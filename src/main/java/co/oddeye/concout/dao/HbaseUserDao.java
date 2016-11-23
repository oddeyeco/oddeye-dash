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
import java.util.TreeMap;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.opentsdb.uid.UniqueId;
import org.hbase.async.Bytes;
import org.hbase.async.ColumnPrefixFilter;
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

    @Autowired
    private BaseTsdbConnect BaseTsdb;
    @Autowired
    HbaseMetaDao MetaDao;

    byte[] dashtable = "oddeyeDushboards".getBytes();

    private final Map<UUID, User> users = new HashMap<>();

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
        BaseTsdb.getClient().put(putUUID);
        BaseTsdb.getClient().put(putname);
        BaseTsdb.getClient().put(putemail);
        BaseTsdb.getClient().put(putlastname).join();
    }

    public List<User> getAllUsers() {
        return new ArrayList<>(users.values());
    }

    public Boolean checkUserByEmail(String email) throws Exception {
//        this.client.get(null);

        final Scanner value_scanner = BaseTsdb.getClient().newScanner(table);

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

        final Scanner value_scanner = BaseTsdb.getClient().newScanner(table);

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
            e.printStackTrace();
        }

        return null;
    }

    public User getUserByUUID(UUID uuid) {

        try {
            GetRequest get = new GetRequest(table, uuid.toString().getBytes());
            final ArrayList<KeyValue> userkvs = BaseTsdb.getClient().get(get).join();
            User user = new User();

            final List<GrantedAuthority> grantedAuths = new ArrayList<>();
            grantedAuths.add(new SimpleGrantedAuthority("ROLE_USER"));
            user.inituser(userkvs, grantedAuths);
            user.setTsdbID(BaseTsdb.getTsdb().getUID(UniqueId.UniqueIdType.TAGV, user.getId().toString()));
//            user.setMetricsMeta(MetaDao.getByUUID(user.getId()));
            user.setDushList(getAllDush(uuid));
            return user;

        } catch (Exception ex) {
            Logger.getLogger(HbaseUserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public void saveDush(UUID id, String DushName, String DushInfo) {
        if (DushName != null) {
            final PutRequest put = new PutRequest(dashtable, id.toString().getBytes(), "data".getBytes(), DushName.getBytes(), DushInfo.getBytes());
            BaseTsdb.getClient().put(put);
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

    public void saveUserPersonalinfo(User user, Map<String, Object> changedata) throws Exception {
        if (changedata.size() > 0) {
            byte[][] qualifiers =new byte[changedata.size()][];
            byte[][] values =new byte[changedata.size()][];
            int index = 0;
            for (Map.Entry<String, Object> data:changedata.entrySet())
            {
              qualifiers[index] = data.getKey().getBytes();
              values[index] = data.getValue().toString().getBytes();
              index++;  
            }
            PutRequest request = new PutRequest(table,user.getId().toString().getBytes(),"personalinfo".getBytes(),qualifiers,values);
            BaseTsdb.getClient().put(request).joinUninterruptibly();
        }        
    }
}
