<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>

    var chartsdata = ${data};
    var echartLine;
    var series = [];
    var legend = [];
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var dates = [];
    var defserie = {
        name: null,
        type: 'candlestick',
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
        var dataavg = [];
        $(".time").each(function () {
            dates.push($(this).attr("value"));
            data.push({name:$(this).attr("value"), value:[parseFloat($(this).next().attr('value')) - parseFloat($(this).next().next().attr('value')), parseFloat($(this).next().attr('value')) + parseFloat($(this).next().next().attr('value')), parseFloat($(this).next().next().next().attr('value')), parseFloat($(this).next().next().next().next().attr('value'))],info:{ Average : parseFloat($(this).next().attr('value')),Deviation: parseFloat($(this).next().next().attr('value')), Minimum:parseFloat($(this).next().next().next().attr('value')), Maximum:parseFloat($(this).next().next().next().next().attr('value'))}});
        })

        var serie = clone_obg(defserie);
        serie.name = "Rule for";
        serie.data = data;
        series.push(serie);


        var serie2 = clone_obg(defserie);
        serie2.name = "line";
        serie2.type = "line";
        serie2.data = chartsdata;
        serie2.xAxisIndex = 1;
        
        series.push(serie2);

//console.log(chartsdata);

        echartLine.setOption({
            title: {
                text: "",
            },
            tooltip: {                
                trigger: 'item'
            },
            legend: {
                data: legend
            },
            animation: false,
            toolbox: {
                show: true,
                feature: {
                    magicType: {
                        show: false,
                    },
                    saveAsImage: {
                        show: true,
                        title: "Save Image"
                    }
                }
            },
            xAxis: [{
                    type: 'category',
                    data: dates,
                },
                {
                    type: 'time',                    
                    axisLine: {onZero: false }
                }],
            yAxis: [{
                    type: 'value',
                    axisLabel: {
                        formatter: format_data
                    }
                }],
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
                alert("Message Sended ");
            } else
            {
                alert("Request failed");
            }
        }).fail(function (jqXHR, textStatus) {
            alert("Request failed");
        });
    });
</script>
