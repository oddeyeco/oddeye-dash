/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import net.opentsdb.core.DataPoint;

/**
 *
 * @author andriasyan
 */
public class DataPointImpl implements DataPoint {
    public DataPointImpl(long timestamp, boolean isInteger, long longValue, double doubleValue, long valueCount) {
        this.timestamp = timestamp;
        this.isInteger = isInteger;
        this.longValue = longValue;
        this.doubleValue = doubleValue;
        this.valueCount = valueCount;
    }
    
    long timestamp;
    @Override
    public long timestamp() {
        return timestamp;
    }

    boolean isInteger;
    @Override
    public boolean isInteger() {
        return isInteger;
    }

    long longValue;
    @Override
    public long longValue() {
        return longValue;
    }

    double doubleValue;
    @Override
    public double doubleValue() {
        return doubleValue;
    }

    @Override
    public double toDouble() {
        return doubleValue;
    }

    long valueCount;
    @Override
    public long valueCount() {
        return valueCount;
    }   
}
