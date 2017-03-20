<script src="${cp}/resources/echarts/dist/echarts.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    pickerlabel = "Last 1 day";
    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var timer;
    var interval = 10000;
    $(document).ready(function () {

        var uri = "${cp}/getdata?hash=${metric.hashCode()}&startdate=1d-ago";
        drawEchart(uri, echartLine);
        timer = setInterval(function () {
            ReDrawEchart(uri, echartLine);
        }, interval);

        $('#reportrange span').html(pickerlabel);
        $('#reportrange').daterangepicker(PicerOptionSet1, cb);

        $('body').on("click", "#Clear_reg", function () {
            var sendData = {};
            sendData.hash = ${metric.hashCode()};
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            url = cp + "/resetregression";
            $.ajax({
                dataType: 'json',
                type: 'POST',
                url: url,
                data: sendData,
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(header, token);
                }
            }).done(function (msg) {
                if (msg.sucsses)
                {
                    alert("Message Sended ");
                } else
                {
                    alert("Request failed");
                }
            }).fail(function (jqXHR, textStatus) {
                alert("Request failed");
            });
        });
    });

    $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
        if (pickerlabel === "Custom")
        {
            var url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=" + pickerstart + "&enddate=" + pickerend;
        } else
        {
            if (typeof (rangeslabels[pickerlabel]) === "undefined")
            {
                url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=1d-ago";
            } else
            {
                url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=" + rangeslabels[pickerlabel];
            }

        }
        clearTimeout(timer);

        drawEchart(url, echartLine);
        timer = setInterval(function () {
            ReDrawEchart(url, echartLine);
        }, interval);


    });

    function drawEchart(uri, chart)
    {
        chart.showLoading("default", {
            text: '',
            color: colorPalette[0],
            textColor: '#000',
            maskColor: 'rgba(255, 255, 255, 0)',
            zlevel: 0
        });
        $.getJSON(uri, null, function (data) {
            var chdata = [];
            var chdataMath = [];
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var ind in chartline.data) {
                    chdataMath.push(chartline.data[ind][1]);
                    chdata.push({value: chartline.data[ind], 'unit': "format_metric"});
                }
//                chdata = chartline.data;
            }
            chart.hideLoading();
            chart.setOption({
                title: {
                    text: chartline.metric
                },
                tooltip: {
                    trigger: 'axis'
                },
                toolbox: {},
                xAxis: [{
                        type: 'time',
                    }],
                yAxis: [{
                        type: 'value',
                        axisLabel:
                                {
                                    formatter: format_metric
                                },
                    }],
                dataZoom: [{
                        type: 'inside',
                        xAxisIndex: 0,
                        show: true,
                        start: 0,
                        end: 100
                    }],
                grid: {
                    x2: 200,
                    y2: 80
                },
                series: [{
                        name: chartline.metric,
                        type: 'line',
                        areaStyle: {
                            normal: {opacity: 0.4}
                        },
                        markPoint: {
                            data: [
                                {type: 'max', name: 'max', itemStyle: {
                                        normal: {
                                            label: {position: "top", formatter: format_metric}
                                        }}},
                                {type: 'min', name: 'min', itemStyle: {
                                        normal: {
                                            label: {position: "top", formatter: format_metric}
                                        }}}
                            ]
                        },
                        markLine: {
                            data: [
                                {type: 'average', name: 'average', itemStyle: {
                                        normal: {
                                            label: {formatter: format_metric}
                                        }}}
                            ]
                        },
                        data: chdata
                    },
                    {
                        name: 'Last',
                        type: 'gauge',
                        axisLabel: {show: false},
                        center: ['91%', 220],
                        radius: 140,
                        startAngle: 90,
                        endAngle: -90,
                        min: Math.min.apply(null, chdataMath),
                        max: Math.max.apply(null, chdataMath),
                        splitNumber: 3,
                        axisLine: {
                            lineStyle: {
                                width: 10
                            }
                        },
                        title: {
                            show: true,
                            offsetCenter: ["30%", -160],
                            textStyle: {
                                color: '#333',
                                fontSize: 15
                            }
                        },
                        detail: {
                            offsetCenter: ["50%", "140%"],
                            formatter: format_metric,
                        },
                        data: [{value: chdataMath[chdataMath.length - 1], name: 'Last Value'}]
                    }]
            });
        });
    }
    ;


    function ReDrawEchart(uri, chart)
    {
        $.getJSON(uri, null, function (data) {
            var date = [];
            var chdata = [];
            var chdataMath = [];
            var dateval = moment();
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var time in chartline.data) {
                    chdataMath.push(chartline.data[time][1]);
                }
                chdata = chartline.data;
            }
            var options = chart.getOption();

            options.series[1].data[0].value = chdataMath[chdataMath.length - 1];
            options.series[1].min = Math.min.apply(null, chdataMath);
            options.series[1].max = Math.max.apply(null, chdataMath);
            options.series[0].data = chdata;
            options.xAxis[0].data = date;
            chart.setOption(options);

        }
        );
    }
    ;

</script>