/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import java.util.UUID;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
abstract public class HbaseBaseDao {

    protected byte[] table = null;
    /**
     *
     */
    protected org.hbase.async.HBaseClient client;

    @SuppressWarnings("empty-statement")
    public HbaseBaseDao(String tableName) {

        if (("".equals(tableName)) || (tableName == null)) {
            tableName = this.getClass().getSimpleName();
        };

        table = tableName.getBytes();
        String quorum = "192.168.10.50";

        this.client = new org.hbase.async.HBaseClient(quorum);

    }
}
