/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.config.DatabaseConfig;
import co.oddeye.concout.model.OddeyeUserModel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.opentsdb.core.Query;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.Internal;
import net.opentsdb.core.TSQuery;
import net.opentsdb.core.TSSubQuery;
import net.opentsdb.query.filter.TagVFilter;
import org.hbase.async.HBaseException;
import org.hbase.async.KeyValue;
import org.hbase.async.Scanner;

/**
 *
 * @author vahan
 */
//@Repository
public class HbaseDataDao extends HbaseBaseDao {

    public HbaseDataDao(DatabaseConfig p_config) {
        super(p_config.getTsdbDataTable());                
    }    

    public short getLastAlertLevel(OddeyeUserModel user, String metric, String tagsquery) throws Exception {
        KeyValue lastekv = getLastbyQuery(user, metric, tagsquery);
        if (lastekv == null) {
            return -100;
        }
        Map<String, String> tags_list = Internal.getTags(BaseTsdb.getTsdb(), lastekv.key());
        return Short.parseShort(tags_list.get("alert_level"));
    }

    public KeyValue getLastbyQuery(OddeyeUserModel user, String metric, String tagsquery) throws Exception {

        final TSQuery tsquery = new TSQuery();
        tsquery.setStart("5s-ago");
        tsquery.setEnd("now");
        final ArrayList<TSSubQuery> sub_queries = new ArrayList<>(1);
        String[] tgitem;
        final TSSubQuery sub_query = new TSSubQuery();
        sub_query.setMetric(metric);
        sub_query.setAggregator("none");
        final String[] tglist = tagsquery.split(";");
        final Map<String, String> tags = new HashMap<>();
        for (String tag : tglist) {
            tgitem = tag.split("=");
            tags.put(tgitem[0], tgitem[1]);
        }
        tags.put("UUID", user.getId().toString());

        final List<TagVFilter> filters = new ArrayList<>();
        TagVFilter.mapToFilters(tags, filters, true);
        tags.clear();
        sub_query.setFilters(filters);
        sub_queries.add(sub_query);

        tsquery.setQueries(sub_queries);
        tsquery.validateAndSetQuery();
        Query[] tsdbqueries = tsquery.buildQueries(BaseTsdb.getTsdb());
        final int nqueries = tsdbqueries.length;
        List<Scanner> scaners = null;
        for (int i = 0; i < nqueries; i++) {
            scaners = Internal.getScanners(tsdbqueries[i]);
        }

        if (scaners == null) {
            return null;
        }

        final Scanner scanner = scaners.get(0);
        ArrayList<ArrayList<KeyValue>> rows;
        scanner.setMaxNumRows(1);
        long lastTime = 0;
        KeyValue lastekv = null;
        while ((rows = scanner.nextRows().joinUninterruptibly()) != null) {
            final ArrayList<KeyValue> row = rows.get(rows.size() - 1);
            final KeyValue kv = row.get(row.size() - 1);
            if (kv.timestamp() > lastTime) {
                lastekv = kv;
                lastTime = kv.timestamp();
            }

        }

        return lastekv;
    }

    public ArrayList<DataPoints[]> getDatabyQuery(OddeyeUserModel user, String metrics, String tagsquery) {
        String Startdate = "5m-ago";
        String Enddate = "now";
        return getDatabyQuery(user, metrics, "none", tagsquery, Startdate, Enddate, "",false);
    }

