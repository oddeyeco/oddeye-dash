/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import com.google.gson.JsonObject;
import com.stumbleupon.async.Deferred;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.hbase.async.Bytes;
import org.hbase.async.PutRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
abstract public class HbaseBaseDao {

    @Autowired
    protected BaseTsdbConnect BaseTsdb;        
    protected byte[] table = null;    
    private final String tablename;
    /**
     *
     * @param tableName
     */    
    @SuppressWarnings("empty-statement")
    public HbaseBaseDao(String tableName) {

        if (("".equals(tableName)) || (tableName == null)) {
            tableName = this.getClass().getSimpleName();
        };

        table = tableName.getBytes();
        tablename = tableName;
    }
    
    public Deferred<Object> put (Map<String, HashMap<String, Object>>  changedata,  byte[] key)
    {
        if (changedata.size() > 0) {
            for (Map.Entry<String, HashMap<String, Object>> data : changedata.entrySet()) {
                byte[] family = data.getKey().getBytes();
                if (data.getValue().size() > 0) {
                    byte[][] qualifiers = new byte[data.getValue().size()][];
                    byte[][] values = new byte[data.getValue().size()][];
                    int index = 0;
                    for (Map.Entry<String, Object> Hbasedata : data.getValue().entrySet()) {
                        qualifiers[index] = Hbasedata.getKey().getBytes();
                        Class<?> aclass = Hbasedata.getValue().getClass();
                        if (Hbasedata.getValue() instanceof byte[]) {
                            values[index] = (byte[]) Hbasedata.getValue();
                        }
                        if (Hbasedata.getValue() instanceof String) {
                            values[index] = ((String) Hbasedata.getValue()).getBytes();
                        }
                        if (Hbasedata.getValue() instanceof Collection) {
                            values[index] = Hbasedata.getValue().toString().getBytes();
                        }
                        if (Hbasedata.getValue() instanceof Boolean) {
                            values[index] = (Bytes.fromInt((Boolean) Hbasedata.getValue() ? 1 : 0));
                        }
                        if (Hbasedata.getValue() instanceof JsonObject) {
                            values[index] = ((JsonObject) Hbasedata.getValue()).toString().getBytes();
                        }                        
                        if (Hbasedata.getValue() instanceof Enum) {
                            values[index] = ((Enum) Hbasedata.getValue()).toString().getBytes();
                        }                                                
                        if (Hbasedata.getValue() instanceof UUID) {
                            values[index] = ((UUID) Hbasedata.getValue()).toString().getBytes();
                        }                        
                        index++;
                    }
                    final PutRequest request = new PutRequest(table, key, family, qualifiers, values);
                    return BaseTsdb.getClient().put(request);
                }
            }
        }  
        return null;
    }

    /**
     * @return the tablename
     */
    public String getTablename() {
        return tablename;
    }
}
