/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.MetaTags;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.opentsdb.core.TSDB;
import net.opentsdb.utils.Config;
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

    private static final String tablename = "oddeyemeta";
    private static TSDB tsdb;

    public HbaseMetaDao() {
        super(tablename);
        
        try {
            Config openTsdbConfig = new net.opentsdb.utils.Config(true);
            openTsdbConfig.overrideConfig("tsd.core.auto_create_metrics", "true");
            openTsdbConfig.overrideConfig("tsd.storage.hbase.data_table", "test_tsdb");
            openTsdbConfig.overrideConfig("tsd.storage.hbase.uid_table", "test_tsdb-uid");
            this.tsdb = new TSDB(
                    this.client,
                    openTsdbConfig);        
        } catch (IOException ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Map<String, Map<String, MetaTags>> getByUUID(UUID userid) {
        
        List<String> sss = this.tsdb.suggestTagNames(tablename);
        
        
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
