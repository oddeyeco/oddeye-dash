/* global numbers, cp, colorPalette, format_metric, echarts, rangeslabels, dashJSONvar, PicerOptionSet1, cb, pickerlabel, $RIGHT_COL, moment, jsonmaker */
var SingleRedrawtimer;
var editor;
var dasheditor;
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
function setdatabyQ(json, rowindex, widgetindex, url, redraw = false, callback = null, customchart = null)
{
    var widget = json[rowindex]["widgets"][widgetindex];
    clearTimeout(widget.timer);
    var chart;
    if (customchart === null)
    {
        chart = json[rowindex]["widgets"][widgetindex].echartLine;
    } else
    {
        chart = customchart;
    }
    if (chart === null)
    {
        return;
    }
    if (widget.tmpoptions)
    {
        widget.options = clone_obg(widget.tmpoptions);
        delete widget.tmpoptions;
    }
    widget.visible = !redraw;
    if (chart)
    {
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
        if ((widget.type === "pie" || widget.type === "funnel" || widget.type === "gauge" || widget.type === "treemap"))
        {
            if (widget.options.toolbox.feature)
            {
                widget.options.toolbox.feature.magicType.show = (!(widget.type === "pie" || widget.type === "funnel" || widget.type === "gauge" || widget.type === "treemap"));
            } else
            {
                widget.options.toolbox.feature = {magicType: {show: false}};
            }
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
        var usePersonalTime = false;
        if (widget.times)
        {
            if (widget.times.pickerlabel === "Custom")
            {
                start = widget.times.pickerstart;
                end = widget.times.pickerend;
                usePersonalTime = true;
            } else
            {
                if (typeof (rangeslabels[widget.times.pickerlabel]) !== "undefined")
                {
                    start = rangeslabels[widget.times.pickerlabel];
                    usePersonalTime = true;
                }

            }
        }

        var count = {"value": widget.q.length};
        var oldseries = clone_obg(widget.options.series);
        widget.options.series = [];
        for (k in widget.q)
        {
            if ((typeof (widget.q[k])) === "string")
            {
                var query = widget.q[k];
            } else if (widget.q[k].info)
            {
                var query = "metrics=" + widget.q[k].info.metrics + "&tags=" + widget.q[k].info.tags +
                        "&aggregator=" + widget.q[k].info.aggregator;
                if (widget.q[k].info.rate)
                {
                    query = query + "&rate=true";
                }

                if (!widget.q[k].info.downsamplingstate)
                {

                    if (!usePersonalTime)
                    {
                        if (widget.q[k].info.downsample === "")
                        {
                            if (json.times.generalds)
                            {
                                if (json.times.generalds[2] && json.times.generalds[0] && json.times.generalds[1])
                                {
                                    query = query + "&downsample=" + json.times.generalds[0] + "-" + json.times.generalds[1];
                                }
                            }
                        } else
                        {
                            query = query + "&downsample=" + widget.q[k].info.downsample;
                        }
                    } else
                    {
                        query = query + "&downsample=" + widget.q[k].info.downsample;
                    }

                }
            }


            var uri = cp + "/" + url + "?" + query + "&startdate=" + start + "&enddate=" + end;


            if (getParameterByName('metrics', uri))
            {
                chart.showLoading("default", {
                    text: '',
                    color: colorPalette[0],
                    textColor: '#000',
                    maskColor: 'rgba(255, 255, 255, 0)',
                    zlevel: 0
                });

                $.getJSON(uri, null, queryCallback(k, widget, oldseries, chart, count, json, rowindex, widgetindex, url, redraw, callback, customchart));

            }

        }
}
}

var queryCallback = function (q_index, widget, oldseries, chart, count, json, rowindex, widgetindex, url, redraw, callback, customchart)
{
    return function (data) {

        var m_sample = widget.options.xAxis[0].m_sample;
        if (data.chartsdata)
        {
            if (Object.keys(data.chartsdata).length > 0)
            {
                if (widget.options.xAxis[0].type === "time")
                {
                    for (index in data.chartsdata)
                    {
                        if (Object.keys(data.chartsdata[index].data).length > 0)
                        {
                            var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                            if (widget.options.title)
                            {
                                var name2 = widget.options.title.text;
                            }

                            if (typeof (widget.q[q_index].info) !== "undefined")
                            {
                                if (widget.q[q_index].info.alias !== "")
                                {
                                    name = widget.q[q_index].info.alias;
                                    name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                    name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                }
                                if (widget.q[q_index].info.alias2)
                                {
                                    if (widget.q[q_index].info.alias2 !== "")
                                    {
                                        name2 = widget.q[q_index].info.alias2;
                                        name2 = name2.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                        name2 = name2.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                        name2 = name2.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    }
                                }
                            }

                            var series = clone_obg(defserie);
                            for (var skey in oldseries)
                            {
                                if (oldseries[skey].name === name)
                                {
                                    series = clone_obg(oldseries[skey]);
                                    break;
                                }

                            }
                            series.data = [];
                            if (!widget.manual)
                            {
                                series.type = widget.type;
                                if ((widget.points !== "none") && (typeof (widget.points) !== "undefined"))
                                {
                                    series.showSymbol = true;
                                    series.symbol = widget.points;
                                } else
                                {
                                    delete series.symbol;
                                    delete series.showSymbol;
                                }

                            } else
                            {
                                if (!series.type)
                                {
                                    series.type = widget.type;
                                }
                                series.showSymbol = ((series.symbol !== "none") && (typeof (series.symbol) !== "undefined"));
                            }
                            series.name = name;
                            var chdata = data.chartsdata[index].data;
                            series.data = [];
                            for (var ind in chdata)
                            {
                                series.data.push({value: chdata[ind], 'unit': widget.options.yAxis[0].unit, 'name': name2});
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
                    var sdata = [];
                    var tmp_series_1 = {};

                    for (var index in data.chartsdata)
                    {

                        var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                        var name2 = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                        if (typeof (widget.q[q_index].info) !== "undefined")
                        {
                            if (widget.q[q_index].info.alias !== "")
                            {
                                name = widget.q[q_index].info.alias;
                                name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                            }
                            if (widget.q[q_index].info.alias2)
                            {
                                if (widget.q[q_index].info.alias2 !== "")
                                {
                                    name2 = widget.q[q_index].info.alias2;
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
                        tmp_series_1[name].push({value: Math.round(val * 100) / 100, name: tmpname, unit: widget.options.yAxis[0].unit});
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
                        name = "All";
                        var series = clone_obg(defserie);

                        for (var skey in oldseries)
                        {
                            if (oldseries[skey].name === name)
                            {
                                series = clone_obg(oldseries[skey]);

                                break;
                            }
                        }
                        series.data = [];
                        if (!widget.manual)
                        {
                            series.type = widget.type;
                        } else
                        {
                            if (!series.type)
                            {
                                series.type = widget.type;
                            }
                        }
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
                        series.name = "All";
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

                            var series = clone_obg(defserie);

                            for (var skey in oldseries)
                            {
                                if (oldseries[skey].name === key)
                                {
                                    series = clone_obg(oldseries[skey]);
                                    break;
                                }
                                if (!oldseries[skey].name)
                                {

                                    oldseries[skey].name = key;
                                    series = clone_obg(oldseries[skey]);
                                    break;
                                }
                            }

                            series.data = [];

                            if (!widget.manual)
                            {
                                series.type = widget.type;
                            } else
                            {
                                if (!series.type)
                                {
                                    series.type = widget.type;
                                }
                            }
                            series.name = key;
//                        console.log(key);
                            if (series.type === "bar")
                            {

                                if (Object.keys(tmp_series_1).length === 1)
                                {
                                    series.itemStyle = {normal: {color: function (params) {
                                                return colorPalette[params.dataIndex % colorPalette.length];
                                            }}};
                                }
                                series.data = tmp_series_1[key];
                            } else
                            {
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
                                var formatter = widget.options.yAxis[0].unit;
                                if (formatter === "none")
                                {
                                    delete series.axisLabel.formatter;
                                    delete series.detail.formatter;
                                } else
                                {
                                    if (!series.detail)
                                    {
                                        series.detail = {};
                                    }

                                    if (typeof (window[formatter]) === "function")
                                    {
                                        series.axisLabel.formatter = window[formatter];
                                        series.detail.formatter = window[formatter];
                                    } else
                                    {
                                        series.axisLabel.formatter = formatter;
                                        series.detail.formatter = formatter;
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

                                    if (Object.keys(tmp_series_1).length === 1)
                                    {

                                    } else
                                    {
                                        if (hr < wr)
                                        {
                                            series.center = [index * radius - radius / 2 + '%', ((row + 1) * radius) + "%"];
                                        } else
                                        {
                                            series.center = [index * radius - radius / 2 + '%', wr * row + wr / 2];
                                        }
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

                                if (!widget.manual)
                                {
                                    series.width = radius - 5 + "%";
                                    series.height = 100 / rows - 5 + "%";
                                    series.x = index * radius - radius + '%';
                                    series.y = (row * 50 + 2.5) + "%";

                                }

                            }
                            index++;
                            var dublicatename = false;

                            for (var s_index in widget.options.series)
                            {
                                if (widget.options.series[s_index].name === series.name)
                                {
                                    dublicatename = true;
                                    widget.options.series[s_index].data = widget.options.series[s_index].data.concat(series.data);

                                    widget.options.series[s_index].data.sort(function (a, b) {
                                        return compareStrings(a.name, b.name);
                                    });
                                    break;
                                }
                            }

                            if (!dublicatename)
                            {
                                widget.options.series.push(series);
                            }
                        }
                    }
                    widget.options.xAxis[0].data = [];
                }

            }
        }
        count.value--;
        if (count.value === 0)
        {
            widget.options.series.sort(function (a, b) {
                return compareStrings(a.name, b.name);
            });

            for (var ind in widget.options.series)
            {
                if (widget.options.xAxis[0].type === "category")
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

                    if ((widget.options.series[ind].type === "pie") || (widget.options.series[ind].type === "funnel"))
                    {
                        for (var sind in widget.options.series[ind].data)
                        {
                            if (widget.options.legend.data.indexOf(widget.options.series[ind].data[sind].name) === -1)
                            {
                                widget.options.legend.data.push(widget.options.series[ind].data[sind].name);
                            }

                        }
                    } else if (widget.options.series[ind].type === "treemap")
                    {

                        for (var sind in widget.options.series[ind].data)
                        {
                            if (widget.options.legend.data.indexOf(widget.options.series[ind].data[sind].name) === -1)
                            {
                                widget.options.legend.data.push(widget.options.series[ind].data[sind].name);
                            }

                        }
                    }

                }


                widget.options.legend.data.push(widget.options.series[ind].name);
                if ((redraw)&&(!widget.manual))
                {                    
                    delete(widget.options.series[ind].type);
                    delete(widget.options.series[ind].stack);
                }
            }
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
//            console.log(redraw);
            if (redraw)
            {
//                console.log(widget.options.series);
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
                        widget.timer = setTimeout(function () {
                            setdatabyQ(json, rowindex, widgetindex, url, true, null, customchart);
                        }, widget.times.intervall);
                    }
                }
            }
            if (GlobalRefresh)
            {
                if (json.times.intervall)
                {
                    widget.timer = setTimeout(function () {
                        setdatabyQ(json, rowindex, widgetindex, url, true, null, customchart);
                    }, json.times.intervall);
                }
            }
        }
    };
};

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
    if (!doapplyjson)
    {
        dashJSONvar.times.intervall = $(this).val();
        repaint(true);
    }

});

function AutoRefresh(redraw = false)
{
    redrawAllJSON(dashJSONvar, redraw);
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
            if (dashJSON[rowindex]["widgets"][widgetindex] == null)
            {

                delete(dashJSON[rowindex]["widgets"][widgetindex]);
                continue;
            }
            if (!dashJSON[rowindex]["widgets"][widgetindex].echartLine || !redraw)
            {
                var bkgclass = "";
                clearTimeout(dashJSONvar[rowindex]["widgets"][widgetindex].timer);
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
            if (typeof (dashJSON[rowindex]["widgets"][widgetindex].q) === "undefined")
            {
                dashJSON[rowindex]["widgets"][widgetindex].q = clone_obg(dashJSON[rowindex]["widgets"][widgetindex].queryes);
                delete dashJSON[rowindex]["widgets"][widgetindex].queryes;
            }


            if (typeof (dashJSON[rowindex]["widgets"][widgetindex].q) !== "undefined")
            {
                if (!dashJSON[rowindex]["widgets"][widgetindex].echartLine || !redraw)
                {
                    dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'oddeyelight');
                }
                setdatabyQ(dashJSON, rowindex, widgetindex, "getdata", redraw);
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
    }


    if (typeof (dashJSON[row]["widgets"][index].q) === "undefined")
    {
        dashJSON[row]["widgets"][index].q = clone_obg(dashJSON[row]["widgets"][index].queryes);
        delete dashJSON[row]["widgets"][index].queryes;
    }

    if (typeof (dashJSON[row]["widgets"][index].q) !== "undefined")
    {
        setdatabyQ(dashJSON, row, index, "getdata", redraw, callback, echartLine);
    } else
    {
        echartLine.setOption(dashJSON[row]["widgets"][index].options);
    }

    if (rebuildform)
    {
        chartForm = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON);
        $(".editchartpanel select").select2({minimumResultsForSearch: 15});
}
}
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
$('#reportrange_private').on('apply.daterangepicker', function (ev, picker) {
    var input = $('#reportrange_private');
    chartForm.change(input);
});

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
            $(check).attr('autoedit', true);
            $(check).trigger('click');
            $(check).removeAttr('autoedit');
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
    doapplyjson = true;
    if (dashJSONvar.times.generalds)
    {
        $('#global-down-sample').val(dashJSONvar.times.generalds[0]);
        $('#global-down-sample-ag').val(dashJSONvar.times.generalds[1]).trigger('change');
        var check = document.getElementById('global-downsampling-switsh');
        if (check.checked !== dashJSONvar.times.generalds[2])
        {
            $(check).attr('autoedit', true);
            $(check).trigger('click');
            $(check).removeAttr('autoedit');
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
            clearTimeout(dashJSONvar[request_R_index]["widgets"][request_W_index].timer);
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
    doapplyjson = false;
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
    $("#global-down-sample-ag").select2({minimumResultsForSearch: 15});
    $('#reportrange').daterangepicker(PicerOptionSet1, cbJson(dashJSONvar, $('#reportrange')));
    var elems = document.querySelectorAll('.js-switch-small');
    for (var i = 0; i < elems.length; i++) {
        var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        elems[i].onchange = function () {
            if (chartForm !== null)
            {
                chartForm.change($(this));
            }
        };
    }

    $('.cl_picer_input').colorpicker().on('hidePicker', function () {
        chartForm.change($(this).find("input"));
    });
    $('.cl_picer_noinput').colorpicker({format: 'rgba'}).on('hidePicker', function () {
        chartForm.change($(this).find("input"));
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
            if (!$(this).attr('autoedit'))
            {
                if (!dashJSONvar.times.generalds)
                {
                    dashJSONvar.times.generalds = [];
                }
                dashJSONvar.times.generalds[2] = this.checked;
                repaint(true);
            }

        };
    }

    $('body').on("change", "#global-down-sample-ag", function () {
        if (!doapplyjson)
        {
            if (!dashJSONvar.times.generalds)
            {
                dashJSONvar.times.generalds = [];
            }
            dashJSONvar.times.generalds[1] = $(this).val();
            repaint(true);
        }

    });

    $('body').on("blur", "#global-down-sample", function () {
        if (!dashJSONvar.times.generalds)
        {
            dashJSONvar.times.generalds = [];
        }
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

    var options = {modes: ['form', 'tree', 'code'], mode: 'code'};
    editor = new JSONEditor(document.getElementById("jsoneditor"), options);
    dasheditor = new JSONEditor(document.getElementById("dasheditor"), options);
});

$('body').on("click", "span.tag_label .fa-remove", function () {
    var input = $(this).parents(".data-label");
    $(this).parents(".tag_label").remove();
    chartForm.change(input);
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
    var uri = cp + "/getfiltredmetricsnames?tags=" + tags + "&filter=" + encodeURIComponent("^(.*)$");

    $.getJSON(uri, null, function (data) {
        metricinput.autocomplete({
            lookup: data.data,
            minChars: 0
        });
    });
}

function maketagKInput(tagkinput, wraper) {
    var uri = cp + "/gettagkey?filter=" + encodeURIComponent("^(.*)$");
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
    chartForm.change(input);
});
$('body').on("blur", ".edit-form input", function () {
    if (!$(this).parent().hasClass("edit"))
    {
        if (!$(this).hasClass("ace_search_field"))
        {
            chartForm.change($(this));
        }
    }
});

$('body').on("change", ".edit-form select", function () {
    chartForm.change($(this));
});

$('body').on("click", ".edit-form #tab_metrics .btn", function () {
    chartForm.change($(this));
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

var doapplyjson = false;

$('body').on("click", "#applydashjson", function () {

    doapplyjson = true;

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
    redrawAllJSON(dashJSONvar);

    if (dashJSONvar.times.generalds)
    {
        $('#global-down-sample').val(dashJSONvar.times.generalds[0]);
        $('#global-down-sample-ag').val(dashJSONvar.times.generalds[1]).trigger('change');
        var check = document.getElementById('global-downsampling-switsh');
        if (check.checked !== dashJSONvar.times.generalds[2])
        {
            $(check).attr('autoedit', true);
            $(check).trigger('click');
            $(check).removeAttr('autoedit');
        }
    }
    if (dashJSONvar.times.intervall)
    {
        $("#refreshtime").val(dashJSONvar.times.intervall).trigger('change');
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

    $("#showjson").modal('hide');
    doapplyjson = false;
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
        var olssize = dashJSONvar[rowindex]["widgets"][widgetindex].size;
        dashJSONvar[rowindex]["widgets"][widgetindex].size = parseInt(dashJSONvar[rowindex]["widgets"][widgetindex].size) - 1;
        $(this).parents(".chartsection").attr("size", dashJSONvar[rowindex]["widgets"][widgetindex].size);
        $(this).parents(".chartsection").removeClass("col-md-" + olssize).addClass("col-md-" + dashJSONvar[rowindex]["widgets"][widgetindex].size);
        dashJSONvar[rowindex]["widgets"][widgetindex].echartLine.resize();

    }

});

$('body').on("click", ".plus", function () {

    var rowindex = $(this).parents(".widgetraw").first().attr("index");
    var widgetindex = $(this).parents(".chartsection").first().attr("index");
    if (dashJSONvar[rowindex]["widgets"][widgetindex].size < 12)
    {

        var olssize = dashJSONvar[rowindex]["widgets"][widgetindex].size;
        dashJSONvar[rowindex]["widgets"][widgetindex].size = parseInt(dashJSONvar[rowindex]["widgets"][widgetindex].size) + 1;
        $(this).parents(".chartsection").attr("size", dashJSONvar[rowindex]["widgets"][widgetindex].size);
        $(this).parents(".chartsection").removeClass("col-md-" + olssize).addClass("col-md-" + dashJSONvar[rowindex]["widgets"][widgetindex].size);
        dashJSONvar[rowindex]["widgets"][widgetindex].echartLine.resize();
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

    var widgetindex = 0;

    if (dashJSONvar[rowindex]["widgets"])
    {
        if (Object.keys(dashJSONvar[rowindex]["widgets"]).length > 0)
        {
            widgetindex = Math.max.apply(null, Object.keys(dashJSONvar[rowindex]["widgets"])) + 1;
        }

    } else
    {
        dashJSONvar[rowindex].widgets = [];
    }
    dashJSONvar[rowindex]["widgets"][widgetindex] = {type: "line"};
    dashJSONvar[rowindex]["widgets"][widgetindex].size = 12;

    //TODO DRAW 1 chart    
    redrawAllJSON(dashJSONvar);
    $('html, body').animate({
        scrollTop: dashJSONvar[rowindex]["widgets"][widgetindex].echartLine._dom.getBoundingClientRect().top - 60
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
                window.location = cp + "/dashboard/";
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
                    var uri = cp + "/dashboard/" + senddata.name;
                    var request_W_index = getParameterByName("widget");
                    var request_R_index = getParameterByName("row");
                    if (request_W_index === null)
                    {
                        if (window.location.pathname !== uri)
                        {
                            window.location.href = uri;
                        } else
                        {
                            alert("Data saved");
                        }
                    } else
                    {
                        if (request_R_index !== null)
                        {
                            uri = uri + "?widget=" + request_W_index + "&row=" + request_R_index + "&action=edit";
//                            console.log(window.location.pathname + "?" + window.location.search);
//                            console.log(uri);
                            if (window.location.pathname + window.location.search !== uri)
                            {
                                window.location.href = uri;
                            } else
                            {
                                alert("Data saved");
                            }
                        }

                    }
                }
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status + ": " + thrownError);
            }
        });
    }
});


$('body').on("click", ".savedashasTemplate", function () {
    var url = cp + "/dashboard/savetemplate";
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
                        if (chart !== null)
                        {
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
                                if (typeof (dashJSONvar[rowindex]["widgets"][widgetindex].q) !== "undefined")
                                {
                                    setdatabyQ(dashJSONvar, rowindex, widgetindex, "getdata", false);
                                }
                            }
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
                        if (typeof (dashJSONvar[rowindex]["widgets"][widgetindex].q) !== "undefined")
                        {
                            setdatabyQ(dashJSONvar, rowindex, widgetindex, "getdata", false);
                        }
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

$('body').on("click", ".csv", function () {
    var single_rowindex = $(this).parents(".widgetraw").first().attr("index");
    var single_widgetindex = $(this).parents(".chartsection").first().attr("index");
    var csvarray = [];
    csvarray.push([dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.title.text]);
    if (dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.xAxis[0].type === "time")
    {
        for (var seriesindex in dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.series)
        {
            var Ser = dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.series[seriesindex];
            csvarray.push([Ser.name]);
            for (var dataind in Ser.data)
            {
                csvarray.push([Ser.name, new Date(Ser.data[dataind].value[0]), Ser.data[dataind].value[1]]);
            }
        }
    }
    if (dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.xAxis[0].type === "category")
    {
        for (var seriesindex in dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.series)
        {
            var Ser = dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.series[seriesindex];
            csvarray.push([Ser.name]);
            for (var dataind in Ser.data)
            {
                csvarray.push([Ser.data[dataind].name, Ser.data[dataind].value]);
            }
        }
    }

    exportToCsv(dashJSONvar[single_rowindex]["widgets"][single_widgetindex].options.title.text + ".csv", csvarray);

});