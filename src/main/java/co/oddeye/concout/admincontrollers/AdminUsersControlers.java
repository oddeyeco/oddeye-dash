/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.concout.validator.UserValidator;
import co.oddeye.core.globalFunctions;
import java.beans.PropertyEditorSupport;
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
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
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
    private UserValidator userValidator;

    protected static final Logger LOGGER = LoggerFactory.getLogger(AdminUsersControlers.class);

    public AdminUsersControlers() {
        AddViewConfig("email", new HashMap<String, Object>() {
            {
                put("path", "email");
                put("title", "E-Mail");
                put("type", "String");
            }
        }).AddViewConfig("name", new HashMap<String, Object>() {
            {
                put("path", "name");
                put("title", " First Name");
                put("type", "String");
            }
        }).AddViewConfig("lastname", new HashMap<String, Object>() {
            {
                put("path", "lastname");
                put("title", " Last Name");
                put("type", "String");
            }
        }).AddViewConfig("Company", new HashMap<String, Object>() {
            {
                put("path", "company");
                put("title", "Company");
                put("type", "String");
            }
        }).AddViewConfig("Country", new HashMap<String, Object>() {
            {
                put("path", "country");
                put("title", "Country");
                put("type", "String");
            }
        }).AddViewConfig("Timezone", new HashMap<String, Object>() {
            {
                put("path", "timezone");
                put("title", " Timezone");
                put("type", "String");
            }
        }).AddViewConfig("Authorities", new HashMap<String, Object>() {
            {
                put("path", "authorities");
                put("title", " Authorities");
                put("type", "Collection");
                put("items", User.getAllRoles());
            }
        }).AddViewConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "edit");
                put("title", " Actions");
                put("type", "actions");
            }
        }).AddViewConfig("userswitch", new HashMap<String, Object>() {
            {
                put("path", "alowswitch");
                put("title", " Switch to user");
                put("type", "actions");
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
                put("title", "E-Mail");
                put("type", "String");
                put("required", true);

            }
        }).AddEditConfig("name", new HashMap<String, Object>() {
            {
                put("path", "name");
                put("title", " First Name");
                put("type", "String");
            }
        }).AddEditConfig("lastname", new HashMap<String, Object>() {
            {
                put("path", "lastname");
                put("title", " Last Name");
                put("type", "String");
            }
        }).AddEditConfig("password", new HashMap<String, Object>() {
            {
                put("path", "password");
                put("title", "Password");
                put("retitle", "Re enter Password");
                put("type", "password");
            }
        }).AddEditConfig("Company", new HashMap<String, Object>() {
            {
                put("path", "company");
                put("title", "Company");
                put("type", "String");
            }
        }).AddEditConfig("Country", new HashMap<String, Object>() {
            {
                put("path", "country");
                put("title", "Country");
                put("type", "Select");
                put("items", country);
            }
        }).AddEditConfig("Timezone", new HashMap<String, Object>() {
            {
                put("path", "timezone");
                put("title", " Timezone");
                put("type", "Select");
                put("items", timezones);
            }
        }).AddEditConfig("balance", new HashMap<String, Object>() {
            {
                put("path", "balance");
                put("title", "Balance");
                put("type", "float");
            }
        }).AddEditConfig("alowswitch", new HashMap<String, Object>() {
            {
                put("path", "alowswitch");
                put("title", "is Alowswitch");
                put("type", "boolean");
            }
        }).AddEditConfig("Authorities", new HashMap<String, Object>() {
            {
                put("path", "authorities");
                put("title", " Authorities");
                put("type", "MultiSelect");
                put("items", User.getAllRoles());
            }
        }).AddEditConfig("active", new HashMap<String, Object>() {
            {
                put("path", "active");
                put("title", "is Active");
                put("type", "boolean");
            }
        }).AddEditConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "actions");
                put("title", " Actions");
                put("type", "actions");
            }
        });

    }

    @RequestMapping(value = "/userslist", method = RequestMethod.GET)
    public String showlist(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
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

    @RequestMapping(value = "user/edit/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable(value = "id") String id, ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        map.put("model", Userdao.getUserByUUID(UUID.fromString(id), true));
        map.put("configMap", getEditConfig());
        map.put("modelname", "User");
        map.put("path", "user");
        map.put("body", "adminedit");
        map.put("jspart", "adminjs");
        return "index";
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
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            userDetails.setSwitchUser(Userdao.getUserByUUID(UUID.fromString(id), true));
        }
        return "redirect:/dashboard/";

    }

    @RequestMapping(value = "user/edit/{id}", method = RequestMethod.POST)
    public String edit(@ModelAttribute("model") User newUser, BindingResult result, ModelMap map, HttpServletRequest request, HttpServletResponse response) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
            String act = request.getParameter("act");
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
                    return "redirect:/userslist";
                }

            }

            if (act.equals("Save")) {
                userValidator.adminvalidate(newUser, result);

                if (result.hasErrors()) {
                    map.put("result", result);
                } else {
                    User updateuser = Userdao.getUserByUUID(newUser.getId());
                    try {
                        Userdao.saveAll(updateuser, newUser, getEditConfig());
                    } catch (Exception e) {
                        LOGGER.error(globalFunctions.stackTrace(e));
                    }
                }

                map.put("model", newUser);
                map.put("configMap", getEditConfig());
                map.put("path", "user");
                map.put("modelname", "User");
                map.put("body", "adminedit");
                map.put("jspart", "adminjs");
            }
        } else {
            map.put("isAuthentication", false);
        }

        return "index";
    }

}
