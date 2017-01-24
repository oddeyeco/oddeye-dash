<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/echarts/theme/macarons.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    pickerlabel = "Last 1 day";

    var hashes =${hashes};
    var echartLine = echarts.init(document.getElementById('echart_line'), 'macarons');
//    var url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=1d-ago";
    var timer;
    var cp = "${cp}";
    var interval = 10000;
    series = [];

    var defserie = {
        name: null,
        type: 'line',
        sampling: 'average',
        data: null
    };

    $(document).ready(function () {
        $('#reportrange span').html(pickerlabel);
        $('#reportrange').daterangepicker(PicerOptionSet1, cb);
    });

    hashes.forEach(function (item, i, arr) {
        var url = "${cp}/getdata?hash=" + item + "&startdate=1d-ago";
        $.getJSON(url, null, function (data) {
            var chdata = [];

            for (key in data.chartsdata)
            {
                var chartline = data.chartsdata[key];

                for (var time in chartline.data) {
                    var dateval = moment(time * 1);
//                    dateval = moment(time * 1).dayOfYear(0);
                    chdata.push([dateval.toDate(), chartline.data[time]]);
                }
                var serie = clone_obg(defserie);

                serie.data = chdata;
                var name = data.chartsdata[key].metric + JSON.stringify(data.chartsdata[key].tags)
                serie.name = name;
                series.push(serie);
                if (series.length == hashes.length)
                {
                    console.log(series);
                    echartLine.setOption({
                        title: {
                            show: false,
//                            text: chartline.metric,
                        },
                        tooltip: {
                            trigger: 'axis'
                        },
//                    legend: {
//                        data: legend
//                    },
                        animation: false,
                        toolbox: {
                            show: true,
                            feature: {
//                    dataZoom: {show: true, title: "dataZoom"},
                                magicType: {
                                    show: true,
                                    title: {
                                        line: 'Line',
                                        bar: 'Bar',
                                    },
                                    type: ['line', 'bar']
                                },
                                saveAsImage: {
                                    show: true,
                                    title: "Save Image"
                                }
                            }
                        },
                        calculable: false,
                        xAxis: [{
                                type: 'time',
//                    data: date
                            }],
                        yAxis: [{
                                type: 'value',
                                axisLabel: {
                                    formatter: format_func
                                }
                            }],
                        dataZoom: {
                            show: true,
//                realtime: true,
                            start: 0,
                            end: 100
                        },
                        series: series
                    });
                }
            }
        });
    });
//    drawEchart(url, echartLine);

</script>    