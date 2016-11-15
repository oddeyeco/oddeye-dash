/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseErrorsDao;
import co.oddeye.concout.model.User;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
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
public class UserController {

    @Autowired
    HbaseErrorsDao ErrorsDao;

    @RequestMapping(value = "/monitoring", method = RequestMethod.GET)
    public String monitoring(HttpServletRequest request, ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("ErrorsDao", ErrorsDao);

            String group_item = request.getParameter("group_item");
            if (group_item == null) {
                map.put("group_item", userDetails.getMetricsMeta().getTagsList().entrySet().iterator().next().getKey());
            } else {
                map.put("group_item", group_item);
            }
            String minValue = request.getParameter("minValue");
            if (minValue == null) {
                map.put("minValue", 1);
            }
            else
            {
                map.put("minValue",Math.abs(Double.parseDouble(minValue)));
            }
            
            String minPersent = request.getParameter("minPersent");
            if (minValue == null) {
                map.put("minPersent", 50);
            }
            else
            {
                map.put("minPersent",Math.abs(Double.parseDouble(minPersent)));
            }            
                
            String minWeight = request.getParameter("minWeight");
            if (minValue == null) {
                map.put("minWeight", 8);
            }
            else
            {
                map.put("minWeight",Math.abs(Short.parseShort(minWeight)));
            }              
            

        }

        map.put("body", "monitoring");
        map.put("jspart", "monitoringjs");

        return "index";
    }

}
