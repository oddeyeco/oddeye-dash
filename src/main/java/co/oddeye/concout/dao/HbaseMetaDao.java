/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.MetaTags;
import co.oddeye.concout.model.User;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseMetaDao extends HbaseBaseDao {    
    private static String tablename = "oddeyemeta";
    
    public HbaseMetaDao() {
        super(tablename);                
    }  
    
    public Map<String, Map<String, MetaTags>> getByUUID(UUID iserid) {
        Map<String, Map<String, MetaTags>> result = new HashMap();
        
        Map<String, MetaTags> Tag =new HashMap();
        Tag.put("host1", new MetaTags());
        Tag.put("host2", new MetaTags());
        Tag.put("host3", new MetaTags());
        Tag.put("host4", new MetaTags());
        result.put("hosts", Tag);
        
        return result;
    }    
}
