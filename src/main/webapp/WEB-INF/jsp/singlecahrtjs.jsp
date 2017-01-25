<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    pickerlabel = "Last 1 day";

    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=1d-ago";
    var timer;
    var cp = "${cp}";
    var interval = 10000;
    $(document).ready(function () {
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
        if (pickerlabel == "Custom")
        {
            url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=" + pickerstart + "&enddate=" + pickerend;
        } else
        {
            if (typeof (rangeslabels[pickerlabel]) == "undefined")
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

    drawEchart(url, echartLine);
    timer = setInterval(function () {
        ReDrawEchart(url, echartLine);
    }, interval);


    function drawEchart(url, chart)
    {
        $.getJSON(url, null, function (data) {
            var date = [];
            var chdata = [];
            var chdataMath = [];
            var dateval = moment();
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var time in chartline.data) {
                    var dateval = moment(time * 1);
                    chdata.push([dateval.toDate(), chartline.data[time]]);
                    chdataMath.push(chartline.data[time]);
                }
            }
            chart.setOption({
                title: {
                    text: chartline.metric
                },
                tooltip: {
                    trigger: 'axis'
                },
                toolbox: {
                    show: true,
                    feature: {
                        magicType: {
                            show: true,
                            title: {
                                line: 'Line',
                                bar: 'Bar'
                            },
                            type: ['line', 'bar']
                        },
                        saveAsImage: {
                            show: true,
                            title: "Save Image"
                        }
                    }
                },
                grid: {
                    x: 90,
                    y: 40,
                    x2: 200,
                    y2: 80
                },
                xAxis: [{
                        type: 'time',
                    }],
                yAxis: [{
                        type: 'value',
                        axisLabel: {
                            formatter: format_func
                        }
                    }],
                dataZoom: {
                    show: true,
                    realtime: true,
                    start: 0,
                    end: 100
                },
                series: [{
                        name: chartline.metric,
                        type: 'line',
                        sampling: 'average',
                        itemStyle: {
                            normal: {
                                areaStyle: {
                                    type: 'default'
                                }
                            }
                        },
                        markPoint: {
                            data: [
                                {type: 'max', name: 'max', itemStyle: {
                                        normal: {
                                            label: {position: "top", formatter: format_func}
                                        }}},
                                {type: 'min', name: 'min', itemStyle: {
                                        normal: {
                                            label: {position: "top", formatter: format_func}
                                        }}}
                            ]
                        },
                        markLine: {
                            data: [
                                {type: 'average', name: 'average', itemStyle: {
                                        normal: {
                                            label: {formatter: format_func}
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
                        pointer: {
                            width: 4,
                            length: '100%'
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
                            show: true,
                            backgroundColor: 'rgba(0,0,0,0)',
                            borderWidth: 0,
                            borderColor: '#ccc',
                            width: 100,
                            height: 40,
                            offsetCenter: ["50%", "140%"],
                            formatter: format_func,
                            textStyle: {
                                color: 'auto',
                                fontSize: 30
                            }
                        },
                        data: [{value: chdataMath[chdataMath.length - 1], name: 'Last Value'}]
                    }]
            });
        });
    }
    ;


    function ReDrawEchart(url, chart)
    {
        $.getJSON(url, null, function (data) {
//            console.log(data);
            var date = [];
            var chdata = [];
            var chdataMath = [];
            var dateval = moment();
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var time in chartline.data) {
                    var dateval = moment(time * 1);
                    chdata.push([dateval.toDate(), chartline.data[time]]);   
                    chdataMath.push(chartline.data[time]);
                }
            }
            var options = chart.getOption();

            options.series[1].data[0].value = chdataMath[chdataMath.length - 1];            
            options.series[1].min = Math.min.apply(null, chdataMath),
            options.series[1].max=Math.max.apply(null, chdataMath),            
            
            options.series[0].data = chdata;
            options.xAxis[0].data = date;
            chart.setOption(options);
        }
        );
    }
    ;

</script>