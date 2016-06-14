/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.concout.validator.UserValidator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class DefaultController {
    
    @Autowired
    private UserValidator userValidator;
    @Autowired
    private HbaseUserDao Userdao;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(ModelMap map) {
        map.put("body", "homepage");
        return "indexNotaut";
    }

    @RequestMapping(value = "/{templatename}", method = RequestMethod.GET)
    public String bytemplate(@PathVariable(value = "templatename") String templatename, ModelMap map) {

        map.put("body", templatename);
        if (templatename.equals("signup")) {
            User newUser = new User();
            map.put("newUser", newUser);
            setLocaleInfo(map);
            return "indexNotaut";
        }
        return "index";
    }

    @RequestMapping(value = "/signup", method = RequestMethod.POST)
    public String createuser(@ModelAttribute("newUser") User newUser, BindingResult result,ModelMap map) {        
        userValidator.validate(newUser, result);
        
        if (result.hasErrors()) {
            setLocaleInfo(map);
            map.put("newUser", newUser);
            map.put("result", result);
            map.put("body", "signup");
        } else {            
            newUser.setActive(Boolean.FALSE);
            newUser.SendConfirmMail();
            Userdao.addUser(newUser);
            map.put("body", "homepage");
        }
        return "indexNotaut";
        //else

    }

    private void setLocaleInfo(ModelMap map) {

        Map<String, String> country = new LinkedHashMap<String, String>();
        Map<String, String> timezones = new LinkedHashMap<String, String>();
        country.put("", "");
        timezones.put("", "");

        String[] locales = Locale.getISOCountries();

        for (String countryCode : locales) {
            Locale obj = new Locale("", countryCode);
            country.put(obj.getCountry(), obj.getDisplayCountry());
        }

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

        map.put("countryList", country);
        map.put("tzone", timezones);
    }

}
