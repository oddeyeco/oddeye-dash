/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.annotation.HbaseColumn;
import co.oddeye.core.AlertLevel;
import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.core.ConsumptionList;
import co.oddeye.concout.core.PageInfo;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.helpers.OddeyeMailSender;
import co.oddeye.concout.providers.OddeyeKafkaDataListener;
import co.oddeye.concout.providers.UserConcurrentMessageListenerContainer;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import javax.servlet.http.Cookie;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.TreeMap;
import java.util.UUID;
import javax.persistence.Id;
import org.apache.commons.codec.binary.Hex;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.listener.ConcurrentMessageListenerContainer;
import org.springframework.kafka.listener.ContainerProperties;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

/**
 *
 * @author vahan
 */
public class OddeyeUserModel implements Serializable, IHbaseModel {
//    private transient HbaseUserDao Userdao;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(OddeyeUserModel.class);
    private static final long serialVersionUID = 465895478L;

    public final static String ROLE_ADMIN = "ROLE_ADMIN";
    public final static String ROLE_CONTENTMANAGER = "ROLE_CONTENTMANAGER";
    public final static String ROLE_USERMANAGER = "ROLE_USERMANAGER";
    public final static String ROLE_USER = "ROLE_USER";
    public final static String ROLE_SUPERADMIN = "ROLE_SUPERADMIN";
    public final static String ROLE_READONLY_ADMIN = "ROLE_READONLY_ADMIN";
    public final static String ROLE_READONLY = "ROLE_READONLY";
    public final static String ROLE_DELETE = "ROLE_DELETE";
    public final static String ROLE_EDIT = "ROLE_EDIT";
    public final static String ROLE_CAN_SWICH = "ROLE_CAN_SWICH";
    public final static String ROLE_WHITELABEL_OWNER = "ROLE_WHITELABEL_OWNER";
    public final static String ROLE_WHITELABEL_USER = "ROLE_WHITELABEL_USER";
    @Id
    @HbaseColumn(qualifier = "UUID", family = "personalinfo")
    private UUID id;
    @HbaseColumn(qualifier = "lastname", family = "personalinfo")
    private String lastname;
    @HbaseColumn(qualifier = "name", family = "personalinfo")
    private String name;
    @HbaseColumn(qualifier = "email", family = "personalinfo")
    private String email;
    @HbaseColumn(qualifier = "company", family = "personalinfo")
    private String company;
    @HbaseColumn(qualifier = "password", family = "technicalinfo", type = "password")
    private byte[] password;
    private byte[] passwordsecond;
    private String oldpassword;
    @HbaseColumn(qualifier = "solt", family = "technicalinfo")
    private byte[] solt = null;
    @HbaseColumn(qualifier = "country", family = "personalinfo")
    private String country;
    @HbaseColumn(qualifier = "city", family = "personalinfo")
    private String city;
    @HbaseColumn(qualifier = "region", family = "personalinfo")
    private String region;
    @HbaseColumn(qualifier = "timezone", family = "personalinfo")
    private String timezone;

    private byte[] TsdbID;
    private String StTsdbID;

    @HbaseColumn(qualifier = "unlimit", family = "technicalinfo")
    private Boolean unlimit = false;
    @HbaseColumn(qualifier = "active", family = "technicalinfo")
    private Boolean active;
    @HbaseColumn(qualifier = "firstlogin", family = "technicalinfo")
    private Boolean firstlogin;
    @HbaseColumn(qualifier = "mailconfirm", family = "technicalinfo")
    private Boolean mailconfirm;
    @HbaseColumn(qualifier = "balance", family = "technicalinfo")
    private Double balance;
    @HbaseColumn(qualifier = "alowswitch", family = "technicalinfo")
    private Boolean alowswitch;
    @HbaseColumn(qualifier = "template", family = "technicalinfo")
    private String template = "default";

