/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.core.AlertLevel;
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
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import java.util.function.Function;
import javax.persistence.Id;
import org.apache.commons.codec.binary.Hex;
import org.hbase.async.Bytes;
import org.hbase.async.KeyValue;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

/**
 *
 * @author vahan
 */
public class User implements UserDetails {

    public final static String ROLE_ADMIN = "ROLE_ADMIN";
    public final static String ROLE_USER = "ROLE_USER";
    public final static String ROLE_SUPERADMIN = "ROLE_SUPERADMIN";
    public final static String ROLE_READONLY_ADMIN = "ROLE_READONLY_ADMIN";
    public final static String ROLE_READONLY = "ROLE_READONLY";
    public final static String ROLE_DELETE = "ROLE_DELETE";

    @Id
    private UUID id;
    private String lastname;
    private String name;
    private String email;
    private String company;
    private byte[] password;
    private byte[] passwordsecond;
    private byte[] oldpassword;
    private byte[] solt = null;
    private String country;
    private String city;
    private String region;
    private String timezone;

    private byte[] TsdbID;
    private String StTsdbID;
    private Boolean active;
    private final Collection<GrantedAuthority> authorities;
    private ConcoutMetricMetaList MetricsMetas;
    private Map<String, String> DushList;
    private Map<String, String> FiltertemplateList = new HashMap<>();
    ;

    private final AlertLevel AlertLevels = new AlertLevel();

    public User() {
        this.id = UUID.randomUUID();
        this.authorities = new ArrayList<>();
        this.MetricsMetas = null;
    }

    // Developet metods
    public void SendConfirmMail(mailSender Sender, String uri) throws UnsupportedEncodingException {
        Sender.send("Confirm Email ", "Hello " + this.getName() + " " + this.getLastname() + "<br/>for Confirm Email click<br/> <a href='" + uri + "/confirm/" + this.getId().toString() + "'>hear</a>", this.getEmail());
    }

    public void inituser(ArrayList<KeyValue> userkvs) {

        userkvs.stream().map((property) -> {
            if (Arrays.equals(property.qualifier(), "UUID".getBytes())) {
                this.id = UUID.fromString(new String(property.value()));
            }
            return property;
        }).map((property) -> {
            if (Arrays.equals(property.qualifier(), "email".getBytes())) {
                this.email = new String(property.value());
            }
            return property;
        }).map((property) -> {
            if (Arrays.equals(property.qualifier(), "name".getBytes())) {
                this.name = new String(property.value());
            }
            return property;
        }).map((property) -> {
            if (Arrays.equals(property.qualifier(), "lastname".getBytes())) {
                this.lastname = new String(property.value());
            }
            return property;
        }).map((property) -> {
            if (Arrays.equals(property.qualifier(), "company".getBytes())) {
                this.company = new String(property.value());
            }
            return property;
        }).map((property) -> {
            if (Arrays.equals(property.qualifier(), "country".getBytes())) {
                this.country = new String(property.value());
            }
            return property;
        }).map((property) -> {
            if (Arrays.equals(property.qualifier(), "city".getBytes())) {
                this.city = new String(property.value());
            }
            return property;
        }).map((property) -> {
            if (Arrays.equals(property.qualifier(), "region".getBytes())) {
                this.region = new String(property.value());
            }
            return property;
        }).map((KeyValue property) -> {
            if ((Arrays.equals(property.qualifier(), "timezone".getBytes()))) {
                if ((Arrays.equals(property.family(), "personalinfo".getBytes()))) {
                    this.timezone = new String(property.value());
                } else {
                    if (this.timezone == null) {
                        this.timezone = new String(property.value());
                    }
                }
            }
            return property;
        }).map((KeyValue property) -> {
            if (Arrays.equals(property.family(), "filtertemplates".getBytes())) {
                this.FiltertemplateList.put(new String(property.qualifier()), new String(property.value()));
            }
            return property;
        }).filter((property) -> (Arrays.equals(property.qualifier(), "active".getBytes()))).forEach((property) -> {
            if (property.value().length == 1) {
                this.active = property.value()[0] != (byte) 0;
            }
            if (property.value().length == 4) {
                this.active = Bytes.getInt(property.value()) != 0;
            }
        });

        authorities.add(new SimpleGrantedAuthority(ROLE_USER));
        if (this.email.equals("vahan_a@mail.ru")) {
            authorities.add(new SimpleGrantedAuthority(ROLE_ADMIN));
        }
    }

