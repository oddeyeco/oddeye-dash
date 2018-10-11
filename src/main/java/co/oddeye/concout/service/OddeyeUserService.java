/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.service;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserModel;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author vahan
 */
@Service("oddeyeUserService")
@Transactional
public class OddeyeUserService {
    @Autowired
    private HbaseUserDao dao;

    
    public OddeyeUserModel findById(UUID id) {
        return dao.getUserByUUID(id);
    }
    
//    public void save(OddeyeUserModel env) {
//        dao.save(env);
//    }
//    
//    public void update(OddeyeUserModel env) {
//        OddeyeUserModel entity = dao.findById(env.getId());
//        if (entity != null) {
//
//        }
//    }
//
//    
//    public void deleteByID(UUID id) {
//        dao.deleteByID(id);
//    }
//    
//    public List<Box> findAll() {
//        return dao.findAll();
//    }    
}
