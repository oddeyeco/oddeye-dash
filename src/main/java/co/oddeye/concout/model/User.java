/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.helpers.mailSender;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;
import java.util.UUID;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.util.Bytes;

/**
 *
 * @author vahan
 */
public class User {

    private UUID id;
    private String lastname;
    private String name;
    private String email;
    private String company;
    private byte[] password;
    private byte[] passwordsecond;
    private byte[] solt = null;
    private String country;
    private String city;
    private String region;
    private String timezone;
    private Boolean active;

    public User() {
        this.id = UUID.randomUUID();
    }

    public void SendConfirmMail(mailSender Sender) {
        Sender.send("Confirm Email ", "Hello " + this.getName() + " " + this.getLastname() + "<br/>for Confirm Email click<br/> <a href='http://localhost:8080/OddeyeCoconut/confirm/" + this.getId().toString() + "'>hear</a>", "oddeye.co@gmail.com", this.getEmail());
    }

    /**
     * @return the id
     */
    public UUID getId() {
        return id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email the email to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @return the company
     */
    public String getCompany() {
        return company;
    }

    /**
     * @param company the company to set
     */
    public void setCompany(String company) {
        this.company = company;
    }

    /**
     * @return the country
     */
    public String getCountry() {
        return country;
    }

    /**
     * @param country the country to set
     */
    public void setCountry(String country) {
        this.country = country;
    }

    /**
     * @return the city
     */
    public String getCity() {
        return city;
    }

    /**
     * @param city the city to set
     */
    public void setCity(String city) {
        this.city = city;
    }

    /**
     * @return the region
     */
    public String getRegion() {
        return region;
    }

    /**
     * @param region the region to set
     */
    public void setRegion(String region) {
        this.region = region;
    }

    /**
     * @return the timezone
     */
    public String getTimezone() {
        return timezone;
    }

    /**
     * @param timezone the timezone to set
     */
    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }

    /**
     * @return the active
     */
    public Boolean getActive() {
        return active;
    }

    /**
     * @param active the active to set
     */
    public void setActive(Boolean active) {
        this.active = active;
    }

    private byte[] getNextSalt() {
        final Random r = new SecureRandom();
        byte[] salt = new byte[64];
        r.nextBytes(salt);
        return salt;
    }

    private byte[] get_SHA_512_SecurePassword(String passwordToHash, byte[] salt) {
        byte[] bytes = null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(salt);
            bytes = md.digest(passwordToHash.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return bytes;
    }

    /**
     * @return the lastname
     */
    public String getLastname() {
        return lastname;
    }

    /**
     * @param lastname the lastname to set
     */
    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        String pass = "";
        return pass;
    }

    public byte[] getPasswordByte() {
        return this.password;
    }

    public String getPasswordst() {
        String pass = "";
        if (this.password != null) {
            pass = new String(this.password);
        }
        return pass;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        if (this.getSolt() == null) {
            this.solt = getNextSalt();
        }
        this.password = get_SHA_512_SecurePassword(password, this.getSolt());
    }

    /**
     * @return the passwordsecond
     */
    public String getPasswordsecondst() {
        String pass = "";
        if (this.passwordsecond != null) {
            pass = new String(this.passwordsecond);
        }
        return pass;
    }

    public String getPasswordsecond() {
        String pass = "";
        return pass;
    }

    /**
     * @param passwordsecond the passwordsecond to set
     */
    public void setPasswordsecond(String passwordsecond) {
        if (this.getSolt() == null) {
            this.solt = getNextSalt();
        }
        this.passwordsecond = get_SHA_512_SecurePassword(passwordsecond, this.getSolt());
    }

    /**
     * @return the solt
     */
    public byte[] getSolt() {
        return solt;
    }

    public void inituser(Result result) {
        byte[] value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("UUID"));
        this.id = UUID.fromString(Bytes.toString(value));
        value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("email"));
        this.email = Bytes.toString(value);
        value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("name"));
        this.name = Bytes.toString(value);
        value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("lastname"));
        this.lastname = Bytes.toString(value);
        value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("company"));
        this.company = Bytes.toString(value);    
        value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("country"));
        this.country = Bytes.toString(value);
        value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("city"));
        this.city = Bytes.toString(value);
        value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("region"));
        this.region = Bytes.toString(value);    
        value = result.getValue(Bytes.toBytes("technicalinfo"), Bytes.toBytes("timezone"));
        this.timezone = Bytes.toString(value);
        value = result.getValue(Bytes.toBytes("technicalinfo"), Bytes.toBytes("active"));
        this.active = Bytes.toBoolean(value);      
    }

}
