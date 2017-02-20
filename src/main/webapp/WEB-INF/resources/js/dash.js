/* global numbers, cp, colorPalette, format_metric, echarts, rangeslabels, dashJSONvar, PicerOptionSet1, cb, pickerlabel, $RIGHT_COL */

//var AllRedrawtimer;
var SingleRedrawtimer;
var refreshtimes =
        {
            "5000": "Refresh every 5s",
            "10000": "Refresh every 10s",
            "30000": "Refresh every 30s",
            "60000": "Refresh every 1m",
            "300000": "Refresh every 5m",
            "900000": "Refresh every 15m",
            "1800000": "Refresh every 30m",
            "3600000": "Refresh every 1h",
            "7200000": "Refresh every 2h",
            "86400000": "Refresh every 1d"
        };
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
    return d;
}

function replacer(tags) {
    return function (str, p1) {
        if (typeof tags[p1] === "undefined")
        {
            return "tag." + p1;
        }
        return tags[p1];
    };
}

function setdatabyQueryes(option, url, start, end, chart, redraw = false)
{
    option.visible = true;
    if (chart._dom.className !== "echart_line_single")
    {
        if (chart._dom.getBoundingClientRect().bottom < 0)
        {
            option.visible = false;
            return;
        }
        if (chart._dom.getBoundingClientRect().top > window.innerHeight)
        {
            option.visible = false;
            return;
        }
    }

    var k;
    option.tmpoptions.legend.data = [];
    option.tmpoptions.toolbox.feature.magicType.title = {
        line: 'Line',
        bar: 'Bar',
        stack: 'Stacked',
        tiled: 'Tiled'
    };
    option.tmpoptions.toolbox.feature.magicType.type = ['line', 'bar', 'stack', "tiled"];
    option.tmpoptions.toolbox.feature.magicType.show = (!(option.type === "pie" || option.type === "funnel"));

    for (k in option.queryes)
    {
        if ((typeof (option.queryes[k])) === "string")
        {
            var query = option.queryes[k];
        } else
        {
            var query = "metrics=" + option.queryes[k].info.metrics + "&tags=" + option.queryes[k].info.tags +
                    "&aggregator=" + option.queryes[k].info.aggregator;
            if (!option.queryes[k].info.downsamplingstate)
            {
                query = query + "&downsample=" + option.queryes[k].info.downsample;
            }
        }
        var uri = cp + "/" + url + "?" + query + "&startdate=" + start + "&enddate=" + end;
        chart.showLoading("default", {
            text: '',
            color: colorPalette[0],
            textColor: '#000',
            maskColor: 'rgba(255, 255, 255, 0.2)',
            zlevel: 0
        });
        var m_sample = option.tmpoptions.xAxis[0].m_sample;
        $.getJSON(uri, null, function (data) {
            option.tmpoptions.series = [];
            if (Object.keys(data.chartsdata).length > 0)
            {
                if (option.tmpoptions.xAxis[0].type === "time")
                {
                    for (index in data.chartsdata)
                    {
                        if (Object.keys(data.chartsdata[index].data).length > 0)
                        {
                            var series = clone_obg(defserie);
                            var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                            if (typeof (option.queryes[k].info) !== "undefined")
                            {
                                if (option.queryes[k].info.alias !== "")
                                {
                                    name = option.queryes[k].info.alias;
                                    name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                    name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                }
                            }
                            series.name = name;
                            option.tmpoptions.legend.data.push({"name": name});
                            var chdata = [];

                            for (var time in data.chartsdata[index].data) {
                                var dateval = moment(time * 1);
                                chdata.push([dateval.toDate(), data.chartsdata[index].data[time]]);
                                delete dateval;
                            }
                            series.data = chdata;
                            series.symbol = option.points;
                            if (option.stacked)
                            {
                                series.stack = "0";
                            }
                            series.type = option.type;
                            if (option.fill)
                            {
                                if (option.fill !== "none")
                                {
                                    series.areaStyle = {normal: {opacity: option.fill}};
                                }
                            }
                            if (option.step)
                            {
                                if (option.step !== "")
                                {
                                    series.step = option.step;
                                }
                            }
                            option.tmpoptions.series.push(series);
                        }
                    }
                    option.tmpoptions.tooltip.trigger = 'axis';
                }

                if (option.tmpoptions.xAxis[0].type === "category")
                {
                    option.tmpoptions.series = [];
                    var xdata = [];
                    var sdata = [];
                    var tmpseries = {};

                    for (var index in data.chartsdata)
                    {
                        var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                        if (typeof (option.queryes[k].info) !== "undefined")
                        {
                            if (option.queryes[k].info.alias !== "")
                            {
                                name = option.queryes[k].info.alias;
                                name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                            }
                        }
//                        console.log(xdata.indexOf(name));
                        if (xdata.indexOf(name) === -1)
                        {
                            xdata.push(name);
                            if ((option.type === "pie") || (option.type === "funnel"))
                            {
                                option.tmpoptions.legend.data.push(name);
                            }
                        }
                        var chdata = [];
                        var val;
                        for (var time in data.chartsdata[index].data) {
                            chdata.push(data.chartsdata[index].data[time]);
                            val = data.chartsdata[index].data[time];
                        }

                        if (m_sample === "avg")
                        {
                            val = numbers.statistic.mean(chdata);
                        }
                        if (m_sample === "min")
                        {
                            val = numbers.basic.min(chdata);
                        }
                        if (m_sample === "max")
                        {
                            val = numbers.basic.max(chdata);
                        }
                        if (m_sample === "total")
                        {
                            val = numbers.basic.sum(chdata);
                        }
                        if (m_sample === "product")
                        {
                            val = numbers.basic.product(chdata);
                        }
                        if (m_sample === "count")
                        {
                            val = chdata.length;
                        }

                        if ((option.type === "gauge"))
                        {
                            tmpseries[name] = {};
                            tmpseries[name][data.chartsdata[index].metric] = {data: {value: val, name: name}, min: 0, max: numbers.basic.max(chdata)};
                        } else
                        {
                            if (!tmpseries[data.chartsdata[index].metric])
                            {
                                tmpseries[data.chartsdata[index].metric] = [];
                            }
                            tmpseries[data.chartsdata[index].metric].push({value: val, name: name});
                        }
                        sdata.push({value: val, name: name});
                    }
                    var radius = (100 / Object.keys(tmpseries).length);
                    if (radius < 25)
                    {
                        radius = 25;
                    }
                    var rows = Math.floor((Object.keys(tmpseries).length / 5)) + 1;
                    var top = 50;
                    if (rows > 1)
                    {
                        top = 25;
                    }
                    index = 1;
                    var row = 0;
                    if (option.type === "treemap")
                    {
                        var series = clone_obg(defserie);
                        data = [];
                        for (var key in tmpseries)
                        {
                            var val = 0;
                            var cildren = [];
                            for (var ind in tmpseries[key])
                            {
                                val = val + tmpseries[key][ind].value;
                                cildren.push({value: tmpseries[key][ind].value, name: key + "." + tmpseries[key][ind].name});
                            }

                            data.push({value: val, name: key, children: cildren});
                        }
                        series.name = option.tmpoptions.title.text;
                        series.type = option.type;
                        option.tmpoptions.tooltip.trigger = 'item';
                        series.data = data;
                        option.tmpoptions.series.push(series);
                    } else
                    {
                        for (var key in tmpseries)
                        {
                            if (index > 4)
                            {
                                index = 1;
                                row++;
                            }

                            var series = clone_obg(defserie);
                            series.name = key;
                            if (option.type === "bar" || option.type === "gauge")
                            {
                                option.tmpoptions.legend.data.push(key);
                                if (Object.keys(tmpseries).length === 1)
                                {
                                    series.itemStyle = {normal: {color: function (params) {
                                                return colorPalette[params.dataIndex]
                                            }}};
                                }
                            }
                            if (option.type === "gauge")
                            {
                                for (var keyindex in tmpseries[key])
                                {
                                    if (!series.data)
                                    {
                                        series.data = [];
                                    }
                                    series.data.push(tmpseries[key][keyindex].data);
                                    series.min = tmpseries[key][keyindex].min;
                                    series.max = tmpseries[key][keyindex].max;
                                    if (option.tmpoptions.yAxis[0].min)
                                    {
                                        series.min = option.tmpoptions.yAxis[0].min;
                                    }
                                    if (option.tmpoptions.yAxis[0].max)
                                    {
                                        series.max = option.tmpoptions.yAxis[0].max;
                                    }
                                    series.axisLine = {
                                        lineStyle: {
                                            color: [[0.15, 'lime'], [0.85, '#1e90ff'], [1, '#ff4500']],
                                            width: 3,
                                            shadowColor: '#ccc', //默认透明
                                            shadowBlur: 10
                                        }
                                    }

                                }

                            } else
                            {
                                series.data = tmpseries[key];
                            }
                            series.type = option.type;
                            option.tmpoptions.tooltip.trigger = 'item';
                            if (option.type === "line")
                            {
                                if (option.fill)
                                {
                                    if (option.fill !== "none")
                                    {
                                        series.areaStyle = {normal: {opacity: option.fill}};
                                    }
                                }
                                if (option.step)
                                {
                                    if (option.step !== "")
                                    {
                                        series.step = option.step;
                                    }
                                }
                                series.symbol = option.points;
                                option.tmpoptions.tooltip.trigger = 'axis';
                            }
                            if (option.type === "pie")
                            {
                                series.radius = radius + "%";
                                series.center = [index * radius - radius / 2 + '%', (top + row * 50) + "%"];
                            }
                            if (option.type === "gauge")
                            {
                                series.radius = (radius-2) * 2  + "%";
                                series.center = [index * radius - radius / 2 + '%', (top + row * 50) + "%"];
                            }
                            if (option.stacked)
                            {
                                series.stack = "0";
                            }
                            if (option.type === "funnel")
                            {
                                if (row !== 1)
                                {
                                    series.sort = 'ascending';
                                }
                                series.itemStyle = {
                                    normal: {
                                        label: {
                                            position: 'right'
                                        },
                                        labelLine: {
                                            show: true
                                        }
                                    }
                                };
                                series.width = radius - 5 + "%";
                                series.height = 100 / rows - 5 + "%";
                                series.x = index * radius - radius + '%';
                                series.y = (row * 50 + 2.5) + "%";
                            }
                            index++;
                            option.tmpoptions.series.push(series);

                        }
                    }
                    option.tmpoptions.xAxis[0].data = xdata;
                }
            }

            for (var yindex in option.tmpoptions.yAxis)
            {
                var formatter = option.tmpoptions.yAxis[yindex].unit;

//                function
                if (formatter === "none")
                {
                    delete option.tmpoptions.yAxis[yindex].axisLabel.formatter;
                } else
                {
                    if (typeof (window[formatter]) === "function")
                    {
                        option.tmpoptions.yAxis[yindex].axisLabel.formatter = window[formatter];
                    } else
                    {
                        option.tmpoptions.yAxis[yindex].axisLabel.formatter = formatter;
                    }
                }
            }
            if (redraw)
            {
                chart.setOption({series: option.tmpoptions.series});
            } else
            {
                chart.setOption(option.tmpoptions);
            }
            chart.hideLoading();
            var GlobalRefresh = true;
            if (option.times)
            {
                if (option.times.intervall)
                {
                    if (option.times.intervall !== "General")
                    {
                        GlobalRefresh = false;
                        option.timer = setTimeout(function () {
                            setdatabyQueryes(option, url, start, end, chart, true);
                        }, option.times.intervall);
                    }
                }
            }
            if (GlobalRefresh)
            {
                if (dashJSONvar.times.intervall)
                {
                    option.timer = setTimeout(function () {
                        setdatabyQueryes(option, url, start, end, chart, true);
                    }, dashJSONvar.times.intervall);
                }
            }

        });
}

}

