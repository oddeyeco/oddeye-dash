/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.core.TemplateType;
import co.oddeye.concout.dao.HbaseDushboardTemplateDAO;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.exception.ResourceNotFoundException;
import co.oddeye.concout.model.DashboardTemplate;
import co.oddeye.concout.model.User;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonObject;
import java.util.logging.Level;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
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
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

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
    @Autowired
    private HbaseDushboardTemplateDAO TemplateDAO;

    @RequestMapping(value = {"/dashboard/"}, method = RequestMethod.GET)
    public String getDashboards(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("title", "My Dashboards");
            map.put("templates", TemplateDAO.getAlltemplates(10));
        }

        map.put("body", "dashboards");
        map.put("jspart", "dashboardsjs");
        return "index";
    }

    @RequestMapping(value = {"/template/{dashkey}"}, method = RequestMethod.GET)
    public String ShowDashTemplate(@PathVariable(value = "dashkey") String dashkey, ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User userDetails = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();
                map.put("curentuser", userDetails);
                map.put("dashname", "Dashboard" + (userDetails.getDushList().size() + 1));
                DashboardTemplate Dash = TemplateDAO.getbyKey(Hex.decodeHex(dashkey.toCharArray()));
                map.put("title", Dash.getName());
                map.put("dashInfo", Dash.getInfojson().toString());
                map.put("body", "dashboard");
                map.put("jspart", "dashboardjs");

//            DashboardTemplate template = new DashboardTemplate(dashname,userDetails.getDush(dashname), userDetails, TemplateType.Dushboard);
//            TemplateDAO.add(template);
                return "index";
            } catch (DecoderException ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        }
        return "index";
    }

    @RequestMapping(value = {"/dashboard/new"}, method = RequestMethod.GET)
    public String NewDash(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("dashname", "Dashboard" + (userDetails.getDushList().size() + 1));
            map.put("title", "New Dashboard");
        }

        map.put("body", "dashboard");
        map.put("jspart", "dashboardjs");
        map.put("dashInfo", "{}");

        return "index";
    }

    @ExceptionHandler(ResourceNotFoundException.class)
//	public String handleEmployeeNotFoundException(ModelMap map, HttpServletRequest request, HttpServletResponse response,Exception ex)
    public ModelAndView handleDushNotFoundException(HttpServletRequest request, Exception ex) {

        User userDetails = (User) SecurityContextHolder.getContext().
                getAuthentication().getPrincipal();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("curentuser", userDetails);
//            modelAndView.addObject("dashname", dashname);        
        modelAndView.addObject("exception", ex);
        modelAndView.addObject("url", request.getRequestURL());
        modelAndView.addObject("body", "errors/404error");
        modelAndView.addObject("jspart", "errors/errorjs");
        modelAndView.setViewName("index");
        return modelAndView;
    }

    @RequestMapping(value = {"/dashboard/{dashname:.+}"}, method = RequestMethod.GET)
    public String ShowDash(@PathVariable(value = "dashname") String dashname, ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("dashname", dashname);
            map.put("title", dashname);
            map.put("dashInfo", userDetails.getDush(dashname));
            map.put("body", "dashboard");
            map.put("jspart", "dashboardjs");
            if (userDetails.getDush(dashname) == null) {
                throw new ResourceNotFoundException(dashname + " not exists");
            }

//            DashboardTemplate template = new DashboardTemplate(dashname,userDetails.getDush(dashname), userDetails, TemplateType.Dushboard);            
//            TemplateDAO.add(template);
            return "index";
        }
        return "index";
    }

    @RequestMapping(value = {"/dashboard/save"})
    public String SaveDash(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            String DushName = request.getParameter("name").trim();
            String DushInfo = request.getParameter("info").trim();
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
            String DushName = request.getParameter("name").trim();
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
