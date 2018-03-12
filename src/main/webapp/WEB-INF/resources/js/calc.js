/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var calc = {
    system_check: {text: "System Checks", childs: {
            check_oddeye: {count: 2, type: 'single', inclass: "checked", isbegin: true, text: "OddEye", src: '/OddeyeCoconut/assets/images/integration/oddeye.png', name: "OddEye"},
            check_cpustats: {count: 8, type: 'multi', inclass: "checked", isbegin: true, text: "CPUstats", hasAll: true, multiText: "Core Count", allText: "Use all cores", src: '/OddeyeCoconut/assets/images/integration/Cpu.png', name: "CPU"},
            check_memory: {count: 8, type: 'single', inclass: "checked", isbegin: true, text: "Memory", src: '/OddeyeCoconut/assets/images/integration/Ram.png', name: "Memory"},
            check_disks: {count: [3, 3], multiText: ["Mountpoint", "Disks"], type: 'multi', inclass: "checked", isbegin: true, text: "Disks", src: '/OddeyeCoconut/assets/images/integration/Disk.png', name: "Drive"},
//                check_partitions: {count: 3, type: 'multi', inclass: "checked", isbegin: true, text: "Disks", multiText: "Mountpoint Count", src: '/OddeyeCoconut/assets/images/integration/Disk.png', name: "Mountpoint"},
            check_network_bytes: {count: 2, type: 'multi', text: "Network bytes", inclass: "checked", isbegin: true, multiText: "Network Interface Count", src: '/OddeyeCoconut/assets/images/integration/Network.png', name: "Network"},
            check_ipconntrack: {count: 2, type: 'single', text: "IPConntrack", src: '/OddeyeCoconut/assets/images/integration/ip.png', name: "IP Conntrack"},
            check_load_average: {count: 3, type: 'single', text: "Load average", src: '/OddeyeCoconut/assets/images/integration/Load.png', name: "Load Average"},
            check_tcpconn: {count: 14/*12*/, type: 'single', text: "Tcp", src: '/OddeyeCoconut/assets/images/integration/TCP.png', name: "TCP Connections"}

        }},
    file_systems_check: {text: "File systems", childs: {
            check_hadoop_datanode: {count: 18, type: 'single', text: "HDFS datanode", src: '/OddeyeCoconut/assets/images/integration/hadoop.png', name: "HDFS datanode"},
            check_hadoop_namenode: {count: 41, type: 'single', text: "HDFS namenode", src: '/OddeyeCoconut/assets/images/integration/hadoop.png', name: "HDFS namenode"},
            check_ceph: {count: 8, type: 'single', text: "Ceph", src: '/OddeyeCoconut/assets/images/integration/ceph.png', name: "Ceph"},
            check_btrfs: {count: 5, type: 'multi', multiText: "Disks Count", text: "BTRFS", src: '/OddeyeCoconut/assets/images/integration/btrfs.png', name: "BTRFS"}
        }},
    webservers_check: {text: "Web Servers", childs: {
            check_apache: {count: 7, type: 'single', text: "Apache", src: '/OddeyeCoconut/assets/images/integration/apache.png', name: "Apache"},
            check_nginx: {count: 7, type: 'single', text: "Nginx", src: '/OddeyeCoconut/assets/images/integration/Nginx.png', name: "NginX"},
            check_haproxy: {count: 2, type: 'multi', multiText: "App Count", text: "Haproxy", src: '/OddeyeCoconut/assets/images/integration/haproxy.png', name: "HAProxy"},
            check_tomcat: {count: 13, type: 'single', text: "Tomcat", src: '/OddeyeCoconut/assets/images/integration/ApacheTomcat.png', name: "Apache Tomcat"},
            check_jetty: {count: 24, type: 'single', text: "Jetty", src: '/OddeyeCoconut/assets/images/integration/jetty.png', name: "Jetty"},
            check_lighttpd: {count: 4/*, type: 'multi'*/, type: 'single', text: "LigHTTPD", src: '/OddeyeCoconut/assets/images/integration/light_logo.png', name: "Lighttpd"},
            check_http_api: {count: 2, type: 'multi', multiText: "App Count", text: "HTTP API", src: '/OddeyeCoconut/assets/images/integration/http.png', name: "HTTP API"}

        }},
    search_check: {text: "Search platform", childs: {
            check_elasticsearch1x: {count: 24, type: 'single', text: "Elasticsearch1X", src: '/OddeyeCoconut/assets/images/integration/elastic.png', name: "Elasticsearch 1.x"},
            check_elasticsearch2x5: {count: 24, type: 'single', text: "Elasticsearch2X5", src: '/OddeyeCoconut/assets/images/integration/elastic.png', name: "Elasticsearch 2.x-5.x"},
            check_solr: {count: 28/*?????*/, type: 'single', text: "Solr", src: '/OddeyeCoconut/assets/images/integration/Solr.png', name: "Solr"}
        }},
    processing_check: {
        text: "BigData processing", childs: {
            check_spark_master: {count: 15/*?????*/, type: 'single', text: "Spark master", src: '/OddeyeCoconut/assets/images/integration/Spark.png', name: "Spark Master"},
            check_spark_worker: {count: 15/*?????*/, type: 'single', text: "Spark worker", src: '/OddeyeCoconut/assets/images/integration/Spark.png', name: "Spark Worker"},
            check_storm_api: {count: [4, 8, 11], type: 'multi', multiText: ["Topologys", "Spots", "Bolts"], text: "Storm Api", src: '/OddeyeCoconut/assets/images/integration/Storm.png', name: "Storm Api"},
            check_storm_workers: {count: 12, type: 'multi', multiText: "Worker Count in node", text: "Storm Workers", src: '/OddeyeCoconut/assets/images/integration/Storm.png', name: "Storm Workers"}

        }
    },
    java_check: {text: "Java", childs: {
            check_jmx: {count: 15, type: 'single', text: "JMX", src: '/OddeyeCoconut/assets/images/integration/jmx.png', name: "JMX"},
            check_jolokia: {count: 16, type: 'single', text: "Jolokia", src: '/OddeyeCoconut/assets/images/integration/jolokia.png', name: "Jolokia"}

        }},
    messagequeue_check: {text: "MQ,Cache", childs: {
            check_kafka: {count: 27, type: 'single', text: "Kafka", src: '/OddeyeCoconut/assets/images/integration/Kafka.png', name: "Kafka"},
            check_rabbitmq: {count: 8/*?????*/, qmcount: 3, hasAll: true, allText: "Use Q Details", type: 'multi', text: "rabbitMQ", multiText: "Q Details Count", src: '/OddeyeCoconut/assets/images/integration/RabbitMQ.png', name: "RabbitMQ"},
            check_rabbitmq_368: {count: 8/*?????*/, qmcount: 7, qmbasecount: 5, hasAll: true, allText: "Use Q Details", type: 'multi', text: "rabbitmq_368", multiText: "368Q Details Count", src: '/OddeyeCoconut/assets/images/integration/RabbitMQ.png', name: "RabbitMQ_368"},
            check_activemq: {count: 17/*?????*/, type: 'single', text: "ActiveMQ", src: '/OddeyeCoconut/assets/images/integration/ActiveMQ.png', name: "ActiveMQ"},
            check_redis: {count: 8/*?????*/, type: 'single', text: "Redis", src: '/OddeyeCoconut/assets/images/integration/Redis.png', name: "Redis"},
            check_memcached: {count: 16, type: 'single', text: "Memcached", src: '/OddeyeCoconut/assets/images/integration/Memcached.png', name: "Memcached"}

        }},
    nosql_check: {text: "NoSQL", childs: {
            check_hbase_master: {count: 22, type: 'single', text: "HBase master", src: '/OddeyeCoconut/assets/images/integration/hbase.png', name: "HBase Master"},
            check_hbase_regionserver: {count: 33, type: 'single', text: "HBase regionserver", src: '/OddeyeCoconut/assets/images/integration/hbase.png', name: "HBase Regionserver"},
            check_hbase_rest: {count: 23, type: 'single', text: "HBase rest", src: '/OddeyeCoconut/assets/images/integration/hbase.png', name: "HBase Rest"},
            check_hbase_thrift: {count: 19, type: 'single', text: "HBase thrift", src: '/OddeyeCoconut/assets/images/integration/hbase.png', name: "HBase Thrift"},
            check_cassandra: {count: 23, type: 'single', text: "Cassandra", src: '/OddeyeCoconut/assets/images/integration/cassandra.png', name: "Cassandra"},
            check_cassandra3: {count: 23, type: 'single', text: "Cassandra3", src: '/OddeyeCoconut/assets/images/integration/cassandra.png', name: "Cassandra 3"},
            check_riak: {count: 10/*?????*/, type: 'single', text: "Riak", src: '/OddeyeCoconut/assets/images/integration/Riak.png', name: "Riak"}
        }},
    hadoop_check: {text: "Distributed mananger", childs: {
            check_zookeeper: {count: 11, type: 'single', text: "Zookeeper", src: '/OddeyeCoconut/assets/images/integration/Zookeeper.png', name: "Zookeeper"},
            check_mesos_master: {count: 32, type: 'single', text: "Mesos master", src: '/OddeyeCoconut/assets/images/integration/Mesos.png', name: "Mesos Master"},
            check_mesos_slave: {count: 20, type: 'single', text: "Mesos slave", src: '/OddeyeCoconut/assets/images/integration/Mesos.png', name: "Mesos Slave"}
        }},
    docstorage_check: {text: "Document Storage", childs: {
            check_couchbase_4x: {count: 8/*?????*/, type: 'single', text: "Couchbase 4x", src: '/OddeyeCoconut/assets/images/integration/Couchbase.png', name: "Couchbase"},
            check_couchbase_5x: {count: 8/*?????*/, type: 'single', text: "Couchbase 5x", src: '/OddeyeCoconut/assets/images/integration/Couchbase.png', name: "Couchbase"},
            check_couchdb_1x: {count: 9/*?????*/, type: 'single', text: "CouchDB 1x", src: '/OddeyeCoconut/assets/images/integration/CouchDB.png', name: "CouchDB"},
            check_couchdb_2x: {count: 9/*?????*/, type: 'single', text: "CouchDB 2x", src: '/OddeyeCoconut/assets/images/integration/CouchDB.png', name: "CouchDB"},
            check_mongodb: {count: 24/*?????*/, type: 'single', text: "MongoDB", src: '/OddeyeCoconut/assets/images/integration/mongoDB.png', name: "MongoDB"}
        }},
    other_check: {text: "Other", childs: {
            check_mysql: {count: 24, type: 'single', text: "MySQL", src: '/OddeyeCoconut/assets/images/integration/MySQL.png', name: "MySQL"},
            check_phpfpm: {count: 7, type: 'single', text: "PHPFPM", src: '/OddeyeCoconut/assets/images/integration/phpfpm.png', name: "PHP-FPM"},
            check_docker_stats: {count: 8, detailcount: 23, type: 'multi', hasAll: true, allText: "Use Detal", text: "Docker stats", multiText: "Docker Container Count", src: '/OddeyeCoconut/assets/images/integration/docker-logo.png', name: "Docker"},
            check_snmp: {count: 1/*?????*/, type: 'multi', text: "SNMP", multiText: "SNMP Device Count", src: '/OddeyeCoconut/assets/images/integration/snmp.png', name: "SNMP"},
            check_nagios: {count: 1, type: 'multi', text: "Nagios", multiText: "Nagios checks metrics count", src: '/OddeyeCoconut/assets/images/integration/nagios.png', name: "Nagios Checks"},
            check_custom: {count: 1, type: 'multi', text: "Custom", multiText: "Custom check metrics count", src: '/OddeyeCoconut/assets/images/integration/custom.png', name: "Custom Checks"}
        }}
//        ,
//        paccages: {text: "Cloud oacages", childs: {
//                hbase_minimal: { inclass: "paccage", src: '/OddeyeCoconut/assets/images/integration/hbase.png', name: "Hbase Cloud small",instances:[{hosts:3,checks:[]},{hosts:3,checks:[]}]}
//        }}        

};
var texts;
var metricprice = 0;
var pp = 0;
var pf = 0;
$.getJSON(cp + '/getpayinfo', function (data) {
    metricprice = data.mp;
    pp = data.pp;
    pf = data.pf;
});
var paint = function () {
    for (var key in calc) {
        $('#accordion').append('<div class="panel"><a class="panel-heading collapsed" role="tab" id="heading_' + key + '" data-toggle="collapse" data-parent="#accordion" href="#collapse_' + key + '" aria-expanded="false" aria-controls="collapse_' + key + '"><h4 class="panel-title">' + calc[key].text + ' (<span class="selectedcount">0</span>)</h4></a><div id="collapse_' + key + '" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading_' + key + '" aria-expanded="false"><div class="panel-body"></div></div></div>');
        for (var t in calc[key].childs) {
            $("#collapse_" + key + " .panel-body").append('<div class="animated flipInY col-lg-3 col-md-6 col-sm-6 col-xs-12" ><div class="integration tile-stats" id="' + t + '"><span class="icon"><img alt="" src="' + calc[key].childs[t]['src'] + '"></span><h3>' + calc[key].childs[t]['name'] + '</h3><p>' + texts[t] + '</p></div></div>');

            $('#' + t).addClass(calc[key].childs[t]['inclass']);
        }
        $('#heading_' + key + " .selectedcount").text($('#collapse_' + key + ' .checked').length + "/" + $('#collapse_' + key + ' .integration').length); // es chi ashxatum 
        ;
    }
    $('#headingSearch').parents('.panel').next().find('.panel-heading').trigger('click');
};
var instance_id = 0;
$('body').on('click', '#apply', function () {
    var sinstance_id = 'check_' + instance_id;
    $("#hostcheck").append('<div class="hostcheck calc x_panel" id="' + sinstance_id + '"> <div class="x_title"><h2>Instance #' + (instance_id + 1) + '</h2><ul class="nav navbar-right panel_toolbox"><li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li><li><a class="close-link"><i class="fa fa-close"></i></a></li></ul><div class="clearfix"></div></div> <div  class="x_content"><div  class="row"><div  class="col-xs-12 col-sm-3 col-lg-2 "><form><label>Host Count</label><input class="host form-control" type="number" value="1"><label>Check Interval(sec.)</label><input class="sec form-control" type="number" value="10"></form></div><div class="check col-xs-12 col-sm-9 col-lg-10"></div></div></div></div>');

    $(".checked").each(function () {
        var id = $(this).attr("id");

        if (id) {
            var parent = $(this).parents('.panel-collapse').attr('id').replace('collapse_', '');
            if (calc[parent].childs[id]['type'] === 'multi') {
                if (calc[parent].childs[id]['hasAll']) {
                    $("#" + sinstance_id + " .check").append('<div class="animated flipInY col-lg-3 col-md-6 col-sm-6 col-xs-12" ><div class="integration_select tile-stats" calcparent="' + parent + '" calcid="' + id + '"><ul class="nav navbar-right panel_toolbox"><li><a class="del-link"><i class="fa fa-close"></i></a></li></ul><span class="icon"><img alt="" src="' + calc[parent].childs[id]['src'] + '"></span><h3>' + calc[parent].childs[id]['name'] + '</h3><form><label>' + calc[parent].childs[id]['multiText'] + '</label> <div><input type="number" min="1" class="multi form-control" value="1"  ></div><div class="col-xs-8 check-wraper"><input type="checkbox" class="checkbox ' + id + '"> ' + calc[parent].childs[id]['allText'] + '</div></form></div></div>');
                    $('#' + sinstance_id + ' .check input.checkbox.' + id).on('ifChanged', function () {
                        doprice($(this).parents(".hostcheck"));
                    }).iCheck({
                        checkboxClass: 'icheckbox_flat-green',
                        radioClass: 'iradio_flat-green'
                    });
                } else {
                    var mt = '<label>' + calc[parent].childs[id]['multiText'] + '</label><div><input type="number" min="1" class="multi form-control" value="1"  ></div>';
                    if (calc[parent].childs[id]['multiText'].constructor === Array)
                    {
                        //TODO ROW HATIK DRAC CHI
                        mt = "<div class='multiinputDiv'>";
                        for (var index in calc[parent].childs[id]['multiText'])
                        {
                            var span = (calc[parent].childs[id]['multiText'].length === 3) ? 4 : 6;
                            mt = mt + '<div class="col-xs-' + span + ' multiinput" >';
                            mt = mt + '<label>' + calc[parent].childs[id]['multiText'][index] + '</label><div><input type="number" min="1" arrindes ="' + index + '" class="multi form-control" value="1"  ></div>';
                            mt = mt + '</div>';
                        }
                        mt = mt + '</div>';
                    }

                    $("#" + sinstance_id + " .check").append('<div class="animated flipInY col-lg-3 col-md-6 col-sm-6 col-xs-12" ><div class="integration_select tile-stats" calcparent="' + parent + '" calcid="' + id + '"><ul class="nav navbar-right panel_toolbox"><li><a class="del-link"><i class="fa fa-close"></i></a></li></ul><span class="icon"><img alt="" src="' + calc[parent].childs[id]['src'] + '"></span><h3>' + calc[parent].childs[id]['name'] + '</h3><form>' + mt + '</form></div></div>');
                }

            } else {
                $("#" + sinstance_id + " .check").append('<div class="animated flipInY col-lg-3 col-md-6 col-sm-6 col-xs-12" ><div class="integration_select tile-stats" calcparent="' + parent + '" calcid="' + id + '"><ul class="nav navbar-right panel_toolbox"><li><a class="del-link"><i class="fa fa-close"></i></a></li></ul><span class="icon"><img alt="" src="' + calc[parent].childs[id]['src'] + '"></span><h3>' + calc[parent].childs[id]['name'] + '</h3><p>' + texts[id] + '</p></div></div>');
            }
        }
    });
    $("#" + sinstance_id + " .x_content").after('<div><button  class="calc_button clone " >Clone</button><div class="totalPrice"> <label>Instance price</label> <span class ="totalusd">~</span>');
    $('#fullprice table tbody').append('<tr id="tr_' + instance_id + '"><th><a href="#' + sinstance_id + '"> #' + (instance_id + 1) + '</a></th><td class="unit">0</td><td class="usd">0</td></tr>');
    doprice($("#" + sinstance_id));
    instance_id++;
});
$('body').on('click', '.integration', function () {
    $(this).toggleClass('checked');
    $("div[value='" + $(this).attr('id') + "']").toggleClass('checked');
    var key = $(this).parents('.panel-collapse').attr('id').replace('collapse_', '');
    if ($(this).attr('value'))
    {
        $("#" + $(this).attr('value')).toggleClass('checked');
        key = $("#" + $(this).attr('value')).parents('.panel-collapse').attr('id').replace('collapse_', '');
    }
    $('#heading_' + key + " .selectedcount").text($('#collapse_' + key + ' .checked').length + "/" + $('#collapse_' + key + ' .integration').length);
});
$('body').on('click', '#reset', function () {
    $('.integration').removeClass('checked');
    $('.panel').each(function () {
        var key = $(this).find('a').attr('href').replace('collapse_', '');
        $(this).find('.selectedcount').text($(key + ' .checked').length + "/" + $(key + ' .integration').length);
    });
});
$('body').on('click', '.x_title .close-link', function () {
    var id = $(this).parents('.hostcheck').attr('id');
    id = id.replace('check_', 'tr_');
    $(this).parents('.hostcheck').remove();
    $('#fullprice table tbody #' + id).remove();
    doprice(false);
});
$('body').on('click', '.hostcheck .collapse-link', function () {
    var item = $(this).find('i');
    if (item.hasClass("fa-chevron-up"))
    {
        item.removeClass('fa-chevron-up');
        item.addClass('fa-chevron-down');
        item.parents('.hostcheck').find('.x_content').slideUp();
    } else
    if (item.hasClass("fa-chevron-down"))
    {
        item.removeClass('fa-chevron-down');
        item.addClass('fa-chevron-up');
        item.parents('.hostcheck').find('.x_content').slideDown();
    }
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
    $(this).parents('.flipInY').fadeOut(500, function () {
        $(this).remove();
        doprice(that);
    });
});
$('body').on('input', '.hostcheck input', function () {
    var elem = $(this);
    clearTimeout(whaittimer);
    var whaittimer = setTimeout(function () {
        doprice(elem.parents(".hostcheck"));
    }, 500);
});
var whaittimer;
$('body').on('keyup', '.search-query', function () {
    $('#accordion .panel:first-child').css("display", "block");
    $('#loading').css("display", "inline-block");
    if ($('.search-query').val()) {
        clearTimeout(whaittimer);
        whaittimer = setTimeout(function () {
            if ($('.search-query').val()) {
                search($('.search-query').val());
                $('#loading').css("display", "none");
                if (!$('#collapseSearch .panel-body .animated').length) {
                    $('#collapseSearch .panel-body').html('No results found for <b>' + $('.search-query').val() + '</b>');
                }
            } else
            {
                if ($("#collapseSearch").hasClass("in"))
                {
                    $('#headingSearch').trigger('click');
                    $('#collapseSearch .panel-body').html('');
                    $('#accordion .panel:first-child').css("display", "none");
                }
            }
            ;
        }, 1000);
    } else {
        $('#loading').css("display", "none");
        if ($("#collapseSearch").hasClass("in"))
        {
            $('#headingSearch').trigger('click');
            $('#collapseSearch .panel-body').html('');
            $('#accordion .panel:first-child').css("display", "none");
        }
        ;
    }
    ;
});
$('body').on('change', '.checkbox', function () {
    doprice($(this).parents(".hostcheck"));
});
function search(value) {
    $('#collapseSearch .panel-body').html('');
    var i = 0;
    var wrapDiv = $("<div></div>");
    while (i <= $(".panel-body").length) {
        wrapDiv.append($($(".panel-body")[i]).html());
        i++;
    }
    var testx = wrapDiv.html();
    const regex = new RegExp('<div([^>\/]+)class="integration([^>\/]+)>((?!<\/div>).)*' + value + '((?!<div).)*(\<(\/?[^>]+)div>)', 'ig');
    var Wrap = "<div class='animated flipInY col-lg-3 col-md-6 col-sm-6 col-xs-12'>";
    let m;
    while ((m = regex.exec(testx)) !== null) {
        // This is necessary to avoid infinite loops with zero-width matches
        if (m.index === regex.lastIndex) {
            regex.lastIndex++;
        }
        var item = $(m[0]);
        item.attr('value', item.attr("id"));
        item.removeAttr("id");
        $('#collapseSearch .panel-body').append(item);
        item.wrap(Wrap);
    }
    if (!$("#collapseSearch").hasClass("in"))
    {
        $('#headingSearch').trigger('click');
    }
}
function doprice(contener) {
    var applysum = 0;
    if (contener)
    {
        contener.find(".integration_select").each(function () {
            var sum = 0;
            var id = $(this).attr('calcid');
            var parent = $(this).attr('calcparent');
            if (calc[parent].childs[id]['type'] === 'multi') {
                var multinumber = 1;
                if ($(this).find('.multi').length === 1)
                {
                    multinumber = Number.parseFloat($(this).find('.multi').val());
                } else
                {
                    multinumber = [];
                    $(this).find('.multi').each(function () {
                        multinumber[$(this).attr('arrindes')] = $(this).val();
                    });
                }
                if (typeof (calc[parent].childs[id]['hasAll']) === "undefined")
                {
                    if ($(this).find('.multi').length === 1)
                    {
                        sum = calc[parent].childs[id]['count'] * multinumber;
                    } else
                    {
                        sum = 0;
                        for (var mind in multinumber)
                        {
                            sum = sum + calc[parent].childs[id]['count'][mind] * multinumber[mind];
                        }
                    }
                } else
                {
                    if (id === "check_cpustats")
                    {
                        if ($(this).find('.checkbox').prop('checked')) {
                            sum = (calc[parent].childs[id]['count']) * (multinumber + 1);
                        } else {
                            sum = calc[parent].childs[id]['count'];
                        }
                    }
                    if (id === "check_docker_stats")
                    {
                        if ($(this).find('.checkbox').prop('checked')) {
                            sum = calc[parent].childs[id]['detailcount'] * multinumber;
                        } else {
                            sum = calc[parent].childs[id]['count'] * multinumber;
                        }
                    }
                    if (id === "check_rabbitmq")
                    {
                        if ($(this).find('.checkbox').prop('checked')) {
                            sum = calc[parent].childs[id]['count'] + (calc[parent].childs[id]['qmcount'] * multinumber);
                        } else {
                            sum = calc[parent].childs[id]['count'];
                        }
                    }
                    if (id === "check_rabbitmq_368")
                    {
                        if ($(this).find('.checkbox').prop('checked')) {
                            sum = calc[parent].childs[id]['qmbasecount'] + (calc[parent].childs[id]['qmcount'] * multinumber);
                        } else {
                            sum = calc[parent].childs[id]['count'];
                        }
                    }
                }
                applysum = applysum + sum;
            } else {
                sum = calc[parent].childs[id]['count'];
                applysum = applysum + sum;
            }
        });
        var price = (contener.find('.host').val() * ((60 * 60 * 24 * 30) / contener.find('.sec').val()) * applysum * metricprice);
        contener.find('.totalusd').html('~' + (price + price * pp / 100 + pf).toFixed(2) + " USD");
        var id = contener.attr('id');
        id = id.replace('check_', 'tr_');
        $('#fullprice table tbody #' + id + ' td.unit').attr("value", applysum * contener.find('.host').val());
        $('#fullprice table tbody #' + id + ' td.unit').html(applysum * contener.find('.host').val());
        $('#fullprice table tbody #' + id + ' td.usd').attr("value", price + price * pp / 100 + pf);
        $('#fullprice table tbody #' + id + ' td.usd').html((price + price * pp / 100 + pf).toFixed(2));
    }
    var sum = 0;
    var sumusd = 0;
    $('#fullprice table tbody td.unit').each(function () {
        sum = sum + parseFloat($(this).attr('value'));
        sumusd = sumusd + parseFloat($(this).next('.usd').attr('value'));
    });
    $('#fullprice table tfoot #total td.unit').html(sum);
    $('#fullprice table tfoot #total td.usd').html(sumusd.toFixed(2));
}
;
$(document).ready(function () {
    if ($(window).width() <= 990) {
        $("#fullprice").remove();
        $(".right_col #maincontener").before('<div id="fullprice" class="col-xs-12 col-lg-2 col-md-3 animated flipInY"><div class="x_panel calc"><div class="x_title"><h2>Price for month</h2><div class="clearfix"></div></div><div class="x_content "><table class="table"><thead><tr><th>Instance</th><th>Metrics</th><th>USD</th></tr></thead><tbody></tbody><tfoot><tr id="total"><th>Total:</th><td class="unit"></td><td class="usd"></td></tr></tfoot></table></div></div></div>');
    }
    $.getJSON(cp + "/assets/checktexts.json", function (data) {
        texts = data;
        paint();
        $('#system_check').addClass('active');
    });
    if ($(window).width() > 990) {
        var winHeight = $(window).height();
        $("#fullprice").css("max-height", winHeight);
    }
});
$(document).on('scroll', function () {
    winHeight = $(window).height();
    if ($(window).width() > 990) {
        if ($(document).scrollTop() >= $('#maincontener').offset().top && !$('#fullprice').hasClass("fixed")) {
            $("#fullprice").css("max-height", winHeight);
            $('#fullprice').addClass("fixed");
        }
        if ($(document).scrollTop() < $('#maincontener').offset().top && $('#fullprice').hasClass("fixed")) {
            $("#fullprice").css("max-height", winHeight);
            $('#fullprice').removeClass("fixed");
        }
    }
});