var defserie = {
    name: null,
    type: 'line',
    symbol: "none",
    sampling: 'average',
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
    animation: false,
    toolbox: {
        show: true,
        feature: {
            magicType: {
                show: true,
                title: {
                    line: 'Line',
                    bar: 'Bar',
                    stack: 'Stacked',
                    tiled: 'Tiled'
                },
                type: ['line', 'bar', 'stack', "tiled"]
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
                formatter: format_metric
            }
        }],
    dataZoom: {
        show: true,
        start: 0,
        end: 100
    },
    series: [defserie]
};
var definterval = 10000;

$('body').on("click", "#refresh", function () {
    repaint(true);
});

$('body').on("change", "#refreshtime", function () {
    dashJSONvar.times.intervall = $(this).val();
    repaint(true);
});

function AutoRefresh(redraw = false)
{
    redrawAllJSON(dashJSONvar, redraw);
//    if (dashJSONvar.times.intervall)
//    {
//        AllRedrawtimer = setTimeout(function () {
//            AutoRefresh(true);
//        }, dashJSONvar.times.intervall);
//}
}

function AutoRefreshSingle(row, index, readonly = false, rebuildform = true, redraw = false)
{
    showsingleChart(row, index, dashJSONvar, readonly, rebuildform, redraw);
//    if (dashJSONvar.times.intervall)
//    {
//        SingleRedrawtimer = setTimeout(function () {
//            AutoRefreshSingle(row, index, readonly, false, true);
//        }, dashJSONvar.times.intervall);
//}
}


