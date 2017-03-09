/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.core.globalFunctions;
import java.io.IOException;
import javax.annotation.PreDestroy;
import net.opentsdb.core.TSDB;
import net.opentsdb.utils.Config;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import org.springframework.stereotype.Service;

/**
 *
 * @author vahan
 */
@Service
public final class BaseTsdbConnect {

    private org.hbase.async.HBaseClient client;
    private TSDB tsdb;
    protected static final Logger LOGGER = LoggerFactory.getLogger(BaseTsdbConnect.class);

    /*
     */
    public BaseTsdbConnect() {

        String quorum = "nn1.netangels.net:2181,nn2.netangels.net:2181,rm1.netangels.net:2181";
        org.hbase.async.Config clientconf = new org.hbase.async.Config();
        clientconf.overrideConfig("hbase.zookeeper.quorum", quorum);
        clientconf.overrideConfig("hbase.rpcs.batch.size", "2048");

        this.client = new org.hbase.async.HBaseClient(clientconf);
        try {
            Config openTsdbConfig = new net.opentsdb.utils.Config(false);
            openTsdbConfig.overrideConfig("tsd.core.auto_create_metrics", String.valueOf(false));
            openTsdbConfig.overrideConfig("tsd.storage.enable_compaction", String.valueOf(false));
            openTsdbConfig.overrideConfig("tsd.storage.hbase.data_table", String.valueOf("test_tsdb"));
            openTsdbConfig.overrideConfig("tsd.storage.hbase.uid_table", String.valueOf("test_tsdb-uid"));
            this.tsdb = new TSDB(
                    this.getClient(),
                    openTsdbConfig);
        } catch (IOException ex) {
            LOGGER.error("TSDB CONNECT ERROR " + globalFunctions.stackTrace(ex));
        }
    }

    /**
     * @return the client
     */
    public org.hbase.async.HBaseClient getClient() {
        return client;
    }

    /**
     * @return the tsdb
     */
    public TSDB getTsdb() {
        return tsdb;
    }

    @PreDestroy
    public void PreDestroy() {
        try {
            tsdb.shutdown().joinUninterruptibly();
            client.shutdown().joinUninterruptibly();
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }
}
