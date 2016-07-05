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
public class HbaseDataDao extends HbaseBaseDao {

    public HbaseDataDao() {
        super("oddeyedata");
    }

}
