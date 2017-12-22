/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserModel;
import java.util.List;
import java.util.function.Consumer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

/**
 *
 * @author vahan
 */
@Component
public class StartupApplicationListener implements
        ApplicationListener<ContextRefreshedEvent> {
 
    private final Logger LOGGER = LoggerFactory.getLogger(StompConnectedEvent.class);
 
    public static int counter;
    @Autowired
    private HbaseUserDao Userdao;    
 
    @Override public void onApplicationEvent(ContextRefreshedEvent event) {
//        LOGGER.info("Increment counter");        
        if (counter==0)
        {
            List<OddeyeUserModel> users = Userdao.getAllUsers(true);
            users.forEach((OddeyeUserModel user) -> {
                LOGGER.warn("Start Read "+user.getEmail());
                Userdao.updateMetaList(user);
                LOGGER.warn("End Read "+user.getEmail());
            });
        }
        counter++;
    }
}
