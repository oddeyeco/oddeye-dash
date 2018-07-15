/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.dao.HbaseDushboardTemplateDAO;
import co.oddeye.concout.model.DashboardTemplate;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.validator.TemplateValidator;
import co.oddeye.core.globalFunctions;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class AdminTemplateControlers extends GRUDControler {

    @Autowired
    private HbaseDushboardTemplateDAO TemplateDAO;

    @Autowired
    private TemplateValidator TemplateValidator;

    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(AdminTemplateControlers.class);

    public AdminTemplateControlers() {
        AddViewConfig("name", new HashMap<String, Object>() {
            {
                put("path", "name");
                put("title", "adminlist.name");
                put("type", "String");
            }
        }).AddViewConfig("type", new HashMap<String, Object>() {
            {
                put("path", "type");
                put("title", "adminlist.type");
                put("type", "Enum");
            }
        }).AddViewConfig("timestamp", new HashMap<String, Object>() {
            {
                put("path", "time");
                put("title", "adminlist.date");
                put("type", "Date");
            }
        }).AddViewConfig("user", new HashMap<String, Object>() {
            {
                put("path", "user");
                put("title", "adminlist.user");
                put("type", "Object");
                put("display", "email");

            }
        }).AddViewConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "edit");
                put("title", "adminlist.actions");
                put("type", "actions");
            }
        }).AddViewConfig("tags", new HashMap<String, Object>() {
            {
                put("title", "tags");
                put("path", "usedtags");                
                put("type", "List");
            }
        }).AddViewConfig("metrics", new HashMap<String, Object>() {
            {
                put("title", "metrics");
                put("path", "usednames");                
                put("type", "List");
            }
        });

        AddEditConfig("name", new HashMap<String, Object>() {
            {
                put("path", "name");
                put("title", "adminlist.name");
                put("type", "String");
                put("required", true);

            }
        }).AddEditConfig("description", new HashMap<String, Object>() {
            {
                put("path", "description");
                put("title", "adminlist.description");
                put("type", "Text");
                put("required", false);

            }
        }).AddEditConfig("infoSjson", new HashMap<String, Object>() {
            {
                put("path", "infoSjson");
                put("title", "JSON");
                put("type", "Text");
                put("required", false);

            }
        }).AddEditConfig("Recomended", new HashMap<String, Object>() {
            {
                put("path", "Recomended");
                put("title", "adminlist.isRecomended");
                put("type", "boolean");
            }
        }).AddEditConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "actions");
                put("title", "adminlist.actions");
                put("type", "actions");
            }
        });
    }

    @RequestMapping(value = "/templatelist", method = RequestMethod.GET)
    public String showlist(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        map.put("modellist", TemplateDAO.getAll());
        map.put("configMap", getViewConfig());
        map.put("body", "adminlist");
        map.put("path", "template");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "template/edit/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable(value = "id") String id, ModelMap map, HttpServletRequest request) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", userDetails);
                map.put("isAuthentication", true);
            } else {
                map.put("isAuthentication", false);
            }

            map.put("model", TemplateDAO.getbyKey(Hex.decodeHex(id.toCharArray())));
            map.put("configMap", getEditConfig());
            map.put("modelname", "User");
            map.put("path", "template");
            map.put("body", "adminedit");
            map.put("jspart", "adminjs");

        } catch (DecoderException ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return "index";
    }

    @RequestMapping(value = "template/edit/{id}", method = RequestMethod.POST)
    public String edit(@ModelAttribute("model") DashboardTemplate template, BindingResult result, ModelMap map, HttpServletRequest request, HttpServletResponse response) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
//            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        String act = request.getParameter("act");
        if (act.equals("Delete")) {
            TemplateDAO.delete(template);
            return "redirect:/templatelist";
        }
        if (act.equals("Save")) {
            template.setInfojson(template.getInfoSjson());
            TemplateValidator.validate(template, result);

            if (result.hasErrors()) {
                map.put("result", result);
            }
            else
            {
                DashboardTemplate oldtemplate = TemplateDAO.getbyKey(template.getKey());
                if  (TemplateDAO.save(template,oldtemplate,getEditConfig()))
                {
                    return "redirect:/template/edit/"+template.getId();
                }
                
            }

            map.put("model", template);
            map.put("configMap", getEditConfig());
            map.put("modelname", "DashboardTemplate");
            map.put("path", "template");
            map.put("body", "adminedit");
            map.put("jspart", "adminjs");
        }
        return "index";
    }
}