    /**
     * @param DushName
     * @param DushInfo
     * @param Userdao
     * @return the DushList
     */
    public Map<String, String> addDush(String DushName, String DushInfo, HbaseUserDao Userdao) {
        DushList.put(DushName, DushInfo);
        Userdao.saveDush(id, DushName, DushInfo);
        return DushList;
    }

    public Map<String, String> removeDush(String DushName, HbaseUserDao Userdao) {
        DushList.remove(DushName);
        Userdao.removeDush(id, DushName);
        return DushList;
    }

    public String getDush(String DushName) {
        return DushList.get(DushName);
    }

    /**
     * @param TsdbID the TsdbID to set
     */
    public void setTsdbID(byte[] TsdbID) {

        this.TsdbID = TsdbID;
        this.StTsdbID = Hex.encodeHexString(TsdbID);

    }

    public String getOldpassword() {
        String pass = "";
        return pass;
    }

    // Override metods
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return this.authorities;
    }

    @Override
    public String getPassword() {
        String pass = "";
        return pass;
    }

    @Override
    public String getUsername() {
        return this.email;
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
    public boolean isEnabled() {
        return this.active;
    }

    // Modified get sets
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

    // Standart get sets
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
     * @return the MetricsMetas
     */
    public ConcoutMetricMetaList getMetricsMeta() {

        return MetricsMetas;
    }

    /**
     * @param MetricsMeta the MetricsMetas to set
     */
    public void setMetricsMeta(ConcoutMetricMetaList MetricsMeta) {
        this.MetricsMetas = MetricsMeta;
//        MetricsMetas.equals(id)
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
     * @return the TsdbID
     */
    public byte[] getTsdbID() {
        return TsdbID;
    }

    /**
     * @return the StTsdbID
     */
    public String getStTsdbID() {
        return StTsdbID;
    }

    public Map<String, Object> updateBaseData(User newcurentuser) {
        Map<String, Object> updatesdata = new HashMap<>();
        if (!newcurentuser.getName().equals(this.name)) {
            this.name = newcurentuser.getName();
            updatesdata.put("name", newcurentuser.getName());
        }

        if (!newcurentuser.getLastname().equals(this.lastname)) {
            this.lastname = newcurentuser.getLastname();
            updatesdata.put("lastname", newcurentuser.getLastname());
        }
        if (!newcurentuser.getCompany().equals(this.company)) {
            this.company = newcurentuser.getCompany();
            updatesdata.put("company", newcurentuser.getCompany());
        }
        if (!newcurentuser.getCountry().equals(this.country)) {
            this.country = newcurentuser.getCountry();
            updatesdata.put("country", newcurentuser.getCountry());
        }
        if (!newcurentuser.getCity().equals(this.city)) {
            this.city = newcurentuser.getCity();
            updatesdata.put("city", newcurentuser.getCity());
        }
        if (!newcurentuser.getRegion().equals(this.region)) {
            this.region = newcurentuser.getRegion();
            updatesdata.put("region", newcurentuser.getRegion());
        }
        if (!newcurentuser.getTimezone().equals(this.timezone)) {
            this.timezone = newcurentuser.getTimezone();
            updatesdata.put("timezone", newcurentuser.getTimezone());
        }

        return updatesdata;
    }

    /**
     * @return the AlertLevels
     */
    public AlertLevel getAlertLevels() {
        return AlertLevels;
    }

    public void addFiltertemplate(String filtername, String filterinfo, HbaseUserDao Userdao) {
        FiltertemplateList.put(filtername, filterinfo);
        Userdao.saveFiltertemplate(id, filtername, filterinfo);
    }

    /**
     * @return the FiltertemplateList
     */
    public Map<String, String> getFiltertemplateList() {
        return FiltertemplateList;
    }

    public String getDefaultFilter() {
        if (FiltertemplateList.get("oddeye_base_def") != null) {
            return FiltertemplateList.get("oddeye_base_def");
        }
        return "{\"check_level_3\":\"on\",\"check_level_4\":\"on\",\"check_level_5\":\"on\"}";
    }

    /**
     * @param FiltertemplateList the FiltertemplateList to set
     */
    public void setFiltertemplateList(Map<String, String> FiltertemplateList) {
        this.FiltertemplateList = FiltertemplateList;
    }
    
    public String getEmailFilter() {
        if (FiltertemplateList.get("oddeye_base_send_email") != null) {
            return FiltertemplateList.get("oddeye_base_send_email");
        }
        return getDefaultFilter();
    }
    
    public String getTelegramFilter() {
        if (FiltertemplateList.get("oddeye_base_send_telegram") != null) {
            return FiltertemplateList.get("oddeye_base_send_telegram");
        }
        return getDefaultFilter();
    }    
}
