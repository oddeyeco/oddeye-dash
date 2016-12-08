/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import java.util.concurrent.CountDownLatch;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *
 * @author vahan
 */
@Controller
public class errorSubscribeController {

    private final Logger log = LoggerFactory.getLogger(errorSubscribeController.class);
    private final SimpMessagingTemplate template;
    public final CountDownLatch countDownLatch1 = new CountDownLatch(1);
     
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
    
//    @KafkaListener(id = "foo", topics = "oddeyetsdb", group = "group1")
//    public void listenTimeStamps(ConsumerRecord<?, String> record) {     
//        this.template.convertAndSend("/topic/greetings", record.value());
//        countDownLatch1.countDown();
//    }    
    
//    @KafkaListener(id = "dush", topics = "semaphore", group = "dush")
//    public void listenErrors(ConsumerRecord<?, String> record) {          
//        this.template.convertAndSendToUser("vahan@medlib.am", "/greetings", record.value());
////        this.template.convertAndSend("/user/greetings", record.value());
//        countDownLatch1.countDown();
//    }        
}
