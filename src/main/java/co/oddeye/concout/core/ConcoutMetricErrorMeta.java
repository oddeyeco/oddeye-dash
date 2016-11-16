/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.core.OddeeyMetricMeta;
import net.opentsdb.core.TSDB;
import org.apache.commons.codec.binary.Hex;

/**
 *
 * @author vahan
 */
public class ConcoutMetricErrorMeta extends OddeeyMetricMeta {

    private long timestamp;
    private Double value;
    private Double persent_weight;
    private short weight;
    public static final short MAX_VALUE = 16;

    public ConcoutMetricErrorMeta(byte[] key, TSDB tsdb) throws Exception {
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
    public Double getValue() {
        return value;
    }


    /**
     * @param value the value to set
     */
    public void setValue(Double value) {
        this.value = value;
    }

    /**
     * @return the persent_weight
     */
    public Double getPersent_weight() {
        return persent_weight;
    }

    /**
     * @param persent_weight the persent_weight to set
     */
    public void setPersent_weight(Double persent_weight) {
        this.persent_weight = persent_weight;
    }

    /**
     * @return the weight
     */
    public short getWeight() {
        return weight;
    }

    /**
     * @param weight the weight to set
     */
    public void setWeight(short weight) {
        this.weight = weight;
    }


    public String getKeyString() {
        return Hex.encodeHexString(getKey());
    }    
}
