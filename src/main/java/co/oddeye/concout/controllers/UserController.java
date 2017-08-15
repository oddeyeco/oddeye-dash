/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.core.MetricErrorMeta;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseErrorsDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.model.User;
import co.oddeye.core.MetriccheckRule;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.SeekableView;
import org.apache.commons.codec.binary.Hex;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import co.oddeye.core.AlertLevel;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.globalFunctions;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Random;

import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.messaging.simp.SimpMessagingTemplate;

/**
 *
 * @author vahan
 */
@Controller
public class UserController {

    private final Logger LOGGER = LoggerFactory.getLogger(UserController.class);
    @Autowired
    HbaseErrorsDao ErrorsDao;
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    HbaseDataDao DataDao;
    private Map<String, String> Tagmap;
    private final Gson gson = new Gson();
    @Autowired
    private BaseTsdbConnect BaseTsdb;

    @Autowired
    ConsumerFactory consumerFactory;

    private final SimpMessagingTemplate template;

    @Autowired
    public UserController(SimpMessagingTemplate template) {
        this.template = template;
    }

    @RequestMapping(value = "/startlisener", method = RequestMethod.POST)
    public String startlisener(HttpServletRequest request, ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

            String[] levels = request.getParameterValues("levels[]");
            String sotoken = request.getParameter("sotoken");
            userDetails.setListenerContainer(MetaDao, consumerFactory, this.template, new HashMap<String, String[]>() {
                {
                    put(sotoken, levels);
                }
            });
        }
        JsonObject jsonResult = new JsonObject();
        jsonResult.addProperty("sucsses", Boolean.TRUE);
        map.put("jsonmodel", jsonResult);
        return "ajax";
    }

    @RequestMapping(value = "/stoplisener", method = RequestMethod.POST)
    public String stoplisener(HttpServletRequest request, ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            String sotoken = request.getParameter("sotoken");
            userDetails.stopListenerContainer(sotoken);
//            userDetails.getListenerContainer().stop();
        }
        JsonObject jsonResult = new JsonObject();
        jsonResult.addProperty("sucsses", Boolean.TRUE);
        map.put("jsonmodel", jsonResult);
        return "ajax";
    }

    @RequestMapping(value = "/monitoring", method = RequestMethod.GET)
    public String monitoring(HttpServletRequest request, ModelMap map) {

//        ContainerProperties properties = new ContainerProperties(topics);
//        properties.setMessageListener(new OddeyeKafkaDataListener());
//        ConcurrentMessageListenerContainer<Integer, String> listenerContainer = new ConcurrentMessageListenerContainer<>(consumerFactory, properties);
//        listenerContainer.setConcurrency(3);
//        listenerContainer.getContainerProperties().setPollTimeout(3000);
//        listenerContainer.start();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("activeuser", userDetails);
            map.put("title", "Real Time monitoring");
            String group_item = request.getParameter("group_item");
            String ident_tag = request.getParameter("ident_tag");

            if (userDetails.getMetricsMeta() == null) {
                try {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }
            }

            Iterator<Map.Entry<String,  Map<String, Integer>>> iter = userDetails.getMetricsMeta().getTagsList().entrySet().iterator();
            while (iter.hasNext()) {
                map.put("group_item", iter.next().getKey());
                map.put("ident_tag", iter.next().getKey());
                break;
            }

            if (group_item != null) {
                map.put("group_item", group_item);
            }
            if (group_item != null) {
                map.put("ident_tag", ident_tag);
            }

            String level_item = request.getParameter("level");

            int int_level_item;
            if (level_item == null) {
                map.put("level_item", AlertLevel.ALERT_LEVEL_ELEVATED);
            } else {
                int_level_item = Integer.parseInt(level_item);
                if (int_level_item > AlertLevel.ALERT_LEVELS.length - 1) {
                    int_level_item = AlertLevel.ALERT_LEVEL_ELEVATED;
                }
                map.put("level_item", int_level_item);
            }

        }
        Random rand = new Random();
        map.put("_sotoken", rand.nextInt(90000) + 10000);
        map.put("body", "monitoring");
        map.put("jspart", "monitoringjs");

        return "index";
    }

    @RequestMapping(value = "/monitoring2", method = RequestMethod.GET)
    public String monitoring2(HttpServletRequest request, ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);

            String group_item = request.getParameter("group_item");
            String ident_tag = request.getParameter("ident_tag");

            if (userDetails.getMetricsMeta() == null) {
                try {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }
            }

            JsonObject savedErrors = new JsonObject();
            String message = null;
            Long time = null;
            try {
                ArrayList<ArrayList<KeyValue>> errors_list = ErrorsDao.getActiveErrors(userDetails);
                for (ArrayList<KeyValue> err_row : errors_list) {
                    JsonObject item = new JsonObject();
                    for (KeyValue cell : err_row) {
                        if (Arrays.equals(cell.qualifier(), "level".getBytes())) {
                            int level = cell.value()[0];
                            item.addProperty("level", level);
                            item.addProperty("levelname", AlertLevel.getName(level));
                        }

                        if (Arrays.equals(cell.qualifier(), "action".getBytes())) {
                            int action = cell.value()[0];
                            item.addProperty("action", action);
                        }
                        if (Arrays.equals(cell.qualifier(), "time".getBytes())) {
                            time = ByteBuffer.wrap(cell.value()).getLong();
                            item.addProperty("time", time);
                        }
                        if (Arrays.equals(cell.qualifier(), "message".getBytes())) {
                            message = new String(cell.value());// ByteBuffer.wrap(cell.value()).toString() ;
                        }
                        if (Arrays.equals(cell.qualifier(), "sv".getBytes())) {
                            Double sv = ByteBuffer.wrap(cell.value()).getDouble();
                            item.addProperty("startvalue", sv);
                        }
                        if (Arrays.equals(cell.qualifier(), "starttimes".getBytes())) {
                            final byte[] starttimes = cell.value();
                            JsonObject stTimes = new JsonObject();
                            int i = 0;
                            final ByteBuffer Buffer = ByteBuffer.wrap(starttimes);
                            while (i < starttimes.length) {
//                               final byte[] level = Arrays.copyOfRange(starttimes, i, i + 1);
                                byte level = Buffer.array()[i];
                                i++;
                                long timetmp = Buffer.getLong(i);
                                i = i + 8;
                                stTimes.addProperty(Byte.toString(level), timetmp);
                            }
                            item.add("starttimes", stTimes);

                        }

                    }

                    KeyValue cell = err_row.get(0);
                    byte[] Metakey = OddeeyMetricMeta.UUIDKey2Key(cell.key(), BaseTsdb.getTsdb());

                    OddeeyMetricMeta metric2 = new OddeeyMetricMeta(Metakey, BaseTsdb.getTsdb());
                    OddeeyMetricMeta metric;
//                    if (metric.getName().equals("mem_buffers"))

                    metric = userDetails.getMetricsMeta().get(metric2.hashCode());
                    if (metric == null) {
                        metric = MetaDao.getByKey(metric2.getKey());
                        if (metric != null) {
                            userDetails.getMetricsMeta().set(metric);
                        } else {
                            ErrorsDao.geleteLastErrorRow(cell.key());
                        }
                    }
                    if (metric != null) {

                        JsonElement metajson = new JsonObject();
                        metajson.getAsJsonObject().add("tags", gson.toJsonTree(metric.getTags()));
                        metajson.getAsJsonObject().addProperty("name", metric.getName());
                        item.getAsJsonObject().addProperty("hash", metric.hashCode());
                        item.getAsJsonObject().addProperty("isspec", metric.isSpecial() ? 1 : 0);

                        if (metric.isSpecial()) {
                            metric = MetaDao.updateMeta(metric);
                            long DURATION = time - metric.getLasttime();
                            message = message.replaceAll("\\{DURATION\\}", Double.toString(DURATION / 1000) + " sec.");
                            item.addProperty("message", message);
                        }

                        item.getAsJsonObject().add("info", metajson);
                        savedErrors.add(Integer.toString(metric.hashCode()), item);
                    }

                    //TODO SEND TO USER in new task
//                    this.template.convertAndSendToUser(Metric.getTags().get("UUID").getValue(), "/errors", Metric.toString());    
                }

            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }

            map.put("errorslist", savedErrors);
            Iterator<Map.Entry<String,  Map<String, Integer>>> iter = userDetails.getMetricsMeta().getTagsList().entrySet().iterator();
            while (iter.hasNext()) {
//                    first = userDetails.getMetricsMeta().getTagsList().entrySet().iterator().next();
                map.put("group_item", iter.next().getKey());
                map.put("ident_tag", iter.next().getKey());
                break;
            }

            if (group_item != null) {
                map.put("group_item", group_item);
            }
            if (group_item != null) {
                map.put("ident_tag", ident_tag);
            }

            String level_item = request.getParameter("level");

            int int_level_item;
