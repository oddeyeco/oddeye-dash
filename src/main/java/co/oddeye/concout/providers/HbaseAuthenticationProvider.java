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
import java.util.Map;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.RequestContextListener;
import org.springframework.web.context.request.ServletRequestAttributes;

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
            final User principal = Userdao.getUserByUUID(userid, true);
            final Authentication auth = new UsernamePasswordAuthenticationToken(principal, password, principal.getAuthorities());
            String Hederout = "";
            for (Map.Entry<String, String> hh:det.getHeadersInfo().entrySet())
            {
                Hederout =Hederout+ hh.getKey()+" = "+hh.getValue()+"\n";
            }
//            LOGGER.warn(Hederout + " " + authentication.getName() + " login sucsses "+det.getRequest().getRemoteAddr()+" "+det.getRequest().getHeader("X-Real-IP"));
            return auth;
        } else {
//            LOGGER.warn(det.getRemoteAddress() + " " + authentication.getName() + " login fail");
            return null;
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}
