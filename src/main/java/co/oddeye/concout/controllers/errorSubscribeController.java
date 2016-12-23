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
import org.apache.commons.codec.binary.Hex;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;

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
    private final Gson gson = new Gson();
    @Autowired
    HbaseMetaDao MetaDao;

    @Autowired
    public errorSubscribeController(SimpMessagingTemplate template) {
        this.template = template;
    }

//    @RequestMapping("/valod")
//    private void bgColor(String greeting) {
//        String text = "{\"aaa\":\"aaaa\"}";
//        this.template.convertAndSend("/topic/greetings", text);
//        log.info("Send color: ");
//    }

      
    @KafkaListener(id = "dush", topics = "errors", group = "dush")
    public void listenErrors(ConsumerRecord<?, String> record) {
        String msg = record.value();
        System.out.println("OFFSET "+record.offset()); 
        if (record.timestamp() > System.currentTimeMillis() - 60000) {

            JsonElement jsonResult = PARSER.parse(msg);
            String Uuid = jsonResult.getAsJsonObject().get("UUID").getAsString();
            int level = jsonResult.getAsJsonObject().get("level").getAsInt();
            int hash = jsonResult.getAsJsonObject().get("hash").getAsInt();
            if (jsonResult.getAsJsonObject().get("message") != null) {
                String message = jsonResult.getAsJsonObject().get("message").getAsString();
                jsonResult.getAsJsonObject().addProperty("message", message);
            }

            jsonResult.getAsJsonObject().addProperty("levelname", AlertLevel.getName(level));

            OddeeyMetricMeta metric = MetaDao.getFullmetalist().get(hash);
            if (metric == null) {
                try {
                   byte[] key = Hex.decodeHex(jsonResult.getAsJsonObject().get("key").getAsString().toCharArray());
                   metric =  MetaDao.getByKey(key);
                } catch (Exception ex) {
                    log.info(globalFunctions.stackTrace(ex));
                }
            }

//            metric = MetaDao.getFullmetalist().get(hash);
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
