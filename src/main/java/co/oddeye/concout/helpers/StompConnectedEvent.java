/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.model.User;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.GenericMessage;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;

/**
 *
 * @author vahan
 */
@Component
public class StompConnectedEvent implements ApplicationListener<SessionConnectedEvent> {

    private final Logger LOGGER = LoggerFactory.getLogger(StompConnectedEvent.class);
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    ConsumerFactory consumerFactory;

    private final SimpMessagingTemplate template;
    @Autowired
    public StompConnectedEvent(SimpMessagingTemplate template) {
        this.template = template;
    }    
    
    @Override
    public void onApplicationEvent(SessionConnectedEvent event) {
        StompHeaderAccessor sha = StompHeaderAccessor.wrap(event.getMessage());

        User userDetails = (User) ((UsernamePasswordAuthenticationToken) event.getMessage().getHeaders().get("simpUser")).getPrincipal();
        GenericMessage message = (GenericMessage) event.getMessage().getHeaders().get("simpConnectMessage");

        String[] levels = ((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("levels").get(0).split(",");
        String sotoken = ((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("sotoken").get(0); //sha.getNativeHeader("sotoken").get(0);
        String Sesionid =(String) message.getHeaders().get("simpSessionId");
        Map <String,Map<String, String[]>> Sesionmap= new HashMap<>();
        Map<String, String[]> sotokenlevel = new HashMap<String, String[]>() {
            {
                put(sotoken, levels);
            }};
        
        Sesionmap.put(Sesionid, sotokenlevel);
                        
        userDetails.setListenerContainer(MetaDao, consumerFactory, this.template, Sesionmap);
        LOGGER.debug("Client connected.");
        // you can use a controller to send your msg here
    }
}
