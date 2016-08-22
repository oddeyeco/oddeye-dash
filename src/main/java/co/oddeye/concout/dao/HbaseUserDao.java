/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.User;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.hbase.async.Bytes;
//import org.apache.hadoop.hbase.client.ResultScanner;
//import org.apache.hadoop.hbase.client.Result;
//import org.apache.hadoop.hbase.client.Scan;
//import org.apache.hadoop.hbase.util.Bytes;
//import org.apache.hadoop.hbase.client.Get;
//import org.apache.hadoop.hbase.filter.BinaryComparator;
//import org.apache.hadoop.hbase.filter.CompareFilter;
//import org.apache.hadoop.hbase.filter.SingleColumnValueFilter;
import org.hbase.async.ColumnPrefixFilter;
import org.hbase.async.ColumnRangeFilter;
import org.hbase.async.FilterList;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.hbase.async.PutRequest;
import org.hbase.async.ScanFilter;
import org.hbase.async.Scanner;
import org.hbase.async.ValueFilter;

//import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseUserDao extends HbaseBaseDao {

    private Map<UUID, User> users = new HashMap<UUID, User>();

    @Autowired
    HbaseMetaDao MetaDao;

    public HbaseUserDao() {
        super("oddeyeusers");
    }

    public void addUser(User user) throws Exception {
        UUID uuid = user.getId();

//        byte[] buuid = Bytes.toBytes(uuid.toString());
//        java.util.Date date = new java.util.Date();        
        final PutRequest putUUID = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "UUID".getBytes(), uuid.toString().getBytes());
        final PutRequest putname = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "name".getBytes(), user.getName().getBytes());
        final PutRequest putemail = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "email".getBytes(), user.getEmail().getBytes());
        final PutRequest putlastname = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "lastname".getBytes(), user.getLastname().getBytes());

        if (user.getCompany() != null) {
            final PutRequest putcompany = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "company".getBytes(), user.getCompany().getBytes());
            client.put(putcompany);
        }
        if (user.getCountry() != null) {
            final PutRequest putcountry = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "country".getBytes(), user.getCountry().getBytes());
            client.put(putcountry);

        }
        if (user.getCity() != null) {
//            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("city"), Bytes.toBytes(user.getCity()));
            final PutRequest putcity = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "city".getBytes(), user.getCity().getBytes());
            client.put(putcity);
        }
        if (user.getRegion() != null) {
            final PutRequest putregion = new PutRequest(table, uuid.toString().getBytes(), "personalinfo".getBytes(), "region".getBytes(), user.getRegion().getBytes());
            client.put(putregion);
        }
        if (user.getPasswordByte() != null) {
            final PutRequest putpassword = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "password".getBytes(), user.getPasswordByte());
            client.put(putpassword);

        }
        if (user.getSolt() != null) {
            final PutRequest putsolt = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "solt".getBytes(), user.getSolt());
            client.put(putsolt);

        }
        if (user.getTimezone() != null) {
            final PutRequest puttimezone = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "timezone".getBytes(), user.getTimezone().getBytes());
            client.put(puttimezone);
        }
        if (user.getActive() != null) {
            final PutRequest putactive = new PutRequest(table, uuid.toString().getBytes(), "technicalinfo".getBytes(), "active".getBytes(), Bytes.fromInt(user.getActive() ? 1 : 0));
            client.put(putactive);
        }
        client.put(putUUID);
        client.put(putname);
        client.put(putemail);
        client.put(putlastname).join();

        //***************************OLD
