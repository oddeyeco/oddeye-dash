/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.security.web.authentication.WebAuthenticationDetails;

/**
 *
 * @author vahan
 */
public class OddeyeWebAuthenticationDetails extends WebAuthenticationDetails {

    private final Map<String, String> HeadersInfo = new HashMap<>();

    public OddeyeWebAuthenticationDetails(HttpServletRequest request) {
        super(request);
        Enumeration headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String key = (String) headerNames.nextElement();
            String value = request.getHeader(key);
            HeadersInfo.put(key, value);
        }        
    }

    /**
     * @return the HeadersInfo
     */
    public Map<String, String> getHeadersInfo() {
        return HeadersInfo;
    }

}
