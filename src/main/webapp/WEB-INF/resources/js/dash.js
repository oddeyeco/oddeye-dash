/* global numbers, cp, colorPalette, format_metric, echarts, rangeslabels, dashJSONvar, PicerOptionSet1, cb, pickerlabel, $RIGHT_COL, moment */

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

function setdatabyQueryes(json, rowindex, widgetindex, url, redraw = false, callback = null, customchart = null)
{
    var widget = json[rowindex]["widgets"][widgetindex];
    var chart;
    if (customchart === null)
    {
        chart = json[rowindex]["widgets"][widgetindex].echartLine;
    } else
    {
        chart = customchart;
    }
    if (widget.tmpoptions)
    {
        widget.options = clone_obg(widget.tmpoptions);
        delete widget.tmpoptions;
    }

    widget.visible = !redraw;
    if (chart._dom.className !== "echart_line_single")
    {
        if (redraw)
        {
            if (chart._dom.getBoundingClientRect().bottom < 0)
            {
                widget.visible = false;
                return;
            }
            if (chart._dom.getBoundingClientRect().top > window.innerHeight)
            {
                widget.visible = false;
                return;
            }
        }
    }

    var k;
    if (!widget.options.legend)
    {
        widget.options.legend = {data: []};
    } else
    {
        widget.options.legend.data = [];
    }

    if (widget.options.toolbox.feature)
    {
        widget.options.toolbox.feature.magicType.show = (!(widget.type === "pie" || widget.type === "funnel" || widget.type === "gauge" || widget.type === "treemap"));
    }


    var start = "5m-ago";
    var end = "now";
    if (json.times)
    {
        if (json.times.pickerlabel === "Custom")
        {
            start = json.times.pickerstart;
            end = json.times.pickerend;
        } else
        {
            if (typeof (rangeslabels[json.times.pickerlabel]) !== "undefined")
            {
                start = rangeslabels[json.times.pickerlabel];
            }

        }
    }
    var count = widget.queryes.length;
    var oldseries = clone_obg(widget.options.series);
    widget.options.series = [];
    for (k in widget.queryes)
    {
        if ((typeof (widget.queryes[k])) === "string")
        {
            var query = widget.queryes[k];
        } else
        {
            var query = "metrics=" + widget.queryes[k].info.metrics + "&tags=" + widget.queryes[k].info.tags +
                    "&aggregator=" + widget.queryes[k].info.aggregator;
            if (!widget.queryes[k].info.downsamplingstate)
            {
                if (widget.queryes[k].info.downsample === "")
                {
                    if (dashJSONvar.times.generalds)
                    {
                        if (json.times.generalds[2] && json.times.generalds[0] && json.times.generalds[1])
                        {
                            query = query + "&downsample=" + json.times.generalds[0] + "-" + json.times.generalds[1];
                        }
                    }
                } else
                {
                    query = query + "&downsample=" + widget.queryes[k].info.downsample;
                }

            }
        }
        var uri = cp + "/" + url + "?" + query + "&startdate=" + start + "&enddate=" + end;
        chart.showLoading("default", {
            text: '',
            color: colorPalette[0],
            textColor: '#000',
            maskColor: 'rgba(255, 255, 255, 0)',
            zlevel: 0
        });
        var m_sample = widget.options.xAxis[0].m_sample;
        $.getJSON(uri, null, function (data) {

            if (Object.keys(data.chartsdata).length > 0)
            {
                if (widget.options.xAxis[0].type === "time")
                {
                    for (index in data.chartsdata)
                    {
                        if (Object.keys(data.chartsdata[index].data).length > 0)
                        {
//                            console.log();
                            var ser_index = widget.options.series.length;
                            if (oldseries[ser_index])
                            {
                                var series = clone_obg(oldseries[ser_index]);
                                series.data = [];
                            } else
                            {
                                var series = clone_obg(defserie);
                            }
                            if (!series.type)
                            {
                                series.type = widget.type;
                            }
                            if (!series.symbol)
                            {
                                series.symbol = widget.points;
                            }


                            var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                            if (widget.options.title)
                            {
                                var name2 = widget.options.title.text;
                            }

                            if (typeof (widget.queryes[k].info) !== "undefined")
                            {
                                if (widget.queryes[k].info.alias !== "")
                                {
                                    name = widget.queryes[k].info.alias;
                                    name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                    name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                }
                                if (widget.queryes[k].info.alias2)
                                {
                                    if (widget.queryes[k].info.alias2 !== "")
                                    {
                                        name2 = widget.queryes[k].info.alias2;
                                        name2 = name2.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                        name2 = name2.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                        name2 = name2.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    }
                                }
                            }

                            series.name = name;
                            widget.options.legend.data.push({"name": name});
                            var chdata = data.chartsdata[index].data;
                            series.data = [];
                            for (var ind in chdata)
                            {
//                                series.data[ind].push(widget.options.yAxis[0].unit);
                                series.data.push({value: chdata[ind], 'unit': widget.options.yAxis[0].unit, 'name': name2})
                            }
                            if (widget.stacked)
                            {
                                series.stack = "0";
                            }
                            if (widget.fill)
                            {
                                if (widget.fill !== "none")
                                {
                                    series.areaStyle = {normal: {opacity: widget.fill}};
                                }
                            }
                            if (widget.step)
                            {
                                if (widget.step !== "")
                                {
                                    series.step = widget.step;
                                }
                            }
                            widget.options.series.push(series);
                        }
                    }
                }

                if (widget.options.xAxis[0].type === "category")
                {
//                    widget.options.series = [];
                    var xdata = [];
                    var sdata = [];
                    var tmp_series_1 = {};

                    for (var index in data.chartsdata)
                    {

                        var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                        var name2 = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                        if (typeof (widget.queryes[k].info) !== "undefined")
                        {
                            if (widget.queryes[k].info.alias !== "")
                            {
                                name = widget.queryes[k].info.alias;
                                name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                            }
                            if (widget.queryes[k].info.alias2)
                            {
                                if (widget.queryes[k].info.alias2 !== "")
                                {
                                    name2 = widget.queryes[k].info.alias2;
                                    name2 = name2.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                    name2 = name2.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    name2 = name2.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                }
                            }
                        }

                        var chdata = [];
                        var val;
                        for (var ind in data.chartsdata[index].data) {
                            chdata.push(data.chartsdata[index].data[ind][1]);
                            val = data.chartsdata[index].data[ind][1];
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
                        var tmpname = name;
                        if (name2)
                        {
                            tmpname = name2;
                        }

                        if (!tmp_series_1[name])
                        {
                            tmp_series_1[name] = [];
                        }
                        tmp_series_1[name].push({value: Math.round(val * 100) / 100, name: tmpname});
                        sdata.push({value: val, name: name});
                    }

                    var radius = (100 / Object.keys(tmp_series_1).length);

                    if (radius < 25)
                    {
                        radius = 25;
                    }
                    var rows = Math.floor((Object.keys(tmp_series_1).length / 4)) + 1;
                    index = 1;
                    var row = 0;
                    if (widget.type === "treemap")
                    {

                        var ser_index = widget.options.series.length;
                        if (oldseries[ser_index])
                        {
                            var series = clone_obg(oldseries[ser_index]);
                            series.data = [];
                        } else
                        {
                            var series = clone_obg(defserie);
                        }

                        if (!series.type)
                        {
                            series.type = widget.type;
                        }

//                        var series = clone_obg(defserie);
                        data = [];
                        for (var key in tmp_series_1)
                        {
                            var val = 0;
                            var cildren = [];
                            for (var ind in tmp_series_1[key])
                            {
                                val = val + tmp_series_1[key][ind].value;
                                cildren.push({value: tmp_series_1[key][ind].value, name: tmp_series_1[key][ind].name});
                            }

                            data.push({value: val, name: key, children: cildren});
                        }
                        series.name = key;
//                        series.type = option.type;
                        widget.options.tooltip.trigger = 'item';
                        series.data = data;
                        widget.options.series.push(series);
                    } else
                    {
                        for (var key in tmp_series_1)
                        {
                            if (index > 4)
                            {
                                index = 1;
                                row++;
                            }
                            var ser_index = widget.options.series.length;
                            if (oldseries[ser_index])
                            {
                                var series = clone_obg(oldseries[ser_index]);
                                series.data = [];
                            } else
                            {
                                var series = clone_obg(defserie);
                            }

                            if (!series.type)
                            {
                                series.type = widget.type;
                            }
                            if (!series.name)
                            {
                                series.name = key;
                            }


                            if (series.type === "bar")
                            {

                                if (Object.keys(tmp_series_1).length === 1)
                                {
                                    series.itemStyle = {normal: {color: function (params) {
                                                return colorPalette[params.dataIndex];
                                            }}};
                                }
                                series.data = tmp_series_1[key];
                            } else
                            {
//                                console.log(widget.options);
                                series.data = tmp_series_1[key];
                                if (series.type === "gauge")
                                {
                                    for (i = 0; i < series.data.length; i++)
                                    {
                                        series.data[i].subname = series.data[i].name;
                                        series.data[i].name = key;
                                    }

                                }
                            }
                            widget.options.tooltip.trigger = 'item';
                            if (series.type === "line")
                            {
                                if (widget.fill)
                                {
                                    if (widget.fill !== "none")
                                    {
                                        series.areaStyle = {normal: {opacity: widget.fill}};
                                    }
                                }
                                if (widget.step)
                                {
                                    if (widget.step !== "")
                                    {
                                        series.step = widget.step;
                                    }
                                }
                                if (!series.symbol)
                                {
                                    series.symbol = widget.points;
                                }
                                if (widget.options.tooltip.trigger)
                                {
                                    widget.options.tooltip.trigger = 'axis';
                                }

                            }
                            var wr = radius * chart._dom.getBoundingClientRect().width / 100;
                            var hr = radius * chart._dom.getBoundingClientRect().height / 100;

                            if (series.type === "gauge")
                            {

                                if (!series.axisLabel)
                                {
                                    series.axisLabel = {};
                                }
                                series.axisLabel.formatter = '{value} kg';
                                var formatter = widget.options.yAxis[0].unit;

//                function
                                if (formatter === "none")
                                {
                                    delete series.axisLabel.formatter;
                                } else
                                {

                                    if (typeof (window[formatter]) === "function")
                                    {
                                        series.axisLabel.formatter = window[formatter];
                                    } else
                                    {
                                        series.axisLabel.formatter = formatter;
                                    }
                                }

                                if (widget.options.yAxis[0].min)
                                {
                                    if (!series.min)
                                    {
                                        series.min = widget.options.yAxis[0].min;
                                    }

                                }
                                if (widget.options.yAxis[0].max)
                                {
                                    if (!series.max)
                                    {
                                        series.max = widget.options.yAxis[0].max;
                                    }
                                }
                                var tmpradius = radius;
                                if (hr < wr)
                                {
                                    var tmpradius = radius + radius / 2;
                                }
                                if (tmpradius > 100)
                                    tmpradius = 95;
                                if (!widget.manual)
                                {
                                    series.radius = tmpradius - 3 + "%";
                                    if (hr < wr)
                                    {
                                        series.center = [index * radius - radius / 2 + '%', (row * tmpradius) + tmpradius / 2 + "%"];
                                    } else
                                    {
                                        series.center = [index * radius - radius / 2 + '%', wr * row + wr / 2];
                                    }
                                }
                            }

                            if (series.type === "pie")
                            {
                                if (!widget.manual)
                                {
                                    series.radius = radius - 3 + "%";

                                    if (hr < wr)
                                    {
                                        series.center = [index * radius - radius / 2 + '%', ((row + 1) * radius) + "%"];
                                    } else
                                    {
                                        series.center = [index * radius - radius / 2 + '%', wr * row + wr / 2];
                                    }
                                }


                            }
                            if (widget.stacked)
                            {
                                series.stack = "0";
                            }
                            if (series.type === "funnel")
                            {
                                delete series.axisLine;
                                delete series.max;
                                delete series.min;
                                delete series.radius;
                                delete series.center;
                                if (row !== 1)
                                {
                                    if (!series.sort)
                                    {
                                        series.sort = 'ascending';
                                    }

                                }

                                if (!series.itemStyle)
                                {
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
                                }
                                if (!series.width)
                                {
                                    series.width = radius - 5 + "%";
                                }

                                if (!series.height)
                                    series.height = 100 / rows - 5 + "%";
                                if (!series.x)
                                    series.x = index * radius - radius + '%';
                                if (!series.y)
                                    series.y = (row * 50 + 2.5) + "%";
                            }
                            index++;
//                            console.log(series);
                            widget.options.series.push(series);

                        }
                    }
                    widget.options.xAxis[0].data = [];
                    for (var ind in widget.options.series)
                    {
                        widget.options.series[ind].unit = widget.options.yAxis[0].unit;
                        if ((widget.type === "bar") || (widget.type === "line"))
                        {
                            for (var sind in widget.options.series[ind].data)
                            {
                                widget.options.series[ind].data[sind].unit = widget.options.yAxis[0].unit;
                                if (widget.options.xAxis[0].data.indexOf(widget.options.series[ind].data[sind].name) === -1)
                                {
                                    widget.options.xAxis[0].data.push(widget.options.series[ind].data[sind].name);
                                }

                            }

                        }
                        widget.options.legend.data.push(widget.options.series[ind].name);
                    }
                }

            }
            count--;
            if (count === 0)
            {

                for (var yindex in widget.options.yAxis)
                {
                    var formatter = widget.options.yAxis[yindex].unit;
                    if (formatter === "none")
                    {
                        delete widget.options.yAxis[yindex].axisLabel.formatter;
                    } else
                    {
                        if (!widget.options.yAxis[yindex].axisLabel)
                        {
                            widget.options.yAxis[yindex].axisLabel = {};
                        }
                        if (typeof (window[formatter]) === "function")
                        {
                            widget.options.yAxis[yindex].axisLabel.formatter = window[formatter];
                        } else
                        {
                            widget.options.yAxis[yindex].axisLabel.formatter = formatter;
                        }
                    }
                }
                if (redraw)
                {
                    for (var ind in widget.options.series)
                    {
                        delete widget.options.series[ind].type;
                        delete widget.options.series[ind].stack;
                    }
                    chart.setOption({series: widget.options.series});
                } else
                {
                    chart.setOption(widget.options);
                }
                chart.hideLoading();
                if (callback !== null)
                {
                    callback();
                }
                var GlobalRefresh = true;
                if (widget.times)
                {
                    if (widget.times.intervall)
                    {
                        if (widget.times.intervall !== "General")
                        {
                            GlobalRefresh = false;
                            clearTimeout(widget.timer);
                            widget.timer = setTimeout(function () {
                                setdatabyQueryes(json, rowindex, widgetindex, url, true, null, customchart);
                            }, widget.times.intervall);
                        }
                    }
                }
                if (GlobalRefresh)
                {
                    if (json.times.intervall)
                    {
                        widget.timer = setTimeout(function () {
                            setdatabyQueryes(json, rowindex, widgetindex, url, true, null, customchart);
                        }, json.times.intervall);
                    }
                }
            }


        });
}

}

var defserie = {
    name: null,
    sampling: 'average',
    data: null
};

defoption = {
    tooltip: {
        trigger: 'axis'
    },
    toolbox: {},
    xAxis: [{
            type: 'time'
        }],
    yAxis: [{
            type: 'value'
        }],
    dataZoom: [{
            type: 'inside',
            xAxisIndex: 0,
            show: true,
            start: 0,
            end: 100
        }],
    series: [defserie]
};
var definterval = 10000;

$('body').on("click", "#refresh", function () {
    repaint(true);
});
$('body').on("click", "#jsonReset", function () {
    chartForm.resetjson();
});

$('body').on("click", "#jsonApply", function () {
    chartForm.applyjson();
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
    var opt = dashJSONvar[row]["widgets"][index];
    showsingleChart(row, index, dashJSONvar, readonly, rebuildform, redraw, function () {
        var jsonstr = JSON.stringify(opt, jsonmaker);
        editor.set(JSON.parse(jsonstr));
    });
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
            if (typeof (dashJSON[rowindex]["widgets"][widgetindex].options) === "undefined")
            {
                dashJSON[rowindex]["widgets"][widgetindex].options = defoption;
                dashJSON[rowindex]["widgets"][widgetindex].options.series[0].symbol = "none";
                dashJSON[rowindex]["widgets"][widgetindex].options.series[0].data = datafunc();
            }


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
                setdatabyQueryes(dashJSON, rowindex, widgetindex, "getdata", redraw);
//                        console.log(dashJSON[rowindex]["widgets"][widgetindex].echartLine);
            } else
            {
                if (dashJSON[rowindex]["widgets"][widgetindex].options.series.length === 1)
                {
                    if (!dashJSON[rowindex]["widgets"][widgetindex].options.series[0].data)
                    {
                        dashJSON[rowindex]["widgets"][widgetindex].options.series[0].data = datafunc();
                    } else
                    if (dashJSON[rowindex]["widgets"][widgetindex].options.series[0].data.length === 0)
                    {
                        dashJSON[rowindex]["widgets"][widgetindex].options.series[0].data = datafunc();
                    }
                }
                dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'oddeyelight');
                if (!dashJSON[rowindex]["widgets"][widgetindex].options.series[0])
                {
                    dashJSON[rowindex]["widgets"][widgetindex].options.series[0] = {};
                }
                dashJSON[rowindex]["widgets"][widgetindex].options.series[0].type = "line";

                dashJSON[rowindex]["widgets"][widgetindex].echartLine.setOption(dashJSON[rowindex]["widgets"][widgetindex].options);
            }

            $("#charttemplate .chartsection").attr("id", "widget");

        }
}
}


