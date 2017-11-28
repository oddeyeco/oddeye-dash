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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;

/**
 *
 * @author vahan
 */
@Component
public class HbaseAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {

    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    @Value("${dash.semaphore.topic}")
    private String semaphoretopic;

    private UserDetailsService userDetailsService;

    private final Logger LOGGER = LoggerFactory.getLogger(HbaseAuthenticationProvider.class);

    public HbaseAuthenticationProvider() {
        super();
    }

//    @Override
//    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
////        String name = authentication.getName();
//        String password = authentication.getCredentials().toString();
//        OddeyeWebAuthenticationDetails det = (OddeyeWebAuthenticationDetails) authentication.getDetails();
//
////        System.out.println(request.getHeaderNames());
//        //TODO check user in hbase
//        UUID userid = Userdao.CheckUserAuthentication(authentication);
//        if (userid != null) {
//            final OddeyeUserDetails principal = Userdao.getUserByUUID(userid, true, false);
//            final Authentication auth = new UsernamePasswordAuthenticationToken(principal, password, principal.getAuthorities());
//            try {
//                InetAddress ia = InetAddress.getLocalHost();
//                String node = ia.getHostName();
//
//                JsonObject Jsonchangedata = new JsonObject();
//                Jsonchangedata.addProperty("UUID", principal.getId().toString());
//                Jsonchangedata.addProperty("action", "login");                                
//                Jsonchangedata.addProperty("node", node);
//                Jsonchangedata.addProperty("time", System.currentTimeMillis());
//
//                // Send chenges to kafka
//                ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send(semaphoretopic, Jsonchangedata.toString());
//                messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
//                    @Override
//                    public void onSuccess(SendResult<Integer, String> result) {
//                        if (LOGGER.isInfoEnabled()) {
//                            LOGGER.info("Kafka Send entertopage onSuccess");
//                        }
//                    }
//
//                    @Override
//                    public void onFailure(Throwable ex) {
//                        LOGGER.error("Kafka Send entertopage onFailure:" + ex);
//                    }
//                });
//            } catch (Exception ex) {
//                LOGGER.error(globalFunctions.stackTrace(ex));
//            }
//
//            LOGGER.info(authentication.getName() + " login sucsses " + det.getRequest().getRemoteAddr() + " " + det.getRequest().getHeader("X-Real-IP"));
//            return auth;
//        } else {
//            LOGGER.info(authentication.getName() + " login fail " + det.getRequest().getRemoteAddr() + " " + det.getRequest().getHeader("X-Real-IP"));
//            return null;
//        }
//    }
//    @Override
//    public boolean supports(Class<?> authentication) {
//        return authentication.equals(UsernamePasswordAuthenticationToken.class);
//    }
    @Override
    protected void additionalAuthenticationChecks(UserDetails ud, UsernamePasswordAuthenticationToken upat) throws AuthenticationException {
//        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        if (upat.getCredentials() == null) {
            LOGGER.debug("Authentication failed: no credentials provided");

            throw new BadCredentialsException(messages.getMessage(
                    "AbstractUserDetailsAuthenticationProvider.badCredentials",
                    "Bad credentials"));
        }

//        String presentedPassword = upat.getCredentials().toString();
        UUID userid = Userdao.CheckUserAuthentication(upat);
        if (userid == null) {
            LOGGER.debug("Authentication failed: password does not match stored value");

            throw new BadCredentialsException(messages.getMessage(
                    "AbstractUserDetailsAuthenticationProvider.badCredentials",
                    "Bad credentials"));
        } else {
            try {
                final OddeyeUserDetails principal = (OddeyeUserDetails) ud;
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
                            LOGGER.info("Kafka Send Login onSuccess");
                        }
                    }

                    @Override
                    public void onFailure(Throwable ex) {
                        LOGGER.error("Kafka Send Login onFailure:" + ex);
                    }
                });
            } catch (UnknownHostException ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
            if (LOGGER.isInfoEnabled()) {
                OddeyeWebAuthenticationDetails det = (OddeyeWebAuthenticationDetails) upat.getDetails();
                LOGGER.info(upat.getName() + " login sucsses " + det.getRequest().getRemoteAddr() + " " + det.getRequest().getHeader("X-Real-IP"));
            }

        }
    }

    @Override
    protected UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken upat) throws AuthenticationException {
        UserDetails loadedUser;

        try {
            loadedUser = this.getUserDetailsService().loadUserByUsername(username);
        } catch (UsernameNotFoundException notFound) {
            if (upat.getCredentials() != null) {
// TODO                            
//				String presentedPassword = upat.getCredentials().toString();
//				passwordEncoder.isPasswordValid(userNotFoundEncodedPassword,
//						presentedPassword, null);
            }
            throw notFound;
        } catch (Exception repositoryProblem) {
            throw new InternalAuthenticationServiceException(
                    repositoryProblem.getMessage(), repositoryProblem);
        }

        if (loadedUser == null) {
            throw new InternalAuthenticationServiceException(
                    "UserDetailsService returned null, which is an interface contract violation");
        }
        return loadedUser;
    }

    /**
     * @return the userDetailsService
     */
    public UserDetailsService getUserDetailsService() {
        return userDetailsService;
    }

    /**
     * @param userDetailsService the userDetailsService to set
     */
    public void setUserDetailsService(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }
}
