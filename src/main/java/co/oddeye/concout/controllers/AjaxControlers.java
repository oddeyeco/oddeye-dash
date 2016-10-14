/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.model.User;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.util.ArrayList;
import java.util.Map;
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

    @RequestMapping(value = "/getdata", method = RequestMethod.GET)
    public String singlecahrt(@RequestParam(value = "tags") String tags,
            @RequestParam(value = "metrics") String metrics,
            @RequestParam(value = "startdate", required = false, defaultValue = "5m-ago") String startdate,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = null;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            user = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

        }

        Gson gson = new Gson();

        Map<String, String> Tagmap;

        Long start_time = DateTime.parseDateTimeString(startdate, null);
        Long starttime = System.currentTimeMillis();
        ArrayList<DataPoints[]> data = DataDao.getDatabyQuery(user, metrics, tags, startdate);
        Long getinterval = System.currentTimeMillis() - starttime;
        JsonObject jsonMessages = new JsonObject();
        JsonObject jsonResult = new JsonObject();

        starttime = System.currentTimeMillis();
        if (data != null) {
            for (DataPoints[] DataPointslist : data) {
                for (DataPoints DataPoints : DataPointslist) {
                    Tagmap = DataPoints.getTags();
                    Tagmap.remove("UUID");
                    Tagmap.remove("alert_level");

                    JsonObject jsonMessage;

                    String jsonuindex = DataPoints.metricName()+Integer.toString(Tagmap.hashCode());
                    
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

//            jsonResult.addProperty("itemscount", itemscount);
//            jsonResult.addProperty("firstinterval", firstinterval);
//            jsonResult.addProperty("stepinterval", stepinterval);
        map.put("jsonmodel", jsonResult);

        return "ajax";
    }
}