//        Put row = new Put(buuid, date.getTime());
//        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("UUID"), Bytes.toBytes(uuid.toString()));
//        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("name"), Bytes.toBytes(user.getName()));
//        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("email"), Bytes.toBytes(user.getEmail()));
//        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("lastname"), Bytes.toBytes(user.getLastname()));
//        if (user.getCompany() != null) {
//            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("company"), Bytes.toBytes(user.getCompany()));
//        }
//        if (user.getCountry() != null) {
//            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("country"), Bytes.toBytes(user.getCountry()));
//        }
//        if (user.getCity() != null) {
//            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("city"), Bytes.toBytes(user.getCity()));
//        }
//        if (user.getRegion() != null) {
//            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("region"), Bytes.toBytes(user.getRegion()));
//        }
//        if (user.getPasswordByte() != null) {
//            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("password"), user.getPasswordByte());
//        }
//        if (user.getSolt() != null) {
//            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("solt"), user.getSolt());
//        }
//        if (user.getTimezone() != null) {
//            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("timezone"), Bytes.toBytes(user.getTimezone()));
//        }
//        if (user.getActive() != null) {
//            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("active"), Bytes.toBytes(user.getActive()));
//        }
//        try {
//            this.htable.put(row);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }

    public List<User> getAllUsers() {
        return new ArrayList<>(users.values());
    }

    public Boolean checkUserByEmail(String email) throws Exception {
//        this.client.get(null);

        final Scanner value_scanner = client.newScanner(table);

        final ArrayList<ScanFilter> filters = new ArrayList<>(2);
        filters.add(
                new ValueFilter(org.hbase.async.CompareFilter.CompareOp.EQUAL,
                        new org.hbase.async.BinaryComparator(email.getBytes())));
        filters.add(new ColumnPrefixFilter("email"));

        value_scanner.setFilter(new FilterList(filters));

        final ArrayList<ArrayList<KeyValue>> value_rows = value_scanner.nextRows().join();

        return value_rows.size() == 1;
    }

    public User getUserByEmail(String email) {
        return null;
    }

    public UUID CheckUserAuthentication(Authentication authentication) {
        String email = authentication.getName();
        String password = authentication.getCredentials().toString();

        final Scanner value_scanner = client.newScanner(table);

        value_scanner.setFamily("personalinfo");
        final ArrayList<ScanFilter> filters = new ArrayList<>(2);
        filters.add(
                new ValueFilter(org.hbase.async.CompareFilter.CompareOp.EQUAL,
                        new org.hbase.async.BinaryComparator(email.getBytes())));
//        filters.add(new ColumnRangeFilter("email"));

        value_scanner.setFilter(new FilterList(filters));

        try {
            final ArrayList<ArrayList<KeyValue>> value_rows = value_scanner.nextRows().join();
            if (value_rows.size() > 0) {
                boolean isvalidpass = false;
                byte[] bUUID = value_rows.get(0).get(0).key();
                GetRequest get = new GetRequest(table, bUUID, "technicalinfo".getBytes(), "password".getBytes());
                final ArrayList<KeyValue> passkvs = client.get(get).join();
                final KeyValue passkv = passkvs.get(0);
                get = new GetRequest(table, bUUID, "technicalinfo".getBytes(), "solt".getBytes());
                final ArrayList<KeyValue> soltkvs = client.get(get).join();
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
            e.printStackTrace();
        }

        return null;
    }

    public User getUserByUUID(UUID uuid) {

        try {
            GetRequest get = new GetRequest(table, uuid.toString().getBytes());
            final ArrayList<KeyValue> userkvs = client.get(get).join();
            User user = new User();
            
            final List<GrantedAuthority> grantedAuths = new ArrayList<>();
            grantedAuths.add(new SimpleGrantedAuthority("ROLE_USER"));
            user.inituser(userkvs, grantedAuths);
            user.setTags(MetaDao.getByUUID(user.getId()));
            return user;            
            
//        Get g = new Get(Bytes.toBytes(uuid.toString()));
//        try {
//            Result result = this.htable.get(g);
//            User user = new User();
//            final List<GrantedAuthority> grantedAuths = new ArrayList<>();
//            grantedAuths.add(new SimpleGrantedAuthority("ROLE_USER"));
//            user.inituser(result, grantedAuths);
//            user.setTags(MetaDao.getByUUID(user.getId()));
//            return user;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
            
        } catch (Exception ex) {
            Logger.getLogger(HbaseUserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
