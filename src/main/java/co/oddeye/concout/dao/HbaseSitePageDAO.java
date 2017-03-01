/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
public class HbaseSitePageDAO extends HbaseBaseDao {

    @Autowired
    private BaseTsdbConnect BaseTsdb;

    private final static String tablename = "oddeyesitepage";

    public HbaseSitePageDAO() {
        super(tablename);
    }
}
