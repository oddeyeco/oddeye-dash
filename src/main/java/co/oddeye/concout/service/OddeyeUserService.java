/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.service;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyePayModel;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.globalFunctions;
import java.util.Calendar;
import java.util.Comparator;
import java.util.List;
import java.util.TimeZone;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
    
    protected static final Logger LOGGER = LoggerFactory.getLogger(OddeyeUserService.class);
    
    @Autowired
    private HbaseUserDao dao;
    
    public OddeyeUserModel findById(UUID id) {
        return dao.getUserByUUID(id);
    }
    
    public void updateConsumptionYear(OddeyeUserModel env) {
        try {
            TimeZone timeZone = TimeZone.getTimeZone("UTC");
            Calendar cal = Calendar.getInstance(timeZone);
            int startYear = cal.get(Calendar.YEAR);
            int startMonth = cal.get(Calendar.MONTH);
            LOGGER.info(env.getEmail() + ":" + startYear + "/" + startMonth + " " + cal.getTime());
            cal.add(Calendar.YEAR, -1);
            if (cal.getTimeInMillis() < env.getSinedate().getTime()) {
                cal.setTime(env.getSinedate());
            }
            env.setConsumptionList(dao.getConsumption(env, startYear, startMonth, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH)));            
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }
    
    public void updateConsumption2m(OddeyeUserModel env) {
        try {
            TimeZone timeZone = TimeZone.getTimeZone("UTC");
            Calendar cal = Calendar.getInstance(timeZone);
            int startYear = cal.get(Calendar.YEAR);
            int startMonth = cal.get(Calendar.MONTH);
            LOGGER.info(env.getEmail() + ":" + startYear + "/" + startMonth + " " + cal.getTime());
            cal.add(Calendar.MONTH, -1);
            if (cal.getTimeInMillis() < env.getSinedate().getTime()) {
                cal.setTime(env.getSinedate());
            }
            env.setConsumptionList(dao.getConsumption(env, startYear, startMonth, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH)));
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }
    
    public void updateConsumption(OddeyeUserModel env) {
        env.setConsumptionList(dao.getConsumption(env));        
    }
    
    public void updatePayments(OddeyeUserModel env, int count) {
        List<OddeyePayModel> list = dao.getPaymets(env, count);
        list.sort(new Comparator<OddeyePayModel>() {
            @Override
            public int compare(OddeyePayModel m1, OddeyePayModel m2) {
                if (m1.getPayment_date().equals(m2.getPayment_date()) ) {
                    return 0;
                }
                return m1.getPayment_date().after(m2.getPayment_date()) ? -1 : 1;
            }
        });
        env.setPaymentList(list);        
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