var echartLine;

function showsingleChart(row, index, dashJSON, readonly = false, rebuildform = true, redraw = false, callback = null) {
    $(".fulldash").hide();
    if (rebuildform)
    {
        chartForm = null;
    }
    $(".editchartpanel").show();
    if (readonly)
    {

        $(".editchartpanel .savedash").hide();
        $(".editchartpanel h1").hide();
        $(".edit-form").hide();
        $(".echart_line_single").css("height", "");
    } else
    {
        $(".editchartpanel .savedash").show();
        $(".edit-form").show();
        $(".editchartpanel h1").show();
        if (typeof (dashJSON[row]["widgets"][index].height) !== "undefined")
        {
            if (dashJSON[row]["widgets"][index].height === "")
            {
                dashJSON[row]["widgets"][index].height = "300px";
            }
            $(".echart_line_single").css("height", dashJSON[row]["widgets"][index].height);
        } else
        {
            $(".echart_line_single").css("height", "300px");
        }
    }
//    


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
        setdatabyQueryes(dashJSON, row, index, "getdata", redraw, callback, echartLine);
//        setdatabyQueryes(dashJSON[row]["widgets"][index], "getdata", startdate, enddate, echartLine, redraw, callback);
    } else
    {
        echartLine.setOption(dashJSON[row]["widgets"][index].options);
    }
    if (rebuildform)
    {
        chartForm = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON);
}
}
;

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
    $('#global-down-sample').val(dashJSONvar.times.generalds[0]);
    $('#global-down-sample-ag').val(dashJSONvar.times.generalds[1]);
    //TODO Fix redraw
    var check = document.getElementById('global-downsampling-switsh');
    if (dashJSONvar.times.generalds[2])
    {
        if (check.checked !== dashJSONvar.times.generalds[2])
        {
            $(check).trigger('click');
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
    if (dashJSONvar.times.generalds)
    {
        $('#global-down-sample').val(dashJSONvar.times.generalds[0]);
        $('#global-down-sample-ag').val(dashJSONvar.times.generalds[1]);
        var check = document.getElementById('global-downsampling-switsh')
        if (check.checked !== dashJSONvar.times.generalds[2])
        {
            $(check).trigger('click');
        }
    }
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
        var label = pickerlabel;
        if (dashJSONvar.times.pickerlabel)
        {
            label = dashJSONvar.times.pickerlabel;
        }

        $('#reportrange span').html(label);
        if (label === "Custom")
        {
            PicerOptionSet1.startDate = moment(dashJSONvar.times.pickerstart);
            PicerOptionSet1.endDate = moment(dashJSONvar.times.pickerend);
            $('#reportrange span').html(PicerOptionSet1.startDate.format('MM/DD/YYYY H:m:s') + ' - ' + PicerOptionSet1.endDate.format('MM/DD/YYYY H:m:s'));

        } else
        {
            PicerOptionSet1.startDate = PicerOptionSet1.ranges[label][0];
            PicerOptionSet1.endDate = PicerOptionSet1.ranges[label][1];
        }

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

    var elems = document.querySelectorAll('.js-switch-general');
    for (var i = 0; i < elems.length; i++) {
        var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        elems[i].onchange = function () {
            dashJSONvar.times.generalds[2] = this.checked;
            repaint(true);
        };
    }
    ;

    $('body').on("change", "#global-down-sample-ag", function () {
        dashJSONvar.times.generalds[1] = $(this).val();
        repaint(true);
    });

    $('body').on("blur", "#global-down-sample", function () {
        dashJSONvar.times.generalds[0] = $(this).val();
        repaint(true);
    });

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
        if (!$(this).hasClass("ace_search_field"))
        {
            chartForm.chage($(this));
        }
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

    redrawAllJSON(dashJSONvar);
});

