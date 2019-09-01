/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;

import co.oddeye.concout.core.ConcoutMetricMetaList;
import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseErrorHistoryDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.ErrorState;
import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeyeTag;
import co.oddeye.core.globalFunctions;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.GetRequest;
import org.hbase.async.GetResultOrException;
import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author vahan
 */
@Controller
public class dataControlers {

    @Autowired
    private HbaseDataDao Datadao;
    @Autowired
    HbaseMetaDao MetaDao;
    @Autowired
    HbaseErrorHistoryDao ErrorHistoryDao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private BaseTsdbConnect BaseTsdb;
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(dataControlers.class);
    
    @Value("${dash.error.status.delta_in_minutes}")   
    public long deltaStatusMinutes;

    @RequestMapping(value = "/metriclist", params = {"tags",}, method = RequestMethod.GET)
    public String tagMetricsList(@RequestParam(value = "tags") String tags, ModelMap map) {
        map.put("body", "taglist");
        map.put("jspart", "taglistjs");

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();

            map.put("curentuser", userDetails);
            map.put("tags", tags);

        }
        return "index";
    }

    @RequestMapping(value = "/chart/{metricshash}", method = RequestMethod.GET)
    public String singlechart(@PathVariable(value = "metricshash") String metricshash, ModelMap map) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel currentUser = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();

                map.put("curentuser", currentUser);

                OddeyeUserModel userDetails = currentUser;
                if ((currentUser.getSwitchUser() != null)) {
                    if (currentUser.getSwitchUser().getAlowswitch()) {
                        userDetails = currentUser.getSwitchUser();
                    }
                }

                map.put("activeuser", userDetails);
