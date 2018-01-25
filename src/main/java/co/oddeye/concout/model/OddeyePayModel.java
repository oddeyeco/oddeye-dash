/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import java.nio.ByteBuffer;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;

/**
 *
 * @author vahan
 */
public class OddeyePayModel {

    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(OddeyePayModel.class);

    private String transaction_subject;
    private Date payment_date;
    private String txn_type;
    private String last_name;
    private String residence_country;
    private String item_name;
    private double payment_gross;
    private String mc_currency;
    private String business;
    private String payment_type;
    private String protection_eligibility;
    private String verify_sign;
    private String payer_status;
    private String test_ipn;
    private String payer_email;
    private String txn_id;
    private double quantity;
    private double points;
    private String receiver_email;
    private String first_name;
    private String payer_id;
    private String receiver_id;
    private String item_number;
    private String payment_status;
    private double payment_fee;
    private double mc_fee;
    private double mc_gross;
    private String custom;
    private String charset;
    private String notify_version;
    private String ipn_track_id;
    private OddeyeUserModel user;
    private JsonElement json;

    public OddeyePayModel(Map<String, String[]> postdata, OddeyeUserModel _user, String paypal_percent, String paypal_fix) {
        try {
            Gson gson = globalFunctions.getGson();
            json = gson.toJsonTree(postdata);
            user = _user;
            transaction_subject = postdata.get("transaction_subject")[0];
            DateFormat format = new SimpleDateFormat("HH:mm:ss MMM d, yyyy z");
            payment_date = format.parse(postdata.get("payment_date")[0]);
            txn_type = postdata.get("txn_type")[0];
            last_name = postdata.get("last_name")[0];
            residence_country = postdata.get("residence_country")[0];
            item_name = postdata.get("item_name")[0];
            payment_gross = Double.parseDouble(postdata.get("payment_gross")[0]);
            mc_currency = postdata.get("mc_currency")[0];
            business = postdata.get("business")[0];
            payment_type = postdata.get("payment_type")[0];
            protection_eligibility = postdata.get("protection_eligibility")[0];
            verify_sign = postdata.get("verify_sign")[0];
            payer_status = postdata.get("payer_status")[0];
            if (postdata.get("test_ipn") != null) {
                test_ipn = postdata.get("test_ipn")[0];
            }
            payer_email = postdata.get("payer_email")[0];
            txn_id = postdata.get("txn_id")[0];
            quantity = Double.parseDouble(postdata.get("quantity")[0]);

            receiver_email = postdata.get("receiver_email")[0];
            first_name = postdata.get("first_name")[0];
            payer_id = postdata.get("payer_id")[0];
            receiver_id = postdata.get("receiver_id")[0];
            item_number = postdata.get("item_number")[0];
            payment_status = postdata.get("payment_status")[0];
            payment_fee = Double.parseDouble(postdata.get("payment_fee")[0]);
            mc_fee = Double.parseDouble(postdata.get("mc_fee")[0]);
            mc_gross = Double.parseDouble(postdata.get("mc_gross")[0]);
            custom = postdata.get("custom")[0];
            charset = postdata.get("charset")[0];
            notify_version = postdata.get("notify_version")[0];
            ipn_track_id = postdata.get("ipn_track_id")[0];

//            points = (mc_gross - Double.parseDouble(paypal_fix)) / (1 + Double.parseDouble(paypal_percent) / 100);
            points = mc_gross;
        } catch (ParseException ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }

    public OddeyePayModel(ArrayList<KeyValue> row, HbaseUserDao Userdao) {
        for (KeyValue kv : row) {
            if (Arrays.equals(kv.qualifier(), "Ipn_track_id".getBytes())) {
                ipn_track_id = new String(kv.value());
            }
            if (Arrays.equals(kv.qualifier(), "First_name".getBytes())) {
                first_name = new String(kv.value());
            }

            if (Arrays.equals(kv.qualifier(), "Mc_currency".getBytes())) {
                mc_currency = new String(kv.value());
            }

            if (Arrays.equals(kv.qualifier(), "Mc_gross".getBytes())) {
                mc_gross = ByteBuffer.wrap(kv.value()).getDouble();
            }

            if (Arrays.equals(kv.qualifier(), "Mc_fee".getBytes())) {
                mc_fee = ByteBuffer.wrap(kv.value()).getDouble();
            }

            if (Arrays.equals(kv.qualifier(), "Payment_gross".getBytes())) {
                payment_gross = ByteBuffer.wrap(kv.value()).getDouble();
            }

            if (Arrays.equals(kv.qualifier(), "Payment_fee".getBytes())) {
                payment_fee = ByteBuffer.wrap(kv.value()).getDouble();
            }

            if (Arrays.equals(kv.qualifier(), "Points".getBytes())) {
                points = ByteBuffer.wrap(kv.value()).getDouble();
            }

            if (Arrays.equals(kv.qualifier(), "Payer_email".getBytes())) {
                mc_currency = new String(kv.value());
            }

            if (Arrays.equals(kv.qualifier(), "fulljson".getBytes())) {

                String str = new String(kv.value());
                JsonParser gson = new JsonParser();
                json = gson.parse(str);
                user = Userdao.getUserByUUID(json.getAsJsonObject().get("custom").getAsString());
                try {
                    DateFormat format = new SimpleDateFormat("HH:mm:ss MMM d, yyyy z");

                    payment_date = format.parse(json.getAsJsonObject().get("payment_date").getAsString());
                } catch (ParseException ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }
            }

        }
    }

    /**
     * @return the transaction_subject
     */
    public String getTransaction_subject() {
        return transaction_subject;
    }

    /**
     * @return the payment_date
     */
    public Date getPayment_date() {
        return payment_date;
    }

    /**
     * @return the txn_type
     */
    public String getTxn_type() {
        return txn_type;
    }

    /**
     * @return the last_name
     */
    public String getLast_name() {
        return last_name;
    }

    /**
     * @return the residence_country
     */
    public String getResidence_country() {
        return residence_country;
    }

    /**
     * @return the item_name
     */
    public String getItem_name() {
        return item_name;
    }

    /**
     * @return the payment_gross
     */
    public double getPayment_gross() {
        return payment_gross;
    }

    /**
     * @return the mc_currency
     */
    public String getMc_currency() {
        return mc_currency;
    }

    /**
     * @return the business
     */
    public String getBusiness() {
        return business;
    }

    /**
     * @return the payment_type
     */
    public String getPayment_type() {
        return payment_type;
    }

    /**
     * @return the protection_eligibility
     */
    public String getProtection_eligibility() {
        return protection_eligibility;
    }

    /**
     * @return the verify_sign
     */
    public String getVerify_sign() {
        return verify_sign;
    }

    /**
     * @return the payer_status
     */
    public String getPayer_status() {
        return payer_status;
    }

    /**
     * @return the test_ipn
     */
    public String getTest_ipn() {
        return test_ipn;
    }

    /**
     * @return the payer_email
     */
    public String getPayer_email() {
        return payer_email;
    }

    /**
     * @return the txn_id
     */
    public String getTxn_id() {
        return txn_id;
    }

    /**
     * @return the quantity
     */
    public double getQuantity() {
        return quantity;
    }

    /**
     * @return the receiver_email
     */
    public String getReceiver_email() {
        return receiver_email;
    }

    /**
     * @return the first_name
     */
    public String getFirst_name() {
        return first_name;
    }

    /**
     * @return the payer_id
     */
    public String getPayer_id() {
        return payer_id;
    }

    /**
     * @return the receiver_id
     */
    public String getReceiver_id() {
        return receiver_id;
    }

    /**
     * @return the item_number
     */
    public String getItem_number() {
        return item_number;
    }

    /**
     * @return the payment_status
     */
    public String getPayment_status() {
        return payment_status;
    }

    /**
     * @return the payment_fee
     */
    public double getPayment_fee() {
        return payment_fee;
    }

    /**
     * @return the mc_fee
     */
    public double getMc_fee() {
        return mc_fee;
    }

    /**
     * @return the mc_gross
     */
    public double getMc_gross() {
        return mc_gross;
    }

    /**
     * @return the custom
     */
    public String getCustom() {
        return custom;
    }

    /**
     * @return the charset
     */
    public String getCharset() {
        return charset;
    }

    /**
     * @return the notify_version
     */
    public String getNotify_version() {
        return notify_version;
    }

    /**
     * @return the ipn_track_id
     */
    public String getIpn_track_id() {
        return ipn_track_id;
    }

    /**
     * @return the points
     */
    public double getPoints() {
        return points;
    }

    /**
     * @return the json
     */
    public JsonElement getJson() {
        return json;
    }

    /**
     * @return the user
     */
    public OddeyeUserModel getUser() {
        return user;
    }
}
