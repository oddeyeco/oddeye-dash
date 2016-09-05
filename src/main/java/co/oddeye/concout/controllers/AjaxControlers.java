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
import java.util.Iterator;
import java.util.Map;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.SeekableView;
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
//http://localhost:8080/OddeyeCoconut/getdata/host/cassa005.mouseflow.eu/drive_md0_read_bytes/1468072117/10

    @RequestMapping(value = "/getdata", method = RequestMethod.GET)
    public String singlecahrt(@RequestParam(value = "tags") String tags, @RequestParam(value = "metrics") String metrics,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = null;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            user = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

        }

        Gson gson = new Gson();

        Map<String, String> Tagmap;

        ArrayList<DataPoints[]> data = DataDao.getDatabyQuery(user.getId(), metrics, tags);
        JsonArray jsonMessages = new JsonArray();
        JsonObject jsonResult = new JsonObject();
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
                        DatapointsJSON.addProperty(Long.toString(Point.timestamp()), Point.doubleValue());
                    }

                    jsonMessage.add("data", DatapointsJSON);
                    jsonMessages.add(jsonMessage);

                }

            }
        }
        jsonResult.add("chartsdata", jsonMessages);
//            jsonResult.addProperty("gettime", getinterval);
//            jsonResult.addProperty("scantime", scaninterval);
//            jsonResult.addProperty("itemscount", itemscount);
//            jsonResult.addProperty("firstinterval", firstinterval);
//            jsonResult.addProperty("stepinterval", stepinterval);
        map.put("jsonmodel", jsonResult);

        return "ajax";
    }
}
