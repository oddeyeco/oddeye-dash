/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonObject;
import java.net.InetAddress;
import java.net.UnknownHostException;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.security.core.AuthenticationException;
import java.util.UUID;
import java.util.logging.Level;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;

/**
 *
 * @author vahan
 */
@Component
public class HbaseAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;

    
    private final Logger LOGGER = LoggerFactory.getLogger(HbaseAuthenticationProvider.class);

    public HbaseAuthenticationProvider() {
        super();
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
//        String name = authentication.getName();
        String password = authentication.getCredentials().toString();
        OddeyeWebAuthenticationDetails det = (OddeyeWebAuthenticationDetails) authentication.getDetails();

//        System.out.println(request.getHeaderNames());
        //TODO check user in hbase
        UUID userid = Userdao.CheckUserAuthentication(authentication);
        if (userid != null) {
            final OddeyeUserDetails principal = Userdao.getUserByUUID(userid, true, false);
            final Authentication auth = new UsernamePasswordAuthenticationToken(principal, password, principal.getAuthorities());
            try {
                InetAddress ia = InetAddress.getLocalHost();
                String node = ia.getHostName();

                JsonObject Jsonchangedata = new JsonObject();
                Jsonchangedata.addProperty("UUID", principal.getId().toString());
                Jsonchangedata.addProperty("action", "login");                                
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
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }

            LOGGER.info(authentication.getName() + " login sucsses " + det.getRequest().getRemoteAddr() + " " + det.getRequest().getHeader("X-Real-IP"));
            return auth;
        } else {
            LOGGER.info(authentication.getName() + " login fail " + det.getRequest().getRemoteAddr() + " " + det.getRequest().getHeader("X-Real-IP"));
            return null;
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}
