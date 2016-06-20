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
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.Table;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.filter.BinaryComparator;
import org.apache.hadoop.hbase.filter.CompareFilter;
import org.apache.hadoop.hbase.filter.SingleColumnValueFilter;

//import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseUserDao {

    private Map<UUID, User> users = new HashMap<UUID, User>();
    private Table htable = null;

    public HbaseUserDao() {

        String tableName = "oddeyeusers";

        Configuration config = HBaseConfiguration.create();
        config.clear();

        config.set("hbase.zookeeper.quorum", "192.168.10.50");
        config.set("hbase.zookeeper.property.clientPort", "2181");
        config.set("zookeeper.session.timeout", "180");
        config.set("zookeeper.recovery.retry", Integer.toString(1));
        try {
            Connection connection = ConnectionFactory.createConnection(config);
            this.htable = connection.getTable(TableName.valueOf(tableName));
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (this.htable == null) {
            throw new RuntimeException("Hbase Table '" + tableName + "' Can not connect");
        }

    }

    public void addUser(User user) {
        UUID uuid = user.getId();

        byte[] buuid = Bytes.toBytes(uuid.toString());
        java.util.Date date = new java.util.Date();
        Put row = new Put(buuid, date.getTime());
        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("UUID"), Bytes.toBytes(uuid.toString()));
        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("name"), Bytes.toBytes(user.getName()));
        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("email"), Bytes.toBytes(user.getEmail()));
        row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("lastname"), Bytes.toBytes(user.getLastname()));
        if (user.getCompany() != null) {
            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("company"), Bytes.toBytes(user.getCompany()));
        }
        if (user.getCountry() != null) {
            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("country"), Bytes.toBytes(user.getCountry()));
        }
        if (user.getCity() != null) {
            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("city"), Bytes.toBytes(user.getCity()));
        }
        if (user.getRegion() != null) {
            row.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("region"), Bytes.toBytes(user.getRegion()));
        }
        if (user.getPasswordByte() != null) {
            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("password"), user.getPasswordByte());
        }
        if (user.getSolt() != null) {
            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("solt"), user.getSolt());
        }
        if (user.getTimezone() != null) {
            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("timezone"), Bytes.toBytes(user.getTimezone()));
        }
        if (user.getActive() != null) {
            row.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("active"), Bytes.toBytes(user.getActive()));
        }
        try {
            this.htable.put(row);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public List<User> getAllUsers() {
        return new ArrayList<User>(users.values());
    }

    public Boolean checkUserByEmail(String email) {
        SingleColumnValueFilter filter = new SingleColumnValueFilter(
                Bytes.toBytes("personalinfo"),
                Bytes.toBytes("email"),
                CompareFilter.CompareOp.EQUAL,
                new BinaryComparator(Bytes.toBytes(email)));
        filter.setFilterIfMissing(false);

//            Filter filter = new ValueFilter(CompareFilter.CompareOp.EQUAL,
//            new BinaryComparator(Bytes.toBytes(true)));
        Scan scan1 = new Scan();
        scan1.setFilter(filter);
        try {
            ResultScanner scanner1 = this.htable.getScanner(scan1);
            Boolean mailexist = false;
            for (Result res : scanner1) {
                mailexist = true;
                break;
            }
            scanner1.close();
            return mailexist;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return true;
    }

    public User getUserByEmail(String email) {
        return null;
    }

    public UUID CheckUserAuthentication(Authentication authentication) {
        String email = authentication.getName();
        String password = authentication.getCredentials().toString();

        SingleColumnValueFilter filter = new SingleColumnValueFilter(
                Bytes.toBytes("personalinfo"),
                Bytes.toBytes("email"),
                CompareFilter.CompareOp.EQUAL,
                new BinaryComparator(Bytes.toBytes(email)));
        filter.setFilterIfMissing(false);

//            Filter filter = new ValueFilter(CompareFilter.CompareOp.EQUAL,
//            new BinaryComparator(Bytes.toBytes(true)));
        Scan scan1 = new Scan();
        scan1.addColumn(Bytes.toBytes("personalinfo"), Bytes.toBytes("UUID"));
        scan1.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("password"));
        scan1.addColumn(Bytes.toBytes("technicalinfo"), Bytes.toBytes("solt"));
        scan1.setFilter(filter);
        try {
            ResultScanner scanner1 = this.htable.getScanner(scan1);
            Result result = null;
            Boolean mailexist = false;
            for (Result res : scanner1) {
                mailexist = true;
                break;
            }

            if (mailexist) {
                boolean isvalidpass = false;
                byte[] pass = result.getValue(Bytes.toBytes("technicalinfo"), Bytes.toBytes("password"));
                byte[] solt = result.getValue(Bytes.toBytes("technicalinfo"), Bytes.toBytes("solt"));                
                byte[] tmppassword = User.get_SHA_512_SecurePassword(password, solt);
                if (Arrays.equals(tmppassword, pass)) {
                    byte[] value = result.getValue(Bytes.toBytes("personalinfo"), Bytes.toBytes("UUID"));
                    return UUID.fromString(Bytes.toString(value));
                }
            }
            scanner1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public User getUserByUUID(UUID uuid) {
        Get g = new Get(Bytes.toBytes(uuid.toString()));
        try {
            Result result = this.htable.get(g);
            User user = new User();
            final List<GrantedAuthority> grantedAuths = new ArrayList<>();
            grantedAuths.add(new SimpleGrantedAuthority("ROLE_USER"));
            user.inituser(result, grantedAuths);
            return user;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
