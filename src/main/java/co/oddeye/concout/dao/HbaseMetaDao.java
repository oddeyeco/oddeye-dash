/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.MetaTags;
import co.oddeye.concout.model.User;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.filter.Filter;
import org.apache.hadoop.hbase.filter.PrefixFilter;
import org.springframework.stereotype.Repository;
import org.apache.hadoop.hbase.util.Bytes;
import org.eclipse.jdt.internal.compiler.lookup.TypeIds;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseMetaDao extends HbaseBaseDao {

    private static String tablename = "oddeyemeta";

    public HbaseMetaDao() {
        super(tablename);
    }

    public Map<String, Map<String, MetaTags>> getByUUID(UUID userid) {

        try {
            byte[] bvalue;
            String tagkey;
            String tagvalue;
            String datakey;
            Map<String, MetaTags> List;
            MetaTags TegItem;

            String key = userid.toString();
            byte[] prefix = Bytes.toBytes(key);
            Scan scan = new Scan(prefix);
            Filter prefixFilter = new PrefixFilter(prefix);
            scan.setFilter(prefixFilter);
            ResultScanner resultScanner = this.htable.getScanner(scan);
            Map<String, Map<String, MetaTags>> result = new HashMap();

            for (Result res : resultScanner) {
                bvalue = res.getValue(Bytes.toBytes("data"), Bytes.toBytes("tagkey"));
                tagkey = Bytes.toString(bvalue);
                if (result.containsKey(tagkey)) {
                    List = result.get(tagkey);
                } else {
                    List = new HashMap();
                    result.put(tagkey, List);
                }
                bvalue = res.getValue(Bytes.toBytes("data"), Bytes.toBytes("tagvalue"));
                tagvalue = Bytes.toString(bvalue);

                if (List.containsKey(tagvalue)) {
                    TegItem = List.get(tagvalue);
                } else {
                    TegItem = new MetaTags();
                    TegItem.setName(tagvalue);
                    List.put(tagvalue, TegItem);
                }
                bvalue = res.getValue(Bytes.toBytes("data"), Bytes.toBytes("datakey"));
                datakey = Bytes.toString(bvalue);

                TegItem.addDatakeys(datakey);

            }

//            Map<String, MetaTags> Tag = new HashMap();
//            result.put("valods", Tag);
//            Tag.put("host1", new MetaTags());
//            Tag.put("host2", new MetaTags());
//            Tag.put("host3", new MetaTags());
//            Tag.put("host4", new MetaTags());
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
