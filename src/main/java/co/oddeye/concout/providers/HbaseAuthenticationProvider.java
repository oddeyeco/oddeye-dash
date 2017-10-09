/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import co.oddeye.concout.dao.HbaseUserDao;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.security.core.AuthenticationException;
import co.oddeye.concout.model.User;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author vahan
 */
@Component
public class HbaseAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private HbaseUserDao Userdao;
    
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
            final User principal = Userdao.getUserByUUID(userid, true,true);            
            final Authentication auth = new UsernamePasswordAuthenticationToken(principal, password, principal.getAuthorities());
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
