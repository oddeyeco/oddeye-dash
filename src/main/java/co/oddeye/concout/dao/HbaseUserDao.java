/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.annotation.HbaseColumn;
import co.oddeye.concout.config.DatabaseConfig;
import co.oddeye.concout.core.CoconutConsumption;
import co.oddeye.concout.core.ConsumptionList;
import co.oddeye.concout.model.IHbaseModel;
import co.oddeye.concout.model.OddeyePayModel;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.concout.model.WhitelabelModel;
import co.oddeye.core.AlertLevel;
import co.oddeye.core.globalFunctions;
import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.TreeMap;

import java.util.UUID;
import net.opentsdb.uid.NoSuchUniqueName;
import net.opentsdb.uid.UniqueId;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.Bytes;
import org.hbase.async.ColumnPrefixFilter;
import org.hbase.async.DeleteRequest;
import org.hbase.async.FilterList;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.hbase.async.PutRequest;
import org.hbase.async.ScanFilter;
import org.hbase.async.Scanner;
import org.hbase.async.ValueFilter;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import java.util.LinkedHashMap;
import java.util.StringTokenizer;
import java.util.stream.Collectors;
import javax.servlet.http.Cookie;

//import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
//TODO REFACTOR
@Repository("Userdao")
public class HbaseUserDao extends HbaseBaseDao {
    @Value("${dash.rootuser}")
    private String dashRootUser;

    @Autowired
    HbaseMetaDao MetaDao;

    @Autowired
    HbasePaymentDao PaymentDao;
    
    @Autowired
    WhitelabelDao whitelabelDao;

    private static final Logger LOGGER = LoggerFactory.getLogger(HbaseUserDao.class);

    byte[] dashtable;
    byte[] optionstable;

    byte[] consumptiontable;
    byte[] paymentstable;

    private final Map<UUID, OddeyeUserModel> usersbyUUID = new HashMap<>();
    private final Map<String, OddeyeUserModel> usersbyEmail = new HashMap<>();

    public HbaseUserDao(DatabaseConfig p_config) {
        super(p_config.getUsersTable());
        dashtable = p_config.getDashTable().getBytes();
        optionstable = p_config.getOptionsTable().getBytes();
        consumptiontable = p_config.getConsumptiontable().getBytes();
        paymentstable = p_config.getPaymentstable().getBytes();

    }

    public OddeyeUserModel getAvalibleUserByUUID(UUID uuid) {
        return getUsers().get(uuid);
    }

    public OddeyeUserModel getUserByUUID(UUID uuid) {
        return getUserByUUID(uuid, false);
    }

    public OddeyeUserModel getUserByUUID(String uuid) {
        try {
            return getUserByUUID(UUID.fromString(uuid), false);
        } catch (Exception e) {
            return null;
        }

    }

