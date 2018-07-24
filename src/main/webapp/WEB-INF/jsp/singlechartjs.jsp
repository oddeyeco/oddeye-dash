<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/echarts/dist/echarts.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>

<script>
    
    var locale = {
        "save": "<spring:message code="save"/>",
        "dash.backToDash": "<spring:message code="dash.backToDash"/>",

        "dash.edit.chart": "<spring:message code="dash.edit.chart"/>",
        "dash.edit.counter": "<spring:message code="dash.edit.counter"/>",
        "dash.edit.table": "<spring:message code="dash.edit.table"/>",
        "dash.show.chart": "<spring:message code="dash.show.chart"/>",
        "dash.show.counter": "<spring:message code="dash.show.counter"/>",
        "dash.show.table": "<spring:message code="dash.show.table"/>",

        "dash.title.lockDashboard": "<spring:message code="dash.title.lockDashboard"/>",
        "dash.title.unlockDashboard": "<spring:message code="dash.title.unlockDashboard"/>",
        "dash.row": "<spring:message code="dash.row"/>",
        "dash.title.expand": "<spring:message code="dash.title.expand"/>",

        "datetime.lastminute": "<spring:message code="datetime.lastminute"/>",
        "datetime.lasthoures": "<spring:message code="datetime.lasthoures"/>",
        "datetime.lasthoures2": "<spring:message code="datetime.lasthoures2"/>",
        "datetime.lastdays": "<spring:message code="datetime.lastdays"/>",
        "datetime.lastdays2": "<spring:message code="datetime.lastdays2"/>",

        "datetime.lastonehoure": "<spring:message code="datetime.lastonehoure"/>",
        "datetime.lastoneday": "<spring:message code="datetime.lastoneday"/>",
        "datetime.general": "<spring:message code="datetime.general"/>"
    };
    
    var DtPicerlocale = {
        applyLabel: '<spring:message code="datetime.submit"/>',
        cancelLabel: '<spring:message code="datetime.clear"/>',
        fromLabel: '<spring:message code="datetime.from"/>',
        toLabel: '<spring:message code="datetime.to"/>',
        customRangeLabel: '<spring:message code="datetime.custom"/>',
        weekLabel: '<spring:message code="datetime.weekLabel"/>',
        daysOfWeek: ['<spring:message code="su"/>', '<spring:message code="mo"/>', '<spring:message code="tu"/>', '<spring:message code="we"/>', '<spring:message code="th"/>', '<spring:message code="fr"/>', '<spring:message code="sa"/>'],
        monthNames: ['<spring:message code="january"/>', '<spring:message code="february"/>', '<spring:message code="march"/>', '<spring:message code="april"/>', '<spring:message code="may"/>', '<spring:message code="june"/>', '<spring:message code="july"/>', '<spring:message code="august"/>', '<spring:message code="september"/>', '<spring:message code="october"/>', '<spring:message code="november"/>', '<spring:message code="december"/>'],
        firstDay: 1
    };    
    
    
    
    var balanse = 0;
    <c:if test="${curentuser.getBalance()!=null}">
    balanse = ${curentuser.getBalance()};
    </c:if>
    var hashcode = ${metric.hashCode()};
    var merictype = ${metric.getType().ordinal()};
    var formatter = format_metric;
    var abc_formatter = format_metric;
    var s_formatter = "format_metric";
    switch (merictype) {
        case 3:
            formatter = formatops;
            s_formatter = "formatops";
            abc_formatter = formatops;
            break;//formatops                
        case 4:
            formatter = format_percent;
            s_formatter = "{value} %";
            abc_formatter = format_percent;
            break;//formatops          
        default:
            formatter = format_metric;
            s_formatter = "format_metric";
            abc_formatter = format_metric;
            break;
    }
    
    var markPoint = {data: [
            {type: 'max', name: 'max', 'unit': s_formatter,
                itemStyle: {color: "#ff0000"},
                label: {
                    normal: {position: "right", formatter: abc_formatter},
                    emphasis: {position: "right", formatter: abc_formatter}
                }},
            {type: 'min', name: 'min', symbolRotate: 180,
                itemStyle: {color: "#b6a2de"},
                label: {
                    normal: {position: "left", formatter: abc_formatter},
                    emphasis: {position: "left", formatter: abc_formatter}
                }}
        ]
    };
    var markLine = {
        data: [
            {type: 'average', name: 'average', 'unit': s_formatter, label: {
                    normal: {formatter: abc_formatter},
                    emphasis: {formatter: abc_formatter}
                }}
        ]
    };    
    
    switch (merictype) {
        case 2:
            markPoint = {};
            markLine = {
                data: [
                    {type: 'max', name: 'max', 'unit': s_formatter, label: {
                            normal: {formatter: abc_formatter},
                            emphasis: {formatter: abc_formatter}
                        }},
                    {type: 'min', name: 'min', 'unit': s_formatter, label: {
                            normal: {formatter: abc_formatter},
                            emphasis: {formatter: abc_formatter}
                        }}
                ]
            };
            break;     
        default:

            break;
    }    
    
    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var timer;
    var interval = 10000;
    $(document).ready(function () {
        var uri = cp + "/getdata?hash=" + hashcode + "&startdate=1d-ago";
        drawEchart(uri, echartLine);
        timer = setInterval(function () {
            ReDrawEchart(uri, echartLine);
        }, interval);
        pickerlabel = locale["datetime.lastoneday"];
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
                    setTimeout(function () {
                        location.reload();
                    }, 1000);
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
        if (pickerlabel === DtPicerlocale["customRangeLabel"])
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
            var grid = {
                top: 50,
                x2: 200,
                y2: 80,
                containLabel: true
            };

            var series = [{
                    name: chartline ? chartline.metric :"b",
                    type: 'line',
                    areaStyle: {
                        normal: {opacity: 0.4}
                    },
                    markPoint: markPoint,
                    markLine: markLine,
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
                }];


            switch (merictype) {
                case 2:
                    grid = {
                        top: 50,
                        x2: 40,
                        y2: 80,
                        containLabel: true
                    };
                    series = [{
                            name: chartline ? chartline.metric :"",
                            type: 'line',
                            areaStyle: {
                                normal: {opacity: 0.4}
                            },
                            markPoint: markPoint,
                            markLine: markLine,
                            data: chdata
                        }];

                    break;

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
                    text: chartline ? chartline.metric :"",
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
                grid: grid,
                series: series
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

            if (options.series[1])
            {
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
            }


            options.series[0].data = chdata;
            chart.setOption({series: options.series});

        }
        );
    }
    ;

</script>