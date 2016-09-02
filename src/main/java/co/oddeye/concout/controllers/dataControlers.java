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
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author vahan
 */
@Controller
public class dataControlers {

    @RequestMapping(value = "/metriclist",params = {"q",}, method = RequestMethod.GET)
    public String tagMetricsList(@RequestParam(value = "q") String q, ModelMap map) {
        map.put("body", "taglist");
        map.put("jspart", "taglistjs");

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
//            map.put("list", userDetails.getTags().get(tagkey).get(tagname));

        }
        return "index";
    }

    @RequestMapping(value = "/chart/{tagkey:.+}/{tagname:.+}/{metric:.+}", method = RequestMethod.GET)
    public String singlecahrt(@PathVariable(value = "tagkey") String tagkey, @PathVariable(value = "tagname") String tagname, @PathVariable(value = "metric") String metric, ModelMap map) {
        map.put("body", "singlecahrt");
        map.put("jspart", "singlecahrtjs");

        map.put("tagkey", tagkey);
        map.put("tagname", tagname);

        map.put("metric", metric);

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
//            map.put("list", userDetails.getTags().get(tagkey).get(tagname));

        }
        return "index";
    }
}
