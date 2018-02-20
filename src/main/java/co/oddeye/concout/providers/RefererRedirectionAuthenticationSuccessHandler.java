/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

/**
 *
 * @author vahan
 */
public class RefererRedirectionAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler
        implements AuthenticationSuccessHandler {

    private RequestCache requestCache = new HttpSessionRequestCache();

    public RefererRedirectionAuthenticationSuccessHandler() {
        super();
//        setUseReferer(true);
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
            HttpServletResponse response, Authentication authentication) throws
            IOException, ServletException {

        SavedRequest savedRequest = requestCache.getRequest(request, response);

        if (savedRequest == null) {
            if (request.getHeader("referer")==null)
            {
                super.onAuthenticationSuccess(request, response, authentication);
                return;
            }
            else
            {
                response.sendRedirect(request.getHeader("referer"));
                return;
            }
            

            
        }
        super.onAuthenticationSuccess(request, response, authentication);
        //Do your logic;
//        
    }

}
