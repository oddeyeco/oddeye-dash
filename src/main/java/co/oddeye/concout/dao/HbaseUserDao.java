/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.annotation.HbaseColumn;
import co.oddeye.concout.model.User;
import co.oddeye.core.globalFunctions;
import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import java.util.UUID;
import net.opentsdb.uid.NoSuchUniqueName;
import net.opentsdb.uid.UniqueId;
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

//import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
//TODO REFACTOR
@Repository
public class HbaseUserDao extends HbaseBaseDao {

    @Autowired
    HbaseMetaDao MetaDao;

    private static final Logger LOGGER = LoggerFactory.getLogger(HbaseUserDao.class);

    byte[] dashtable = "oddeyeDushboards".getBytes();

    private final Map<UUID, User> usersbyUUID = new HashMap<>();
    private final Map<String, User> usersbyEmail = new HashMap<>();

    public HbaseUserDao() {
        super("oddeyeusers");
    }

    public void addUser(User user) throws Exception {
        //TODO change for put qualifuers[][]
        UUID uuid = user.getId();
        final PutRequest putUUID = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "UUID".getBytes(), uuid.toString().getBytes());
        final PutRequest putname = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "name".getBytes(), user.getName().getBytes());
        final PutRequest putemail = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "email".getBytes(), user.getEmail().getBytes());
        final PutRequest putlastname = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "lastname".getBytes(), user.getLastname().getBytes());

        if (user.getCompany() != null) {
            final PutRequest putcompany = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "company".getBytes(), user.getCompany().getBytes());
            BaseTsdb.getClient().put(putcompany);
        }
        if (user.getCountry() != null) {
            final PutRequest putcountry = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "country".getBytes(), user.getCountry().getBytes());
            BaseTsdb.getClient().put(putcountry);

        }
        if (user.getCity() != null) {
//            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("city"), Bytes.toBytes(user.getCity()));
            final PutRequest putcity = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "city".getBytes(), user.getCity().getBytes());
            BaseTsdb.getClient().put(putcity);
        }

        if (user.getTimezone() != null) {
            final PutRequest puttimezone = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "timezone".getBytes(), user.getTimezone().getBytes());
            BaseTsdb.getClient().put(puttimezone);
        }

        if (user.getRegion() != null) {
            final PutRequest putregion = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "region".getBytes(), user.getRegion().getBytes());
            BaseTsdb.getClient().put(putregion);
        }
        if (user.getPasswordByte() != null) {
            final PutRequest putpassword = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "password".getBytes(), user.getPasswordByte());
            BaseTsdb.getClient().put(putpassword);

        }
        if (user.getSolt() != null) {
            final PutRequest putsolt = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "solt".getBytes(), user.getSolt());
            BaseTsdb.getClient().put(putsolt);

        }
        if (user.getActive() != null) {
            final PutRequest putactive = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "active".getBytes(), Bytes.fromInt(user.getActive() ? 1 : 0));
            BaseTsdb.getClient().put(putactive);
        }

        if (user.getAuthorities() != null) {
            final PutRequest putAuthorities = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "authorities".getBytes(), user.getAuthorities().toString().getBytes());
            BaseTsdb.getClient().put(putAuthorities);
        }
        BaseTsdb.getClient().put(putUUID);
        BaseTsdb.getClient().put(putname);
        BaseTsdb.getClient().put(putemail);
        BaseTsdb.getClient().put(putlastname).join();
    }

    public List<User> getAllUsers() {
        return getAllUsers(false);
    }

    public List<User> getAllUsers(boolean reload) {
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

    public Boolean checkUserByEmail(User user) throws Exception {
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
        if (value_rows.size() == 1) {
            UUID uuid = UUID.fromString(new String(value_rows.get(0).get(0).key()));
            return (!user.getId().equals(uuid));
        }
        return value_rows.size() == 1;
    }

    public User getUserByEmail(String email) {
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
                byte[] tmppassword = User.get_SHA_512_SecurePassword(password, solt);
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

    public User getUserByUUID(UUID uuid) {
        return getUserByUUID(uuid, false);
    }

    public User getUserByUUID(UUID uuid, boolean reload) {
        if (!reload && getUsers().containsKey(uuid)) {
            return getUsers().get(uuid);
        }
        try {
            GetRequest get = new GetRequest(table, uuid.toString().getBytes());
            final ArrayList<KeyValue> userkvs = BaseTsdb.getClient().get(get).join();
            User user;
            if (getUsers().containsKey(uuid)) {
                user = getUsers().get(uuid);
            } else {
                user = new User();
            }
            byte[] TsdbID;
            user.inituser(userkvs);
            try {
                TsdbID = BaseTsdb.getTsdb().getUID(UniqueId.UniqueIdType.TAGV, user.getId().toString());
            } catch (NoSuchUniqueName e) {
                TsdbID = BaseTsdb.getTsdb().assignUid("tagv", user.getId().toString());
            }

            user.setTsdbID(TsdbID);
            getUsers().put(user.getId(), user);
            usersbyEmail.put(user.getEmail(), user);
            user.setDushList(getAllDush(uuid));
            return getUsers().get(uuid);

        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;
    }

    public void saveDush(UUID id, String DushName, String DushInfo) {
        if (DushName != null) {
            final PutRequest put = new PutRequest(dashtable, id.toString().getBytes(), "data".getBytes(), DushName.getBytes(), DushInfo.getBytes());
            BaseTsdb.getClient().put(put);
        }
    }

    public void removeDush(UUID id, String DushName) {
        if (DushName != null) {
            final DeleteRequest put = new DeleteRequest(dashtable, id.toString().getBytes(), "data".getBytes(), DushName.getBytes());
            BaseTsdb.getClient().delete(put);
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

    public void saveField(User user, String name) throws Exception {
        Field field = user.getClass().getDeclaredField(name);
        Annotation[] Annotations = field.getDeclaredAnnotations();
        Map<String, HashMap<String, Object>> changedata = new HashMap<>();
        for (Annotation annotation : Annotations) {
            if (annotation.annotationType().equals(HbaseColumn.class)) {
                PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), User.class);
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
                } else {
                    setter.invoke(user, newvalue);
                    changedata.get(family).put(((HbaseColumn) annotation).qualifier(), newvalue);
                }
            }
        }
        
        PutHbase(changedata, user);

    }

    public void PutHbase(Map<String, HashMap<String, Object>> changedata,User user) throws Exception {
        if (changedata.size() > 0) {
            for (Map.Entry<String, HashMap<String, Object>> data : changedata.entrySet()) {
                byte[] family = data.getKey().getBytes();
                if (data.getValue().size() > 0) {
                    byte[][] qualifiers = new byte[data.getValue().size()][];
                    byte[][] values = new byte[data.getValue().size()][];
                    int index = 0;
                    for (Map.Entry<String, Object> Hbasedata : data.getValue().entrySet()) {
                        qualifiers[index] = Hbasedata.getKey().getBytes();
                        if (Hbasedata.getValue() instanceof byte[]) {
                            values[index] = (byte[]) Hbasedata.getValue();
                        }
                        if (Hbasedata.getValue() instanceof String) {
                            values[index] = ((String) Hbasedata.getValue()).getBytes();
                        }
                        if (Hbasedata.getValue() instanceof Collection) {
                            values[index] = Hbasedata.getValue().toString().getBytes();
                        }
                        if (Hbasedata.getValue() instanceof Boolean) {
                            values[index] = (Bytes.fromInt((Boolean) Hbasedata.getValue() ? 1 : 0));
                        }
                        if (Hbasedata.getValue() instanceof Long) {
                            values[index] = (Bytes.fromLong((Long) Hbasedata.getValue()));
                        }
                        index++;
                    }
                    final PutRequest request = new PutRequest(table, user.getId().toString().getBytes(), family, qualifiers, values);
                    BaseTsdb.getClient().put(request);
                }
            }
        }
    }

    public void saveAll(User user, User newuser, Map<String, Object> editConfig) throws Exception {
        Map<String, HashMap<String, Object>> changedata = new HashMap<>();
        for (Map.Entry<String, Object> configEntry : editConfig.entrySet()) {
            HashMap<String, Object> config = (HashMap<String, Object>) configEntry.getValue();
            String name = (String) config.get("path");
            try {
                Field field = user.getClass().getDeclaredField(name);
                Annotation[] Annotations = field.getDeclaredAnnotations();
                if (Annotations.length > 0) {
                    for (Annotation annotation : Annotations) {
                        if (annotation.annotationType().equals(HbaseColumn.class)) {
                            try {
                                PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), User.class);
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
                                        if (!Arrays.equals((byte[]) newvalue, (byte[]) value)) {
                                            ischange = true;
                                        }
                                        break;
                                    case "collection":
                                        if (!value.toString().equals(newvalue.toString())) {
                                            ischange = true;
                                        }
                                        break;
                                    default:
                                        if ((value == null)) {
                                            if  (newvalue != null)
                                            {
                                                ischange = true;
                                            }                                            
                                            break;
                                        }
                                        if ((newvalue == null)) {
                                            if  (value != null)
                                            {
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
                            }
                        }

                    }
                }
            } catch (NoSuchFieldException | SecurityException e) {
            }
        }
        PutHbase(changedata, user);
//        if (changedata.size() > 0) {
//            for (Map.Entry<String, HashMap<String, Object>> data : changedata.entrySet()) {
//                byte[] family = data.getKey().getBytes();
//                if (data.getValue().size() > 0) {
//                    byte[][] qualifiers = new byte[data.getValue().size()][];
//                    byte[][] values = new byte[data.getValue().size()][];
//                    int index = 0;
//                    for (Map.Entry<String, Object> Hbasedata : data.getValue().entrySet()) {
//                        qualifiers[index] = Hbasedata.getKey().getBytes();
//                        if (Hbasedata.getValue() instanceof byte[]) {
//                            values[index] = (byte[]) Hbasedata.getValue();
//                        }
//                        if (Hbasedata.getValue() instanceof String) {
//                            values[index] = ((String) Hbasedata.getValue()).getBytes();
//                        }
//                        if (Hbasedata.getValue() instanceof Collection) {
//                            values[index] = Hbasedata.getValue().toString().getBytes();
//                        }
//                        if (Hbasedata.getValue() instanceof Boolean) {
//                            values[index] = (Bytes.fromInt((Boolean) Hbasedata.getValue() ? 1 : 0));
//                        }
//                        if (Hbasedata.getValue() instanceof Long) {
//                            values[index] = (Bytes.fromLong((Long) Hbasedata.getValue()));
//                        }
//                        index++;
//                    }
//                    final PutRequest request = new PutRequest(table, user.getId().toString().getBytes(), family, qualifiers, values);
//                    BaseTsdb.getClient().put(request);
//                }
//            }
//        }
    }

    public void saveUserPersonalinfo(User user, Map<String, Object> changedata) throws Exception {
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

    public void saveAlertLevels(User curentuser, String levelsJSON) {
        final PutRequest put = new PutRequest(table, curentuser.getId().toString().getBytes(), "technicalinfo".getBytes(), "AL".getBytes(), levelsJSON.getBytes());
        BaseTsdb.getClient().put(put);
    }

    /**
     * @return the usersbyUUID
     */
    public Map<UUID, User> getUsers() {
        return usersbyUUID;
    }

    public void deleteUser(User newUser) {

        try {
            final DeleteRequest delete = new DeleteRequest(table, newUser.getId().toString().getBytes());
            BaseTsdb.getClient().delete(delete).joinUninterruptibly();
            getUsers().remove(newUser.getId());
            usersbyEmail.remove(newUser.getEmail());
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }

}
