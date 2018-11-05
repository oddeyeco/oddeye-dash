/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.config.DatabaseConfig;
import co.oddeye.concout.model.WhitelabelModel;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository("Whitelabeldao")
public class WhitelabelDao extends HbaseBaseDao {

    
    public WhitelabelDao(DatabaseConfig p_config) {
        super(p_config.getWltable());
    }    
    
    @Override
    protected byte[] getKey(Object object)
    {
        return ((WhitelabelModel) object).getKey();
    } 
}
