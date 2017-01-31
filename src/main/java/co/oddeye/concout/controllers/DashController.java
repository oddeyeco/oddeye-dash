/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import com.google.gson.JsonObject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.support.SendResult;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.kafka.core.KafkaTemplate;

/**
 *
 * @author vahan
 */
@Controller
public class DashController {

    protected static final Logger LOGGER = LoggerFactory.getLogger(DashController.class);

    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;    
    @Autowired
    private HbaseUserDao Userdao;

    @RequestMapping(value = {"/dashboard/new"}, method = RequestMethod.GET)
    public String NewDash(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("dashname", "Dashboard" + (userDetails.getDushList().size() + 1));
        }

        map.put("body", "dashboard");
        map.put("jspart", "dashboardjs");
        map.put("dashInfo", "{}");

        return "index";
    }

    @RequestMapping(value = {"/dashboard/{dashname}"}, method = RequestMethod.GET)
    public String ShowDash(@PathVariable(value = "dashname") String dashname, ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            String chartid = request.getParameter("chart");
            if (chartid != null) {
                map.put("chart", chartid);
            } else {
                map.put("chart", -1);
            }
            map.put("curentuser", userDetails);
            map.put("dashname", dashname);
            map.put("dashInfo", userDetails.getDush(dashname));
        }

        map.put("body", "dashboard");
        map.put("jspart", "dashboardjs");

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
            } else {
                jsonResult.addProperty("sucsses", false);
            }
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/dashboard/delete"})
    public String DeleteDash(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            String DushName = request.getParameter("name");
            if (DushName != null) {
                userDetails.removeDush(DushName, Userdao);
                jsonResult.addProperty("sucsses", true);
            } else {
                jsonResult.addProperty("sucsses", false);
            }
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/savefilter", "/savefilter/{filtername}"})
    public String savemonitoringsetings(@PathVariable(value = "filtername", required = false) String filtername, ModelMap map, HttpServletRequest request) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        User userDetails;
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

            if (filtername == null) {
                filtername = "oddeye_base_def";
            }

            String filterinfo = request.getParameter("filter");
            if (filtername != null) {
                userDetails.addFiltertemplate(filtername, filterinfo, Userdao);

                JsonObject Jsonchangedata = new JsonObject();
                Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
                Jsonchangedata.addProperty("action", "changefilter");
                Jsonchangedata.addProperty("filter", filterinfo);
                Jsonchangedata.addProperty("filtername", filtername);

                // Send chenges to kafka
                ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send("semaphore", Jsonchangedata.toString());
                messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                    @Override
                    public void onSuccess(SendResult<Integer, String> result) {
                        if (LOGGER.isInfoEnabled()) {
                            LOGGER.info("Kafka resetregresion onSuccess");
                        }
                    }

                    @Override
                    public void onFailure(Throwable ex) {
                        LOGGER.error("Kafka resetregresion onFailure:" + ex);
                    }
                });

                jsonResult.addProperty("sucsses", true);
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);
        return "ajax";
    }
}
