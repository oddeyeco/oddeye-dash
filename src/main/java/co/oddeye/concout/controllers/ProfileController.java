/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseErrorsDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.validator.LevelsValidator;
import co.oddeye.concout.validator.UserValidator;
import co.oddeye.core.MetriccheckRule;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeeyMetricTypesEnum;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import java.util.Map;
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
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.TimeZone;
import javax.servlet.http.HttpServletRequest;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.SeekableView;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.web.bind.annotation.PathVariable;

/**
 *
 * @author vahan
 */
@Controller
public class ProfileController {

    protected static final Logger LOGGER = LoggerFactory.getLogger(dataControlers.class);
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
    @Autowired
    MessageSource messageSource;

    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;

    @RequestMapping(value = {"/profile/page/{page}", "/profile"}, method = RequestMethod.GET)
    public String profile(@PathVariable(value = "page" , required = false) Integer page,ModelMap map) throws Exception {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();

//            userDetails.updateConsumption();
            map.put("curentuser", userDetails);
            map.put("activeuser", userDetails);
            if (page==null)
            {
                page = 1;
            }
            map.put("page", page);

            if ((userDetails.getSwitchUser() != null)) {
                if (userDetails.getSwitchUser().getAlowswitch()) {
                    map.put("activeuser", userDetails.getSwitchUser());
                }
            }
            map.put("title", messageSource.getMessage("title.myAccount",new String[]{""},LocaleContextHolder.getLocale()));

        } else {
            layaut = "indexPrime";
        }
        map.put("htitle", messageSource.getMessage("htitle.accountDetail.h1",new String[]{""},LocaleContextHolder.getLocale()));
//      map.put("htitle", "Account Detail");
        map.put("body", "profile");
        map.put("jspart", "profilejs");

        return layaut;
    }

    @RequestMapping(value = {"/metriq/{hash}/{timestamp}", "/metriq/{hash}"}, method = RequestMethod.GET)
    public String metricinfo(@PathVariable(value = "hash") Integer hash, @PathVariable(value = "timestamp", required = false) Long timestamp, HttpServletRequest request, ModelMap map) throws Exception {

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
                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(hash);
                if (meta == null) {
                    map.put("body", "errors/usererror");
                    map.put("jspart", "errorjs");
                    map.put("message", "Metric not exist");
                    return "index";
                }
                
                if (meta.isSpecial())
                {
                    return "redirect:/history/"+meta.hashCode();
                }
                
                GetRequest getMetric = new GetRequest(MetaDao.getTablename().getBytes(), meta.getKey(), "d".getBytes());
                ArrayList<KeyValue> row = BaseTsdb.getClient().get(getMetric).joinUninterruptibly();
                meta = new OddeeyMetricMeta(row, BaseTsdb.getTsdb(), false);

                map.put("metric", meta);
                map.put("title", meta.getDisplayName());
                Calendar CalendarObj = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
                if (timestamp != null) {
                    CalendarObj.setTimeInMillis(timestamp * 1000);
                }

                CalendarObj.set(Calendar.MILLISECOND, 0);
                CalendarObj.set(Calendar.SECOND, 0);
                CalendarObj.set(Calendar.MINUTE, 0);
                map.put("Date", CalendarObj.getTime());

//                String hour = request.getParameter("hour");
//                if (hour != null) {
//                    CalendarObj.set(Calendar.HOUR_OF_DAY, Integer.parseInt(hour));
//                }
                ArrayList<DataPoints[]> data;
                if (timestamp != null) {
                    String startdate = Long.toString(CalendarObj.getTimeInMillis());
                    CalendarObj.add(Calendar.HOUR, 1);
                    CalendarObj.add(Calendar.SECOND, -4);
                    String enddate = Long.toString(CalendarObj.getTimeInMillis());

                    data = DataDao.getDatabyQuery(userDetails, meta.getName(), "none", meta.getFullFilter(), startdate, enddate, "", false);
                } else {
                    data = DataDao.getDatabyQuery(userDetails, meta.getName(), "none", meta.getFullFilter(), "1h-ago", "now", "", false);
                }

                CalendarObj.add(Calendar.DATE, -1);

                Map<String, MetriccheckRule> rules = meta.getRules(CalendarObj, 7, MetaDao.getTablename().getBytes(), BaseTsdb.getClient());
                map.put("Rules", rules);

                JsonArray DatapointsJSON = new JsonArray();
                JsonArray PredictJSON = new JsonArray();
                String s_formatter;
                
                switch (meta.getType()) {
                    case PERCENT: {
                        s_formatter = "{value} %";
                        break;
                    }
                    default:
                        s_formatter = "format_metric";
                        break;
                }
                for (DataPoints[] Datapointslist : data) {
                    for (DataPoints Datapoints : Datapointslist) {
                        final SeekableView Datalist = Datapoints.iterator();
                        while (Datalist.hasNext()) {
                            final DataPoint Point = Datalist.next();
                            JsonArray j_point = new JsonArray();
                            JsonObject j_data = new JsonObject();
                            j_point.add(Point.timestamp());
                            j_point.add(Point.doubleValue());
                            j_data.add("value", j_point);
                            //TODO check host type
                            j_data.addProperty("unit", s_formatter);
                            DatapointsJSON.add(j_data);

                            JsonArray p_point = new JsonArray();
                            JsonObject p_data = new JsonObject();
                            p_point.add(Point.timestamp());
                            p_point.add(meta.getRegression().predict(Point.timestamp() / 1000));
                            p_data.add("value", p_point);
                            //TODO check host type
                            p_data.addProperty("unit", s_formatter);

                            PredictJSON.add(p_data);
                        }
                    }
                }
                map.put("data", DatapointsJSON);
                map.put("p_data", PredictJSON);
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        }
        map.put("body", "metriqinfo");
        map.put("jspart", "metriqinfojs");

        return "index";

