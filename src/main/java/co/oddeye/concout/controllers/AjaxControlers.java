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
import com.google.gson.JsonArray;
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
            @RequestParam(value = "startdate", required = false, defaultValue = "1h-ago") String startdate,
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
        JsonArray jsonMessages = new JsonArray();
        JsonObject jsonResult = new JsonObject();

        starttime = System.currentTimeMillis();
        if (data != null) {
            for (DataPoints[] DataPointslist : data) {
                for (DataPoints DataPoints : DataPointslist) {
                    final JsonObject jsonMessage = new JsonObject();
                    jsonMessage.addProperty("index", DataPoints.getQueryIndex());
                    jsonMessage.addProperty("metric", DataPoints.metricName());
                    Tagmap = DataPoints.getTags();
                    Tagmap.remove("UUID");
                    final JsonElement TagsJSON = gson.toJsonTree(Tagmap);
                    jsonMessage.add("tags", TagsJSON);
                    Tagmap.clear();
                    final SeekableView Datalist = DataPoints.iterator();
                    final JsonObject DatapointsJSON = new JsonObject();
                    while (Datalist.hasNext()) {
                        DataPoint Point = Datalist.next();
                        if (Point.timestamp() < start_time) {
                            continue;
                        }
                        DatapointsJSON.addProperty(Long.toString(Point.timestamp()), Point.doubleValue());
                    }

                    jsonMessage.add("data", DatapointsJSON);
                    jsonMessages.add(jsonMessage);

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
