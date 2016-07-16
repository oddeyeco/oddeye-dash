/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.model.User;
import com.google.gson.JsonObject;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import java.util.Map;
import java.util.TreeMap;
import org.apache.avro.generic.GenericData;

import org.apache.hadoop.hbase.util.Bytes;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

/**
 *
 * @author vahan
 */
@Controller
public class AjaxControlers {

    @Autowired
    HbaseDataDao DataDao;
//http://localhost:8080/OddeyeCoconut/getdata/host/cassa005.mouseflow.eu/drive_md0_read_bytes/1468072117/10

    @RequestMapping(value = "/getdata/{tagkey:.+}/{tagname:.+}/{metric:.+}/{fromdate}/{count}", method = RequestMethod.GET)
    public String singlecahrt(@PathVariable(value = "tagkey") String tagkey, @PathVariable(value = "tagname") String tagname,
            @PathVariable(value = "metric") String metric,
            @PathVariable(value = "fromdate") long fromdate,
            @PathVariable(value = "count") int count,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = null;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            user = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

        }
        ResultScanner resultScanner = DataDao.getSingleDataByTags(user, tagkey, tagname, metric, fromdate, count);
        try {
//            Result[] result = resultScanner.next(1);
//            map.put("result", result);
            Map<String, Map<Long, Double>> result1 = new TreeMap();
//            Map<Long, Double> result1 = new TreeMap();            
            JsonObject jsonMessage = new JsonObject();
//            JsonObjectBuilder model = Json.createObjectBuilder();
            byte[] Value;
            for (Result item = resultScanner.next(); item != null; item = resultScanner.next()) //            for (Result item : result) 
            {
                Value = item.getValue(Bytes.toBytes("tags"), Bytes.toBytes("timestamp"));
                double tt = Bytes.toDouble(Value);
                long timestamp = (long) tt;
                Value = item.getValue(Bytes.toBytes("data"), Bytes.toBytes(metric));
                double data = Bytes.toDouble(Value);
                Value = item.getValue(Bytes.toBytes("tags"), Bytes.toBytes("host"));
                String host = Bytes.toString(Value);
                Map<Long, Double> datamap;
                if (result1.containsKey(host)) {
                    datamap = result1.get(host);
                } else {
                    datamap = new TreeMap();
                    result1.put(host, datamap);
                }
                datamap.put(timestamp, data);

            }

            for (Map.Entry<String, Map<Long, Double>> hostentry : result1.entrySet()) {
                if (!jsonMessage.has(hostentry.getKey())) {
                    JsonObject dataJson = new JsonObject();
                    jsonMessage.add(hostentry.getKey(), dataJson);
                }
                for (Map.Entry<Long, Double> dataentry : hostentry.getValue().entrySet()) {
                    jsonMessage.getAsJsonObject(hostentry.getKey()).addProperty(String.format("%d", dataentry.getKey()), dataentry.getValue());
                }
            }

//            for (Map.Entry<Long, Double> entry : result2.entrySet()) {
//                jsonMessage.addProperty(String.format("%d", entry.getKey()), entry.getValue());
//            }            
//            map.put("result1", result1);
            JsonObject jsonResult= new JsonObject();
            jsonResult.add("chartdata",jsonMessage);
            map.put("jsonmodel", jsonResult);

        } catch (Exception e) {
            e.printStackTrace();
            map.put("result1", e);
        }

        return "ajax";
    }

    @RequestMapping(value = "/gettestdata/{tagkey:.+}/{tagname:.+}/{metric:.+}/{fromdate}/{count}", method = RequestMethod.GET)
    public String gettestdata(@PathVariable(value = "tagkey") String tagkey, @PathVariable(value = "tagname") String tagname,
            @PathVariable(value = "metric") String metric,
            @PathVariable(value = "fromdate") long fromdate,
            @PathVariable(value = "count") int count,
            ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = null;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            user = (User) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal();

        }
        ResultScanner resultScanner = DataDao.getSingleDataByTags(user, tagkey, tagname, metric, fromdate, count);
        try {

            Map<Long, Result> result = new TreeMap();
            byte[] Value;
            for (Result item = resultScanner.next(); item != null; item = resultScanner.next()) {
//                Value = item.getValue(Bytes.toBytes("tags"), Bytes.toBytes("timestamp"));
//                double tt = Bytes.toDouble(Value);
//                long timestamp = (long) tt;
//                Value = item.getValue(Bytes.toBytes("data"), Bytes.toBytes(metric));
//                double data = Bytes.toDouble(Value);
//                result1.put(timestamp, data);

                long timestamp2 = item.rawCells()[0].getTimestamp();
//                item.rawCells()
                result.put(timestamp2, item);
            }

//            map.put("result1", result1);
            map.put("jsonmodel", result);

        } catch (Exception e) {
            e.printStackTrace();
            map.put("result1", e);
        }

        return "ajax";
    }
}
