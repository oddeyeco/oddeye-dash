/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.model.User;
//import com.google.gson.JsonObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

/**
 *
 * @author vahan
 */
@Controller
public class AjaxControlers {

    @Autowired
    HbaseDataDao DataDao;
//http://localhost:8080/OddeyeCoconut/getdata/host/cassa005.mouseflow.eu/drive_md0_read_bytes/1468072117/10

    @RequestMapping(value = "/getdata/{tagkey:.+}/{tagname:.+}/{metric:.+}/{fromdate}/{count}", method = RequestMethod.GET)
    public String singlecahrt(@PathVariable(value = "tagkey") String tagkey, @PathVariable(value = "tagname") String tagname,
            @PathVariable(value = "metric") String metric,
            @PathVariable(value = "fromdate") long fromdate,
            @PathVariable(value = "count") int count,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = null;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            user = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

        }

//        JsonObject jsonResult = new JsonObject();
//            jsonResult.add("chartdata",jsonMessage);
//            jsonResult.addProperty("gettime", getinterval);
//            jsonResult.addProperty("scantime", scaninterval);
//            jsonResult.addProperty("itemscount", itemscount);
//            jsonResult.addProperty("firstinterval", firstinterval);
//            jsonResult.addProperty("stepinterval", stepinterval);

//        map.put("jsonmodel", jsonResult);

        return "ajax";
    }
}
