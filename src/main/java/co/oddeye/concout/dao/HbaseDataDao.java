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
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.opentsdb.core.Aggregators;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.TSDB;
import org.springframework.stereotype.Repository;
import net.opentsdb.utils.Config;
import net.opentsdb.core.Query;
import net.opentsdb.core.DataPoints; 
import net.opentsdb.core.SeekableView;



/**
 *
 * @author vahan
 */
@Repository
public class HbaseDataDao extends HbaseBaseDao {

    private final static String tablename = "HbaseDataDao";

    private TSDB tsdb;
    private UUID uuid;
    private Map<String, String> tags = new HashMap<String, String>();
    private DataPoints dataPoints; 

    public HbaseDataDao() {
        super(tablename);

//        this.uuid = uuid;
        try {
            Config openTsdbConfig = new net.opentsdb.utils.Config(true);
            openTsdbConfig.overrideConfig("tsd.core.auto_create_metrics", String.valueOf(false));
            openTsdbConfig.overrideConfig("tsd.storage.hbase.data_table", String.valueOf("test_tsdb"));
            openTsdbConfig.overrideConfig("tsd.storage.hbase.uid_table", String.valueOf("test_tsdb-uid"));
            this.tsdb = new TSDB(
                    this.client,
                    openTsdbConfig);
        } catch (IOException ex) {
            Logger.getLogger(HbaseDataDao.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public Iterator<DataPoint> getDatabyQuery(String query) {

        Query q = this.tsdb.newQuery();
//        tags.put("cluster", "*");
        tags.put("host", "app00.raffle.int");
        q.setTimeSeries("cpu_user", tags, Aggregators.AVG, false);        

        q.setStartTime(System.currentTimeMillis()/1000-1);
        q.setEndTime(System.currentTimeMillis()/1000);
        //no group_bys for now 
        dataPoints = q.run()[0];

        return dataPoints.iterator();

    }

}
