/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import static co.oddeye.concout.controllers.DefaultController.setLocaleInfo;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.concout.validator.UserValidator;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
public class ProfileController {

    @Autowired
    private UserValidator userValidator;
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    private HbaseUserDao Userdao;
    

    @RequestMapping(value = "/profile", method = RequestMethod.GET)
    public String profile(ModelMap map) throws Exception {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

            userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
            map.put("curentuser", userDetails);

        } else {
            layaut = "indexNotaut";
        }

        map.put("body", "profile");
        map.put("jspart", "profilejs");

        return layaut;
    }

    @RequestMapping(value = "/profile/edit", method = RequestMethod.GET)
    public String profileedit(ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("newuserdata", userDetails);
            DefaultController.setLocaleInfo(map);

        } else {
            layaut = "indexNotaut";
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
    public String createuser(@ModelAttribute("newuserdata") User newuserdata, BindingResult result, ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User curentuser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            userValidator.updatevalidate(newuserdata, result);            
            
            DefaultController.setLocaleInfo(map);
            
            DefaultController.setLocaleInfo(map);
            if (result.hasErrors()) {                
                map.put("result", result);                
            } 
            else
            {                
                try {
                    Map<String, Object> changedata = curentuser.updateBaseData(newuserdata);
                    Userdao.saveUserPersonalinfo(curentuser,changedata);
                    return "redirect:/profile/edit";
                } catch (Exception ex) {
                    Logger.getLogger(ProfileController.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }
            map.put("newuserdata", newuserdata);
            map.put("curentuser", curentuser);
            map.put("body", "profileedit");
            map.put("jspart", "profileeditjs");

            return "index";

        }
        return "indexNotaut";
        //else
    }
}
