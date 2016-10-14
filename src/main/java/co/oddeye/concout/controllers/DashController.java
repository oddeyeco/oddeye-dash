/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import com.google.gson.JsonObject;
import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
public class DashController {

    @Autowired
    private HbaseUserDao Userdao;

    @RequestMapping(value = {"/dashboard/new"}, method = RequestMethod.GET)
    public String NewDash(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("dashname", "Dashboard" + userDetails.getDushList().size() + 1);
        }

        map.put("body", "dashboard_new");
        map.put("jspart", "dashboard_newjs");

        return "index";
    }

    @RequestMapping(value = {"/dashboard/{dashname}"}, method = RequestMethod.GET)
    public String ShowDash(@PathVariable(value = "dashname") String dashname, ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("dashname", dashname);
            map.put("dashInfo", userDetails.getDush(dashname));
        }

        map.put("body", "dashboard_new");
        map.put("jspart", "dashboard_newjs");

        return "index";
    }

    @RequestMapping(value = {"/dashboard/save"})
    public String SaveDash(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            String DushName = request.getParameter("name");
            String DushInfo = request.getParameter("info");
            if (DushName != null) {
                userDetails.addDush(DushName, DushInfo, Userdao);
                jsonResult.addProperty("sucsses", true);
            }
            else
            {
                jsonResult.addProperty("sucsses", false);
            }
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }
}
