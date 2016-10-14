/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.opentsdb.core.TSDB;
import org.springframework.stereotype.Repository;
import net.opentsdb.utils.Config;
import net.opentsdb.core.Query;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.TSQuery;
import net.opentsdb.core.TSSubQuery;
import net.opentsdb.query.filter.TagVFilter;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseDataDao extends HbaseBaseDao {

    @Autowired
    private BaseTsdbConnect BaseTsdb;

    private final static String tablename = "HbaseDataDao";    
    private final Map<String, String> tags = new HashMap<>();    

    public HbaseDataDao() {
        super(tablename);
    }

    public ArrayList<DataPoints[]> getDatabyQuery(User user, String metrics, String tagsquery) {
        String Startdate = "5m-ago";
        String Enddate = "now";
        return getDatabyQuery(user, metrics, tagsquery, Startdate, Enddate, "");
    }

    public ArrayList<DataPoints[]> getDatabyQuery(User user, String metrics, String tagsquery, String Startdate, String Enddate, String Downsample) {

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

            for (String metric : metricslist) {
                
                    final TSSubQuery sub_query = new TSSubQuery();
                    sub_query.setMetric(metric);
                    sub_query.setAggregator("none");

                    if (!Downsample.equals(""))
                    {
                        sub_query.setDownsample(Downsample);
                    }
                    for (String tag : tglist) {
                        tgitem = tag.split("=");
                        tags.put(tgitem[0], tgitem[1]);
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
        } catch (Exception ex) {
            Logger.getLogger(HbaseDataDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;

    }

}
