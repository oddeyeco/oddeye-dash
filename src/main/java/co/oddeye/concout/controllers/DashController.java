/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.core.TemplateType;
import co.oddeye.concout.dao.HbaseDushboardTemplateDAO;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.exception.ResourceNotFoundException;
import co.oddeye.concout.model.DashboardTemplate;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.service.OddeyeUserService;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.support.SendResult;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author vahan
 */
@Controller
public class DashController {

    protected static final Logger LOGGER = LoggerFactory.getLogger(DashController.class);

    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Autowired
    private HbaseUserDao Userdao;
    
    @Autowired
    private OddeyeUserService UserService;
    
    @Autowired
    private HbaseDushboardTemplateDAO TemplateDAO;
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    MessageSource messageSource;

    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;
    @Value("${paypal.url}")
    private String paypal_url;
    @Value("${paypal.email}")
    private String paypal_email;
    @Value("${paypal.returnurl}")
    private String paypal_returnurl;
    @Value("${paypal.notifyurl}")
    private String paypal_notifyurl;

    @Value("${paypal.percent}")
    private String paypal_percent;
    @Value("${paypal.fix}")
    private String paypal_fix;

    @RequestMapping(value = {"/infrastructure/","/infrastructure/{version}/"}, method = RequestMethod.GET)
    public String infrastructure(ModelMap map,@PathVariable(required = false) String version) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        OddeyeUserModel user;
        if (auth != null
                && auth.isAuthenticated()
                && //when Anonymous Authentication is enabled
                !(auth instanceof AnonymousAuthenticationToken)) {
            user = ((OddeyeUserDetails) auth.getPrincipal()).getUserModel();
            map.put("curentuser", user);

            LinkedHashMap<String, Boolean> taglist = new LinkedHashMap<>();
            JsonObject filter = null;
            try {
                if (user.getFiltertemplateList().containsKey("oddeye_base_infrastructure")) {
                    filter = (JsonObject) globalFunctions.getJsonParser().parse(user.getFiltertemplateList().get("oddeye_base_infrastructure"));
                }
            } catch (JsonSyntaxException e) {
                LOGGER.warn("Wrong folter JSON");
            }

            map.put("filter", filter);
            ArrayList<String> taglistprioryty = new ArrayList<>();
            if (filter == null) {
                taglistprioryty.add("cluster");
                taglistprioryty.add("group");
                taglistprioryty.add("location");
                taglistprioryty.add("host");
            } else {
                if (filter.has("metric_input")) {
                    map.put("metric_input", filter.get("metric_input").getAsString());
                } else {
                    map.put("metric_input", "");
                }

                for (Map.Entry<String, JsonElement> f_item : filter.entrySet()) {
                    if (user.getMetricsMeta().getTagsList().containsKey(f_item.getValue().getAsString())) {
                        taglistprioryty.add(f_item.getValue().getAsString());
                    }
                }
            }

            for (String tg : taglistprioryty) {
                if (user.getMetricsMeta().getTagsList().containsKey(tg)) {
                    taglist.put(tg, true);
                }
            }

            user.getMetricsMeta().getTagsList().entrySet().stream().filter((tag) -> (!taglist.containsKey(tag.getKey()))).forEachOrdered((tag) -> {
                taglist.put(tag.getKey(), false);
            });
            map.put("taglist", taglist);
        }
        map.put("htitle", messageSource.getMessage("htitle.infrastructure.h1", new String[]{""}, LocaleContextHolder.getLocale()));
        map.put("body", "infrastructure");
        if (version!=null)
        {
            map.put("jspart", "infrastructurejs"+version);
        }
        else
        {
            map.put("jspart", "infrastructurejs");
        }
        
