/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import static co.oddeye.concout.controllers.DefaultController.setLocaleInfo;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.helpers.OddeyeMailSender;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.model.WhitelabelModel;
import co.oddeye.concout.service.OddeyeUserService;
import co.oddeye.concout.validator.UserValidator;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.beans.PropertyEditorSupport;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class AdminUsersControlers extends GRUDControler {

    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    private OddeyeUserService UserService;    
    @Autowired
    private UserValidator userValidator;
    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;

    protected static final Logger LOGGER = LoggerFactory.getLogger(AdminUsersControlers.class);

    public AdminUsersControlers() {
        AddViewConfig("email", new HashMap<String, Object>() {
            {
                put("path", "email");
                put("title", "adminlist.email");
                put("type", "String");
            }
        }).AddViewConfig("name", new HashMap<String, Object>() {
            {
                put("path", "fullname");
                put("title", "adminlist.name");
                put("type", "String");
            }
        }).AddViewConfig("balance", new HashMap<String, Object>() {
            {
                put("path", "balance");
                put("title", "adminlist.balance");
                put("type", "Double");
            }
        }).AddViewConfig("Company", new HashMap<String, Object>() {
            {
                put("path", "company");
                put("title", "adminlist.company");
                put("type", "String");
            }
        }).AddViewConfig("Country", new HashMap<String, Object>() {
            {
                put("path", "country");
                put("title", "adminlist.country");
                put("type", "String");
            }
        }).AddViewConfig("Sinedate", new HashMap<String, Object>() {
            {
                put("path", "sinedate");
                put("title", "adminlist.signedDate");
                put("type", "Date");
                put("displayclass", "orderdesc");
            }
        }).AddViewConfig("mailconfirm", new HashMap<String, Object>() {
            {
                put("path", "mailconfirm");
                put("title", "adminlist.isMailConfirm");
                put("type", "boolean");
            }
        }).AddViewConfig("active", new HashMap<String, Object>() {
            {
                put("path", "active");
                put("title", "adminlist.isActive");
                put("type", "boolean");
            }
        }).AddViewConfig("referal", new HashMap<String, Object>() {
            {
                put("path", "referal");
                put("title", "adminlist.referal");
                put("type", "Object");
                put("display", "email");
                put("items", null);
            }
        }).AddViewConfig("whitelabel", new HashMap<String, Object>() {
            {
                put("path", "whitelabel");
                put("title", "adminlist.whitelabel");
                put("type", "Object");
                put("display", "url");
                put("items", null);
            }
        })
//                .AddViewConfig("Timezone", new HashMap<String, Object>() {
//            {
//                put("path", "timezone");
//                put("title", " Timezone");
//                put("type", "String");
//            }
//        }).AddViewConfig("Authorities", new HashMap<String, Object>() {
//            {
//                put("path", "authorities");
//                put("title", " Authorities");
//                put("type", "Collection");
//                put("items", OddeyeUserModel.getAllRoles());
//            }
        .AddViewConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "edit");
                put("title", "adminlist.actions");
                put("type", "actions");
            }
        }).AddViewConfig("userswitch", new HashMap<String, Object>() {
            {
                put("path", "alowswitch");
                put("title", "adminlist.switchToUser");
                put("type", "actions");
            }
        }).AddViewConfig("activity", new HashMap<String, Object>() {
            {
                put("title", "adminlist.monitoringConneted");
                put("type", "userstatus");
            }
        });

        Map<String, String> country = new LinkedHashMap<>();
        Map<String, String> timezones = new LinkedHashMap<>();

        country.put("", "");
        timezones.put("", "");
        String[] ids = TimeZone.getAvailableIDs();
        for (String tzone : ids) {
            TimeZone timeZone = TimeZone.getTimeZone(tzone);
            int offset = timeZone.getOffset(System.currentTimeMillis()) / 1000 / 60 / 60;
            String prefix = "UTC+";
            if (offset < 0) {
                prefix = "UTC";
            }
            timezones.put(timeZone.getID(), timeZone.getID() + "(" + prefix + offset + ")");
        }
        String[] locales = Locale.getISOCountries();

        for (String countryCode : locales) {
            Locale obj = new Locale("", countryCode);
            country.put(obj.getCountry(), obj.getDisplayCountry());
        }

        AddEditConfig("email", new HashMap<String, Object>() {
            {
                put("path", "email");
                put("title", "adminlist.email");
                put("type", "String");
                put("required", true);

            }
        }).AddEditConfig("name", new HashMap<String, Object>() {
            {
                put("path", "name");
                put("title", "adminlist.firstName");
                put("type", "String");
            }
        }).AddEditConfig("lastname", new HashMap<String, Object>() {
            {
                put("path", "lastname");
                put("title", "adminlist.lastName");
                put("type", "String");
            }
        }).AddEditConfig("password", new HashMap<String, Object>() {
            {
                put("path", "password");
                put("title", "adminlist.password");
                put("retitle", "adminlist.reEnterPassword");
                put("type", "password");
            }
        }).AddEditConfig("Company", new HashMap<String, Object>() {
            {
                put("path", "company");
                put("title", "adminlist.company");
                put("type", "String");
            }
        }).AddEditConfig("Country", new HashMap<String, Object>() {
            {
                put("path", "country");
                put("title", "adminlist.country");
                put("type", "Select");
                put("items", country);
            }
        }).AddEditConfig("Timezone", new HashMap<String, Object>() {
            {
                put("path", "timezone");
                put("title", "adminlist.timezone");
                put("type", "Select");
                put("items", timezones);
            }
        }).AddEditConfig("referal", new HashMap<String, Object>() {
            {
                put("path", "sreferal");
                put("title", "adminlist.referal");
                put("type", "Select");
                put("items", null);
            }
        }).AddEditConfig("balance", new HashMap<String, Object>() {
            {
                put("path", "balance");
                put("title", "adminlist.balance");
                put("type", "float");
            }
        }).AddEditConfig("unlimit", new HashMap<String, Object>() {
            {
                put("path", "unlimit");
                put("title", "adminlist.isUnlimit");
                put("type", "boolean");
            }
        }).AddEditConfig("alowswitch", new HashMap<String, Object>() {
            {
                put("path", "alowswitch");
                put("title", "adminlist.isAlowswitch");
                put("type", "boolean");
            }
        }).AddEditConfig("Authorities", new HashMap<String, Object>() {
            {
                put("path", "authorities");
                put("title", "adminlist.privilege");
                put("type", "MultiSelect");
                put("items", OddeyeUserModel.getAllRoles());
            }
        }).AddEditConfig("active", new HashMap<String, Object>() {
            {
                put("path", "active");
                put("title", "adminlist.isActive");
                put("type", "boolean");
            }
        }).AddEditConfig("firstlogin", new HashMap<String, Object>() {
            {
                put("path", "firstlogin");
                put("title", "adminlist.firstLogin");
                put("type", "boolean");
            }
        }).AddEditConfig("mailconfirm", new HashMap<String, Object>() {
            {
                put("path", "mailconfirm");
                put("title", "adminlist.isMailConfirm");
                put("type", "boolean");
            }
        }).AddEditConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "actions");
                put("title", "adminlist.actions");
                put("type", "actions");
            }
        });

    }

    @RequestMapping(value = "/userslist", method = RequestMethod.GET)
    public String showlist(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        map.put("modellist", Userdao.getAllUsers(true));
        map.put("configMap", getViewConfig());
        map.put("body", "adminlist");
        map.put("path", "user");
        map.put("jspart", "adminjs");
        return "index";
    }
    @Autowired
    private OddeyeMailSender mailSender;

    @RequestMapping(value = "user/edit/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable(value = "id") String id, ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }
        OddeyeUserModel model = Userdao.getUserByUUID(UUID.fromString(id), true);        
        UserService.updateConsumptionYear(model);
        map.put("model", model);
//
//        String baseUrl = mailSender.getBaseurl(request);
//        try {
//            Userdao.getUserByUUID(UUID.fromString(id)).SendConfirmMail(mailSender, baseUrl);
//        } catch (UnsupportedEncodingException ex) {
//
//        }
         Map<String, String> Referalitems = Userdao.getAllUsersShort();
//         for (OddeyeUserModel tuser:Userdao.getAllUsers(true))
//         {
//             Referalitems.put(tuser.getId().toString(), tuser.getEmail());
//         }
        ((HashMap<String, Object>) getEditConfig().get("referal")).put("items",Referalitems);
        //Userdao.getAllUsers() 
        map.put("configMap", getEditConfig());
        map.put("modelname", "User");
        map.put("path", "user");
        map.put("body", "adminedit");
        map.put("jspart", "adminjs");
        return "index";
    }
    
    @RequestMapping(value = "user/new", method = RequestMethod.GET)
    public String startRegisteringNewUser(
            ModelMap map,
            HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }
     
        OddeyeUserModel newUser = new OddeyeUserModel();
        map.put("newUser", newUser);
        map.put("configMap", getEditConfig());
        map.put("modelname", "User");
        map.put("path", "user");
        map.put("body", "adminNewUser");
        map.put("jspart", "adminNewUserjs");
        return "index";
    }

    @RequestMapping(value = "user/new", method = RequestMethod.POST)
    public String createUserFromAdmin(@ModelAttribute("newUser") OddeyeUserModel newUser, BindingResult result, ModelMap map, HttpServletRequest request) {

        userValidator.adminCreateValidate(newUser, result);
        if (result.hasErrors()) {
            setLocaleInfo(map);
            map.put("newUser", newUser);
            map.put("result", result);
            map.put("body", "adminNewUser");
            map.put("jspart", "adminNewUserjs");
        } else {
            try {
//                newUser.SendAdminMail("New user created from admin panel", mailSender);
                newUser.addAuthoritie(OddeyeUserModel.ROLE_USER);
                newUser.setActive(Boolean.FALSE);
                Userdao.addUser(newUser);
                return "redirect:/user/edit/" + newUser.getId().toString();
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
                map.put("newUser", newUser);
                map.put("result", result);
                map.put("body", "adminNewUser");
                map.put("jspart", "adminNewUserjs");
                map.put("message", ex.toString());
            }
        }
        return "indexPrime";
    }
    
    
    class GrantedAuthorityEditor extends PropertyEditorSupport {

        @Override
        public void setAsText(String text) {
            SimpleGrantedAuthority Authority = new SimpleGrantedAuthority(text);
            setValue(Authority);
        }
    }

    @InitBinder
    public void initBinderAll(WebDataBinder binder) {
        binder.registerCustomEditor(GrantedAuthority.class, new GrantedAuthorityEditor());
    }

    @RequestMapping(value = "user/switch/{id}", method = RequestMethod.GET)
    public String userswitch(@PathVariable(value = "id") String id, ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            userDetails.setSwitchUser(Userdao.getUserByUUID(UUID.fromString(id), true));
        }
        return "redirect:/dashboard/";

    }

    @RequestMapping(value = "/switchoff/", method = RequestMethod.GET)
    public String userswitchoff(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            userDetails.setSwitchUser(null);
        }
        return "redirect:/dashboard/";

    }

    @RequestMapping(value = "user/edit/{id}", method = RequestMethod.POST)
    public String edit(@ModelAttribute("model") OddeyeUserModel newUser, BindingResult result, ModelMap map, HttpServletRequest request, HttpServletResponse response) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", userDetails);
                map.put("isAuthentication", true);
                String act = request.getParameter("act");
                JsonObject Jsonchangedata = new JsonObject();

                InetAddress ia = InetAddress.getLocalHost();
                String node = ia.getHostName();
                Gson gson = new Gson();

                if (act.equals("Delete")) {
                    if (newUser.getId().equals(userDetails.getId())) {
                        map.put("model", newUser);
                        map.put("configMap", getEditConfig());
                        map.put("modelname", "User");
                        map.put("path", "user");
                        map.put("body", "adminedit");
                        map.put("jspart", "adminjs");
                    } else {
                        Userdao.deleteUser(newUser);
                        Jsonchangedata.addProperty("UUID", newUser.getId().toString());
                        Jsonchangedata.addProperty("action", "deleteuser");
                        Jsonchangedata.addProperty("node", node);
                        Jsonchangedata.addProperty("fromuser", userDetails.getId().toString());
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
                        return "redirect:/userslist";
                    }

                }

                if (act.equals("Save")) {                    
                    userValidator.adminvalidate(newUser, result);
                    if (result.hasErrors()) {
                        map.put("result", result);
                        map.put("model", newUser);
                    } else {
                        OddeyeUserModel updateuser = Userdao.getUserByUUID(newUser.getId());
                        try {
                            Map<String, HashMap<String, Object>> changedata = Userdao.saveAll(updateuser, newUser, getEditConfig());
                            Jsonchangedata.addProperty("UUID", updateuser.getId().toString());
                            Jsonchangedata.addProperty("action", "updateuser");
                            Jsonchangedata.addProperty("node", node);
                            String changedatajson = gson.toJson(changedata);
                            Jsonchangedata.addProperty("changedata", changedatajson);
                            Jsonchangedata.addProperty("fromuser", userDetails.getId().toString());
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

                        } catch (Exception e) {
                            LOGGER.error(globalFunctions.stackTrace(e));
                        }                        
                        UserService.updateConsumptionYear(updateuser);
                        updateuser.setReferal(Userdao.getUserByUUID(newUser.getSreferal()));
                        map.put("model", updateuser);
                    }

                    map.put("configMap", getEditConfig());
                    map.put("path", "user");
                    map.put("modelname", "User");
                    map.put("body", "adminedit");
                    map.put("jspart", "adminjs");
                }
            } catch (UnknownHostException ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            map.put("isAuthentication", false);
        }

        return "index";
    }

}
