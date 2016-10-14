/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.helpers.mailSender;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.UUID;
import org.hbase.async.KeyValue;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

/**
 *
 * @author vahan
 */

public class User implements UserDetails {
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
    private final Set<GrantedAuthority> authorities;
//    private OddeeyMetricMetaList Tags;
    private ConcoutMetricMetaList MetricsMeta;
    private final Set<String> Allkeys;
    
    private Map<String, String> DushList;

    public User() {
        this.id = UUID.randomUUID();
        this.authorities = null;
        this.MetricsMeta = null;
        this.Allkeys = null;
    }

    @Override
    public boolean isEnabled() {
        return this.active;
    }

    @Override
    public boolean isAccountNonExpired() {
        return this.active;
    }

    @Override
    public boolean isAccountNonLocked() {
        return this.active;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return this.active;

    }

    @Override
    public String getUsername() {
        return this.email;
    }

    @Override
    public Collection<GrantedAuthority> getAuthorities() {
        return this.authorities;
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

    static public byte[] get_SHA_512_SecurePassword(String passwordToHash, byte[] salt) {
        byte[] bytes = null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(salt);
            bytes = md.digest(passwordToHash.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
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
    @Override
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

//    public void inituser(List<GrantedAuthority> result,Collection<? extends GrantedAuthority> authorities) {           
//                
//    }
    /**
     * @return the Tags
     */
//    public OddeeyMetricMetaList getTags() {
//        return Tags;
//    }
//    public Map<String, MetaTags> getMetrics() {
//        return this.Tags.get("metrics");
//    }
//
//    public Map<String, MetaTags> getTags() {
//        return this.Tags.get("tagks");
//    }
//
//    public Map<String, MetaTags> getTagsValues() {
//        return this.Tags.get("tagvs");
//    }
    /**
     * @param Tags the Tags to set
     */
//    public void setTags(OddeeyMetricMetaList Tags) {
//        this.Tags = Tags;
//    }
    public void inituser(ArrayList<KeyValue> userkvs, List<GrantedAuthority> grantedAuths) {

        for (KeyValue property : userkvs) {
            if (Arrays.equals(property.qualifier(), "UUID".getBytes())) {
                this.id = UUID.fromString(new String(property.value()));
            }
            if (Arrays.equals(property.qualifier(), "email".getBytes())) {
                this.email = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "name".getBytes())) {
                this.name = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "lastname".getBytes())) {
                this.lastname = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "company".getBytes())) {
                this.company = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "country".getBytes())) {
                this.country = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "city".getBytes())) {
                this.city = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "region".getBytes())) {
                this.region = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "timezone".getBytes())) {
                this.timezone = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "active".getBytes())) {
                this.active = property.value()[0] != (byte) 0;
            }

        }
    }

    /**
     * @return the MetricsMeta
     */
    public ConcoutMetricMetaList getMetricsMeta() {
        
        return MetricsMeta;
    }

    /**
     * @param MetricsMeta the MetricsMeta to set
     */
    public void setMetricsMeta(ConcoutMetricMetaList MetricsMeta) {
        this.MetricsMeta = MetricsMeta;
//        MetricsMeta.equals(id)
    }

    /**
     * @return the DushList
     */
    public Map<String, String> getDushList() {
        return DushList;
    }

    /**
     * @param DushList the DushList to set
     */
    public void setDushList(Map<String, String> DushList) {
        this.DushList = DushList;
    }
    
    /**
     * @param DushName
     * @param DushInfo
     * @return the DushList
     */
    public Map<String, String> addDush(String DushName, String DushInfo,HbaseUserDao Userdao) {
        DushList.put(DushName, DushInfo);
        Userdao.saveDush(id, DushName, DushInfo);
        return DushList;
    }
    

}
