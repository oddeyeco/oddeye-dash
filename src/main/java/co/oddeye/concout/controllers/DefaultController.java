/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.beans.PasswordRecoveryInfo;
import co.oddeye.concout.beans.PasswordResetInfo;
import co.oddeye.concout.beans.WhiteLabelResolver;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.helpers.OddeyeMailSender;
import co.oddeye.concout.helpers.PasswordResetTokenEncoder;
import co.oddeye.concout.helpers.PasswordResetTokenEncoder.ResetInfo;

import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.model.WhitelabelModel;
import co.oddeye.concout.validator.UserValidator;
import co.oddeye.core.OddeyeHttpURLConnection;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonElement;
import com.maxmind.geoip2.DatabaseReader;
import com.maxmind.geoip2.exception.GeoIp2Exception;
import com.maxmind.geoip2.model.CityResponse;
import java.io.IOException;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;
import java.util.logging.Level;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;
import org.apache.commons.validator.routines.EmailValidator;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.validation.ValidationUtils;

/**
 *
 * @author vahan
 */
@Controller
public class DefaultController {
    @Value("${captcha.on}")
    private String captchaOn;
    @Value("${captcha.secret}")
    private String captchaSecret;
    
    @Autowired
    private PasswordResetTokenEncoder passwordResetTokenEncoder;
    
    @Autowired
    private UserValidator userValidator;
    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    private OddeyeMailSender mailSender;
    @Autowired
    private DatabaseReader geoip;
    @Autowired
    private MessageSource messageSource;

    @Autowired
    private WhiteLabelResolver whiteLabelResolver;

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
//            UserModel userDetails = (UserModel) SecurityContextHolder.getContext().
//                    getAuthentication().getPrincipal();
//            map.put("curentuser", userDetails);
//            map.put("isAuthentication", true);
//        } else {
//            map.put("isAuthentication", false);
//        }
////        layaut = "indexPrime";
//        return "indexPrime";
    }
/*
    @RequestMapping(value = "/gugush.txt", method = RequestMethod.GET)
    public String gugush(ModelMap map, HttpServletRequest request) {
        map.put("slug", "login");
        map.put("body", "gugush");
        map.put("jspart", "gugushjs");
        return "indextxt";
    }
*/
    @RequestMapping(value = "/preset", method = RequestMethod.GET)
    public String resetpassword(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            return "redirect:/profile/edit#Security";
        }
        map.put("isAuthentication", false);
        map.put("title", messageSource.getMessage("title.login", new String[]{""}, LocaleContextHolder.getLocale()));
//      map.put("title", "");
        map.put("slug", "login");
        map.put("body", "login");
        map.put("jspart", "loginjs");
        return "indexPrime";
    }

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String test(ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//        org.springframework.security.access.AccessDeniedException;
//ExecutorSubscribableChannel
        OddeyeUserModel user;
        if (auth != null
                && auth.isAuthenticated()
                && //when Anonymous Authentication is enabled
                !(auth instanceof AnonymousAuthenticationToken)) {
            user = ((OddeyeUserDetails) auth.getPrincipal()).getUserModel();
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
//        whiteLabelResolver.getDomain();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            return redirecttodashboard();
        }
        map.put("isAuthentication", false);
        map.put("title", messageSource.getMessage("title.login", new String[]{""}, LocaleContextHolder.getLocale()));
        map.put("slug", "login");
        map.put("body", "login");
        map.put("jspart", "loginjs");
        return "indexPrime";
    }

