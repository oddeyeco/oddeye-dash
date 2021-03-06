/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationListener;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.GenericMessage;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Component;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
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
    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;
    private static final JsonParser PARSER = new JsonParser();

    private final SimpMessagingTemplate template;

    @Autowired
    public StompConnectedEvent(SimpMessagingTemplate template) {
        this.template = template;
    }

    @Override
    @SuppressWarnings("unchecked")
    public void onApplicationEvent(SessionConnectedEvent event) {
        
        StompHeaderAccessor sha = StompHeaderAccessor.wrap(event.getMessage());
        if (event.getMessage().getHeaders().get("simpUser") == null) {
            LOGGER.info("simpUser is null");
            return;
        }

        if (((UsernamePasswordAuthenticationToken) event.getMessage().getHeaders().get("simpUser")).getPrincipal() == null) {
            LOGGER.info("getPrincipal is null");
            return;
        }

        OddeyeUserModel userDetails = ((OddeyeUserDetails) ((UsernamePasswordAuthenticationToken) event.getMessage().getHeaders().get("simpUser")).getPrincipal()).getUserModel();
        GenericMessage message = (GenericMessage) event.getMessage().getHeaders().get("simpConnectMessage");

        if (((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("sotoken") != null) {
            String sotoken = ((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("sotoken").get(0); //sha.getNativeHeader("sotoken").get(0);
            String Sesionid = (String) message.getHeaders().get("simpSessionId");

            if (((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("levels") != null) {
                String[] levels = ((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("levels").get(0).split(",");
                Map<String, Map<String, String[]>> Sesionmap = new HashMap<>();
                Map<String, String[]> sotokenlevel = new HashMap<String, String[]>() {
                    {
                        put(sotoken, levels);
                    }
                };
                Sesionmap.put(Sesionid, sotokenlevel);
                userDetails.setListenerContainer(MetaDao, consumerFactory, this.template, Sesionmap);
            }

            if (((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("options") != null) {
                String options = ((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("options").get(0);
                JsonObject optionsJson = PARSER.parse(options).getAsJsonObject();                
                Map<String, Map<String, JsonObject>> Sesionmap = new HashMap<>();
                Map<String, JsonObject> sotokenlevel = new HashMap<String, JsonObject>() {
                    {
                        put(sotoken, optionsJson);
                    }
                };
                Sesionmap.put(Sesionid, sotokenlevel);
                userDetails.setListenerContainerJ(MetaDao, consumerFactory, this.template, Sesionmap);
            }            
            
        }

        if (((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("page") != null) {

            try {
                String page = ((Map<String, List<String>>) message.getHeaders().get("nativeHeaders")).get("page").get(0); //sha.getNativeHeader("sotoken").get(0);
                String Sesionid = (String) message.getHeaders().get("simpSessionId");

                InetAddress ia = InetAddress.getLocalHost();
                String node = ia.getHostName();

                JsonObject Jsonchangedata = new JsonObject();
                Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
                Jsonchangedata.addProperty("action", "entertopage");
                Jsonchangedata.addProperty("page", page);
                Jsonchangedata.addProperty("SessionId", Sesionid);
                Jsonchangedata.addProperty("node", node);
                Jsonchangedata.addProperty("time", System.currentTimeMillis());

                // Send chenges to kafka
                ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
                messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                    @Override
                    public void onSuccess(SendResult<Integer, String> result) {
                        if (LOGGER.isInfoEnabled()) {
                            LOGGER.info("Kafka Send entertopage onSuccess");
                        }
                    }

                    @Override
                    public void onFailure(Throwable ex) {
                        LOGGER.error("Kafka Send entertopage onFailure:" + ex);
                    }
                });

//                userDetails.getPagelist().put(Sesionid, page);
            } catch (UnknownHostException ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        }

        LOGGER.debug("Client connected.");
        // you can use a controller to send your msg here
    }
}
