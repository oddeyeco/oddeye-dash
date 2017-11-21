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
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.ErrorState;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonElement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
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
    HbaseErrorHistoryDao ErrorHistoryDao;
    @Autowired
    private BaseTsdbConnect BaseTsdb;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(dataControlers.class);
    
    @RequestMapping(value = "/metriclist", params = {"tags",}, method = RequestMethod.GET)
    public String tagMetricsList(@RequestParam(value = "tags") String tags, ModelMap map) {
        map.put("body", "taglist");
        map.put("jspart", "taglistjs");
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            
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
                OddeyeUserModel currentUser = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                
                map.put("curentuser", currentUser);
                
                OddeyeUserModel userDetails = currentUser;
                if ((currentUser.getSwitchUser() != null)) {
                    if (currentUser.getSwitchUser().getAlowswitch()) {
                        userDetails = currentUser.getSwitchUser();
                    }
                }
                
                map.put("activeuser", userDetails);
//                if (userDetails.getMetricsMeta() == null) {
//                    try {
//                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
//                    } catch (Exception ex) {
//                        LOGGER.error(globalFunctions.stackTrace(ex));
//                    }
//                }
                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(metricshash);
                
                GetRequest getMetric = new GetRequest(MetaDao.getTablename().getBytes(), meta.getKey(), "d".getBytes());
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
        return singlehistory(metricshash, System.currentTimeMillis(), map);
    }
    
    @RequestMapping(value = "/history/{metricshash}/{date}", method = RequestMethod.GET)
    public String singlehistory(@PathVariable(value = "metricshash") Integer metricshash, @PathVariable(value = "date") Long date, ModelMap map) {
        map.put("body", "singlehistory");
        map.put("jspart", "singlehistoryjs");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel currentUser = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", currentUser);
                
                OddeyeUserModel userDetails = currentUser;
                if ((currentUser.getSwitchUser() != null)) {
                    if (currentUser.getSwitchUser().getAlowswitch()) {
                        userDetails = currentUser.getSwitchUser();
                    }
                }
                
                map.put("activeuser", userDetails);
//                if (userDetails.getMetricsMeta() == null) {
//                    try {
//                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
//                    } catch (Exception ex) {
//                        LOGGER.error(globalFunctions.stackTrace(ex));
//                    }
//                }
                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(metricshash);
                
                GetRequest getMetric = new GetRequest(MetaDao.getTablename().getBytes(), meta.getKey(), "d".getBytes());
                ArrayList<KeyValue> row = BaseTsdb.getClient().get(getMetric).joinUninterruptibly();
                meta = new OddeeyMetricMeta(row, BaseTsdb.getTsdb(), false);
                
                byte[] historykey = ArrayUtils.addAll(meta.getUUIDKey(), meta.getKey());
                historykey = ArrayUtils.addAll(historykey, globalFunctions.getDayKey(date));
                String ss = Hex.encodeHexString(historykey);
                
                getMetric = new GetRequest(ErrorHistoryDao.getTablename().getBytes(), historykey, "h".getBytes());
                row = BaseTsdb.getClient().get(getMetric).joinUninterruptibly();
                
                List<ErrorState> list = new ArrayList<>(row.size());
                int lastlevel = -255;
                for (KeyValue KV : row) {
                    ErrorState lasterror = null;
                    try {
                        JsonElement json = globalFunctions.getJsonParser().parse((new String(KV.value())));
                        lasterror = new ErrorState(json.getAsJsonObject());
                    } catch (Exception e) {
                        LOGGER.error(globalFunctions.stackTrace(e));
                    }
                    
                    if (lasterror == null) {
                        continue;
                    }
                    if (lastlevel != lasterror.getLevel()) {
                        list.add(lasterror);
                    }
                    
                    lastlevel = lasterror.getLevel();
                }
                class RecipeCompare implements Comparator<ErrorState> {
                    
                    @Override
                    public int compare(ErrorState o1, ErrorState o2) {
                        // write comparison logic here like below , it's just a sample
                        return o1.getTime() < o2.getTime() ? 1 : -1;
                    }
                }
                
                Collections.sort(list, new RecipeCompare());
                //reverse(list);
                map.put("date", new Date(date));
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
                OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", userDetails);
//                if (userDetails.getMetricsMeta() == null) {
//                    try {
//                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
//                    } catch (Exception ex) {
//                        LOGGER.error(globalFunctions.stackTrace(ex));
//                    }
//                }
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
