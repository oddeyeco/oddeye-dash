/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.model.User;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class ProfileController {
    @RequestMapping(value = "/profile", method = RequestMethod.GET)
    public String profile( ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);

        } else {
            layaut = "indexNotaut";
        }

        map.put("body", "profile");
        map.put("jspart", "profilejs");

        return layaut;
    }    
    @RequestMapping(value = "/profile/edit", method = RequestMethod.GET)
    public String profileedit( ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "index";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);                                    
            DefaultController.setLocaleInfo(map);            

        } else {
            layaut = "indexNotaut";
        }

        map.put("body", "profileedit");
        map.put("jspart", "profileeditjs");

        return layaut;
    }     
}
