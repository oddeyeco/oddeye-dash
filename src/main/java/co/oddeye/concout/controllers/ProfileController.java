/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import static co.oddeye.concout.controllers.dataControlers.LOGGER;
import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseErrorsDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.concout.validator.LevelsValidator;
import co.oddeye.concout.validator.UserValidator;
import co.oddeye.core.MetriccheckRule;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.google.gson.JsonObject;
import java.util.ArrayList;
import java.util.Calendar;
import javax.servlet.http.HttpServletRequest;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.SeekableView;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.springframework.web.bind.annotation.PathVariable;

/**
 *
 * @author vahan
 */
@Controller
public class ProfileController {

    @Autowired
    private UserValidator userValidator;
    @Autowired
    private LevelsValidator levelsValidator;
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    HbaseErrorsDao ErrorsDao;
    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Autowired
    private BaseTsdbConnect BaseTsdb;
    @Autowired
    HbaseDataDao DataDao;

    @RequestMapping(value = "/profile", method = RequestMethod.GET)
    public String profile(ModelMap map) throws Exception {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
//            if (userDetails.getMetricsMeta() == null) {
//            userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
//            }
            map.put("curentuser", userDetails);
            map.put("title", "MyProfile");

        } else {
            layaut = "indexPrime";
        }

        map.put("body", "profile");
        map.put("jspart", "profilejs");

        return layaut;
    }

    @RequestMapping(value = "/metriq/{hash}", method = RequestMethod.GET)
    public String metricinfo(@PathVariable(value = "hash") Integer hash, HttpServletRequest request, ModelMap map) throws Exception {

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
                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(hash);

                GetRequest getMetric = new GetRequest(HbaseMetaDao.TBLENAME.getBytes(), meta.getKey(), "d".getBytes());
                ArrayList<KeyValue> row = BaseTsdb.getClient().get(getMetric).joinUninterruptibly();
                meta = new OddeeyMetricMeta(row, BaseTsdb.getTsdb(), false);

                map.put("metric", meta);
                map.put("title", meta.getDisplayName());

                Calendar CalendarObj = Calendar.getInstance();
//                CalendarObj.setTimeInMillis(time * 1000);
                String hour = request.getParameter("hour");
                if (hour != null) {
                    CalendarObj.set(Calendar.HOUR_OF_DAY, Integer.parseInt(hour));
                }

                CalendarObj.add(Calendar.DATE, -1);

                Map<String, MetriccheckRule> rules = meta.getRules(CalendarObj, 7, HbaseMetaDao.TBLENAME.getBytes(), BaseTsdb.getClient());
                map.put("Rules", rules);
                ArrayList<DataPoints[]> data = DataDao.getDatabyQuery(userDetails, meta.getName(), "none", meta.getFullFilter(), "1h-ago", "now", "", false);
                
                JsonArray DatapointsJSON = new JsonArray();
                for (DataPoints[] Datapointslist : data) {
                    for (DataPoints Datapoints : Datapointslist) {
                        final SeekableView Datalist = Datapoints.iterator();
                        while (Datalist.hasNext()) {
                            final DataPoint Point = Datalist.next();
                            JsonArray j_point = new JsonArray();
                            j_point.add(Point.timestamp());
                            j_point.add(Point.doubleValue());
                            DatapointsJSON.add(j_point);
                        }                        
                    }
                }
                map.put("data", DatapointsJSON);
            } catch (Exception ex) {
                Logger.getLogger(dataControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        map.put("body", "metriqinfo");
        map.put("jspart", "metriqinfojs");

        return "index";

//        return layaut;
    }

    @RequestMapping(value = "/profile/edit", method = RequestMethod.GET)
    public String profileedit(ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("newuserleveldata", userDetails);
            map.put("newuserdata", userDetails);
            map.put("title", "Edit Profile");
            DefaultController.setLocaleInfo(map);

        } else {
            layaut = "indexPrime";
        }

        map.put("body", "profileedit");
        map.put("jspart", "profileeditjs");

        return layaut;
    }

    @RequestMapping(value = "/profile/saveuser", method = RequestMethod.GET)
    public String createuserGet(@ModelAttribute("curentuser") User newcurentuser, BindingResult result, ModelMap map) {
        return "redirect:/profile/edit";
    }

    @RequestMapping(value = "/profile/saveuser", method = RequestMethod.POST)
    public String updateuser(@ModelAttribute("newuserdata") User newuserdata, BindingResult result, ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User curentuser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            userValidator.updatevalidate(newuserdata, result);

            DefaultController.setLocaleInfo(map);

            DefaultController.setLocaleInfo(map);
            if (result.hasErrors()) {
                map.put("result", result);
            } else {
                try {
                    Map<String, Object> changedata = curentuser.updateBaseData(newuserdata);
                    Userdao.saveUserPersonalinfo(curentuser, changedata);
                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", curentuser.getId().toString());
                    Jsonchangedata.addProperty("action", "updateuser");
                    Gson gson = new Gson();
                    Jsonchangedata.addProperty("changedata", gson.toJson(changedata));
                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send("semaphore", Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            Logger.getLogger(DefaultController.class.getName()).log(Level.SEVERE, "onSuccess");
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            Logger.getLogger(DefaultController.class.getName()).log(Level.SEVERE, "onFailure", ex);
                        }
                    });

                    return "redirect:/profile/edit";
                } catch (Exception ex) {
                    Logger.getLogger(ProfileController.class.getName()).log(Level.SEVERE, null, ex);
                }

            }
            map.put("newuserdata", newuserdata);
            map.put("newuserleveldata", curentuser);
            map.put("curentuser", curentuser);
            map.put("body", "profileedit");
            map.put("jspart", "profileeditjs");

            return "index";

        }
        return "indexPrime";
        //else
    }

    @RequestMapping(value = "/profile/saveuserlevels", method = RequestMethod.POST)
    public String updatelevels(@ModelAttribute("newuserleveldata") User newuserdata, BindingResult result, ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User curentuser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            levelsValidator.validate(newuserdata, result);

            DefaultController.setLocaleInfo(map);

            DefaultController.setLocaleInfo(map);
            if (result.hasErrors()) {
                map.put("result", result);
            } else {
                try {

                    curentuser.setAlertLevels(newuserdata.getAlertLevels());
//                    Map<String, Object> changedata = curentuser.getAlertLevels().updateBaseData(newuserdata);
                    Gson gson = new Gson();
                    String levelsJSON = gson.toJson(curentuser.getAlertLevels());
                    Userdao.saveAlertLevels(curentuser, levelsJSON);
                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", curentuser.getId().toString());
                    Jsonchangedata.addProperty("action", "updatelevels");

                    Jsonchangedata.addProperty("changedata", levelsJSON);
                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send("semaphore", Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            Logger.getLogger(DefaultController.class.getName()).log(Level.SEVERE, "onSuccess");
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            Logger.getLogger(DefaultController.class.getName()).log(Level.SEVERE, "onFailure", ex);
                        }
                    });

                    return "redirect:/profile/edit";
                } catch (Exception ex) {
                    Logger.getLogger(ProfileController.class.getName()).log(Level.SEVERE, null, ex);
                }

            }
            map.put("newuserdata", curentuser);
            map.put("newuserleveldata", newuserdata);
            map.put("curentuser", curentuser);
            map.put("body", "profileedit");
            map.put("jspart", "profileeditjs");

            return "index";

        }
        return "indexPrime";
        //else
    }
}
