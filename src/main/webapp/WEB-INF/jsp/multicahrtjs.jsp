<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/assets/js/echarts.min.js?v=${version}"></script>
<!--<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>-->
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>

<script>
    var balanse = 0;
    <c:if test="${curentuser.getBalance()!=null}">
    balanse = ${curentuser.getBalance()};
    </c:if>
    var locale = {
//        "save": "<spring:message code="save"/>",
//        "dash.backToDash": "<spring:message code="dash.backToDash"/>",

//        "dash.edit.chart": "<spring:message code="dash.edit.chart"/>",
//        "dash.edit.counter": "<spring:message code="dash.edit.counter"/>",
//        "dash.edit.table": "<spring:message code="dash.edit.table"/>",
//        "dash.show.chart": "<spring:message code="dash.show.chart"/>",
//        "dash.show.counter": "<spring:message code="dash.show.counter"/>",
//        "dash.show.table": "<spring:message code="dash.show.table"/>",
//
//        "dash.title.lockDashboard": "<spring:message code="dash.title.lockDashboard"/>",
//        "dash.title.unlockDashboard": "<spring:message code="dash.title.unlockDashboard"/>",
//        "dash.row": "<spring:message code="dash.row"/>",
//        "dash.title.expand": "<spring:message code="dash.title.expand"/>",

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
    var hashes =${hashes};
    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var timer;
    var interval = 10000;
    series = [];
    var defserie = {
        name: null,
        type: 'line',
        data: null
    };
    window.onresize = echartLine.resize;
    $(document).ready(function () {
        pickerlabel = locale["datetime.lastonehoure"];
        $('#reportrange span').html(pickerlabel);
        PicerOptionSet1.minDate = getmindate();
        $('#reportrange').daterangepicker(PicerOptionSet1, cb);
        drawEchart(hashes, echartLine);
    });

    $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
        drawEchart(hashes, echartLine);
    });

    function drawEchart(hashes, echartLine, reload)
    {
        if (typeof (reload) === "undefined")
        {
            reload = false;
        }
        var requestcount = 0;
        var series = [];
        var legend = [];
        hashes.forEach(function (item, i, arr) {
            var url;
            if (pickerlabel === "Custom")
            {
                url = "${cp}/getdata?hash=" + item + "&startdate=" + pickerstart + "&enddate=" + pickerend;
            } else
            {
                if (typeof (rangeslabels[pickerlabel]) === "undefined")
                {
                    url = "${cp}/getdata?hash=" + item + "&startdate=1d-ago";
                } else
                {
                    url = "${cp}/getdata?hash=" + item + "&startdate=" + rangeslabels[pickerlabel];
                }

            }
            requestcount++;
            echartLine.showLoading("default", {
                text: '',
                color: colorPalette[0],
                textColor: '#000',
                maskColor: 'rgba(255, 255, 255, 0)',
                zlevel: 0
            });

            $.getJSON(url, null, function (data) {
                var chdata = [];
                requestcount--;                
                if (Object.keys(data.chartsdata).length > 0)
                {
                    for (key in data.chartsdata)
                    {
                        var chartline = data.chartsdata[key];

                        chdata = chartline.data;
                        var serie = clone_obg(defserie);

//                    serie.data = chdata;
                        serie.data = [];
                        for (var ind in chdata)
                        {
                            serie.data.push({value: chdata[ind], 'unit': "format_metric"});
                            if (reload)
                            {
                                delete(serie.type);
                                delete(serie.stack);

                            }
                        }
                        var name = data.chartsdata[key].metric + JSON.stringify(data.chartsdata[key].tags);
                        serie.name = name;
                        series.push(serie);
                        legend.push(name);
                    }
                }
                if (requestcount === 0)
                {
                    echartLine.hideLoading();
                    series.sort(function (a, b) {
                        return compareStrings(a.name, b.name);
                    });
                    if (!reload)
                    {
                        echartLine.setOption({
                            title: {
                                text: ""
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
                                                formatter: format_metric
                                            }
                                }],
                            dataZoom: [{
                                    type: 'inside',
                                    xAxisIndex: 0,
                                    show: true,
                                    start: 0,
                                    end: 100
                                }],
                            series: series
                        });
                    } else
                    {
                        echartLine.setOption({series: series});
                        echartLine.resize();
                    }
                    timer = setTimeout(function () {
                        drawEchart(hashes, echartLine, true);
                    }, interval);
                }

            })
                    .done(function () {
                    })
                    .fail(function (jqXHR, textStatus, errorThrown) {
                        console.log('getJSON request failed! ' + textStatus);
                    })
                    ;
        });
    }
</script>    