    public OddeyeUserDetails getUserByUUID(UUID uuid, boolean reload, boolean initmeta) {
        OddeyeUserModel user = getUserByUUID(uuid, reload);
        OddeyeUserDetails result = new OddeyeUserDetails(uuid);
        if (initmeta) {
            try {
                user.setMetricsMeta(MetaDao.getByUUID(user.getId()));
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        }

        return result;
    }

    public OddeyeUserModel getUserByUUID(UUID uuid, boolean reload) {
        if (!reload && getUsers().containsKey(uuid)) {
            return getUsers().get(uuid);
        }
        try {
            GetRequest get = new GetRequest(table, uuid.toString().getBytes());
            final ArrayList<KeyValue> userkvs = BaseTsdb.getClient().get(get).join();
            OddeyeUserModel user;
            if (getUsers().containsKey(uuid)) {
                user = getUsers().get(uuid);
                user.getCookies().clear();
            } else {
                user = new OddeyeUserModel();
            }
            byte[] TsdbID;
            if (userkvs.isEmpty()) {
                return null;
            }
            for (Field field : user.getClass().getDeclaredFields()) {
                if (field.isAnnotationPresent(HbaseColumn.class)) {
                    PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), OddeyeUserModel.class);
                    for (KeyValue kv : userkvs) {
                        String q = new String(kv.qualifier());
                        for (Annotation an : field.getDeclaredAnnotations()) {
                            if (an.annotationType().equals(HbaseColumn.class)) {
                                HbaseColumn anotation = (HbaseColumn) an;
                                if ((Arrays.equals(kv.family(), anotation.family().getBytes()))) {
                                    if (anotation.qualifier().isEmpty()) {
                                        if (ArrayList.class.isAssignableFrom(field.getType())) {
                                            if (field.getName().equals("cookies")) {
                                                Method getter = PDescriptor.getReadMethod();
                                                Object value = getter.invoke(user);
                                                String cname = new String(kv.qualifier());
                                                String cvalue = new String(kv.value());
                                                if (!cname.isEmpty()) {
                                                    ((ArrayList<Cookie>) value).add(new Cookie(cname, cvalue));
                                                }

                                            }

                                        }
                                    } else {
                                        if (anotation.qualifier().equals("*")) {
                                            Object newvalue = null;
                                            Method getter = PDescriptor.getReadMethod();
                                            switch (field.getType().getCanonicalName()) {
                                                case "java.util.Map":
                                                    newvalue = new String(kv.value());
                                                    Map list = (java.util.Map) getter.invoke(user);
                                                    list.put(new String(kv.qualifier()), newvalue);
                                                    break;
                                            }

                                        } else if ((Arrays.equals(kv.qualifier(), anotation.qualifier().getBytes()))) {
                                            Method setter = PDescriptor.getWriteMethod();
                                            Object newvalue = null;
                                            //&& (field.getType().getCanonicalName().equals("java.util.Date"))
                                            if (anotation.type().equals("timestamp")) {
                                                newvalue = new Date(kv.timestamp());
                                                setter.invoke(user, new Object[]{newvalue});
                                            } else {
                                                switch (field.getType().getCanonicalName()) {
                                                    case "java.util.UUID":
                                                        newvalue = UUID.fromString(new String(kv.value()));
                                                        setter.invoke(user, new Object[]{newvalue});
                                                        break;
                                                    case "java.lang.String":
                                                        newvalue = new String(kv.value());
                                                        setter.invoke(user, new Object[]{newvalue});
                                                        break;
                                                    case "co.oddeye.concout.model.WhitelabelModel":                                                        
                                                        WhitelabelModel val =  whitelabelDao.getByID(kv.value());                                                        
                                                        setter.invoke(user, new Object[]{val});
                                                        break;                                                        
                                                        
                                                    case "java.util.Collection":
                                                        if (field.getName().equals("authorities")) {
                                                            String token;
                                                            StringTokenizer tokens = new StringTokenizer(new String(kv.value()).replaceAll("\\[|\\]", ""), ",");
                                                            newvalue = new ArrayList<>();
                                                            while (tokens.hasMoreTokens()) {
                                                                token = tokens.nextToken();
                                                                token = token.trim();
                                                                ((ArrayList<GrantedAuthority>) newvalue).add(new SimpleGrantedAuthority(token));
                                                            }
                                                            setter.invoke(user, new Object[]{newvalue});
                                                        }

                                                        break;
                                                    case "java.lang.Double":
                                                        newvalue = ByteBuffer.wrap(kv.value()).getDouble();//Bytes.getLong(property.value());
                                                        setter.invoke(user, new Object[]{newvalue});
                                                        break;
                                                    case "co.oddeye.core.AlertLevel":
                                                        newvalue = globalFunctions.getGson().fromJson(new String(kv.value()), AlertLevel.class);
                                                        setter.invoke(user, new Object[]{newvalue});
                                                        break;

                                                    case "java.lang.Boolean":
                                                        if (kv.value().length == 1) {
                                                            newvalue = kv.value()[0] != (byte) 0;
                                                        }
                                                        if (kv.value().length == 4) {
                                                            newvalue = Bytes.getInt(kv.value()) != 0;
                                                        }
                                                        setter.invoke(user, new Object[]{newvalue});
                                                        break;
                                                    case "byte[]":
                                                        switch (field.getName()) {
                                                            case "password":
                                                                user.setPasswordByte(kv.value());
                                                                break;
                                                            default:
                                                                newvalue = kv.value();
                                                                setter.invoke(user, new Object[]{newvalue});
                                                                break;
                                                        }

                                                        break;
                                                    default:
                                                        System.out.println(field.getType().getCanonicalName());
                                                        break;
                                                }
                                            }

                                        }
                                    }

                                }

                            }
                        }
                    }
                }

            }
            if (user.getAlertLevels() == null) {
                user.setAlertLevels(new AlertLevel(true));
            }
//            user.inituser(userkvs, this);
            try {
                TsdbID = BaseTsdb.getTsdb().getUID(UniqueId.UniqueIdType.TAGV, user.getId().toString());
            } catch (NoSuchUniqueName e) {
                TsdbID = BaseTsdb.getTsdb().assignUid("tagv", user.getId().toString());
            }

// backdoor     
            if (user.getEmail() != null) {//
                if (user.getEmail().equals(dashRootUser)) {
                    if (!user.getAuthorities().contains(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_SUPERADMIN))) {
                        user.getAuthorities().add(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_SUPERADMIN));
                    }
                    if (!user.getAuthorities().contains(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_ADMIN))) {
                        user.getAuthorities().add(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_ADMIN));
                    }
                    if (!user.getAuthorities().contains(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_USERMANAGER))) {
                        user.getAuthorities().add(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_USERMANAGER));
                    }
                    if (!user.getAuthorities().contains(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_DELETE))) {
                        user.getAuthorities().add(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_DELETE));
                    }
                    if (!user.getAuthorities().contains(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_EDIT))) {
                        user.getAuthorities().add(new SimpleGrantedAuthority(OddeyeUserModel.ROLE_EDIT));
                    }
                }
            } else {
                System.out.println("co.oddeye.concout.model.OddeyeUserModel.inituser()");
            }

            user.setTsdbID(TsdbID);
            getUsers().put(user.getId(), user);
            usersbyEmail.put(user.getEmail(), user);
            user.setDushList(getAllDush(uuid));
            user.setOptionsList(getAllOptions(uuid));
            return getUsers().get(uuid);

        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;
    }

    /**
     * @return the usersbyUUID
     */
    public Map<UUID, OddeyeUserModel> getUsers() {
        return usersbyUUID;
    }

    public Map<String, HashMap<String, Object>> addUser(OddeyeUserModel user) throws Exception {
        Map<String, HashMap<String, Object>> changedata = new HashMap<>();
        for (Field field : user.getClass().getDeclaredFields()) {
            if (field.isAnnotationPresent(HbaseColumn.class)) {
                PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), OddeyeUserModel.class);
                Method getter = PDescriptor.getReadMethod();
                Object value = getter.invoke(user);
                if (value != null) {
                    for (Annotation an : field.getDeclaredAnnotations()) {
                        if (an instanceof HbaseColumn) {
                            String family = ((HbaseColumn) an).family();
                            if (!changedata.containsKey(family)) {
                                changedata.put(family, new HashMap<>());
                            }
                            if (((HbaseColumn) an).type().equals("password")) {
                                if ((user.getPasswordByte() != null) && (user.getSolt() != null)) {
                                    changedata.get(family).put("password", user.getPasswordByte());
                                    changedata.get(family).put("solt", user.getSolt());
                                }
                            } else if (value instanceof IHbaseModel) {
                                if (((HbaseColumn) an).identfield() != null) {
                                    PropertyDescriptor PDescriptor2 = new PropertyDescriptor(((HbaseColumn) an).identfield(), value.getClass());
                                    Method getter2 = PDescriptor2.getReadMethod();
                                    value = getter2.invoke(value);
                                    changedata.get(family).put(((HbaseColumn) an).qualifier(), value);
                                }
                            } else {
                                changedata.get(family).put(((HbaseColumn) an).qualifier(), value);
                            }
                        }

                    }
                }
            }
        }
        PutHbase(changedata, user);
        return changedata;
    }

    public Map<String, HashMap<String, Object>> saveAll(OddeyeUserModel user, OddeyeUserModel newuser, Map<String, Object> editConfig) throws Exception {
        Map<String, HashMap<String, Object>> changedata = new HashMap<>();
        for (Map.Entry<String, Object> configEntry : editConfig.entrySet()) {
//            HashMap<String, Object> config = (HashMap<String, Object>) configEntry.getValue();
            HashMap<?, ?> config = (HashMap<?, ?>) configEntry.getValue();
            String name = (String) config.get("path");
            try {
                Field field = user.getClass().getDeclaredField(name);
                Annotation[] Annotations = field.getDeclaredAnnotations();
                if (Annotations.length > 0) {
                    for (Annotation annotation : Annotations) {
                        if (annotation.annotationType().equals(HbaseColumn.class)) {
                            try {
                                PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), OddeyeUserModel.class);
                                Method getter = PDescriptor.getReadMethod();
                                Object value = getter.invoke(user);
                                Object newvalue = getter.invoke(newuser);
                                //type="collection"
                                boolean ischange = false;

                                switch (((HbaseColumn) annotation).type()) {
                                    case "password":
                                        getter = user.getClass().getDeclaredMethod("getPasswordByte");
                                        value = getter.invoke(user);
                                        newvalue = getter.invoke(newuser);
                                        if (newvalue != null) {
                                            if (!Arrays.equals((byte[]) newvalue, (byte[]) value)) {
                                                ischange = true;
                                            }
                                        }
                                        break;
                                    case "collection":
                                        if (!value.toString().equals(newvalue.toString())) {
                                            ischange = true;
                                        }
                                        break;
                                    default:
                                        if ((value == null)) {
                                            if (newvalue != null) {
                                                ischange = true;
                                            }
                                            break;
                                        }
                                        if ((newvalue == null)) {
                                            if (value != null) {
                                                ischange = true;
                                            }
                                            break;
                                        }
                                        if (!value.equals(newvalue)) {
                                            ischange = true;
                                        }
                                        break;
                                }

                                if (ischange) {

                                    Method setter = PDescriptor.getWriteMethod();
                                    String family = ((HbaseColumn) annotation).family();
                                    if (!changedata.containsKey(family)) {
                                        changedata.put(family, new HashMap<>());
                                    }
                                    if (((HbaseColumn) annotation).type().equals("password")) {
                                        changedata.get(family).put("password", newuser.getPasswordByte());
                                        changedata.get(family).put("solt", newuser.getSolt());
                                    } else {
                                        setter.invoke(user, newvalue);
                                        changedata.get(family).put(((HbaseColumn) annotation).qualifier(), newvalue);
                                    }

                                }

                            } catch (IntrospectionException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
                                LOGGER.error(globalFunctions.stackTrace(e));
                            }
                        }

                    }
                }
            } catch (NoSuchFieldException | SecurityException e) {
            }
        }
        PutHbase(changedata, user);
        return changedata;
    }

    public void saveSineUpCookes(OddeyeUserModel user, Cookie[] cookies) throws Exception {
        if (cookies != null) {

            ArrayList<byte[]> qlist = new ArrayList<>();
            ArrayList<byte[]> vlist = new ArrayList<>();
            for (Cookie cookie : cookies) {

                qlist.add(cookie.getName().getBytes());
                vlist.add((cookie.getValue()).getBytes());
            }
            byte[][] qualifiers = new byte[qlist.size()][];
            byte[][] values = new byte[vlist.size()][];
            if (vlist.size() > 0) {
                qualifiers = qlist.toArray(qualifiers);
                values = vlist.toArray(values);
                final PutRequest put = new PutRequest(table, user.getId().toString().getBytes(), "cookesinfo".getBytes(), qualifiers, values);
                BaseTsdb.getClient().put(put);
            }

        }
    }

    public List<OddeyeUserModel> getAllUsers() {
        return getAllUsers(false);
    }

    public Map<String, String> getAllUsersShort() {
        Map<String, String> list = new HashMap<>();
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            byte[][] qualifiers = new byte[2][];
            qualifiers[0] = "UUID".getBytes();
            qualifiers[1] = "email".getBytes();
            scanner.setQualifiers(qualifiers);//r("UUID");
            ArrayList<ArrayList<KeyValue>> rows;
            while ((rows = scanner.nextRows(10000).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                    String id = "";
                    String value = "";
                    for (KeyValue kv : row) {
                        if (Arrays.equals(kv.qualifier(), qualifiers[0])) {
                            id = new String(kv.value());
                        }
                        if (Arrays.equals(kv.qualifier(), qualifiers[1])) {
                            value = new String(kv.value());
                        }
                    }
                    if ((!id.isEmpty()) && (!value.isEmpty())) {
                        list.put(id, value);
                    }

                }
            }
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
            return null;
        }
        list.put("", "");
        LinkedHashMap<String, String> result = list.entrySet().stream()
                .sorted(Map.Entry.comparingByValue())
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (oldValue, newValue) -> oldValue, LinkedHashMap::new));
        list.clear();

        list.putAll(result);
        return result;
    }

    public List<OddeyeUserModel> getAllUsers(boolean reload) {
        if (reload) {
            try {
                final Scanner scanner = BaseTsdb.getClient().newScanner(table);
                scanner.setQualifier("UUID");
                ArrayList<ArrayList<KeyValue>> rows;
                while ((rows = scanner.nextRows(10000).joinUninterruptibly()) != null) {
                    for (final ArrayList<KeyValue> row : rows) {
                        row.stream().filter((property) -> (Arrays.equals(property.qualifier(), "UUID".getBytes()))).forEachOrdered((property) -> {
                            getUserByUUID(UUID.fromString(new String(property.value())), reload);
                        });
                    }
                }
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
                return null;
            }
        }
        return new ArrayList<>(getUsers().values());
    }

    public Boolean checkUserByEmail(OddeyeUserModel user) throws Exception {
//        this.client.get(null);
        String email = user.getEmail();
        final Scanner value_scanner = BaseTsdb.getClient().newScanner(table);

        final ArrayList<ScanFilter> filters = new ArrayList<>(2);
        filters.add(
                new ValueFilter(org.hbase.async.CompareFilter.CompareOp.EQUAL,
                        new org.hbase.async.BinaryComparator(email.getBytes())));
        filters.add(new ColumnPrefixFilter("email"));

        value_scanner.setFilter(new FilterList(filters));

        final ArrayList<ArrayList<KeyValue>> value_rows = value_scanner.nextRows().join();
        if (value_rows != null) {
            if (value_rows.size() == 1) {
                UUID uuid = UUID.fromString(new String(value_rows.get(0).get(0).key()));
                return (!user.getId().equals(uuid));
            }
            return value_rows.size() == 1;
        }
        return false;
    }

    public OddeyeUserDetails getUserByEmail(String email) {

        try {
            final Scanner value_scanner = BaseTsdb.getClient().newScanner(table);

            final ArrayList<ScanFilter> filters = new ArrayList<>(2);
            filters.add(
                    new ValueFilter(org.hbase.async.CompareFilter.CompareOp.EQUAL,
                            new org.hbase.async.BinaryComparator(email.getBytes())));
            filters.add(new ColumnPrefixFilter("email"));

            value_scanner.setFilter(new FilterList(filters));

            final ArrayList<ArrayList<KeyValue>> value_rows = value_scanner.nextRows().join();
            if (value_rows.size() == 1) {
                UUID uuid = UUID.fromString(new String(value_rows.get(0).get(0).key()));
                return getUserByUUID(uuid, false, false);
            }
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;
    }

    public UUID CheckUserAuthentication(Authentication authentication) {
        String email = authentication.getName();
        String password = authentication.getCredentials().toString();

        final Scanner value_scanner = BaseTsdb.getClient().newScanner(table);

        value_scanner.setFamily("personalinfo");
        final ArrayList<ScanFilter> filters = new ArrayList<>(2);
        filters.add(
                new ValueFilter(org.hbase.async.CompareFilter.CompareOp.EQUAL,
                        new org.hbase.async.BinaryComparator(email.getBytes())));
        value_scanner.setFilter(new FilterList(filters));

        try {

            final ArrayList<ArrayList<KeyValue>> value_rows = value_scanner.nextRows().joinUninterruptibly();

            if (value_rows.size() > 0) {
                boolean isvalidpass = false;
                byte[] bUUID = value_rows.get(0).get(0).key();
                GetRequest get = new GetRequest(table, bUUID, "technicalinfo".getBytes(), "password".getBytes());
                final ArrayList<KeyValue> passkvs = BaseTsdb.getClient().get(get).join();
                final KeyValue passkv = passkvs.get(0);
                get = new GetRequest(table, bUUID, "technicalinfo".getBytes(), "solt".getBytes());
                final ArrayList<KeyValue> soltkvs = BaseTsdb.getClient().get(get).join();
                final KeyValue soltkv = soltkvs.get(0);

                byte[] pass = passkv.value();
                byte[] solt = soltkv.value();
                byte[] tmppassword = OddeyeUserModel.get_SHA_512_SecurePassword(password, solt);
                if (Arrays.equals(tmppassword, pass)) {

                    return UUID.fromString(new String(bUUID));
                }
            }
//            scanner1.close();
        } catch (Exception e) {
            value_scanner.close();
            LOGGER.error(globalFunctions.stackTrace(e));
        }

        return null;
    }

    public void updateMetaList(OddeyeUserModel user) {
        try {
            user.setMetricsMeta(MetaDao.getByUUID(user.getId()));
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }

    public void saveDush(UUID id, String DushName, String DushInfo) throws Exception {
        if (DushName != null) {
            final PutRequest put = new PutRequest(dashtable, id.toString().getBytes(), "data".getBytes(), DushName.getBytes(), DushInfo.getBytes());
            BaseTsdb.getClient().put(put).join();
        }
    }

    public void removeDush(UUID id, String DushName) throws Exception {
        if (DushName != null) {
            final DeleteRequest put = new DeleteRequest(dashtable, id.toString().getBytes(), "data".getBytes(), DushName.getBytes());
            BaseTsdb.getClient().delete(put).join();
        }
    }

    public Map<String, String> getAllDush(UUID id) throws Exception {
        final Map<String, String> result = new TreeMap<>();
        final GetRequest get = new GetRequest(dashtable, id.toString().getBytes());
        final ArrayList<KeyValue> DushList = BaseTsdb.getClient().get(get).joinUninterruptibly();
        DushList.stream().forEach((dush) -> {
            result.put(new String(dush.qualifier()), new String(dush.value()));
        });
        return result;
    }

    public void saveOptions(UUID id, String OptionsName, String OptionsInfo) throws Exception {
        if (OptionsName != null) {
            final PutRequest put = new PutRequest(optionstable, id.toString().getBytes(), "data".getBytes(), OptionsName.getBytes(), OptionsInfo.getBytes());
            BaseTsdb.getClient().put(put).join();
        }
    }

    public void removeOptions(UUID id, String OptionsName) throws Exception {
        if (OptionsName != null) {
            final DeleteRequest put = new DeleteRequest(optionstable, id.toString().getBytes(), "data".getBytes(), OptionsName.getBytes());
            BaseTsdb.getClient().delete(put).join();
        }
    }

    public Map<String, String> getAllOptions(UUID id) throws Exception {
        final Map<String, String> result = new TreeMap<>();
        final GetRequest get = new GetRequest(optionstable, id.toString().getBytes());
        final ArrayList<KeyValue> OptionsList = BaseTsdb.getClient().get(get).joinUninterruptibly();
        OptionsList.stream().forEach((Options) -> {
            String name = new String(Options.qualifier());
            if (!name.equals("@%@@%@default_page_filter@%@@%@")) {
                result.put(name, new String(Options.value()));
            }
        });
        return result;
    }

    public Map<String, String> getHidenOptions(UUID id) throws Exception {
        final Map<String, String> result = new TreeMap<>();
        final GetRequest get = new GetRequest(optionstable, id.toString().getBytes(), "data".getBytes(), "@%@@%@default_page_filter@%@@%@".getBytes());
        final ArrayList<KeyValue> OptionsList = BaseTsdb.getClient().get(get).joinUninterruptibly();
        OptionsList.stream().forEach((Options) -> {
            String name = new String(Options.qualifier());
            result.put(name, new String(Options.value()));

        });
        return result;
    }

    public Map<String, HashMap<String, Object>> saveField(OddeyeUserModel user, String name) throws Exception {
        Field field = user.getClass().getDeclaredField(name);
        Annotation[] Annotations = field.getDeclaredAnnotations();
        Map<String, HashMap<String, Object>> changedata = new HashMap<>();
        for (Annotation annotation : Annotations) {
            if (annotation.annotationType().equals(HbaseColumn.class)) {
                PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), OddeyeUserModel.class);
                Method getter = PDescriptor.getReadMethod();
                Object newvalue = getter.invoke(user);
                Method setter = PDescriptor.getWriteMethod();
                String family = ((HbaseColumn) annotation).family();
                if (!changedata.containsKey(family)) {
                    changedata.put(family, new HashMap<>());
                }
                if (((HbaseColumn) annotation).type().equals("password")) {
                    changedata.get(family).put("password", user.getPasswordByte());
                    changedata.get(family).put("solt", user.getSolt());
                } else if (newvalue instanceof IHbaseModel) {
                    if (((HbaseColumn) annotation).identfield() != null) {
                        PropertyDescriptor PDescriptor2 = new PropertyDescriptor(((HbaseColumn) annotation).identfield(), newvalue.getClass());
                        Method getter2 = PDescriptor2.getReadMethod();
                        newvalue = getter2.invoke(newvalue);
                        changedata.get(family).put(((HbaseColumn) annotation).qualifier(), newvalue);
                    }
                } else {
                    setter.invoke(user, newvalue);
                    changedata.get(family).put(((HbaseColumn) annotation).qualifier(), newvalue);
                }
            }
        }

        PutHbase(changedata, user);
        return changedata;
    }

    public void PutHbase(Map<String, HashMap<String, Object>> changedata, OddeyeUserModel user) throws Exception {
        if (changedata.size() > 0) {
            for (Map.Entry<String, HashMap<String, Object>> data : changedata.entrySet()) {
                byte[] family = data.getKey().getBytes();
                if (data.getValue().size() > 0) {
//                    byte[][] qualifiers = new byte[data.getValue().size()][];
//                    byte[][] values = new byte[data.getValue().size()][];

                    ArrayList<byte[]> qualifiers = new ArrayList<>();
                    ArrayList<byte[]> values = new ArrayList<>();
                    for (Map.Entry<String, Object> Hbasedata : data.getValue().entrySet()) {

                        boolean isvalid = false;
                        if (Hbasedata.getValue() instanceof byte[]) {
                            isvalid = true;
                            values.add((byte[]) Hbasedata.getValue());
                        }
                        if (Hbasedata.getValue() instanceof String) {
                            isvalid = true;
                            values.add(((String) Hbasedata.getValue()).getBytes());
                        }
                        if (Hbasedata.getValue() instanceof UUID) {
                            isvalid = true;
                            values.add(((UUID) Hbasedata.getValue()).toString().getBytes());
                        }

                        if (Hbasedata.getValue() instanceof Collection) {
                            isvalid = true;
                            values.add(Hbasedata.getValue().toString().getBytes());
                        }
                        if (Hbasedata.getValue() instanceof Boolean) {
                            isvalid = true;
                            values.add((Bytes.fromInt((Boolean) Hbasedata.getValue() ? 1 : 0)));
                        }
                        if (Hbasedata.getValue() instanceof Long) {
                            isvalid = true;
                            values.add((Bytes.fromLong((Long) Hbasedata.getValue())));
                        }
                        if (Hbasedata.getValue() instanceof Double) {
                            isvalid = true;
                            byte[] bytes = new byte[8];
                            ByteBuffer.wrap(bytes).putDouble((Double) Hbasedata.getValue());
                            values.add(bytes);
                        }
                        if (isvalid) {
                            qualifiers.add(Hbasedata.getKey().getBytes());
                        }

                    }

                    byte[][] q = qualifiers.toArray(new byte[qualifiers.size()][]);
                    byte[][] v = values.toArray(new byte[values.size()][]);
                    if (qualifiers.size() > 0) {
                        final PutRequest request = new PutRequest(table, user.getId().toString().getBytes(), family, q, v);
                        BaseTsdb.getClient().put(request).join();
                    }
                }
            }
        }
    }

    public void saveUserPersonalinfo(OddeyeUserModel user, Map<String, Object> changedata) throws Exception {
        if (changedata.size() > 0) {
            byte[][] qualifiers = new byte[changedata.size()][];
            byte[][] values = new byte[changedata.size()][];
            int index = 0;
            for (Map.Entry<String, Object> data : changedata.entrySet()) {
                qualifiers[index] = data.getKey().getBytes();
                values[index] = data.getValue().toString().getBytes();
                index++;
            }
            PutRequest request = new PutRequest(table, user.getId().toString().getBytes(), "personalinfo".getBytes(), qualifiers, values);
            BaseTsdb.getClient().put(request).joinUninterruptibly();
        }
    }

    public void saveUserinfo(OddeyeUserModel user, Map<String, Object> newdata) throws Exception {
        if (newdata.size() > 0) {
            byte[][] qualifiers = new byte[newdata.size()][];
            byte[][] values = new byte[newdata.size()][];
            int index = 0;
            for (Map.Entry<String, Object> data : newdata.entrySet()) {
                qualifiers[index] = data.getKey().getBytes();
                values[index] = data.getValue().toString().getBytes();
                index++;
            }
            PutRequest request = new PutRequest(table, user.getId().toString().getBytes(), "personalinfo".getBytes(), qualifiers, values);
            BaseTsdb.getClient().put(request).joinUninterruptibly();
        }
    }

    public void saveFiltertemplate(UUID id, String filtername, String filterinfo) {
        if (filtername != null) {
            final PutRequest put = new PutRequest(table, id.toString().getBytes(), "filtertemplates".getBytes(), filtername.getBytes(), filterinfo.getBytes());
            BaseTsdb.getClient().put(put);
        }
    }

    public void removeFiltertemplate(UUID id, String filtername) {
        if (filtername != null) {
            final DeleteRequest put = new DeleteRequest(table, id.toString().getBytes(), "filtertemplates".getBytes(), filtername.getBytes());
            BaseTsdb.getClient().delete(put);
        }
    }

    public void saveAlertLevels(OddeyeUserModel curentuser, String levelsJSON) {
        final PutRequest put = new PutRequest(table, curentuser.getId().toString().getBytes(), "technicalinfo".getBytes(), "AL".getBytes(), levelsJSON.getBytes());
        BaseTsdb.getClient().put(put);
    }

    public void deleteUser(OddeyeUserModel newUser) {

        try {
            final DeleteRequest delete = new DeleteRequest(table, newUser.getId().toString().getBytes());
            BaseTsdb.getClient().delete(delete).joinUninterruptibly();
            getUsers().remove(newUser.getId());
            usersbyEmail.remove(newUser.getEmail());
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }

    public ConsumptionList getConsumption(OddeyeUserModel user, int startYear, int startMonth, int endYear, int endMonth) throws Exception {
        final ConsumptionList result = new ConsumptionList();
        Scanner scanner = BaseTsdb.getClientSecondary().newScanner(consumptiontable);
        try {
            LOGGER.info(user.getEmail() + ":" + startYear + "/" + startMonth + " " + endYear + "/" + endMonth);
            byte[] year_key = ByteBuffer.allocate(4).putInt(startYear).array();
            byte[] month_key = ByteBuffer.allocate(4).putInt(startMonth).array();
            byte[] start_key = ArrayUtils.addAll(user.getId().toString().getBytes(), ArrayUtils.addAll(year_key, month_key));

            year_key = ByteBuffer.allocate(4).putInt(endYear).array();
            month_key = ByteBuffer.allocate(4).putInt(endMonth).array();
            byte[] end_key = ArrayUtils.addAll(user.getId().toString().getBytes(), ArrayUtils.addAll(year_key, month_key));

//            final GetRequest get = new GetRequest(consumptiontable, key);
            scanner.setStartKey(end_key);
            ArrayList<ArrayList<KeyValue>> rows;

            GetRequest request = new GetRequest(consumptiontable, start_key);
            ArrayList<KeyValue> frow = BaseTsdb.getClientSecondary().get(request).join();
            frow.stream().forEach((cos) -> {
                CoconutConsumption CoconutCos = new CoconutConsumption(cos);
                result.put(CoconutCos.getTimestamp(), CoconutCos);
            });
            if (!Arrays.equals(end_key, start_key)) {
                scanner.setStopKey(start_key);
                while ((rows = scanner.nextRows().join()) != null) {
                    rows.stream().forEach((row) -> {
                        row.stream().forEach((cos) -> {
                            CoconutConsumption CoconutCos = new CoconutConsumption(cos);
                            result.put(CoconutCos.getTimestamp(), CoconutCos);
                        });
                    });
                }
            }

//            final ArrayList<KeyValue> ConsList = BaseTsdb.getClient().get(get).joinUninterruptibly();
//            ConsList.stream().forEach((cos) -> {
//                CoconutConsumption CoconutCos = new CoconutConsumption(cos);
//                result.put(CoconutCos.getTimestamp(), new CoconutConsumption(cos));
//            });
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        } finally {
            scanner.close().join();
        }

        return result;
    }

    public ConsumptionList getConsumption(OddeyeUserModel user, int Year, int Month) {
        final ConsumptionList result = new ConsumptionList();
        try {
            byte[] year_key = ByteBuffer.allocate(4).putInt(Year).array();
            byte[] month_key = ByteBuffer.allocate(4).putInt(Month).array();

            byte[] key = ArrayUtils.addAll(user.getId().toString().getBytes(), ArrayUtils.addAll(year_key, month_key));
            final GetRequest get = new GetRequest(consumptiontable, key);
            final ArrayList<KeyValue> ConsList = BaseTsdb.getClient().get(get).joinUninterruptibly();
            ConsList.stream().forEach((cos) -> {
                CoconutConsumption CoconutCos = new CoconutConsumption(cos);
                result.put(CoconutCos.getTimestamp(), new CoconutConsumption(cos));
            });

        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return result;
    }

    public ConsumptionList getConsumption(OddeyeUserModel user) {
        final ConsumptionList result = new ConsumptionList();
        try {
            Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));

            byte[] year_key = ByteBuffer.allocate(4).putInt(cal.get(Calendar.YEAR)).array();
            byte[] month_key = ByteBuffer.allocate(4).putInt(cal.get(Calendar.MONTH)).array();

            byte[] key = ArrayUtils.addAll(user.getId().toString().getBytes(), ArrayUtils.addAll(year_key, month_key));
            final GetRequest get = new GetRequest(consumptiontable, key);
            final ArrayList<KeyValue> ConsList = BaseTsdb.getClient().get(get).joinUninterruptibly();
            ConsList.stream().forEach((cos) -> {
                CoconutConsumption CoconutCos = new CoconutConsumption(cos);
                result.put(CoconutCos.getTimestamp(), new CoconutConsumption(cos));
            });

        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return result;
    }

    public boolean isPaymentNew(OddeyeUserModel user, OddeyePayModel payment) throws Exception {
//        byte[] family = "c".getBytes();
        byte[][] qualifiers = new byte[10][];
        byte[][] values = new byte[10][];
        byte[] end_key = ArrayUtils.addAll(user.getId().toString().getBytes(), payment.getIpn_track_id().getBytes());

        final GetRequest request = new GetRequest(paymentstable, end_key);
        ArrayList<KeyValue> paymentt = BaseTsdb.getClient().get(request).join();
        return paymentt.isEmpty();
    }

    public void addPayment(OddeyeUserModel user, OddeyePayModel payment) throws Exception {
        PaymentDao.addPayment(user, payment);
    }

    public List<OddeyePayModel> getPaymets(OddeyeUserModel env, int count) {
        return PaymentDao.getPayments(env, count);
    }
}
