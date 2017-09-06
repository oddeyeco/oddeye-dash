/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.core.OddeeyMetric;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import java.util.Date;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import java.util.concurrent.CountDownLatch;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author vahan
 */
public class KafkaMetricLisener {

    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    protected BaseTsdbConnect BaseTsdb;

    private static final Logger LOGGER = LoggerFactory.getLogger(KafkaMetricLisener.class);

    private CountDownLatch latch = new CountDownLatch(1);

    public CountDownLatch getLatch() {
        return latch;
    }

    @KafkaListener(topics = "oddeyetsdb")
    public void receive(String payload) {
        LOGGER.info("received payload='{}'", payload);
        JsonArray jsonResult = null;
        Date date;
        final JsonParser parser = new JsonParser();
        JsonElement Metric;
        try {
            if (parser.parse(payload).isJsonArray()) {
                jsonResult = parser.parse(payload).getAsJsonArray();
            } else {
                jsonResult = null;
                LOGGER.error("not array:" + payload);
            }
        } catch (JsonSyntaxException ex) {
            LOGGER.info("payload parse Exception" + ex.toString());
        }
        if (jsonResult != null) {
            try {
                if (jsonResult.size() > 0) {
                    LOGGER.debug("Ready count: " + jsonResult.size());
                    for (int i = 0; i < jsonResult.size(); i++) {
                        Metric = jsonResult.get(i);
                        try {
                            final OddeeyMetric mtrsc = new OddeeyMetric(Metric);
                            OddeeyMetricMeta mtrscMeta = new OddeeyMetricMeta(mtrsc, BaseTsdb.getTsdb());
                            User user = Userdao.getUserByUUID(UUID.fromString(mtrsc.getTags().get("UUID")));
                            if (user.getMetricsMeta() == null) {
                                user.setMetricsMeta(new ConcoutMetricMetaList());
                            }
//                            if (mtrscMeta.hashCode() == -1334554093) {                                
//                                if (user.getMetricsMeta().containsKey(mtrscMeta.hashCode()))
//                                {
//                                    System.out.println(mtrscMeta.hashCode() + " " + mtrscMeta.getName()+" "+ mtrscMeta.getLasttime()+" "+(mtrscMeta.getLasttime()-user.getMetricsMeta().get(mtrscMeta.hashCode()).getLasttime()));
//                                }
//                                
//                            }
                            user.getMetricsMeta().add(mtrscMeta);
                        } catch (Exception e) {
                            LOGGER.error("Exception: " + globalFunctions.stackTrace(e));
                            LOGGER.error("Exception Wits Metriq: " + Metric);
                            LOGGER.error("Exception Wits Input: " + payload);
                        }

                    }
                }
            } catch (JsonSyntaxException ex) {
                LOGGER.error("JsonSyntaxException: " + globalFunctions.stackTrace(ex));
//                this.collector.ack(input);
            } catch (NumberFormatException ex) {
                LOGGER.error("NumberFormatException: " + globalFunctions.stackTrace(ex));
//                this.collector.ack(input);
            }
            jsonResult = null;
        }

        latch.countDown();
    }
}
