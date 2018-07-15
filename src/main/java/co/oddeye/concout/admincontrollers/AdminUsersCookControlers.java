/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.helpers.OddeyeMailSender;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.validator.UserValidator;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.beans.PropertyEditorSupport;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class AdminUsersCookControlers extends GRUDControler {

    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    private UserValidator userValidator;
    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;

    protected static final Logger LOGGER = LoggerFactory.getLogger(AdminUsersCookControlers.class);

    public AdminUsersCookControlers() {
        AddViewConfig("email", new HashMap<String, Object>() {
            {
                put("path", "email");
                put("title", "adminlist.email");
                put("type", "String");
            }
        }).AddViewConfig("name", new HashMap<String, Object>() {
            {
                put("path", "fullname");
                put("title", "adminlist.name");
                put("type", "String");
            }
        }).AddViewConfig("balance", new HashMap<String, Object>() {
            {
                put("path", "balance");
                put("title", "adminlist.balance");
                put("type", "Double");
            }
        }).AddViewConfig("referal", new HashMap<String, Object>() {
            {
                put("path", "referal");
                put("title", "adminlist.referal");
                put("type", "Object");
                put("display", "email");
                put("items", null);
            }
        }).AddViewConfig("Sinedate", new HashMap<String, Object>() {
            {
                put("path", "sinedate");
                put("title", "adminlist.signedDate");
                put("type", "Date");
                put("displayclass", "orderdesc");
            }
        }).AddViewConfig("Cookesinfo", new HashMap<String, Object>() {
            {
                put("path", "cookies");
                put("title", "adminlist.cookiesInfo");
                put("type", "cookies");                
            }
        });
                
                
                
//                .AddViewConfig("Authorities", new HashMap<String, Object>() {
//            {
//                put("path", "authorities");
//                put("title", " Authorities");
//                put("type", "Collection");
//                put("items", OddeyeUserModel.getAllRoles());
//            });

    }

    @RequestMapping(value = "/cookreport", method = RequestMethod.GET)
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
        List<OddeyeUserModel> userlist = Userdao.getAllUsers(true);
//        Collections.sort(userlist, OddeyeUserModel.USinedateComparator);
        map.put("modellist", userlist);
        map.put("configMap", getViewConfig());
        map.put("body", "adminlist");
        map.put("path", "user");
        map.put("jspart", "adminjs");
        return "index";
    }

}
