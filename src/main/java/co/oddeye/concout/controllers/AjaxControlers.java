/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.dao.HbaseDataDao;
import com.google.gson.JsonObject;
import java.math.BigDecimal;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import org.apache.hadoop.hbase.util.Bytes;

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
            @PathVariable(value = "fromdate") int fromdate,
            @PathVariable(value = "count") int count,
            ModelMap map) {
//        tagkey = "valdasdsaod";
        ResultScanner resultScanner = DataDao.getSingleDataByTags(null, tagkey, tagname, metric);
        try {
            Result[] result = resultScanner.next(count);
            map.put("result", result);
            Map<Long, Double> result1 = new TreeMap();
            JsonObject jsonMessage = new JsonObject();
//            JsonObjectBuilder model = Json.createObjectBuilder();
            byte[] Value;
            for (Result item : result) {
                Value = item.getValue(Bytes.toBytes("tags"), Bytes.toBytes("timestamp"));
                double tt = Bytes.toDouble(Value);
                long timestamp = (long) tt;
                Value = item.getValue(Bytes.toBytes("data"), Bytes.toBytes(metric));
                double data = Bytes.toDouble(Value);
                result1.put(timestamp, data);

            }

            for (Map.Entry<Long, Double> entry : result1.entrySet()) {
                jsonMessage.addProperty(String.format("%d", entry.getKey()), entry.getValue());
            }

//            map.put("result1", result1);
            map.put("jsonmodel", jsonMessage);

        } catch (Exception e) {
            e.printStackTrace();
            map.put("result1", e);
        }

        return "ajax";
    }
}
