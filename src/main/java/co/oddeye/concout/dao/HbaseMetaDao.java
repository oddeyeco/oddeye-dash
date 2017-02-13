/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.core.MetricErrorMeta;
import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.model.User;
import co.oddeye.core.InvalidKeyException;
import co.oddeye.core.MetriccheckRule;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.stumbleupon.async.Deferred;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Calendar;

import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.opentsdb.query.QueryUtil;
import net.opentsdb.uid.UniqueId;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.DeleteRequest;
import org.hbase.async.GetRequest;
import org.hbase.async.HBaseClient;
import org.hbase.async.KeyValue;
import org.hbase.async.Scanner;
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
    private final ConcoutMetricMetaList fullmetalist = new ConcoutMetricMetaList();
    public static final String TBLENAME = "test_oddeye-meta";
//    private ConcoutMetricMetaList MtrscList;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(HbaseMetaDao.class);

    public HbaseMetaDao() {
        super(TBLENAME);
    }

    public Map<String, MetriccheckRule> getErrorRules(MetricErrorMeta meta, long time) throws Exception {
        Calendar CalendarObj = Calendar.getInstance();
        CalendarObj.setTimeInMillis(time * 1000);
        CalendarObj.add(Calendar.DATE, -1);
        return meta.getRules(CalendarObj, 7, table, BaseTsdbV.getClient());
    }

    public OddeeyMetricMeta getByKey(byte[] key) throws Exception {

//        final byte[][] Qualifiers = new byte[][]{"n".getBytes(), "timestamp".getBytes(), "Special".getBytes(), "Regression".getBytes()};
        GetRequest request = new GetRequest(table, key, "d".getBytes());
        ArrayList<KeyValue> row = BaseTsdbV.getClient().get(request).joinUninterruptibly();
        if (row.size() > 0) {           
            return new OddeeyMetricMeta(row, BaseTsdbV.getTsdb(), false);
        }
        else
        {
            LOGGER.warn("Key "+Hex.encodeHexString(key)+" Not Found in database");
        }
        
        return null;
        

    }

    public ConcoutMetricMetaList getByUUID(UUID userid) throws Exception {

        Scanner scanner = BaseTsdbV.getClient().newScanner(table);
        scanner.setServerBlockCache(false);
        scanner.setMaxNumRows(1000);
        scanner.setFamily("d".getBytes());
//        scanner.setQualifier("n".getBytes());
//        byte[][] Qualifiers = new byte[2][];
//        Qualifiers[0] = "n".getBytes();
//        Qualifiers[1] = "timestamp".getBytes();
        final byte[][] Qualifiers = new byte[][]{"n".getBytes(), "timestamp".getBytes(), "type".getBytes(), "Regression".getBytes()};
        scanner.setQualifiers(Qualifiers);

        byte[] key = new byte[0];
      
        key = ArrayUtils.addAll(key, BaseTsdbV.getTsdb().getUID(UniqueId.UniqueIdType.TAGK, "UUID"));
        key = ArrayUtils.addAll(key, BaseTsdbV.getTsdb().getUID(UniqueId.UniqueIdType.TAGV, userid.toString()));

        StringBuilder buffer = new StringBuilder();
        buffer.append("\\Q");
        QueryUtil.addId(buffer, key, true);
        scanner.setKeyRegexp(buffer.toString(), Charset.forName("ISO-8859-1"));
    
        final ConcoutMetricMetaList result = new ConcoutMetricMetaList();
        ArrayList<ArrayList<KeyValue>> rows;
        while ((rows = scanner.nextRows(10000).joinUninterruptibly()) != null) {
            for (final ArrayList<KeyValue> row : rows) {
                try {
                    OddeeyMetricMeta meta = new OddeeyMetricMeta(row, BaseTsdbV.getTsdb(), false);
                    if (meta.getTags().get("UUID").getValue().equals(userid.toString())) {
                        OddeeyMetricMeta add = result.add(meta);
                    } else {
                        LOGGER.info("Oter User ID"); 
                    }
                } catch (InvalidKeyException e) {
                    LOGGER.warn("InvalidKeyException " + row + " Is deleted");
                    final DeleteRequest deleterequest = new DeleteRequest(table, row.get(0).key());
                    BaseTsdbV.getClient().delete(deleterequest).joinUninterruptibly();
                } catch (Exception e) {
                    LOGGER.warn(globalFunctions.stackTrace(e));
                    LOGGER.warn("Can not add row to metrics " + row);
                }

            }
        }

        getFullmetalist().putAll(result);
        return result;

    }

    public OddeeyMetricMeta deleteMeta(Integer hash, User user) {
        if (user.getMetricsMeta().get(hash) != null) {
            return deleteMeta(user.getMetricsMeta().get(hash), user);
        }
        return null;
    }

    public OddeeyMetricMeta deleteMeta(OddeeyMetricMeta meta, User user) {
        final HBaseClient client = BaseTsdbV.getTsdb().getClient();
        final DeleteRequest req = new DeleteRequest(TBLENAME.getBytes(), meta.getKey());

        if (!meta.getTags().get("UUID").getValue().equals(user.getId().toString())) {
            return meta;
        }
        try {
            client.delete(req).joinUninterruptibly();
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return meta;
        }
        getFullmetalist().remove(meta.hashCode());
        return user.getMetricsMeta().remove(meta.hashCode());
    }

    public boolean deleteMetaByTag(String tagK, String tagV, User user) {

        final HBaseClient client = BaseTsdbV.getTsdb().getClient();

        ArrayList<OddeeyMetricMeta> MtrList;
        try {
            MtrList = user.getMetricsMeta().getbyTag(tagK, tagV);
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        final ArrayList<Deferred<Object>> result = new ArrayList<>(MtrList.size());
        for (OddeeyMetricMeta meta : MtrList) {
            if (!meta.getTags().get("UUID").getValue().equals(user.getId().toString())) {
                continue;
            }

            final DeleteRequest req = new DeleteRequest(TBLENAME.getBytes(), meta.getKey());
            try {
                result.add(client.delete(req));
            } catch (Exception ex) {
                Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
                return false;
            }
            getFullmetalist().remove(meta.hashCode());
            user.getMetricsMeta().remove(meta.hashCode());
        }
        try {
            Deferred.groupInOrder(result).joinUninterruptibly();
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        return true;
    }

    /**
     * @return the fullmetalist
     */
    public ConcoutMetricMetaList getFullmetalist() {
        return fullmetalist;
    }

    public boolean deleteMetaByName(String name, User user) {
        final HBaseClient client = BaseTsdbV.getTsdb().getClient();

        ArrayList<OddeeyMetricMeta> MtrList;
        try {
            MtrList = user.getMetricsMeta().getbyName(name);
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        final ArrayList<Deferred<Object>> result = new ArrayList<>(MtrList.size());
        for (OddeeyMetricMeta meta : MtrList) {
            if (!meta.getTags().get("UUID").getValue().equals(user.getId().toString())) {
                continue;
            }

            final DeleteRequest req = new DeleteRequest(TBLENAME.getBytes(), meta.getKey());
            try {
                result.add(client.delete(req));
            } catch (Exception ex) {
                Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
                return false;
            }
            getFullmetalist().remove(meta.hashCode());
            user.getMetricsMeta().remove(meta.hashCode());
        }
        try {
            Deferred.groupInOrder(result).joinUninterruptibly();
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        return true;
    }

    public OddeeyMetricMeta updateMeta(OddeeyMetricMeta metric) {
        metric.update(table,BaseTsdbV.getTsdb().getClient());
        return metric;
    }

}
