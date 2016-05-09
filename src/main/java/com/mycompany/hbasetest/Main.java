/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.hbasetest;

import java.io.IOException;
import java.util.Random;
import java.util.UUID;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.HBaseAdmin;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.util.GenericOptionsParser;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.Cell;

/**
 *
 * @author vahan
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        System.out.println("Hello World");

        try {
            Configuration config = HBaseConfiguration.create();
            config.clear();
            config.set("hbase.zookeeper.quorum", "192.168.10.50");
            config.set("hbase.zookeeper.property.clientPort", "2181");
//            config.set("hbase.master", "192.168.15.20:60000");
            //HBaseConfiguration config = HBaseConfiguration.create();
            //config.set("hbase.zookeeper.quorum", "localhost");  // Here we are running zookeeper locally

            HBaseAdmin.checkHBaseAvailable(config);

            System.out.println("HBase is running!");

            HBaseAdmin admin = new HBaseAdmin(config);

            addTable("testoddeye", admin, config);
//            TableName tablename= TableName.valueOf("testoddeye");
//            admin.disableTable(tablename);
//            admin.deleteTable(tablename);
//            scan("usertable", admin, config);
        } catch (Exception ce) {
            ce.printStackTrace();

        }

    }

    public static void findeby(String table, String field, String value, HBaseAdmin admin, HBaseConfiguration config) {

    }

    public static void scan(String tablename, HBaseAdmin admin, HBaseConfiguration config) {
        try {
            HTable table = new HTable(config, tablename);
            Scan scan = new Scan();
            scan.setMaxResultSize(2);
            byte[] contactFamily = Bytes.toBytes("contactinfo");
            byte[] emailQualifier = Bytes.toBytes("email");
            byte[] nameFamily = Bytes.toBytes("name");
            byte[] firstNameQualifier = Bytes.toBytes("first");
            byte[] lastNameQualifier = Bytes.toBytes("last");

            ResultScanner results = table.getScanner(scan);
            for (Result result : results) {
                System.out.println("******************************");
                String id = new String(result.getRow());
                Cell[] cells = result.rawCells();
                for (Cell cell : cells) {
                    System.out.println(cell.toString());
                    byte[] valueObj = cell.getValue();
                    String value = new String(valueObj);
                    System.out.println(value);
                }
                System.out.println("******************************");
//                byte[] firstNameObj = result.getValue(nameFamily, firstNameQualifier);
//                String firstName = new String(firstNameObj);
//                byte[] lastNameObj = result.getValue(nameFamily, lastNameQualifier);
//                String lastName = new String(lastNameObj);
//                System.out.println(firstName + " " + lastName + " - ID: " + id);
//                byte[] emailObj = result.getValue(contactFamily, emailQualifier);
//                String email = new String(emailObj);
//                System.out.println(firstName + " " + lastName + " - " + email + " - ID: " + id);
            }
            results.close();
            table.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static void addTable(String name, HBaseAdmin admin, Configuration config) {
        try {

            // create the table...
            HTableDescriptor tableDescriptor = new HTableDescriptor(TableName.valueOf(name));
            // ... with two column families
            tableDescriptor.addFamily(new HColumnDescriptor("tags"));
            tableDescriptor.addFamily(new HColumnDescriptor("data"));

//            admin.createTable(tableDescriptor);
//            System.out.println("createTable");

            /*
             admin.disableTable(name);
             admin.deleteTable(name);*/
            // define some people
//            UUID uuid = UUID.randomUUID();
//
//            System.out.println(uuid.hashCode());
            HTable table = new HTable(config, name);
            System.out.println("Open Table");
            Random random = new Random();
            // Add each person to the table
            //   Use the `name` column family for the name
            //   Use the `contactinfo` column family for the email
            System.out.println("Start insert");
            for (int i = 0; i < 100000; i++) {                
                UUID uuid = UUID.randomUUID();
//                UUID uuid = UUID.fromString("1805df36-0cb0-4989-b8b9-6dac645ce464");

                byte[] buuid = Bytes.add(Bytes.toBytes(uuid.getMostSignificantBits()), Bytes.toBytes(uuid.getLeastSignificantBits()));
                java.util.Date date = new java.util.Date();
                Put person = new Put(buuid, date.getTime());
                person.add(Bytes.toBytes("tags"), Bytes.toBytes("uuid"), Bytes.toBytes(uuid.toString()));
                person.add(Bytes.toBytes("tags"), Bytes.toBytes("host"), Bytes.toBytes("tag_hostname" + i));
                person.add(Bytes.toBytes("tags"), Bytes.toBytes("type"), Bytes.toBytes("tag_type" + i));
                person.add(Bytes.toBytes("tags"), Bytes.toBytes("cluster"), Bytes.toBytes("tcluster_name" + i));
                person.add(Bytes.toBytes("tags"), Bytes.toBytes("group"), Bytes.toBytes("host_group" + i));

//                date. 
                person.add(Bytes.toBytes("tags"), Bytes.toBytes("timestamp"), Bytes.toBytes(date.getTime()));

                person.add(Bytes.toBytes("data"), Bytes.toBytes("cpu_user"), Bytes.toBytes(random.nextInt(100)));
                person.add(Bytes.toBytes("data"), Bytes.toBytes("cpu_idle"), Bytes.toBytes(random.nextInt(100)));
                person.add(Bytes.toBytes("data"), Bytes.toBytes("cpu_iadle"), Bytes.toBytes(random.nextInt(100)));
                person.add(Bytes.toBytes("data"), Bytes.toBytes("cpu_iowait"), Bytes.toBytes(random.nextInt(100)));
                table.put(person);
                System.out.println("Add "+i+" Raw");
            }
            // flush commits and close the table
            table.flushCommits();
            table.close();
            System.out.println("Add rows");
        } catch (Exception ce) {
            ce.printStackTrace();

        }
    }

}
