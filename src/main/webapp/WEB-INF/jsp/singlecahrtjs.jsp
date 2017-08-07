<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="${cp}/resources/echarts/dist/echarts.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>    
    var balanse = 0;
    <c:if test="${curentuser.getBalance()!=null}">
    balanse = ${curentuser.getBalance()};
    </c:if>    
    var hashcode = ${metric.hashCode()};
    var merictype = ${metric.getType()};
    var formatter = format_metric;
    var s_formatter = "{value} %";
    var abc_formatter = format_metric;    
    
    switch (merictype) {
        case 4:
            formatter = "{value} %";
            s_formatter = "{value} %";
            abc_formatter = "{c} %";
            break;//formatops          
        default:                        
            formatter = format_metric;
            s_formatter = "format_metric";
            abc_formatter = format_metric;
            break;
    }
    pickerlabel = "Last 1 day";
    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var timer;
    var interval = 10000;
    $(document).ready(function () {
        var uri = cp + "/getdata?hash=" + hashcode + "&startdate=1d-ago";
        drawEchart(uri, echartLine);
        timer = setInterval(function () {
            ReDrawEchart(uri, echartLine);
        }, interval);

        $('#reportrange span').html(pickerlabel);
        PicerOptionSet1.minDate = getmindate();        
        $('#reportrange').daterangepicker(PicerOptionSet1, cb);

        $('body').on("click", "#Clear_reg", function () {
            var sendData = {};
            sendData.hash = hashcode;
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
            var url = cp + "/getdata?hash=" + hashcode + "&startdate=" + pickerstart + "&enddate=" + pickerend;
        } else
        {
            if (typeof (rangeslabels[pickerlabel]) === "undefined")
            {
                url = cp + "/getdata?hash=" + hashcode + "&startdate=1d-ago";
            } else
            {
                url = cp + "/getdata?hash=" + hashcode + "&startdate=" + rangeslabels[pickerlabel];
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
                    chdata.push({value: chartline.data[ind], 'unit': s_formatter});
                }
            }

            var calcmin = 0;
            var clacmax = 100;

            switch (merictype) {
                case 4:
                    calcmin = 0;
                    clacmax = 100;
                    break;

                default:
                    calcmin = Math.min.apply(null, chdataMath);
                    clacmax = Math.max.apply(null, chdataMath);
                    break;
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
                        type: 'time'
                    }],
                yAxis: [{
                        type: 'value',
                        axisLabel:
                                {
                                    formatter: formatter
                                }
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
                                {type: 'max', name: 'max', 'unit': s_formatter, label: {
                                        normal: {position: "top", formatter: abc_formatter},
                                        emphasis: {position: "top",formatter: abc_formatter}
                                    }},
                                {type: 'min', name: 'min', label: {
                                        normal: {position: "top", formatter: abc_formatter},
                                        emphasis: {position: "top",formatter: abc_formatter}
                                    }}
                            ]
                        },
                        markLine: {
                            data: [
                                {type: 'average', name: 'average',  'unit': s_formatter, label: {
                                        normal: {formatter: abc_formatter},
                                        emphasis: {formatter: abc_formatter}
                                    }}
                            ]
                        },
                        data: chdata
                    },
                    {
                        name: 'Last',
                        type: 'gauge',
                        axisLabel: {show: false},
                        center: ['90%', 220],
                        radius: 140,
                        startAngle: 90,
                        endAngle: -90,
                        min: calcmin,
                        max: clacmax,
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
                            formatter: formatter
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
                for (var ind in chartline.data) {
                    chdataMath.push(chartline.data[ind][1]);
                    chdata.push({value: chartline.data[ind]});
                }

            }
            var options = chart.getOption();

            options.series[1].data[0].value = chdataMath[chdataMath.length - 1];
            switch (merictype) {
                case 4:
                    options.series[1].min = 0;
                    options.series[1].max = 100;
                    break;

                default:
                    options.series[1].min = Math.min.apply(null, chdataMath);
                    options.series[1].max = Math.max.apply(null, chdataMath);
                    break;
            }            
            
            options.series[0].data = chdata;            
            chart.setOption({series:options.series});

        }
        );
    }
    ;

</script>