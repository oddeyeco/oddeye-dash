/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.MetaTags;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
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
        MetaTags Temptags;
        String[] parts;
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
                    parts = new String(meta.qualifier()).split("/");
                    if (!parts[0].equals("UUID")) {
                        Temptags = tagvlist.getOrDefault(parts[0], new MetaTags());
                        Temptags.addDatakeys(parts[1]);
                        tagvlist.put(parts[0], Temptags);
                    }
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

    }

}