        map.put("title", messageSource.getMessage("title.infrastructure", new String[]{""}, LocaleContextHolder.getLocale()));
        return "index";
    }

    @RequestMapping(value = {"/dashboard/"}, method = RequestMethod.GET)
    public String getDashboards(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel(true);
            UserService.updateConsumption2m(userDetails);
            UserService.updatePayments(userDetails,10);
            map.put("curentuser", userDetails);

            map.put("activeuser", userDetails);

            map.put("title", messageSource.getMessage("title.dashboards", new String[]{""}, LocaleContextHolder.getLocale()));
//            map.put("title", "My Dashboards");
//            map.put("lasttemplates", TemplateDAO.getLasttemplates(userDetails, 50));

            map.put("recomend", TemplateDAO.getRecomendTemplates(userDetails, 50));
            map.put("mylasttemplates", TemplateDAO.getLastUsertemplates(userDetails, 50));

            map.put("paypal_percent", paypal_percent);
            map.put("paypal_fix", paypal_fix);

//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    map.put("activeuser", userDetails.getSwitchUser());
//                    map.put("lasttemplates", TemplateDAO.getLasttemplates(userDetails.getSwitchUser(), 50));
//                    map.put("recomend", TemplateDAO.getRecomendTemplates(userDetails.getSwitchUser(), 50));
//                    map.put("mylasttemplates", TemplateDAO.getLastUsertemplates(userDetails.getSwitchUser(), 50));
//
//                }
//            }
        }
        map.put("paypal_url", paypal_url);
        map.put("paypal_email", paypal_email);
        map.put("paypal_returnurl", paypal_returnurl);
        map.put("paypal_notifyurl", paypal_notifyurl);
        map.put("htitle", messageSource.getMessage("htitle.dashboards.h1", new String[]{""}, LocaleContextHolder.getLocale()));
//      map.put("htitle", "Dashboards");
        map.put("body", "dashboards");
        map.put("jspart", "dashboardsjs");
        return "index";
    }

    @RequestMapping(value = {"/template/{dashkey}"}, method = RequestMethod.GET)
    public String ShowDashTemplate(@PathVariable(value = "dashkey") String dashkey, ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", userDetails);
                map.put("dashname", "Dashboard" + (userDetails.getDushList().size() + 1));
                DashboardTemplate Dash = TemplateDAO.getbyKey(Hex.decodeHex(dashkey.toCharArray()));
                map.put("title", Dash.getName());
                if (Dash.getInfojson() != null) {
                    map.put("dashInfo", Dash.getInfojson().toString());
                } else {
                    map.put("dashInfo", "{rows:[]}");
                }

                map.put("body", "dashboard");
                map.put("jspart", "dashboardjs");

//            DashboardTemplate template = new DashboardTemplate(dashname,userDetails.getDush(dashname), userDetails, TemplateType.Dushboard);
//            TemplateDAO.add(template);
                return "index";
            } catch (DecoderException ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        }
        return "index";
    }

    @RequestMapping(value = {"/dashboard/new"}, method = RequestMethod.GET)
    public String NewDash(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();

            map.put("curentuser", userDetails);
//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            map.put("activeuser", userDetails);
            map.put("dashname", "Dashboard" + (userDetails.getDushList().size() + 1));
            map.put("htitle", "Dashboard" + (userDetails.getDushList().size() + 1));
            map.put("title", messageSource.getMessage("title.newDashboard", new String[]{""}, LocaleContextHolder.getLocale()));
//          map.put("title", "New Dashboard");  
        }

        map.put("body", "dashboard");
        map.put("jspart", "dashboardjs");
        map.put("dashInfo", "{rows:[]}");

        return "index";
    }

    @ExceptionHandler(ResourceNotFoundException.class)