$('body').on("click", "#deleterowconfirm", function () {
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


$('body').on("click", "#showasjson", function () {
    $("#showjson").find('.btn-ok').attr('id', "applydashjson");
    var jsonstr = JSON.stringify(dashJSONvar, jsonmaker);
    dasheditor.set(JSON.parse(jsonstr));
    $("#showjson").modal('show');
});

$('body').on("click", "#applydashjson", function () {
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


    dashJSONvar = dasheditor.get();

    $('#global-down-sample').val(dashJSONvar.times.generalds[0]);
    $('#global-down-sample-ag').val(dashJSONvar.times.generalds[1]);
    var check = document.getElementById('global-downsampling-switsh')
    if (check.checked !== dashJSONvar.times.generalds[2])
    {
        $(check).trigger('click');
    }
    if (dashJSONvar.times.intervall)
    {
        $("#refreshtime").val(dashJSONvar.times.intervall);
    }
    var label = pickerlabel;
    if (dashJSONvar.times.pickerlabel)
    {
        label = dashJSONvar.times.pickerlabel;
    }

    $('#reportrange span').html(label);
    if (label === "Custom")
    {
        PicerOptionSet1.startDate = moment(dashJSONvar.times.pickerstart);
        PicerOptionSet1.endDate = moment(dashJSONvar.times.pickerend);
        $('#reportrange span').html(PicerOptionSet1.startDate.format('MM/DD/YYYY H:m:s') + ' - ' + PicerOptionSet1.endDate.format('MM/DD/YYYY H:m:s'));

    } else
    {
        PicerOptionSet1.startDate = PicerOptionSet1.ranges[label][0];
        PicerOptionSet1.endDate = PicerOptionSet1.ranges[label][1];
    }
    redrawAllJSON(dashJSONvar);
    $("#showjson").modal('hide');
});

$('body').on("click", ".showrowjson", function () {
    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    $("#showjson").find('.btn-ok').attr('id', "applyrowjson");
    $("#showjson").find('.btn-ok').attr('index', rowindex);
    var jsonstr = JSON.stringify(dashJSONvar[rowindex], jsonmaker);
    dasheditor.set(JSON.parse(jsonstr));
    $("#showjson").modal('show');
});

$('body').on("click", "#applyrowjson", function () {
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

    var rowindex = $(this).attr("index");
    dashJSONvar[rowindex] = dasheditor.get();
    redrawAllJSON(dashJSONvar);
    $("#showjson").modal('hide');
});

$('body').on("click", ".minus", function () {


    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = $(this).parents(".chartsection").first().attr("index");
    if (dashJSONvar[rowindex]["widgets"][widgetindex].size > 1)
    {
        dashJSONvar[rowindex]["widgets"][widgetindex].size = dashJSONvar[rowindex]["widgets"][widgetindex].size - 1;
    }
//    redrawAllJSON(dashJSONvar);
});

$('body').on("click", ".plus", function () {

    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = $(this).parents(".chartsection").first().attr("index");
    if (dashJSONvar[rowindex]["widgets"][widgetindex].size < 12)
    {
        dashJSONvar[rowindex]["widgets"][widgetindex].size = dashJSONvar[rowindex]["widgets"][widgetindex].size + 1;
    }
//    redrawAllJSON(dashJSONvar);
});


$('body').on("click", "#deletewidgetconfirm", function () {

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

    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var curentwidgetindex = $(this).parents(".chartsection").first().attr("index");
    var widgetindex = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
    dashJSONvar[rowindex]["widgets"][widgetindex] = clone_obg(dashJSONvar[rowindex]["widgets"][curentwidgetindex]);
    delete  dashJSONvar[rowindex]["widgets"][widgetindex].echartLine;
    redrawAllJSON(dashJSONvar);
});

$('body').on("click", ".addchart", function () {
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
    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = numbers.basic.max(Object.keys(dashJSONvar[rowindex]["widgets"])) + 1;

    dashJSONvar[rowindex]["widgets"][widgetindex] = {type: "line"};
    dashJSONvar[rowindex]["widgets"][widgetindex].size = 12;

    redrawAllJSON(dashJSONvar);
    $('html, body').animate({
        scrollTop: dashJSONvar[rowindex]["widgets"][widgetindex].echartLine._dom.parent.getBoundingClientRect().top - 30
    }, 5);
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
                if (dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions)
                {
                    dashJSONvar[rowindex]["widgets"][widgetindex].options = clone_obg(dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions);
                    delete dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions;
                }

                for (var k in dashJSONvar[rowindex]["widgets"][widgetindex].options.series) {
                    dashJSONvar[rowindex]["widgets"][widgetindex].options.series[k].data = [];
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
//                    window.location.reload();
                    alert("Data saved")
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
    if ($('#axes_mode_x').val() === 'category') {
        $('.only-Series').show();
    } else {
        $('.only-Series').hide();
    }
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
    var request_W_index = getParameterByName("widget");
    var request_R_index = getParameterByName("row");
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

    $('html, body').animate({
        scrollTop: dashJSONvar[request_R_index]["widgets"][request_W_index].echartLine._dom.getBoundingClientRect().top
    }, 500);
    $RIGHT_COL.css('min-height', $(window).height());
});

var scrolltimer;
window.onscroll = function () {

    clearTimeout(scrolltimer);

    scrolltimer = setTimeout(function () {
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
                            setdatabyQueryes(dashJSONvar, rowindex, widgetindex, "getdata", false);
                        }
                    }
                }
            }
        }

    }, 1000);
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
                        setdatabyQueryes(dashJSONvar, rowindex, widgetindex, "getdata", false);
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