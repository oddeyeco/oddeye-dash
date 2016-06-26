/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.model.User;
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
public class UserController {
@RequestMapping(value = "/dashboard/new", method = RequestMethod.GET)
    public String dashboardnew( ModelMap map) {
        User userDetails = (User) SecurityContextHolder.getContext().
                getAuthentication().getPrincipal();
        map.put("curentuser", userDetails);
        map.put("body", "newdush");
        return "index";
    }    
    
}
