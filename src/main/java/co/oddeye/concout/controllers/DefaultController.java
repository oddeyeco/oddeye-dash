/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.helpers.mailSender;
import co.oddeye.concout.model.User;
import co.oddeye.concout.validator.UserValidator;
import co.oddeye.core.globalFunctions;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;
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
import org.slf4j.Logger;

/**
 *
 * @author vahan
 */
@Controller
public class DefaultController {

    @Autowired
    private UserValidator userValidator;
    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    private mailSender Sender;

    protected static final Logger LOGGER = LoggerFactory.getLogger(DefaultController.class);

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(ModelMap map, HttpServletRequest request) {
        return redirecttodashboard();
//        map.put("request", request);
//        map.put("title", "High speed monitoring &amp; analytics");
//        map.put("body", "homepage");
//        map.put("jspart", "homepagejs");
//        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//        if (!(auth instanceof AnonymousAuthenticationToken)) {
//            User userDetails = (User) SecurityContextHolder.getContext().
//                    getAuthentication().getPrincipal();
//            map.put("curentuser", userDetails);
//            map.put("isAuthentication", true);
//        } else {
//            map.put("isAuthentication", false);
//        }
////        layaut = "indexPrime";
//        return "indexPrime";
    }

    @RequestMapping(value = "/gugush.txt", method = RequestMethod.GET)
    public String gugush(ModelMap map, HttpServletRequest request) {
        map.put("slug", "login");
        map.put("body", "gugush");
        map.put("jspart", "gugushjs");
        return "indextxt";
    }    
    
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String test(ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//        org.springframework.security.access.AccessDeniedException;
//ExecutorSubscribableChannel
        User user;
        if (auth != null
                && auth.isAuthenticated()
                && //when Anonymous Authentication is enabled
                !(auth instanceof AnonymousAuthenticationToken)) {
            user = (User) auth.getPrincipal();
            map.put("curentuser", user);
        }
        map.put("body", "test");
        map.put("jspart", "testjs");
        return "index";
    }

    @RequestMapping(value = {"/logout"}, method = RequestMethod.GET)
    public String logoutDo(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
        SecurityContextHolder.clearContext();
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        for (Cookie cookie : request.getCookies()) {
            cookie.setMaxAge(0);
        }
        return "redirect:/";
    }

    @RequestMapping(value = {"/login/", "/login"}, method = RequestMethod.GET)
    public String loginDo(ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            return redirecttodashboard();
        }
        map.put("isAuthentication", false);
        map.put("title", "Login");
        map.put("slug", "login");
        map.put("body", "login");
        map.put("jspart", "loginjs");
        return "indexPrime";
    }

    @RequestMapping(value = "/{slug}/", method = RequestMethod.GET)
    public String bytemplate(@PathVariable(value = "slug") String slug, ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layaut = "indexPrime";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
            layaut = "index";
            map.put("body", slug);
            map.put("jspart", slug+"js");            
        } else {
            map.put("isAuthentication", false);
            map.put("body", "standartpage");
            map.put("jspart", "standartpagejs");

        }
        map.put("title", slug);
        map.put("slug", slug);

        if (slug.equals("signup")) {
            if (!(auth instanceof AnonymousAuthenticationToken)) {
                return redirecttodashboard();
            }
            User newUser = new User();
            map.put("newUser", newUser);
            map.put("title", slug);
            map.put("slug", slug);
            map.put("body", slug);
            map.put("jspart", slug + "js");

            setLocaleInfo(map);
        }

        return layaut;
    }

    private String redirecttodashboard() {
        return "redirect:/dashboard/";
    }

    @RequestMapping(value = "/confirm/{uuid}", method = RequestMethod.GET)
    public String confirmuser(@PathVariable(value = "uuid") String uuid, ModelMap map) {
        User user = null;
        if (SecurityContextHolder.getContext().getAuthentication() != null
                && SecurityContextHolder.getContext().getAuthentication().isAuthenticated()
                && //when Anonymous Authentication is enabled
                !(SecurityContextHolder.getContext().getAuthentication() instanceof AnonymousAuthenticationToken)) {
            user = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

        } else {
            user = Userdao.getUserByUUID(UUID.fromString(uuid));
        }

        user.setActive(Boolean.TRUE);
        try {
            Userdao.addUser(user);
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        //TODO Send refresh messge to kafka
        return redirecttodashboard();
//        map.put("curentuser", user);
//        map.put("body", templatename);
//        return "index";
    }

    @RequestMapping(value = "/signup/", method = RequestMethod.POST)
    public String createuser(@ModelAttribute("newUser") User newUser, BindingResult result, ModelMap map, HttpServletRequest request) {
        userValidator.validate(newUser, result);

        if (result.hasErrors()) {
            setLocaleInfo(map);
            map.put("newUser", newUser);
            map.put("result", result);
            map.put("body", "signup");
            map.put("jspart", "signupjs");
        } else {
            try {
                //request.getScheme()
//                String baseUrl = String.format("%s://%s:%d"+request.getContextPath(),"https",  request.getServerName(), request.getServerPort());
                String baseUrl = Sender.getBaseurl(request);
                newUser.SendConfirmMail(Sender, baseUrl);
//                newUser.getAuthorities().add(new SimpleGrantedAuthority(User.ROLE_USER));
                newUser.addAuthoritie(User.ROLE_USER);
                newUser.setActive(Boolean.FALSE);
                Userdao.addUser(newUser);
                map.put("body", "homepage");
                map.put("jspart", "homepagejs");
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
                map.put("newUser", newUser);
                map.put("result", result);
                map.put("body", "signup");
                map.put("jspart", "signupjs");
                map.put("message", ex.toString());
            }
        }
        return "indexPrime";
        //else

    }

    public static void setLocaleInfo(ModelMap map) {

        Map<String, String> country = new LinkedHashMap<>();
        Map<String, String> timezones = new LinkedHashMap<>();
        country.put("", "");
        timezones.put("", "");

        String[] locales = Locale.getISOCountries();

        for (String countryCode : locales) {
            Locale obj = new Locale("", countryCode);
            country.put(obj.getCountry(), obj.getDisplayCountry());
        }

        String[] ids = TimeZone.getAvailableIDs();
        for (String tzone : ids) {
            TimeZone timeZone = TimeZone.getTimeZone(tzone);
            int offset = timeZone.getOffset(System.currentTimeMillis()) / 1000 / 60 / 60;
            String prefix = "UTC+";
            if (offset < 0) {
                prefix = "UTC";
            }
            timezones.put(timeZone.getID(), timeZone.getID() + "(" + prefix + offset + ")");
        }

        map.put("countryList", country);
        map.put("tzone", timezones);
    }

}
