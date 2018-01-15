/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyePayModel;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.OddeyeHttpURLConnection;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonObject;
import java.util.Map;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
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
public class PaymentController {

    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(PaymentController.class);
    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Value("${paypal.url}")
    private String paypal_url;

    @Value("${barlus.url}")
    private String barlus_url;
    @Value("${barlus.uuids}")
    private String barlus_uuids;

    @Value("${paypal.percent}")
    private String paypal_percent;
    @Value("${paypal.fix}")
    private String paypal_fix;

    @Autowired
    private HbaseUserDao Userdao;

    @RequestMapping(value = "/paypal/ipn/", method = RequestMethod.POST)
    public String paypalipn(ModelMap map, HttpServletRequest request, HttpServletResponse response) {
//        String paypal_url = "https://www.sandbox.paypal.com/cgi-bin/websc";
        //String paypal_url = "https://www.paypal.com/cgi-bin/websc";        
        String req = "cmd=_notify-validate";
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Map<String, String[]> postdata = request.getParameterMap();
        for (Map.Entry<String, String[]> dd : postdata.entrySet()) {
            req = req + "&" + dd.getKey() + "=" + dd.getValue()[0];
        }
        boolean isvalid = false;
        JsonObject jsonResult = new JsonObject();
        try {
            String data = OddeyeHttpURLConnection.getPost(paypal_url, req);
            isvalid = data.equals("VERIFIED");
            if (isvalid) {
                OddeyeUserModel user = Userdao.getUserByUUID(UUID.fromString(postdata.get("custom")[0]), true);
                OddeyePayModel pay = new OddeyePayModel(postdata, user, paypal_percent, paypal_fix);
                if (Userdao.isPaymentNew(user, pay)) {
                    Userdao.addPayment(user, pay);
                    user.setBalance(user.getBalance() + pay.getPoints());
                    Userdao.saveField(user, "balance");

                }

                //TODO Write paymants to DB
                jsonResult.add("data", pay.getJson());
            }
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        map.put("jsonmodel", jsonResult);

        return "ajax";
    }
}
