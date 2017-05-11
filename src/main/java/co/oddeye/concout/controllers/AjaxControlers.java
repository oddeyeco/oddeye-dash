/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeyeTag;
import co.oddeye.core.globalFunctions;
import co.oddeye.concout.core.SendToKafka;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.stumbleupon.async.Deferred;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.SeekableView;
import net.opentsdb.utils.DateTime;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
//import com.google.gson.JsonObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author vahan
 */
@Controller
public class AjaxControlers {

    @Autowired
    HbaseDataDao DataDao;
    @Autowired
    HbaseMetaDao MetaDao;

    @Autowired
    HbaseUserDao UserDao;

    @Autowired
    private KafkaTemplate<Integer, String> conKafkaTemplate;
    protected static final Logger LOGGER = LoggerFactory.getLogger(AjaxControlers.class);

    @RequestMapping(value = "/getdata", method = RequestMethod.GET)
    public String singlecahrt(@RequestParam(value = "tags", required = false) String tags,
            @RequestParam(value = "hash", required = false) Integer hash,
            @RequestParam(value = "metrics", required = false) String metrics,
            @RequestParam(value = "startdate", required = false, defaultValue = "10m-ago") String startdate,
            @RequestParam(value = "enddate", required = false, defaultValue = "now") String enddate,
            @RequestParam(value = "aggregator", required = false, defaultValue = "none") String aggregator,
            @RequestParam(value = "rate", required = false, defaultValue = "false") Boolean rate,
            @RequestParam(value = "downsample", required = false, defaultValue = "") String downsample,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User userDetails;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
        } else {
            userDetails = UserDao.getUserByUUID(UUID.fromString("c1393383-217a-44ef-b699-8d69fe1867dc"));
        }

        Gson gson = new Gson();
        Map<String, String> Tagmap;
        JsonObject jsonMessages = new JsonObject();
        JsonObject jsonResult = new JsonObject();
        if ((hash == null) && (metrics == null) && (tags == null)) {
            jsonResult.addProperty("sucsses", Boolean.FALSE);
            map.put("jsonmodel", jsonResult);
            return "ajax";
        }

