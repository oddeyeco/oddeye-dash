/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.config.DatabaseConfig;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseErrorHistoryDao extends HbaseBaseDao {
        
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(HbaseMetaDao.class);
    
    public HbaseErrorHistoryDao(DatabaseConfig p_config) {
        super(p_config.getErrorHistoryTable());
    }
    
}