    public ArrayList<DataPoints[]> getDatabyQuery(OddeyeUserModel user, String metrics, String aggregator, String tagsquery, String Startdate, String Enddate, String Downsample, Boolean rate) {

        try {
            final TSQuery tsquery = new TSQuery();
            final UUID userid = user.getId();
            tsquery.setStart(Startdate);
            if (!Enddate.equals("now")) {
                tsquery.setEnd(Enddate);
            }

            tsquery.setDelete(false);
            final List<TagVFilter> filters = new ArrayList<>();
            final ArrayList<TSSubQuery> sub_queries = new ArrayList<>(1);
            final String[] metricslist = metrics.split(";");
            final String[] tglist = tagsquery.split(";");
            String[] tgitem;
            final Map<String, String> tags = new HashMap<>();
            for (String metric : metricslist) {

                final TSSubQuery sub_query = new TSSubQuery();
                sub_query.setMetric(metric);
                sub_query.setAggregator(aggregator);
                if (rate)
                {
                    sub_query.setRate(true);
                }

                if (!Downsample.equals("")) {
                    sub_query.setDownsample(Downsample);
                }
                for (String tag : tglist) {
                    tgitem = tag.split("=");
                    if (tgitem.length == 2) {
                        if (tgitem[1].equals("")) {
                            tgitem[1] = "*";                        
                        }
                        tags.put(tgitem[0], tgitem[1]);
                    }
                }
                tags.put("UUID", userid.toString());
//                sub_query.setTags(tags);
                TagVFilter.mapToFilters(tags, filters, true);
                sub_query.setFilters(filters);
//                sub_query.setDownsample("1m-ep999r7");
                sub_queries.add(sub_query);

                tags.clear();
            }

            tags.clear();
            tsquery.setQueries(sub_queries);

            tsquery.validateAndSetQuery();

            Query[] tsdbqueries = tsquery.buildQueries(BaseTsdb.getTsdb());

            // create some arrays for storing the results and the async calls
            final int nqueries = tsdbqueries.length;
            final ArrayList<DataPoints[]> results
                    = new ArrayList<>(nqueries);
//            final ArrayList<Deferred<DataPoints[]>> deferreds
//                    = new ArrayList<Deferred<DataPoints[]>>(nqueries);

            // this executes each of the sub queries asynchronously and puts the
            // deferred in an array so we can wait for them to complete.
            for (int i = 0; i < nqueries; i++) {
                results.add(tsdbqueries[i].run());
            }

            return results;
        } catch (HBaseException ex) {
            Logger.getLogger(HbaseDataDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;

    }
    
    private String getCacheKey(
            OddeyeUserModel user,
            String metrics,
            String aggregator,
            String tagsquery,
            String startDate,
            String endDate,
            String downsample,
            Boolean rate) {
        return "YYYX";
    }
    
    List<DataPoints[]>  cache = null;
    private List<DataPoints[]> getDatabyQueryCached(
            String key) {
        return null;
    }
    
    private void putToCache(String key, List<DataPoints[]> result) {
        cache = new ArrayList<>(result.size());
        for(DataPoints[] dataPoints : result) {
            DataPoints[] newDataPointsArray = new DataPoints[dataPoints.length];
            for(int i = 0;i < dataPoints.length;i++){
                newDataPointsArray[i] = new DataPointsImpl(dataPoints[i]);
            }
                    
            cache.add(newDataPointsArray);
        }      
    }
    
    public List<DataPoints[]> getDatabyQueryCached(
            OddeyeUserModel user,
            String metrics,
            String aggregator,
            String tagsquery,
            String startDate,
            String endDate,
            String downsample,
            Boolean rate) {
        String cacheKey = getCacheKey(user, metrics, aggregator, tagsquery, startDate, endDate, downsample, rate);
        List<DataPoints[]> result;
        if(null != cacheKey) {
            result = getDatabyQueryCached(cacheKey);
            if(null != result) {
                List<DataPoints[]> filteredResult = new ArrayList<>(result.size());
                for(DataPoints[] metricPoints : result) {
                    List<DataPoints> filteredMetric = new LinkedList<>();
                    for(DataPoints point : metricPoints) {
//                        if(point.getT)
                    }
//                    filteredResult.add(metricPoints.strea);
                }
                return result;
            } else {
                result = getDatabyQuery(user, metrics, aggregator, tagsquery, startDate, endDate, downsample, rate);
                putToCache(cacheKey, result);
                return cache;
            }
        } else {
           return getDatabyQuery(user, metrics, aggregator, tagsquery, startDate, endDate, downsample, rate);
        }

    }
}
