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

function setdatabyQueryes(option, url, start, end, chart)
{
//    console.log(option.queryes);
    var k;
    option.tmpoptions.series = [];
    for (k in option.queryes)
    {
        var query = option.queryes[k];
        var uri = cp + "/" + url + "?" + query + "&startdate=" + start + "&enddate=" + end;
        $.getJSON(uri, null, function (data) {
            if (Object.keys(data.chartsdata).length > 0)
            {
                for (index in data.chartsdata)
                {

                    var series = clone_obg(defserie);
                    var chdata = [];
                    for (var time in data.chartsdata[index].data) {
                        var dateval = moment(time * 1);
                        chdata.push([dateval.toDate(), data.chartsdata[index].data[time]]);
                        delete dateval;
                    }
                    series.data = chdata;
                    series.name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags)
//                    console.log(data.chartsdata[index]);
                    option.tmpoptions.series.push(series);

                }
            }
            chart.setOption(option.tmpoptions);
        });
    }

}


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

                    if (typeof (dashJSON[rowindex]["widgets"][widgetindex].queryes) !== "undefined")
                    {
                        dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'macarons');
                        var startdate = "5m-ago";
                        var enddate = "now";
                        if (pickerlabel == "Custom")
                        {
                            startdate = pickerstart;
                            enddate = pickerend;
                        } else
                        {
                            if (typeof (rangeslabels[pickerlabel]) !== "undefined")
                            {
                                startdate = rangeslabels[pickerlabel];
                            }

                        }

                        setdatabyQueryes(dashJSON[rowindex]["widgets"][widgetindex], "getdata", startdate, enddate, dashJSON[rowindex]["widgets"][widgetindex].echartLine);
                    } else
                    {
                        if (dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series.length == 1)
                        {
                            if (dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data.length === 0)
                            {
                                dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data = datafunc();
                            }
                        }
                        dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'macarons');
                        dashJSON[rowindex]["widgets"][widgetindex].echartLine.setOption(dashJSON[rowindex]["widgets"][widgetindex].tmpoptions);
                    }
                }
//                } 
//                else
//                {
//                    options = dashJSON[rowindex]["widgets"][widgetindex].echartLine.getOption();
//                }
                $("#charttemplate .chartsection").attr("id", "widget");
            }
        }
    }
}


var echartLine;

function showsingleChart(row, index, dashJSON, readonly = false) {
    $(".editchartpanel").show();
    if (readonly)
    {
        $(".edit-form").hide();
    } else
    {
        $(".edit-form").show();
    }
    echartLine = echarts.init(document.getElementById("echart_line_single"), 'macarons');
    if (typeof (dashJSON[row]["widgets"][index].queryes) !== "undefined")
    {

        var startdate = "5m-ago";
        var enddate = "now";
        if (pickerlabel == "Custom")
        {
            startdate = pickerstart;
            enddate = pickerend;
        } else
        {
            if (typeof (rangeslabels[pickerlabel]) !== "undefined")
            {
                startdate = rangeslabels[pickerlabel];
            }

        }
        setdatabyQueryes(dashJSON[row]["widgets"][index], "getdata", startdate, enddate, echartLine);
    } else
    {
        echartLine.setOption(dashJSON[row]["widgets"][index].tmpoptions);
    }
    chartForm = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON);
    $(".fulldash").hide();
}
;



// TODO To some global js    
function getParameterByName(name, url) {
    if (!url)
        url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
    if (!results)
        return null;
    if (!results[2])
        return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}