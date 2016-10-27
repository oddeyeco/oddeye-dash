/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.core.OddeeyMetricMeta;
import com.stumbleupon.async.Deferred;
import java.util.ArrayList;

import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.hbase.async.DeleteRequest;
import org.hbase.async.HBaseClient;
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
    private ConcoutMetricMetaList MtrscList;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(HbaseMetaDao.class);

    public HbaseMetaDao() {
        super(TBLENAME);
    }

    public ConcoutMetricMetaList getByUUID(UUID userid) throws Exception {
        if ((MtrscList == null) || (MtrscList.isEmpty())) {
            try {
                MtrscList = new ConcoutMetricMetaList(BaseTsdbV.getTsdb(), TBLENAME.getBytes());
            } catch (Exception ex) {
                MtrscList = new ConcoutMetricMetaList();
            }
        }

        final ConcoutMetricMetaList result = new ConcoutMetricMetaList();
//        OddeyeTag tag = new OddeyeTag("UUID", userid.toString(), BaseTsdbV.getTsdb());
        MtrscList.entrySet().stream().filter((metric) -> (metric.getValue().getTags().containsKey("UUID"))).filter((metric) -> (metric.getValue().getTags().get("UUID").getValue().equals(userid.toString()))).forEach((Map.Entry<Integer, OddeeyMetricMeta> metric) -> {
            result.add(metric.getValue());
        });

        return result;

    }

    public OddeeyMetricMeta deleteMeta(Integer hash, UUID userid) {
        if (MtrscList.get(hash) != null) {
            return deleteMeta(MtrscList.get(hash), userid);
        }
        return null;
    }

    public OddeeyMetricMeta deleteMeta(OddeeyMetricMeta meta, UUID userid) {
        final HBaseClient client = BaseTsdbV.getTsdb().getClient();
        final DeleteRequest req = new DeleteRequest(TBLENAME.getBytes(), meta.getKey());

        if (!meta.getTags().get("UUID").getValue().equals(userid.toString())) {
            return meta;
        }
        try {
            client.delete(req).joinUninterruptibly();
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return meta;
        }
        return MtrscList.remove(meta.hashCode());
    }

    public boolean deleteMetaByTag(String tagK, String tagV, UUID userid) {

        final HBaseClient client = BaseTsdbV.getTsdb().getClient();

        ArrayList<OddeeyMetricMeta> MtrList;
        try {
            MtrList = MtrscList.getbyTag(tagK, tagV);
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        final ArrayList<Deferred<Object>> result = new ArrayList<>(MtrList.size());
        for (OddeeyMetricMeta meta : MtrList) {
            if (!meta.getTags().get("UUID").getValue().equals(userid.toString())) {
                continue;
            }

            final DeleteRequest req = new DeleteRequest(TBLENAME.getBytes(), meta.getKey());
            try {
                result.add(client.delete(req));
            } catch (Exception ex) {
                Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
                return false;
            }
            MtrscList.remove(meta.hashCode());
        }
        try {
//            client.flush().joinUninterruptibly();
            Deferred.groupInOrder(result).joinUninterruptibly();
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        return true;
    }

}
