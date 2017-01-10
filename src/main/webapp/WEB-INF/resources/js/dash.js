function datafunc() {
    var d = [];
    var len = 0;
    while (len < 50) {
        d.push([
            new Date(2017, 9, 1, 0, len * 10000),
            (Math.random() * 500).toFixed(2) - 0
        ]);
        len++;
    }
    ;

    return d;
}
;


var defserie = {
    name: null,
    type: 'line',
    sampling: 'average',
    markPoint: {
        data: [
            {type: 'max', name: 'max', symbol: 'diamond', symbolSize: 20, itemStyle: {
                    normal: {
                        label: {position: "top", formatter: format_func}
                    }}},
            {type: 'min', name: 'min', symbol: 'triangle', symbolSize: 20, itemStyle: {normal: {label: {position: 'top', formatter: format_func}}}},
        ]
    },
    data: null
};

defoption = {
    title: {
        text: "Line Chart"
    },
    tooltip: {
        trigger: 'axis'
    },
    legend: {
        show: false,
        data: []
    },
    animation: true,
    toolbox: {
        show: true,
        feature: {
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
            type: 'time'
        }],
    yAxis: [{
            type: 'value',
            axisLabel: {
                formatter: format_func
            }
        }],
    dataZoom: {
        show: true,
        start: 0,
        end: 100
    },
    series: [defserie]
};


function redrawAllJSON(dashJSON)
{
    var rowindex;
    var widgetindex;
    $("#dashcontent").html("");
    for (rowindex in dashJSON)
    {
        $("#rowtemplate .widgetraw").attr("index", rowindex);
        $("#rowtemplate .widgetraw").attr("id", "row" + rowindex);
        var html = $("#rowtemplate").html();
        $("#dashcontent").append(html);
        $("#rowtemplate .widgetraw").attr("id", "row");
        for (widgetindex in    dashJSON[rowindex]["widgets"])
        {
            if (dashJSON[rowindex]["widgets"][widgetindex].type === "linechart")
            {
                $("#charttemplate .chartsection").attr("size", dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").attr("index", widgetindex);
                $("#charttemplate .chartsection").attr("id", "widget" + rowindex + "_" + widgetindex);
                $("#charttemplate .chartsection").attr("type", dashJSON[rowindex]["widgets"][widgetindex].type);
                $("#charttemplate .chartsection").attr("class", "chartsection col-lg-" + dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").find(".echart_line").attr("id", "echart_line" + rowindex + "_" + widgetindex);
                $("#row" + rowindex).find(".rowcontent").append($("#charttemplate").html());
                $("#charttemplate .chartsection").find(".echart_line").attr("id", "echart_line");
                if (typeof (dashJSON[rowindex]["widgets"][widgetindex].tmpoptions) === "undefined")
                {
                    dashJSON[rowindex]["widgets"][widgetindex].tmpoptions = defoption;
                    dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data = datafunc();
                } else
                {
                    if (dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data.length === 0)
                    {
                        dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data = datafunc();
                    }
                }
//                } 
//                else
//                {
//                    options = dashJSON[rowindex]["widgets"][widgetindex].echartLine.getOption();
//                }

                dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'macarons');
                dashJSON[rowindex]["widgets"][widgetindex].echartLine.setOption(dashJSON[rowindex]["widgets"][widgetindex].tmpoptions);

                $("#charttemplate .chartsection").attr("id", "widget");
            }
        }
    }
}