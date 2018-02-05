/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.core.globalFunctions;
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
    private HbaseMetaDao Metadao;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        if (counter == 0) {
            try {
                LOGGER.warn("Start Read FOR ALL USERS");        
//                Metadao.getForUsers();
                LOGGER.warn("End Read FOR ALL USERS");
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        }
        counter++;

    }
}
