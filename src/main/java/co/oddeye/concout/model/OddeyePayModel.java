/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.annotation.HbaseColumn;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import java.io.Serializable;
import java.nio.ByteBuffer;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;
import java.util.UUID;
import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;

/**
 *
 * @author vahan
 */
public class OddeyePayModel implements Serializable, IHbaseModel {

    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(OddeyePayModel.class);

    private String id;
    
    private String transaction_subject;
    private Date payment_date;
    private String txn_type;
    private String last_name;
    private String residence_country;
    private String item_name;
    @HbaseColumn(qualifier = "Payment_gross", family = "c")
    private double payment_gross; 
    @HbaseColumn(qualifier = "Mc_currency", family = "c")
    private String mc_currency; 
    private String business;
    private String payment_type;
    private String protection_eligibility;
    private String verify_sign;
    private String payer_status;
    private String test_ipn;
    @HbaseColumn(qualifier = "Payer_email", family = "c")
    private String payer_email; 
    private String txn_id;
    private double quantity;
    @HbaseColumn(qualifier = "Points", family = "c")
    private double points; 
    private String receiver_email;
    @HbaseColumn(qualifier = "First_name", family = "c")
    private String first_name; //First_name
    private String payer_id;
    private String receiver_id;
    private String item_number;
    private String payment_status;
    @HbaseColumn(qualifier = "Payment_fee", family = "c")
    private double payment_fee; 
    @HbaseColumn(qualifier = "Mc_fee", family = "c")
    private double mc_fee; 
    @HbaseColumn(qualifier = "Mc_gross", family = "c")
    private double mc_gross; 
    private String custom;
    private String charset;
    private String notify_version;
    @HbaseColumn(qualifier = "Ipn_track_id", family = "c")
    private String ipn_track_id;
    private OddeyeUserModel user;
    @HbaseColumn(qualifier = "fulljson", family = "c")
    private JsonElement json; 

    public OddeyePayModel() {
        id = UUID.randomUUID().toString();
    }
    
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
                payer_email = new String(kv.value());
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

    /**
     * @param ipn_track_id the ipn_track_id to set
     */
    public void setIpn_track_id(String ipn_track_id) {
        this.ipn_track_id = ipn_track_id;
    }
    
    /**
     * @param payment_fee the payment_fee to set
     */
    public void setPayment_fee(double payment_fee) {
        this.payment_fee = payment_fee;
    }

    /**
     * @param payment_gross the payment_gross to set
     */
    public void setPayment_gross(double payment_gross) {
        this.payment_gross = payment_gross;
    }

    /**
     * @param user the user to set
     */
    public void setUser(OddeyeUserModel user) {
        this.user = user;
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }    

    /**
     * @param transaction_subject the transaction_subject to set
     */
    public void setTransaction_subject(String transaction_subject) {
        this.transaction_subject = transaction_subject;
    }

    /**
     * @param payment_date the payment_date to set
     */
    public void setPayment_date(Date payment_date) {
        this.payment_date = payment_date;
    }

    /**
     * @param txn_type the txn_type to set
     */
    public void setTxn_type(String txn_type) {
        this.txn_type = txn_type;
    }

    /**
     * @param last_name the last_name to set
     */
    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }

    /**
     * @param residence_country the residence_country to set
     */
    public void setResidence_country(String residence_country) {
        this.residence_country = residence_country;
    }

    /**
     * @param item_name the item_name to set
     */
    public void setItem_name(String item_name) {
        this.item_name = item_name;
    }

    /**
     * @param mc_currency the mc_currency to set
     */
    public void setMc_currency(String mc_currency) {
        this.mc_currency = mc_currency;
    }

    /**
     * @param business the business to set
     */
    public void setBusiness(String business) {
        this.business = business;
    }

    /**
     * @param payment_type the payment_type to set
     */
    public void setPayment_type(String payment_type) {
        this.payment_type = payment_type;
    }

    /**
     * @param protection_eligibility the protection_eligibility to set
     */
    public void setProtection_eligibility(String protection_eligibility) {
        this.protection_eligibility = protection_eligibility;
    }

    /**
     * @param verify_sign the verify_sign to set
     */
    public void setVerify_sign(String verify_sign) {
        this.verify_sign = verify_sign;
    }

    /**
     * @param test_ipn the test_ipn to set
     */
    public void setTest_ipn(String test_ipn) {
        this.test_ipn = test_ipn;
    }

    /**
     * @param payer_email the payer_email to set
     */
    public void setPayer_email(String payer_email) {
        this.payer_email = payer_email;
    }

    /**
     * @param txn_id the txn_id to set
     */
    public void setTxn_id(String txn_id) {
        this.txn_id = txn_id;
    }

    /**
     * @param quantity the quantity to set
     */
    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    /**
     * @param points the points to set
     */
    public void setPoints(double points) {
        this.points = points;
    }

    /**
     * @param receiver_email the receiver_email to set
     */
    public void setReceiver_email(String receiver_email) {
        this.receiver_email = receiver_email;
    }

    /**
     * @param first_name the first_name to set
     */
    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }

    /**
     * @param payer_id the payer_id to set
     */
    public void setPayer_id(String payer_id) {
        this.payer_id = payer_id;
    }

    /**
     * @param receiver_id the receiver_id to set
     */
    public void setReceiver_id(String receiver_id) {
        this.receiver_id = receiver_id;
    }

    /**
     * @param item_number the item_number to set
     */
    public void setItem_number(String item_number) {
        this.item_number = item_number;
    }

    /**
     * @param payment_status the payment_status to set
     */
    public void setPayment_status(String payment_status) {
        this.payment_status = payment_status;
    }

    /**
     * @param mc_fee the mc_fee to set
     */
    public void setMc_fee(double mc_fee) {
        this.mc_fee = mc_fee;
    }

    /**
     * @param mc_gross the mc_gross to set
     */
    public void setMc_gross(double mc_gross) {
        this.mc_gross = mc_gross;
    }

    /**
     * @param custom the custom to set
     */
    public void setCustom(String custom) {
        this.custom = custom;
    }

    /**
     * @param charset the charset to set
     */
    public void setCharset(String charset) {
        this.charset = charset;
    }

    /**
     * @param notify_version the notify_version to set
     */
    public void setNotify_version(String notify_version) {
        this.notify_version = notify_version;
    }

    /**
     * @param json the json to set
     */
    public void setJson(JsonElement json) {
        this.json = json;
    }
}