//	public String handleEmployeeNotFoundException(ModelMap map, HttpServletRequest request, HttpServletResponse response,Exception ex)
    public ModelAndView handleDushNotFoundException(HttpServletRequest request, Exception ex) {

        OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                getAuthentication().getPrincipal()).getUserModel();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("curentuser", userDetails);

        modelAndView.addObject("exception", ex);
        modelAndView.addObject("url", request.getRequestURL());
        modelAndView.addObject("body", "errors/404error");
        modelAndView.addObject("jspart", "errors/errorjs");
        modelAndView.setViewName("index");
        return modelAndView;
    }

    @RequestMapping(value = {"/dashboard/{dashname:.+}"}, method = RequestMethod.GET)
    public String ShowDash(@PathVariable(value = "dashname") String dashname, ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();

            map.put("curentuser", userDetails);

//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            map.put("activeuser", userDetails);
            map.put("dashname", dashname);
            map.put("htitle", dashname);
            map.put("title", dashname);
            map.put("dashInfo", userDetails.getDush(dashname));
            map.put("body", "dashboard");
            map.put("jspart", "dashboardjs");

            if (userDetails.getDush(dashname) == null) {
                try {
                    TimeUnit.SECONDS.sleep(2);
                    if (userDetails.getDush(dashname) == null) {
                        throw new ResourceNotFoundException(dashname + " not exists");
                    }
                } catch (InterruptedException ex) {
                    LOGGER.error("lalaal");
                }
            }

            return "index";
        }
        return "index";
    }

    @RequestMapping(value = {"/dashboard/save"}, produces = AjaxControlers.JSON_UTF8)
    public @ResponseBody String SaveDash(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();

//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            String DushName = request.getParameter("name").trim().replaceAll(" +", " ");
            String DushInfo = request.getParameter("info").trim();
            String oldname = request.getParameter("oldname");
            String unloadRef = request.getParameter("unloadRef");
            if (DushName != null) {
                try {
                    userDetails.addDush(DushName, DushInfo, Userdao);
                    if (oldname != null) {
                        oldname = oldname.trim();
                        userDetails.removeDush(oldname, Userdao);
                    }
                    String node;
                    InetAddress ia;

                    ia = InetAddress.getLocalHost();
                    node = ia.getHostName();

                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
                    Jsonchangedata.addProperty("action", "editdash");
                    Jsonchangedata.addProperty("node", node);
                    Jsonchangedata.addProperty("name", DushName);
                    Jsonchangedata.addProperty("oldname", oldname);
                    Jsonchangedata.addProperty("unloadRef", unloadRef);

                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            LOGGER.info("kafka semaphore editdash send messge onSuccess");
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            LOGGER.error("kafka semaphore editdash send messge onFailure " + ex.getMessage());
                        }
                    });

                    jsonResult.addProperty("sucsses", true);
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                    jsonResult.addProperty("sucsses", false);
                }
            } else {
                jsonResult.addProperty("sucsses", false);
            }
        }

        return jsonResult.toString();
    }

    @RequestMapping(value = {"/dashboard/savetemplate"}, produces = AjaxControlers.JSON_UTF8)
    public @ResponseBody String SaveDashTeplate(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();

//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            String DushName = request.getParameter("name").trim();
            String DushInfo = request.getParameter("info").trim();
            if (DushName != null) {
//                userDetails.addDush(DushName, DushInfo, Userdao);
                DashboardTemplate template = new DashboardTemplate(DushName, DushInfo, userDetails, TemplateType.Dushboard);
                TemplateDAO.add(template);
                jsonResult.addProperty("sucsses", true);
            } else {
                jsonResult.addProperty("sucsses", false);
            }
        }

        return jsonResult.toString();
    }

    @RequestMapping(value = {"/dashboard/delete"}, produces = AjaxControlers.JSON_UTF8)
    public @ResponseBody String DeleteDash(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();

//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            String DushName = request.getParameter("name").trim();
            if (DushName != null) {
                try {
                    userDetails.removeDush(DushName, Userdao);

                    String node = "";
                    InetAddress ia;
                    try {
                        ia = InetAddress.getLocalHost();
                        node = ia.getHostName();
                    } catch (UnknownHostException ex) {
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }

                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
                    Jsonchangedata.addProperty("action", "deletedash");
                    Jsonchangedata.addProperty("node", node);
                    Jsonchangedata.addProperty("name", DushName);
                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            LOGGER.info("kafka semaphore editdash send messge onSuccess");
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            LOGGER.error("kafka semaphore editdash send messge onFailure " + ex.getMessage());
                        }
                    });

                    jsonResult.addProperty("sucsses", true);
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                    jsonResult.addProperty("sucsses", false);
                }
            } else {
                jsonResult.addProperty("sucsses", false);
            }
        }

        return jsonResult.toString();
    }

    @RequestMapping(value = {"/savefilter", "/savefilter/{filtername}"}, produces = AjaxControlers.JSON_UTF8)
    public @ResponseBody String savemonitoringsetings(@PathVariable(value = "filtername", required = false) String filtername, HttpServletRequest request) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        OddeyeUserModel userDetails;
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            if (filtername == null) {
                filtername = "oddeye_base_def";
            }

            String filterinfo = request.getParameter("filter");
            userDetails.addFiltertemplate(filtername, filterinfo, Userdao);

            JsonObject Jsonchangedata = new JsonObject();
            Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
            Jsonchangedata.addProperty("action", "changefilter");
            Jsonchangedata.addProperty("filter", filterinfo);
            Jsonchangedata.addProperty("filtername", filtername);

            // Send chenges to kafka
            ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
            messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                @Override
                public void onSuccess(SendResult<Integer, String> result) {
                    if (LOGGER.isInfoEnabled()) {
                        LOGGER.info("Kafka savemonitoringsetings onSuccess");
                    }
                }

                @Override
                public void onFailure(Throwable ex) {
                    LOGGER.error("Kafka savemonitoringsetings onFailure:" + ex);
                }
            });

            jsonResult.addProperty("sucsses", true);

        } else {
            jsonResult.addProperty("sucsses", false);
        }

        return jsonResult.toString();
    }

    @RequestMapping(value = {"/addmonitoringpage/"}, produces = AjaxControlers.JSON_UTF8)
    public @ResponseBody String savemonitoringOptions(HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        OddeyeUserModel userDetails;
        JsonObject jsonResult = new JsonObject();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            String optionsname = request.getParameter("optionsname");
            if (optionsname == null) {
                optionsname = "";
            }

            String optionsinfo = request.getParameter("optionsjson");
            if (!optionsname.isEmpty()) {
                try {
                    userDetails.addOptions(optionsname, optionsinfo, Userdao);

                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
                    Jsonchangedata.addProperty("action", "changeoptions");
                    Jsonchangedata.addProperty("options", optionsinfo);
                    Jsonchangedata.addProperty("optionsname", optionsname);

                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            if (LOGGER.isInfoEnabled()) {
                                LOGGER.info("Kafka savemonitoringsetings onSuccess");
                            }
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            LOGGER.error("Kafka savemonitoringsetings onFailure:" + ex);
                        }
                    });

                    jsonResult.addProperty("sucsses", true);
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        return jsonResult.toString();
    }

    @RequestMapping(value = {"/deletemonitoringpage/"}, produces = AjaxControlers.JSON_UTF8)
    public @ResponseBody String deletemonitoringOptions(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        OddeyeUserModel userDetails;
        JsonObject jsonResult = new JsonObject();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
//            if ((userDetails.getSwitchUser() != null)) {
//                if (userDetails.getSwitchUser().getAlowswitch()) {
//                    userDetails = userDetails.getSwitchUser();
//                }
//            }
            String optionsname = request.getParameter("optionsname");

            if (!optionsname.isEmpty()) {
                try {
                    userDetails.removeOptions(optionsname, Userdao);

                    JsonObject Jsonchangedata = new JsonObject();
                    Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
                    Jsonchangedata.addProperty("action", "deleteoptions");
                    Jsonchangedata.addProperty("optionsname", optionsname);

                    // Send chenges to kafka
                    ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
                    messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                        @Override
                        public void onSuccess(SendResult<Integer, String> result) {
                            if (LOGGER.isInfoEnabled()) {
                                LOGGER.info("Kafka savemonitoringsetings onSuccess");
                            }
                        }

                        @Override
                        public void onFailure(Throwable ex) {
                            LOGGER.error("Kafka savemonitoringsetings onFailure:" + ex);
                        }
                    });

                    jsonResult.addProperty("sucsses", true);
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        return jsonResult.toString();
    }
}
