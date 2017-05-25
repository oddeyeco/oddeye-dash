/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseErrorHistoryDao extends HbaseBaseDao {
    
    @Autowired
    private BaseTsdbConnect BaseTsdbV;    
    public static final String TBLENAME = "test_oddeye-error-history";
//    private ConcoutMetricMetaList MtrscList;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(HbaseMetaDao.class);
    
    public HbaseErrorHistoryDao() {
        super(TBLENAME);
    }
    
}