function redrawAllJSON(dashJSON, redraw = false)
{

    var rowindex;
    var widgetindex;
    $(".editchartpanel").hide();
    $(".fulldash").show();
    if (!redraw)
    {
        $("#dashcontent").html("");
    }
    for (rowindex in dashJSON)
    {
        if (rowindex === "times")
        {
            continue;
        }
        if (!redraw)
        {
            $("#rowtemplate .widgetraw").attr("index", rowindex);
            $("#rowtemplate .widgetraw").attr("id", "row" + rowindex);
            var html = $("#rowtemplate").html();
            $("#dashcontent").append(html);
            $("#rowtemplate .widgetraw").attr("id", "row");
        }
        for (widgetindex in    dashJSON[rowindex]["widgets"])
        {
            if (!dashJSON[rowindex]["widgets"][widgetindex].echartLine || !redraw)
            {
                var bkgclass = "";
                if (typeof (dashJSON[rowindex]["widgets"][widgetindex].transparent) === "undefined")
                {
                    bkgclass = "chartbkg";

                } else
                {
                    if (dashJSON[rowindex]["widgets"][widgetindex].transparent)
                    {
                        bkgclass = "";
                    } else
                    {
                        bkgclass = "chartbkg";
                    }
                }


                $("#charttemplate .chartsection").attr("size", dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").attr("index", widgetindex);
                $("#charttemplate .chartsection").attr("id", "widget" + rowindex + "_" + widgetindex);
                $("#charttemplate .chartsection").attr("type", dashJSON[rowindex]["widgets"][widgetindex].type);
                $("#charttemplate .chartsection").attr("class", "chartsection " + bkgclass + " col-xs-12 col-md-" + dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").find(".echart_line").attr("id", "echart_line" + rowindex + "_" + widgetindex);
                $("#charttemplate .chartsection .echart_time").html("");
                if (dashJSON[rowindex]["widgets"][widgetindex].times)
                {
                    if (dashJSON[rowindex]["widgets"][widgetindex].times.pickerlabel)
                    {
                        if (dashJSON[rowindex]["widgets"][widgetindex].times.pickerlabel !== "Custom")
                        {
                            $("#charttemplate .chartsection .echart_time").append(dashJSON[rowindex]["widgets"][widgetindex].times.pickerlabel + " ");
                        } else
                        {
                            $("#charttemplate .chartsection .echart_time").append("From " + moment(dashJSON[rowindex]["widgets"][widgetindex].times.pickerstart).format('MM/DD/YYYY H:m:s') + " to " + moment(dashJSON[rowindex]["widgets"][widgetindex].times.pickerend).format('MM/DD/YYYY H:m:s') + " ");
                        }
                    }
                    if (dashJSON[rowindex]["widgets"][widgetindex].times.intervall)
                    {
                        if (dashJSON[rowindex]["widgets"][widgetindex].times.intervall !== "General")
                        {
                            $("#charttemplate .chartsection .echart_time").append(refreshtimes[dashJSON[rowindex]["widgets"][widgetindex].times.intervall]);
                        }
                    }

                }


                if (typeof (dashJSON[rowindex]["widgets"][widgetindex].height) !== "undefined")
                {
                    $("#charttemplate .chartsection").find(".echart_line").css("height", dashJSON[rowindex]["widgets"][widgetindex].height);
                    if (dashJSON[rowindex]["widgets"][widgetindex].height === "")
                    {
                        $("#charttemplate .chartsection").find(".echart_line").css("height", "300px");
                    }
                } else
                {
                    $("#charttemplate .chartsection").find(".echart_line").css("height", "300px");
                }
                $("#row" + rowindex).find(".rowcontent").append($("#charttemplate").html());
                $("#charttemplate .chartsection").find(".echart_line").attr("id", "echart_line");
            }
            if (typeof (dashJSON[rowindex]["widgets"][widgetindex].tmpoptions) === "undefined")
            {
                dashJSON[rowindex]["widgets"][widgetindex].tmpoptions = defoption;
                dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data = datafunc();
            } else
            {

                if (typeof (dashJSON[rowindex]["widgets"][widgetindex].queryes) !== "undefined")
                {
                    if (!dashJSON[rowindex]["widgets"][widgetindex].echartLine || !redraw)
                    {
                        dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'oddeyelight');
                    }
                    var startdate = "5m-ago";
                    var enddate = "now";
                    if (dashJSON.times)
                    {
                        if (dashJSON.times.pickerlabel === "Custom")
                        {
                            startdate = dashJSON.times.pickerstart;
                            enddate = dashJSON.times.pickerend;
                        } else
                        {
                            if (typeof (rangeslabels[dashJSON.times.pickerlabel]) !== "undefined")
                            {
                                startdate = rangeslabels[dashJSON.times.pickerlabel];
                            }

                        }
                    }
                    if (dashJSON[rowindex]["widgets"][widgetindex].times)
                    {
                        if (dashJSON[rowindex]["widgets"][widgetindex].times.pickerlabel === "Custom")
                        {
                            startdate = dashJSON[rowindex]["widgets"][widgetindex].times.pickerstart;
                            enddate = dashJSON[rowindex]["widgets"][widgetindex].times.pickerend;
                        } else
                        {
                            if (typeof (rangeslabels[dashJSON[rowindex]["widgets"][widgetindex].times.pickerlabel]) !== "undefined")
                            {
                                startdate = rangeslabels[dashJSON[rowindex]["widgets"][widgetindex].times.pickerlabel];
                            }

                        }
                    }
                    var chart = dashJSON[rowindex]["widgets"][widgetindex].echartLine;
                    setdatabyQueryes(dashJSON[rowindex]["widgets"][widgetindex], "getdata", startdate, enddate, chart, redraw);
//                        console.log(dashJSON[rowindex]["widgets"][widgetindex].echartLine);
                } else
                {
                    if (dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series.length === 1)
                    {
                        if (dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data.length === 0)
                        {
                            dashJSON[rowindex]["widgets"][widgetindex].tmpoptions.series[0].data = datafunc();
                        }
                    }
                    dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'oddeyelight');
                    dashJSON[rowindex]["widgets"][widgetindex].echartLine.setOption(dashJSON[rowindex]["widgets"][widgetindex].tmpoptions);
                }
            }
            $("#charttemplate .chartsection").attr("id", "widget");

        }
}
}


