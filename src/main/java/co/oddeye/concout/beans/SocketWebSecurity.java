/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.beans;

import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;

/**
 *
 * @author vahan
 */
public class SocketWebSecurity {

    private final Logger log = LoggerFactory.getLogger(SocketWebSecurity.class);

    public boolean checkUserId(Authentication authentication, int id) {
        log.info("sss" + authentication);
        log.info("sss" + id);
        return true;
    }
}
