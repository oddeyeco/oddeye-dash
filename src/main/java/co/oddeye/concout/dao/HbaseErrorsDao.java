/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.core.ConcoutMetricMeta;
import co.oddeye.concout.model.User;
import co.oddeye.core.OddeeyMetricMeta;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import net.opentsdb.core.Const;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.Bytes;
import org.hbase.async.HBaseClient;
import org.hbase.async.KeyValue;
import org.hbase.async.Scanner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseErrorsDao extends HbaseBaseDao {

    @Autowired
    private BaseTsdbConnect BaseTsdb;

    private final static String TABLENAME = "test_oddeye-errors";
    private HBaseClient client;

    public HbaseErrorsDao() {
        super(TABLENAME);
    }

    public ConcoutMetricMetaList getLast(User user) {
        client = BaseTsdb.getClient();

        final byte[] start_row;
        final byte[] end_row;

        final Map<Long, ConcoutMetricMetaList> result = new TreeMap<>();
        Calendar Date = Calendar.getInstance();
        start_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((long) (Date.getTimeInMillis() / 1000)).array());
        Date.add(Calendar.MINUTE, 1);
        end_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((long) (Date.getTimeInMillis() / 1000)).array());

        Scanner scanner = client.newScanner(table);
        scanner.setServerBlockCache(false);
        scanner.setFamily("d".getBytes());
        scanner.setStartKey(start_row);
        scanner.setStopKey(end_row);
        scanner.setMaxNumRows(1);
        ArrayList<ArrayList<KeyValue>> rows;
        ConcoutMetricMetaList MetricMetaList = new ConcoutMetricMetaList();
        try {
            while ((rows = scanner.nextRows(1000).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                    for (final KeyValue kv : row) {
                        ConcoutMetricMeta e = new ConcoutMetricMeta(kv.qualifier(), BaseTsdb.getTsdb());

                        if (MetricMetaList.get(e.hashCode()) != null) {
                            e =(ConcoutMetricMeta) MetricMetaList.get(e.hashCode());
                        }
                        
                        long time = getTime(kv.key());
                        e.setTimestamp(time);
                        e.setValue(ByteBuffer.wrap(kv.value()).getShort());

                        MetricMetaList.add(e);

                        
                        ConcoutMetricMetaList value = result.get(time);
                        if (value == null) {
                            value = new ConcoutMetricMetaList();
                        }
                        value.add(e);

                        result.put(time, value);

                    }

                }
            }

        } catch (Exception e) {
            return null;
        }

        return MetricMetaList;
    }

    private long getTime(byte[] key) {
        final byte[] Tsarray = ArrayUtils.subarray(key, 3, key.length);

        final long Ts = ByteBuffer.wrap(Tsarray).getLong();
        return Ts;
    }
}
