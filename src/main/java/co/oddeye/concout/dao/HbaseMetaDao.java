/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.config.DatabaseConfig;
import co.oddeye.core.MetricErrorMeta;
import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.core.SendToKafka;
import co.oddeye.concout.model.User;
import co.oddeye.core.AddMeta;
import co.oddeye.core.MetriccheckRule;
import co.oddeye.core.OddeeyMetricMeta;
import com.google.common.util.concurrent.ThreadFactoryBuilder;
import com.stumbleupon.async.Callback;
import com.stumbleupon.async.Deferred;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Calendar;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
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
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseMetaDao extends HbaseBaseDao {

    private final ConcoutMetricMetaList fullmetalist = new ConcoutMetricMetaList();
//    private ConcoutMetricMetaList MtrscList;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(HbaseMetaDao.class);

    public HbaseMetaDao(DatabaseConfig p_config) {
        super(p_config.getMetaTable());
    }

    public Map<String, MetriccheckRule> getErrorRules(MetricErrorMeta meta, long time) throws Exception {
        Calendar CalendarObj = Calendar.getInstance();
        CalendarObj.setTimeInMillis(time * 1000);
        CalendarObj.add(Calendar.DATE, -1);
        return meta.getRules(CalendarObj, 7, table, BaseTsdb.getClient());
    }

    public OddeeyMetricMeta getByKey(byte[] key) throws Exception {
        GetRequest request = new GetRequest(table, key, "d".getBytes());
        ArrayList<KeyValue> row = BaseTsdb.getClient().get(request).joinUninterruptibly();
        if (row.size() > 0) {
            final OddeeyMetricMeta meta = new OddeeyMetricMeta(row, BaseTsdb.getTsdb(), false);
            fullmetalist.put(meta.hashCode(), meta);
            return fullmetalist.get(meta.hashCode());
        } else {
            LOGGER.warn("Key " + Hex.encodeHexString(key) + " Not Found in database");
        }
        return null;

    }

    public ConcoutMetricMetaList getByUUID(UUID userid) throws Exception {

        Scanner scanner = BaseTsdb.getClient().newScanner(table);
        scanner.setServerBlockCache(false);
        scanner.setMaxNumRows(10000);
        scanner.setFamily("d".getBytes());
        final byte[][] Qualifiers = new byte[][]{"n".getBytes(), "timestamp".getBytes(), "type".getBytes(), "Regression".getBytes()};
        scanner.setQualifiers(Qualifiers);

        byte[] key = new byte[0];

        key = ArrayUtils.addAll(key, BaseTsdb.getTsdb().getUID(UniqueId.UniqueIdType.TAGK, "UUID"));
        key = ArrayUtils.addAll(key, BaseTsdb.getTsdb().getUID(UniqueId.UniqueIdType.TAGV, userid.toString()));

        StringBuilder buffer = new StringBuilder();
        buffer.append("\\Q");
        QueryUtil.addId(buffer, key, true);
        scanner.setKeyRegexp(buffer.toString(), Charset.forName("ISO-8859-1"));

        final ConcoutMetricMetaList result = new ConcoutMetricMetaList();
        ThreadFactory namedThreadFactory = new ThreadFactoryBuilder()
                .setNameFormat("AddMeta-thread-%d-"+userid.toString()).setPriority(10)
                .build();
        ExecutorService executor = Executors.newFixedThreadPool(8,namedThreadFactory);
        // Callback class to keep scanning recursively.        
        class cb implements Callback<Object, ArrayList<ArrayList<KeyValue>>> {
            @Override
            public Object call(final ArrayList<ArrayList<KeyValue>> rows) {
                if (rows == null) {
                    return null;
                }
                try {                    
                    for (final ArrayList<KeyValue> row : rows) {                        
                        executor.submit(new AddMeta(row, BaseTsdb.getTsdb(), BaseTsdb.getClient(), table, result));                        
                    }
//                    return rows;
                    return scanner.nextRows().addCallback(this);
                } catch (AssertionError e) {
                    throw new RuntimeException("Asynchronous failure", e);
                }
            }
        }

        try {
            scanner.nextRows().addCallbacks(new cb(), Callback.PASSTHROUGH).join();            
        } finally {
            scanner.close().join();
            executor.shutdown();
        }

//        ExecutorService executor = Executors.newCachedThreadPool();
//        while ((rows = scanner.nextRows().joinUninterruptibly()) != null) {
//            for (final ArrayList<KeyValue> row : rows) {
//                executor.submit(new AddMeta(row, BaseTsdb.getTsdb(), BaseTsdb.getClient(), table, result));
//            }
//        }                
//        executor.shutdown();
//        new OddeeyMetricMetaList.AddMeta()
//        while ((rows = scanner.nextRows(10000).joinUninterruptibly()) != null) {
//            for (final ArrayList<KeyValue> row : rows) {
//                try {
//                    OddeeyMetricMeta meta = new OddeeyMetricMeta(row, BaseTsdb.getTsdb(), false);
//                    if (meta.getTags().get("UUID").getValue().equals(userid.toString())) {
//                        OddeeyMetricMeta add = result.add(meta);
//                    } else {
//                        LOGGER.info("Oter User ID");
//                    }
//                } catch (InvalidKeyException e) {
//                    LOGGER.warn("InvalidKeyException " + row + " Is deleted");
//                    final DeleteRequest deleterequest = new DeleteRequest(table, row.get(0).key());
//                    BaseTsdb.getClient().delete(deleterequest).joinUninterruptibly();
//                } catch (Exception e) {
//                    LOGGER.warn(globalFunctions.stackTrace(e));
//                    LOGGER.warn("Can not add row to metrics " + row);
//                }
//
//            }
//        }
//        getFullmetalist().putAll(result);
        return result;
    }

    public OddeeyMetricMeta deleteMeta(Integer hash, User user) {
        if (user.getMetricsMeta().get(hash) != null) {
            return deleteMeta(user.getMetricsMeta().get(hash), user);
        }
        return null;
    }

    public OddeeyMetricMeta deleteMeta(OddeeyMetricMeta meta, User user) {
        final HBaseClient client = BaseTsdb.getTsdb().getClient();
        final DeleteRequest req = new DeleteRequest(table, meta.getKey());

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

        final HBaseClient client = BaseTsdb.getTsdb().getClient();

        ConcoutMetricMetaList MtrList;
        try {
            MtrList = user.getMetricsMeta().getbyTag(tagK, tagV);
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        final ArrayList<Deferred<Object>> result = new ArrayList<>(MtrList.size());
        for (Map.Entry<Integer, OddeeyMetricMeta> metaentry : MtrList.entrySet()) {
            OddeeyMetricMeta meta = metaentry.getValue();
            if (!meta.getTags().get("UUID").getValue().equals(user.getId().toString())) {
                continue;
            }

            final DeleteRequest req = new DeleteRequest(table, meta.getKey());
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
        final HBaseClient client = BaseTsdb.getTsdb().getClient();

        ConcoutMetricMetaList MtrList;
        try {
            MtrList = user.getMetricsMeta().getbyName(name);
        } catch (Exception ex) {
            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        final ArrayList<Deferred<Object>> result = new ArrayList<>(MtrList.size());
        for (Map.Entry<Integer, OddeeyMetricMeta> metaentry : MtrList.entrySet()) {
            OddeeyMetricMeta meta = metaentry.getValue();
            if (!meta.getTags().get("UUID").getValue().equals(user.getId().toString())) {
                continue;
            }

            final DeleteRequest req = new DeleteRequest(table, meta.getKey());
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

    public ArrayList<Deferred<Object>> deleteMetaByList(ConcoutMetricMetaList MtrList, User user, SendToKafka sk) {
        final HBaseClient client = BaseTsdb.getTsdb().getClient();
        final ArrayList<Deferred<Object>> result = new ArrayList<>(MtrList.size());
        for (Map.Entry<Integer, OddeeyMetricMeta> metaentry : MtrList.entrySet()) {
            OddeeyMetricMeta meta = metaentry.getValue();
            if (!meta.getTags().get("UUID").getValue().equals(user.getId().toString())) {
                continue;
            }

            final DeleteRequest req = new DeleteRequest(table, meta.getKey());
            try {
                Callback<Object, Object> cb = new Callback<Object, Object>() {
                    @Override
                    public Object call(Object t) throws Exception {
                        sk.run(user, "deletemetricbyhash", meta.hashCode());
                        return t;
                    }
                };
                result.add(client.delete(req).addCallback(cb));
            } catch (Exception ex) {
                Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
                return null;
            }
            getFullmetalist().remove(meta.hashCode());
            user.getMetricsMeta().remove(meta.hashCode());
        }
        return result;
//        try {
//            Deferred.groupInOrder(result).joinUninterruptibly();
//        } catch (Exception ex) {
//            Logger.getLogger(HbaseMetaDao.class.getName()).log(Level.SEVERE, null, ex);
//            return false;
//        }
//        return null;
    }

    public OddeeyMetricMeta updateMeta(OddeeyMetricMeta metric) {
        metric.update(table, BaseTsdb.getTsdb().getClient());
        return metric;
    }

}
