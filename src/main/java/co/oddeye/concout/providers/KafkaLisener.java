/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import co.oddeye.concout.core.CoconutParseMetric;
import co.oddeye.concout.core.PageInfo;
import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.core.OddeeyMetric;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;

/**
 *
 * @author vahan
 */
public class KafkaLisener {

    @Autowired
    private HbaseUserDao Userdao;
    @Autowired
    protected BaseTsdbConnect BaseTsdb;

    private static final Logger LOGGER = LoggerFactory.getLogger(KafkaLisener.class);

    private final CountDownLatch latch = new CountDownLatch(1);
    @Autowired
    private SimpMessagingTemplate template;

    @Autowired
    private CoconutParseMetric metricparser;

    public CountDownLatch getLatch() {
        return latch;
    }

//    @KafkaListener(topics = "oddeyetsdb")
    @KafkaListener(topics = "${kafka.metrictopic}")
    public void receiveMetric(String payload) {
        if (LOGGER.isInfoEnabled())
        {
            LOGGER.info("received payload='{}'", payload);
        }

        Object o = metricparser.execute(payload);
        User user;
        if (o instanceof OddeeyMetric) {
            OddeeyMetric Metric = (OddeeyMetric) o;
            try {
                OddeeyMetricMeta mtrscMeta = new OddeeyMetricMeta(Metric, BaseTsdb.getTsdb());
                user = Userdao.getUserByUUID(UUID.fromString(Metric.getTags().get("UUID")));
//                if (user.getMetricsMeta() == null) {
//                    user.setMetricsMeta(new ConcoutMetricMetaList());
//                }
                user.getMetricsMeta().add(mtrscMeta);
            } catch (Exception ex) {
                LOGGER.info(globalFunctions.stackTrace(ex));
            }
        }
        if (o instanceof TreeMap) {
            TreeMap<?, ?> metricinfo = (TreeMap<?, ?>) o;
            for (Map.Entry<?, ?> mtrscEntry : metricinfo.entrySet()) {
                OddeeyMetric Metric = (OddeeyMetric) mtrscEntry.getValue();
                try {
                    OddeeyMetricMeta mtrscMeta = new OddeeyMetricMeta(Metric, BaseTsdb.getTsdb());
                    user = Userdao.getUserByUUID(UUID.fromString(Metric.getTags().get("UUID")));
//                    if (user.getMetricsMeta() == null) {
//                        user.setMetricsMeta(new ConcoutMetricMetaList());
//                    }
                    if (!user.getMetricsMeta().containsKey(mtrscMeta.hashCode())) {
                        user.getMetricsMeta().add(mtrscMeta);
                    } else {
                        user.getMetricsMeta().get(mtrscMeta.hashCode()).update(mtrscMeta);
                    }

                } catch (Exception ex) {
                    LOGGER.info(globalFunctions.stackTrace(ex));
                }
            }
        }

        latch.countDown();
    }

    @KafkaListener(topics = "${dash.semaphore.topic}")
    public void receiveAction(String payload) {
        LOGGER.info("received payload='{}'", payload);
        JsonElement jsonResult = null;

        final JsonParser parser = new JsonParser();
        try {
            jsonResult = parser.parse(payload);
        } catch (JsonSyntaxException ex) {
            LOGGER.info("payload parse Exception" + ex.toString());
        }
        User user;
        if (jsonResult != null) {

            user = Userdao.getUserByUUID(UUID.fromString(jsonResult.getAsJsonObject().get("UUID").getAsString()));
            String action = jsonResult.getAsJsonObject().get("action").getAsString();

            switch (action) {
                case "exitfrompage": {
                    String Sesionid = jsonResult.getAsJsonObject().get("SessionId").getAsString();
                    user.getPagelist().remove(Sesionid);
                    break;
                }
                case "entertopage": {
                    String Sesionid = jsonResult.getAsJsonObject().get("SessionId").getAsString();
                    user.getPagelist().put(Sesionid, new PageInfo(jsonResult.getAsJsonObject().get("page").getAsString(), jsonResult.getAsJsonObject().get("node").getAsString(), jsonResult.getAsJsonObject().get("time").getAsLong()));
                    break;
                }
                case "deleteuser": {
                    Userdao.deleteUser(user);
//                    this.template.convertAndSendToUser(user.getId().toString(), "/info", jsonResult.toString());
                    break;
                }
                case "updateuser":
                case "deletedash":
                case "editdash":
                case "updatelevels": {
                    Map<String, PageInfo> userpagelist = user.getPagelist();
                    if (userpagelist.size() > 1) {
                        try {
                            InetAddress ia = InetAddress.getLocalHost();
                            String node = ia.getHostName();
                            for (Iterator<Map.Entry<String, PageInfo>> it = userpagelist.entrySet().iterator(); it.hasNext();) {
                                Map.Entry<String, PageInfo> userinfoentry = it.next();
                                if (userinfoentry.getValue().getNode().equals(node)) {
                                    if (!jsonResult.getAsJsonObject().get("node").getAsString().equals(node)) {
                                        TimeUnit.SECONDS.sleep(2);
                                        user = Userdao.getUserByUUID(UUID.fromString(jsonResult.getAsJsonObject().get("UUID").getAsString()), true);
                                    }
                                    this.template.convertAndSendToUser(user.getId().toString(), "/info", jsonResult.toString());
                                    break;
                                }

                            }

                        } catch (UnknownHostException | InterruptedException ex) {
                            LOGGER.error(globalFunctions.stackTrace(ex));
                        }
                    }
                    break;
                }
                default:
                    break;
            }

            jsonResult = null;
        }

        latch.countDown();
    }
}