//        return layaut;
    }

    @RequestMapping(value = "/profile/edit", method = RequestMethod.GET)
    public String profileedit(ModelMap map
    ) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("activeuser", userDetails);

            map.put("newuserleveldata", userDetails);
            map.put("newuserdata", userDetails);

            if ((userDetails.getSwitchUser() != null)) {
                if (userDetails.getSwitchUser().getAlowswitch()) {
                    map.put("activeuser", userDetails.getSwitchUser());
                    map.put("newuserleveldata", userDetails.getSwitchUser());
                    map.put("newuserdata", userDetails.getSwitchUser());
                }
            }
            map.put("title", messageSource.getMessage("title.changeProfile",new String[]{""},LocaleContextHolder.getLocale()));
 //         map.put("title", "Change Profile");
            DefaultController.setLocaleInfo(map);

        } else {
            layaut = "indexPrime";
        }
        map.put("htitle", messageSource.getMessage("htitle.accountControl.h1",new String[]{""},LocaleContextHolder.getLocale()));
//      map.put("htitle", "Account control");
        map.put("body", "profileedit");
        map.put("jspart", "profileeditjs");
        map.put("tab", "general-tab");

        return layaut;
    }

    @RequestMapping(value = "/profile/saveuser", method = RequestMethod.GET)
    public String createuserGet(@ModelAttribute("curentuser") OddeyeUserModel newcurentuser, BindingResult result,
            ModelMap map
    ) {
        return "redirect:/profile/edit";
    }

    @RequestMapping(value = "/profile/changepassword", method = RequestMethod.POST)
    public String updatepass(@ModelAttribute("newuserdata") OddeyeUserModel newuserdata, BindingResult result,
            ModelMap map
    ) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel currentUser = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            if ((currentUser.getSwitchUser() != null)) {
                if (currentUser.getSwitchUser().getAlowswitch()) {
                    currentUser = currentUser.getSwitchUser();

                }
            }
            userValidator.passwordvalidate(newuserdata, currentUser, result);

            DefaultController.setLocaleInfo(map);
            map.put("htitle", messageSource.getMessage("htitle.accountControl.h1",new String[]{""},LocaleContextHolder.getLocale()));
            map.put("title", messageSource.getMessage("title.password",new String[]{""},LocaleContextHolder.getLocale()));
