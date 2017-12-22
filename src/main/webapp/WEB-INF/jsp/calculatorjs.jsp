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

//var hasAll;
    function buildRaw( ) {

        var opt;
        var row = $('<tr class="row"><td ><input   type="number" min="1" class="host calc_font form-control" name="hostNumb" value="1"></td><td><input type="number" min="1" class="sec calc_font form-control" value="10" name="seconds"></td><td class="selectTd"><select class="js-example-basic-multiple checkList" name="states[]" multiple="multiple"></select></td><td class="multiTd"></td><td><input type="text" class="prices form-control" name="prce" disabled></td><td class="buttonTd"><button id="minus" class="reflock"> <i class="fa fa-minus" aria-hidden="true"></i> </button></td></tr>');

        for (var key in checs) {

            var val = checs[key];

            opt = $("<option val='" + key + "' type ='" + val['type'] + "'>" + val['text'] + "</option>");

            if (val['isbegin']) {
                opt.attr('selected', true);
            }
            ;
            row.find('.checkList').append(opt);
        }
        ;
        $('tbody').append(row);
        row.find('.js-example-basic-multiple').select2();

    }
    ;

    var priceGenerator = function (select, selectVal, elem) {

        var contArr = [];
        var keyArrMulti = [];
//        console.log(selectVal.length);
        for (var i = 0; i < selectVal.length; i++) {

            var key = select.find('option:contains(' + selectVal[i] + ')').attr('val');
            var count = checs[key]['count'];

            if (checs[key]['type'] === 'multi' && select.parents('tr').find('.multiTd .multiDiv #' + key).length === 0) {

                if (checs[key]['hasAll']) {

                    select.parent().next().append('<div class="multiDiv"><label>' + checs[key]['multiText'] + '</label><input type="number" min="1" class="multi calc_font form-control" value="4" id=' + key + '></div>');
                    var checkbox = '<input   type="checkbox" class="checkbox icheckbox_flat-green ' + key + '">';
                    select.parents('tr').find('.multiDiv label').before(checkbox);

//                    console.log(select.parents('tr').find('.checkbox').prop('checked'));

                    if (select.parents('tr').find('.checkbox').prop('checked')) {
                        count = checs[key]['count'] * (+select.parents('tr').find('#' + key).val().val() + 1);
                    } else {
                        count = checs[key]['count'] * (+select.parents('tr').find('#' + key).val());
                    }
                } else {
                    select.parent().next().append('<div class="multiDiv"><label>' + checs[key]['multiText'] + '</label><input type="number" min="1" class="multi calc_font form-control" value="1" id=' + key + '></div>');
                }
                ;

            } else if (checs[key]['type'] === 'multi' && select.parents('tr').find('.multiTd .multiDiv #' + key).length !== 0) {
                if (checs[key]['hasAll']) {
                    console.log(select.parents('tr').find('.checkbox').prop('checked'));
                    if (select.parents('tr').find('.checkbox').prop('checked')) {
                        count = checs[key]['count'] * (+select.parents('tr').find('#' + key).val() + 1);
                    } else {
                        count = checs[key]['count'] * (+select.parents('tr').find('#' + key).val());
                    }
                } else {
                    count = checs[key]['count'] * select.parents('tr').find('#' + key).val();
                }
                ;

            }
            ;

            contArr.push(count);

            if (checs[key]['type'] === 'multi') {
                keyArrMulti.push(key);
            }
            ;
        }
        ;
        if (select.parents('tr').find('.multiTd .multiDiv').length > 0) {

//        select.parents('tr').find('.multiDiv .checkbox').remove();

            var inputArr = select.parents('tr').find('.multiDiv .multi');
            var checkboxArr = select.parents('tr').find('.multiDiv .checkbox');
            var labelArr = select.parents('tr').find('.multiDiv label');

            select.parents('tr').find('.multiDiv').remove();

            for (var j = 0; j < inputArr.length; j++) {

                var elem = $(inputArr[j]);

                for (var i = 0; i < keyArrMulti.length; i++) {

                    if ((elem.attr('id') === keyArrMulti[i] && checs[keyArrMulti[i]]['type'] === 'multi')) {

                        var multiDiv = $('<div class="multiDiv"></div>');
                        if (checs[keyArrMulti[i]]['hasAll']) {
                            var CHeckLabText = '<label>' + checs[keyArrMulti[i]]['multiText'] + ' : All </label>';
                            multiDiv.append(CHeckLabText, checkboxArr[0], inputArr[j]);

                        } else {
                            multiDiv.append(labelArr[j], inputArr[j]);
                        }
                        select.parent().next().append(multiDiv);
                        select.parent().next().find('input.checkbox').iCheck({checkboxClass: 'icheckbox_flat-green', radioClass: 'iradio_flat-green', increaseArea: '20%'});
                    }
                }
                ;
            }
            ;

        }
        ;

        var countSum = function () {

            var sum = 0;

            for (var i = 0; i < contArr.length; i++) {
                sum += contArr[i];
            }
            ;
            return sum;
        };

        var price = select.parents('tr').find('.host').val() * ((60 * 60 * 24 * 30) / select.parents('tr').find('.sec').val()) * countSum() * metricprice;

        if (typeof price === "number") {
            select.parents('tr').find('.prices').val(price.toFixed(2) + " $");
        }
        ;

    };
    var dellRow = function () {

        $(this).closest("tr").remove();

    };


    function priceCalculation(elem) {


//        console.log(elem);

        if (elem.attr('id') === 'plus') {
            var select = $('tbody .checkList:last');
            var selectVal = $('tbody .checkList:last').val();
            priceGenerator(select, selectVal, elem);
        } else {
            var select = elem.parents('tr').find('.checkList');
            var selectVal = elem.parents('tr').find('.checkList').val();
            priceGenerator(select, selectVal);
        }

    }
    ;

    var whaittimer;

    $(document).ready(function () {
        $('body').on('click', '#plus', function ( ) {
            var elem = $(this);
            buildRaw();
            priceCalculation(elem);

        });
        $('body').on('click', '#minus', dellRow);

        $('body').on('input', 'input', function ( ) {
//            console.log("asd");
            var elem = $(this);
            clearTimeout(whaittimer);
            whaittimer = setTimeout(function () {
                priceCalculation(elem);
            }, 500);
        });
        $('body').on('change', 'select', function ( ) {
            priceCalculation($(this));
        });

        $('body').on('ifChecked', '.multiDiv .checkbox', function () {
            priceCalculation($(this));
        });
        $('body').on('ifUnchecked', '.multiDiv .checkbox', function () {
            priceCalculation($(this));
        });

    });
</script>