/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author vahan
 */
@Controller
public class dataControlers {

    @Autowired
    private HbaseDataDao Datadao;    
    
    @RequestMapping(value = "/metriclist",params = {"tags",}, method = RequestMethod.GET)
    public String tagMetricsList(@RequestParam(value = "tags") String tags, ModelMap map) {
        map.put("body", "taglist");
        map.put("jspart", "taglistjs");

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("tags", tags);

        }
        return "index";
    }

    @RequestMapping(value = "/chart", method = RequestMethod.GET)
    public String singlecahrt(@RequestParam(value = "tags") String tags,@RequestParam(value = "metrics") String metrics, ModelMap map) {
        map.put("body", "singlecahrt");
        map.put("jspart", "singlecahrtjs");

        map.put("metric", metrics);
        map.put("q", tags);

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
