/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.core.AlertLevel;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.util.UUID;
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
    private static final JsonParser PARSER = new JsonParser();
    private Gson gson = new Gson();
    @Autowired
    HbaseMetaDao MetaDao;

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
    @KafkaListener(id = "dushtest", topics = "errors", group = "dushtest")
    public void listenErrors(ConsumerRecord<?, String> record) {
        String msg = record.value();
        if (record.timestamp() > System.currentTimeMillis() - 60000) {

            JsonElement jsonResult = PARSER.parse(msg);
            String Uuid = jsonResult.getAsJsonObject().get("UUID").getAsString();
            int level = jsonResult.getAsJsonObject().get("level").getAsInt();
            int hash = jsonResult.getAsJsonObject().get("hash").getAsInt();

//        if (level == -1)
//        {
//            System.out.println("valod");
//        }
            if (jsonResult.getAsJsonObject().get("message") != null) {
                String message = jsonResult.getAsJsonObject().get("message").getAsString();
                jsonResult.getAsJsonObject().addProperty("message", message);
            }

            jsonResult.getAsJsonObject().addProperty("levelname", AlertLevel.getName(level));

            OddeeyMetricMeta metric = MetaDao.getFullmetalist().get(hash);
            if (metric == null) {
                try {
                    MetaDao.getByUUID(UUID.fromString(Uuid));
                } catch (Exception ex) {
                    log.info(globalFunctions.stackTrace(ex));
                }
            }

            metric = MetaDao.getFullmetalist().get(hash);
            if (metric != null) {
                JsonElement metajson = new JsonObject();
                metajson.getAsJsonObject().add("tags", gson.toJsonTree(metric.getTags()));
                metajson.getAsJsonObject().addProperty("name", metric.getName());
                jsonResult.getAsJsonObject().add("info", metajson);
            }
            this.template.convertAndSendToUser(Uuid, "/errors", jsonResult.toString());
        }
        countDownLatch1.countDown();
    }
}
