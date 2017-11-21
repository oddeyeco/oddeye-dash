/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonObject;
import java.net.InetAddress;
import java.net.UnknownHostException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.messaging.support.GenericMessage;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Component;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

/**
 *
 * @author vahan
 */
@Component
public class StompDisConnectedEvent implements ApplicationListener<SessionDisconnectEvent> {

    private final Logger LOGGER = LoggerFactory.getLogger(StompDisConnectedEvent.class);

    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;

    @Override
    public void onApplicationEvent(SessionDisconnectEvent event) {
        
        OddeyeUserModel userDetails = ((OddeyeUserDetails) ((UsernamePasswordAuthenticationToken) event.getMessage().getHeaders().get("simpUser")).getPrincipal()).getUserModel();
        GenericMessage message = (GenericMessage) event.getMessage();
        String Sesionid = (String) message.getHeaders().get("simpSessionId");
        userDetails.stopListenerContainer(Sesionid);

        try {
            InetAddress ia = InetAddress.getLocalHost();
            String node = ia.getHostName();

            JsonObject Jsonchangedata = new JsonObject();
            Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
            Jsonchangedata.addProperty("action", "exitfrompage");
            Jsonchangedata.addProperty("SessionId", Sesionid);
            Jsonchangedata.addProperty("node", node);
            Jsonchangedata.addProperty("time", System.currentTimeMillis());

            // Send chenges to kafka
            ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
            messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                @Override
                public void onSuccess(SendResult<Integer, String> result) {
                    if (LOGGER.isInfoEnabled()) {
                        LOGGER.info("Kafka Send exitfrompage onSuccess");
                    }
                }

                @Override
                public void onFailure(Throwable ex) {
                    LOGGER.error("Kafka Send exitfrompage onFailure:" + ex);
                }
            });

//                userDetails.getPagelist().put(Sesionid, page);
        } catch (UnknownHostException ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }

//        userDetails.getPagelist().remove(Sesionid);
        LOGGER.debug("Client SessionDisconnectEvent.");
        // you can use a controller to send your msg here
    }

}
