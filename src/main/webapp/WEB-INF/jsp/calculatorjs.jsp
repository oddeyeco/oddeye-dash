<script type="text/javascript">
    var calc = {
        system_check: {text: "System Checks", childs: {
                check_cpustats: {count: 8, type: 'multi', inclass: "checked", isbegin: true, text: "CPUstats", hasAll: true, multiText: "Core Count", allText: "Use all cores", src: '/OddeyeCoconut/assets/images/integration/Cpu.png', text2: "It reads /proc/stat file for CPU related information.", name: "CPU Check"},
                check_memory: {count: 8, type: 'single', inclass: "checked", isbegin: true, text: "Memory", src: '/OddeyeCoconut/assets/images/integration/Ram.png', text2: "It takes memory related information from /proc/meminfo file.", name: "Memory Check"},
                check_drives: {count: 3, type: 'multi', inclass: "checked", isbegin: true, text: "Disks", multiText: "Disks Count", src: '/OddeyeCoconut/assets/images/integration/Disk.png', text2: "Provide statistics about disk IO.", name: "Drive Check"},
                check_partitions: {count: 3, type: 'multi', inclass: "checked", isbegin: true, text: "Disks", multiText: "Partitions Count", src: '/OddeyeCoconut/assets/images/integration/Disk.png', text2: "Provide statistics about partitions Space usage.", name: "Partition Check"},
                check_network_bytes: {count: 2, type: 'multi', text: "Network bytes", inclass: "checked", isbegin: true, multiText: "Network Interface Count", src: '/OddeyeCoconut/assets/images/integration/Network.png', text2: " It collects metrics about all installed interfaces.", name: "Network"},
                check_ipconntrack: {count: 2, type: 'single', text: "IPConntrack", src: '/OddeyeCoconut/assets/images/integration/ip.png', text2: "It reads /proc/sys/net/ipv4/netfilter/ip_conntrack_max|ip_conntrack_count files and provides.", name: "IP Conntrack"},
                check_load_average: {count: 3, type: 'single', text: "Load average", src: '/OddeyeCoconut/assets/images/integration/Load.png', text2: "System load average shows ammount of processes. ", name: "Load Average"},
                check_tcp: {count: 13, type: 'single', text: "Tcp", src: '/OddeyeCoconut/assets/images/integration/TCP.png', text2: "This check provides status of TCP connections to systems. It parses /proc/net/tcp.", name: "TCP Connections"},
                check_btrfs: {count: 4, type: 'single', text: "BTRFS", src: '/OddeyeCoconut/assets/images/integration/btrfs.png', text2: "BTRFS file system internal stats and error reporting.", name: "BTRFS Check"}
            }},
        webservers_check: {text: "Web Servers", childs: {
                check_apache: {count: 7, type: 'single', text: "Apache", src: '/OddeyeCoconut/assets/images/integration/apache.png', text2: "Apache HTTPD worlds the most popular web server.", name: "Apache"},
                check_nginx: {count: 7, type: 'single', text: "Nginx", src: '/OddeyeCoconut/assets/images/integration/Nginx.png', text2: "NginX fast and reliable web server, proxy cache.", name: "NginX"},
                check_haproxy: {count: 2, type: 'single', text: "Haproxy", src: '/OddeyeCoconut/assets/images/integration/haproxy.png', text2: "Reliable and High Performance Load Balancer.", name: "HAProxy"},
                check_phpfpm: {count: 7, type: 'single', text: "PHPFPM", src: '/OddeyeCoconut/assets/images/integration/phpfpm.png', text2: "Alternative PHP FastCGI with built in process manager.", name: "PHP-FPM"},
                check_tomcat: {count: 14, type: 'single', text: "Tomcat", src: '/OddeyeCoconut/assets/images/integration/ApacheTomcat.png', text2: "Popular Servlet Engine and Http Server from Apache.", name: "Apache Tomcat"},
                check_jetty: {count: 25, type: 'single', text: "Jetty", src: '/OddeyeCoconut/assets/images/integration/jetty.png', text2: "Reliable and High Performance Load Balancer.", name: "Jetty"},
                check_lighttpd: {count: 7, type: 'single', text: "LigHTTPD", src: '/OddeyeCoconut/assets/images/integration/light_logo.png', text2: "Security and speed optimized, light web server .", name: "Lighttpd"},
                check_http_api: {count: 2, type: 'single', text: "HTTP API", src: '/OddeyeCoconut/assets/images/integration/http.png', text2: "Simple HTTP api server's performance test script.", name: "HTTP API"}

            }},
        bigdata_check: {text: "Big Data", childs: {
                check_elasticsearch1x: {count: 25, type: 'single', text: "Elasticsearch1X", src: '/OddeyeCoconut/assets/images/integration/elastic.png', text2: "Distributed, RESTful search and analytics engine.", name: "Elasticsearch 1.x"},
                check_elasticsearch2x5: {count: 4, type: 'single', text: "Elasticsearch2X5", src: '/OddeyeCoconut/assets/images/integration/elastic.png', text2: "Distributed, RESTful search and analytics engine.", name: "Elasticsearch 2.x-5.x"},
                check_solr: {count: 4, type: 'single', text: "Solr", src: '/OddeyeCoconut/assets/images/integration/Solr.png', text2: "Blaming fast and reliable serch engine written in Java.", name: "Solr"},
                check_cassandra: {count: 23, type: 'single', text: "Cassandra", src: '/OddeyeCoconut/assets/images/integration/cassandra.png', text2: "Distributed wide column store from Apache foundation.", name: "Cassandra"},
                check_cassandra3: {count: 6, type: 'single', text: "Cassandra3", src: '/OddeyeCoconut/assets/images/integration/cassandra.png', text2: "Distributed wide column store from Apache foundation.", name: "Cassandra 3"},
                check_ceph: {count: 7, type: 'single', text: "Ceph", src: '/OddeyeCoconut/assets/images/integration/ceph.png', text2: "Distributed and fault tolerant file system, blob storage.", name: "Ceph"},
                check_spark_master: {count: 5, type: 'single', text: "Spark master", src: '/OddeyeCoconut/assets/images/integration/Spark.png', text2: "Fast and general engine for big data processing.", name: "Spark Master"},
                check_spark_worker: {count: 6, type: 'single', text: "Spark worker", src: '/OddeyeCoconut/assets/images/integration/Spark.png', text2: "Fast and general engine for big data processing.", name: "Spark Worker"},
                check_storm_api: {count: 12, type: 'single', text: "Storm Api", src: '/OddeyeCoconut/assets/images/integration/Storm.png', text2: "Distributed stream processing engine from Apache.", name: "Storm Api"},
                check_storm_workers: {count: 12, type: 'single', text: "Storm Workers", src: '/OddeyeCoconut/assets/images/integration/Storm.png', text2: "Distributed stream processing engine from Apache.", name: "Storm Workers"},
                check_mesos_master: {count: 27, type: 'single', text: "Mesos master", src: '/OddeyeCoconut/assets/images/integration/Mesos.png', text2: "Didtributed systems resource management framework.", name: "Mesos Master"},
                check_mesos_slave: {count: 21, type: 'single', text: "Mesos slave", src: '/OddeyeCoconut/assets/images/integration/Mesos.png', text2: "Didtributed systems resource management framework.", name: "Mesos Slave"}


            }},
        java_check: {text: "Java", childs: {
                check_jmx: {count: 4, type: 'single', text: "JMX", src: '/OddeyeCoconut/assets/images/integration/jmx.png', text2: "JMX over HTTP via Java attach api and Jolokia agent.", name: "JMX"},
                check_jolokia: {count: 15, type: 'single', text: "Jolokia", src: '/OddeyeCoconut/assets/images/integration/jolokia.png', text2: "HTTP proxy bridge for common access to Java JMX.", name: "Jolokia"}

            }},
        messagequeue_check: {text: "Message Queue", childs: {
                check_kafka: {count: 27, type: 'single', text: "Kafka", src: '/OddeyeCoconut/assets/images/integration/Kafka.png', text2: "Distributed message queue and streaming platform.", name: "Kafka"},
                check_rabbitmq: {count: 12, type: 'multi', text: "rabbitMQ", multiText: "Q Details Count", src: '/OddeyeCoconut/assets/images/integration/RabbitMQ.png', text2: "High performance pub/sub message broker service.", name: "RabbitMQ"},
                check_rabbitmq_368: {count: 12, type: 'multi', text: "rabbitmq_368", multiText: "368Q Details Count", src: '/OddeyeCoconut/assets/images/integration/RabbitMQ.png', text2: "High performance pub/sub message broker service.", name: "RabbitMQ_368"},
                check_activemq: {count: 2, type: 'single', text: "ActiveMQ", src: '/OddeyeCoconut/assets/images/integration/ActiveMQ.png', text2: "An open source message broker written in Java.", name: "ActiveMQ"}
            }},
        sqlcache_check: {text: "SQL,Cache", childs: {
                check_mysql: {count: 24, type: 'single', text: "MySQL", src: '/OddeyeCoconut/assets/images/integration/MySQL.png', text2: "Open-source relational database management system .", name: "MySQL"},
                check_redis: {count: 17, type: 'single', text: "Redis", src: '/OddeyeCoconut/assets/images/integration/Redis.png', text2: "Open source in-memory data structure store.", name: "Redis"},
                check_memcached: {count: 16, type: 'single', text: "Memcached", src: '/OddeyeCoconut/assets/images/integration/Memcached.png', text2: "General-purpose open-source memory caching system.", name: "Memcached"},
                check_mongodb: {count: 3, type: 'single', text: "MongoDB", src: '/OddeyeCoconut/assets/images/integration/mongoDB.png', text2: "Free and open-source document-oriented database.", name: "MongoDB"}

            }},
        hadoop_check: {text: "Hadoop", childs: {
                check_hadoop_datanode: {count: 18, type: 'single', text: "Hadoop datanode", src: '/OddeyeCoconut/assets/images/integration/hadoophdfs.png', text2: "Distributed storage engine for Hadoop ecosystem.", name: "Hadoop datanode"},
                check_hadoop_namenode: {count: 26, type: 'single', text: "Hadoop namenode", src: '/OddeyeCoconut/assets/images/integration/hadoophdfs.png', text2: "Distributed storage engine for Hadoop ecosystem.", name: "Hadoop namenode"},
                check_hbase_master: {count: 7, type: 'single', text: "HBase master", src: '/OddeyeCoconut/assets/images/integration/hbase.png', text2: "Distributed real time database engine on top of HDFS.", name: "HBase Master"},
                check_hbase_regionserver: {count: 32, type: 'single', text: "HBase regionserver", src: '/OddeyeCoconut/assets/images/integration/hbase.png', text2: "Distributed real time database engine on top of HDFS.", name: "HBase Regionserver"},
                check_hbase_rest: {count: 10, type: 'single', text: "HBase rest", src: '/OddeyeCoconut/assets/images/integration/hbaserest.png', text2: "HTTP gateway and proxy service for accessing HBase .", name: "HBase Rest"},
                check_hbase_thrift: {count: 1, type: 'single', text: "HBase thrift", src: '/OddeyeCoconut/assets/images/integration/hbasetrift.png', text2: "Multi language gateway and proxy service for HBase .", name: "HBase Thrift"},
                check_zookeeper: {count: 11, type: 'single', text: "Zookeeper", src: '/OddeyeCoconut/assets/images/integration/Zookeeper.png', text2: "Distributed lock manager and cluster coordinator.", name: "Zookeeper"}
            }},
        docstorage_check: {text: "Document Storage", childs: {
                check_couchbase: {count: 8, type: 'single', text: "Couchbase", src: '/OddeyeCoconut/assets/images/integration/Couchbase.png', text2: "Distributed cache and document-oriented database.", name: "Couchbase"},
                check_couchdb: {count: 9, type: 'single', text: "CouchDB", src: '/OddeyeCoconut/assets/images/integration/CouchDB.png', text2: "RSTfull document-oriented database from Apache.", name: "CouchDB"},
                check_riak: {count: 2, type: 'single', text: "Riak", src: '/OddeyeCoconut/assets/images/integration/Riak.png', text2: "Distribute and high available NoSQL database.", name: "Riak"}
            }},
        other_check: {text: "Other", childs: {
                check_docker_stats: {count: 2, type: 'multi', text: "Docker stats", multiText: "Docker Container Count", src: '/OddeyeCoconut/assets/images/integration/docker-logo.gif', text2: "Monitor Docker containers resources utilization.", name: "Docker"},
                check_oddeye: {count: 1, type: 'single', inclass: "checked", isbegin: true, text: "OddEye", src: '/OddeyeCoconut/assets/images/logo.png', text2: "Its monitors BTRFS volumes and checks for volume errors.", name: "OddEye"},
                check_snmp: {count: 3, type: 'multi', text: "SNMP", multiText: "SNMP Device Count", src: '/OddeyeCoconut/assets/images/integration/snmp.png', text2: "Collect metrics from devices via SNMP protocol.", name: "SNMP"},
                check_nagios: {count: 3, type: 'multi', text: "SNMP", multiText: "SNMP Device Count", src: '/OddeyeCoconut/assets/images/integration/nagios.png', text2: "Use existing Nagios plugins to send alerts to OddEye.", name: "Nagios Checks"},
                check_custom: {count: 1, type: 'multi', text: "Custom", multiText: "Custom check metrics count", src: '/OddeyeCoconut/assets/images/integration/custom.png', text2: "Your custom checks.", name: "Custom Checks"}
            }}
    };
    var metricprice = 8.73042583962e-07;
    var pp = 0;
    var pf = 0;
    $.getJSON(cp + '/getpayinfo', function (data) {
        metricprice = data.mp;
        pp = data.pp;
        pf = data.pf;
    });
    var paint = function () {
        for (var key in calc) {
            $('.tab-content').append('<div class="tab-pane " id="' + key + '"></div>');
            var _class = "tab";
            if (key === "system_check")
            {
                var _class = "active";
            }
            ;
            $('.tabs-left').append('<li id="tab_' + key + '" class="' + _class + '"><a href="#' + key + '" data-toggle="tab">' + calc[key].text + ' (<span class="selectedcount">0</span>)</a></li>');
            for (var t in calc[key].childs) {
                $('#' + key).append('<div class="animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12" ><div class="integration tile-stats" id="' + t + '"><span class="icon"><img alt="" src="' + calc[key].childs[t]['src'] + '"></span><h3>' + calc[key].childs[t]['name'] + '</h3><p>' + calc[key].childs[t]['text2'] + '</p></div></div>');
                $('#' + t).addClass(calc[key].childs[t]['inclass']);
            }
            $('#tab_' + key + " .selectedcount").text($('#' + key + ' .checked').length + "/" + $('#' + key + ' .integration').length);
            ;
        }
        ;
    };
    var instance_id = 0;
    $('body').on('click', '#apply', function () {
        var sinstance_id = 'check_' + instance_id;
        $("#hostcheck").append('<div class="hostcheck calc x_panel" id="' + sinstance_id + '"> <div class="x_title"><h2>Instance #' + (instance_id + 1) + '</h2><ul class="nav navbar-right panel_toolbox"><li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li><li><a class="close-link"><i class="fa fa-close"></i></a></li></ul><div class="clearfix"></div></div> <div  class="x_content"><div  class="row"><div  class="col-xs-3 col-lg-2 "><form><label>Host Count</label><input class="host form-control" type="number" value="1"><label>Check Interval(sec.)</label><input class="sec form-control" type="number" value="10"><form></div><div class="check col-xs-9 col-lg-10"></div></div></div></div>');
        $(".checked").each(function () {
            var id = $(this).attr("id");
            if (id)
            {
                var parent = $(this).parent().parent().attr("id");
                if (calc[parent].childs[id]['type'] === 'multi') {
                    if (calc[parent].childs[id]['hasAll']) {
                        $("#" + sinstance_id + " .check").append('<div class="animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12" ><div class="integration_select tile-stats" calcparent="' + parent + '" calcid="' + id + '"><ul class="nav navbar-right panel_toolbox"><li><a class="del-link"><i class="fa fa-close"></i></a></li></ul><span class="icon"><img alt="" src="' + calc[parent].childs[id]['src'] + '"></span><h3>' + calc[parent].childs[id]['name'] + '</h3><form><label class="col-xs-9">' + calc[parent].childs[id]['multiText'] + '</label> <div class="col-xs-8"><input type="number" min="1" class="multi form-control" value="1"  ></div><div class="col-xs-8 check-wraper"><input type="checkbox" class="checkbox ' + id + '" checked> ' + calc[parent].childs[id]['allText'] + '</div></form></div></div>');
                        $('#' + sinstance_id + ' .check input.checkbox.' + id).on('ifChanged', function () {
                            doprice($(this).parents(".hostcheck"));
                        }).iCheck({
                            checkboxClass: 'icheckbox_flat-green',
                            radioClass: 'iradio_flat-green'
                        });
                    } else {
                        $("#" + sinstance_id + " .check").append('<div class="animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12" ><div class="integration_select tile-stats" calcparent="' + parent + '" calcid="' + id + '"><ul class="nav navbar-right panel_toolbox"><li><a class="del-link"><i class="fa fa-close"></i></a></li></ul><span class="icon"><img alt="" src="' + calc[parent].childs[id]['src'] + '"></span><h3>' + calc[parent].childs[id]['name'] + '</h3><form><label class="col-xs-9">' + calc[parent].childs[id]['multiText'] + '</label><div class="col-xs-8"><input type="number" min="1" class="multi form-control" value="1"  ></div></form></div></div>');
                    }

                } else {
                    $("#" + sinstance_id + " .check").append('<div class="animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12" ><div class="integration_select tile-stats" calcparent="' + parent + '" calcid="' + id + '"><ul class="nav navbar-right panel_toolbox"><li><a class="del-link"><i class="fa fa-close"></i></a></li></ul><span class="icon"><img alt="" src="' + calc[parent].childs[id]['src'] + '"></span><h3>' + calc[parent].childs[id]['name'] + '</h3><p>' + calc[parent].childs[id]['text2'] + '</p></div></div>');
//                    $("#" + instance_id + " .check").append('<div class="integration_select" calcparent="' + parent + '" calcid="' + id + '"><span class="intclose"><i class="fa fa-times" aria-hidden="true"></i></span><span><img alt="" src="' + calc[parent].childs[id]['src'] + '">' + calc[parent].childs[id]['name'] + '</span><p class="for_integration">' + calc[parent].childs[id]['text'] + '</p>');
                }
            }
        });
        $("#" + sinstance_id + " .x_content").after('<div><button  class="calc_button clone " >Clone</button><div class="totalPrice"> <label>Instance price</label> <span class ="total"></span><span class ="totalusd">~</span>');
        $('#fullprice table tbody').append('<tr id="tr_' + instance_id + '"><th><a href="#' + sinstance_id + '"> #' + (instance_id + 1) + '</a></th><td class="unit">0</td><td class="usd">0</td></tr>');
        doprice($("#" + sinstance_id));
        instance_id++;
    });
    $('body').on('click', '.integration', function () {
        $(this).toggleClass('checked');
        var key = $(this).parents('.tab-pane').attr("id");

        if ($(this).attr('value'))
        {
            $("#" + $(this).attr('value')).toggleClass('checked');
            key = $("#" + $(this).attr('value')).parents('.tab-pane').attr("id");
        }                
        $('#tab_' + key + ' .selectedcount').text($('#'+key + ' .checked').length + "/" + $('#'+key + ' .integration').length);

    });
    $('body').on('click', '#reset', function () {
        $('.integration').removeClass('checked');
        $('.tabs-left li').each(function () {
            var key = $(this).find('a').attr('href');
            $(this).find('.selectedcount').text($(key + ' .checked').length + "/" + $(key + ' .integration').length);
//            console.log(key);
        });
    });
    $('body').on('click', '.x_title .close-link', function () {
        var id = $(this).parents('.hostcheck').attr('id');
        id = id.replace('check_', 'tr_');
        $(this).parents('.hostcheck').remove();
        $('#fullprice table tbody #' + id).remove();
        doprice(false);
    });
    $('body').on('click', '.hostcheck .fa-chevron-up', function () {
        $(this).removeClass('fa-chevron-up');
        $(this).addClass('fa-chevron-down');
        $(this).parents('.hostcheck').find('.x_content').hide();
    });
    $('body').on('click', '.hostcheck .fa-chevron-down', function () {
        $(this).removeClass('fa-chevron-down');
        $(this).addClass('fa-chevron-up');
        $(this).parents('.hostcheck').find('.x_content').show();
    });
    $('body').on('click', '.clone', function () {
        var sinstance_id = 'check_' + instance_id;
        var clone = $(this).parents('.hostcheck').clone();
        clone.attr("id", sinstance_id);
        clone.find("h2").text('Instanse #' + (instance_id + 1));
        $('#fullprice table tbody').append('<tr id="tr_' + instance_id + '"><th><a href="#' + sinstance_id + '"> #' + (instance_id + 1) + '</a></th><td class="unit">0</td><td class="usd">0</td></tr>');
        $("#hostcheck").append(clone);
        clone.find('ins.iCheck-helper').remove();
        clone.find('input.checkbox').on('ifChanged', function () {
            doprice($(this).parents(".hostcheck"));
        }).iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });
        doprice(clone);
        instance_id++;
    });
    $('body').on('click', '.del-link', function () {
        var that = $(this).parents(".hostcheck");
        $(this).parents('.flipInY').remove();
        doprice(that);
    });
    $('body').on('input', '.hostcheck input', function () {
        var elem = $(this);
        clearTimeout(whaittimer);
        var whaittimer = setTimeout(function () {
            doprice(elem.parents(".hostcheck"));
        }, 500);
    });
    var whaittimer;
    $('body').on('change keyup paste ', '.search-query', function () {
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
    $('body').on('change', '.checkbox', function () {
        doprice($(this).parents(".hostcheck"));
    });
    function search(value) {
        $('#search_check').html('');
        var testx = $("#tab-items").html();
        const regex = new RegExp('<div([^>\/]+)class="integration([^>\/]+)>((?!<\/div>).)*' + value + '((?!<div).)*(\<(\/?[^>]+)div>)', 'ig');
        var Wrap = "<div class='animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12'>";
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
            item.wrap(Wrap);
        }
    }


    function doprice(contener) {
        var applysum = 0;
        if (contener)
        {
            contener.find(".integration_select").each(function () {
//            var applysum = 0;
                var sum = 0;
                var id = $(this).attr('calcid');
                var parent = $(this).attr('calcparent');
                if (calc[parent].childs[id]['type'] === 'multi') {
                    if (typeof (calc[parent].childs[id]['hasAll']) === "undefined")
                    {
                        sum = (calc[parent].childs[id]['count']) * (Number.parseFloat($(this).find('.multi').val()));
                    } else
                    {
                        if ($(this).find('.checkbox').prop('checked')) {
                            sum = (calc[parent].childs[id]['count']) * (Number.parseFloat($(this).find('.multi').val()) + 1);
                        } else {
                            sum = calc[parent].childs[id]['count'];
                        }
                    }
                    applysum = applysum + sum;
                } else {
                    sum = calc[parent].childs[id]['count'];
                    applysum = applysum + sum;
                }

            });
            var price = (contener.find('.host').val() * ((60 * 60 * 24 * 30) / contener.find('.sec').val()) * applysum * metricprice);
            contener.find('.total').html(price.toFixed(2) + " Units");
            contener.find('.totalusd').html('~' + (price + price * pp / 100 + pf).toFixed(2) + " USD");
            var id = contener.attr('id');
            id = id.replace('check_', 'tr_');
            $('#fullprice table tbody #' + id + ' td.unit').attr("value", price);
            $('#fullprice table tbody #' + id + ' td.unit').html(price.toFixed(2));
            $('#fullprice table tbody #' + id + ' td.usd').attr("value", price + price * pp / 100 + pf);
            $('#fullprice table tbody #' + id + ' td.usd').html((price + price * pp / 100 + pf).toFixed(2));
        }
        var sum = 0;
        var sumusd = 0;
        $('#fullprice table tbody td.unit').each(function () {
            sum = sum + parseFloat($(this).attr('value'));
            sumusd = sumusd + parseFloat($(this).next('.usd').attr('value'));
        });
        $('#fullprice table tfoot #total td.unit').html(sum.toFixed(2));
        $('#fullprice table tfoot #total td.usd').html((sum + sum * pp / 100 + pf).toFixed(2));
        $('#fullprice table tfoot #usdsave td.usd').html((sumusd - (sum + sum * pp / 100 + pf)).toFixed(2));
    }
    ;
    $(document).ready(function () {
        paint();
        $('#system_check').addClass('active');
    });
    $(document).on('scroll', function () {
        if ($(document).scrollTop() >= $('#maincontener').offset().top) {
            if (!$('#fullprice').hasClass("fixed"))
            {
                $('#fullprice').addClass("fixed");
            }
        } else
        {

            if ($('#fullprice').hasClass("fixed"))
            {
                $('#fullprice').removeClass("fixed");
            }
        }
    });
</script>