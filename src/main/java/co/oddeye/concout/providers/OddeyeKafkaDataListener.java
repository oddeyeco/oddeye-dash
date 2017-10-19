/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.model.User;
import co.oddeye.core.AlertLevel;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.Serializable;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import org.apache.commons.codec.binary.Hex;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.listener.MessageListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;

/**
 *
 * @author vahan
 */
public class OddeyeKafkaDataListener implements MessageListener<Object, Object>, Serializable {

    private final User user;
    private final HbaseMetaDao MetaDao;
    private final Logger log = LoggerFactory.getLogger(OddeyeKafkaDataListener.class);

    private static final JsonParser PARSER = new JsonParser();
    private final Gson gson = new Gson();

    public final CountDownLatch countDownLatch1 = new CountDownLatch(1);

    private final SimpMessagingTemplate template;
//    private final Map<String, String[]> sotokenlist = new HashMap<>();

    public OddeyeKafkaDataListener(User _user, SimpMessagingTemplate _template, HbaseMetaDao _MetaDao) {
        user = _user;
        template = _template;
        MetaDao = _MetaDao;
//        sotokenlist.putAll(sotoken);
    }

    @Override
    public void onMessage(ConsumerRecord<Object, Object> record) {
//        System.out.println(data);
        String msg = (String) record.value();
        String t_level = record.topic().replace(user.getId().toString(), "");
        Integer i_level = Integer.parseInt(t_level);
        if (log.isInfoEnabled()) {
            log.info("OFFSET " + record.offset() + " partition " + record.partition() + " time set " + (System.currentTimeMillis() - record.timestamp()));
        }

        if (System.currentTimeMillis() - record.timestamp() < 60000) {
            String message;
            JsonElement jsonResult = PARSER.parse(msg);

            int level = jsonResult.getAsJsonObject().get("level").getAsInt();
            int hash = jsonResult.getAsJsonObject().get("hash").getAsInt();

            jsonResult.getAsJsonObject().addProperty("levelname", AlertLevel.getName(level));
            OddeeyMetricMeta metricMeta = user.getMetricsMeta().get(hash);
            if (metricMeta == null) {
                try {
                    byte[] key = Hex.decodeHex(jsonResult.getAsJsonObject().get("key").getAsString().toCharArray());
                    user.getMetricsMeta().put(hash, MetaDao.getByKey(key));
                    metricMeta = user.getMetricsMeta().get(hash);
                } catch (Exception ex) {
                    log.info(globalFunctions.stackTrace(ex));
                }
            }

            if (metricMeta != null) {

                if (metricMeta.isSpecial()) {
                    if (jsonResult.getAsJsonObject().get("message") != null) {
                        long time = System.currentTimeMillis();
                        if (jsonResult.getAsJsonObject().get("reaction").getAsInt() < 0) {
                            time = jsonResult.getAsJsonObject().get("time").getAsLong();
                        }
                        long DURATION = time - metricMeta.getLasttime();
                        message = jsonResult.getAsJsonObject().get("message").getAsString();
                        message = message.replaceAll("\\{DURATION\\}", Double.toString(DURATION / 1000) + " sec.");
                        jsonResult.getAsJsonObject().addProperty("message", message);
                    }
                }

                if (level == i_level) {
                    metricMeta.getErrorState().setLevel(jsonResult.getAsJsonObject().get("level").getAsInt(), jsonResult.getAsJsonObject().get("time").getAsLong());
//                    user.getMetricsMeta().put(hash, metricMeta);
                }

                JsonElement metajson = new JsonObject();
                metajson.getAsJsonObject().add("tags", gson.toJsonTree(metricMeta.getTags()));
                metajson.getAsJsonObject().addProperty("name", metricMeta.getName());
                jsonResult.getAsJsonObject().add("info", metajson);
                jsonResult.getAsJsonObject().addProperty("isspec", metricMeta.isSpecial() ? 1 : 0);
                jsonResult.getAsJsonObject().addProperty("flap", metricMeta.getErrorState().getFlap());

                for (Map.Entry<String, Map<String, String[]>> sesionsotokenlevel : user.getSotokenlist().entrySet()) {
                    Map<String, String[]> sotokenlevelmap = sesionsotokenlevel.getValue();
                    for (Map.Entry<String, String[]> sotokenlevel : sotokenlevelmap.entrySet()) {
                        if (Arrays.asList(sotokenlevel.getValue()).contains(t_level)) {

                            if (level == i_level) {
                                this.template.convertAndSendToUser(user.getId().toString(), "/" + sotokenlevel.getKey() + "/errors", jsonResult.toString());
                            } else {
                                if (!Arrays.asList(sotokenlevel.getValue()).contains(Integer.toString(level))) {
                                    this.template.convertAndSendToUser(user.getId().toString(), "/" + sotokenlevel.getKey() + "/errors", jsonResult.toString());
                                }
                            }

                        }

                    }

                }

//                for (Map.Entry<String, String[]> sotokenlevel : user.getSotokenlist().entrySet()) {
//                    if (Arrays.asList(sotokenlevel.getValue()).contains(t_level)) {
//                        this.template.convertAndSendToUser(user.getId().toString(), "/" + sotokenlevel.getKey() + "/errors", jsonResult.toString());
//                    }
//
//                }
            }

        } else {
//            System.out.println("valod");
        }
        countDownLatch1.countDown();

    }

}