//          map.put("title", "Password");
            if (result.hasErrors()) {
                map.put("result", result);
            } else {
                try {
                    final Map<String, Object> EditConfig = new LinkedHashMap<>();
                    EditConfig.put("password", new HashMap<String, Object>() {
                        {
                            put("title", messageSource.getMessage("title.password",new String[]{""},LocaleContextHolder.getLocale()));
//                          put("title", "Password");
                            put("path", "password");                            
                            put("retitle", messageSource.getMessage("retitle.reEnterPassword",new String[]{""},LocaleContextHolder.getLocale()));
                            put("type", "password");
                        }
                    });

                    Userdao.saveAll(currentUser, newuserdata, EditConfig);
                    return "redirect:/profile/edit";
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }

            }
            map.put("newuserdata", newuserdata);
            map.put("curentuser", currentUser);
            map.put("activeuser", currentUser);
            map.put("body", "profileedit");
            map.put("jspart", "profileeditjs");
            map.put("tab", "pass-tab");

            return "index";

        }
        return "indexPrime";
        //else
    }

    @RequestMapping(value = "/profile/saveuser", method = RequestMethod.POST)
    public String updateuser(@ModelAttribute("newuserdata") OddeyeUserModel newuserdata, BindingResult result,
            ModelMap map
    ) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel currentUser = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            if ((currentUser.getSwitchUser() != null)) {
                if (currentUser.getSwitchUser().getAlowswitch()) {
                    currentUser = currentUser.getSwitchUser();
                }
            }
            userValidator.updatevalidate(newuserdata, result);

            DefaultController.setLocaleInfo(map);

            DefaultController.setLocaleInfo(map);
            if (result.hasErrors()) {
                map.put("result", result);
            } else {
                try {
                    Map<String, Object> changedata = currentUser.updateBaseData(newuserdata);
                    Userdao.saveUserPersonalinfo(currentUser, changedata);
                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", currentUser.getId().toString());
                    Jsonchangedata.addProperty("action", "updateuser");
                    InetAddress ia = InetAddress.getLocalHost();
                    String node = ia.getHostName();
                    Jsonchangedata.addProperty("node", node);
                    Gson gson = new Gson();
                    Jsonchangedata.addProperty("changedata", gson.toJson(changedata));
                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            LOGGER.info("kafka semaphore saveuser send messge onSuccess");
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            LOGGER.error("kafka semaphore saveuser send messge onFailure " + ex.getMessage());
                        }
                    });
                    return "redirect:/profile/edit";
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }

            }
            map.put("newuserdata", newuserdata);
            map.put("newuserleveldata", currentUser);
            map.put("curentuser", currentUser);
            map.put("body", "profileedit");
            map.put("jspart", "profileeditjs");
            map.put("tab", "general-tab");

            return "index";

        }
        return "indexPrime";
        //else
    }

    @RequestMapping(value = "/profile/saveuserlevels", method = RequestMethod.POST)
    public String updatelevels(@ModelAttribute("newuserleveldata") OddeyeUserModel newuserdata, BindingResult result,
            ModelMap map
    ) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel currentUser = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            if ((currentUser.getSwitchUser() != null)) {
                if (currentUser.getSwitchUser().getAlowswitch()) {
                    currentUser = currentUser.getSwitchUser();
                }
            }
            levelsValidator.validate(newuserdata, result);

            DefaultController.setLocaleInfo(map);

            DefaultController.setLocaleInfo(map);
            if (result.hasErrors()) {
                map.put("result", result);
            } else {
                try {

                    currentUser.setAlertLevels(newuserdata.getAlertLevels());
//                    Map<String, Object> changedata = currentUser.getAlertLevels().updateBaseData(newuserdata);
                    Gson gson = new Gson();
                    String levelsJSON = gson.toJson(currentUser.getAlertLevels());
                    Userdao.saveAlertLevels(currentUser, levelsJSON);
                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", currentUser.getId().toString());
                    Jsonchangedata.addProperty("action", "updatelevels");
                    InetAddress ia = InetAddress.getLocalHost();
                    String node = ia.getHostName();
                    Jsonchangedata.addProperty("node", node);
                    Jsonchangedata.addProperty("changedata", levelsJSON);
                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send("semaphore", Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            LOGGER.info("kafka semaphore saveuserlevels send messge onSuccess");
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            LOGGER.error("kafka semaphore saveuserlevels send messge onFailure " + ex.getMessage());
                        }
                    });

                    return "redirect:/profile/edit";
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }

            }
            map.put("activeuser", currentUser);
            map.put("newuserdata", currentUser);
            map.put("newuserleveldata", newuserdata);
            map.put("curentuser", currentUser);
            map.put("body", "profileedit");
            map.put("jspart", "profileeditjs");
            map.put("tab", "level-tab");

            return "index";

        }
        return "indexPrime";
        //else
    }
}
