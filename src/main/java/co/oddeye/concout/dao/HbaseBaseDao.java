/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

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
     * @param tableName
     */    
    @SuppressWarnings("empty-statement")
    public HbaseBaseDao(String tableName) {

        if (("".equals(tableName)) || (tableName == null)) {
            tableName = this.getClass().getSimpleName();
        };

        table = tableName.getBytes();
    }
}
