/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.MetaTags;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.opentsdb.core.TSDB;
import net.opentsdb.uid.UniqueId;
import net.opentsdb.utils.Config;
import org.hbase.async.ColumnPrefixFilter;
import org.hbase.async.FilterList;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.hbase.async.ScanFilter;
import org.hbase.async.Scanner;
import org.hbase.async.ValueFilter;
//import org.apache.hadoop.hbase.client.Result;
//import org.apache.hadoop.hbase.client.ResultScanner;
//import org.apache.hadoop.hbase.client.Scan;
//import org.apache.hadoop.hbase.filter.Filter;
//import org.apache.hadoop.hbase.filter.PrefixFilter;
//import org.apache.hadoop.hbase.util.Bytes;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseMetaDao extends HbaseBaseDao {

    private static final String tablename = "oddeye_tsdb_meta";

    public HbaseMetaDao() {
        super(tablename);
    }

    public Map<String, Map<String, MetaTags>> getByUUID(UUID userid) {
       Map<String, Map<String, MetaTags>> tagslist = new HashMap<>();
       Map<String, MetaTags> metricslist = new HashMap<>();
       Map<String, MetaTags> tagklist = new HashMap<>();
       Map<String, MetaTags> tagvlist = new HashMap<>();
       
       
        try {
            GetRequest get = new GetRequest(table, userid.toString().getBytes());
            final ArrayList<KeyValue> metalist = client.get(get).join();
            for (KeyValue meta : metalist) {
                if (Arrays.equals(meta.family(), "metrics".getBytes())) {
                    metricslist.put(new String(meta.qualifier()), null);
                }
                if (Arrays.equals(meta.family(), "tagks".getBytes())) {
                    tagklist.put(new String(meta.qualifier()), null);
                }                
                if (Arrays.equals(meta.family(), "tagvs".getBytes())) {
                    tagvlist.put(new String(meta.qualifier()), null);
                }                                
            }
            
            tagslist.put("metrics", metricslist);
            tagslist.put("tagks", tagklist);
            tagslist.put("tagvs", tagvlist);
            return tagslist;
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;

//        try {
//            byte[] bvalue;
//            String tagkey;
//            String tagvalue;
//            String datakey;
//            Map<String, MetaTags> List;
//            MetaTags TegItem;
//
//            String key = userid.toString();
//            byte[] prefix = Bytes.toBytes(key);
//            Scan scan = new Scan(prefix);
//            Filter prefixFilter = new PrefixFilter(prefix);
//            scan.setFilter(prefixFilter);
//            ResultScanner resultScanner = this.htable.getScanner(scan);
//            Map<String, Map<String, MetaTags>> result = new HashMap();
//
//            for (Result res : resultScanner) {
//                bvalue = res.getValue(Bytes.toBytes("data"), Bytes.toBytes("tagkey"));
//                tagkey = Bytes.toString(bvalue);
//                if (result.containsKey(tagkey)) {
//                    List = result.get(tagkey);
//                } else {
//                    List = new HashMap();
//                    result.put(tagkey, List);
//                }
//                bvalue = res.getValue(Bytes.toBytes("data"), Bytes.toBytes("tagvalue"));
//                tagvalue = Bytes.toString(bvalue);
//
//                if (List.containsKey(tagvalue)) {
//                    TegItem = List.get(tagvalue);
//                } else {
//                    TegItem = new MetaTags();
//                    TegItem.setName(tagvalue);
//                    List.put(tagvalue, TegItem);
//                }
//                bvalue = res.getValue(Bytes.toBytes("data"), Bytes.toBytes("datakey"));
//                datakey = Bytes.toString(bvalue);
//
//                TegItem.addDatakeys(datakey);
//
//            }
//
////            Map<String, MetaTags> Tag = new HashMap();
////            result.put("valods", Tag);
////            Tag.put("host1", new MetaTags());
////            Tag.put("host2", new MetaTags());
////            Tag.put("host3", new MetaTags());
////            Tag.put("host4", new MetaTags());
//            return result;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
    }

}