var echartLine;

function showsingleChart(row, index, dashJSON, readonly = false, rebuildform = true, redraw = false) {
    $(".fulldash").hide();
    if (rebuildform)
    {
        chartForm = null;
    }
    $(".editchartpanel").show();
    if (readonly)
    {
        $(".edit-form").hide();
    } else
    {
        $(".edit-form").show();
    }

    if (typeof (dashJSON[row]["widgets"][index].transparent) === "undefined")
    {
        $(".editchartpanel #singlewidget").addClass("chartbkg");

    } else
    {
        if (dashJSON[row]["widgets"][index].transparent)
        {
            $(".editchartpanel #singlewidget").removeClass("chartbkg");
        } else
        {
            $(".editchartpanel #singlewidget").addClass("chartbkg");
        }
    }
    if (!redraw)
    {
        echartLine = echarts.init(document.getElementById("echart_line_single"), 'oddeyelight');
//        console.log(echartLine._dom);
    }
    if (typeof (dashJSON[row]["widgets"][index].queryes) !== "undefined")
    {
        var startdate = "5m-ago";
        var enddate = "now";
        if (dashJSON.times)
        {
            if (dashJSON.times.pickerlabel === "Custom")
            {
                startdate = dashJSON.times.pickerstart;
                enddate = dashJSON.times.pickerend;
            } else
            {
                if (typeof (rangeslabels[dashJSON.times.pickerlabel]) !== "undefined")
                {
                    startdate = rangeslabels[dashJSON.times.pickerlabel];
                }

            }
        }
        if (dashJSON[row]["widgets"][index].times)
        {
            if (dashJSON[row]["widgets"][index].times.pickerlabel === "Custom")
            {
                startdate = dashJSON[row]["widgets"][index].times.pickerstart;
                enddate = dashJSON[row]["widgets"][index].times.pickerend;
            } else
            {
                if (typeof (rangeslabels[dashJSON[row]["widgets"][index].times.pickerlabel]) !== "undefined")
                {
                    startdate = rangeslabels[dashJSON[row]["widgets"][index].times.pickerlabel];
                }

            }
        }
        setdatabyQueryes(dashJSON[row]["widgets"][index], "getdata", startdate, enddate, echartLine, redraw);
    } else
    {
        echartLine.setOption(dashJSON[row]["widgets"][index].tmpoptions);
    }
    if (rebuildform)
    {
        chartForm = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON);
}
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


