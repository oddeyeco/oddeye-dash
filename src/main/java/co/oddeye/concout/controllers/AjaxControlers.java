/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.User;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeyeTag;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.SeekableView;
import net.opentsdb.utils.DateTime;
//import com.google.gson.JsonObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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

    @RequestMapping(value = "/getdata", method = RequestMethod.GET)
    public String singlecahrt(@RequestParam(value = "tags") String tags,
            @RequestParam(value = "metrics") String metrics,
            @RequestParam(value = "startdate", required = false, defaultValue = "10m-ago") String startdate,
            @RequestParam(value = "enddate", required = false, defaultValue = "now") String enddate,
            @RequestParam(value = "aggregator", required = false, defaultValue = "none") String aggregator,
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
        if (userDetails != null) {
            Long start_time = DateTime.parseDateTimeString(startdate, null);
            Long end_time = DateTime.parseDateTimeString(enddate, null);
            Long starttime = System.currentTimeMillis();
            ArrayList<DataPoints[]> data = DataDao.getDatabyQuery(userDetails, metrics, aggregator, tags, startdate, enddate, downsample);
            Long getinterval = System.currentTimeMillis() - starttime;
            starttime = System.currentTimeMillis();
            if (data != null) {
                for (DataPoints[] DataPointslist : data) {
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
                            if (Point.timestamp() < start_time) {
                                continue;
                            }
                            if (Point.timestamp() > end_time) {
                                continue;
                            }

                            DatapointsJSON.addProperty(Long.toString(Point.timestamp()), Point.doubleValue());
                        }

                        jsonMessage.add("data", DatapointsJSON);
                        jsonMessages.add(jsonuindex, jsonMessage);

                    }

                }
            }
            Long scaninterval = System.currentTimeMillis() - starttime;
            jsonResult.addProperty("gettime", getinterval);
            jsonResult.addProperty("scantime", scaninterval);
            jsonResult.add("chartsdata", jsonMessages);
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
                ArrayList<OddeeyMetricMeta> Metriclist = userDetails.getMetricsMeta().getbyTags(tagsMap, filter);
                jsonResult.addProperty("sucsses", true);
                jsonResult.addProperty("count", Metriclist.size());

                for (final OddeeyMetricMeta metric : Metriclist) {
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
                Logger.getLogger(AjaxControlers.class.getName()).log(Level.SEVERE, null, ex);
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
                ArrayList<OddeeyMetricMeta> Metriclist = userDetails.getMetricsMeta().getbyTag(key, value);
                jsonResult.addProperty("sucsses", true);
                jsonResult.addProperty("count", Metriclist.size());
                for (final OddeeyMetricMeta metric : Metriclist) {
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
                Logger.getLogger(AjaxControlers.class.getName()).log(Level.SEVERE, null, ex);
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
            ModelMap map) {
        JsonObject jsonResult = new JsonObject();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                User userDetails = (User) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal();

                if (hash != null) {
                    MetaDao.deleteMeta(hash, userDetails);
                    jsonResult.addProperty("sucsses", true);
                } else {
                    jsonResult.addProperty("sucsses", false);
                }

                if ((key != null) && (value != null)) {
                    MetaDao.deleteMetaByTag(key, value, userDetails);
                    jsonResult.addProperty("sucsses", true);
                } else {
                    jsonResult.addProperty("sucsses", false);
                }
//                userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));

            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                Logger.getLogger(AjaxControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

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
                Logger.getLogger(AjaxControlers.class.getName()).log(Level.SEVERE, null, ex);
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
                    for (String tag : tags) {
                        jsondata.add(tag);
                    }
                } else {
                    Pattern r = Pattern.compile(filter);

                    for (String tag : tags) {
                        Matcher m = r.matcher(tag);
                        if (m.find()) {
                            jsondata.add(tag);
                        }
                    }
                }

                jsonResult.add("data", jsondata);

                jsonResult.addProperty("sucsses", true);
            } catch (Exception ex) {
                jsonResult.addProperty("sucsses", false);
                Logger.getLogger(AjaxControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            jsonResult.addProperty("sucsses", false);
        }

        map.put("jsonmodel", jsonResult);

        return "ajax";
    }

}