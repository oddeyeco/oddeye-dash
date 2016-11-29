/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.core.ConcoutMetricErrorMeta;
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
import java.util.logging.Level;
import java.util.logging.Logger;
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

/**
 *
 * @author vahan
 */
@Controller
public class UserController {

    @Autowired
    HbaseErrorsDao ErrorsDao;
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    HbaseDataDao DataDao;
    private Map<String, String> Tagmap;
    private final Gson gson = new Gson();

    @RequestMapping(value = "/monitoring", method = RequestMethod.GET)
    public String monitoring(HttpServletRequest request, ModelMap map) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (!(auth instanceof AnonymousAuthenticationToken)) {
            User userDetails = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();
            map.put("curentuser", userDetails);
            map.put("ErrorsDao", ErrorsDao);

            String group_item = request.getParameter("group_item");
//            if (group_item == null) {
//                map.put("group_item", userDetails.getMetricsMeta().getTagsList().entrySet().iterator().next().getKey());
//            } else {
//                map.put("group_item", group_item);
//            }

            String ident_tag = request.getParameter("ident_tag");

            if (userDetails.getMetricsMeta()== null)
            {
                try {
                    userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
                } catch (Exception ex) {
                    Logger.getLogger(UserController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            Iterator<Map.Entry<String, Set<String>>> iter = userDetails.getMetricsMeta().getTagsList().entrySet().iterator();
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
                map.put("minWeight", Math.abs(Short.parseShort(minWeight)));
            }

            String minRecurrenceCount = request.getParameter("minRecurrenceCount");
            if (minValue == null) {
                map.put("minRecurrenceCount", 2);
            } else {
                map.put("minRecurrenceCount", Math.abs(Short.parseShort(minRecurrenceCount)));
            }
            String minPredictPersent = request.getParameter("minPredictPersent");
            if (minValue == null) {
                map.put("minPredictPersent", 50);
            } else {
                map.put("minPredictPersent", Math.abs(Short.parseShort(minPredictPersent)));
            }            
            
            

            String minRecurrenceTimeInterval = request.getParameter("minRecurrenceTimeInterval");
            if (minValue == null) {
                map.put("minRecurrenceTimeInterval", 60);
            } else {
                map.put("minRecurrenceTimeInterval", Math.abs(Integer.parseInt(minRecurrenceTimeInterval)));
            }

        }

        map.put("body", "monitoring");
        map.put("jspart", "monitoringjs");

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
                ConcoutMetricErrorMeta Error = ErrorsDao.getErrorMeta(userDetails, Hex.decodeHex(metriqkey.toCharArray()), Long.parseLong(timestamp));
                if (Error == null)
                {
                    return "index";
                }
                Map<String, MetriccheckRule> rules = MetaDao.getErrorRules(Error, Long.parseLong(timestamp));
                map.put("Error", Error);
                map.put("Rules", rules);
                ArrayList<DataPoints[]> data = new ArrayList<>();                
                // Get rules chart data
                for (Map.Entry<String, MetriccheckRule> rule : rules.entrySet()) {
                    Calendar calobject = rule.getValue().getTime();
                    String startdate = Long.toString(calobject.getTimeInMillis());
                    calobject.add(Calendar.HOUR, 1);
                    calobject.add(Calendar.MILLISECOND, -1);
                    String enddate = Long.toString(calobject.getTimeInMillis());
                    data.addAll(DataDao.getDatabyQuery(userDetails, Error.getName(), "none", Error.getFullFilter(), startdate, enddate, ""));
                    if (!data.isEmpty()) {
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
                                    DatapointsJSON.addProperty(Long.toString(Point.timestamp()), Point.doubleValue());                                    
                                }

                                jsonMessage.add("data", DatapointsJSON);
                                jsonMessages.add(startdate, jsonMessage);

                            }

                        }
                    }
                    data.clear();
                }
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
                data.addAll(DataDao.getDatabyQuery(userDetails, Error.getName(), "none", Error.getFullFilter(), startdate, enddate, ""));
                if (!data.isEmpty()) {
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
                                DatapointsJSON.addProperty(Long.toString(Point.timestamp()), Point.doubleValue());                                
                            }

                            jsonMessage.add("data", DatapointsJSON);
                            jsonMessages.add(startdate, jsonMessage);

                        }

                    }
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
                for (long i = Long.parseLong(startdate); i < Long.parseLong(enddate); i = i + 10000) {
                    DatapointsJSON.addProperty(Long.toString(i), Error.getRegression().predict(i));
                }
                jsonMessage.add("data", DatapointsJSON);
                jsonMessages.add("predict", jsonMessage);
                map.put("chartdata", jsonMessages);
                // End Predict

            } catch (Exception ex) {
                Logger.getLogger(UserController.class
                        .getName()).log(Level.SEVERE, null, ex);
            }

        }

        map.put("body", "advansed");
        map.put("jspart", "advansedjs");

        return "index";
    }

}
