/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.dao.WhitelabelDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.model.WhitelabelModel;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonObject;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * @author vahan
 */
@Controller
public class AdminWhitelabelControlers extends GRUDControler {

    protected static final Logger LOGGER = LoggerFactory.getLogger(AdminWhitelabelControlers.class);

    @Autowired
    WhitelabelDao Whitelabeldao;

    @Autowired
    private HbaseUserDao Userdao;

    public AdminWhitelabelControlers() {
//        AddViewConfig("url", new HashMap<String, Object>() {
//            {
//                put("path", "url");
//                put("title", "whitelabel.url");
//                put("type", "String");
//            }
//        });

        AddViewConfig("url", new HashMap<String, Object>() {
            {
                put("path", "url");
                put("title", "whitelabel.url");
                put("type", "String");
            }
        }).AddViewConfig("logo", new HashMap<String, Object>() {
            {
                put("path", "logo");
                put("title", "whitelabel.logo");
                put("type", "File");
            }
        }).AddViewConfig("introbkg", new HashMap<String, Object>() {
            {
                put("path", "introbkg");
                put("title", "whitelabel.introbkg");
                put("type", "File");
            }
        }).AddViewConfig("css", new HashMap<String, Object>() {
            {
                put("path", "css");
                put("title", "whitelabel.css");
                put("type", "File");
            }
        }).AddViewConfig("userpayment", new HashMap<String, Object>() {
            {
                put("path", "userpayment");
                put("title", "whitelabel.userpayment");
                put("type", "boolean");
            }
        }).AddViewConfig("owner", new HashMap<String, Object>() {
            {
                put("path", "owner");
                put("title", "whitelabel.owner");
                put("type", "Object");
                put("display", "email");
                put("items", null);
            }
        }).AddViewConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "edit");
                put("title", "adminlist.actions");
                put("type", "actions");
            }
        });

        AddEditConfig("url", new HashMap<String, Object>() {
            {
                put("path", "url");
                put("title", "whitelabel.url");
                put("type", "String");
            }
        }).AddEditConfig("logo", new HashMap<String, Object>() {
            {
                put("path", "logo");
                put("title", "whitelabel.logo");
                put("infopath", "logofilename");
                put("inftype", "image/*");                
                put("type", "File");
            }
        }).AddEditConfig("introbkg", new HashMap<String, Object>() {
            {
                put("path", "introbkg");
                put("title", "whitelabel.introbkg");
                put("infopath", "introbkgfilename");
                put("inftype", "image/*");
                put("type", "File");
            }
        }).AddEditConfig("css", new HashMap<String, Object>() {
            {
                put("path", "css");
                put("title", "whitelabel.css");
                put("infopath", "cssfilename");
                put("inftype", ".css");                    
                put("type", "File");
            }
        }).AddEditConfig("userpayment", new HashMap<String, Object>() {
            {
                put("path", "userpayment");
                put("title", "whitelabel.userpayment");
                put("type", "boolean");
            }
        }).AddEditConfig("owner", new HashMap<String, Object>() {
            {
                put("path", "owner");
                put("title", "whitelabel.owner");
                put("type", "Select");
                put("items", null);
            }
        }).AddEditConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "actions");
                put("title", "adminlist.actions");
                put("type", "actions");
            }
        });
    }

    @RequestMapping(value = "/whitelable/list", method = RequestMethod.GET)
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

        map.put("modellist", Whitelabeldao.getAll());
        map.put("configMap", getViewConfig());
        map.put("body", "adminlist");
        map.put("path", "whitelable");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "/whitelable/new", method = RequestMethod.GET)
    public String newWL(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        Map<String, String> owneritems = new HashMap<>();
        owneritems.put("", " ");
        for (OddeyeUserModel tuser : Userdao.getAllUsers(true)) {
            if (tuser.isRolePresent(OddeyeUserModel.ROLE_WHITELABEL_OWNER)) {
                owneritems.put(tuser.getId().toString(), tuser.getEmail());
            }
        }
        ((HashMap<String, Object>) getEditConfig().get("owner")).put("items", owneritems);

        WhitelabelModel model = new WhitelabelModel();
        map.put("model", model);
        //Userdao.getAllUsers() 
        map.put("configMap", getEditConfig());
        map.put("modelname", "whitelable");
        map.put("path", "whitelable");
        map.put("body", "admineditmultipart");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "/whitelable/edit/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable(value = "id") String id, ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }
        WhitelabelModel model = Whitelabeldao.getByID(id);
        Map<String, String> owneritems = new HashMap<>();
        owneritems.put("", " ");
        for (OddeyeUserModel tuser : Userdao.getAllUsers(true)) {
            if (tuser.isRolePresent(OddeyeUserModel.ROLE_WHITELABEL_OWNER)) {
                owneritems.put(tuser.getId().toString(), tuser.getEmail());
            }
        }
        ((HashMap<String, Object>) getEditConfig().get("owner")).put("items", owneritems);

        map.put("model", model);
        //Userdao.getAllUsers() 
        map.put("configMap", getEditConfig());
        map.put("modelname", "whitelable");
        map.put("path", "whitelable");
        map.put("body", "admineditmultipart");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "/whitelable/edit/{id}", method = RequestMethod.POST)
    public String edit(@ModelAttribute("model") WhitelabelModel newWL, BindingResult result, @RequestParam("logo") MultipartFile files, ModelMap map, HttpServletRequest request, HttpServletResponse response) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", userDetails);
                map.put("isAuthentication", true);
                String act = request.getParameter("act");
                JsonObject Jsonchangedata = new JsonObject();