    @HbaseColumn(qualifier = "whitelabelkey", family = "technicalinfo", identfield = "key")
    private WhitelabelModel whitelabel;

    @HbaseColumn(qualifier = "authorities", family = "technicalinfo", type = "collection")
    private Collection<GrantedAuthority> authorities;
    @HbaseColumn(qualifier = "*", family = "filtertemplates")
    private Map<String, String> FiltertemplateList = new HashMap<>();
    @HbaseColumn(qualifier = "AL", family = "technicalinfo")
    private AlertLevel AlertLevels;
    private transient OddeyeUserModel referal;
    @HbaseColumn(qualifier = "referal", family = "technicalinfo")
    private transient String sreferal;

    @HbaseColumn(family = "cookesinfo")
    private transient ArrayList<Cookie> cookies = new ArrayList<>();

    @HbaseColumn(qualifier = "UUID", family = "personalinfo", type = "timestamp")
    private Date sinedate;
    private ConcoutMetricMetaList MetricsMetas = new ConcoutMetricMetaList();
    private Map<String, String> DushList;
    private Map<String, String> OptionsList;

    private ConsumptionList consumptionList;
    private List<OddeyePayModel> paymentList;
    
    
    private Double consumption = 0d;
//    private OddeyeUserModel SwitchUser;

    private transient UserConcurrentMessageListenerContainer<Integer, String> listenerContainer;

    private transient final Map<String, Map<String, String[]>> sotokenlist = new HashMap<>();
    private transient final Map<String, Map<String, JsonObject>> sotokenJSON = new HashMap<>();
    private final Map<String, PageInfo> pagelist = new HashMap<>();
    private String recaptcha;

    public OddeyeUserModel() {
//        this.SwitchUser = null;
        this.id = UUID.randomUUID();
        this.authorities = new ArrayList<>();
//        this.MetricsMetas = null;
    }

    /**
     * @return the recaptcha
     */
    public String getRecaptcha() {
        return recaptcha;
    }

    /**
     * @param recaptcha the recaptcha to set
     */
    public void setRecaptcha(String recaptcha) {
        this.recaptcha = recaptcha;
    }

    public static Map<SimpleGrantedAuthority, String> getAllRoles() {
        final Map<SimpleGrantedAuthority, String> roles = new LinkedHashMap<>();
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_USER), "User");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_ADMIN), "Admin");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_CONTENTMANAGER), "Content manager");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_USERMANAGER), "User manager");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_SUPERADMIN), "Root");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_DELETE), "Can delete");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_EDIT), "Can Edit");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_CAN_SWICH), "Can Switch to users");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_WHITELABEL_OWNER), "White Label Owner");
        roles.put(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_WHITELABEL_USER), "White Label User");

        return roles;
    }

    public void SendWLConfirmMail(OddeyeMailSender Sender, String uri, String email) throws UnsupportedEncodingException {
        //        Sender.send("Confirm Email ", "Hello " + this.getName() + " " + this.getLastname() + "<br/>for Confirm Email click<br/> <a href='" + uri + "/confirm/" + this.getId().toString() + "'>hear</a>", this.getEmail());
        HashMap<String, String> model = new HashMap<>();
        model.put("userName", this.getName());
        model.put("userLastName", this.getLastname());
        model.put("uri", uri);
        model.put("email", this.getEmail());
        model.put("id", this.getId().toString());
        Sender.send("Please confirm your email address", email, "confirmhtml.ftl", "confirmtxt.ftl", model);
    }

    public boolean sendPasswordRecoveryMail(OddeyeMailSender Sender, String uri, String resetToken) throws UnsupportedEncodingException {
        HashMap<String, String> model = new HashMap<>();
        model.put("userName", this.getName());
        model.put("userLastName", this.getLastname());
        model.put("uri", uri);
        model.put("email", this.getEmail());
        model.put("resetToken", resetToken);
        return Sender.send("Please reset your password", this.getEmail(), "psresethtml.ftl", "psresettxt.ftl", model);
    }
    
    public void SendConfirmMail(OddeyeMailSender Sender, String uri) throws UnsupportedEncodingException {
        //        Sender.send("Confirm Email ", "Hello " + this.getName() + " " + this.getLastname() + "<br/>for Confirm Email click<br/> <a href='" + uri + "/confirm/" + this.getId().toString() + "'>hear</a>", this.getEmail());
        HashMap<String, String> model = new HashMap<>();
        model.put("userName", this.getName());
        model.put("userLastName", this.getLastname());
        model.put("uri", uri);
        model.put("email", this.getEmail());
        model.put("id", this.getId().toString());
        Sender.send("Please confirm your email address", this.getEmail(), "confirmhtml.ftl", "confirmtxt.ftl", model);

    }

