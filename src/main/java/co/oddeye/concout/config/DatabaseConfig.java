/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import co.oddeye.concout.dao.BaseTsdbConnect;
import co.oddeye.concout.dao.HbaseDataDao;
import co.oddeye.concout.dao.HbaseDushboardTemplateDAO;
import co.oddeye.concout.dao.HbaseErrorHistoryDao;
import co.oddeye.concout.dao.HbaseErrorsDao;
import co.oddeye.concout.dao.HbaseMetaDao;
import co.oddeye.concout.dao.HbaseUserDao;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;

/**
 *
 * @author vahan
 */
@Configuration
@PropertySource("file:/etc/oddeye/dash.properties")
public class DatabaseConfig {

    @Value("${hbase.zookeeper.quorum}")
    private String hbaseQuorum;

    @Value("${hbase.rpcs.batch.size}")
    private String hbaseBatchSize;
    @Value("${tsd.core.auto_create_metrics}")
    private String tsdbAutoCreateMetrics;
    @Value("${tsd.storage.enable_compaction}")
    private String tsdbEnableCompaction;
    @Value("${tsd.storage.hbase.data_table}")
    private String tsdbDataTable;
    @Value("${tsd.storage.hbase.uid_table}")
    private String tsdbUidTable;
    @Value("${dash.userrtable}")
    private String usersTable;
    @Value("${dash.dushboardstable}")
    private String dushboardsTable;
    @Value("${dash.dushboardstemplatestable}")
    private String dushboardsTemplatesTable;
    @Value("${dash.errorhistorytable}")
    private String errorHistoryTable;
    @Value("${dash.errorslasttable}")
    private String errorsLastTable;
    @Value("${dash.errorstable}")
    private String errorsTable;
    @Value("${dash.metatable}")
    private String metaTable;
    @Value("${dash.consumptiontable}")
    private String consumptiontable;
    @Value("${dash.payments}")
    private String paymentstable;    

    
    @Bean
    public BaseTsdbConnect BaseTsdb() {
        return new BaseTsdbConnect(this);
    }

    @Bean
    public HbaseUserDao Userdao() {
        return new HbaseUserDao(this);
    }

    @Bean
    public HbaseDataDao DataDao() {
        return new HbaseDataDao(this);
    }

    @Bean
    public HbaseDushboardTemplateDAO TemplateDAO() {
        return new HbaseDushboardTemplateDAO(this);
    }

    public HbaseErrorHistoryDao ErrorHistoryDao() {
        return new HbaseErrorHistoryDao(this);
    }

    public HbaseErrorsDao ErrorDao() {
        return new HbaseErrorsDao(this);
    }

    public HbaseMetaDao MetaDao() {
        return new HbaseMetaDao(this);
    }
    
    

    @Bean
    public static PropertySourcesPlaceholderConfigurer
            propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    /**
     * @return the hbaseQuorum
     */
    public String getHbaseQuorum() {
        return hbaseQuorum;
    }

    /**
     * @return the hbaseBatchSize
     */
    public String getHbaseBatchSize() {
        return hbaseBatchSize;
    }

    /**
     * @return the tsdbAutoCreateMetrics
     */
    public String getTsdbAutoCreateMetrics() {
        return tsdbAutoCreateMetrics;
    }

    /**
     * @return the tsdbEnableCompaction
     */
    public String getTsdbEnableCompaction() {
        return tsdbEnableCompaction;
    }

    /**
     * @return the tsdbDataTable
     */
    public String getTsdbDataTable() {
        return tsdbDataTable;
    }

    /**
     * @return the tsdbUidTable
     */
    public String getTsdbUidTable() {
        return tsdbUidTable;
    }

    /**
     * @return the usersTable
     */
    public String getUsersTable() {
        return usersTable;
    }

    /**
     * @return the dashTable
     */
    public String getDashTable() {
        return getDushboardsTable();
    }

    /**
     * @return the dushboardsTable
     */
    public String getDushboardsTable() {
        return dushboardsTable;
    }

    /**
     * @return the dushboardsTemplatesTable
     */
    public String getDushboardsTemplatesTable() {
        return dushboardsTemplatesTable;
    }

    /**
     * @return the errorHistoryTable
     */
    public String getErrorHistoryTable() {
        return errorHistoryTable;
    }

    /**
     * @return the errorsLastTable
     */
    public String getErrorsLastTable() {
        return errorsLastTable;
    }

    /**
     * @return the errorsTable
     */
    public String getErrorsTable() {
        return errorsTable;
    }

    /**
     * @return the metaTable
     */
    public String getMetaTable() {
        return metaTable;
    }

    /**
     * @return the consumptiontable
     */
    public String getConsumptiontable() {
        return consumptiontable;
    }

    /**
     * @return the paymentstable
     */
    public String getPaymentstable() {
        return paymentstable;
    }

}
