/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.core.OddeeyMetricMeta;
import net.opentsdb.core.TSDB;

/**
 *
 * @author vahan
 */
public class ConcoutMetricMeta extends OddeeyMetricMeta {

    private long timestamp;
    private short value;
    public static final short MAX_VALUE = 16;

    public ConcoutMetricMeta(byte[] key, TSDB tsdb) throws Exception {
        super(key, tsdb);
    }

    /**
     * @return the timestamp
     */
    public long getTimestamp() {
        return timestamp;
    }

    /**
     * @param timestamp the timestamp to set
     */
    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    /**
     * @return the value
     */
    public short getValue() {
        return value;
    }

    /**
     * @return the value
     */
    public float getValuePersent() {
        if (value > MAX_VALUE) {
            return 100;
        }
        return value * 100 / MAX_VALUE;
    }

    /**
     * @param value the value to set
     */
    public void setValue(short value) {
        this.value = value;
    }
}
