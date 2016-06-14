/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.User;
import java.util.ArrayList;
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

//import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

//        config.set("hbase.zookeeper.quorum", String.valueOf(conf.get("zookeeper.quorum")));
//        config.set("hbase.zookeeper.property.clientPort", String.valueOf(conf.get("zookeeper.clientPort")));
        config.set("hbase.zookeeper.quorum", "192.168.10.50");
        config.set("hbase.zookeeper.property.clientPort", "2181");
        try {
            Connection connection = ConnectionFactory.createConnection(config);
            this.htable = connection.getTable(TableName.valueOf(tableName));
        } catch (Exception e) {
            e.printStackTrace();

        }
        if (this.htable == null) {
            throw new RuntimeException("Hbase Table '" + tableName + "' Can not connect");
        }

//        Scan scan = new Scan();
//        try {
//            ResultScanner scanner = this.htable.getScanner(scan);
//            for (Result result = scanner.next(); result != null; result = scanner.next()) {
//                users.put(UUID.fromString(new String(result.getRow())), null);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
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

    public User getUserByEmail(String email) {
        return null;
    }

    public User getUserByUUID(UUID uuid) {
        Get g = new Get(Bytes.toBytes(uuid.toString()));
        try {
            Result result = this.htable.get(g);
            User user = new User();
            user.inituser(result);
            return user;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
