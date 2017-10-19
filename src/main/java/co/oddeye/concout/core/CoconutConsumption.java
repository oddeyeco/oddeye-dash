/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.Calendar;
import org.hbase.async.KeyValue;

/**
 *
 * @author vahan
 */
public class CoconutConsumption implements Serializable {

    private Double amount = 0.0;
    private long count = 0;
    private long timestamp = 0;
    private final Calendar time;    

    public CoconutConsumption(long times) {
        amount = 0.0;
        count = 0;
        timestamp = times;
        time = Calendar.getInstance();
        time.setTimeInMillis(timestamp);
    }

    public CoconutConsumption(KeyValue cos) {
        timestamp = ByteBuffer.wrap(cos.qualifier()).getLong();
        time = Calendar.getInstance();
        time.setTimeInMillis(timestamp);
        amount = ByteBuffer.wrap(cos.value()).getDouble();
        count = ByteBuffer.wrap(cos.value()).getInt(8);
    }

    /**
     * @return the amount
     */
    public Double getAmount() {
        return amount;
    }

    /**
     * @return the count
     */
    public Long getCount() {
        return count;
    }

    public void addConsumption(Double value, Long _count) {
        amount = amount + value;
        count = count + _count;
    }

    public void doConsumption(Double value, Long _count) {
        amount = amount + value * _count;
        count = count + _count;

    }

    public void doConsumption(Double value) {
        amount = value;
        count++;
    }

    public void clear() {
        amount = 0.0;
        count = 0;
    }

    /**
     * @return the timestamp
     */
    public long getTimestamp() {
        return timestamp;
    }

    /**
     * @return the time
     */
    public Calendar getTime() {
        return time;
    }

}
