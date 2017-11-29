<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="${cp}/resources/echarts/dist/echarts.min.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    var curentvalue = ${Error.getValue()};
    var chartsdata = ${chartdata};
    var echartLine;
    var series = [];
    var legend = [];
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
//TODO check host type for formater
    var defserie = {
        name: null,
        type: 'line',
        sampling: 'average',
        markPoint: {
            data: [
                {type: 'max', name: 'max', symbol: 'diamond', symbolSize: 20, itemStyle: {
                        normal: {
                            label: {position: "top", formatter: format_data}
                        }}},
                {type: 'min', name: 'min', symbol: 'triangle', symbolSize: 20, itemStyle: {normal: {label: {position: 'top', formatter: format_data}}}},
            ]
        },
        data: null
    };

    $(document).ready(function () {
        echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
        drawEchart(chartsdata);
    });


    function drawEchart(data)
    {
        for (var k in data) {
            var chartline = data[k];
            var chdata = [];

            for (var time in chartline.data) {

                var dateval = moment(time * 1);
//                    date.push(dateval.format("h:m:s"));
                dateval = moment(time * 1).dayOfYear(0);
//                dateval = moment(time * 1).year(0);
                chdata.push([dateval.toDate(), chartline.data[time]]);

            }
//                date.sort();            
            var serie = clone_obg(defserie);
            serie.data = chdata;
            if (k != "predict")
            {
                serie.name = moment(k * 1).format("YY/MM/DD");
                legend.push(moment(k * 1).format("YY/MM/DD"));
            } else
            {
                serie.name = 'predict';
                legend.push('predict');
                prserie = serie;
            }
            series.push(serie);
        }
        ;

        var serie = clone_obg(defserie);
        serie.name = "Curent Value";
        legend.push('Curent Value');
        serie.markLine = {
            data: [
                {name: 'Curentvalue', value: curentvalue, xAxis: prserie.data[0][0], yAxis: curentvalue}, // When xAxis is the category axis, value 1 will be understood as the index of the category axis. By xAxis: -1 | MAXNUMBER, markLine can reach the edge of the grid.
                {name: 'Curentvalue', xAxis: prserie.data[prserie.data.length - 1][0], yAxis: curentvalue}, // When xAxis is the category axis, String 'Wednesday' will be understood as matching the category axis text.
            ],
            itemStyle: {normal: {color: '#ff0000', label: {formatter: format_data}}}
        };
        serie.data = []
        series.push(serie);

        echartLine.setOption({
            title: {
                text: chartline.metric,
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                data: legend
            },
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
            grid: {
                x: 90,
                y: 40,
                x2: 20,
                y2: 80
            },
            xAxis: [{
                    type: 'time',
                }],
            yAxis: [{
                    type: 'value',
                    axisLabel: {
                        formatter: format_data
                    }
                }],
            dataZoom: [{
                    type: 'inside',
                    xAxisIndex: 0,
                    show: true,
                    start: 0,
                    end: 100
                }, {
                    show: true,
                    start: 0,
                    end: 100
                },
            ],
            series: series
        });

    }
    ;

    $('body').on("click", "#Clear_reg", function () {
        var sendData = {};
        sendData.hash = ${Error.hashCode()};
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
    })
</script>
