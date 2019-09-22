/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import javax.servlet.http.HttpServletRequest;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.switchuser.SwitchUserFilter;

/**
 *
 * @author andriasyan
 */
public class CustomSwitchUserFilter extends SwitchUserFilter{
	protected Authentication attemptSwitchUser(HttpServletRequest request) throws AuthenticationException {
		Authentication current = SecurityContextHolder.getContext().getAuthentication();

		// Put here all the checkings and initialization you want to check before switching.
		return super.attemptSwitchUser(request);
	}

	protected Authentication attemptExitUser(HttpServletRequest request) throws AuthenticationCredentialsNotFoundException {
		Authentication current = SecurityContextHolder.getContext().getAuthentication();

		// Checkings when switch back called.
		return super.attemptExitUser(request);
	}
}
