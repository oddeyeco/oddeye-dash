<script type="text/javascript">
    var checs = {
        check_activemq: {count: 2, type: 'single', text: "ActiveMQ"},
        check_apache: {count: 7, type: 'single', text: "Apache"},
//    check_btrfs: {count: 4, type: 'single', text: "BTRFS"},
        check_cassandra: {count: 23, type: 'single', text: "Cassandra"},
        check_cassandra3: {count: 6, type: 'single', text: "Cassandra3"},
        check_ceph: {count: 7, type: 'single', text: "Ceph"},
        check_couchbase: {count: 8, type: 'single', text: "Couchbase"},
        check_couchdb: {count: 9, type: 'single', text: "CouchDB"},
        check_cpustats: {count: 8, type: 'multi', isbegin: true, text: "CPUstats", hasAll: true, multiText: "Core Count"},
        check_disks: {count: 6, type: 'multi', isbegin: true, text: "Disks", multiText: "Disks Count"},
        check_docker_stats: {count: 2, type: 'multi', text: "Docker stats", multiText: "Docker Container Count"},
        check_elasticsearch1x: {count: 25, type: 'single', text: "Elasticsearch1X"},
        check_elasticsearch2x5: {count: 4, type: 'single', text: "Elasticsearch2X5"},
        check_hadoop_datanode: {count: 18, type: 'single', text: "Hadoop datanode"},
        check_hadoop_namenode: {count: 26, type: 'single', text: "Hadoop namenode"},
        check_haproxy: {count: 2, type: 'single', text: "Haproxy"},
        check_hbase_master: {count: 7, type: 'single', text: "HBase master"},
        check_hbase_regionserver: {count: 32, type: 'single', text: "HBase regionserver"},
        check_hbase_rest: {count: 10, type: 'single', text: "HBase rest"},
        check_hbase_thrift: {count: 1, type: 'single', text: "HBase thrift"},
//    check_http_api: {count: 2, type: 'single', text: "HTTP API"},
        check_ipconntrack: {count: 2, type: 'single', text: "IPConntrack"},
        check_jmx: {count: 4, type: 'single', text: "JMX"},
        check_jolokia: {count: 15, type: 'single', text: "Jolokia"},
        check_kafka: {count: 27, type: 'single', text: "Kafka"},
        check_lighttpd: {count: 7, type: 'single', text: "LigHTTPD"},
        check_load_average: {count: 3, type: 'single', text: "Load average"},
        check_memcached: {count: 16, type: 'single', text: "Memcached"},
        check_memory: {count: 8, type: 'single', isbegin: true, text: "Memory"},
        check_mesos_master: {count: 27, type: 'single', text: "Mesos master"},
        check_mesos_slave: {count: 21, type: 'single', text: "Mesos slave"},
        check_mongodb: {count: 3, type: 'single', text: "MongoDB"},
        check_mysql: {count: 24, type: 'single', text: "MySQL"},
        check_network_bytes: {count: 2, type: 'multi', text: "Network bytes", isbegin: true, multiText: "Network Interface Count"},
        check_nginx: {count: 7, type: 'single', text: "Nginx"},
        check_oddeye: {count: 1, type: 'single', isbegin: true, text: "OddEye"},
        check_phpfpm: {count: 7, type: 'single', text: "PHPFPM"},
        check_rabbitmq: {count: 12, type: 'multi', text: "rabbitMQ", multiText: "Q Details Count"},
        check_rabbitmq_368: {count: 12, type: 'multi', text: "rabbitmq_368", multiText: "368Q Details Count"},
        check_redis: {count: 17, type: 'single', text: "Redis"},
        check_riak: {count: 2, type: 'single', text: "Riak"},
        check_snmp: {count: 3, type: 'multi', text: "SNMP", multiText: "SNMP Device Count"},
        check_solr: {count: 4, type: 'single', text: "Solr"},
        check_spark_master: {count: 5, type: 'single', text: "Spark master"},
        check_spark_worker: {count: 6, type: 'single', text: "Spark worker"},
        check_storm_workers: {count: 12, type: 'single', text: "Storm workers"},
        check_tcpconn: {count: 8, type: 'single', text: "TCPconn"},
        check_tomcat: {count: 14, type: 'single', text: "Tomcat"},
        check_zookeeper: {count: 11, type: 'single', text: "Zookeeper"},
        check_jetty: {count: 25, type: 'single', text: "Jetty"}
    };

//(60/seconds)*60*24*30*(hostcount)*(check1count+check2count)*metricprice

    var metricprice = 8.73042583962e-07;
    var checkboxElem;


</script>