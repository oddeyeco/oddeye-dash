/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Table;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
abstract public class HbaseBaseDao {
    protected Table htable = null;
    public HbaseBaseDao(String tableName) {
        if ((tableName == "")||(tableName == null))
        {
            tableName = this.getClass().getSimpleName();
        };
        
        Configuration config = HBaseConfiguration.create();
        config.clear();

        config.set("hbase.zookeeper.quorum", "192.168.10.50");
        config.set("hbase.zookeeper.property.clientPort", "2181");
        config.set("zookeeper.session.timeout", "18000");
        config.set("zookeeper.recovery.retry", Integer.toString(1));    
        
        try {
            Connection connection = ConnectionFactory.createConnection(config);
            this.htable = connection.getTable(TableName.valueOf(tableName));
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (this.htable == null) {
            throw new RuntimeException("Hbase Table '" + tableName + "' Can not connect");
        }        
    }
}
