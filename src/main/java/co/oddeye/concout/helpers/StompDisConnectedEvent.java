/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.model.User;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.support.GenericMessage;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

/**
 *
 * @author vahan
 */
@Component
public class StompDisConnectedEvent implements ApplicationListener<SessionDisconnectEvent> {

    private final Logger LOGGER = LoggerFactory.getLogger(StompDisConnectedEvent.class);

    @Override
    public void onApplicationEvent(SessionDisconnectEvent event) {
        User userDetails = (User) ((UsernamePasswordAuthenticationToken) event.getMessage().getHeaders().get("simpUser")).getPrincipal();
        GenericMessage message = (GenericMessage) event.getMessage();
        String Sesionid = (String) message.getHeaders().get("simpSessionId");
        userDetails.stopListenerContainer(Sesionid);
        userDetails.getPagelist().remove(Sesionid);

        LOGGER.debug("Client SessionDisconnectEvent.");
        // you can use a controller to send your msg here
    }

}
