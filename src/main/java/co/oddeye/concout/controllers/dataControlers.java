/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseErrorHistoryDao;
import co.oddeye.concout.model.User;
import co.oddeye.core.ErrorState;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author vahan
 */
@Controller
public class dataControlers {

    @Autowired
    private HbaseDataDao Datadao;
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    private BaseTsdbConnect BaseTsdb;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(dataControlers.class);

    @RequestMapping(value = "/metriclist", params = {"tags",}, method = RequestMethod.GET)
    public String tagMetricsList(@RequestParam(value = "tags") String tags, ModelMap map) {
        map.put("body", "taglist");
        map.put("jspart", "taglistjs");

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("tags", tags);

        }
        return "index";
    }

    @RequestMapping(value = "/chart/{metricshash}", method = RequestMethod.GET)
    public String singlecahrt(@PathVariable(value = "metricshash") Integer metricshash, ModelMap map) {
        map.put("body", "singlecahrt");
        map.put("jspart", "singlecahrtjs");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User cuentuser = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();
                map.put("curentuser", cuentuser);

                User userDetails = cuentuser;
                if ((cuentuser.getSwitchUser() != null)) {
                    if (cuentuser.getSwitchUser().getAlowswitch()) {
                        userDetails = cuentuser.getSwitchUser();
                    }
                }

                map.put("activeuser", userDetails);
                if (userDetails.getMetricsMeta() == null) {
                    try {
                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                    } catch (Exception ex) {
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }
                }
                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(metricshash);

                GetRequest getMetric = new GetRequest(HbaseMetaDao.TBLENAME.getBytes(), meta.getKey(), "d".getBytes());
                ArrayList<KeyValue> row = BaseTsdb.getClient().get(getMetric).joinUninterruptibly();
                meta = new OddeeyMetricMeta(row, BaseTsdb.getTsdb(), false);

                map.put("metric", meta);
                map.put("title", meta.getDisplayName() + "|" + meta.getDisplayTags("|"));
            } catch (Exception ex) {
                Logger.getLogger(dataControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return "index";
    }

    @RequestMapping(value = "/history/{metricshash}", method = RequestMethod.GET)
    public String singlehistory(@PathVariable(value = "metricshash") Integer metricshash, ModelMap map) {
        map.put("body", "singlehistory");
        map.put("jspart", "singlehistoryjs");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User cuentuser = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();
                map.put("curentuser", cuentuser);

                User userDetails = cuentuser;
                if ((cuentuser.getSwitchUser() != null)) {
                    if (cuentuser.getSwitchUser().getAlowswitch()) {
                        userDetails = cuentuser.getSwitchUser();
                    }
                }

                map.put("activeuser", userDetails);
                if (userDetails.getMetricsMeta() == null) {
                    try {
                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                    } catch (Exception ex) {
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }
                }
                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(metricshash);

                byte[] historykey = ArrayUtils.addAll(meta.getUUIDKey(), meta.getKey());
                historykey = ArrayUtils.addAll(historykey, globalFunctions.getDayKey(System.currentTimeMillis()));
                String ss = Hex.encodeHexString(historykey);

                GetRequest getMetric = new GetRequest(HbaseErrorHistoryDao.TBLENAME.getBytes(), historykey, "h".getBytes());
                ArrayList<KeyValue> row = BaseTsdb.getClient().get(getMetric).joinUninterruptibly();
                List<ErrorState> list = new ArrayList<>(row.size());
                int lastlevel = -255;
                for (KeyValue KV : row) {
                    ErrorState lasterror = ErrorState.createSerializedErrorState(KV.value());
                    if (lastlevel != lasterror.getLevel()) {
                        list.add(lasterror);
                    }

                    lastlevel = lasterror.getLevel();
                }
                Collections.reverse(list);
                map.put("list", list);
                map.put("metric", meta);
                map.put("title", meta.getDisplayName() + "|" + meta.getDisplayTags("|"));
            } catch (Exception ex) {
                Logger.getLogger(dataControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return "index";
    }

    @RequestMapping(value = "/chart", method = RequestMethod.GET)
    public String multicahrt(HttpServletRequest request, ModelMap map) {
        map.put("body", "multicahrt");
        map.put("jspart", "multicahrtjs");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User userDetails = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();
                map.put("curentuser", userDetails);
                if (userDetails.getMetricsMeta() == null) {
                    try {
                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                    } catch (Exception ex) {
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }
                }
                String hashes = request.getParameter("hashes");
                String hashesarr = "[" + hashes.replaceAll(";", ",") + "]";
                map.put("hashes", hashesarr);
                map.put("title", "Multi Chart");
            } catch (Exception ex) {
                Logger.getLogger(dataControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return "index";
    }
}
