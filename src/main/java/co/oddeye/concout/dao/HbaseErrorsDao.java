/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.core.ConcoutMetricMeta;
import co.oddeye.concout.model.User;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.BinaryComparator;
import org.hbase.async.CompareFilter;
import org.hbase.async.FilterList;
import org.hbase.async.HBaseClient;
import org.hbase.async.KeyValue;
import org.hbase.async.ScanFilter;
import org.hbase.async.Scanner;
import org.hbase.async.ValueFilter;
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
        short value;

//        final Map<Long, ConcoutMetricMetaList> result = new TreeMap<>();
        Calendar Date = Calendar.getInstance();
        Date.add(Calendar.MINUTE, 60);
        end_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((long) (Date.getTimeInMillis() / 1000)).array());

        Date.add(Calendar.MINUTE, -61);
        start_row = ArrayUtils.addAll(user.getTsdbID(), ByteBuffer.allocate(8).putLong((long) (Date.getTimeInMillis() / 1000)).array());

        Scanner scanner = client.newScanner(table);
        scanner.setServerBlockCache(false);
        scanner.setFamily("d".getBytes());
        scanner.setStartKey(start_row);
        scanner.setStopKey(end_row);

        byte[] data = ByteBuffer.allocate(2).putShort((short) 6).array();
        byte[] Negdata = ByteBuffer.allocate(2).putShort((short) -6).array();
        
        ValueFilter filter = new ValueFilter(CompareFilter.CompareOp.GREATER,new BinaryComparator(data));
        
        List<ScanFilter> list= new LinkedList<>();
        list.add(new ValueFilter(CompareFilter.CompareOp.GREATER,new BinaryComparator(data)));
        list.add(new ValueFilter(CompareFilter.CompareOp.LESS,new BinaryComparator(Negdata)));
        FilterList filterlist = new FilterList(list,FilterList.Operator.MUST_PASS_ALL);
        scanner.setFilter(filterlist);
        
        
        ArrayList<ArrayList<KeyValue>> rows;
        ConcoutMetricMetaList MetricMetaList;
        try {
            MetricMetaList = new ConcoutMetricMetaList();
        } catch (Exception ex) {
            Logger.getLogger(HbaseErrorsDao.class.getName()).log(Level.SEVERE, null, ex);
            return null;

        }
        int rowcount = 0;
        try {
            while ((rows = scanner.nextRows(1000).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                    rowcount++;
                    for (final KeyValue kv : row) {
                        value = ByteBuffer.wrap(kv.value()).getShort();
//                        if (value < 5) {
//                            continue;
//                        }
                        ConcoutMetricMeta e = new ConcoutMetricMeta(kv.qualifier(), BaseTsdb.getTsdb());

                        if (MetricMetaList.get(e.hashCode()) != null) {
                            e = (ConcoutMetricMeta) MetricMetaList.get(e.hashCode());

                        }

                        long time = getTime(kv.key());
                        e.setTimestamp(time);
                        e.setValue(value);
                        MetricMetaList.add(e);
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