//            int_level_item = AlertLevel.ALERT_LEVEL_ELEVATED;
            if (level_item == null) {
                map.put("level_item", AlertLevel.ALERT_LEVEL_ELEVATED);
            } else {
                int_level_item = Integer.parseInt(level_item);
                if (int_level_item > AlertLevel.ALERT_LEVELS.length - 1) {
                    int_level_item = AlertLevel.ALERT_LEVEL_ELEVATED;
                }
                map.put("level_item", int_level_item);
            }

        }

        map.put("body", "monitoring2");
        map.put("jspart", "monitoringjs2");

        return "index";
    }

    @RequestMapping(value = "/errorsanalysis", method = RequestMethod.GET)
    public String errorsanalysis(HttpServletRequest request, ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("activeuser", userDetails);
            map.put("ErrorsDao", ErrorsDao);
            map.put("title", "Analysis");
            String group_item = request.getParameter("group_item");

            String ident_tag = request.getParameter("ident_tag");

            if (userDetails.getMetricsMeta() == null) {
                try {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                } catch (Exception ex) {
                    LOGGER.error(globalFunctions.stackTrace(ex));
                }
            }
            Iterator<Map.Entry<String,  Map<String, Integer>>> iter = userDetails.getMetricsMeta().getTagsList().entrySet().iterator();
            while (iter.hasNext()) {
//                    first = userDetails.getMetricsMeta().getTagsList().entrySet().iterator().next();
                map.put("group_item", iter.next().getKey());
                map.put("ident_tag", iter.next().getKey());
                break;
            }

            if (group_item != null) {
                map.put("group_item", group_item);
            }
            if (group_item != null) {
                map.put("ident_tag", ident_tag);
            }

            String level_item = request.getParameter("level");

            int int_level_item = -1;
            if (level_item == null) {
                map.put("level_item", AlertLevel.ALERT_LEVEL_ELEVATED);
            } else {
                int_level_item = Integer.parseInt(level_item);
                if (int_level_item > AlertLevel.ALERT_LEVELS.length - 1) {
                    int_level_item = -1;
                }
                map.put("level_item", int_level_item);
            }

            if (int_level_item == -1) {
                String minValue = request.getParameter("minValue");
                if (minValue == null) {
                    map.put("minValue", 1);
                } else {
                    map.put("minValue", Math.abs(Double.parseDouble(minValue)));
                }

                String minPersent = request.getParameter("minPersent");
                if (minValue == null) {
                    map.put("minPersent", 50);
                } else {
                    map.put("minPersent", Math.abs(Double.parseDouble(minPersent)));
                }

                String minWeight = request.getParameter("minWeight");
                if (minValue == null) {
                    map.put("minWeight", 14);
                } else {
                    map.put("minWeight", Math.abs((short) Math.round(Float.parseFloat(minWeight))));
                }

                String minRecurrenceCount = request.getParameter("minRecurrenceCount");
                if (minValue == null) {
                    map.put("minRecurrenceCount", 2);
                } else {
                    map.put("minRecurrenceCount", Math.abs((short) Math.round(Float.parseFloat(minRecurrenceCount))));
                }
                String minPredictPersent = request.getParameter("minPredictPersent");
                if (minValue == null) {
                    map.put("minPredictPersent", 50);
                } else {
                    map.put("minPredictPersent", Math.abs(Float.parseFloat(minPredictPersent)));
                }
            } else {
                map.put("minValue", userDetails.getAlertLevels().get(int_level_item).get(AlertLevel.ALERT_PARAM_VALUE));
                map.put("minPersent", userDetails.getAlertLevels().get(int_level_item).get(AlertLevel.ALERT_PARAM_PECENT));
                map.put("minWeight", userDetails.getAlertLevels().get(int_level_item).get(AlertLevel.ALERT_PARAM_WEIGTH));
                map.put("minRecurrenceCount", userDetails.getAlertLevels().get(int_level_item).get(AlertLevel.ALERT_PARAM_RECCOUNT));
                map.put("minPredictPersent", userDetails.getAlertLevels().get(int_level_item).get(AlertLevel.ALERT_PARAM_PREDICTPERSENT));
            }
            String minRecurrenceTimeInterval = request.getParameter("minRecurrenceTimeInterval");
            if (minRecurrenceTimeInterval == null) {
                map.put("minRecurrenceTimeInterval", 60);
            } else {
                map.put("minRecurrenceTimeInterval", Math.abs(Integer.parseInt(minRecurrenceTimeInterval)));
            }

        }

        map.put("body", "errorsanalysis");
        map.put("jspart", "errorsanalysisjs");

        return "index";
    }

    @RequestMapping(value = "/expanded/{metriqkey}/{timestamp}", method = RequestMethod.GET)
    public String advansedinfo(@PathVariable(value = "metriqkey") String metriqkey,
            @PathVariable(value = "timestamp") String timestamp,
            HttpServletRequest request, ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User userDetails = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();
                map.put("curentuser", userDetails);
                JsonObject jsonMessages = new JsonObject();
                MetricErrorMeta Error = ErrorsDao.getErrorMeta(userDetails, Hex.decodeHex(metriqkey.toCharArray()), Long.parseLong(timestamp));
                if (Error == null) {
                    return "index";
                }
                Map<String, MetriccheckRule> rules = MetaDao.getErrorRules(Error, Long.parseLong(timestamp));
                map.put("Error", Error);
                map.put("title", Error.getDisplayName());
                map.put("Rules", rules);
                ArrayList<DataPoints[]> data = new ArrayList<>();
                // Get rules chart data
                rules.entrySet().stream().map((rule) -> rule.getValue().getTime()).map((Calendar calobject) -> {
                    String startdate = Long.toString(calobject.getTimeInMillis());
//                    calobject.add(Calendar.HOUR, 1);
                    calobject.add(Calendar.MINUTE, 59);
//                    calobject.add(Calendar.SECOND, 59);
                    String enddate = Long.toString(calobject.getTimeInMillis());
                    data.addAll(DataDao.getDatabyQuery(userDetails, Error.getName(), "none", Error.getFullFilter(), startdate, enddate, "", false));
                    return startdate;
                }).map((String startdate) -> {
                    if (!data.isEmpty()) {
                        data.forEach((DataPointslist) -> {
                            for (DataPoints DataPoints : DataPointslist) {
                                Tagmap = DataPoints.getTags();
                                Tagmap.remove("UUID");
                                Tagmap.remove("alert_level");
                                JsonObject jsonMessage;
                                String jsonuindex = DataPoints.metricName() + Integer.toString(Tagmap.hashCode());
                                if (jsonMessages.get(jsonuindex) == null) {
                                    jsonMessage = new JsonObject();
                                } else {
                                    jsonMessage = jsonMessages.get(jsonuindex).getAsJsonObject();
                                }

                                jsonMessage.addProperty("index", Tagmap.hashCode());
                                jsonMessage.addProperty("metric", DataPoints.metricName());

                                final JsonElement TagsJSON = gson.toJsonTree(Tagmap);
                                jsonMessage.add("tags", TagsJSON);
                                Tagmap.clear();

                                final SeekableView Datalist = DataPoints.iterator();

                                JsonObject DatapointsJSON;

                                if (jsonMessage.get("data") == null) {
                                    DatapointsJSON = new JsonObject();
                                } else {
                                    DatapointsJSON = jsonMessage.get("data").getAsJsonObject();
                                }

                                while (Datalist.hasNext()) {
                                    final DataPoint Point = Datalist.next();
                                    DatapointsJSON.addProperty(Long.toString(Point.timestamp()), Point.doubleValue());
                                }

                                jsonMessage.add("data", DatapointsJSON);
                                jsonMessages.add(startdate, jsonMessage);

                            }
                        });
                    }
                    return startdate;
                }).forEachOrdered((_item) -> {
                    data.clear();
                }); 

                
                // Get Curent chart data
                Calendar calobject = Calendar.getInstance();
                calobject.setTimeInMillis(Long.parseLong(timestamp) * 1000);
                calobject.set(Calendar.MINUTE, 0);
                calobject.set(Calendar.SECOND, 0);
                calobject.set(Calendar.MILLISECOND, 0);
                String startdate = Long.toString(calobject.getTimeInMillis());
                calobject.add(Calendar.HOUR, 1);
                calobject.add(Calendar.MILLISECOND, -1);
                String enddate = Long.toString(calobject.getTimeInMillis());
                data.clear();
                data.addAll(DataDao.getDatabyQuery(userDetails, Error.getName(), "none", Error.getFullFilter(), startdate, enddate, "", false));
                if (!data.isEmpty()) {
                    data.forEach((DataPointslist) -> {
                        for (DataPoints DataPoints : DataPointslist) {
                            Tagmap = DataPoints.getTags();
                            Tagmap.remove("UUID");
                            Tagmap.remove("alert_level");

                            JsonObject jsonMessage;

                            String jsonuindex = DataPoints.metricName() + Integer.toString(Tagmap.hashCode());

                            if (jsonMessages.get(jsonuindex) == null) {
                                jsonMessage = new JsonObject();
                            } else {
                                jsonMessage = jsonMessages.get(jsonuindex).getAsJsonObject();
                            }

                            jsonMessage.addProperty("index", Tagmap.hashCode());
                            jsonMessage.addProperty("metric", DataPoints.metricName());

                            final JsonElement TagsJSON = gson.toJsonTree(Tagmap);
                            jsonMessage.add("tags", TagsJSON);
                            Tagmap.clear();

                            final SeekableView Datalist = DataPoints.iterator();

                            JsonObject DatapointsJSON;

                            if (jsonMessage.get("data") == null) {
                                DatapointsJSON = new JsonObject();
                            } else {
                                DatapointsJSON = jsonMessage.get("data").getAsJsonObject();
                            }

                            while (Datalist.hasNext()) {
                                final DataPoint Point = Datalist.next();
                                DatapointsJSON.addProperty(Long.toString(Point.timestamp()), Point.doubleValue());
                            }

                            jsonMessage.add("data", DatapointsJSON);
                            jsonMessages.add(startdate, jsonMessage);

                        }
                    });
                }

                // Predict for JSON
                JsonObject jsonMessage;
                String jsonuindex = Error.getName() + "_predict";
                if (jsonMessages.get(jsonuindex) == null) {
                    jsonMessage = new JsonObject();
                } else {
                    jsonMessage = jsonMessages.get(jsonuindex).getAsJsonObject();
                }

                jsonMessage.addProperty("metric", Error.getName());
                JsonObject DatapointsJSON;
                if (jsonMessage.get("data") == null) {
                    DatapointsJSON = new JsonObject();

                } else {
                    DatapointsJSON = jsonMessage.get("data").getAsJsonObject();
                }
//                for (long i = Long.parseLong(startdate); i < Long.parseLong(enddate); i = i + 10000) {
//                    DatapointsJSON.addProperty(Long.toString(i), Error.getRegression().predict(i));
//                }

                DatapointsJSON.addProperty(startdate, Error.getRegression().predict(Long.parseLong(startdate)/1000));
                DatapointsJSON.addProperty(enddate, Error.getRegression().predict(Long.parseLong(enddate)/1000));

                jsonMessage.add("data", DatapointsJSON);
                jsonMessages.add("predict", jsonMessage);
                map.put("chartdata", jsonMessages);
                // End Predict

            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }

        }

        map.put("body", "advansed");
        map.put("jspart", "advansedjs");

        return "index";
    }

}