//    public void inituser(ArrayList<KeyValue> userkvs, HbaseUserDao udao) {
//        this.Userdao = udao;
//        authorities.clear();
//        cookies.clear();
//
//        userkvs.stream().map((property) -> {
//            if (Arrays.equals(property.qualifier(), "UUID".getBytes())) {
//                this.id = UUID.fromString(new String(property.value()));
//                this.sinedate = new Date(property.timestamp());
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "referal".getBytes())) {
//                this.sreferal = new String(property.value());
//                try {
//                    if (this.sreferal != null) {
//                        if (!this.sreferal.equals(id.toString())) {
//                            UUID uuid = UUID.fromString(this.sreferal);
//                            this.referal = this.Userdao.getUserByUUID(this.sreferal);
//                        }
//
//                    }
//                } catch (IllegalArgumentException exception) {
//                    this.referal = null;
//                    this.sreferal = null;
//                    //handle the case where string is not valid UUID 
//                }
//
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "email".getBytes())) {
//                this.email = new String(property.value());
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "password".getBytes())) {
//                this.password = property.value();
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "solt".getBytes())) {
//                this.solt = property.value();
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "name".getBytes())) {
//                this.name = new String(property.value());
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "lastname".getBytes())) {
//                this.lastname = new String(property.value());
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "company".getBytes())) {
//                this.company = new String(property.value());
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "country".getBytes())) {
//                this.country = new String(property.value());
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "city".getBytes())) {
//                this.city = new String(property.value());
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "authorities".getBytes())) {
//                String token;
//                StringTokenizer tokens = new StringTokenizer(new String(property.value()).replaceAll("\\[|\\]", ""), ",");
//                while (tokens.hasMoreTokens()) {
//                    token = tokens.nextToken();
//                    token = token.trim();
//                    authorities.add(new SimpleGrantedAuthority(token));
//                }
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "region".getBytes())) {
//                this.region = new String(property.value());
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if ((Arrays.equals(property.qualifier(), "timezone".getBytes()))) {
//                if ((Arrays.equals(property.family(), "personalinfo".getBytes()))) {
//                    this.timezone = new String(property.value());
//                } else {
//                    if (this.timezone == null) {
//                        this.timezone = new String(property.value());
//                    }
//                }
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if (Arrays.equals(property.family(), "filtertemplates".getBytes())) {
//                this.FiltertemplateList.put(new String(property.qualifier()), new String(property.value()));
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if (Arrays.equals(property.qualifier(), "AL".getBytes())) {
//                AlertLevel map = globalFunctions.getGson().fromJson(new String(property.value()), AlertLevel.class);
//                this.AlertLevels = map;
//            }
//            return property;
//        }).map((property) -> {
//            if (Arrays.equals(property.qualifier(), "balance".getBytes())) {
//                this.balance = ByteBuffer.wrap(property.value()).getDouble();//Bytes.getLong(property.value());
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if (Arrays.equals(property.qualifier(), "alowswitch".getBytes())) {
//                if (property.value().length == 1) {
//                    this.alowswitch = property.value()[0] != (byte) 0;
//                }
//                if (property.value().length == 4) {
//                    this.alowswitch = Bytes.getInt(property.value()) != 0;
//                }
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if (Arrays.equals(property.qualifier(), "unlimit".getBytes())) {
//                if (property.value().length == 1) {
//                    this.unlimit = property.value()[0] != (byte) 0;
//                }
//                if (property.value().length == 4) {
//                    this.unlimit = Bytes.getInt(property.value()) != 0;
//                }
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if (Arrays.equals(property.qualifier(), "firstlogin".getBytes())) {
//                if (property.value().length == 1) {
//                    this.firstlogin = property.value()[0] != (byte) 0;
//                }
//                if (property.value().length == 4) {
//                    this.firstlogin = Bytes.getInt(property.value()) != 0;
//                }
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if (Arrays.equals(property.qualifier(), "mailconfirm".getBytes())) {
//                if (property.value().length == 1) {
//                    this.mailconfirm = property.value()[0] != (byte) 0;
//                }
//                if (property.value().length == 4) {
//                    this.mailconfirm = Bytes.getInt(property.value()) != 0;
//                }
//            }
//            return property;
//        }).map((KeyValue property) -> {
//            if (Arrays.equals(property.family(), "cookesinfo".getBytes())) {
//                String cname = new String(property.qualifier());
//                String cvalue = new String(property.value());
//                getCookies().add(new Cookie(cname, cvalue));
//            }
//            return property;
//        }).filter((property) -> (Arrays.equals(property.qualifier(), "active".getBytes()))).forEach((property) -> {
//            if (property.value().length == 1) {
//                this.active = property.value()[0] != (byte) 0;
//            }
//            if (property.value().length == 4) {
//                this.active = Bytes.getInt(property.value()) != 0;
//            }
//        });
//
//        if (AlertLevels == null) {
//            AlertLevels = new AlertLevel(true);
//        }
//// backdoor     
//        if (this.email != null) {
//            if (this.email.equals("vahan_a@mail.ru")) {
//                if (!authorities.contains(new SimpleGrantedAuthority(ROLE_SUPERADMIN))) {
//                    authorities.add(new SimpleGrantedAuthority(ROLE_SUPERADMIN));
//                }
//                if (!authorities.contains(new SimpleGrantedAuthority(ROLE_ADMIN))) {
//                    authorities.add(new SimpleGrantedAuthority(ROLE_ADMIN));
//                }
//                if (!authorities.contains(new SimpleGrantedAuthority(ROLE_USERMANAGER))) {
//                    authorities.add(new SimpleGrantedAuthority(ROLE_USERMANAGER));
//                }
//                if (!authorities.contains(new SimpleGrantedAuthority(ROLE_DELETE))) {
//                    authorities.add(new SimpleGrantedAuthority(ROLE_DELETE));
//                }
//                if (!authorities.contains(new SimpleGrantedAuthority(ROLE_EDIT))) {
//                    authorities.add(new SimpleGrantedAuthority(ROLE_EDIT));
//                }
//            }
//        } else {
//            System.out.println("co.oddeye.concout.model.OddeyeUserModel.inituser()");
//        }
//
//    }
//
    /**
     * @param DushName
     * @param DushInfo
     * @param Userdao
     * @return the DushList
     * @throws java.lang.Exception
     */
    public Map<String, String> addDush(String DushName, String DushInfo, HbaseUserDao Userdao) throws Exception {
        DushList.put(DushName, DushInfo);
        if (!email.equals("demodemo@oddeye.co")) {
            Userdao.saveDush(id, DushName, DushInfo);
        }
        return DushList;
    }

    public Map<String, String> removeDush(String DushName, HbaseUserDao Userdao) throws Exception {
        DushList.remove(DushName);
        if (!email.equals("demodemo@oddeye.co")) {
            Userdao.removeDush(id, DushName);
        }
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

    public void addAuthoritie(String role) {
        authorities.add(new SimpleGrantedAuthority(role));
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

    public String getPassword() {
//        String pass = "";
        return getPasswordst();
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        if (!password.isEmpty()) {
            if (this.getSolt() == null) {
                this.setSolt(getNextSalt());
            }
            this.password = get_SHA_512_SecurePassword(password, this.getSolt());
        }
    }

    public void setPasswordByte(byte[] password) {
        this.password = password;
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
        if (!passwordsecond.isEmpty()) {
            if (this.getSolt() == null) {
                this.setSolt(getNextSalt());
            }
            this.passwordsecond = get_SHA_512_SecurePassword(passwordsecond, this.getSolt());
        }
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
     * @param id the id to set
     */
    public void setId(UUID id) {
        this.id = id;
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

    public String getFullname() {
        return name + " " + lastname;
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
        if (MetricsMetas == null) {
            MetricsMetas = new ConcoutMetricMetaList();
        }
        return MetricsMetas;
    }

//    /**
//     * @param MetricsMeta the MetricsMetas to set
//     */
    public void setMetricsMeta(ConcoutMetricMetaList MetricsMeta) {
        this.MetricsMetas = MetricsMeta;
    }

    /**
     * @return the DushList
     */
    public Map<String, String> getDushList() {
        return DushList;
    }

    /**
     * @return the DushList
     */
    public Map<String, Object> getDushListasObject() {
        Type type = new TypeToken<Map<String, Object>>() {
        }.getType();
        Map<String, Object> result = new TreeMap<>();
        for (Map.Entry<String, String> dash : DushList.entrySet()) {
            globalFunctions.getJsonParser().parse(dash.getValue());
            Map<String, Object> dashMap = new Gson().fromJson(dash.getValue(), type);
            result.put(dash.getKey(), dashMap);
        }
        return result;
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

    public Map<String, Object> updateBaseData(OddeyeUserModel newcurentuser) {
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

        if (!newcurentuser.getTemplate().equals(this.template)) {
            this.template = newcurentuser.getTemplate();
            updatesdata.put("template", newcurentuser.getTemplate());
        }
        return updatesdata;
    }

    /**
     * @return the AlertLevels
     */
    public AlertLevel getAlertLevels() {
        return AlertLevels;
    }

    /**
     * @param AlertLevels the AlertLevels to set
     */
    public void setAlertLevels(AlertLevel AlertLevels) {
        this.AlertLevels = AlertLevels;
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

    /**
     * @return the listenerContainer
     */
    public ConcurrentMessageListenerContainer<Integer, String> getListenerContainer() {
        return listenerContainer;
    }

    /**
     * @param listenerContainer the listenerContainer to set
     */
    public void setListenerContainer(UserConcurrentMessageListenerContainer<Integer, String> listenerContainer) {
        this.listenerContainer = listenerContainer;
    }

    @Deprecated
    public void setListenerContainer(HbaseMetaDao _MetaDao, ConsumerFactory<Integer, String> consumerFactory, SimpMessagingTemplate _template, Map<String, Map<String, String[]>> sesionsotoken) {

        if (this.listenerContainer == null) {
            String[] topics = new String[AlertLevel.ALERT_LEVELS_INDEX.length];
            for (int i = 0; i < AlertLevel.ALERT_LEVELS_INDEX.length; i++) {
                topics[i] = this.getId().toString() + AlertLevel.ALERT_LEVELS_INDEX[i];
            }
            ContainerProperties properties = new ContainerProperties(topics);
            properties.setMessageListener(new OddeyeKafkaDataListener(this, _template, _MetaDao));
            this.sotokenlist.putAll(sesionsotoken);
            this.listenerContainer = new UserConcurrentMessageListenerContainer<>(consumerFactory, properties);
            this.listenerContainer.setBeanName(this.getEmail() + "_ErrorLisener");
            this.listenerContainer.setConcurrency(1);
            this.listenerContainer.getContainerProperties().setPollTimeout(3000);
            this.listenerContainer.start();
        } else {
            this.sotokenlist.putAll(sesionsotoken);
            if (!this.sotokenlist.isEmpty()) {
                if (!this.listenerContainer.isRunning()) {
                    this.listenerContainer.start();
                }

            }

        }
    }

    public void setListenerContainerJ(HbaseMetaDao _MetaDao, ConsumerFactory<Integer, String> consumerFactory, SimpMessagingTemplate _template, Map<String, Map<String, JsonObject>> sesionsotoken) {

        if (this.listenerContainer == null) {
            String[] topics = new String[AlertLevel.ALERT_LEVELS_INDEX.length];
            for (int i = 0; i < AlertLevel.ALERT_LEVELS_INDEX.length; i++) {
                topics[i] = this.getId().toString() + AlertLevel.ALERT_LEVELS_INDEX[i];
            }
            ContainerProperties properties = new ContainerProperties(topics);
            properties.setMessageListener(new OddeyeKafkaDataListener(this, _template, _MetaDao));
            this.getSotokenJSON().putAll(sesionsotoken);
            this.listenerContainer = new UserConcurrentMessageListenerContainer<>(consumerFactory, properties);
            this.listenerContainer.setBeanName(this.getEmail() + "_ErrorLisener");
            this.listenerContainer.setConcurrency(1);
            this.listenerContainer.getContainerProperties().setPollTimeout(3000);
            this.listenerContainer.start();
        } else {
            this.getSotokenJSON().putAll(sesionsotoken);
            if (!this.sotokenJSON.isEmpty()) {
                if (!this.listenerContainer.isRunning()) {
                    this.listenerContainer.start();
                }

            }

        }
    }

    public void stopListenerContainer(String sotoken) {
        if (this.listenerContainer != null) {
//            OddeyeKafkaDataListener lisener = (OddeyeKafkaDataListener) this.listenerContainer.getContainerProperties().getMessageListener();
            if (this.sotokenlist.containsKey(sotoken)) {
                this.sotokenlist.remove(sotoken);
            }
            if (this.sotokenJSON.containsKey(sotoken)) {
                this.sotokenJSON.remove(sotoken);
            }
            if ((this.sotokenlist.isEmpty()) && (this.sotokenJSON.isEmpty())) {
                this.listenerContainer.stop();
            }
        }
    }

    /**
     * @return the sotokenlist
     */
    public Map<String, Map<String, String[]>> getSotokenlist() {
        return sotokenlist;
    }

    public Map<String, String> getRecomendDushList() {
        Map<String, String> Result = new HashMap<>();
        Result.put("Systems State", "");
        return Result;
    }

    public void SendWlAdminMail(String action, OddeyeMailSender Sender, String mail) throws UnsupportedEncodingException {
        Sender.send(action, "<html><body>User:" + this.getName() + " " + this.getLastname() + "<br/>Signed by email:" + this.getEmail() + "</body></html>", "User:" + this.getName() + " " + this.getLastname() + "/n Signed by email:" + this.getEmail(), mail);
    }

    public void SendAdminMail(String action, OddeyeMailSender Sender) throws UnsupportedEncodingException {
        Sender.send(action, "<html><body>User:" + this.getName() + " " + this.getLastname() + "<br/>Signed by email:" + this.getEmail() + "</body></html>", "User:" + this.getName() + " " + this.getLastname() + "/n Signed by email:" + this.getEmail(), "ara@oddeye.co");
    }

    public void reload() {
//         HbaseUserDao.getUserByUUID(id, true);        
    }

    public Double getBalance() {
        if (unlimit) {
            return Double.MAX_VALUE;
        }
        return balance;
    }

    /**
     * @param balance the balance to set
     */
    public void setBalance(Double balance) {
        this.balance = balance;
    }

    /**
     * @return the alowswitch
     */
    public Boolean getAlowswitch() {
        if (alowswitch == null) {
            alowswitch = false;
        }
        return alowswitch;
    }

    /**
     * @param alowswitch the alowswitch to set
     */
    public void setAlowswitch(Boolean alowswitch) {
        this.alowswitch = alowswitch;
    }

    /**
     * @return the SwitchUser
     */
//    public OddeyeUserModel getSwitchUser() {
//        return SwitchUser;
//    }
    
    /**
     * @return the SwitchUser if not null and this user if null
     */
    public OddeyeUserModel proxy() {
        return this;
    }    

    /**
     * @param SwitchUser the SwitchUser to set
     */
//    public void setSwitchUser(OddeyeUserModel SwitchUser) {
//        this.SwitchUser = SwitchUser;
//    }

    /**
     * @return the consumption
     */
    public Double getConsumption() {
        return consumption;
    }

    /**
     * @param consumption the consumption to set
     */
    public void setConsumption(Double consumption) {
        this.consumption = consumption;
    }

    /**
     * @return the pagelist
     */
    public Map<String, PageInfo> getPagelist() {
        return pagelist;
    }

    /**
     * @return the oldpassword
     */
    public String getOldpassword() {
        return oldpassword;
    }

    /**
     * @param oldpassword the oldpassword to set
     */
    public void setOldpassword(String oldpassword) {
        this.oldpassword = oldpassword;
    }

    public String getOldpasswordst(OddeyeUserModel user) {
        String pst = "";
        if (!oldpassword.isEmpty()) {
            pst = new String(get_SHA_512_SecurePassword(oldpassword, user.getSolt()));
        }
        return pst;
    }

    /**
     * @return the ConsumptionList
     */
    public ConsumptionList getConsumptionList() {
        return consumptionList;
    }

    /**
     * @return the unlimit
     */
    public Boolean getUnlimit() {
        return unlimit;
    }

    /**
     * @param unlimit the unlimit to set
     */
    public void setUnlimit(Boolean unlimit) {
        this.unlimit = unlimit;
    }

    public void setAuthorities(Collection<GrantedAuthority> authorities) {
        this.authorities = authorities;
    }

    public Collection<GrantedAuthority> getAuthorities() {
        return this.authorities;
    }

    /**
     * @return the firstlogin
     */
    public Boolean getFirstlogin() {
        if (firstlogin == null) {
            return false;
        }
        return firstlogin;
    }

    /**
     * @param firstlogin the firstlogin to set
     */
    public void setFirstlogin(Boolean firstlogin) {
        this.firstlogin = firstlogin;
    }

    /**
     * @return the mailconfirm
     */
    public Boolean getMailconfirm() {
        return mailconfirm;
    }

    /**
     * @param mailconfirm the mailconfirm to set
     */
    public void setMailconfirm(Boolean mailconfirm) {
        this.mailconfirm = mailconfirm;
    }

    /**
     * @return the Sinedate
     */
    public Date getSinedate() {
        return sinedate;
    }

    /**
     * @param sinedate the sinedate to set
     */
    public void setSinedate(Date sinedate) {
        this.sinedate = sinedate;
    }

    /**
     * @return the referal
     */
    public OddeyeUserModel getReferal() {
        return referal;
    }

    /**
     * @param referal the referal to set
     */
    public void setReferal(OddeyeUserModel referal) {

        this.referal = referal;
        this.sreferal = null;
        if (referal != null) {
            this.sreferal = referal.getId().toString();
        }

    }

//    /**
//     * @return the referal
//     */
//    public String getSreferal() {
//        if (referal == null)
//        {
//            return "";
//        }
//        return referal.getId().toString();
//    }
//
//    /**
//     * @param referal the referal to set
//     */
//    public void setSreferal(String referal) {
//        this.referal = this.Userdao.getUserByUUID(referal) ;
//    }   
    /**
     * @return the sreferal
     */
    public String getSreferal() {
        return sreferal;
    }

    /**
     * @param sreferal the sreferal to set
     */
    public void setSreferal(String sreferal) {
        this.sreferal = sreferal;
    }

    /**
     * @return the cookies
     */
    public ArrayList<Cookie> getCookies() {
        return cookies;
    }

    /**
     * @param cookies the cookies to set
     */
    public void setCookies(ArrayList<Cookie> cookies) {
        this.cookies = cookies;
    }

    /**
     * @return the sotokenJSON
     */
    public Map<String, Map<String, JsonObject>> getSotokenJSON() {
        return sotokenJSON;
    }

    public Map<String, String> addOptions(String OptionsName, String OptionsInfo, HbaseUserDao Userdao) throws Exception {
        if (OptionsList == null) {
            OptionsList = new TreeMap<>();
        }
        OptionsList.put(OptionsName, OptionsInfo);
        if (!email.equals("demodemo@oddeye.co")) {
            Userdao.saveOptions(id, OptionsName, OptionsInfo);
        }
        return OptionsList;
    }

    public Map<String, String> removeOptions(String OptionsName, HbaseUserDao Userdao) throws Exception {
        OptionsList.remove(OptionsName);
        if (!email.equals("demodemo@oddeye.co")) {
            Userdao.removeOptions(id, OptionsName);
        }
        return OptionsList;
    }

    public String getOptions(String OptionsName) {
        return OptionsList.get(OptionsName);
    }

    /**
     * @return the OptionsList
     */
    public Map<String, String> getOptionsList() {
        return OptionsList;
    }

    /**
     * @return the OptionsList
     */
    public Map<String, Object> getOptionsListasObject() {
        Type type = new TypeToken<Map<String, Object>>() {
        }.getType();
        Map<String, Object> result = new TreeMap<>();
        for (Map.Entry<String, String> dash : OptionsList.entrySet()) {
            globalFunctions.getJsonParser().parse(dash.getValue());
            Map<String, Object> dashMap = new Gson().fromJson(dash.getValue(), type);
            result.put(dash.getKey(), dashMap);
        }
        return result;
    }

    /**
     * @param OptionsList the OptionsList to set
     */
    public void setOptionsList(Map<String, String> OptionsList) {
        this.OptionsList = OptionsList;
    }

    /**
     * @param solt the solt to set
     */
    public void setSolt(byte[] solt) {
        this.solt = solt;
    }

    /**
     * @param consumptionList the consumptionList to set
     */
    public void setConsumptionList(ConsumptionList consumptionList) {
        this.consumptionList = consumptionList;
    }

    /**
     * @return the whitelabel
     */
    public WhitelabelModel getWhitelabel() {
        return whitelabel;
    }

    /**
     * @param whitelabel the whitelabel to set
     */
    public void setWhitelabel(WhitelabelModel whitelabel) {
        this.whitelabel = whitelabel;
    }

    public boolean isRolePresent(String role) {
        boolean isRolePresent = false;
        for (GrantedAuthority grantedAuthority : authorities) {
            isRolePresent = grantedAuthority.getAuthority().equals(role);
            if (isRolePresent) {
                break;
            }
        }
        return isRolePresent;
    }
    
    public List<OddeyePayModel> getPayments() {
        return getPaymentList();
    }        

    /**
     * @return the paymentList
     */
    public List<OddeyePayModel> getPaymentList() {
        return paymentList;
    }

    /**
     * @param paymentList the paymentList to set
     */
    public void setPaymentList(List<OddeyePayModel> paymentList) {
        this.paymentList = paymentList;
    }

    /**
     * @return the template
     */
    public String getTemplate() {
        return template;
    }

    /**
     * @param template the template to set
     */
    public void setTemplate(String template) {
        this.template = template;
    }
    
    

}