//                if (userDetails.getMetricsMeta() == null) {
//                    try {
//                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
//                    } catch (Exception ex) {
//                        LOGGER.error(globalFunctions.stackTrace(ex));
//                    }
//                }
                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(metricshash);
                if (meta != null) {
                    if (meta.isSpecial()) {
                        return "redirect:/history/" + meta.sha256Code();
                    }

                    map.put("body", "singlechart");
                    map.put("jspart", "singlechartjs");
                    GetRequest getMetric = new GetRequest(MetaDao.getTablename().getBytes(), meta.getKey(), "d".getBytes());
                    ArrayList<KeyValue> row = BaseTsdb.getClient().get(getMetric).joinUninterruptibly();
                    meta = new OddeeyMetricMeta(row, BaseTsdb.getTsdb(), false);

                    map.put("metric", meta);
                    map.put("title", meta.getDisplayName() + "|" + meta.getDisplayTags("|"));
                    map.put("hashcode", meta.sha256Code());
                    map.put("type", meta.getType().ordinal());
                }
                else
                {
                    map.put("body", "singlechart");
                    map.put("jspart", "singlechartjs");   
                    map.put("hashcode", metricshash);
                    map.put("type", 3);                    
                    map.put("title", metricshash);
                }

            } catch (Exception ex) {
                Logger.getLogger(dataControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return "index";
    }

    @RequestMapping(value = "/history/{metricshash}", method = RequestMethod.GET)
    public String singlehistory(@PathVariable(value = "metricshash") String metricshash, ModelMap map) {
        return singlehistory(metricshash, System.currentTimeMillis(), map);
    }

    @RequestMapping(value = "/history/{metricshash}/{date}", method = RequestMethod.GET)
    public String singlehistory(@PathVariable(value = "metricshash") String metricshash, @PathVariable(value = "date") Long date, ModelMap map) {
        map.put("h1title", "Messages hostory");
        map.put("body", "singlehistory");
        map.put("jspart", "singlehistoryjs");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel currentUser = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", currentUser);

                OddeyeUserModel userDetails = currentUser;
                if ((currentUser.getSwitchUser() != null)) {
                    if (currentUser.getSwitchUser().getAlowswitch()) {
                        userDetails = currentUser.getSwitchUser();
                    }
                }

                map.put("activeuser", userDetails);

                OddeeyMetricMeta meta = userDetails.getMetricsMeta().get(metricshash);

                GetRequest getMetricErrors = new GetRequest(MetaDao.getTablename().getBytes(), meta.getKey(), "d".getBytes());
                ArrayList<KeyValue> rowM = BaseTsdb.getClient().get(getMetricErrors).joinUninterruptibly();
                meta = new OddeeyMetricMeta(rowM, BaseTsdb.getTsdb(), false);

                byte[] historykey = ArrayUtils.addAll(meta.getUUIDKey(), meta.getKey());

                Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
                cal.setTimeInMillis(date);
                cal.setTimeZone(TimeZone.getTimeZone(currentUser.getTimezone()));
                if (cal.get(Calendar.HOUR_OF_DAY) > 0) {
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                }
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                cal.set(Calendar.MILLISECOND, 0);

                Calendar cala = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
                cala.setTimeInMillis(cal.getTimeInMillis());
                long startTime = cala.getTimeInMillis();

                byte[] historykey1 = ArrayUtils.addAll(historykey, globalFunctions.getDayKey(cala));
                cala.add(Calendar.DATE, 1);
                long endTime = cala.getTimeInMillis();
                byte[] historykey2 = ArrayUtils.addAll(historykey, globalFunctions.getDayKey(cala));

//                String ss = Hex.encodeHexString(historykey);
                getMetricErrors = new GetRequest(ErrorHistoryDao.getTablename().getBytes(), historykey1, "h".getBytes());
                ArrayList<KeyValue> row1 = BaseTsdb.getClient().get(getMetricErrors).joinUninterruptibly();
                getMetricErrors = new GetRequest(ErrorHistoryDao.getTablename().getBytes(), historykey2, "h".getBytes());
                ArrayList<KeyValue> row2 = BaseTsdb.getClient().get(getMetricErrors).joinUninterruptibly();
//                Scanner scanner = BaseTsdb.getClient().newScanner(ErrorHistoryDao.getTablename());
//                scanner.setFamily("h".getBytes());
//                scanner.setStartKey(historykey1);
//                scanner.setStopKey(historykey2);

                List<ErrorState> list = new ArrayList<>();
                int lastlevel = -255;
                ArrayList<ArrayList<KeyValue>> rows = new ArrayList<>();
                rows.add(row1);
                rows.add(row2);
                for (ArrayList<KeyValue> row : rows) {
                    for (KeyValue KV : row) {
                        ErrorState lasterror = null;
                        try {
                            JsonElement json = globalFunctions.getJsonParser().parse((new String(KV.value())));
                            lasterror = new ErrorState(json.getAsJsonObject());
                        } catch (Exception e) {
                            LOGGER.error(globalFunctions.stackTrace(e));
                        }

                        if (lasterror == null) {
                            continue;
                        }
                        if ((lasterror.getTime() < startTime) || (lasterror.getTime() > endTime)) {
                            continue;
                        }
                        if (lastlevel != lasterror.getLevel()) {
                            list.add(lasterror);
                        }

                        lastlevel = lasterror.getLevel();
                    }
                }

                class RecipeCompare implements Comparator<ErrorState> {

                    @Override
                    public int compare(ErrorState o1, ErrorState o2) {
                        // write comparison logic here like below , it's just a sample
                        return o1.getTime() < o2.getTime() ? 1 : -1;
                    }
                }

                Collections.sort(list, new RecipeCompare());
                //reverse(list);
                map.put("date", new Date(date));
                map.put("list", list);
                map.put("metric", meta);
                map.put("title", meta.getDisplayName() + "|" + meta.getDisplayTags("|"));
            } catch (Exception ex) {
                Logger.getLogger(dataControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return "index";
    }

    @RequestMapping(value = "/chart", method = RequestMethod.GET)
    public String multicahrt(HttpServletRequest request, ModelMap map) {
        map.put("body", "multicahrt");
        map.put("jspart", "multicahrtjs");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            try {
                OddeyeUserModel userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                        getAuthentication().getPrincipal()).getUserModel();
                map.put("curentuser", userDetails);
//                if (userDetails.getMetricsMeta() == null) {
//                    try {
//                        userDetails.setMetricsMeta(MetaDao.getByUUID(userDetails.getId()));
//                    } catch (Exception ex) {
//                        LOGGER.error(globalFunctions.stackTrace(ex));
//                    }
//                }
                String hashes = request.getParameter("hashes");
                String hashesarr = "[\"" + hashes.replaceAll(";", "\",\"") + "\"]";
                map.put("hashes", hashesarr);
                map.put("title", messageSource.getMessage("title.multiChart", new String[]{""}, LocaleContextHolder.getLocale()));
//              map.put("title", "");
            } catch (Exception ex) {
                Logger.getLogger(dataControlers.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return "index";
    }
    
    private static boolean matches(OddeeyMetricMeta meta, Map<String, Pattern> filterTags) {
        Map<String, OddeyeTag> valueTags = meta.getTags();
        for(String valueTagName : valueTags.keySet()) {
            if(filterTags.containsKey(valueTagName)) {
                final Pattern p = filterTags.get(valueTagName);
                final OddeyeTag valueTag = valueTags.get(valueTagName);
                final Matcher m = p.matcher(valueTag.getValue());
                if(!m.matches())
                    return false;
            }
        }
        return true;
    }
    
    @RequestMapping(value = "/getStatusData", method = RequestMethod.GET)
    public @ResponseBody String getStatusData(@RequestParam(value = "tags", required = false) String tags,
            @RequestParam(value = "hash", required = false) String hash,
            @RequestParam(value = "metrics", required = false) String metrics,
            @RequestParam(value = "startdate", required = false, defaultValue = "10m-ago") String startdate,
            @RequestParam(value = "enddate", required = false, defaultValue = "now") String enddate,
            @RequestParam(value = "aggregator", required = false, defaultValue = "none") String aggregator,
            @RequestParam(value = "rate", required = false, defaultValue = "false") Boolean rate,
            @RequestParam(value = "downsample", required = false, defaultValue = "") String downsample) {
        long startTime = System.currentTimeMillis();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        OddeyeUserModel userDetails = null;
        if (!(auth instanceof AnonymousAuthenticationToken)) {
            userDetails = ((OddeyeUserDetails) SecurityContextHolder.getContext().
                    getAuthentication().getPrincipal()).getUserModel();
        }

        Gson gson = new Gson();
        Map<String, Pattern> tagMap = new HashMap<>();
        if(null != tags) {
            String tagsArray[] = tags.split(";");
            for(String tagNameValue : tagsArray) {
                String tagNameValueSplitted[] = tagNameValue.split("=");
                if(tagNameValueSplitted.length > 1) {
                    String filter = tagNameValueSplitted[1];
                    if(!"UUID".equals(filter)){
                        Pattern p;
                        if("*".equals(filter))
                            p = Pattern.compile(".*");
                        else
                            p = Pattern.compile(filter);
                        tagMap.put(tagNameValueSplitted[0], p);
                    }
                }
            }  
        }
        
        JsonObject jsonMessages = new JsonObject();
        JsonObject jsonResult = new JsonObject();
        if ((hash == null) && (metrics == null) && (tags == null)) {
            jsonResult.addProperty("sucsses", Boolean.FALSE);
            return jsonResult.toString();
        }

        if (userDetails != null) {
            if ((userDetails.getSwitchUser() != null)) {
                if (userDetails.getSwitchUser().getAlowswitch()) {
                    userDetails = userDetails.getSwitchUser();
                }
            }
            Map<String, OddeeyMetricMeta> foundMetrics = new HashMap<>();            
            if ((hash != null)) {
                OddeeyMetricMeta metric = userDetails.getMetricsMeta().get(hash);
                if (metric == null && matches(metric, tagMap)) {
                    foundMetrics.put(hash, metric);
                }
            }
            
            if(metrics != null){
                String metricsArray[] = metrics.split(";");
                Set<String> metricsNamesSet = new HashSet<>();
                for(String metricName : metricsArray) {
                    metricsNamesSet.add(metricName);
                }
                
                ConcoutMetricMetaList metricList;
                metricList = userDetails.getMetricsMeta().getbyType("0");
                
                for(String hashKey : metricList.keySet()) {
                    OddeeyMetricMeta nextMetric = metricList.get(hashKey);
                    if(metricsNamesSet.contains(nextMetric.getName()) && matches(nextMetric, tagMap)){
                        foundMetrics.put(hashKey, nextMetric);
                    }
                }
                
                try {
                    String timezone = userDetails.getTimezone();
                    for(String hashKey : foundMetrics.keySet()) {
                        OddeeyMetricMeta metric2check = foundMetrics.get(hashKey);
                        ErrorState es = getMetricRecentState(metric2check, timezone);
                        JsonObject jsonMessage = new JsonObject();                        
                        jsonMessage.addProperty("metric", metric2check.getName());
                        jsonMessage.add("data", new JsonArray());

                        JsonObject tagsMessage = new JsonObject();
                        for(OddeyeTag tag : metric2check.getTags().values()) {
                            String tagName = tag.getKey();
                            if(!"UUID".equals(tagName)) {
                                    tagsMessage.addProperty(tagName, tag.getValue());
                            }
                        }
                        jsonMessage.add("tags", tagsMessage);
                        jsonMessages.add(hashKey, jsonMessage);

                        if(null!= es) {
                            jsonMessage.addProperty("level", es.getLevelName());
                            String message = es.getMessage();
                            if(message.startsWith("{DURATION}")) {
                                long duration = System.currentTimeMillis() - metric2check.getLasttime();
                                message = message.replaceAll("\\{DURATION\\}", Double.toString(duration / 1000.0) + " sec.");
                            }
                            jsonMessage.addProperty("info", message);
                            jsonMessage.addProperty("start", es.getTimestart());
                            jsonMessage.addProperty("end", es.getTimeend());
                            jsonMessage.addProperty("hasData", "true");
                        } else {
                            jsonMessage.addProperty("hasData", "false");                            
                            jsonMessage.addProperty("noDataTime", deltaStatusMinutes);
                        }
                     }
                    jsonResult.add("chartsdata", jsonMessages);
                } catch (Exception e) {
                    LOGGER.error(globalFunctions.stackTrace(e));
                    jsonResult.addProperty("sucsses", Boolean.FALSE);
                    jsonResult.addProperty("message", e.toString());
                }                
                }
        }
        LOGGER.info("getStatusData tooks:{} seconds", (System.currentTimeMillis() - startTime) / 1000.0);
        return jsonResult.toString();
    }
    
    public ErrorState getMetricRecentState(OddeeyMetricMeta meta, String timezone) throws Exception {
        GetRequest getMetricErrors = new GetRequest(MetaDao.getTablename().getBytes(), meta.getKey(), "d".getBytes());
        ArrayList<KeyValue> rowM = BaseTsdb.getClient().get(getMetricErrors).joinUninterruptibly();
        meta = new OddeeyMetricMeta(rowM, BaseTsdb.getTsdb(), false);

        byte[] historykey = ArrayUtils.addAll(meta.getUUIDKey(), meta.getKey());

        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
        long currentTime = System.currentTimeMillis();
        cal.setTimeInMillis(currentTime);
        cal.setTimeZone(TimeZone.getTimeZone(timezone));
        if (cal.get(Calendar.HOUR_OF_DAY) > 0) {
            cal.set(Calendar.HOUR_OF_DAY, 0);
        }
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);

        Calendar cala = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
        cala.setTimeInMillis(cal.getTimeInMillis());

        byte[] historykey1 = ArrayUtils.addAll(historykey, globalFunctions.getDayKey(cala));
        cala.add(Calendar.DATE, 1);
        byte[] historykey2 = ArrayUtils.addAll(historykey, globalFunctions.getDayKey(cala));

        List<GetRequest> requests = new ArrayList<>(2);
        GetRequest getErrorsRequest = new GetRequest(ErrorHistoryDao.getTablename().getBytes(), historykey1, "h".getBytes());
        GetRequest getErrorsRequest2 = new GetRequest(ErrorHistoryDao.getTablename().getBytes(), historykey2, "h".getBytes());
        
        long timeDeltaMiliseconds = (deltaStatusMinutes * 60L * 1000L);
        long topEdge = currentTime + timeDeltaMiliseconds;
        long bottomEdge = currentTime - timeDeltaMiliseconds;
        getErrorsRequest.setMaxTimestamp(topEdge);
        getErrorsRequest2.setMaxTimestamp(topEdge);
        
        getErrorsRequest.setMinTimestamp(bottomEdge);
        getErrorsRequest2.setMinTimestamp(bottomEdge);        
        
        
        requests.add(getErrorsRequest);
        requests.add(getErrorsRequest2);
        
        
        List<GetResultOrException> results = BaseTsdb.getClient().get(requests).joinUninterruptibly();       
//        ArrayList<KeyValue> row1 = BaseTsdb.getClient().get(getErrorsRequest).joinUninterruptibly();
//        ArrayList<KeyValue> row2 = BaseTsdb.getClient().get(getErrorsRequest2).joinUninterruptibly();
//        row1.addAll(row2);

        List<KeyValue> rows = new LinkedList<>();
        for(GetResultOrException roe : results) {
            List<KeyValue> cells = roe.getCells();
            if(null != cells)
                rows.addAll(cells);
        }
        
        ErrorState recentState = null;

        for (KeyValue row : rows) {
            ErrorState lasterror = null;
            try {
                JsonElement json = globalFunctions.getJsonParser().parse((new String(row.value())));
                lasterror = new ErrorState(json.getAsJsonObject());
            } catch (Exception e) {
                LOGGER.error(globalFunctions.stackTrace(e));
            }

            if (lasterror == null) {
                continue;
            }

            if(null == recentState || lasterror.getTime() > recentState.getTime())
                recentState = lasterror;
        }
        return recentState;
    }    
}
