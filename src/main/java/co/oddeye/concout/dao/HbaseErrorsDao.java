/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.config.DatabaseConfig;
import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.core.MetricErrorMeta;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import net.opentsdb.query.QueryUtil;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.BinaryComparator;
import org.hbase.async.CompareFilter;
import org.hbase.async.DeleteRequest;
import org.hbase.async.GetRequest;
import org.hbase.async.HBaseClient;
import org.hbase.async.KeyValue;
import org.hbase.async.QualifierFilter;
import org.hbase.async.Scanner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.hbase.async.FilterList;
import org.hbase.async.KeyRegexpFilter;
import org.hbase.async.ScanFilter;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseErrorsDao extends HbaseBaseDao {

    @Autowired
    HbaseMetaDao MetaDao;    
    
    private final Logger LOGGER = LoggerFactory.getLogger(HbaseErrorsDao.class);    
    private final String TABLENAME_LAST ;    
    private HBaseClient client;
    private short weight;
    private double persent_weight;
    private double value;
    private short stat_weight;
    private double persent_predict;

    public HbaseErrorsDao(DatabaseConfig p_config) {
        super(p_config.getErrorsTable());        
        TABLENAME_LAST = p_config.getErrorsLastTable();
    }

    public ArrayList<ArrayList<KeyValue>> getActiveErrors(OddeyeUserModel user) throws Exception {
        client = BaseTsdb.getClient();
        Scanner scanner = client.newScanner(TABLENAME_LAST);
        scanner.setServerBlockCache(false);
        scanner.setFamily("l".getBytes());
        byte[] key = user.getTsdbID();
//        byte[] key = ArrayUtils.addAll(globalFunctions.getDayKey(metric.getErrorState().getTime()), user.getTsdbID());

        StringBuilder buffer = new StringBuilder();
        buffer.append("(?s)(");
        buffer.append("\\Q");
        QueryUtil.addId(buffer, key, true);
        buffer.append(")(.*)$");
        final ArrayList<ScanFilter> filters = new ArrayList<>();
        filters.add(new KeyRegexpFilter(buffer.toString()));
        scanner.setFilter(new FilterList(filters));

        ArrayList<ArrayList<KeyValue>> all_rows = new ArrayList<>();
        ArrayList<ArrayList<KeyValue>> rows;
        while ((rows = scanner.nextRows(1000).joinUninterruptibly()) != null) {
            all_rows.addAll(rows);
        }
        scanner.close();

        return all_rows;

//        Internal.getScanner(query);
//        buf.append((char) (1 & 0xFF));
    }

    public MetricErrorMeta getErrorMeta(OddeyeUserModel user, byte[] key, long time) throws Exception {
        Calendar Date = Calendar.getInstance();
        Date.setTimeInMillis(time);
        client = BaseTsdb.getClient();
        byte[] tablekey = user.getTsdbID();
        tablekey = ArrayUtils.addAll(tablekey, ByteBuffer.allocate(8).putLong(time).array());

        GetRequest request = new GetRequest(table, tablekey, "d".getBytes(), key);
        ArrayList<KeyValue> curent_row = client.get(request).joinUninterruptibly();
        MetricErrorMeta e = null;
        for (final KeyValue kv : curent_row) {
            e = new MetricErrorMeta(kv.qualifier(), BaseTsdb.getTsdb());
            weight = ByteBuffer.wrap(kv.value()).getShort();
            persent_weight = ByteBuffer.wrap(kv.value()).getDouble(2);
            value = ByteBuffer.wrap(kv.value()).getDouble(10);
            e.setTimestamp(time);
            e.setValue(value);
            e.setWeight(weight);
            e.setPersent_weight(persent_weight);
        }
        if (e == null) {
            return null;
        }
        GetRequest getRegression = new GetRequest(MetaDao.getTablename().getBytes(), e.getKey(), "d".getBytes(), "Regression".getBytes());
        ArrayList<KeyValue> Regressiondata = client.get(getRegression).joinUninterruptibly();
        for (KeyValue Regression : Regressiondata) {
            if (Arrays.equals(Regression.qualifier(), "Regression".getBytes())) {
                e.setSerializedRegression(Regression.value());
            }
        }
        //get  Recurrence
        final byte[] start_row;
        final byte[] end_row;
//        final Map<Long, ConcoutMetricMetaList> result = new TreeMap<>();

//        Date.setTimeInMillis((time * 1000)+1);
        end_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong(time + 1).array());

//        Date.add(Calendar.MINUTE, -60);
        start_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong(time - (60 * 60)).array());

        Scanner scanner = client.newScanner(table);
        scanner.setServerBlockCache(false);
        scanner.setFamily("d".getBytes());
        scanner.setStartKey(start_row);
        scanner.setStopKey(end_row);
        QualifierFilter filter = new QualifierFilter(CompareFilter.CompareOp.EQUAL, new BinaryComparator(key));
        scanner.setFilter(filter);

        try {
            ArrayList<ArrayList<KeyValue>> rows;
            while ((rows = scanner.nextRows(1000).joinUninterruptibly()) != null) {
                for (ArrayList<KeyValue> row : rows) {
                    for (final KeyValue kv : row) {
//                        datapart = Arrays.copyOfRange(kv.value(), 0, 2);
                        stat_weight = ByteBuffer.wrap(kv.value()).getShort();
//                        datapart = Arrays.copyOfRange(kv.value(), 2, 10);
                        persent_weight = ByteBuffer.wrap(kv.value()).getDouble(2);
                        value = ByteBuffer.wrap(kv.value()).getDouble(10);

                        if (Math.abs(stat_weight) < Math.abs(weight)) {
                            continue;
                        }

                        long stat_time = getTime(kv.key());
                        long divator = time - stat_time;
                        if (divator < 60) {
                            e.setRecurrence1m(e.getRecurrence1m() + 1);
                        } else {
                            if (divator < 120) {
                                e.setRecurrenceLast1m(e.getRecurrenceLast1m() + 1);
                            }
                        }
                        if (divator < 600) {
                            e.setRecurrence10m(e.getRecurrence10m() + 1);
                        } else {
                            if (divator < 1200) {
                                e.setRecurrenceLast10m(e.getRecurrenceLast10m() + 1);
                            }
                        }

                        if (divator < 1200) {
                            e.setRecurrence20m(e.getRecurrence20m() + 1);
                        } else {
                            if (divator < 2400) {
                                e.setRecurrenceLast20m(e.getRecurrenceLast20m() + 1);
                            }
                        }

                        if (divator < 1800) {
                            e.setRecurrence30m(e.getRecurrence30m() + 1);
                        } else {
                            if (divator < 3600) {
                                e.setRecurrenceLast30m(e.getRecurrenceLast30m() + 1);
                            }
                        }

//                        e.setTimestamp(time);                        
                    }

                }
            }

        } catch (Exception ex) {
            return null;
        }

        return e;
    }

    public ConcoutMetricMetaList getLast(OddeyeUserModel user, Double minValue, Double minPersent, short minWeight, short minRecurrenceCount, int minRecurrenceTimeInterval, Double minPredictPersent) {
        client = BaseTsdb.getClient();

        final byte[] start_row;
        final byte[] end_row;
//        final Map<Long, ConcoutMetricMetaList> result = new TreeMap<>();
        Calendar Date = Calendar.getInstance();
        Date.add(Calendar.SECOND, minRecurrenceTimeInterval);
        end_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((Date.getTimeInMillis() / 1000)).array());

        Date.add(Calendar.SECOND, -2 * minRecurrenceTimeInterval);
        start_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((Date.getTimeInMillis() / 1000)).array());

        Scanner scanner = client.newScanner(table);
        scanner.setServerBlockCache(false);
        scanner.setFamily("d".getBytes());
        scanner.setStartKey(start_row);
        scanner.setStopKey(end_row);

        ArrayList<ArrayList<KeyValue>> rows;
        ConcoutMetricMetaList MetricMetaListTmp;
        ConcoutMetricMetaList MetricMetaListFinal;
        try {
            MetricMetaListTmp = new ConcoutMetricMetaList();
            MetricMetaListFinal = new ConcoutMetricMetaList();
        } catch (Exception ex) {            
            LOGGER.error(globalFunctions.stackTrace(ex));
            return null;

        }
        try {
            while ((rows = scanner.nextRows(1000).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                    for (final KeyValue kv : row) {
//                        datapart = Arrays.copyOfRange(kv.value(), 0, 2);
                        weight = ByteBuffer.wrap(kv.value()).getShort();
//                        datapart = Arrays.copyOfRange(kv.value(), 2, 10);
                        persent_weight = ByteBuffer.wrap(kv.value()).getDouble(2);
                        value = ByteBuffer.wrap(kv.value()).getDouble(10);
                        persent_predict = ByteBuffer.wrap(kv.value()).getDouble(18);

                        if (Math.abs(value) < minValue) {
                            continue;
                        }
                        if (Math.abs(persent_weight) < minPersent) {
                            continue;
                        }
                        if (Math.abs(weight) < minWeight) {
                            continue;
                        }
                        if (Math.abs(persent_predict) < minPredictPersent) {
                            continue;
                        }

                        MetricErrorMeta e = new MetricErrorMeta(kv.qualifier(), BaseTsdb.getTsdb());

                        if (MetricMetaListTmp.get(e.hashCode()) != null) {
                            e = (MetricErrorMeta) MetricMetaListTmp.get(e.hashCode());
                        }

                        long time = getTime(kv.key());
                        e.setTimestamp(time);
                        e.setValue(value);
                        e.setWeight(weight);
                        e.setPersent_weight(persent_weight);
                        e.setPersent_predict(persent_predict);
                        e.setRecurrenceTmp(e.getRecurrenceTmp() + 1);
                        MetricMetaListTmp.add(e);
                        if (e.getRecurrenceTmp() >= minRecurrenceCount) {
                            MetricMetaListFinal.add(e);
                        }
                    }

                }
            }

        } catch (Exception e) {
            return null;
        }

        return MetricMetaListFinal;
    }

    private long getTime(byte[] key) {
        final byte[] Tsarray = ArrayUtils.subarray(key, 3, key.length);

        final long Ts = ByteBuffer.wrap(Tsarray).getLong();
        return Ts;
    }

    public ArrayList<MetricErrorMeta> getErrorList(OddeyeUserModel user, OddeeyMetricMeta metriq) {
        try {
            client = BaseTsdb.getClient();

            ArrayList<MetricErrorMeta> result = new ArrayList<>();
            final byte[] start_row;
            final byte[] end_row;
//        final Map<Long, ConcoutMetricMetaList> result = new TreeMap<>();
            Calendar Date = Calendar.getInstance();
            Date.add(Calendar.SECOND, 0);
            end_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((Date.getTimeInMillis() / 1000)).array());

            Date.add(Calendar.SECOND, -1000);
            start_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((Date.getTimeInMillis() / 1000)).array());

            Scanner scanner = client.newScanner(table);
            scanner.setServerBlockCache(false);
            scanner.setFamily("d".getBytes());
            scanner.setStartKey(start_row);
            scanner.setStopKey(end_row);
            scanner.setQualifier(metriq.getKey());
            ArrayList<ArrayList<KeyValue>> rows;
            while ((rows = scanner.nextRows(1000).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                    for (final KeyValue kv : row) {
                        weight = ByteBuffer.wrap(kv.value()).getShort();
//                        datapart = Arrays.copyOfRange(kv.value(), 2, 10);
                        persent_weight = ByteBuffer.wrap(kv.value()).getDouble(2);
                        value = ByteBuffer.wrap(kv.value()).getDouble(10);
                        persent_predict = ByteBuffer.wrap(kv.value()).getDouble(18);
                        MetricErrorMeta e = new MetricErrorMeta(kv.qualifier(), BaseTsdb.getTsdb());

                        long time = getTime(kv.key());
                        e.setTimestamp(time);
                        e.setValue(value);
                        e.setWeight(weight);
                        e.setPersent_weight(persent_weight);
                        e.setPersent_predict(persent_predict);
                        e.setRecurrenceTmp(e.getRecurrenceTmp() + 1);
                        result.add(e);
                    }
                }
                return result;
            }
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;
    }

    public void geleteLastErrorRow(byte[] key) {
        final DeleteRequest delreq = new DeleteRequest(TABLENAME_LAST.getBytes(), key);
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("Delete key:" + Hex.encodeHexString(key));
        }
        BaseTsdb.getClient().delete(delreq);

    }

}
