<script type="text/javascript">
    var checs = {
//        check_activemq: {count: 2, type: 'single', text: "ActiveMQ"},
//        check_apache: {count: 7, type: 'single', text: "Apache"},
//    check_btrfs: {count: 4, type: 'single', text: "BTRFS"},
//        check_cassandra: {count: 23, type: 'single', text: "Cassandra"},
//        check_cassandra3: {count: 6, type: 'single', text: "Cassandra3"},
//        check_ceph: {count: 7, type: 'single', text: "Ceph"},
//        check_couchbase: {count: 8, type: 'single', text: "Couchbase"},
//        check_couchdb: {count: 9, type: 'single', text: "CouchDB"},
//        check_cpustats: {count: 8, type: 'multi', isbegin: true, text: "CPUstats", hasAll: true, multiText: "Core Count"},
//        check_disks: {count: 6, type: 'multi', isbegin: true, text: "Disks", multiText: "Disks Count"},
//        check_docker_stats: {count: 2, type: 'multi', text: "Docker stats", multiText: "Docker Container Count"},
//        check_elasticsearch1x: {count: 25, type: 'single', text: "Elasticsearch1X"},
//        check_elasticsearch2x5: {count: 4, type: 'single', text: "Elasticsearch2X5"},
//        check_hadoop_datanode: {count: 18, type: 'single', text: "Hadoop datanode"},
//        check_hadoop_namenode: {count: 26, type: 'single', text: "Hadoop namenode"},
//        check_haproxy: {count: 2, type: 'single', text: "Haproxy"},
//        check_hbase_master: {count: 7, type: 'single', text: "HBase master"},
//        check_hbase_regionserver: {count: 32, type: 'single', text: "HBase regionserver"},
//        check_hbase_rest: {count: 10, type: 'single', text: "HBase rest"},
//        check_hbase_thrift: {count: 1, type: 'single', text: "HBase thrift"},
//    check_http_api: {count: 2, type: 'single', text: "HTTP API"},
//        check_ipconntrack: {count: 2, type: 'single', text: "IPConntrack"},
//        check_jmx: {count: 4, type: 'single', text: "JMX"},
//        check_jolokia: {count: 15, type: 'single', text: "Jolokia"},
//        check_kafka: {count: 27, type: 'single', text: "Kafka"},
//        check_lighttpd: {count: 7, type: 'single', text: "LigHTTPD"},
//        check_load_average: {count: 3, type: 'single', text: "Load average"},
//        check_memcached: {count: 16, type: 'single', text: "Memcached"},
//        check_memory: {count: 8, type: 'single', isbegin: true, text: "Memory"},
//        check_mesos_master: {count: 27, type: 'single', text: "Mesos master"},
//        check_mesos_slave: {count: 21, type: 'single', text: "Mesos slave"},
//        check_mongodb: {count: 3, type: 'single', text: "MongoDB"},
//        check_mysql: {count: 24, type: 'single', text: "MySQL"},
//        check_network_bytes: {count: 2, type: 'multi', text: "Network bytes", isbegin: true, multiText: "Network Interface Count"},
//        check_nginx: {count: 7, type: 'single', text: "Nginx"},
//        check_oddeye: {count: 1, type: 'single', isbegin: true, text: "OddEye"},
//        check_phpfpm: {count: 7, type: 'single', text: "PHPFPM"},
//        check_rabbitmq: {count: 12, type: 'multi', text: "rabbitMQ", multiText: "Q Details Count"},
//        check_rabbitmq_368: {count: 12, type: 'multi', text: "rabbitmq_368", multiText: "368Q Details Count"},
//        check_redis: {count: 17, type: 'single', text: "Redis"},
//        check_riak: {count: 2, type: 'single', text: "Riak"},
//        check_snmp: {count: 3, type: 'multi', text: "SNMP", multiText: "SNMP Device Count"},
//        check_solr: {count: 4, type: 'single', text: "Solr"},
//        check_spark_master: {count: 5, type: 'single', text: "Spark master"},
//        check_spark_worker: {count: 6, type: 'single', text: "Spark worker"},
//        check_storm_workers: {count: 12, type: 'single', text: "Storm workers"},
//        check_storm_api: {count: 12, type: 'single', text: "Storm workers"},
//        check_tcpconn: {count: 8, type: 'single', text: "TCPconn"},
//        check_tomcat: {count: 14, type: 'single', text: "Tomcat"},
//        check_zookeeper: {count: 11, type: 'single', text: "Zookeeper"},
//        check_jetty: {count: 25, type: 'single', text: "Jetty"},
//        check_tcp: {count: 13, type: 'single', text: "Tcp"}
    };
    
    var calc = {
        system_check: {
            check_cpustats: {count: 8, type: 'multi', inclass: "checked", isbegin: true, text: "CPUstats", hasAll: true, multiText: "Core Count", src: '/OddeyeCoconut/assets/images/integration/Cpu.png', text2: "It reads /proc/stat file for CPU related information.", name: "CPU Check"},
            check_memory: {count: 8, type: 'single', inclass: "checked", isbegin: true, text: "Memory", src: '/OddeyeCoconut/assets/images/integration/Ram.png', text2: "It takes memory related information from /proc/meminfo file.", name: "Memory Check"},
            check_disks: {count: 6, type: 'multi', inclass: "checked", isbegin: true, text: "Disks", multiText: "Disks Count", src: '/OddeyeCoconut/assets/images/integration/Disk.png', text2: "Provide statistics about disk IO and Space usage.", name: "Disk Check"},
            check_network_bytes: {count: 2, type: 'multi', text: "Network bytes", inclass: "checked", isbegin: true, multiText: "Network Interface Count", src: '/OddeyeCoconut/assets/images/integration/Network.png', text2: " It collects metrics about all installed interfaces.", name: "Network"},
            check_ipconntrack: {count: 2, type: 'single', text: "IPConntrack", src: '/OddeyeCoconut/assets/images/integration/ip.png', text2: "It reads /proc/sys/net/ipv4/netfilter/ip_conntrack_max|ip_conntrack_count files and provides.", name: "IP Conntrack"},
            check_load_average: {count: 3, type: 'single', text: "Load average", src: '/OddeyeCoconut/assets/images/integration/Load.png', text2: "System load average shows ammount of processes. ", name: "Load Average"},
            check_tcp: {count: 13, type: 'single', text: "Tcp", src: '/OddeyeCoconut/assets/images/integration/TCP.png', text2: "This check provides status of TCP connections to systems. It parses /proc/net/tcp.", name: "TCP Connections"},
            check_btrfs: {count: 4, type: 'single', text: "BTRFS", src: '/OddeyeCoconut/assets/images/integration/btrfs.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "BTRFS Check"}
        },
        webservers_check: {
            check_apache: {count: 7, type: 'single', text: "Apache", src: '/OddeyeCoconut/assets/images/integration/apache.png', text2: "Apache is free and open-source cross-platform web server software, released under the terms of Apache License 2.0.", name: "Apache"},
            check_nginx: {count: 7, type: 'single', text: "Nginx", src: '/OddeyeCoconut/assets/images/integration/Nginx.png', text2: "Nginx is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server.", name: "NginX"},
            check_haproxy: {count: 2, type: 'single', text: "Haproxy", src: '/OddeyeCoconut/assets/images/integration/haproxy.png', text2: "HAProxy is a free, reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.", name: "HAProxy"},
            check_phpfpm: {count: 7, type: 'single', text: "PHPFPM", src: '/OddeyeCoconut/assets/images/integration/phpfpm.png', text2: "PHP-FPM is an alternative PHP FastCGI implementation with some additional features useful for sites of any size.", name: "PHP-FPM"},
            check_tomcat: {count: 14, type: 'single', text: "Tomcat", src: '/OddeyeCoconut/assets/images/integration/ApacheTomcat.png', text2: "The Apache Tomcat software is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language  ...", name: "Apache Tomcat"},
            check_jetty: {count: 25, type: 'single', text: "Jetty", src: '/OddeyeCoconut/assets/images/integration/jetty.png', text2: "Jetty provides a Web server and javax.servlet container, plus support for HTTP/2, WebSocket, OSGi, JMX, JNDI ...", name: "Jetty"},
            check_lighttpd: {count: 7, type: 'single', text: "LigHTTPD", src: '/OddeyeCoconut/assets/images/integration/light_logo.png', text2: "Lighttpd is an open-source web server optimized for speed-critical environments while remaining standards-compliant, secure and flexible.", name: "Lighttpd"},
            check_http_api: {count: 2, type: 'single', text: "HTTP API", src: '/OddeyeCoconut/assets/images/integration/http.png', text2: "HTTP is basic check for measuring performance of HTTP API servers.", name: "HTTP API"}

        },
        bigdata_check: {
            check_elasticsearch1x: {count: 25, type: 'single', text: "Elasticsearch1X", src: '/OddeyeCoconut/assets/images/integration/elastic.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Elasticsearch 1.x"},
            check_elasticsearch2x5: {count: 4, type: 'single', text: "Elasticsearch2X5", src: '/OddeyeCoconut/assets/images/integration/elastic.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Elasticsearch 2.x-5.x"},

            check_solr: {count: 4, type: 'single', text: "Solr", src: '/OddeyeCoconut/assets/images/integration/Solr.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Solr"},
            check_cassandra: {count: 23, type: 'single', text: "Cassandra", src: '/OddeyeCoconut/assets/images/integration/cassandra.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Cassandra"},
            check_cassandra3: {count: 6, type: 'single', text: "Cassandra3", src: '/OddeyeCoconut/assets/images/integration/cassandra.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Cassandra 3"},
            check_ceph: {count: 7, type: 'single', text: "Ceph", src: '/OddeyeCoconut/assets/images/integration/ceph.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Ceph"},
            check_spark_master: {count: 5, type: 'single', text: "Spark master", src: '/OddeyeCoconut/assets/images/integration/Spark.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Spark Master"},
            check_spark_worker: {count: 6, type: 'single', text: "Spark worker", src: '/OddeyeCoconut/assets/images/integration/Spark.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Spark Worker"},
            check_storm_api: {count: 12, type: 'single', text: "Storm Api", src: '/OddeyeCoconut/assets/images/integration/Storm.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Storm Api"},
            check_storm_workers: {count: 12, type: 'single', text: "Storm Workers", src: '/OddeyeCoconut/assets/images/integration/Storm.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Storm Workers"},
            check_mesos_master: {count: 27, type: 'single', text: "Mesos master", src: '/OddeyeCoconut/assets/images/integration/Mesos.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Mesos Master"},
            check_mesos_slave: {count: 21, type: 'single', text: "Mesos slave", src: '/OddeyeCoconut/assets/images/integration/Mesos.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Mesos Slave"}


        },
        java_check: {
            check_jmx: {count: 4, type: 'single', text: "JMX", src: '/OddeyeCoconut/assets/images/integration/jmx.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "JMX"},
            check_jolokia: {count: 15, type: 'single', text: "Jolokia", src: '/OddeyeCoconut/assets/images/integration/jolokia.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Jolokia"}

        },
        messagequeue_check: {
            check_kafka: {count: 27, type: 'single', text: "Kafka", src: '/OddeyeCoconut/assets/images/integration/Kafka.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Kafka"},
            check_rabbitmq: {count: 12, type: 'multi', text: "rabbitMQ", multiText: "Q Details Count", src: '/OddeyeCoconut/assets/images/integration/RabbitMQ.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "RabbitMQ"},
            check_rabbitmq_368: {count: 12, type: 'multi', text: "rabbitmq_368", multiText: "368Q Details Count", src: '/OddeyeCoconut/assets/images/integration/RabbitMQ.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "RabbitMQ_368"},
            check_activemq: {count: 2, type: 'single', text: "ActiveMQ", src: '/OddeyeCoconut/assets/images/integration/ActiveMQ.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "ActiveMQ"}
        },
        sqlcache_check: {
            check_mysql: {count: 24, type: 'single', text: "MySQL", src: '/OddeyeCoconut/assets/images/integration/MySQL.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "MySQL"},
            check_redis: {count: 17, type: 'single', text: "Redis", src: '/OddeyeCoconut/assets/images/integration/Redis.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Redis"},
            check_memcached: {count: 16, type: 'single', text: "Memcached", src: '/OddeyeCoconut/assets/images/integration/Memcached.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Memcached"},
            check_mongodb: {count: 3, type: 'single', text: "MongoDB", src: '/OddeyeCoconut/assets/images/integration/mongoDB.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "MongoDB"}

        },

        hadoop_check: {
            check_hadoop_datanode: {count: 18, type: 'single', text: "Hadoop datanode", src: '/OddeyeCoconut/assets/images/integration/hadoophdfs.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Hadoop datanode"},
            check_hadoop_namenode: {count: 26, type: 'single', text: "Hadoop namenode", src: '/OddeyeCoconut/assets/images/integration/hadoophdfs.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Hadoop namenode"},
            check_hbase_master: {count: 7, type: 'single', text: "HBase master", src: '/OddeyeCoconut/assets/images/integration/hbase.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "HBase Master"},
            check_hbase_regionserver: {count: 32, type: 'single', text: "HBase regionserver", src: '/OddeyeCoconut/assets/images/integration/hbase.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "HBase Regionserver"},
            check_hbase_rest: {count: 10, type: 'single', text: "HBase rest", src: '/OddeyeCoconut/assets/images/integration/hbaserest.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "HBase Rest"},
            check_hbase_thrift: {count: 1, type: 'single', text: "HBase thrift", src: '/OddeyeCoconut/assets/images/integration/hbasetrift.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "HBase Thrift"},
            check_zookeeper: {count: 11, type: 'single', text: "Zookeeper", src: '/OddeyeCoconut/assets/images/integration/Zookeeper.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Zookeeper"}
        },
        docstorage_check: {
            check_couchbase: {count: 8, type: 'single', text: "Couchbase", src: '/OddeyeCoconut/assets/images/integration/Couchbase.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Couchbase"},
            check_couchdb: {count: 9, type: 'single', text: "CouchDB", src: '/OddeyeCoconut/assets/images/integration/CouchDB.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "CouchDB"},
            check_riak: {count: 2, type: 'single', text: "Riak", src: '/OddeyeCoconut/assets/images/integration/Riak.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Riak"}
        },
        other_check: {
            check_docker_stats: {count: 2, type: 'multi', text: "Docker stats", multiText: "Docker Container Count", src: '/OddeyeCoconut/assets/images/integration/docker-logo.gif', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Docker"},
            check_oddeye: {count: 1, type: 'single', inclass: "checked", isbegin: true, text: "OddEye", src: '/OddeyeCoconut/assets/images/logo.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "OddEye"},
            check_snmp: {count: 3, type: 'multi', text: "SNMP", multiText: "SNMP Device Count", src: '/OddeyeCoconut/assets/images/integration/snmp.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "SNMP"},
            check_nagios: {count: 3, type: 'multi', text: "SNMP", multiText: "SNMP Device Count", src: '/OddeyeCoconut/assets/images/integration/nagios.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "Nagios Checks"}
        }
    };
    var metricprice = 8.73042583962e-07;


    var paint = function () {
        for (var key in calc) {
            $('.tab-content').append('<div class="tab-pane " id="' + key + '"></div>');
            for (var t in calc[key]) {
                $('#' + key).append('<div class="integration" id="' + t + '"><span><img alt="" src="' + calc[key][t]['src'] + '">' + calc[key][t]['name'] + '</span><p class="for_integration">' + calc[key][t]['text2'] + '</p>');
//                console.log(calc[key][t]['isbegin']);
                $('#' + t).addClass(calc[key][t]['inclass']);

            }
            ;
        }
        ;
    };
    var i = 0;

    $('body').on('click', '#apply', function () {
        $("#hostcheck").append('<div class="hostcheck calc"> <span class="delete"><i class="fa fa-close" aria-hidden="true"></i></span><div  class="col-xs-3 col-lg-2 "><label>Host Count</label><input class="host" type="number" value="1"><label>Check Interval(sec.)</label><input class=sec type="number" value="10"></div><div class="check tab-pane col-xs-9 col-lg-10"></div></div>');
        $(".checked").each(function () {
            var id = $(this).attr("id");
            if (id)
            {
                var parent = $(this).parent().attr("id");
                if (calc[parent][id]['type'] === 'multi') {
                    if (calc[parent][id]['hasAll']) {
//                          alert(t);
                        $(".hostcheck .check").last().append('<div class="integration_select" calcparent="' + parent + '" calcid="' + id + '"><span class="intclose"><i class="fa fa-close" aria-hidden="true"></i></span><span><img alt="" src="' + calc[parent][id]['src'] + '">' + calc[parent][id]['name'] + '</span><div clas="for_integration"><label style="float:left">' + calc[parent][id]['multiText'] + ":All" + '</label> <input type="checkbox" class="checkbox ' + id + '" checked><input type="number" min="1" class="multi" value="1"  ></div>');
                    } else {
                        $(".hostcheck .check").last().append('<div class="integration_select" calcparent="' + parent + '" calcid="' + id + '"><span class="intclose"><i class="fa fa-close" aria-hidden="true"></i></span><span  ><img alt="" src="' + calc[parent][id]['src'] + '">' + calc[parent][id]['name'] + '</span><div clas="for_integration"><label>' + calc[parent][id]['multiText'] + '</label><input type="number" min="1" class="multi" value="1"></div>');
                    }

                } else {
                    $(".hostcheck .check").last().append('<div class="integration_select" calcparent="' + parent + '" calcid="' + id + '"><span class="intclose"><i class="fa fa-times" aria-hidden="true"></i></span><span><img alt="" src="' + calc[parent][id]['src'] + '">' + calc[parent][id]['name'] + '</span><p class="for_integration">' + calc[parent][id]['text'] + '</p>');
                }
            }
        });
        $(".hostcheck .check").last().append('<div style="clear:both"></div><div><button class="calc_button change">Change</button><button  class="calc_button clone " >Clone</button><div> <label>Total Price</label> <span class ="total"></span>');
        $(".hostcheck .check").last().find('.total').html(price($(".hostcheck .check").last().find('.total').parents(".hostcheck")));
    });
    $('body').on('click', '.integration', function () {
        $(this).toggleClass('checked');
        $("#" + $(this).attr('value')).toggleClass('checked');
    });
    $('body').on('click', '#reset', function () {
        $('.integration').removeClass('checked');
    });
    $('body').on('click', '.delete', function () {
        $(this).parents('.hostcheck').remove();

    });
    $('body').on('click', '.clone', function () {
        $(this).parents('.hostcheck').clone().prependTo('#hostcheck');

    });
    $('body').on('click', '.intclose', function () {
        var that = $(this).parents(".hostcheck");
        $(this).parents('.integration_select').remove();
        price(that);
    });
    $('body').on('click', '.change', function () {
        price($(this).parents(".hostcheck"));

    });
    $('body').on('input', 'input', function ( ) {
        var elem = $(this);
        clearTimeout(whaittimer);
        var whaittimer = setTimeout(function () {
            price(elem.parents(".hostcheck"));
        }, 500);
    });
    var whaittimer;
    $('body').on('change keyup paste ', '.search-query', function ( ) {
        clearTimeout(whaittimer);
        whaittimer = setTimeout(function () {
            if ($('.search-query').val()) {
                $('.tab-pane.active').removeClass('active');
                $('.nav-tabs  li.active').removeClass('active');

                if ($('#search_check').length === 0)
                {
                    $('.tab-content').append('<div class="tab-pane active" id="search_check">valod');
                } else
                {
                    $('#search_check').addClass('active');
                }
                search($('.search-query').val());
            } else
            {
                $('.tab-pane').first().addClass('active');
                $('.nav-tabs  li').first().addClass('active');

            }
            ;

        }, 1000);


    });
    $('body').on('change', '.checkbox', function ( ) {
        price($(this).parents(".hostcheck"));
        ;
    });
    function search(value) {
        $('#search_check').html('');
        var testx = $("#tab-items").html();
        const regex = new RegExp('<div([^>\/]+)class="integration([^>\/]+)>((?!<\/div>).)*' + value + '((?!<div).)*(\<(\/?[^>]+)div>)', 'ig');
        let m;
        while ((m = regex.exec(testx)) !== null) {
            // This is necessary to avoid infinite loops with zero-width matches
            if (m.index === regex.lastIndex) {
                regex.lastIndex++;
            }
            var item = $(m[0]);
            item.attr('value', item.attr("id"));
            item.removeAttr("id");
            $('#search_check').append(item);
        }
    }


    function price(contener) {
        var applysum = 0;

        contener.find(".integration_select").each(function () {
//            var applysum = 0;
            var sum = 0;
            var id = $(this).attr('calcid');
            var parent = $(this).attr('calcparent');
            if (calc[parent][id]['type'] === 'multi') {
                if (typeof (calc[parent][id]['hasAll']) == "undefined")
                {
                    sum = (calc[parent][id]['count']) * (Number.parseFloat($(this).find('.multi').val()));
                } else
                {
                    if ($(this).find('.checkbox').prop('checked')) {
                        sum = (calc[parent][id]['count']) * (Number.parseFloat($(this).find('.multi').val()) + 1);
                    } else {
                        sum = calc[parent][id]['count'];

                    }
                }
                applysum = applysum + sum;

            } else {
                sum = calc[parent][id]['count'];
                applysum = applysum + sum;
            }

        });
        var price = (contener.find('.host').val() * ((60 * 60 * 24 * 30) / contener.find('.sec').val()) * applysum * metricprice).toFixed(2);
        contener.find('.total').html(price + " $");



    }
    ;
    $(document).ready(function () {
        paint();
        $('#system_check').addClass('active');
//        console.log(checked);
        

    });




</script>