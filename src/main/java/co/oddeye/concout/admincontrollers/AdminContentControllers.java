/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.model.SitePage;
import co.oddeye.concout.model.User;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class AdminContentControllers extends GRUDControler {

    public AdminContentControllers() {
        AddViewConfig("email", new HashMap<String, Object>() {
            {
                put("path", "title");
                put("title", "Title");
                put("type", "String");
            }
        }).AddViewConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "actions");
                put("title", " Actions");
                put("type", "actions");
            }
        });
        
        AddEditConfig("slug", new HashMap<String, Object>() {
            {
                put("path", "slug");
                put("title", "Slug");
                put("type", "String");
                put("required", true);

            }
        }).AddEditConfig("title", new HashMap<String, Object>() {
            {
                put("path", "title");
                put("title", "Display text");
                put("type", "String");
                put("required", true);

            }
        }).AddEditConfig("fulltitle", new HashMap<String, Object>() {
            {
                put("path", "fulltitle");
                put("title", "Title");
                put("type", "String");
                put("required", true);

            }
        }).AddEditConfig("content", new HashMap<String, Object>() {
            {
                put("path", "content");
                put("title", "Text");
                put("type", "Text");
                put("rows", 30);
                put("required", false);

            }
        }).AddEditConfig("description", new HashMap<String, Object>() {
            {
                put("path", "description");
                put("title", "Description");
                put("type", "Text");
                put("rows", 5);
                put("required", false);
            }
        }).AddEditConfig("keywords", new HashMap<String, Object>() {
            {
                put("path", "keywords");
                put("title", "Keywords");
                put("type", "String");
                put("required", false);

            }
        })                 
                .AddEditConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "actions");
                put("title", " Actions");
                put("type", "actions");
            }
        });
    }

    @RequestMapping(value = "/pages", method = RequestMethod.GET)
    public String showlist(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        map.put("modellist", null);
        map.put("configMap", getViewConfig());
        map.put("body", "adminlist");
        map.put("path", "pages");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "/pages/new", method = RequestMethod.GET)
    public String newpage(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);

            map.put("model", new SitePage());
            map.put("configMap", getEditConfig());
            map.put("modelname", "User");
            map.put("body", "adminnew");
            map.put("jspart", "adminjs");
            map.put("configMap", getEditConfig());
        } else {
            map.put("isAuthentication", false);
        }
        map.put("path", "pages");
        return "index";
    }
    
    @RequestMapping(value = "/pages/new/", method = RequestMethod.POST)
    public String addpage(@ModelAttribute("model") SitePage sitePage,ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);

            map.put("model", sitePage);
            map.put("configMap", getEditConfig());
            map.put("modelname", "User");
            map.put("body", "adminnew");
            map.put("jspart", "adminjs");
            map.put("configMap", getEditConfig());
        } else {
            map.put("isAuthentication", false);
        }
        map.put("path", "pages");
        return "index";
    }    
}
