/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *
 * @author vahan
 */
@Controller
public class errorSubscribeController {

    private final Logger log = LoggerFactory.getLogger(errorSubscribeController.class);
    private final SimpMessagingTemplate template;
     
    @Autowired
    public errorSubscribeController(SimpMessagingTemplate template) {
        this.template = template;
    }
  
    @RequestMapping("/valod")
    private void bgColor(String greeting) {
        String text = "{\"aaa\":\"aaaa\"}";
        this.template.convertAndSend("/topic/greetings", text);
        log.info("Send color: ");
    }
}