        if (userDetails != null) {
            OddeeyMetricMeta metric = null;
            if ((hash != null)) {
                metric = userDetails.getMetricsMeta().get(hash);
                if (metric == null) {
                    jsonResult.addProperty("sucsses", Boolean.FALSE);
                    LOGGER.warn("Metric for hash:" + hash + " not exist");
                    map.put("jsonmodel", jsonResult);
                    return "ajax";
                }
                metrics = metric.getName();
                tags = "";
                for (Map.Entry<String, OddeyeTag> tag : metric.getTags().entrySet()) {
                    tags = tags + tag.getKey() + "=" + tag.getValue().getValue() + ";";
                }
            }
            Long start_time = DateTime.parseDateTimeString(startdate, null);
            Long end_time = DateTime.parseDateTimeString(enddate, null);
            Long starttime = System.currentTimeMillis();
            ArrayList<DataPoints[]> data = DataDao.getDatabyQuery(userDetails, metrics, aggregator, tags, startdate, enddate, downsample, rate);
            Long getinterval = System.currentTimeMillis() - starttime;
            starttime = System.currentTimeMillis();
            if (data != null) {
                if (data.isEmpty()) {
                    LOGGER.info("Empty data for query: metrics:" + metrics + " aggregator:" + aggregator + " tags:" + tags + " startdate:" + startdate + " enddate:" + enddate + " downsample:" + downsample);
                }
                for (DataPoints[] DataPointslist : data) {
                    if (DataPointslist.length < 1) {
                        LOGGER.info("Empty DataPointslist for query: metrics:" + metrics + " aggregator:" + aggregator + " tags:" + tags + " startdate:" + startdate + " enddate:" + enddate + " downsample:" + downsample);
                    }
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

                        if (metric != null) {
                            jsonMessage.addProperty("hash", metric.hashCode());
                        }
                        jsonMessage.addProperty("taghash", Tagmap.hashCode());
                        jsonMessage.addProperty("metric", DataPoints.metricName());

                        final JsonElement TagsJSON = gson.toJsonTree(Tagmap);
                        jsonMessage.add("tags", TagsJSON);
                        Tagmap.clear();

                        final SeekableView Datalist = DataPoints.iterator();

                        JsonArray DatapointsJSON;

                        if (jsonMessage.get("data") == null) {
                            DatapointsJSON = new JsonArray();
                        } else {
                            DatapointsJSON = jsonMessage.get("data").getAsJsonArray();
                        }

                        while (Datalist.hasNext()) {
                            final DataPoint Point = Datalist.next();
                            if (Point.timestamp() < start_time) {
                                continue;
                            }
                            if (Point.timestamp() > end_time) {
                                continue;
                            }
                            JsonArray pointsJSON = new JsonArray();
                            pointsJSON.add(Point.timestamp());
                            pointsJSON.add(Point.doubleValue());
                            DatapointsJSON.add(pointsJSON);
                        }

                        jsonMessage.add("data", DatapointsJSON);

                        jsonMessages.add(jsonuindex, jsonMessage);

                    }

                }
            } else {
                LOGGER.warn("Empty Data for query: metrics:" + metrics + " aggregator:" + aggregator + " tags:" + tags + " startdate:" + startdate + " enddate:" + enddate + " downsample:" + downsample);
            }
            Long scaninterval = System.currentTimeMillis() - starttime;
            jsonResult.addProperty("gettime", getinterval);
            jsonResult.addProperty("scantime", scaninterval);
//            jsonMessages.
            jsonResult.add("chartsdata", jsonMessages);
        }
        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/getfiltredmetricsnames"})
    public String GetMetricsLargeNames(
            @RequestParam(value = "tags", required = false, defaultValue = "") String tags,
            @RequestParam(value = "filter", required = false, defaultValue = "") String filter,
            @RequestParam(value = "all", required = false, defaultValue = "false") String s_all,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();
        JsonArray jsondata = new JsonArray();
//        List<String> data = new ArrayList<>();
        User userDetails;
        boolean all = Boolean.valueOf(s_all);
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
        } else {
            userDetails = UserDao.getUserByUUID(UUID.fromString("c1393383-217a-44ef-b699-8d69fe1867dc"));
        }

        if (userDetails != null) {
            try {
                String[] tagslist = tags.split(";");
                final Map<String, String> tagsMap = new HashMap<>();
                for (String tag : tagslist) {
                    String[] tgitem = tag.split("=");
                    if (tgitem.length == 2) {
                        if (tgitem[1].equals("")) {
                            tgitem[1] = "*";
                        }
                        tagsMap.put(tgitem[0], tgitem[1]);
                    }
                }
                if (userDetails.getMetricsMeta() == null) {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                }
//                userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                if (filter.equals("") || filter.equals("*")) {
                    filter = "^(.*)$";
                }
                ConcoutMetricMetaList Metriclist = userDetails.getMetricsMeta().getbyTags(tagsMap, filter);
                jsonResult.addProperty("sucsses", true);

//                for (final OddeeyMetricMeta metric : Metriclist) {
//                    if ((!metric.isSpecial()) || (all)) {
//                        if (!data.contains(metric.getName())) {
//                            data.add(metric.getName());
//                        }
//                    }
//                }
                ArrayList<String> data = new ArrayList<>();
                if (all) {
                    data.addAll(Metriclist.getSpecialNameSorted());
                    jsonResult.addProperty("specialcount", data.size());
                }
                data.addAll(Metriclist.getRegularNamelistSorted());
//                Collections.sort(data);
                Gson gson = new Gson();

                jsondata.addAll(gson.toJsonTree(data).getAsJsonArray());
//                        if (!jsondata.contains(metricjson)) {
//                            jsondata.add(metricjson);
//                        }                
                jsonResult.addProperty("count", data.size());
                jsonResult.add("data", jsondata);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }
        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/getfiltredmetrics"})
    public String GetMetricsLarge(
            @RequestParam(value = "tags", required = false, defaultValue = "") String tags,
            @RequestParam(value = "filter", required = false, defaultValue = "") String filter,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();
        JsonArray jsondata = new JsonArray();
        User userDetails;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
        } else {
            userDetails = UserDao.getUserByUUID(UUID.fromString("c1393383-217a-44ef-b699-8d69fe1867dc"));
        }

        if (userDetails != null) {
            try {
                String[] tagslist = tags.split(";");
                final Map<String, String> tagsMap = new HashMap<>();
                for (String tag : tagslist) {
                    String[] tgitem = tag.split("=");
                    if (tgitem.length == 2) {
                        if (tgitem[1].equals("")) {
                            tgitem[1] = "*";
                        }
                        tagsMap.put(tgitem[0], tgitem[1]);
                    }
                }
                if (userDetails.getMetricsMeta() == null) {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                }
//                userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                if (filter.equals("") || filter.equals("*")) {
                    filter = "^(.*)$";
                }
                ConcoutMetricMetaList Metriclist = userDetails.getMetricsMeta().getbyTags(tagsMap, filter);
                jsonResult.addProperty("sucsses", true);
                jsonResult.addProperty("count", Metriclist.size());

                for (Map.Entry<Integer, OddeeyMetricMeta> metricentry : Metriclist.entrySet()) {
                    final OddeeyMetricMeta metric = metricentry.getValue();
                    final JsonObject metricjson = new JsonObject();
                    final JsonObject tagsjson = new JsonObject();
                    metricjson.addProperty("name", metric.getName());
                    metricjson.addProperty("hash", metric.hashCode());
                    metricjson.addProperty("lasttime", metric.getLasttime());

                    for (final Map.Entry<String, OddeyeTag> tag : metric.getTags().entrySet()) {
                        if (!tag.getValue().getKey().equals("UUID")) {
                            tagsjson.addProperty(tag.getValue().getKey(), tag.getValue().getValue());
                        }
                    }
                    metricjson.add("tags", tagsjson);
                    jsondata.add(metricjson);
                }

                jsonResult.add("data", jsondata);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }
        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/getmetrics"})
    public String GetMetrics(
            @RequestParam(value = "key") String key,
            @RequestParam(value = "value") String value,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        JsonObject jsonResult = new JsonObject();
        JsonArray jsondata = new JsonArray();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User userDetails = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();

//                userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                ConcoutMetricMetaList Metriclist;
                if (key.equals("name")) {
                    Metriclist = userDetails.getMetricsMeta().getbyName(value);
                } else {
                    Metriclist = userDetails.getMetricsMeta().getbyTag(key, value);
                }

                jsonResult.addProperty("sucsses", true);
                jsonResult.addProperty("count", Metriclist.size());
                final List<OddeeyMetricMeta> MetriclistSorted = new ArrayList<>(Metriclist.values());
                MetriclistSorted.sort(OddeeyMetricMeta::compareTo);
                MetriclistSorted.stream().map((metric) -> {
                    final JsonObject metricjson = new JsonObject();
                    final JsonObject tagsjson = new JsonObject();
                    metricjson.addProperty("name", metric.getName());
                    metricjson.addProperty("hash", metric.hashCode());
                    metricjson.addProperty("type", metric.getType());
                    metricjson.addProperty("typename", metric.getTypeName());
                    metricjson.addProperty("lasttime", metric.getLasttime());
                    metric.getTags().entrySet().stream().filter((tag) -> (!tag.getValue().getKey().equals("UUID"))).forEachOrdered((tag) -> {
                        tagsjson.addProperty(tag.getValue().getKey(), tag.getValue().getValue());
                    });
                    metricjson.add("tags", tagsjson);
                    return metricjson;
                }).forEachOrdered((metricjson) -> {
                    jsondata.add(metricjson);
                });
                jsonResult.add("data", jsondata);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/deletemetrics"})
    public String DeleteMetrics(
            @RequestParam(value = "key", required = false) String key,
            @RequestParam(value = "value", required = false) String value,
            @RequestParam(value = "hash", required = false) Integer hash,
            @RequestParam(value = "name", required = false) String name,
            ModelMap map
    ) {

        SendToKafka KafkaLocalSender = (User user, String action, Object hash1) -> {
            JsonObject Jsonchangedata = new JsonObject();
            Jsonchangedata.addProperty("UUID", user.getId().toString());
            Jsonchangedata.addProperty("action", action);
            Jsonchangedata.addProperty("hash", (Integer) hash1);
            ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send("semaphore", Jsonchangedata.toString());
            messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                @Override
                public void onSuccess(SendResult<Integer, String> result) {
                    if (LOGGER.isInfoEnabled()) {
                        LOGGER.info("Kafka KafkaLocalSender onSuccess");
                    }
                }

                @Override
                public void onFailure(Throwable ex) {
                    LOGGER.error("Kafka KafkaLocalSender onFailure:" + ex);
                }
            });
        };

        JsonObject jsonResult = new JsonObject();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User userDetails = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();

                if (hash != null) {
                    if (MetaDao.deleteMeta(hash, userDetails) != null) {
                        KafkaLocalSender.run(userDetails, "deletemetricbyhash", hash);
                        jsonResult.addProperty("sucsses", true);
                    } else {
                        jsonResult.addProperty("sucsses", false);
                    }

                } else {
                    jsonResult.addProperty("sucsses", false);
                }

                if ((key != null) && (value != null)) {
                    ConcoutMetricMetaList MtrList;
                    try {

                        if (key.equals("name")) {
                            MtrList = userDetails.getMetricsMeta().getbyName(value);
                        } else {
                            MtrList = userDetails.getMetricsMeta().getbyTag(key, value);
                        }
                        ArrayList<Deferred<Object>> list = MetaDao.deleteMetaByList(MtrList, userDetails, KafkaLocalSender);
                        Deferred.groupInOrder(list).join();
                    } catch (Exception ex) {
                        jsonResult.addProperty("sucsses", false);
                        LOGGER.error(globalFunctions.stackTrace(ex));
                    }
                } else {
                    jsonResult.addProperty("sucsses", false);
                }

