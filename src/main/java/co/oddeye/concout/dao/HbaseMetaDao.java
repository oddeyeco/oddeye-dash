/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.model.MetaTags;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeeyMetricMetaList;
import co.oddeye.core.OddeyeTag;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import java.util.Map;
import java.util.UUID;
import net.opentsdb.core.TSDB;
import net.opentsdb.utils.Config;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private BaseTsdbConnect BaseTsdbV;

    private static final String TBLENAME = "test_oddeye-meta";
    private OddeeyMetricMetaList MtrscList;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(HbaseMetaDao.class);

    public HbaseMetaDao() {
        super(TBLENAME);
    }

    public ConcoutMetricMetaList getByUUID(UUID userid) throws Exception {
        if (MtrscList == null) {
            try {
                MtrscList = new OddeeyMetricMetaList(BaseTsdbV.getTsdb(), TBLENAME.getBytes());
            } catch (Exception ex) {
                MtrscList = new OddeeyMetricMetaList();
            }
        }

        final ConcoutMetricMetaList result = new ConcoutMetricMetaList();
//        OddeyeTag tag = new OddeyeTag("UUID", userid.toString(), BaseTsdbV.getTsdb());

        for (Map.Entry<Integer, OddeeyMetricMeta> metric : MtrscList.entrySet()) {
            if (metric.getValue().getTags().containsKey("UUID")) {                
                if (metric.getValue().getTags().get("UUID").getValue().equals(userid.toString()))
                result.add(metric.getValue());
            }
        }
        
        return result;

    }

}