//                InetAddress ia = InetAddress.getLocalHost();
//                String node = ia.getHostName();
//                Gson gson = new Gson();
                String uploadsDir = "/WEB-INF/assets/uploads/"+newWL.getOwner().getId().toString()+"/"+newWL.getUrl()+"/";
                String realPathtoUploads = request.getServletContext().getRealPath(uploadsDir);
                if (!new File(realPathtoUploads).exists()) {
                    new File(realPathtoUploads).mkdirs();
                }

                if (!newWL.getLogo().isEmpty()) {
                    String orgName = newWL.getLogo().getOriginalFilename();
                    String filePath = realPathtoUploads + orgName;
                    File dest = new File(filePath);
                    newWL.getLogo().transferTo(dest);                                        
                    newWL.setLogofilename(newWL.getLogo().getOriginalFilename());
                }
                if (!newWL.getIntrobkg().isEmpty()) {
                    String orgName = newWL.getIntrobkg().getOriginalFilename();
                    String filePath = realPathtoUploads + orgName;
                    File dest = new File(filePath);
                    newWL.getIntrobkg().transferTo(dest);                                        
                    newWL.setIntrobkgfilename(newWL.getIntrobkg().getOriginalFilename());
                }                
                
                if (!newWL.getCss().isEmpty()) {
                    String orgName = newWL.getCss().getOriginalFilename();
                    String filePath = realPathtoUploads + orgName;
                    File dest = new File(filePath);
                    newWL.getCss().transferTo(dest);                                        
                    newWL.setCssfilename(newWL.getCss().getOriginalFilename());
                }                                
                
                if (act.equals("Delete")) {
                    Whitelabeldao.delete(newWL);
                    return "redirect:/whitelable/list";
                }

                if (act.equals("Save")) {
                    Whitelabeldao.addRow(newWL);
                    Userdao.saveField(newWL.getOwner(), "whitelabel");
                    map.put("configMap", getEditConfig());
                    map.put("path", "whitelable");
                    map.put("modelname", "whitelable");
                    map.put("body", "admineditmultipart");
                    map.put("jspart", "adminjs");
                }
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            map.put("isAuthentication", false);
        }

        return "index";
    }
}
