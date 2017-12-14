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
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.OddeeyMetric;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
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
    @Autowired
    private SimpMessagingTemplate template;
    @Autowired
    private CoconutParseMetric metricparser;

    public CountDownLatch countDownReceiveMetric = new CountDownLatch(6);
    public CountDownLatch countDownReceiveAction = new CountDownLatch(6);

    @KafkaListener(id = "receiveMetric", topics = "${kafka.metrictopic}")
    public void receiveMetric(List<String> list) {
        for (String payload : list) {
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("received payload='{}'", payload);
            }

            Object o = metricparser.execute(payload);
            OddeyeUserModel user;
            if (o instanceof OddeeyMetric) {
                OddeeyMetric Metric = (OddeeyMetric) o;
                try {
                    OddeeyMetricMeta mtrscMeta = new OddeeyMetricMeta(Metric, BaseTsdb.getTsdb());
                    user = Userdao.getUserByUUID(UUID.fromString(Metric.getTags().get("UUID")));
                    user.getMetricsMeta().add(mtrscMeta);
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }
            }
            if (o instanceof TreeMap) {
                TreeMap<?, ?> metricinfo = (TreeMap<?, ?>) o;
                for (Map.Entry<?, ?> mtrscEntry : metricinfo.entrySet()) {
                    OddeeyMetric Metric = (OddeeyMetric) mtrscEntry.getValue();
                    try {
                        OddeeyMetricMeta mtrscMeta = new OddeeyMetricMeta(Metric, BaseTsdb.getTsdb());
                        user = Userdao.getUserByUUID(UUID.fromString(Metric.getTags().get("UUID")));
                        if (!user.getMetricsMeta().containsKey(mtrscMeta.hashCode())) {
                            user.getMetricsMeta().add(mtrscMeta);
                        } else {
                            user.getMetricsMeta().get(mtrscMeta.hashCode()).update(mtrscMeta);
                        }

                    } catch (Exception ex) {
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }
                }
            }
        }
        countDownReceiveMetric.countDown();
    }

    @KafkaListener(id = "receiveAction", topics = "${dash.semaphore.topic}")
    public void receiveAction(List<String> list) {
//        String payload = list.get(0);
//        System.out.println("receiveAction list.size : " + list.size());
        for (String payload : list) {
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("received payload='{}'", payload);
            }

            JsonElement jsonResult = null;

            final JsonParser parser = new JsonParser();
            try {
                jsonResult = parser.parse(payload);
            } catch (JsonSyntaxException ex) {
                LOGGER.error("payload parse Exception" + ex.toString());
            }
            OddeyeUserModel user;
            if (jsonResult != null) {

                user = Userdao.getUserByUUID(UUID.fromString(jsonResult.getAsJsonObject().get("UUID").getAsString()));
                String action = jsonResult.getAsJsonObject().get("action").getAsString();

                switch (action) {
                    case "login": {
//                        LOGGER.warn("login messge OK");
//                        Userdao.updateMetaList(user);                        
                        this.template.convertAndSendToUser(user.getId().toString(), "/info", jsonResult.toString());
//                        LOGGER.warn("login messge Fin");
//                        user.getMetricsMeta().remove(jsonResult.getAsJsonObject().get("hash").getAsInt());
                        break;
                    }

                    case "deletemetricbyhash": {
                        user.getMetricsMeta().remove(jsonResult.getAsJsonObject().get("hash").getAsInt());
                        break;
                    }
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
                    case "deletedash":
                    case "editdash": {
                        try {
                            user.setDushList(Userdao.getAllDush(user.getId()));
                            this.template.convertAndSendToUser(user.getId().toString(), "/info", jsonResult.toString());
                        } catch (Exception ex) {
                            LOGGER.error(globalFunctions.stackTrace(ex));
                        }
                        break;
                    }
                    case "updateuser":
                    case "updatelevels": {
                        Map<String, PageInfo> userpagelist = user.getPagelist();
//                        if (userpagelist.size() > 1) {
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
//                        }
                        break;
                    }
                    default:
                        break;
                }

                jsonResult = null;
            }
        }
        countDownReceiveAction.countDown();
    }
}
