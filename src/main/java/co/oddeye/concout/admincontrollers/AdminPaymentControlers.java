/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.dao.HbasePaymentDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyePayModel;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.model.WhitelabelModel;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonObject;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.datetime.DateFormatter;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class AdminPaymentControlers extends GRUDControler {

    @Autowired
    private HbasePaymentDao PaymentDao;
    @Autowired
    private HbaseUserDao Userdao;

    protected static final Logger LOGGER = LoggerFactory.getLogger(AdminPaymentControlers.class);

    public AdminPaymentControlers() {
        AddViewConfig("first_name", new HashMap<String, Object>() {
            {
                put("path", "first_name");
                put("title", "adminlist.firstName");
                put("type", "String");
            }
        }).AddViewConfig("user", new HashMap<String, Object>() {
            {
                put("path", "user");
                put("title", "adminlist.user");
                put("type", "Object");
                put("display", "email");

            }
        }).AddViewConfig("payer_email", new HashMap<String, Object>() {
            {
                put("path", "payer_email");
                put("title", "adminlist.payerEmail");
                put("type", "String");

            }
        }).AddViewConfig("payment_date", new HashMap<String, Object>() {
            {
                put("path", "payment_date");
                put("title", "adminlist.date");
                put("type", "Date");
                put("displayclass", "orderdesc");
            }
        }).AddViewConfig("payment_gross", new HashMap<String, Object>() {
            {
                put("path", "payment_gross");
                put("title", "adminlist.paymentGross");
                put("type", "Double");
            }
        }).AddViewConfig("payment_fee", new HashMap<String, Object>() {
            {
                put("path", "payment_fee");
                put("title", "adminlist.paymentFee");
                put("type", "Double");
            }
        }).AddViewConfig("mc_currency", new HashMap<String, Object>() {
            {
                put("path", "mc_currency");
                put("title", "adminlist.currency");
                put("type", "String");
            }
        }).AddViewConfig("points", new HashMap<String, Object>() {
            {
                put("path", "points");
                put("title", "adminlist.points");
                put("type", "Double");
            }
        });

        AddEditConfig("user", new HashMap<String, Object>() {
            {
                put("path", "user");
                put("title", "adminlist.user");
                put("type", "Select");
                put("items", null);

            }
        }).AddEditConfig("payment_gross", new HashMap<String, Object>() {
            {
                put("path", "payment_gross");
                put("title", "adminlist.paymentGross");
                put("type", "String");
            }
        }).AddEditConfig("payment_fee", new HashMap<String, Object>() {
            {
                put("path", "payment_fee");
                put("title", "adminlist.paymentFee");
                put("type", "String");
            }
        }).AddEditConfig("points", new HashMap<String, Object>() {
            {
                put("path", "points");
                put("title", "adminlist.points");
                put("type", "Double");
            }
        }).AddEditConfig("actions", new HashMap<String, Object>() {
            {
                put("path", "actions");
                put("title", "adminlist.actions");
                put("type", "actions");
            }
        });

    }

    @RequestMapping(value = "/paymentslist", method = RequestMethod.GET)
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

        map.put("modellist", PaymentDao.getAllPay());
        map.put("configMap", getViewConfig());
        map.put("body", "adminlist");
        map.put("path", "payment");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "/payment/new", method = RequestMethod.GET)
    public String newPayment(ModelMap map, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
            map.put("curentuser", userDetails);
            map.put("isAuthentication", true);
        } else {
            map.put("isAuthentication", false);
        }

        Map<String, String> users = new HashMap<>();
        for (OddeyeUserModel tuser : Userdao.getAllUsers(true)) {
            users.put(tuser.getId().toString(), tuser.getEmail());
        }

        ((HashMap<String, Object>) getEditConfig().get("user")).put("items", users);

        OddeyePayModel model = new OddeyePayModel();
        map.put("model", model);
        //Userdao.getAllUsers() 
        map.put("configMap", getEditConfig());
        map.put("modelname", "payment");
        map.put("path", "payment");
        map.put("body", "adminedit");
        map.put("jspart", "adminjs");
        return "index";
    }

    @RequestMapping(value = "/payment/edit/{id}", method = RequestMethod.POST)
    public String edit(@ModelAttribute("model") OddeyePayModel payment, BindingResult result, ModelMap map, HttpServletRequest request, HttpServletResponse response) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", userDetails);
                map.put("isAuthentication", true);
                String act = request.getParameter("act");
                JsonObject Jsonchangedata = new JsonObject();

//                if (act.equals("Delete")) {
//                    Whitelabeldao.delete(newWL);
//                    return "redirect:/whitelable/list";
//                }
                if (act.equals("Save")) {
                    Jsonchangedata.addProperty("custom", payment.getUser().getId().toString());
                    Date date =new Date();
                    DateFormat format = new SimpleDateFormat("HH:mm:ss MMM d, yyyy z");                    
                    Jsonchangedata.addProperty("payment_date", format.format(date));
                    
                    payment.setJson(Jsonchangedata);
                    payment.setIpn_track_id(payment.getId());
                    payment.setPoints(payment.getPayment_gross());
                    payment.getUser().setBalance(payment.getUser().getBalance() + payment.getPoints());
                    Userdao.saveField(payment.getUser(), "balance");                    
                    
                    PaymentDao.addRow(payment);
                    map.put("configMap", getEditConfig());
                    map.put("path", "payment");
                    map.put("modelname", "payment");
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