$('#reportrange').on('apply.daterangepicker', function (ev, picker) {
    var startdate = "5m-ago";
    var enddate = "now";
    if (dashJSONvar.times.pickerlabel === "Custom")
    {
        startdate = dashJSONvar.times.pickerstart;
        enddate = dashJSONvar.times.pickerend;
    } else
    {
        if (typeof (rangeslabels[dashJSONvar.times.pickerlabel]) !== "undefined")
        {
            startdate = rangeslabels[dashJSONvar.times.pickerlabel];
        }

    }
    for (var rowindex in dashJSONvar)
    {
        for (var widgetindex in    dashJSONvar[rowindex]["widgets"])
        {
            if (dashJSONvar[rowindex]["widgets"][widgetindex])
            {
                clearTimeout(dashJSONvar[rowindex]["widgets"][widgetindex].timer);
            }
        }
    }
    if ($(".editchartpanel").is(':visible'))
    {
        var request_W_index = getParameterByName("widget");
        var request_R_index = getParameterByName("row");
        var action = getParameterByName("action");

        showsingleChart(request_R_index, request_W_index, dashJSONvar, action !== "edit", false);
        if ($('#axes_mode_x').val() === 'category') {
            $('.only-Series').show();
        } else {
            $('.only-Series').hide();
        }
        $(".editchartpanel select").select2({minimumResultsForSearch: 15});
        $(".select2_group").select2({dropdownCssClass: "menu-select"});

    } else
    {
        window.history.pushState({}, "", "?&startdate=" + startdate + "&enddate=" + enddate);
        redrawAllJSON(dashJSONvar);
    }
});
function repaint(redraw = false) {
    var request_W_index = getParameterByName("widget");
    var request_R_index = getParameterByName("row");
    if ((request_W_index === null) && (request_R_index === null))
    {
        window.history.pushState({}, "", window.location.pathname);
        AutoRefresh(redraw);
    } else
    {
        var NoOpt = false;
        if (typeof (dashJSONvar[request_R_index]) === "undefined")
        {
            NoOpt = true;
        }

        if (!NoOpt)
        {
            if (typeof (dashJSONvar[request_R_index]["widgets"][request_W_index]) === "undefined")
            {
                NoOpt = true;
            }
        }

        if (NoOpt)
        {
            window.history.pushState({}, "", window.location.pathname);
            AutoRefresh(redraw);
        } else
        {
            var action = getParameterByName("action");
            AutoRefreshSingle(request_R_index, request_W_index, action !== "edit", true, redraw);
            if ($('#axes_mode_x').val() === 'category') {
                $('.only-Series').show();
            } else {
                $('.only-Series').hide();
            }
            $(".editchartpanel select").select2({minimumResultsForSearch: 15});
            $(".select2_group").select2({dropdownCssClass: "menu-select"});
        }
}
}
$(document).ready(function () {
    if (dashJSONvar.times)
    {
        if (dashJSONvar.times.intervall)
        {
            $("#refreshtime").val(dashJSONvar.times.intervall);
        }
        $('#reportrange span').html(dashJSONvar.times.pickerlabel);
        PicerOptionSet1.startDate = PicerOptionSet1.ranges[dashJSONvar.times.pickerlabel][0];
        PicerOptionSet1.endDate = PicerOptionSet1.ranges[dashJSONvar.times.pickerlabel][1];
    } else
    {
        dashJSONvar.times = {};
        $('#reportrange span').html(pickerlabel);
    }
    $("#refreshtime").select2({minimumResultsForSearch: 15});
    $('#reportrange').daterangepicker(PicerOptionSet1, cbJson(dashJSONvar, $('#reportrange')));
    var elems = document.querySelectorAll('.js-switch-small');
    for (var i = 0; i < elems.length; i++) {
        var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        elems[i].onchange = function () {
            if (chartForm !== null)
            {
                chartForm.chage($(this));
            }
        };
    }

    $('.cl_picer_input').colorpicker().on('hidePicker', function () {
        chartForm.chage($(this).find("input"));
    });
    $('.cl_picer_noinput').colorpicker({format: 'rgba'}).on('hidePicker', function () {
        chartForm.chage($(this).find("input"));
    });


    $('#button_title_subtitle').on('click', function () {
        $('#title_subtitle').fadeToggle(500, function () {
            if ($('#title_subtitle').css('display') === 'block')
            {
                $('#button_title_subtitle').removeClass("fa-chevron-circle-down");
                $('#button_title_subtitle').addClass("fa-chevron-circle-up");
            } else
            {
                $('#button_title_subtitle').removeClass("fa-chevron-circle-up");
                $('#button_title_subtitle').addClass("fa-chevron-circle-down");

            }
        });
    });

    $('#button_title_description').on('click', function () {
        $('#title_subdescription').fadeToggle(500, function () {
            if ($('#title_subdescription').css('display') === 'block')
            {
                $('#button_title_description').removeClass("fa-chevron-circle-down");
                $('#button_title_description').addClass("fa-chevron-circle-up");
            } else
            {
                $('#button_title_description').removeClass("fa-chevron-circle-up");
                $('#button_title_description').addClass("fa-chevron-circle-down");

            }
        });
    });

    $('#button_title_position').on('click', function () {
        $('#position_block').fadeToggle(500, function () {
            if ($('#position_block').css('display') === 'block')
            {
                $('#button_title_position i').removeClass("fa-chevron-circle-down");
                $('#button_title_position i').addClass("fa-chevron-circle-up");
            } else
            {
                $('#button_title_position i').removeClass("fa-chevron-circle-up");
                $('#button_title_position i').addClass("fa-chevron-circle-down");

            }
        });
    });

    $('#button_title_color').on('click', function () {
        $('#color_block').fadeToggle(500, function () {
            if ($('#color_block').css('display') === 'block')
            {
                $('#button_title_color i').removeClass("fa-chevron-circle-down");
                $('#button_title_color i').addClass("fa-chevron-circle-up");
            } else
            {
                $('#button_title_color i').removeClass("fa-chevron-circle-up");
                $('#button_title_color i').addClass("fa-chevron-circle-down");

            }
        });
    });

    $('#button_title_border').on('click', function () {
        $('#border_block').fadeToggle(500, function () {
            if ($('#border_block').css('display') === 'block')
            {
                $('#button_title_border i').removeClass("fa-chevron-circle-down");
                $('#button_title_border i').addClass("fa-chevron-circle-up");
            } else
            {
                $('#button_title_border i').removeClass("fa-chevron-circle-up");
                $('#button_title_border i').addClass("fa-chevron-circle-down");

            }
        });
    });

    repaint();

    $('body').on("mouseenter", ".select2-container--default .menu-select .select2-results__option[role=group]", function () {
        $(this).find("ul").css("top", $(this).position().top);
        var curent = $(this);
        if ($(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").length === 0)
        {
            curent.find("ul:hidden").show();
        } else
        {
            if ($(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").parents(".select2-results__option[role=group]").attr("aria-label") !== $(this).attr("aria-label"))
            {
                $(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").hide();
                curent.find("ul:hidden").show();
            }
        }

    });
    $('body').on("mouseleave", ".select2-container--default .menu-select", function () {
        $(".select2-container--default .menu-select .select2-results__option[role=group] ul").hide();
    });
});

$('body').on("click", "span.tag_label .fa-remove", function () {
    var input = $(this).parents(".data-label");
    $(this).parents(".tag_label").remove();
    chartForm.chage(input);
});

$('body').on("click", "span.tagspan .fa-pencil", function () {
    $(this).parents(".tagspan").hide();
    var input = $(this).parents(".data-label");
    if ($(this).parents(".tag_label").hasClass("query_metric"))
    {
        $(this).parents(".tagspan").after('<div class="edit"><input id="metrics" name="metrics" class="form-control query_input" type="text" value="' + $(this).parents(".tagspan").find(".text").html() + '"><a><i class="fa fa-check"></i></a><a><i class="fa fa-remove"></i></a></div>');
        var metricinput = $(this).parents(".tag_label").find("input");
        makeMetricInput(metricinput, input);
    }

    if ($(this).parents(".tag_label").hasClass("query_tag"))
    {
        var tag_arr = $(this).parents(".tagspan").find(".text").html().split("=");
        $(this).parents(".tagspan").after('<div class="edit"><input id="tagk" name="tagk" class="form-control query_input" type="text" value="' + tag_arr[0] + '"> </div><div class="edit"><input id="tagv" name="tagv" class="form-control query_input" type="text" value="' + tag_arr[1] + '"> <a><i class="fa fa-check"></i></a><a><i class="fa fa-remove"></i></a></div>');
        var tagkinput = $(this).parents(".tag_label").find("input#tagk");
        maketagKInput(tagkinput, input);
    }
});

function makeMetricInput(metricinput, wraper)
{
    var tags = "";
    wraper.parents("form").find(".query_tag .text").each(function () {
        tags = tags + $(this).text().replace("*", "(.*)") + ";";
    });
    var uri = cp + "/getfiltredmetricsnames?tags=" + tags + "&filter=^(.*)$";
    console.log(uri);
    $.getJSON(uri, null, function (data) {
        metricinput.autocomplete({
            lookup: data.data,
            minChars: 0
        });
    });
}

function maketagKInput(tagkinput, wraper) {
    var uri = cp + "/gettagkey?filter=^(.*)$";
    $.getJSON(uri, null, function (data) {

        var tagvinput = tagkinput.parent().next().find("#tagv");

        if (tagkinput.val() !== "")
        {
            var uri = cp + "/gettagvalue?key=" + tagkinput.val();
            $.getJSON(uri, null, function (data) {
                tagvinput.autocomplete({
                    lookup: data.data,
                    minChars: 0
                });
            });
        }
        tagkinput.autocomplete({
            lookup: data.data,
            minChars: 0,
            onSelect: function (suggestion) {
                var uri = cp + "/gettagvalue?key=" + suggestion.value;
                $.getJSON(uri, null, function (data) {
                    tagvinput.autocomplete({
                        lookup: data.data,
                        minChars: 0
                    });
                });

            }
        });
    });
}

$('body').on("click", ".query-label .fa-plus", function () {

    var input = $(this).parents(".form-group").find(".data-label");
    if (input.hasClass("metrics"))
    {
        input.append("<span class='control-label query_metric tag_label' ><span class='tagspan'><span class='text'></span><a><i class='fa fa-pencil'></i> </a> <a><i class='fa fa-remove'></i></a></span></span>");
        input.find(".tagspan").last().hide();
        input.find(".tagspan").last().after('<div class="edit"><input id="metrics" name="metrics" class="form-control query_input" type="text" value=""><a><i class="fa fa-check"></i></a><a><i class="fa fa-remove"></i></a></div>');
        var metricinput = input.find("input");
        makeMetricInput(metricinput, input);
    }

    if (input.hasClass("tags"))
    {
        input.append("<span class='control-label query_tag tag_label' ><span class='tagspan'><span class='text'></span><a><i class='fa fa-pencil'></i> </a> <a><i class='fa fa-remove'></i></a></span></span>");
        input.find(".tagspan").last().hide();
        input.find(".tagspan").last().after('<div class="edit"><input id="tagk" name="tagk" class="form-control query_input" type="text" value=""> </div><div class="edit"><input id="tagv" name="tagv" class="form-control query_input" type="text" value=""> <a><i class="fa fa-check"></i></a><a><i class="fa fa-remove"></i></a></div>');
        var tagkinput = input.find("input#tagk");
        maketagKInput(tagkinput, input);
    }
});
$('body').on("click", "span.tag_label .fa-check", function () {
    var input = $(this).parents(".form-group").find(".data-label");
    if (input.hasClass("metrics"))
    {
        var metricinput = input.find("input");
        if (metricinput.val() === "")
        {
            metricinput.parents(".tag_label").remove();
        } else
        {
            metricinput.parents(".tag_label").find(".text").html(metricinput.val());
            metricinput.parents(".tag_label").find(".tagspan").show();
            metricinput.parent().remove();
        }
    }
    if (input.hasClass("tags"))
    {

        var keyinput = input.find("#tagk");
        var valinput = input.find("#tagv");
        if (keyinput.val() === "")
        {
            keyinput.parents(".tag_label").remove();
        } else
        {
            if (valinput.val() === "")
            {
                valinput.val("*");
            }
            keyinput.parents(".tag_label").find(".text").html(keyinput.val() + "=" + valinput.val());
            keyinput.parents(".tag_label").find(".tagspan").show();
            keyinput.parent().remove();
            valinput.parent().remove();
        }
    }
    chartForm.chage(input);
});
$('body').on("blur", ".edit-form input", function () {
    if (!$(this).parent().hasClass("edit"))
    {
        chartForm.chage($(this));
    }
});
$('body').on("change", ".edit-form select", function () {
    chartForm.chage($(this));
});

$('body').on("change", ".edit-form select#axes_mode_x", function () {
    if ($(this).val() === 'category') {
        $('.only-Series').fadeIn();
    } else {
        $('.only-Series').fadeOut();
    }
});

$("#addrow").on("click", function () {
    dashJSONvar[Object.keys(dashJSONvar).length] = {widgets: {}};
    redrawAllJSON(dashJSONvar);
});

$('body').on("click", "#deleterowconfirm", function () {
    var rowindex = $(this).attr("index");
    delete dashJSONvar[rowindex];
    redrawAllJSON(dashJSONvar);
    $("#deleteConfirm").modal('hide');
});


$('body').on("click", ".deleterow", function () {
    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    $("#deleteConfirm").find('.btn-ok').attr('id', "deleterowconfirm");
    $("#deleteConfirm").find('.btn-ok').attr('index', rowindex);
    $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-ok btn-danger");
    $("#deleteConfirm").find('.modal-body p').html("Do you want to delete this Row?");
    $("#deleteConfirm").find('.modal-body .text-warning').html("");
    $("#deleteConfirm").modal('show');
});

$('body').on("click", ".minus", function () {
    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = $(this).parents(".chartsection").first().attr("index");
    if (dashJSONvar[rowindex]["widgets"][widgetindex].size > 1)
    {
        dashJSONvar[rowindex]["widgets"][widgetindex].size = dashJSONvar[rowindex]["widgets"][widgetindex].size - 1;
    }
    redrawAllJSON(dashJSONvar);
});

$('body').on("click", ".plus", function () {

    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = $(this).parents(".chartsection").first().attr("index");
    if (dashJSONvar[rowindex]["widgets"][widgetindex].size < 12)
    {
        dashJSONvar[rowindex]["widgets"][widgetindex].size = dashJSONvar[rowindex]["widgets"][widgetindex].size + 1;
    }
    redrawAllJSON(dashJSONvar);
});


$('body').on("click", "#deletewidgetconfirm", function () {
    var rowindex = $(this).attr("rowindex");
    var widgetindex = $(this).attr("widgetindex");
    delete dashJSONvar[rowindex]["widgets"][widgetindex];
    redrawAllJSON(dashJSONvar);
    $("#deleteConfirm").modal('hide');
});


$('body').on("click", ".deletewidget", function () {
    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = $(this).parents(".chartsection").first().attr("index");
    $("#deleteConfirm").find('.btn-ok').attr('id', "deletewidgetconfirm");
    $("#deleteConfirm").find('.btn-ok').attr('rowindex', rowindex);
    $("#deleteConfirm").find('.btn-ok').attr('widgetindex', widgetindex);
    $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-ok btn-danger");
    $("#deleteConfirm").find('.modal-body p').html("Do you want to delete this Panel?");
    $("#deleteConfirm").find('.modal-body .text-warning').html("");
    $("#deleteConfirm").modal('show');
});


$('body').on("click", ".dublicate", function () {
    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var curentwidgetindex = $(this).parents(".chartsection").first().attr("index");
    var widgetindex = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
    dashJSONvar[rowindex]["widgets"][widgetindex] = clone_obg(dashJSONvar[rowindex]["widgets"][curentwidgetindex]);
    delete  dashJSONvar[rowindex]["widgets"][widgetindex].echartLine;
    redrawAllJSON(dashJSONvar);
});

$('body').on("click", ".addchart", function () {
    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
    dashJSONvar[rowindex]["widgets"][widgetindex] = {type: "line"};
    itemcount = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
    if (itemcount < 4)
    {
        size = Math.round(12 / itemcount);
    } else
    {
        size = 3;
    }

    for (var key in dashJSONvar[rowindex]["widgets"])
    {
        dashJSONvar[rowindex]["widgets"][key].size = size;
    }
    redrawAllJSON(dashJSONvar);

});

$('body').on("click", "#deletedashconfirm", function () {
    url = cp + "/dashboard/delete";
    senddata = {};
    senddata.name = $("#name").val();
    var header = $("meta[name='_csrf_header']").attr("content");
    var token = $("meta[name='_csrf']").attr("content");
    $.ajax({
        url: url,
        data: senddata,
        dataType: 'json',
        type: 'POST',
        beforeSend: function (xhr) {
            xhr.setRequestHeader(header, token);
        },
        success: function (data) {
            if (data.sucsses)
            {
                window.location = cp + "/profile";
            }
            ;
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.status + ": " + thrownError);
        }
    });

});

$('body').on("click", ".deletedash", function () {
    $("#deleteConfirm").find('.btn-ok').attr('id', "deletedashconfirm");
    $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-ok btn-danger");
    $("#deleteConfirm").find('.modal-body p').html("Do you want to delete this dashboard?");
    $("#deleteConfirm").find('.modal-body .text-warning').html($("#name").val());
    $("#deleteConfirm").modal('show');
});

$('body').on("click", ".savedash", function () {
    var url = cp + "/dashboard/save";
    var to_senddata = {};
    var senddata = {};
    if (Object.keys(dashJSONvar).length > 0)
    {
        for (var rowindex in dashJSONvar)
        {
            for (var widgetindex in dashJSONvar[rowindex]["widgets"])
            {
                delete dashJSONvar[rowindex]["widgets"][widgetindex].echartLine;
                for (var k in dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions.series) {
                    dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions.series[k].data = [];
                }
            }
        }

        senddata.info = JSON.stringify(dashJSONvar);
        senddata.name = $("#name").val();
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        $.ajax({
            url: url,
            data: senddata,
            dataType: 'json',
            type: 'POST',
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            },
            success: function (data) {
                if (data.sucsses)
                {
                    window.location.reload();
                }
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status + ": " + thrownError);
            }
        });
    }
});

var single_rowindex = 0;
var single_widgetindex = 0;

$('body').on("click", ".editchart", function () {
    var single_rowindex = $(this).parents(".widgetraw").first().attr("index");
    var single_widgetindex = $(this).parents(".chartsection").first().attr("index");
    window.history.pushState({}, "", "?widget=" + single_widgetindex + "&row=" + single_rowindex + "&action=edit");
//    clearTimeout(AllRedrawtimer);
    for (var rowindex in dashJSONvar)
    {
        for (var widgetindex in    dashJSONvar[rowindex]["widgets"])
        {
            if (dashJSONvar[rowindex]["widgets"][widgetindex])
            {
                clearTimeout(dashJSONvar[rowindex]["widgets"][widgetindex].timer);
            }
        }
    }
    AutoRefreshSingle(single_rowindex, single_widgetindex);
    $(".editchartpanel select").select2({minimumResultsForSearch: 15});
    $(".select2_group").select2({dropdownCssClass: "menu-select"});
    $RIGHT_COL.css('min-height', $(window).height());
});

$('body').on("click", ".view", function () {
    var single_rowindex = $(this).parents(".widgetraw").first().attr("index");
    var single_widgetindex = $(this).parents(".chartsection").first().attr("index");
    window.history.pushState({}, "", "?widget=" + single_widgetindex + "&row=" + single_rowindex + "&action=view");
    for (var rowindex in dashJSONvar)
    {
        for (var widgetindex in    dashJSONvar[rowindex]["widgets"])
        {
            if (dashJSONvar[rowindex]["widgets"][widgetindex])
            {
                clearTimeout(dashJSONvar[rowindex]["widgets"][widgetindex].timer);
            }
        }
    }
    AutoRefreshSingle(single_rowindex, single_widgetindex, true, true);
    $RIGHT_COL.css('min-height', $(window).height());
});

$('body').on("click", ".backtodush", function () {
    $(".editchartpanel").hide();
    $(".fulldash").show();
    window.history.pushState({}, "", window.location.pathname);
    for (var rowindex in dashJSONvar)
    {
        for (var widgetindex in    dashJSONvar[rowindex]["widgets"])
        {
            if (dashJSONvar[rowindex]["widgets"][widgetindex])
            {
                clearTimeout(dashJSONvar[rowindex]["widgets"][widgetindex].timer);
            }
        }
    }
    AutoRefresh();
    $RIGHT_COL.css('min-height', $(window).height());
});


window.onscroll = function () {
    if ($(".fulldash").is(':visible'))
    {
        for (var rowindex in dashJSONvar)
        {
            for (var widgetindex in    dashJSONvar[rowindex]["widgets"])
            {
                if (dashJSONvar[rowindex]["widgets"][widgetindex])
                {
                    var chart = dashJSONvar[rowindex]["widgets"][widgetindex].echartLine;


                    var oldvisible = dashJSONvar[rowindex]["widgets"][widgetindex].visible;

                    dashJSONvar[rowindex]["widgets"][widgetindex].visible = true;
                    if (chart._dom.getBoundingClientRect().bottom < 0)
                    {
                        dashJSONvar[rowindex]["widgets"][widgetindex].visible = false;
                    }
                    if (chart._dom.getBoundingClientRect().top > window.innerHeight)
                    {
                        dashJSONvar[rowindex]["widgets"][widgetindex].visible = false;
                    }
                    if (!oldvisible && dashJSONvar[rowindex]["widgets"][widgetindex].visible)
                    {
                        var startdate = "5m-ago";
                        var enddate = "now";
                        if (dashJSONvar.times)
                        {
                            if (dashJSONvar.times.pickerlabel === "Custom")
                            {
                                startdate = dashJSONvar.times.pickerstart;
                                enddate = dashJSONvar.times.pickerend;
                            } else
                            {
                                if (typeof (rangeslabels[dashJSONvar.times.pickerlabel]) !== "undefined")
                                {
                                    startdate = rangeslabels[dashJSONvar.times.pickerlabel];
                                }

                            }
                        }
                        setdatabyQueryes(dashJSONvar[rowindex]["widgets"][widgetindex], "getdata", startdate, enddate, chart, false);
                    }
                }
            }
        }
    }
};

window.onresize = function () {
    if ($(".fulldash").is(':visible'))
    {
        for (var rowindex in dashJSONvar)
        {
            for (var widgetindex in    dashJSONvar[rowindex]["widgets"])
            {
                if (dashJSONvar[rowindex]["widgets"][widgetindex])
                {
                    var chart = dashJSONvar[rowindex]["widgets"][widgetindex].echartLine;
                    var oldvisible = dashJSONvar[rowindex]["widgets"][widgetindex].visible;
                    dashJSONvar[rowindex]["widgets"][widgetindex].visible = true;
                    if (chart._dom.getBoundingClientRect().bottom < 0)
                    {
                        dashJSONvar[rowindex]["widgets"][widgetindex].visible = false;
                    }
                    if (chart._dom.getBoundingClientRect().top > window.innerHeight)
                    {
                        dashJSONvar[rowindex]["widgets"][widgetindex].visible = false;
                    }
                    if (!oldvisible && dashJSONvar[rowindex]["widgets"][widgetindex].visible)
                    {
                        var startdate = "5m-ago";
                        var enddate = "now";
                        if (dashJSONvar.times)
                        {
                            if (dashJSONvar.times.pickerlabel === "Custom")
                            {
                                startdate = dashJSONvar.times.pickerstart;
                                enddate = dashJSONvar.times.pickerend;
                            } else
                            {
                                if (typeof (rangeslabels[dashJSONvar.times.pickerlabel]) !== "undefined")
                                {
                                    startdate = rangeslabels[dashJSONvar.times.pickerlabel];
                                }

                            }
                        }
                        setdatabyQueryes(dashJSONvar[rowindex]["widgets"][widgetindex], "getdata", startdate, enddate, chart, false);
                    }
                    chart.resize();
                }
            }
        }
    }
    if ($(".editchartpanel").is(':visible'))
    {
        echartLine.resize();
    }

};