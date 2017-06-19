/* global numbers, cp, colorPalette, format_metric, echarts, rangeslabels, dashJSONvar, PicerOptionSet1, cb, pickerlabel, $RIGHT_COL, moment, jsonmaker */
var SingleRedrawtimer;
var dasheditor;
var refreshtimes = {
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
var echartLine;
var defserie = {
    name: null,
    data: null
};
var defoption = {
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
var doapplyjson = false;
var single_rowindex = 0;
var single_widgetindex = 0;
var scrolltimer;


var queryCallback = function (q_index, widget, oldseries, chart, count, json, rowindex, widgetindex, url, redraw, callback, customchart, end) {
    return function (data) {
        var m_sample = widget.options.xAxis[0].m_sample;

        if (data.chartsdata)
        {
            if (Object.keys(data.chartsdata).length > 0)
            {
                var xAxis_Index = 0;
                {
                    if (widget.q[q_index].xAxisIndex)
                    {
                        xAxis_Index = widget.q[q_index].xAxisIndex[0];
                    }
                    if (!widget.options.xAxis[xAxis_Index])
                    {
                        xAxis_Index = 0;
                    }
                }
                if (widget.options.xAxis[xAxis_Index].type === "time")
                {
                    if (end === "now")
                    {
                        widget.options.xAxis[xAxis_Index].max = new Date().getTime();
                    } else
                    {
                        widget.options.xAxis[xAxis_Index].max = end;
                    }


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
                                if (widget.q[q_index].info.alias)
                                {
                                    if (widget.q[q_index].info.alias !== "")
                                    {
                                        name = widget.q[q_index].info.alias;
                                        name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                        name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                        name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    }
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
                                if (widget.q[q_index].yAxisIndex)
                                {
                                    series.yAxisIndex = [];
                                    for (var ax in widget.q[q_index].yAxisIndex)
                                    {
                                        if (widget.options.yAxis[widget.q[q_index].yAxisIndex[ax]])
                                        {
                                            series.yAxisIndex.push(widget.q[q_index].yAxisIndex[ax]);
                                        }

                                    }
                                    if (series.yAxisIndex.length === 0)
                                    {
                                        delete series.yAxisIndex;
                                    }

                                } else
                                {
                                    delete series.yAxisIndex;
                                }
                                if (widget.q[q_index].xAxisIndex)
                                {
                                    series.xAxisIndex = [];
                                    for (var ax in widget.q[q_index].xAxisIndex)
                                    {
                                        if (widget.options.xAxis[widget.q[q_index].xAxisIndex[ax]])
                                        {
                                            series.xAxisIndex.push(widget.q[q_index].xAxisIndex[ax]);
                                        }

                                    }
                                    if (series.xAxisIndex.length === 0)
                                    {
                                        delete series.xAxisIndex;
                                    }
                                } else
                                {
                                    delete series.xAxisIndex;
                                }
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
                            var yAxis = 0;
                            if (series.yAxisIndex)
                            {
                                if (series.yAxisIndex === Array)
                                {
                                    yAxis = series.yAxisIndex[0];
                                } else
                                {
                                    yAxis = series.yAxisIndex;
                                }
                            }
                            if (!widget.options.yAxis[yAxis])
                            {
                                yAxis = 0;
                            }

                            for (var ind in chdata)
                            {
                                var val = chdata[ind];
                                if (widget.q[q_index].info.inverse)
                                {
                                    val[1] = -1 * val[1];
                                }
                                switch (widget.type) {
                                    case 'pie':
                                    {
                                        series.data.push({value: val[1], 'unit': widget.options.yAxis[yAxis].unit, 'name': moment(val[0]).format('YYYY-MM-DD hh:mm'), isinverse: widget.q[q_index].info.inverse});
                                        break;
                                    }
                                    case 'bar':
                                    {
                                        series.data.push({value: val, 'unit': widget.options.yAxis[yAxis].unit, 'name': name2, isinverse: widget.q[q_index].info.inverse});
                                        break;
                                    }
                                    case 'line':
                                    {
                                        series.data.push({value: val, 'unit': widget.options.yAxis[yAxis].unit, 'name': name2, isinverse: widget.q[q_index].info.inverse});
                                        break;
                                    }
                                    default:
                                    {
                                        break
                                    }
                                }


                            }
                            var yAxis = 0;
                            if (series.yAxisIndex)
                            {
                                yAxis = series.yAxisIndex[0];
                            }
                            if (widget.stacked)
                            {
                                series.stack = "stack" + yAxis;
                            } else
                            {
                                delete series.stack;
                            }

                            if (typeof (widget.smooth) !== "undefined")
                            {
                                series.smooth = widget.smooth;
                            } else
                            {
                                delete series.smooth;
                            }

                            if (widget.fill)
                            {
                                if (widget.fill !== "none")
                                {
                                    series.areaStyle = {normal: {opacity: widget.fill}};
                                } else {
                                    delete series.areaStyle;
                                }
                            }
                            if (widget.step)
                            {
                                if (widget.step !== "")
                                {
                                    series.step = widget.step;
                                }
                            } else
                            {
                                delete series.step;
                            }
                            widget.options.series.push(series);
                        }
                    }
                }

                if (widget.options.xAxis[xAxis_Index].type === "category")
                {

                    delete widget.options.xAxis[xAxis_Index].max;
                    var sdata = [];
                    var tmp_series_1 = {};

                    for (var index in data.chartsdata)
                    {

                        var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                        var name2 = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                        if (typeof (widget.q[q_index].info) !== "undefined")
                        {
                            if (widget.q[q_index].info.alias)
                            {
                                if (widget.q[q_index].info.alias !== "")
                                {
                                    name = widget.q[q_index].info.alias;
                                    name = name.replace(new RegExp("\\{metric\\}", 'g'), data.chartsdata[index].metric);//"$2, $1"
                                    name = name.replace(new RegExp("\\{\w+\\}", 'g'), replacer(data.chartsdata[index].tags));
                                    name = name.replace(new RegExp("\\{tag.([A-Za-z0-9_]*)\\}", 'g'), replacer(data.chartsdata[index].tags));
                                }

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
                        if (widget.q[q_index].info.inverse)
                        {
                            val = -1 * val;
                        }
                        var yAxis = 0;
                        if (widget.q[q_index].yAxisIndex)
                        {
                            if (widget.q[q_index].yAxisIndex === Array)
                            {
                                yAxis = widget.q[q_index].yAxisIndex[0];
                            } else
                            {
                                yAxis = widget.q[q_index].yAxisIndex;
                            }
                        }
                        if (!widget.options.yAxis[yAxis])
                        {
                            yAxis = 0;
                        }
                        tmp_series_1[name].push({value: Math.round(val * 100) / 100, name: tmpname, unit: widget.options.yAxis[yAxis].unit, isinverse: widget.q[q_index].info.inverse});
                        sdata.push({value: val, name: name});
                    }

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
                                cildren.push({value: tmp_series_1[key][ind].value, name: tmp_series_1[key][ind].name, unit: series.unit});
                            }

                            data.push({value: val, name: key, children: cildren});
                        }
                        series.name = "All";
//                        widget.options.tooltip.trigger = 'item';
                        series.data = data;
                        widget.options.series.push(series);

//                        console.log(widget.options.series[0].data);

                    } else
                    {
                        for (var key in tmp_series_1)
                        {
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
                                var yAxis = 0;
                                if (series.yAxisIndex)
                                {
                                    yAxis = series.yAxisIndex[0];
                                }
                                if (widget.stacked)
                                {
                                    series.stack = "stack" + yAxis;
                                } else
                                {
                                    delete series.stack;
                                }

                                if (widget.q[q_index].yAxisIndex)
                                {
                                    series.yAxisIndex = [];
                                    for (var ax in widget.q[q_index].yAxisIndex)
                                    {
                                        if (widget.options.yAxis[widget.q[q_index].yAxisIndex[ax]])
                                        {
                                            series.yAxisIndex.push(widget.q[q_index].yAxisIndex[ax]);
                                        }

                                    }
                                    if (series.yAxisIndex.length === 0)
                                    {
                                        delete series.yAxisIndex;
                                    }

                                } else
                                {
                                    delete series.yAxisIndex;
                                }
                                if (widget.q[q_index].xAxisIndex)
                                {
                                    series.xAxisIndex = [];
                                    for (var ax in widget.q[q_index].xAxisIndex)
                                    {
                                        if (widget.options.xAxis[widget.q[q_index].xAxisIndex[ax]])
                                        {
                                            series.xAxisIndex.push(widget.q[q_index].xAxisIndex[ax]);
                                        }

                                    }
                                    if (series.xAxisIndex.length === 0)
                                    {
                                        delete series.xAxisIndex;
                                    }
                                } else
                                {
                                    delete series.xAxisIndex;
                                }
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
                                if ((Object.keys(tmp_series_1).length === 1) && (count.base === 1))
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
                            if (series.type === "line")
                            {
                                if (!widget.manual)
                                {
                                    if ((widget.points !== "none") && (typeof (widget.points) !== "undefined"))
                                    {
                                        series.showSymbol = true;
                                        series.symbol = widget.points;
                                    } else
                                    {
                                        delete series.symbol;
                                        delete series.showSymbol;
                                    }
                                }

                            }


                            if (series.type === "gauge")
                            {
                                if (!series.axisLabel)
                                {
                                    series.axisLabel = {};
                                }
                                if (!widget.manual)
                                {
                                    var yAxis = 0;
                                    if (series.yAxisIndex)
                                    {
                                        yAxis = series.yAxisIndex[0];
                                    }
                                    if (typeof widget.options.yAxis[yAxis].min !== "undefined")
                                    {
                                        series.min = widget.options.yAxis[yAxis].min;
                                    } else
                                    {
                                        delete series.min;
                                    }

                                    if (typeof widget.options.yAxis[yAxis].max !== "undefined")
                                    {
                                        series.max = widget.options.yAxis[yAxis].max;
                                    } else
                                    {
                                        delete(series.max);
                                    }
                                    if (typeof widget.options.yAxis[yAxis].splitNumber !== "undefined")
                                    {
                                        series.splitNumber = widget.options.yAxis[0].splitNumber;
                                    } else
                                    {
                                        delete(series.splitNumber);
                                    }
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
                }

            }

        }

        count.value--;

        if (count.value === 0)
        {
            if (!widget.manual)
            {
                switch (widget.type) {
                    case 'bars':
                    {
                        widget.options.tooltip.trigger = 'axes';
                        break;
                    }
                    case 'line':
                    {
                        widget.options.tooltip.trigger = 'axes';
                        break;
                    }
                    default:
                    {
                        widget.options.tooltip.trigger = 'item';
                        break
                    }
                }

                widget.options.series.sort(function (a, b) {
                    return compareStrings(a.name, b.name);
                });
            }

            for (var ind in widget.options.xAxis)
            {
                widget.options.xAxis[ind].data = [];
            }

            var w = chart._dom.getBoundingClientRect().width;
            var h = chart._dom.getBoundingClientRect().height;
            if (widget.options.grid)
            {
                if (widget.options.grid.x)
                {
                    if ($.isNumeric(widget.options.grid.x))
                    {
                        w = w - widget.options.grid.x;
                    }
                }
                if (widget.options.grid.x2)
                {

                    if ($.isNumeric(widget.options.grid.x2))
                    {
                        w = w - widget.options.grid.x2;
                    }
                }
                if (widget.options.grid.y)
                {

                    if ($.isNumeric(widget.options.grid.y))
                    {
                        h = h - widget.options.grid.y;
                    }
                }

                if (widget.options.grid.y2)
                {

                    if ($.isNumeric(widget.options.grid.y2))
                    {
                        h = h - widget.options.grid.y2;
                    }
                }
            }
            var a = w;
            var b = h;
            var rows = 1;
            var cols = 0;
            var rawcols = 0;

            for (var i = 1; i <= widget.options.series.length; i++)
            {

                if (a > b)
                {

                    if (cols > 0)
                    {
                        if (rawcols * rows <= cols * rows)
                        {
                            rawcols++;
                        } else if (i % rows !== 0)
                        {
                            rawcols++;
                        }
                    } else
                    {
                        rawcols++;
                    }
                    a = w / Math.max(rawcols, cols);

                } else
                {
                    rows++;
                    b = h / rows;
                    cols = rawcols;
                    rawcols = 1;

                }
            }

            cols = Math.max(rawcols, cols);
            var col = 1;
            var row = 1;
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


            for (var zoomindex in widget.options.dataZoom)
            {
                if (!widget.options.dataZoom[zoomindex].xAxisIndex)
                {
                    if (widget.options.dataZoom[zoomindex].yAxisIndex)
                    {

                        if (typeof widget.options.dataZoom[zoomindex].yAxisIndex[0] !== "undefined")
                        {
                            if (widget.options.yAxis[widget.options.dataZoom[zoomindex].yAxisIndex[0]])
                            {
                                widget.options.dataZoom[zoomindex].labelFormatter = widget.options.yAxis[widget.options.dataZoom[zoomindex].yAxisIndex[0]].axisLabel.formatter;
                            }
                        }
                    }

                }
            }

            for (var ind in widget.options.series)
            {

                var ser = widget.options.series[ind];
                var yAxis = 0;
                if (ser.yAxisIndex)
                {
                    if (ser.yAxisIndex === Array)
                    {
                        yAxis = ser.yAxisIndex[0];
                    } else
                    {
                        yAxis = ser.yAxisIndex;
                    }

                }
                val.valueformatter = widget.options.yAxis[yAxis].axisLabel.formatter;

                if (widget.label)
                    if (widget.label.parts)
                    {
                        $.each(ser.data, function (i, val) {
                            val.formatter = widget.label.parts;
                        });

                    }
                ;

                if (!widget.manual)
                {
                    if (widget.label)
                    {
                        if (!ser.label)
                        {
                            ser.label = {normal: {}};
                        }

                        if (typeof widget.label.show !== "undefined")
                        {
                            ser.label.normal.show = widget.label.show;
                        } else
                        {
                            ser.label.normal.show = false;
                        }

                        if (widget.label.position)
                        {
                            ser.label.normal.position = widget.label.position;
                        } else
                        {
                            delete ser.label.normal.position;
                        }
                    } else
                    {
                        delete ser.label;
                    }

                    if (ser.type === 'gauge')
                    {
                        if (!ser.detail)
                        {
                            ser.axisLabel = {};
                        }
                        ser.axisLabel.formatter = widget.options.yAxis[yAxis].axisLabel.formatter;
                        if (!ser.detail)
                        {
                            ser.detail = {};
                        }
                        ser.detail.formatter = widget.options.yAxis[yAxis].axisLabel.formatter;
                    }
                    if (ser.label)
                    {
                        if (ser.label.normal)
                        {
                            if (ser.label.normal.show)
                            {
                                switch (ser.type) {
                                    case 'pie':
                                    {
                                        delete ser.label.normal.formatter;
                                        break;
                                    }
                                    case 'funnel':
                                    {
                                        delete ser.label.normal.formatter;
                                        break;
                                    }
                                    case 'line':
                                    {
                                        delete ser.label.normal.formatter;
                                        break;
                                    }
                                    default:
                                    {

                                        if (widget.options.yAxis[yAxis].axisLabel.formatter)
                                        {
                                            if (typeof (widget.options.yAxis[yAxis].axisLabel.formatter) === "function")
                                            {
                                                ser.label.normal.formatter = widget.options.yAxis[yAxis].axisLabel.formatter;
                                            } else
                                            {
                                                ser.label.normal.formatter = widget.options.yAxis[yAxis].axisLabel.formatter.replace("{value}", "{c}");
                                            }
                                        } else
                                        {
                                            delete ser.label.normal.formatter;
                                        }
                                        delete ser.label.normal.formatter;
                                        break
                                    }
                                }


                            }
                        }

                    }
                }

                //Set series positions                
                if (col > cols)
                {
                    col = 1;
                    row++;
                }
                if ((ser.type === "pie") || (ser.type === "gauge"))
                {
                    if (!widget.manual)
                    {
                        delete ser.center;
                        delete ser.radius;
                        if (widget.options.grid)
                        {
                            if (typeof (widget.options.grid.height) !== "undefined")
                            {
                                if ($.isNumeric(widget.options.grid.height))
                                {
                                    ser.radius = widget.options.grid.height;
                                }
                            }
                        }

                        if (ser.type === "pie")
                        {

                            if (!ser.radius)
                            {
                                ser.radius = Math.min(a / 4, b / 4);
                                if (ser.label)
                                {
                                    if (ser.label.normal)
                                    {
                                        if ((ser.label.normal.position === 'inner') || (ser.label.normal.position === 'center') || (!ser.label.normal.show))
                                        {
                                            ser.radius = Math.min(a / 2, b / 2);
                                        }

                                    }
                                }
                                ser.radius = ser.radius - 5;
                            }


                            if (widget.options.grid)
                            {
                                if (typeof (widget.options.grid.width) !== "undefined")
                                {
                                    if ($.isNumeric(widget.options.grid.width))
                                    {
                                        var internalRad = ser.radius - widget.options.grid.width;
                                        if (internalRad < 0)
                                        {
                                            internalRad = ser.radius - internalRad;
                                        }
                                        ser.radius = [internalRad, ser.radius];
                                    }
                                }
                            }
                        } else
                        {
                            if (!ser.radius)
                            {
                                ser.radius = Math.min(a / 2, b / 2) - 5;
                            }
                            delete ser.axisLine;
                            delete ser.axisTick;
                            delete ser.splitLine;
                            if (widget.options.grid)
                            {
                                if (typeof (widget.options.grid.width) !== "undefined")
                                {
                                    if ($.isNumeric(widget.options.grid.width))
                                    {
                                        ser.radius = ser.radius - parseInt(widget.options.grid.width);
                                        ser.axisLine = {lineStyle: {width: widget.options.grid.width}};
                                        ser.axisTick = {length: parseInt(widget.options.grid.width) + 8};
                                        ser.splitLine = {length: parseInt(widget.options.grid.width) + 15};
                                    }
                                }
                            }


                        }

                        var left = 0;
                        var top = 0;
                        if (widget.options.grid)
                        {
                            if (widget.options.grid.x)
                            {
                                if ($.isNumeric(widget.options.grid.x))
                                {
                                    left = parseInt(widget.options.grid.x);
                                }

                            }
                            if (widget.options.grid.y)
                            {
                                if ($.isNumeric(widget.options.grid.y))
                                {
                                    top = parseInt(widget.options.grid.y);
                                }

                            }

                        }


                        ser.center = [col * a - a / 2 + left, row * b - b / 2 + top];
                    }
                }
                if (ser.type === "funnel")
                {
                    if (!widget.manual)
                    {
                        delete ser.axisLine;
                        delete ser.max;
                        delete ser.min;
                        delete ser.radius;
                        delete ser.center;
                        if (row % 2 !== 0)
                        {

                            ser.sort = 'ascending';
                        } else
                        {
                            delete ser.sort;
                        }


                        delete ser.x;
                        delete ser.y;

                        var left = 0;
                        var top = 0;
                        delete ser.width;
                        delete ser.height;
                        if (widget.options.grid)
                        {
                            if (widget.options.grid.x)
                            {
                                if ($.isNumeric(widget.options.grid.x))
                                {
                                    left = parseInt(widget.options.grid.x);
                                }

                            }
                            if (widget.options.grid.y)
                            {
                                if ($.isNumeric(widget.options.grid.y))
                                {
                                    top = parseInt(widget.options.grid.y);
                                }

                            }
                            if (typeof (widget.options.grid.width) !== "undefined")
                            {
                                if ($.isNumeric(widget.options.grid.width))
                                {
                                    ser.width = widget.options.grid.width;
                                }
                            }
                            if (typeof (widget.options.grid.height) !== "undefined")
                            {
                                if ($.isNumeric(widget.options.grid.height))
                                {
                                    ser.height = widget.options.grid.height;
                                }
                            }
                        }
                        if (!ser.height)
                        {
                            ser.height = b - 10;
                        }

                        if (!ser.width)
                        {
                            ser.width = a / 1.5;
                            if (ser.label)
                            {
                                if (ser.label.normal)
                                {
                                    if ((ser.label.normal.position === 'inside') || (!ser.label.normal.show))
                                    {
                                        ser.width = a;
                                    }
                                    if ((ser.label.normal.position === 'left') && (ser.label.normal.show))
                                    {
                                        left = left + a - ser.width;
                                    }

                                }
                            }
                            ser.width = ser.width - 10;
                        }

                        ser.x = (col - 1) * a + left + 10;
                        ser.y = (row - 1) * b + top + 10;
                    }

                }

                col++;
                var xAxisIndex = 0;
                if (widget.options.series[ind].xAxisIndex)
                {
                    xAxisIndex = widget.options.series[ind].xAxisIndex[0];
                }

                if (!widget.options.xAxis[xAxisIndex])
                {
                    xAxisIndex = 0;
                }
                if (widget.options.xAxis[xAxisIndex].type === "category")
                {
                    widget.options.series[ind].unit = widget.options.yAxis[0].unit;
                    if ((widget.type === "bar") || (widget.type === "line"))
                    {

                        for (var sind in widget.options.series[ind].data)
                        {
                            if (!widget.options.xAxis[xAxisIndex].data)
                            {
                                widget.options.xAxis[xAxisIndex].data = [];
                            }
                            widget.options.series[ind].data[sind].unit = widget.options.yAxis[0].unit;
                            if (widget.options.xAxis[xAxisIndex].data.indexOf(widget.options.series[ind].data[sind].name) === -1)
                            {
                                widget.options.xAxis[xAxisIndex].data.push(widget.options.series[ind].data[sind].name);
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

            }

            if (redraw)
            {
                chart.setOption({series: widget.options.series, xAxis: widget.options.xAxis});
            } else
            {
                chart.setOption(widget.options, true);
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
    }
    ;
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
function setdatabyQ(json, rowindex, widgetindex, url, redraw = false, callback = null, customchart = null) {
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
        } else
        {
            widget.options.toolbox = {};
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

        var count = {"value": widget.q.length, "base": widget.q.length};
        for (k in widget.q)
        {
            if (widget.q[k].check_disabled || (!widget.q[k].info.metrics))
            {
                count.base--;
            }
        }
        if (count.base === 0)
        {
            var tmpseries = clone_obg(widget.options.series);
            for (var tk in tmpseries)
            {
                tmpseries[tk].data = [];
            }
            chart.setOption({series: tmpseries, legend: {data: []}});
            return;
        }

        count.value = count.base;
        var oldseries = clone_obg(widget.options.series);
        widget.options.series = [];
        for (k in widget.q)
        {
            if (count.base !== 0)
            {
                if (widget.q[k].check_disabled)
                {
                    continue;
                }
            }

            if ((typeof (widget.q[k])) === "string")
            {
                var query = widget.q[k];
            } else if (widget.q[k].info)
            {
                if (!widget.q[k].info.metrics)
                {
                    continue;
                }
                var stags = "&tags=";
                if (widget.q[k].info.tags)
                {
                    stags = "&tags=" + widget.q[k].info.tags;
                }
                if (!widget.q[k].info.aggregator)
                {
                    widget.q[k].info.aggregator = "none";
                }
                var query = "metrics=" + widget.q[k].info.metrics + stags +
                        "&aggregator=" + widget.q[k].info.aggregator;
                if (widget.q[k].info.rate)
                {
                    query = query + "&rate=true";
                }

                if (!widget.q[k].info.downsamplingstate)
                {
                    var downsample = widget.q[k].info.downsample;

                    if (widget.q[k].info.ds)
                    {

                        if ((Object.keys(widget.q[k].info.ds).length === 2))
                        {
                            downsample = widget.q[k].info.ds.time + "-" + widget.q[k].info.ds.aggregator;
                        }
                    }

                    if (!usePersonalTime)
                    {
                        if (!downsample)
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
                            if (downsample)
                            {
                                query = query + "&downsample=" + downsample;
                            }

                        }
                    } else
                    {
                        if (downsample)
                        {
                            query = query + "&downsample=" + downsample;
                        }
                    }

                }
            }
            var uri = cp + "/" + url + "?" + query + "&startdate=" + start + "&enddate=" + end;


            if (getParameterByName('metrics', uri))
            {
                chart.showLoading("default", {
                    text: '',
                    color: colorPalette[colorPalette.length],
                    textColor: '#000',
                    maskColor: 'rgba(255, 255, 255, 0)',
                    zlevel: 0
                });

                $.getJSON(uri, null, queryCallback(k, widget, oldseries, chart, count, json, rowindex, widgetindex, url, redraw, callback, customchart, end));

            }

        }
}
}
function AutoRefresh(redraw = false) {
    redrawAllJSON(dashJSONvar, redraw);
}
function AutoRefreshSingle(row, index, readonly = false, rebuildform = true, redraw = false) {
    var opt = dashJSONvar[row]["widgets"][index];

    showsingleWidget(row, index, dashJSONvar, readonly, rebuildform, redraw, function () {
//        var jsonstr = JSON.stringify(opt, jsonmaker);
//        editor.set(JSON.parse(jsonstr));
    });
}
function redrawAllJSON(dashJSON, redraw = false) {
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
                $("#charttemplate .chartsection").attr("size", dashJSON[rowindex]["widgets"][widgetindex].size);
                if (dashJSON[rowindex]["widgets"][widgetindex].options)
                {
                    if (dashJSON[rowindex]["widgets"][widgetindex].options.backgroundColor)
                    {
                        $("#charttemplate .chartsection").css("background-color", dashJSON[rowindex]["widgets"][widgetindex].options.backgroundColor);
                    } else
                    {
                        $("#charttemplate .chartsection").css("background-color", "");
                    }
                }

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
//            console.log(dashJSON[rowindex]["widgets"][widgetindex]);
            if (typeof (dashJSON[rowindex]["widgets"][widgetindex].options) === "undefined")
            {
                dashJSON[rowindex]["widgets"][widgetindex].options = clone_obg(defoption);
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
function showsingleWidget(row, index, dashJSON, readonly = false, rebuildform = true, redraw = false, callback = null) {

    $(".fulldash").hide();
    for (var rowindex in dashJSON)
    {
        for (var widgetindex in    dashJSON[rowindex]["widgets"])
        {
            if (dashJSON[rowindex]["widgets"][widgetindex])
            {
                clearTimeout(dashJSON[rowindex]["widgets"][widgetindex].timer);
            }
        }
    }


    if (rebuildform)
    {
        Edit_Form = null;
    }
    //Rename queryes to q
    if (typeof (dashJSON[row]["widgets"][index].q) === "undefined")
    {
        dashJSON[row]["widgets"][index].q = clone_obg(dashJSON[row]["widgets"][index].queryes);
        delete dashJSON[row]["widgets"][index].queryes;
    }
    //Change queryes downsample 
    if (dashJSON[row]["widgets"][index].q)
    {
        for (var qindex in dashJSON[row]["widgets"][index].q)
        {
            if (dashJSON[row]["widgets"][index].q[qindex].info)
            {
                if (dashJSON[row]["widgets"][index].q[qindex].info.downsample)
                {
                    var ds_ = dashJSON[row]["widgets"][index].q[qindex].info.downsample.split("-");
                    dashJSON[row]["widgets"][index].q[qindex].info.ds = {};
                    dashJSON[row]["widgets"][index].q[qindex].info.ds.time = ds_[0];
                    dashJSON[row]["widgets"][index].q[qindex].info.ds.aggregator = ds_[1];
                    delete dashJSON[row]["widgets"][index].q[qindex].info.downsample;
                }
            }

        }
    }

    var title = "Edit Chart";
    var W_type = dashJSON[row]["widgets"][index].type;
    if (W_type === "table")
    {
        title = "Edit Table";
    }
    if (rebuildform)
    {
        $(".right_col").append('<div class="x_panel editpanel"></div>');
        if (!readonly)
        {
            $(".right_col .editpanel").append('<div class="x_title dash_action">' +
                    '<h1 class="col-md-3">' + title + '</h1>' +
                    '<div class="pull-right">' +
                    '<a class="btn btn-primary savedash" type="button">Save </a>' +
                    '<a class="btn btn-primary backtodush" type="button">Back to Dash </a>' +
                    '</div>' +
                    '<div class="clearfix"></div>' +
                    '</div>');

        }

        if (W_type === "table")
        {
            $(".right_col .editpanel").append('<div class="x_content" id="singlewidget">' +
                    '<div class="table_single" id="table_single"></div>' +
                    '</div>');
        } else //chart
        {
            if (!redraw)
            {
                if (readonly)
                {
                    $(".right_col .editpanel").append('<div class="x_content" id="singlewidget">' +
                            '<div class="echart_line_single" id="echart_line_single"></div>' +
                            '</div>');

                } else
                {
                    var height = "300px";
                    if (typeof (dashJSON[row]["widgets"][index].height) !== "undefined")
                    {
                        if (dashJSON[row]["widgets"][index].height === "")
                        {
                            dashJSON[row]["widgets"][index].height = "300px";
                        }
                        height = dashJSON[row]["widgets"][index].height;
                    }
                    $(".right_col .editpanel").append('<div class="x_content" id="singlewidget">' +
                            '<div class="echart_line_single" id="echart_line_single" style="height:' + height + ';"></div>' +
                            '</div>');
                }
                echartLine = echarts.init(document.getElementById("echart_line_single"), 'oddeyelight');
            }


            if (!readonly)
            {
                $(".right_col .editpanel").append('<div class="x_content edit-form">');
                Edit_Form = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON);
//                $(".editchartpanel select").select2({minimumResultsForSearch: 15});
            }

        }
    }

    if (typeof (dashJSON[row]["widgets"][index].q) !== "undefined")
    {
        setdatabyQ(dashJSON, row, index, "getdata", redraw, callback, echartLine);
    } else
    {
        echartLine.setOption(dashJSON[row]["widgets"][index].options);
    }

    return;
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
function repaint(redraw = false, rebuildform = true) {
    doapplyjson = true;
    if (dashJSONvar.times.generalds)
    {
        $('#global-down-sample').val(dashJSONvar.times.generalds[0]);
        $('#global-down-sample-ag').val(dashJSONvar.times.generalds[1]).trigger('change');
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
            AutoRefreshSingle(request_R_index, request_W_index, action !== "edit", rebuildform, redraw);
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
            $('#reportrange span').html(PicerOptionSet1.startDate.format('MM/DD/YYYY HH:mm:ss') + ' - ' + PicerOptionSet1.endDate.format('MM/DD/YYYY HH:mm:ss'));

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
    repaint();
    var elem = document.getElementById('global-downsampling-switsh');
    var switchery = new Switchery(elem, {size: 'small', color: '#26B99A'});
    elem.onchange = function () {
        if (!$(this).attr('autoedit'))
        {
            if (!dashJSONvar.times.generalds)
            {
                dashJSONvar.times.generalds = [];
            }
            dashJSONvar.times.generalds[2] = this.checked;
            repaint(true, false);
        }

    };

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

        if ($(".editpanel").is(':visible'))
        {
            var request_W_index = getParameterByName("widget");
            var request_R_index = getParameterByName("row");
            var action = getParameterByName("action");
            showsingleWidget(request_R_index, request_W_index, dashJSONvar, action !== "edit", false, false);
        } else
        {
            window.history.pushState({}, "", "?&startdate=" + startdate + "&enddate=" + enddate);
            redrawAllJSON(dashJSONvar);
        }
    });
    $("#refreshtime").select2({minimumResultsForSearch: 15});
    $("#global-down-sample-ag").select2({minimumResultsForSearch: 15});
    $('#reportrange').daterangepicker(PicerOptionSet1, cbJson(dashJSONvar, $('#reportrange')));
    $('body').on("click", ".dropdown_button,.button_title_adv", function () {
        var target = $(this).attr('target');
        var shevron = $(this);
        if ($(this).hasClass("button_title_adv"))
        {
            shevron = $(this).find('i');
        }
        $('#' + $(this).attr('target')).fadeToggle(500, function () {
            if ($('#' + target).css('display') === 'block')
            {
                shevron.removeClass("fa-chevron-circle-down");
                shevron.addClass("fa-chevron-circle-up");
            } else
            {
                shevron.removeClass("fa-chevron-circle-up");
                shevron.addClass("fa-chevron-circle-down");

            }
        });
    });
    $('body').on("change", "#global-down-sample-ag", function () {
        if (!doapplyjson)
        {
            if (!dashJSONvar.times.generalds)
            {
                dashJSONvar.times.generalds = [];
            }
            dashJSONvar.times.generalds[1] = $(this).val();
            repaint(true, false);
        }

    });
    $('body').on("blur", "#global-down-sample", function () {
        if (!dashJSONvar.times.generalds)
        {
            dashJSONvar.times.generalds = [];
        }
        dashJSONvar.times.generalds[0] = $(this).val();
        repaint(true, false);
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
//    console.log(curentwidgetindex);
//    console.log(widgetindex);
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
        $(".editchartpanel select").select2({minimumResultsForSearch: 15});
        $(".select2_group").select2({dropdownCssClass: "menu-select"});
        $RIGHT_COL.css('min-height', $(window).height());
    });
    $('body').on("click", ".viewchart", function () {
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
        $(".editpanel").empty();
        $(".editpanel").remove();
        delete Edit_Form;
        AutoRefresh();

        $('html, body').animate({
            scrollTop: dashJSONvar[request_R_index]["widgets"][request_W_index].echartLine._dom.getBoundingClientRect().top
        }, 500);
        $RIGHT_COL.css('min-height', $(window).height());
    });
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
    $('body').on("click", "#refresh", function () {
        repaint(true);
    });
    $('body').on("change", "#refreshtime", function () {
        if (!doapplyjson)
        {
            dashJSONvar.times.intervall = $(this).val();
            repaint(true, false);
        }

    });


//    $('body').on("mouseenter", ".select2-container--default .menu-select .select2-results__option[role=group]", function () {
//        $(this).find("ul").css("top", $(this).position().top);
//        var curent = $(this);
//        if ($(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").length === 0)
//        {
//            curent.find("ul:hidden").show();
//        } else
//        {
//            if ($(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").parents(".select2-results__option[role=group]").attr("aria-label") !== $(this).attr("aria-label"))
//            {
//                $(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").hide();
//                curent.find("ul:hidden").show();
//            }
//        }
//
//    });
//    $('body').on("mouseleave", ".select2-container--default .menu-select", function () {
//        $(".select2-container--default .menu-select .select2-results__option[role=group] ul").hide();
//    });

    var options = {modes: ['form', 'tree', 'code'], mode: 'code'};
    dasheditor = new JSONEditor(document.getElementById("dasheditor"), options);
});
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
                            if (chart._dom)
                            {
                                if (chart._dom.getBoundingClientRect().bottom < 0)
                                {
                                    dashJSONvar[rowindex]["widgets"][widgetindex].visible = false;
                                }
                                if (chart._dom.getBoundingClientRect().top > window.innerHeight)
                                {
                                    dashJSONvar[rowindex]["widgets"][widgetindex].visible = false;
                                }
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


