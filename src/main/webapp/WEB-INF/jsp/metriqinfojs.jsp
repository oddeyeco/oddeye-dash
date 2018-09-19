<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<script src="${cp}/resources/js/kalman.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
<script>
    var chartsdata = ${data};
    var p_data = ${p_data};
</script>

<script>
    var merictype = ${metric.getType().ordinal()};
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

//    console.log(predictend);
    //Error.getRegression().predict(Long.parseLong(startdate)/1000)    

    var echartLine;
    var series = [];
    var legend = [];
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var dates = [];
    var defserie = {
        name: null,
        type: 'boxplot',
        sampling: 'average',
        data: null
    };

    $(document).ready(function () {
        echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
        drawEchart(chartsdata);
    });


    function drawEchart(data)
    {
        var data = [];
        var datab = [];
        //TODO check host type for formater
        $(".time").each(function (index) {
            dates.push($(this).attr("value"));
            data.push({name: $(this).attr("value"),
                unit: s_formatter,
                value: [
                    parseFloat($(this).next().next().next().attr('value')),
                    parseFloat($(this).next().attr('value')) - parseFloat($(this).next().next().attr('value')),
                    parseFloat($(this).next().attr('value')),
                    parseFloat($(this).next().attr('value')) + parseFloat($(this).next().next().attr('value')),
                    parseFloat($(this).next().next().next().next().attr('value'))
                ],
                info: {Minimum: parseFloat($(this).next().next().next().attr('value')), Average: parseFloat($(this).next().attr('value')), Deviation: parseFloat($(this).next().next().attr('value')), Maximum: parseFloat($(this).next().next().next().next().attr('value'))}});
        });

        var serie2 = clone_obg(defserie);
        serie2.name = "Master data";
        serie2.type = "line";
        serie2.data = chartsdata;
        serie2.xAxisIndex = 1;
        series.push(serie2);


        var kalmanFilter = new KalmanFilter({R: 0.01, Q: 1});
//            console.log(series[0].data);
        var dataKalman = chartsdata.map(function (v) {
            var localjson = clone_obg(v);
            localjson.value[1] = kalmanFilter.filter(v.value[1]);
            return localjson;
        });
//            console.log(dataKalman);
        var localser = clone_obg(serie2);
        localser.name = "Kalman filter data";
        localser.data = dataKalman;
        series.push(localser);

        console.log(series);

        var serieLinereg = clone_obg(defserie);
        serieLinereg.name = "Predicted by regression";
        serieLinereg.type = "line";
        serieLinereg.data = p_data;
        serieLinereg.xAxisIndex = 1;
        serieLinereg.itemStyle = {};
        serieLinereg.itemStyle.color = "#00ff00";
//        serieLinereg.tooltip = {trigger: 'axis'};
        series.push(serieLinereg);

        var serie = clone_obg(defserie);
        serie.name = "Rule info";
//        serie.type = "bars";
        serie.data = data;
        serie.tooltip = {trigger: 'item'};
        serie.itemStyle = {normal: {borderColor: colorPalette[2], color: "rgba(200, 200, 200, 0.7)", borderWidth: 4}};
        series.push(serie);
        serie = clone_obg(serie);
        legend = ["Rule info", "Predicted by regression", "Master data", "Kalman filter data"];
        echartLine.setOption({
            title: {
                text: ""
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: "line"
                }
            },
            legend: {
                show: true,
                data: legend
            },
            animation: false,
            toolbox: {
                show: true,
                feature: {
                    magicType: {
                        show: false
                    },
                    saveAsImage: {
                        show: true,
                        title: "Save Image"
                    }
                }
            },
            xAxis: [{
                    type: 'category',
                    splitArea: {
                        show: true
                    },
                    data: dates
                },
                {
                    type: 'time',
                    splitNumber: 30,
                    axisLine: {onZero: false}
                }],
            yAxis: [{
                    type: 'value',
                    scale: true,
                    splitArea: {
                        show: false
                    },
                    axisLabel: {
                        formatter: formatter
                    }
                }],
            dataZoom: [{
                    type: 'inside',
                    xAxisIndex: 1,
                    show: true,
                    start: 0,
                    end: 100
                }],
            grid: {
                left: 0,
                right: 20,
                top: 30,
                bottom: 5,
                containLabel: true
            },
            series: series
        });

    }
    ;

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
</script>