//                if (name != null) {
//                    MetaDao.deleteMetaByName(name, userDetails);
//                    jsonResult.addProperty("sucsses", true);
//                } else {
//                    jsonResult.addProperty("sucsses", false);
//                }
//                userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put(
                "jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/gettagkey"})
    public String getTagkeys(
            @RequestParam(value = "filter", required = false, defaultValue = "") String filter,
            ModelMap map) {
        JsonObject jsonResult = new JsonObject();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        User userDetails;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
        } else {
            userDetails = UserDao.getUserByUUID(UUID.fromString("c1393383-217a-44ef-b699-8d69fe1867dc"));
        }

        if (userDetails != null) {
            try {

                if (userDetails.getMetricsMeta() == null) {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                }
                Map<String, Set<String>> tags = userDetails.getMetricsMeta().getTagsList();
                JsonArray jsondata = new JsonArray();

                if (filter.equals("") || filter.equals("*")) {
                    for (Map.Entry<String, Set<String>> tag : tags.entrySet()) {
                        jsondata.add(tag.getKey());
                    }
                } else {
                    Pattern r = Pattern.compile(filter);

                    for (Map.Entry<String, Set<String>> tag : tags.entrySet()) {
                        Matcher m = r.matcher(tag.getKey());
                        if (m.find()) {
                            jsondata.add(tag.getKey());
                        }
                    }
                }

                jsonResult.add("data", jsondata);

                jsonResult.addProperty("sucsses", true);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/gettagvalue"})
    public String getTagvalues(
            @RequestParam(value = "filter", required = false, defaultValue = "") String filter,
            @RequestParam(value = "key", required = true) String key,
            ModelMap map) {
        JsonObject jsonResult = new JsonObject();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        User userDetails;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
        } else {
            userDetails = UserDao.getUserByUUID(UUID.fromString("c1393383-217a-44ef-b699-8d69fe1867dc"));
        }

        if (userDetails != null) {
            try {

                if (userDetails.getMetricsMeta() == null) {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                }
                Set<String> tags = userDetails.getMetricsMeta().getTagsList().get(key);
                JsonArray jsondata = new JsonArray();

                if (filter.equals("") || filter.equals("*")) {
                    tags.forEach((tag) -> {
                        jsondata.add(tag);
                    });
                } else {
                    Pattern r = Pattern.compile(filter);
                    if (tags != null) {
                        tags.forEach((tag) -> {
                            Matcher m = r.matcher(tag);
                            if (m.find()) {
                                jsondata.add(tag);
                            }
                        });
                    }

                }

                jsonResult.add("data", jsondata);

                jsonResult.addProperty("sucsses", true);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/resetregression"})
    public String regrresinreset(
            @RequestParam(value = "hash") int hash,
            ModelMap map) {
        JsonObject jsonResult = new JsonObject();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        User userDetails;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
        } else {
            userDetails = UserDao.getUserByUUID(UUID.fromString("c1393383-217a-44ef-b699-8d69fe1867dc"));
        }

        if (userDetails != null) {
            try {
                JsonObject Jsonchangedata = new JsonObject();
                Jsonchangedata.addProperty("UUID", userDetails.getId().toString());
                Jsonchangedata.addProperty("action", "resetregresion");
                Jsonchangedata.addProperty("hash", hash);

                // Send chenges to kafka
                ListenableFuture<SendResult<Integer, String>> messge = conKafkaTemplate.send("semaphore", Jsonchangedata.toString());
                messge.addCallback(new ListenableFutureCallback<SendResult<Integer, String>>() {
                    @Override
                    public void onSuccess(SendResult<Integer, String> result) {
                        if (LOGGER.isInfoEnabled()) {
                            LOGGER.info("Kafka resetregresion onSuccess");
                        }
                    }

                    @Override
                    public void onFailure(Throwable ex) {
                        LOGGER.error("Kafka resetregresion onFailure:" + ex);
                    }
                });

                jsonResult.addProperty("sucsses", true);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/getmetastat"})
    public String getmetastat(ModelMap map) {
        JsonObject jsonResult = new JsonObject();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        User userDetails;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
        } else {
            userDetails = UserDao.getUserByUUID(UUID.fromString("b46898ea-8eb2-4281-bd2c-93c37ba0d8ea"));
        }

        if (userDetails != null) {
            try {
                userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                jsonResult.addProperty("names", userDetails.getMetricsMeta().GetNames().size());
                jsonResult.addProperty("tagscount", userDetails.getMetricsMeta().getTagsList().size());
                jsonResult.addProperty("count", userDetails.getMetricsMeta().size());
                jsonResult.addProperty("uniqtagscount", userDetails.getMetricsMeta().getTaghashlist().size());
                JsonObject tagaslist = new JsonObject();
                for (Map.Entry<String, Set<String>> item : userDetails.getMetricsMeta().getTagsList().entrySet()) {
                    tagaslist.addProperty(item.getKey(), item.getValue().size());
                }
                jsonResult.add("tags", tagaslist);
                jsonResult.addProperty("sucsses", true);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

    @RequestMapping(value = {"/getmetastat/{uuid}"})
    public String getmetastatadmin(@PathVariable(value = "uuid") String uuid, ModelMap map) {
        JsonObject jsonResult = new JsonObject();
//        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        User userDetails;

        userDetails = UserDao.getUserByUUID(UUID.fromString(uuid));

        if (userDetails != null) {
            try {
                userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                jsonResult.addProperty("names", userDetails.getMetricsMeta().GetNames().size());
                jsonResult.addProperty("tagscount", userDetails.getMetricsMeta().getTagsList().size());
                jsonResult.addProperty("count", userDetails.getMetricsMeta().size());
                jsonResult.addProperty("uniqtagscount", userDetails.getMetricsMeta().getTaghashlist().size());
                JsonObject tagaslist = new JsonObject();
                for (Map.Entry<String, Set<String>> item : userDetails.getMetricsMeta().getTagsList().entrySet()) {
                    tagaslist.addProperty(item.getKey(), item.getValue().size());
                }
                jsonResult.add("tags", tagaslist);
                jsonResult.addProperty("sucsses", true);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }
}
