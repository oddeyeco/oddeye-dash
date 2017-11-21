/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import java.security.Principal;
import java.util.Map;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Controller;

/**
 *
 * @author vahan
 */
@Controller
public class WebSocketController {

    @MessageMapping(value = "/chagelevel/")
    public void executeTrade(Principal principal, SimpMessageHeaderAccessor headerAccessor, String[] levels) {
//      UserModel user = (UserModel) principal;
        OddeyeUserModel userDetails = ((OddeyeUserDetails) ((UsernamePasswordAuthenticationToken) headerAccessor.getUser()).getPrincipal()).getUserModel();
        String sessionId = headerAccessor.getSessionId();
        for (Map.Entry<String, String[]> listEntry : userDetails.getSotokenlist().get(sessionId).entrySet()) {
            listEntry.setValue(levels);
        }
//      System.out.println(principal.getName());
    }

//  public void executeTrade(SimpMessageHeaderAccessor headerAccessor, MessageMapping message) {
//      String sessionId = headerAccessor.getSessionId();
//      System.out.println(sessionId);
//  }  
}