//    @RequestMapping(value = {"/{slug}"}, method = RequestMethod.POST)
//    public String postbytemplate(@PathVariable(value = "slug") String slug, @RequestParam("file") MultipartFile file, ModelMap map, HttpServletRequest request) {
//        return "index";
//    }    
    @RequestMapping(value = {"/{slug}"}, method = RequestMethod.GET)
    public String prepareJSP(@PathVariable(value = "slug") String slug, ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String layout = "indexPrime";
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
            layout = "index";
            map.put("body", slug);
            map.put("jspart", slug + "js");
        } else {
            request.getSession().removeAttribute("SPRING_SECURITY_SAVED_REQUEST");
            map.put("isAuthentication", false);
            if (!slug.equals("signup") || !slug.equals("psrecovery")) {
                map.put("wraper", "noautwraper");
            }
            map.put("body", slug);
            map.put("jspart", slug + "js");
        }
        switch (slug) {
            case "calculator": {
                map.put("title", messageSource.getMessage("title.monitoringPriceCalculator", new String[]{""}, LocaleContextHolder.getLocale()));
//              map.put("title", "Monitoring Price Calculator");
                map.put("ogimage", "oddeyecalcog.png");

                break;
            }
            default: {
                map.put("title", slug);
            }

        }

        map.put("slug", slug);

        if (slug.equals("signup")) {
            if (!(auth instanceof AnonymousAuthenticationToken)) {
                return redirecttodashboard();
            }
            OddeyeUserModel newUser = new OddeyeUserModel();
            map.put("newUser", newUser);
            map.put("title", slug);
            map.put("slug", slug);
            map.put("body", slug);
            map.put("jspart", slug + "js");

            try {
                String ip = request.getHeader("X-Real-IP");
                if (ip == null) {
                    ip = request.getRemoteAddr();
                }
                InetAddress ipAddress = InetAddress.getByName(ip);

                CityResponse city = geoip.city(ipAddress);
                newUser.setCity(city.getCity().getName());
                newUser.setCountry(city.getCountry().getIsoCode());
//                CountryResponse country = geoip.country(ipAddress);
                map.put("country", city.getCountry().getNames());
                map.put("city", city.getCity().getName());
            } catch (GeoIp2Exception | IOException ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }

            setLocaleInfo(map);
        }
       if (slug.equals("psrecovery")) {
            if (!(auth instanceof AnonymousAuthenticationToken)) {
                return redirecttodashboard();
            }
            PasswordRecoveryInfo passwordRecoveryInfo = new PasswordRecoveryInfo();
            map.put("psRecoveryInfo", passwordRecoveryInfo);
            map.put("title", slug);
            map.put("slug", slug);
            map.put("body", slug);
            map.put("jspart", slug + "js");

            setLocaleInfo(map);
        }

        return layout;
    }

    private String redirecttodashboard() {
        return "redirect:/dashboard/";
    }

    @RequestMapping(value = "/confirm/{uuid}", method = RequestMethod.GET)
    public String confirmuser(@PathVariable(value = "uuid") String uuid, ModelMap map) {
        OddeyeUserModel userDetails = null;
        if (SecurityContextHolder.getContext().getAuthentication() != null
                && SecurityContextHolder.getContext().getAuthentication().isAuthenticated()
                && //when Anonymous Authentication is enabled
                !(SecurityContextHolder.getContext().getAuthentication() instanceof AnonymousAuthenticationToken)) {
            userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
        } else {
            userDetails = Userdao.getUserByUUID(UUID.fromString(uuid));
        }
        if (userDetails == null) {
            return "redirect:/signup/?invalidconfirmcode";
        }
        userDetails.setActive(Boolean.TRUE);
        boolean confirm = false;
        if (userDetails.getMailconfirm() == null) {
            userDetails.setFirstlogin(Boolean.TRUE);
            userDetails.setBalance(50.0);
            userDetails.setMailconfirm(Boolean.TRUE);
            confirm = true;
        }

        try {
            Userdao.addUser(userDetails);
            userDetails.SendAdminMail("User Confirm Email", mailSender);
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        //TODO Send refresh messge to kafka
//        return redirecttodashboard();
        return "redirect:/login?confirm=" + confirm;
//        map.put("curentuser", user);
//        map.put("body", templatename);
//        return "index";
    }
    
    @RequestMapping(value = "/signup", method = RequestMethod.POST)
    public String createuser(@ModelAttribute("newUser") OddeyeUserModel newUser, BindingResult result, ModelMap map, HttpServletRequest request) {

        WhitelabelModel wl = whiteLabelResolver.getWhitelabelModel();
        userValidator.validate(newUser, result);
        if("true".equalsIgnoreCase(captchaOn)) {
            if (request.getParameter("g-recaptcha-response") != null) {
                if (!request.getParameter("g-recaptcha-response").isEmpty()) {
                    String ip = request.getHeader("X-Real-IP");
                    if (ip == null) {
                        ip = request.getRemoteAddr();
                    }
                    try {
                        String captchaTestParams = "secret=" + captchaSecret + "&response=" + request.getParameter("g-recaptcha-response") + "&remoteip=" + ip;

                        JsonElement capchaRequest = OddeyeHttpURLConnection.getPostJSON("https://www.google.com/recaptcha/api/siteverify", captchaTestParams);
                        if (capchaRequest.getAsJsonObject().get("success") == null) {
                            result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                        } else {
                            if (!capchaRequest.getAsJsonObject().get("success").getAsBoolean()) {
                                result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                            }
                        }
                    } catch (Exception ex) {
                        result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }

                } else {
                    result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                }
            } else {
                result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
            }
        }
        if (result.hasErrors()) {
            setLocaleInfo(map);
            map.put("newUser", newUser);
            map.put("result", result);
            map.put("body", "signup");
            map.put("jspart", "signupjs");
        } else {
            try {
                String baseUrl = mailSender.getBaseurl(request);
                if (wl != null) {
                    newUser.setWhitelabel(wl);
                    newUser.addAuthoritie(OddeyeUserModel.ROLE_WHITELABEL_USER);
                    newUser.SendWlAdminMail("User Signed in wl", mailSender, wl.getOwner().getEmail());
                    newUser.SendWLConfirmMail(mailSender, baseUrl, wl.getOwner().getEmail());
                }
                if (wl == null) {                    
                    newUser.SendConfirmMail(mailSender, baseUrl);
                }

                newUser.SendAdminMail("User Signed", mailSender);
                newUser.addAuthoritie(OddeyeUserModel.ROLE_USER);
                newUser.setActive(Boolean.FALSE);
                Userdao.addUser(newUser);
                Userdao.saveSineUpCookes(newUser, request.getCookies());

//                return redirecttodashboard();
                map.put("body", "signupconfirm");
                map.put("jspart", "signupconfirmjs");
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
                map.put("newUser", newUser);
                map.put("result", result);
                map.put("body", "signup");
                map.put("jspart", "signupjs");
                map.put("message", ex.toString());
            }
        }
        map.put("title", messageSource.getMessage("title.signUp", new String[]{""}, LocaleContextHolder.getLocale()));
//      map.put("title", "Sign Up");
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
            country.put(obj.getCountry(), obj.getDisplayCountry(LocaleContextHolder.getLocale()));
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
    
    @RequestMapping(value = "/psrecovery", method = RequestMethod.POST)
    public String passwordRecovery(@ModelAttribute("psRecoveryInfo") PasswordRecoveryInfo passwordRecoveryInfo, BindingResult result, ModelMap map, HttpServletRequest request) {
        if("true".equalsIgnoreCase(captchaOn)) {
            if (request.getParameter("g-recaptcha-response") != null) {
                if (!request.getParameter("g-recaptcha-response").isEmpty()) {
                    String ip = request.getHeader("X-Real-IP");
                    if (ip == null) {
                        ip = request.getRemoteAddr();
                    }
                    try {
                        String captchaTestParams = "secret=" + captchaSecret + "&response=" + request.getParameter("g-recaptcha-response") + "&remoteip=" + ip;

                        JsonElement capchaRequest = OddeyeHttpURLConnection.getPostJSON("https://www.google.com/recaptcha/api/siteverify", captchaTestParams);
                        if (capchaRequest.getAsJsonObject().get("success") == null) {
                            result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                        } else {
                            if (!capchaRequest.getAsJsonObject().get("success").getAsBoolean()) {
                                result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                            }
                        }
                    } catch (Exception ex) {
                        result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }

                } else {
                    result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                }
            } else {
                result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
            }
        }

        OddeyeUserDetails existingUser = null;
        
        if(!result.hasErrors()) {
            ValidationUtils.rejectIfEmptyOrWhitespace(result, "email", "email.empty", "Email address must not be empty.");
            if (!EmailValidator.getInstance().isValid(passwordRecoveryInfo.getEmail())) {
                result.rejectValue("email", "email.notValid", "Email address is not valid!");
            }   

            try {
                existingUser = Userdao.getUserByEmail(passwordRecoveryInfo.getEmail());

                if (null == existingUser)
                {
                    result.rejectValue("email", "email.notExist", "Email address is not exist!");
                }
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(UserValidator.class.getName()).log(Level.SEVERE, null, ex);
            }        
        }
        if (result.hasErrors()) {
            setLocaleInfo(map);
            map.put("result", result);
            map.put("body", "psrecovery");
            map.put("jspart", "psrecoveryjs");
        } else {
            try {
                String baseUrl = mailSender.getBaseurl(request);
                baseUrl = "http://localhost:8080/OddeyeCoconut";// Development URL remove on production
                OddeyeUserModel um = existingUser.getUserModel();
                String resetToken = passwordResetTokenEncoder.createRecoveryToken(
                        um);
                
                resetToken = URLEncoder.encode(resetToken, StandardCharsets.UTF_8.toString());
                if(um.sendPasswordRecoveryMail(mailSender, baseUrl, resetToken)){
                    um.SendAdminMail("User requested password recovery", mailSender);
                    map.put("body", "psrecoveryconfirm");
                    map.put("jspart", "psrecoveryconfirmjs");
                } else {
                    setLocaleInfo(map);
                    result.reject("Something went wrong, please try later");
                    map.put("result", result);
                    map.put("body", "psrecovery");
                    map.put("jspart", "psrecoveryjs");                
                }
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
                map.put("result", result);
                map.put("body", "psrecovery");
                map.put("jspart", "psrecoveryjs");
                map.put("message", ex.toString());
            }
        }
        map.put("title", messageSource.getMessage("title.signUp", new String[]{""}, LocaleContextHolder.getLocale()));
        return "indexPrime";
    }
    
    @RequestMapping(value = "/pschange", method = RequestMethod.POST)
    public String passwordChangeRecovery(@ModelAttribute("passwordResetInfo") PasswordResetInfo passwordResetInfo, BindingResult result, ModelMap map, HttpServletRequest request) {

        if("true".equalsIgnoreCase(captchaOn)) {
            if (request.getParameter("g-recaptcha-response") != null) {
                if (!request.getParameter("g-recaptcha-response").isEmpty()) {
                    String ip = request.getHeader("X-Real-IP");
                    if (ip == null) {
                        ip = request.getRemoteAddr();
                    }
                    try {
                        String captchaTestParams = "secret=" + captchaSecret + "&response=" + request.getParameter("g-recaptcha-response") + "&remoteip=" + ip;

                        JsonElement capchaRequest = OddeyeHttpURLConnection.getPostJSON("https://www.google.com/recaptcha/api/siteverify", captchaTestParams);
                        if (capchaRequest.getAsJsonObject().get("success") == null) {
                            result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                        } else {
                            if (!capchaRequest.getAsJsonObject().get("success").getAsBoolean()) {
                                result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                            }
                        }
                    } catch (Exception ex) {
                        result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }

                } else {
                    result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
                }
            } else {
                result.rejectValue("recaptcha", "recaptcha.notValid", "Please complete the CAPTCHA to complete your registration.");
            }
        }
        if (result.hasErrors()) {
            setLocaleInfo(map);
            map.put("passwordResetInfo", passwordResetInfo);
            map.put("result", result);
            map.put("body", "psreset");
            map.put("jspart", "psresetjs");
        } else {
            try {
//                String baseUrl = mailSender.getBaseurl(request);
//                if (wl != null) {
//                    user.setWhitelabel(wl);
//                    user.addAuthoritie(OddeyeUserModel.ROLE_WHITELABEL_USER);
//                    user.SendWlAdminMail("User Signed in wl", mailSender, wl.getOwner().getEmail());
//                    user.SendWLConfirmMail(mailSender, baseUrl, wl.getOwner().getEmail());
//                }
//                if (wl == null) {                    
//                    user.SendConfirmMail(mailSender, baseUrl);
//                }
//
//                user.SendAdminMail("User Signed", mailSender);
//                user.addAuthoritie(OddeyeUserModel.ROLE_USER);
//                user.setActive(Boolean.FALSE);
//                Userdao.addUser(user);
//                Userdao.saveSineUpCookes(user, request.getCookies());

//                return redirecttodashboard();
                map.put("body", "psrecoveryconfirm");
                map.put("jspart", "psrecoveryconfirmjs");
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
                map.put("passwordResetInfo", passwordResetInfo);
                map.put("result", result);
                map.put("body", "psrecovery");
                map.put("jspart", "psrecoveryjs");
                map.put("message", ex.toString());
            }
        }
        map.put("title", messageSource.getMessage("title.signUp", new String[]{""}, LocaleContextHolder.getLocale()));
//      map.put("title", "Sign Up");
        return "indexPrime";
        //else
    }      
    
   @RequestMapping(value = "/psreset/{token}", method = RequestMethod.GET)
    public String passwordReset(@PathVariable(value = "token") String token, ModelMap map, HttpServletRequest request) {
        try {
            final ResetInfo ri = passwordResetTokenEncoder.validateToken(token);
            if(!passwordResetTokenEncoder.validateToken(token).getStatus())
                return "redirect:/login";
            map.put("resetInfo", ri);
            PasswordResetInfo passwordResetInfo = new PasswordResetInfo();
            passwordResetInfo.setEmail(ri.getEmail());
            passwordResetInfo.setUserName(ri.getUserModel().getName());            
            map.put("passwordResetInfo", passwordResetInfo);
            map.put("title", "psreset");
            map.put("slug", "psreset");
            map.put("body", "psreset");
            map.put("jspart", "psresetjs");

            setLocaleInfo(map);
            
            return "indexPrime";
         }
        catch(Exception e){
            return "redirect:/login";
        }
    }
}
