/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import co.oddeye.concout.dao.HbasePaymentDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
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

    protected static final Logger LOGGER = LoggerFactory.getLogger(AdminPaymentControlers.class);

    public AdminPaymentControlers() {
        AddViewConfig("first_name", new HashMap<String, Object>() {
            {
                put("path", "first_name");
                put("title", "first_name");
                put("type", "String");
            }
        }).AddViewConfig("user", new HashMap<String, Object>() {
            {
                put("path", "user");
                put("title", "User");
                put("type", "Object");
                put("display", "email");

            }
        }).AddViewConfig("payer_email", new HashMap<String, Object>() {
            {
                put("path", "payer_email");
                put("title", "Payer email");
                put("type", "String");                

            }
        }).AddViewConfig("payment_date", new HashMap<String, Object>() {
            {
                put("path", "payment_date");
                put("title", "Date");
                put("type", "Date");
            }
        }).AddViewConfig("payment_gross", new HashMap<String, Object>() {
            {
                put("path", "payment_gross");
                put("title", "Payment gross");
                put("type", "Double");
            }
        }).AddViewConfig("payment_fee", new HashMap<String, Object>() {
            {
                put("path", "payment_fee");
                put("title", "Payment fee");
                put("type", "Double");
            }
        }).AddViewConfig("mc_currency", new HashMap<String, Object>() {
            {
                put("path", "mc_currency");
                put("title", "Currency");
                put("type", "String");
            }
        }).AddViewConfig("points", new HashMap<String, Object>() {
            {
                put("path", "points");
                put("title", "points");
                put("type", "Double");
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
        map.put("path", "user");
        map.put("jspart", "adminjs");
        return "index";
    }


}
