/* global numbers, cp, colorPalette, format_metric, echarts, rangeslabels, gdd, PicerOptionSet1, cb, pickerlabel, $RIGHT_COL, moment, jsonmaker, EditForm, getmindate, globalstompClient, subtractlist, pieformater, abcformater, getParameterByName */
var SingleRedrawtimer;
var dasheditor;
var echartLine;
var basecounter = '<div class="animated flipInY col-xs-6 chartsection" >' +
        '<div class="tile-stats">' +
//        '<div class="icon"><i class="fa fa-database"></i></div>' +
        '<h3>Title</h3>' +
        '<p></p>' +
        '<div class="count"><span class="number">0</span><span class="param"></span></div>' +
        '</div>' +
        '</div>';

var defserie = {
    name: null,
    data: null
};

var olddashname = "";
var dashmodifier = false;
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
var single_ri = 0;
var single_wi = 0;
var scrolltimer;
var btn = null;


function currentpagelock() {
    if ($('.current-i').hasClass('fa-lock')) {
        $('.current-i').removeClass('fa-lock').addClass('fa-unlock');
    } else if ($('.current-i').hasClass('fa-unlock')) {
        $('.current-i').removeClass('fa-unlock').addClass('fa-lock');
    }
}
;


function domodifier()
{
    dashmodifier = true;
    $('.savedash').parent().find('.btn').addClass('btn-warning');
    $('.savedash').parent().find('.btn').removeClass('btn-default');
}
;

function dounmodifier()
{
    dashmodifier = false;
    $('.savedash').parent().find('.btn').addClass('btn-default');
    $('.savedash').parent().find('.btn').removeClass('btn-warning');
}

function doeditTitle(e) {
    if (((e.which === 13) && (e.type === 'keypress')) || (e.type === 'click'))
    {
        $(this).parents('.item_title').find('.title_text').css("display", "block");
        $(this).parent().css("display", "none");

        $(this).parents('.item_title').find('span').html($(this).parent().find('input').val());
        var ri = $(this).parents(".widgetraw").index();
        if (ri !== -1)
        {
            gdd.rows[ri].name = $(this).parent().find('input').val();
        }
        domodifier();
    }
}
;
function opensave() {
    $('#myModal .modal-title').text("Successfully  saved");
    $('#myModal').modal('show');

    setTimeout(function () {
        $('#myModal').modal('hide');
    }, 2000);
}
;
function savedash() {
    var url = cp + "/dashboard/save";
    var senddata = {};
    var localjson = clone_obg(gdd);
    if (Object.keys(localjson).length > 0)
    {
        for (var ri in localjson.rows)
        {
            for (var wi in localjson.rows[ri].widgets)
            {
                delete localjson.rows[ri].widgets[wi].echartLine;
                if (localjson.rows[ri].widgets[wi].tmpoptions)
                {
                    localjson.rows[ri].widgets[wi].options = clone_obg(gdd.rows[ri].widgets[wi].tmpoptions);
                    delete localjson.rows[ri].widgets[wi].tmpoptions;
                }
                if (localjson.rows[ri].widgets[wi].options)
                {
                    for (var k in localjson.rows[ri].widgets[wi].options.series) {
                        localjson.rows[ri].widgets[wi].options.series[k].data = [];
                    }
                }

            }
        }

        senddata.info = JSON.stringify(localjson);
        senddata.name = $("#name").val();

        senddata.unloadRef = globalstompClient.ws._transport.unloadRef;
        if (olddashname !== $("#name").val())
        {
            senddata.oldname = olddashname;
        }


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
                    var uri = encodeURI(cp + "/dashboard/" + senddata.name);
                    var request_W_index = getParameterByName("widget");
                    var request_R_index = getParameterByName("row");
                    if (request_W_index === null)
                    {
                        if (window.location.pathname !== uri)
                        {
                            window.location.href = uri;
                        } else
                        {
                            opensave();
                        }
                    } else
                    {
                        if (request_R_index !== null)
                        {
                            uri = uri + encodeURI("?widget=" + request_W_index + "&row=" + request_R_index + "&action=edit");
                            if (window.location.pathname + window.location.search !== uri)
                            {
                                window.location.href = uri;
                            } else
                            {
                                opensave();
                            }
                        }

                    }
                }
            },
            error: function (xhr, ajaxOptions, thrownError) {
                $('#myModal .modal-title').text("Error saving data");
                $('#myModal').modal('show');
                setTimeout(function () {
                    $('#myModal').modal('hide');
                }, 2000);

            }
        });
    }
    dounmodifier();
}

function btnlock() {

    if ($('#btnlock').hasClass('btnunlock'))

    {
        if ($('#btnlock').parents('.fulldash').hasClass('locked'))
        {
            $('#btnlock').parents('.fulldash').toggleClass('locked');
            $('.dash_header,.text-right').hide();
        }

        $('.dash_header,.text-right').show(500);
        $('#btnlock').toggleClass('btnunlock');
        domodifier();
        $('#btnlock').find('i').toggleClass('fa-unlock');
        locktooltip();
        delete gdd.locked;

    } else
    {
        if (dashmodifier === true) {
            $('#lockConfirm').modal('show');
            $('#lockConfirm').on('shown.bs.modal', function () {
                $('#savelock').focus();
            });
            btn = $('#btnlock');

        } else {
            $('.dash_header,.text-right').hide(500, function () {

                if (!$('#btnlock').parents('.fulldash').hasClass('locked')) {
                    $('#btnlock').parents('.fulldash').toggleClass('locked');
                }
            });

            $('#btnlock').toggleClass('btnunlock');
            $('#btnlock').find('i').toggleClass('fa-unlock');
            locktooltip();
            $('#btnlock').parents('.fulldash').toggleClass('locked');
            gdd.locked = true;
            setTimeout(function () {
                savedash();

            }, 1000);
        }
    }
}

function locktooltip() {

    if ($('#btnlock').hasClass('btnunlock')) {
        $('#btnlock').attr('data-original-title', 'Unlock Dashboard(Ctrl+L)');

    } else {
        $('#btnlock').attr('data-original-title', 'Lock Dashboard(Ctrl+L)');

    }
}


var queryCallback = function (inputdata) {
    var q_index = inputdata[0];
    var widget = inputdata[1];
    var oldseries = inputdata[2];
    var chart = inputdata[3];
    var count = inputdata[4];
    var json = inputdata[5];
    var ri = inputdata[6];
    var wi = inputdata[7];
    var url = inputdata[8];
    var redraw = inputdata[9];
    var callback = inputdata[10];
    var customchart = inputdata[11];
    var start = inputdata[12];
    var end = inputdata[13];
    var whaitlist = inputdata[14];
    var uri = inputdata[15];

    return function (data) {


        if (data.chartsdata)
        {
            if (widget.type === "counter")
            {
                for (var dindex in data.chartsdata)
                {

                    var name;

                    if (widget.title)
                    {
                        name = widget.title.text;
                    } else
                    {
                        name = data.chartsdata[dindex].metric + JSON.stringify(data.chartsdata[dindex].tags);
                    }
                    if (widget.title)
                    {
                        var name2 = widget.title.text;
                    }

                    if (typeof (widget.q[q_index].info) !== "undefined")
                    {
                        if (widget.q[q_index].info.alias)
                        {
                            if (widget.q[q_index].info.alias !== "")
                            {
                                name = applyAlias(widget.q[q_index].info.alias, data.chartsdata[dindex]);
                            }
                        }

                        if (widget.q[q_index].info.alias2)
                        {
                            if (widget.q[q_index].info.alias2 !== "")
                            {
                                name2 = applyAlias(widget.q[q_index].info.alias2, data.chartsdata[dindex]);
                            }
                        }
                    }
//                    console.log( data.chartsdata[dindex]);
                    widget.data.push({data: data.chartsdata[dindex].data, name: name, name2: name2, id: data.chartsdata[dindex].taghash + data.chartsdata[dindex].metric, q_index: q_index});
                }
            } else
            {
                var m_sample = widget.options.xAxis[0].m_sample;
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
                if (Object.keys(data.chartsdata).length > 0)
                {

                    if (widget.options.xAxis[xAxis_Index].type === "time")
                    {
                        for (index in data.chartsdata)
                        {
                            if (data.chartsdata[index].data.length > 0)
                            {
                                var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags);
                                if (widget.title)
                                {
                                    var name2 = widget.title.text;
                                }

                                if (typeof (widget.q[q_index].info) !== "undefined")
                                {
                                    if (widget.q[q_index].info.alias)
                                    {
                                        if (widget.q[q_index].info.alias !== "")
                                        {
                                            name = applyAlias(widget.q[q_index].info.alias, data.chartsdata[index]);
                                        }
                                    }

                                    if (widget.q[q_index].info.alias2)
                                    {
                                        if (widget.q[q_index].info.alias2 !== "")
                                        {
                                            name2 = applyAlias(widget.q[q_index].info.alias2, data.chartsdata[index]);
                                        }
                                    }
                                }

                                var series = clone_obg(defserie);
                                series.data = [];
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

                                series.name = name;
                                var chdata = data.chartsdata[index].data;
                                series.data = [];
                                var yAxis = 0;
                                if (series.yAxisIndex)
                                {
                                    if (Array.isArray(series.yAxisIndex))
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
                                            //TODO Mi ban anel
//                                        series.data.push({value: val[1], 'unit': widget.options.yAxis[yAxis].unit, 'name': moment(val[0]).format('YYYY-MM-DD hh:mm'), isinverse: widget.q[q_index].info.inverse});
                                            break;
                                        }
                                        case 'bar':
                                        {
                                            series.data.push({value: val, 'unit': widget.options.yAxis[yAxis].unit, 'name': name2, isinverse: widget.q[q_index].info.inverse});
                                            break;
                                        }
                                        case 'line':
                                        {
                                            var tmptitle = false
                                            if (widget.title)
                                            {
                                                tmptitle = widget.title.text;
                                            }
                                            series.data.push({value: val, 'unit': widget.options.yAxis[yAxis].unit, 'hname': name2 === tmptitle ? null : name2, isinverse: widget.q[q_index].info.inverse, name: tmptitle});
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
                        delete widget.options.xAxis[xAxis_Index].min;
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
                                        name = applyAlias(widget.q[q_index].info.alias, data.chartsdata[index]);
                                    }

                                }
                                if (widget.q[q_index].info.alias2)
                                {
                                    if (widget.q[q_index].info.alias2 !== "")
                                    {
                                        name2 = applyAlias(widget.q[q_index].info.alias2, data.chartsdata[index]);
                                    }
                                }
                            }

                            var chdata = [];
                            var val;
                            for (var ind in data.chartsdata[index].data) {
                                chdata.push(data.chartsdata[index].data[ind][1]);
                                val = data.chartsdata[index].data[ind][1];
                            }

                            if (widget.q[q_index].xAxisIndex)
                            {
                                if (Array.isArray(widget.q[q_index].xAxisIndex))
                                {
                                    m_sample = widget.options.xAxis[widget.q[q_index].xAxisIndex[0]].m_sample;
                                } else
                                {
                                    m_sample = widget.options.xAxis[widget.q[q_index].xAxisIndex].m_sample;
                                }
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
                                if (Array.isArray(widget.q[q_index].yAxisIndex))
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
                            var series = clone_obg(defserie);
                            series.data = [];
                            series.type = widget.type;
                            data = [];
                            series.breadcrumb = {show: false};
                            for (var key in tmp_series_1)
                            {
                                var val = 0;
                                var cildren = [];
                                for (var ind in tmp_series_1[key])
                                {
                                    val = val + tmp_series_1[key][ind].value;
                                    cildren.push({value: tmp_series_1[key][ind].value, name: tmp_series_1[key][ind].name, unit: widget.options.yAxis[yAxis].unit});
                                }

                                data.push({value: val, name: key, children: cildren, unit: widget.options.yAxis[yAxis].unit});
                            }
                            series.name = tmp_series_1[Object.keys(tmp_series_1)[0]][0].name;
                            series.data = data;
                            series.upperLabel = {"normal": {"show": true, "height": 20}};
                            widget.options.series.push(series);
                        } else
                        {
                            for (var key in tmp_series_1)
                            {
                                var series = clone_obg(defserie);

                                series.data = [];
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
                                            key = key.replace("\\n", '\n');
                                            key = key.replace("\\r", '\r');
                                            series.data[i].name = key;
//                                            console.log(series.data[i]);
//                                            console.log(series);
                                        }

                                    }
                                }
                                if (series.type === "line")
                                {
//                                if (!widget.manual)
//                                {
                                    if ((widget.points !== "none") && (typeof (widget.points) !== "undefined"))
                                    {
                                        series.showSymbol = true;
                                        series.symbol = widget.points;
                                    } else
                                    {
                                        delete series.symbol;
                                        delete series.showSymbol;
                                    }
//                                }

                                }


                                if (series.type === "gauge")
                                {
                                    if (!series.axisLabel)
                                    {
                                        series.axisLabel = {};
                                    }
//                                if (!widget.manual)
//                                {
                                    var yAxis = 0;
                                    if (series.yAxisIndex)
                                    {
                                        yAxis = series.yAxisIndex[0];
                                    }
                                    var xAxis = 0;
                                    if (series.xAxisIndex)
                                    {
                                        xAxis = series.xAxisIndex[0];
                                    }

//                                console.log(yAxis);

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

                                    series.title = {color: null};
                                    if (typeof widget.options.yAxis[yAxis].axisLine !== "undefined")
                                    {
                                        if (typeof widget.options.yAxis[yAxis].axisLine.lineStyle.color !== "undefined")
                                        {
                                            series.title.color = widget.options.yAxis[yAxis].axisLine.lineStyle.color;
                                        }

                                    }
                                    if (typeof widget.options.yAxis[yAxis].nameTextStyle !== "undefined")
                                    {
                                        if (typeof widget.options.yAxis[yAxis].nameTextStyle.fontSize !== "undefined")
                                        {
                                            series.title.fontSize = widget.options.yAxis[yAxis].nameTextStyle.fontSize;
                                        }
                                    }
                                    if (typeof widget.options.yAxis[yAxis].axisLabel !== "undefined")
                                    {
                                        if (typeof widget.options.yAxis[yAxis].axisLabel.fontSize !== "undefined")
                                        {
                                            series.axisLabel.fontSize = widget.options.yAxis[yAxis].axisLabel.fontSize;
                                        }
                                    }
                                    if (typeof widget.options.xAxis[xAxis].nameTextStyle !== "undefined")
                                    {
                                        if (typeof widget.options.xAxis[xAxis].nameTextStyle.fontSize !== "undefined")
                                        {
                                            if (!series.detail)
                                            {
                                                series.detail = {};
                                            }
                                            series.detail.fontSize = widget.options.xAxis[xAxis].nameTextStyle.fontSize;
                                        }
                                    }


                                    if (typeof widget.options.yAxis[yAxis].splitNumber !== "undefined")
                                    {
                                        series.splitNumber = widget.options.yAxis[yAxis].splitNumber;
                                    } else
                                    {
                                        delete(series.splitNumber);
                                    }
//                                }

                                }

                                index++;
                                var dublicatename = false;

                                for (var s_index in widget.options.series)
                                {
                                    if (widget.options.series[s_index].name === series.name)
                                    {
                                        dublicatename = true;
                                        if (widget.options.series[s_index].data = widget.options.series[s_index].data)
                                        {
                                            widget.options.series[s_index].data = widget.options.series[s_index].data.concat(series.data);
                                            widget.options.series[s_index].data.sort(function (a, b) {
                                                return compareStrings(a.name, b.name);
                                            });
                                        }
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

                if (widget.options.xAxis[xAxis_Index].type === "time")
                {
                    if (end === "now")
                    {
                        widget.options.xAxis[xAxis_Index].max = new Date().getTime();
                    } else
                    {
                        widget.options.xAxis[xAxis_Index].max = end;
                    }
                    if (subtractlist[start])
                    {
                        widget.options.xAxis[xAxis_Index].min = moment(widget.options.xAxis[xAxis_Index].max).subtract(subtractlist[start][0], subtractlist[start][1]).valueOf();
                    } else
                    {
                        if (moment(start).isValid())
                        {
                            widget.options.xAxis[xAxis_Index].min = start
                        } else
                        {
                            delete(widget.options.xAxis[xAxis_Index].min);
                        }
//                    console.log(widget.options.xAxis[xAxis_Index].min); 
                    }

                }
            }
        }
        if (whaitlist)
            if (whaitlist[uri])
            {
                for (var uriind in whaitlist[uri])
                {
                    queryCallback(whaitlist[uri][uriind])(data);
                }
            }

        count.value--;

        if (count.value === 0)
        {
            if (widget.type === "counter")
            {
                if (!redraw)
                {
                    chart.html("");
                }

                widget.data.sort(function (a, b) {
                    return compareNameName(a, b);
                });


                for (var val in widget.data)
                {

//                    console.log(redraw);
                    var JQcounter;
                    var dataarray = widget.data[val].data;

                    var value = dataarray[dataarray.length - 1][1];
                    var valueformatter = widget.q[widget.data[val].q_index].unit;
                    var numberindex = 0;
                    var paramindex = 1;

                    if (typeof (window[valueformatter]) === "function")
                    {
                        valueformatter = window[valueformatter];
                        value = (valueformatter(value));

                    } else
                    {
                        valueformatter = widget.q[widget.data[val].q_index].unit;
                        if (!valueformatter)
                        {
                            valueformatter = "{value}";
                        }
                        var tmpvar = valueformatter.split(" ");
                        if (tmpvar[1] === "{value}")
                        {
                            numberindex = 1;
                            paramindex = 0;

                        }
                        value = valueformatter.replace(new RegExp("{value}", 'g'), Number.isInteger(value) ? value : value.toFixed(2));
                    }
                    var avalue = value.split(" ");

                    if (!redraw)
                    {
                        JQcounter = $(basecounter);
                        chart.append(JQcounter);
                        if (!widget.col)
                        {
                            widget.col = 6;
                        }
                        JQcounter.attr("class", "animated flipInY chartsection" + " col-xs-12 col-sm-" + widget.col);
                        JQcounter.find('.tile-stats h3').text(widget.data[val].name);
                        if (widget.title)
                        {
                            if (widget.title.textStyle)
                            {
                                JQcounter.find('.tile-stats h3').css(widget.title.textStyle);
                            }
                            if (widget.title.subtextStyle)
                            {
                                JQcounter.find('.tile-stats p').css(widget.title.subtextStyle);
                            }
                        }
                        JQcounter.find('.tile-stats p').text(widget.data[val].name2);

                        JQcounter.find('.tile-stats .param').text(avalue[paramindex]);

                        if (widget.valueStyle)
                        {
                            JQcounter.find('.tile-stats .number').css(widget.valueStyle);
                        }

                        if (widget.unitStyle)
                        {
                            JQcounter.find('.tile-stats .param').css(widget.unitStyle);
                        }

                        if (widget.style)
                        {
                            JQcounter.find('.tile-stats').css(widget.style);
                        }
                        JQcounter.attr("id", widget.data[val].id + val);
                    } else
                    {
                        JQcounter = chart.find("#" + widget.data[val].id + val);
                    }
//                    console.log(avalue[0]);
//                    console.log(typeof (avalue[0]));

                    if ((!isNaN(avalue[numberindex])) && (avalue[numberindex].indexOf("0x") === -1))
                    {
                        var endvalue = parseFloat(avalue[numberindex]);
                        var fix = 2;
                        if (Number.isInteger(endvalue))
                        {
                            fix = 0;
                        }
                        var steper = function (ff) {
                            return function (now) {
                                $(this).find(".number").text(now.toFixed(ff));
                            };
                        };

                        JQcounter.find(".count").prop('Counter', JQcounter.find(".count .number").text()).animate({
                            Counter: endvalue
                        }, {
                            duration: 1000,
                            easing: 'linear',
                            step: steper(fix)
                        });
                    } else
                    {
                        JQcounter.find(".count .number").text(avalue[numberindex]);
                    }
                }
                lockq[ri + " " + wi] = false;

            } else
            {
                switch (widget.type) {
                    case 'bars':
                    {
                        widget.options.tooltip.trigger = 'axis';
                        break;
                    }
                    case 'line':
                    {
                        widget.options.tooltip.trigger = 'axis';
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
//            }

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


                    switch (widget.type) {
                        case 'pie':
                        {
                            widget.options.series[i - 1].data.sort(function (a, b) {
                                return compareStrings(a.name, b.name);
                            });
                            break;
                        }
                        case 'funnel':
                        {
                            widget.options.series[i - 1].data.sort(function (a, b) {
                                return compareStrings(a.name, b.name);
                            });
                            break;
                        }

                        default:
                        {

                            break
                        }
                    }
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

                switch (widget.type) {
                    case 'pie':
                    {
                        delete widget.options.dataZoom;
                        break;
                    }
                    case 'funnel':
                    {
                        delete widget.options.dataZoom;
                        break;
                    }
                    case 'gauge':
                    {
                        delete widget.options.dataZoom;
                        break;
                    }
                    default:
                    {
                        break
                    }
                }

                for (var ind in widget.options.series)
                {

                    var ser = widget.options.series[ind];
                    var yAxis = 0;
                    if (ser.yAxisIndex)
                    {
                        if (Array.isArray(ser.yAxisIndex))
                        {
                            yAxis = ser.yAxisIndex[0];
                        } else
                        {
                            yAxis = ser.yAxisIndex;
                        }

                    }
                    if (typeof val === "undefined")
                    {
                        continue;
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

//                if (!widget.manual)
//                {
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
                            delete ser.label.normal.show;
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
                        if (!ser.axisLabel)
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
                            if (ser.label.normal.show || typeof (ser.label.normal.show) === "undefined")
                            {

                                switch (ser.type) {
                                    case 'pie':
                                    {
//                                    delete ser.label.normal.formatter;
                                        ser.label.normal.formatter = pieformater;
                                        break;
                                    }
//                                case 'funnel':
//                                {
//                                    ser.label.normal.formatter = abcformater;
//                                    break;
//                                }
//                                case 'line':
//                                {
//                                    ser.label.normal.formatter = abcformater;
//                                    break;
//                                }
                                    default:
                                    {
                                        ser.label.normal.formatter = abcformater;
//                                    if (widget.options.yAxis[yAxis].axisLabel.formatter)
//                                    {
//                                        if (typeof (widget.options.yAxis[yAxis].axisLabel.formatter) === "function")
//                                        {
//                                            console.log(widget.options.yAxis[yAxis].axisLabel);
//                                            ser.label.normal.formatter = abcformater;
//                                        } else
//                                        {
//                                            ser.label.normal.formatter = widget.options.yAxis[yAxis].axisLabel.formatter.replace("{value}", "{c}");
//                                        }
//                                    } else
//                                    {
//                                        delete ser.label.normal.formatter;
//                                    }
                                        break
                                    }
                                }


                            }
                        }

                    }
//                }

                    //Set series positions                
                    if (col > cols)
                    {
                        col = 1;
                        row++;
                    }
                    if ((ser.type === "pie") || (ser.type === "gauge"))
                    {
//                    if (!widget.manual)
//                    {
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
//                    }
                    }
                    if ((ser.type === "funnel") || (ser.type === "treemap"))
                    {
//                    if (!widget.manual)
//                    {
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
                            if (ser.type === "treemap")
                            {
                                ser.width = a;
                            } else
                            {
                                ser.width = a / 1.5;
                            }

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
                    col++;
                }

                if (widget.manual)
                {
//                    for (var oldkey in oldseries)
//                    {
//                        for (var sind in widget.options.series)
//                        {
//                            if (widget.options.series[sind].name === oldseries[oldkey].name)
//                            {
//
//                                for (var key in oldseries[oldkey]) {
//                                    if (key === "data")
//                                    {
////                                        if (oldseries[oldkey].type === "gauge")
////                                        {
////                                            for (i = 0; i < widget.options.series[sind].data.length; i++)
////                                            {
////                                                widget.options.series[sind].data[i].subname = oldseries[sind].data[i].subname;
////                                                widget.options.series[sind].data[i].name = oldseries[sind].data[i].name;
////                                            }
//
////                                        }
//                                        continue;
//                                    }
//                                    if (key === "axisLabel")
//                                    {
//                                        console.log(widget.options.series[sind][key]);
//                                    }
//
//
//                                    widget.options.series[sind][key] = oldseries[oldkey][key];
//                                    widget.options.series[sind].restored = true;
//                                }
//                                delete oldseries[oldkey];
//                                break;
//                            }
//                        }
//                    }

                    for (var oldkey in oldseries)
                    {
                        for (var sind in widget.options.series)
                        {
                            if (widget.options.series[sind].restored !== true)
                            {

                                for (var key in oldseries[oldkey]) {
                                    if ((key === "data") || (key === "name"))
                                    {
                                        continue;
                                    }
//                                    {
//                                        console.log(widget.options.series[sind][key]);
//                                    }
//                                    widget.options.series[sind][key] = Object.assign({}, widget.options.series[sind][key], oldseries[oldkey][key])
//                                    


                                    if ((key === "axisLabel" || key === "detail") & (typeof widget.options.series[sind][key] !== "undefined"))
                                    {
                                        for (var key2 in oldseries[oldkey][key])
                                            if (typeof oldseries[oldkey][key][key2] !== "undefined")
                                            {
                                                widget.options.series[sind][key][key2] = oldseries[oldkey][key][key2];
                                            }

                                    } else
                                    {
                                        widget.options.series[sind][key] = oldseries[oldkey][key];
                                    }
                                    widget.options.series[sind].restored = true;
                                }
                                delete oldseries[oldkey];
                                break;
                            }
                        }
                    }
                }
                var tmpLegend = [];
                var tmpLegendSer = [];
                for (var ind in widget.options.series)
                {

                    var ser = widget.options.series[ind];
                    delete ser.restored;
                    var xAxisIndex = 0;
                    if (widget.options.series[ind].xAxisIndex)
                    {
                        xAxisIndex = widget.options.series[ind].xAxisIndex[0];
                    }

                    if (!widget.options.xAxis[xAxisIndex])
                    {
                        xAxisIndex = 0;
                    }

                    if (tmpLegendSer.indexOf(widget.options.series[ind].name) === -1)
                    {
                        tmpLegendSer.push(widget.options.series[ind].name);
                    }
                    if (widget.options.xAxis[xAxisIndex].type === "category")
                    {
                        widget.options.series[ind].unit = widget.options.yAxis[0].unit;
                        if ((widget.type === "bar") || (widget.type === "line"))
                        {
                            widget.options.series[ind].data.sort(function (a, b) {
                                return compareStrings(a.name, b.name);
                            });
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
                                if (tmpLegend.indexOf(widget.options.series[ind].data[sind].name) === -1)
                                {
                                    tmpLegend.push(widget.options.series[ind].data[sind].name);
                                }

                            }
                        } else if (widget.options.series[ind].type === "treemap")
                        {
                            widget.options.series[ind].levels = getLevelOption(widget.options.series.length, widget.options.series[ind].data[0].children.length);
                            for (var sind in widget.options.series[ind].data)
                            {
                                if (widget.options.legend.data.indexOf(widget.options.series[ind].data[sind].name) === -1)
                                {
                                    widget.options.legend.data.push(widget.options.series[ind].data[sind].name);
                                }

                            }

                        }

                    }
//                console.log(widget.options.legend.data);
                }
                if (widget.options.series[ind])
                {
                    if ((widget.options.series[ind].type === "pie") || (widget.options.series[ind].type === "funnel"))
                    {
                        tmpLegend.sort();
                        for (var sind in tmpLegend)
                        {
                            widget.options.legend.data.push({name: tmpLegend[sind]});
                        }
                        for (var sind in tmpLegendSer)
                        {
                            widget.options.legend.data.push({name: tmpLegendSer[sind], icon: 'diamond'});
                        }

                    } else
                    {
                        widget.options.legend.data = tmpLegendSer;
                    }
                }
//*************************************            
//            console.log(widget.options.series);
                if (redraw)
                {
                    var datalist = [];
                    for (var key in widget.options.series)
                    {
                        var ss = widget.options.series[key];
                        datalist.push({data: ss.data});
                    }
                    chart.setOption({series: datalist, xAxis: widget.options.xAxis});

                } else
                {
                    chart.setOption(widget.options, true);
                }

                chart.hideLoading();
                lockq[ri + " " + wi] = false;
                if (callback !== null)
                {
                    callback();
                }
            }
            var GlobalRefresh = true;
            if (widget.times)
            {
                if (widget.times.intervall)
                {
                    if (widget.times.intervall !== "General")
                    {
                        GlobalRefresh = false;
                        if (widget.times.intervall !== "off")
                        {
                            widget.timer = setTimeout(function () {
                                setdatabyQ(json, ri, wi, url, true, null, customchart);
                            }, widget.times.intervall);
                        }
                    }
                }
            }
            if (GlobalRefresh)
            {
                if (json.times.intervall)
                {
                    widget.timer = setTimeout(function () {
                        setdatabyQ(json, ri, wi, url, true, null, customchart);
                    }, json.times.intervall);
                }
            }
        }
        ;


    };
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

var lockq = {};
function setdatabyQ(json, ri, wi, url, redraw = false, callback = null, customchart = null) {
    if (lockq[ri + " " + wi])
    {
        return;
    }
    var prevuri = "";
    var whaitlist = {};
    var widget = json.rows[ri].widgets[wi];
    if (widget.timer)
        if (widget.timer)
        {
            clearTimeout(widget.timer);
        }

    var chart;
    if (customchart === null)
    {
        chart = json.rows[ri].widgets[wi].echartLine;
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
    var k;

    //Cheto kaskacelija ****************************************************
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
            if (json.times.pickerlabel)
            {
                if (typeof (rangeslabels[json.times.pickerlabel]) !== "undefined")
                {
                    start = rangeslabels[json.times.pickerlabel];
                } else
                {
                    start = json.times.pickerstart;
                }
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
                end = "now";
                usePersonalTime = true;
            }

        }
    }

    var count = {"value": widget.q.length, "base": widget.q.length};

    for (k in widget.q)
    {
        if (widget.q[k].check_disabled || (!widget.q[k].info) || (!widget.q[k].info.metrics))
        {
            count.base--;
        }
    }

//    lockq[ri + " " + wi] = true;
    count.value = count.base;
    var oldseries = {};
    if (widget.type === "counter")
    {
        oldseries = clone_obg(widget.series);
    } else
    {
        oldseries = clone_obg(widget.options.series);
        widget.options.series = [];
    }



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
        if (widget.type === "counter")
        {
//            updatecounter(chart, widget);
            widget.data = [];
            if (getParameterByName('metrics', uri))
            {
                if (prevuri !== uri)
                {
                    if (chart.attr("id") === "singlewidget")
                    {
                        chart.attr("class", " col-xs-12 col-sm-" + widget.size);
                    }
                    var inputdata = [k, widget, oldseries, chart, count, json, ri, wi, url, redraw, callback, customchart, start, end, whaitlist, uri];
                    lockq[ri + " " + wi] = true;
                    $.ajax({
                        dataType: "json",
                        url: uri,
                        data: null,
                        success: queryCallback(inputdata),
                        error: function (xhr, error) {
                            chart.hideLoading();
                            $(chart).before("<h2 class='error'>Invalid Query");
                        }
                    });
                } else
                {
                    if (!whaitlist[uri])
                    {
                        whaitlist[uri] = [];
                    }
                    whaitlist[uri].push([k, widget, oldseries, chart, count, json, ri, wi, url, redraw, callback, customchart, end, null, uri]);
                }
                prevuri = uri;

            }
        } else if (chart)
        {
            if (chart._dom.className !== "echart_line_single")
            {
                if (chart._dom.className + $(chart._dom).css('width') !== $(chart._dom).children().css('width'))
                {
                    chart.resize();
                }
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

            //Cheto kaskacelija ****************************************************   
            if (!widget.options.legend)
            {
                widget.options.legend = {data: []};
            } else
            {
                widget.options.legend.data = [];
            }
//            if ((widget.type === "pie" || widget.type === "funnel" || widget.type === "gauge" || widget.type === "treemap"))
//            {
//                if (widget.options.toolbox.feature)
//                {
//                    widget.options.toolbox.feature.magicType.show = (!(widget.type === "pie" || widget.type === "funnel" || widget.type === "gauge" || widget.type === "treemap"));
//                } else
//                {
//                    widget.options.toolbox.feature = {magicType: {show: false}};
//                }
//            } else
//            {
//                widget.options.toolbox = {};
//            }

            if (count.base === 0)
            {
                var tmpseries = clone_obg(widget.options.series);
                for (var tk in tmpseries)
                {
                    tmpseries[tk].data = [];
                }
                chart.setOption(widget.options);
                return;
            }
            if (getParameterByName('metrics', uri))
            {
                chart.showLoading("default", {
                    text: '',
                    color: colorPalette[colorPalette.length - 1],
                    textColor: '#000',
                    maskColor: 'rgba(255, 255, 255, 0)',
                    zlevel: 0
                });
                $(chart._dom).parent().find('.error').remove();
                if (prevuri !== uri)
                {
                    var inputdata = [k, widget, oldseries, chart, count, json, ri, wi, url, redraw, callback, customchart, start, end, whaitlist, uri];
                    lockq[ri + " " + wi] = true;
                    $.ajax({
                        dataType: "json",
                        url: uri,
                        data: null,
                        success: queryCallback(inputdata),
                        error: function (xhr, error) {
                            chart.hideLoading();
                            $(chart._dom).before("<h2 class='error'>Invalid Query");
                        }
                    });
                } else
                {
                    if (!whaitlist[uri])
                    {
                        whaitlist[uri] = [];
                    }
                    whaitlist[uri].push([k, widget, oldseries, chart, count, json, ri, wi, url, redraw, callback, customchart, end, null, uri]);
                }
                prevuri = uri;

            }

        }
}

}
function AutoRefresh(redraw = false) {
    redrawAllJSON(gdd, redraw);
}
function AutoRefreshSingle(row, index, readonly = false, rebuildform = true, redraw = false) {
    var opt = gdd.rows[row].widgets[index];

    showsingleWidget(row, index, gdd, readonly, rebuildform, redraw, function () {
        if (rebuildform)
        {
            $('html, body').animate({
                scrollTop: 0
            }, 500);
        }

//        var jsonstr = JSON.stringify(opt, jsonmaker);
//        editor.set(JSON.parse(jsonstr));
    });
}
function redrawAllJSON(dashJSON, redraw = false) {
    var ri;
    var wi;
    $(".editchartpanel").hide();
    $(".fulldash").show();
    if (dashJSON.locked)
    {
        $(".fulldash").addClass('locked');
        $('#btnlock').addClass('btnunlock');
        $('#btnlock i').addClass('fa-unlock');
        $('.text-right').hide();
    }
    locktooltip();
    if (!redraw)
    {
        $("#dashcontent").html("");
    }
    for (ri in dashJSON.rows)
    {
        var tmprow = dashJSON.rows[ri];

        if (tmprow === null)
        {
            dashJSON.rows.splice(ri, 1);
            continue;
        }
        if (!redraw)
        {
//            $("#rowtemplate .widgetraw").attr("index", ri);
            $("#rowtemplate .widgetraw").attr("id", "row" + ri);
            var html = $("#rowtemplate").html();
            $("#dashcontent").append(html);
            $("#rowtemplate .widgetraw").attr("id", "row");
        }
        var name = "";
        if (typeof tmprow.name === "undefined")
        {
            name = 'Row:' + ri;
        } else
        {
            name = tmprow.name;
        }

        $("#row" + ri).find('.item_title .title_text span').html(name);
        $("#row" + ri).find('.item_title .title_input input').val(name);

        if (tmprow.colapsed)
        {
            var colapserow = $("#row" + ri).find('.colapserow');
            colapserow.removeClass('colapserow');
            colapserow.addClass('expandrow');
            colapserow.find('i').removeClass('fa-chevron-up');
            colapserow.find('i').addClass('fa-chevron-down');
            colapserow.attr('data-original-title', 'Expand');

            continue;
        }

        for (wi in tmprow.widgets)
        {

            if (tmprow.widgets[wi] === null)
            {
                tmprow.widgets.splice(wi, 1);
                continue;
            }

            if (!tmprow.widgets[wi].echartLine || !redraw)
            {
                var bkgclass = "";
                clearTimeout(tmprow.widgets[wi].timer);
                var chartobj = $($("#charttemplate").html());

                chartobj.attr("size", tmprow.widgets[wi].size);

                if (tmprow.widgets[wi].options)
                {
                    if (tmprow.widgets[wi].options.backgroundColor)
                    {
                        chartobj.find(" > div").css("background-color", tmprow.widgets[wi].options.backgroundColor);
                    } else
                    {
                        chartobj.find(" > div").css("background-color", "");
                    }
                } else
                {
                    chartobj.find(" > div").css("background-color", "");
                }
                if (tmprow.widgets[wi].title) {
                    if (tmprow.widgets[wi].title.text) {
                        chartobj.find(".chartTitle h3").html(tmprow.widgets[wi].title.text);
                        if (tmprow.widgets[wi].title.style)
                        {
                            chartobj.find(".chartTitleDiv").css(tmprow.widgets[wi].title.style);
                            chartobj.find(".chartTitleDiv h3").css('font-size', tmprow.widgets[wi].title.style.fontSize);
                        } else
                        {
                            chartobj.find(".chartTitleDiv").removeAttr("style");
                        }
                    }
                    ;
                    if (tmprow.widgets[wi].title.subtext) {
                        if (tmprow.widgets[wi].title.sublink) {
                            chartobj.find(".chartSubText").attr('href', tmprow.widgets[wi].title.sublink);
                            chartobj.find(".chartSubText").attr('target', '_' + tmprow.widgets[wi].title.subtarget);
                        } else {
                            chartobj.find(".chartSubText").removeAttr('href');
                        }
                        ;
                        chartobj.find(".chartSubText").html(tmprow.widgets[wi].title.subtext);
                        if (tmprow.widgets[wi].title.subtextStyle)
                        {
                            chartobj.find(".chartSubText").css(tmprow.widgets[wi].title.subtextStyle);
                        } else
                        {
                            chartobj.find(".chartSubText").removeAttr("style");
                        }
                    } else {
                        chartobj.find(".chartSubIcon").css({display: 'none'});
                    }
                    ;
                }
                ;

//                $("#charttemplate .chartsection").attr("index", wi);
                chartobj.attr("id", "widget" + ri + "_" + wi);
                chartobj.attr("type", tmprow.widgets[wi].type);
                chartobj.attr("class", "chartsection " + bkgclass + " col-xs-12 col-md-" + tmprow.widgets[wi].size);
                chartobj.find(".echart_line").attr("id", "echart_line" + ri + "_" + wi);
                chartobj.find(".echart_line").html("");

                if (tmprow.widgets[wi].times)
                {
                    if (tmprow.widgets[wi].times.pickerlabel)
                    {
                        chartobj.find(".echart_time_icon").css({display: 'block'});
                        if (tmprow.widgets[wi].times.pickerlabel !== "Custom")
                        {
                            chartobj.find(".echart_time").append(tmprow.widgets[wi].times.pickerlabel + " ");
                        } else
                        {
                            chartobj.find(".echart_time").append("From " + moment(tmprow.widgets[wi].times.pickerstart).format('MM/DD/YYYY H:m:s') + " to " + moment(tmprow.widgets[wi].times.pickerend).format('MM/DD/YYYY H:m:s') + " ");
                        }
                    }
                    if (tmprow.widgets[wi].times.intervall)
                    {
                        if (tmprow.widgets[wi].times.intervall !== "General")
                        {
                            chartobj.find(".echart_time_icon").css({display: 'block'});
                            chartobj.find(".echart_time").append(EditForm.refreshtimes[tmprow.widgets[wi].times.intervall]);
                        }
                    }
                }
                if (typeof (tmprow.widgets[wi].height) !== "undefined")
                {
                    chartobj.find(".echart_line").css("height", tmprow.widgets[wi].height);
                    if (tmprow.widgets[wi].height === "")
                    {
                        chartobj.find(".echart_line").css("height", "300px");
                    }
                } else
                {
                    chartobj.find(".echart_line").css("height", "300px");
                }
                $("#row" + ri).find(".rowcontent").append(chartobj);
                chartobj.find(".echart_time").attr("id", "echart_line");
            }

            if (tmprow.widgets[wi].type !== "counter")
            {
                if (typeof (tmprow.widgets[wi].options) === "undefined")
                {
                    tmprow.widgets[wi].options = clone_obg(defoption);
                    tmprow.widgets[wi].options.series[0].symbol = "none";
                    tmprow.widgets[wi].options.series[0].data = datafunc();
                }
            }

            if (typeof (tmprow.widgets[wi].q) === "undefined")
            {
                tmprow.widgets[wi].q = clone_obg(tmprow.widgets[wi].queryes);
                delete tmprow.widgets[wi].queryes;
            }



            if (typeof (tmprow.widgets[wi].q) !== "undefined")
            {
                if (!tmprow.widgets[wi].echartLine || !redraw)
                {
                    if (tmprow.widgets[wi].type === "counter")
                    {
                        $("#echart_line" + ri + "_" + wi).removeAttr("style");
//                        $("#echart_line" + ri + "_" + wi).append(basecounter);
                        tmprow.widgets[wi].echartLine = $("#echart_line" + ri + "_" + wi);
                    } else
                    {
                        tmprow.widgets[wi].echartLine = echarts.init(document.getElementById("echart_line" + ri + "_" + wi), 'oddeyelight');
                    }
                }

                setdatabyQ(dashJSON, ri, wi, "getdata", redraw);
            } else
            {
                if (tmprow.widgets[wi].type === "counter")
                {
                    $("#echart_line" + ri + "_" + wi).removeAttr("style");
//                    $("#echart_line" + ri + "_" + wi).append(basecounter);
//                    updatecounter($("#echart_line" + ri + "_" + wi), tmprow.widgets[wi]);
                } else
                {
                    if (tmprow.widgets[wi].options.series.length === 1)
                    {
                        if (!tmprow.widgets[wi].options.series[0].data)
                        {
                            tmprow.widgets[wi].options.series[0].data = datafunc();
                        } else
                        if (tmprow.widgets[wi].options.series[0].data.length === 0)
                        {
                            tmprow.widgets[wi].options.series[0].data = datafunc();
                        }
                    }

                    tmprow.widgets[wi].echartLine = echarts.init(document.getElementById("echart_line" + ri + "_" + wi), 'oddeyelight');
                    if (!tmprow.widgets[wi].options.series[0])
                    {
                        tmprow.widgets[wi].options.series[0] = {};
                    }
                    tmprow.widgets[wi].options.series[0].type = "line";

                    tmprow.widgets[wi].echartLine.setOption(tmprow.widgets[wi].options);
                }
            }

            $("#charttemplate .chartsection").attr("id", "widget");

        }

        $("#row" + ri + " .rowcontent").sortable({
            cursor: "move",
            appendTo: ".rowcontent",
            cancel: "canvas,input,.echart_line,.chartTitle"
        });


        var wingetindrag = false;
        $("#row" + ri + " .rowcontent").on('sortstart', function (event, ui) {
            ui.item.find('.inner').css('border', "5px solid rgba(200,200,200,1)");
            var ri = ui.item.parents(".widgetraw").index();
            var wi = ui.item.index();
            wingetindrag = [ri, wi];
        });
        $("#row" + ri + " .rowcontent").on('sortstop', function (event, ui) {
            event.stopPropagation();
            ui.item.find('.inner').removeAttr('style');
            var ri = ui.item.parents(".widgetraw").index();
            var wi = ui.item.index();
            var tmpwid = (gdd.rows[wingetindrag[0]].widgets[wingetindrag[1]]);
            if (wingetindrag !== false)
            {
                gdd.rows[wingetindrag[0]].widgets.splice(wingetindrag[1], 1);
            }
            gdd.rows[ri].widgets.splice(wi, 0, tmpwid);
            if (gdd.rows[ri].widgets[wi].options)
            {
                if (gdd.rows[ri].widgets[wi].options.backgroundColor)
                {
                    ui.item.find('.inner').css("background-color", gdd.rows[ri].widgets[wi].options.backgroundColor);
                } else
                {
                    ui.item.find('.inner').css("background-color", "");
                }
            }

            wingetindrag = false;
            domodifier();
        });
    }
    $('.fulldash .btn').tooltip();
}
function showsingleWidget(row, index, dashJSON, readonly = false, rebuildform = true, redraw = false, callback = null) {
    $(".fulldash").hide();
    for (var ri in dashJSON.rows)
    {
        var tmprow = dashJSON.rows[ri];
        for (var wi in    tmprow.widgets)
        {
            if (tmprow.widgets[wi])
            {
                clearTimeout(tmprow.widgets[wi].timer);
            }
        }
    }


    if (rebuildform)
    {
        Edit_Form = null;
    }
    //Rename queryes to q
    if (typeof (dashJSON.rows[row].widgets[index].q) === "undefined")
    {
        dashJSON.rows[row].widgets[index].q = clone_obg(dashJSON.rows[row].widgets[index].queryes);
        delete dashJSON.rows[row].widgets[index].queryes;
    }
    //Change queryes downsample 

    if (dashJSON.rows[row].widgets[index].q)
    {
        for (var qindex in dashJSON.rows[row].widgets[index].q)
        {
            if (dashJSON.rows[row].widgets[index].q[qindex].info)
            {
                if (dashJSON.rows[row].widgets[index].q[qindex].info.downsample)
                {
                    var ds_ = dashJSON.rows[row].widgets[index].q[qindex].info.downsample.split("-");
                    dashJSON.rows[row].widgets[index].q[qindex].info.ds = {};
                    dashJSON.rows[row].widgets[index].q[qindex].info.ds.time = ds_[0];
                    dashJSON.rows[row].widgets[index].q[qindex].info.ds.aggregator = ds_[1];
                    delete dashJSON.rows[row].widgets[index].q[qindex].info.downsample;
                }
            }

        }
    }
    var acprefix = "Edit";
    if (readonly)
    {
        acprefix = "Show";
    }
    var title = acprefix + " Chart";
    var W_type = dashJSON.rows[row].widgets[index].type;

    if (W_type === "table")
    {
        title = acprefix + " Table";
    }

    if (W_type === "counter")
    {
        title = acprefix + " Numeric";
    }
    if (rebuildform)
    {
        $(".right_col").append('<div class="x_panel editpanel"></div>');
        if (!readonly)
        {
            $(".right_col .editpanel").append('<div class="x_title dash_action">' +
                    '<h1 class="col-md-3">' + title + '</h1>' +
                    '<div class="pull-right">' +
                    '<span><a class="btn btn-primary savedash"  type="button">Save </a></span>' +
                    '<a class="btn btn-primary backtodush" type="button">Back to Dash </a>' +
                    '</div>' +
                    '<div class="clearfix"></div>' +
                    '</div>');
            $(".right_col .editpanel").addClass("singleedit");

        } else
        {
            $(".right_col .editpanel").append('<div class="x_title dash_action">' +
                    '<h1 class="col-md-3">' + title + '</h1>' +
                    '<div class="pull-right">' +
                    '<a class="btn btn-primary backtodush" type="button">Back to Dash </a>' +
                    '</div>' +
                    '<div class="clearfix"></div>' +
                    '</div>');
            $(".right_col .editpanel").addClass("singleview");
        }

        if (dashJSON.locked)
        {
            $(".right_col .editpanel").addClass('locked');
        }
        $(".right_col .editpanel").append($("#dash_main").html());
        $(".right_col .editpanel").append('<div class="clearfix"></div>');
        if (W_type === "counter")
        {
            $(".right_col .editpanel").append('<div class="' + " col-xs-12 col-md-" + dashJSON.rows[row].widgets[index].size + '" id="singlewidget">' +
                    '<div class="counter_single" id="counter_single"></div>' +
                    '</div>');
//            if (typeof (dashJSON.rows[row].widgets[index].q) !== "undefined")
//            {
//                setdatabyQ(dashJSON, row, index, "getdata", redraw, callback, $(".right_col .editpanel #singlewidget"));
//            } else
//            {
////                updatecounter($(".right_col .editpanel"), tmprow.widgets[wi]);
//            }
            if (!readonly)
            {
                $(".right_col .editpanel").append('<div class="x_content edit-form">');
                Edit_Form = new CounterEditForm($(".edit-form"), row, index, dashJSON, domodifier);
//                $(".editchartpanel select").select2({minimumResultsForSearch: 15});
            }


        } else if (W_type === "table")
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
                    var wraper = $(".right_col .editpanel #singlewidget");
                } else
                {
                    var height = "300px";
                    if (typeof (dashJSON.rows[row].widgets[index].height) !== "undefined")
                    {
                        if (dashJSON.rows[row].widgets[index].height === "")
                        {
                            dashJSON.rows[row].widgets[index].height = "300px";
                        }
                        height = dashJSON.rows[row].widgets[index].height;
                    }
                    var wraper = $('<div class="x_content" id="singlewidget">' +
                            '<div class="echart_line_single" id="echart_line_single" ></div>' +
                            '</div>');
                    wraper.find(".echart_line_single").css("height", height);
                    $(".right_col .editpanel").append(wraper);
                }
                echartLine = echarts.init(document.getElementById("echart_line_single"), 'oddeyelight');
            }


            if (!readonly)
            {
                $(".right_col .editpanel").append('<div class="x_content edit-form">');
                Edit_Form = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON, domodifier);
            }

        }
    } else
    {
        var wraper = $(".right_col .editpanel #singlewidget");
    }

//    else
//    {
    if (W_type === "counter")
    {
        if (typeof (dashJSON.rows[row].widgets[index].q) !== "undefined")
        {
            setdatabyQ(dashJSON, row, index, "getdata", redraw, callback, $(".right_col .editpanel #singlewidget"));
        } else
        {
//                updatecounter($(".right_col .editpanel"), dashJSON.rows[row].widgets[index]);
        }

    } else if (W_type === "table")
    {

    } else //chart
    {

        //TODO Drow single widget title


//        console.log(dashJSON.rows[row].widgets[index]);
        var singleWi = dashJSON.rows[row].widgets[index];

        if (rebuildform) {
            wraper.prepend('<div class="chartTitleDiv">' + '<div class="chartDesc wrap">' +
                    '<div class="borderRadius">' + '<span class="chartSubIcon" style="display: none">'
                    + '<i class="fa fa-info"></i> ' + '</span>' + '</div>' +
                    '<a class="chartSubText hoverShow">' + '</a>' + '</div>' + '<div class="chartTime wrap">'
                    + '<div class="borderRadius">' + '<span class="echart_time_icon">' + '<i class="fa fa-clock-o"></i>'
                    + '</span>' + '</div>' + '<span class="echart_time hoverShow" id="echart_line">'
                    + '<span class="last">' + '</span>' + '<span class="refreshEvery" >' + '</span>' +
                    '</span>' + '</div>' + '<div class=chartTitle>' + $('#charttemplate .chartTitle').html() + '</div>' +
                    "</div>");
            var wraperTitle = wraper.find('.chartTitleDiv');
        } else {
            var wraperTitle = $('#singlewidget .chartTitleDiv');
        }
        if (singleWi.title) {
            if (!singleWi.title.text) {
                wraperTitle.find('.chartTitle').css({display: 'none'});
                wraperTitle.removeAttr("style");
            } else {
                wraperTitle.find('.chartTitle').css({display: 'inline-block'});
                wraperTitle.find('.chartTitle h3').text(singleWi.title.text);
                if (singleWi.title.style) {
                    wraperTitle.css(singleWi.title.style);
                    wraperTitle.find('.chartTitle h3').css('font-size', singleWi.title.style.fontSize);
                } else {
                    wraperTitle.find('.chartTitle').removeAttr("style");
                }
                ;
            }
            if (!singleWi.title.subtext) {
                wraperTitle.find('.chartSubIcon').css({display: 'none'});
            } else {
                wraperTitle.find('.chartSubText').text(singleWi.title.subtext);
                if (singleWi.title.subtextStyle) {
                    wraperTitle.find('.chartSubText').css(singleWi.title.subtextStyle);
                } else
                {
                    wraperTitle.find('.chartSubText').removeAttr("style");
                }
                ;
                wraperTitle.find('.chartSubIcon').css({display: 'block'});
            }
            if (!singleWi.title.sublink) {
                wraperTitle.find('.chartSubText').removeAttr('href');
            } else {
                wraperTitle.find('.chartSubText').attr('href', singleWi.title.sublink);
                wraperTitle.find('.chartSubText').attr('target', '_' + singleWi.title.subtarget);
            }
        } else {
            wraperTitle.find('.chartTitleDiv').css({display: 'none'});
        }
        if (singleWi.times) {
            if (singleWi.times.pickerlabel)
            {
                ;
                wraperTitle.find(".echart_time_icon").css({display: 'block'});
                if (singleWi.times.pickerlabel !== "Custom")
                {
                    wraperTitle.find(".echart_time .last").html(singleWi.times.pickerlabel + " ");
                } else
                {
                    wraperTitle.find(".echart_time .last").html("From " + moment(singleWi.times.pickerstart).format('MM/DD/YYYY H:m:s') + " to " + moment(tmprow.widgets[wi].times.pickerend).format('MM/DD/YYYY H:m:s') + " ");
                }
            } else {
                wraperTitle.find(".echart_time .last").html(' ');
            }
            if (singleWi.times.intervall)
            {
                if (singleWi.times.intervall !== "General")
                {
                    wraperTitle.find(".echart_time_icon").css({display: 'block'});
                    wraperTitle.find(".echart_time .refreshEvery").html(EditForm.refreshtimes[singleWi.times.intervall]);
                } else {
                    wraperTitle.find(".echart_time .refreshEvery").html(' ');
                }
            }
        }

        if (typeof (dashJSON.rows[row].widgets[index].q) !== "undefined")
        {
            setdatabyQ(dashJSON, row, index, "getdata", redraw, callback, echartLine);
        } else
        {
            echartLine.setOption(dashJSON.rows[row].widgets[index].options);
        }
    }
//    }


    return;
}

function repaint(redraw = false, rebuildform = true) {
    doapplyjson = true;
    if (gdd.times.generalds)
    {
        $('#global-down-sample').val(gdd.times.generalds[0]);
        $('#global-down-sample-ag').val(gdd.times.generalds[1]).trigger('change');
        var check = document.getElementById('global-downsampling-switsh');
        if (gdd.times.generalds[2])
        {
            if (check.checked !== gdd.times.generalds[2])
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
//        console.log(window.location.search.substring(1));        
//        window.history.pushState({}, "", window.location.pathname);
        AutoRefresh(redraw);
    } else
    {
        var NoOpt = false;
        if (typeof (gdd.rows[request_R_index]) === "undefined")
        {
            NoOpt = true;
        }

        if (!NoOpt)
        {
            if (typeof (gdd.rows[request_R_index].widgets[request_W_index]) === "undefined")
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
            clearTimeout(gdd.rows[request_R_index].widgets[request_W_index].timer);
            var action = getParameterByName("action");
            AutoRefreshSingle(request_R_index, request_W_index, action !== "edit", rebuildform, redraw);
            $(".editchartpanel select").select2({minimumResultsForSearch: 15});
            $(".select2_group").select2({dropdownCssClass: "menu-select"});
        }
    }
    doapplyjson = false;
}


$(document).ready(function () {

    $("#global-down-sample-ag").select2({minimumResultsForSearch: 15, data: EditForm.aggregatoroptions_selct2});

    $("#dashcontent").sortable({
        cursor: "move",
        appendTo: ".rowcontent",
        cancel: "canvas,input,.echart_line,.chartTitle"
    });
    var rowdrag = false;
    if (getParameterByName("startdate"))
    {
        if ($.isNumeric(getParameterByName("startdate")))
        {
            gdd.times.pickerstart = getParameterByName("startdate") * 1;
        } else
        {
            gdd.times.pickerstart = getParameterByName("startdate");
        }

        if (moment(gdd.times.pickerstart).isValid())
        {
            gdd.times.pickerlabel = "Custom";
        } else
        {
            gdd.times.pickerlabel = gdd.times.pickerstart;
        }

        for (var label in rangeslabels)
        {
            if (rangeslabels[label] === gdd.times.pickerstart)
            {
                gdd.times.pickerlabel = label;
            }

        }

    }
    if (getParameterByName("enddate"))
    {
        if ($.isNumeric(getParameterByName("enddate")))
        {
            gdd.times.pickerend = getParameterByName("enddate") * 1;
        } else
        {
            gdd.times.pickerend = getParameterByName("enddate");
        }

    }

    if (getParameterByName("ds"))
    {
        gdd.times.generalds = getParameterByName("ds").split(",");
        gdd.times.generalds[2] = (gdd.times.generalds[2] == 'true');
    }
    //&ds="+gdd.times.generalds
    $("#dashcontent").on('sortstart', function (event, ui) {
        var ri = ui.item.index();
        for (var lri in gdd.rows)
        {
            for (var wi in    gdd.rows[lri].widgets)
            {
                if (gdd.rows[lri].widgets[wi])
                {
                    clearTimeout(gdd.rows[lri].widgets[wi].timer);
                }
            }
        }
        rowdrag = ri;
    });
    $("#dashcontent").on('sortstop', function (event, ui) {
        var ri = ui.item.index();
        var tmprow = (gdd.rows[rowdrag]);
        if (rowdrag !== false)
        {
            gdd.rows.splice(rowdrag, 1);
        }
        gdd.rows.splice(ri, 0, tmprow);
        redrawAllJSON(gdd);
        domodifier();
        rowdrag = false;
    });
//Old style Update te new
    if (!gdd.rows) {
        var rows = [];
        for (var ri in gdd)
        {
            if (ri !== 'times')
            {
                var wid = [];
                for (var wi in gdd[ri].widgets)
                {
                    wid.push(clone_obg(gdd[ri].widgets[wi]));
                }
                rows.push({widgets: wid});
                delete gdd[ri];
            }


        }
        gdd.rows = rows;
    }


    for (var ri in gdd.rows)
    {

        for (var wi in gdd.rows[ri].widgets)
        {
            var wid = gdd.rows[ri].widgets[wi];
            if (wid.options)
            {
                wid.title = wid.options.title;
                delete wid.options.title;
            }

        }
    }

//    console.log(gdd);
    if (gdd.times) {
        if (gdd.times.intervall)
        {
            $("#refreshtime").val(gdd.times.intervall);
        }
        var label = pickerlabel;
        if (gdd.times.pickerlabel)
        {
            label = gdd.times.pickerlabel;
        }

        $('#reportrange span').html(label);
        if (label === "Custom")
        {
            PicerOptionSet1.startDate = moment(gdd.times.pickerstart);
            PicerOptionSet1.endDate = moment(gdd.times.pickerend);
            $('#reportrange span').html(PicerOptionSet1.startDate.format('MM/DD/YYYY HH:mm:ss') + ' - ' + PicerOptionSet1.endDate.format('MM/DD/YYYY HH:mm:ss'));

        } else
        {
            if (PicerOptionSet1.ranges[label])
            {
                PicerOptionSet1.startDate = PicerOptionSet1.ranges[label][0];
                PicerOptionSet1.endDate = PicerOptionSet1.ranges[label][1];
            }
        }

    } else {
        gdd.times = {};
        $('#reportrange span').html(pickerlabel);
    }

    repaint();

    var elem = document.getElementById('global-downsampling-switsh');
    var switchery = new Switchery(elem, {size: 'small', color: '#26B99A'});
    elem.onchange = function () {
        if (!$(this).attr('autoedit'))
        {
            if (!gdd.times.generalds)
            {
                gdd.times.generalds = [];
            }
            gdd.times.generalds[2] = this.checked;
            repaint(true, false);
            domodifier();
        }

    };

    $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
        var startdate = "5m-ago";
        var enddate = "now";
        if (gdd.times.pickerlabel === "Custom")
        {
            startdate = gdd.times.pickerstart;
            enddate = gdd.times.pickerend;
        } else
        {
            if (typeof (rangeslabels[gdd.times.pickerlabel]) !== "undefined")
            {
                startdate = rangeslabels[gdd.times.pickerlabel];
            } else
            {
                startdate = gdd.times.pickerstart;
            }

        }
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }

        $('#global-down-sample').val(gdd.times.generalds[0]);
        if ($('#global-down-sample-ag').val() === "")
        {
            $('#global-down-sample-ag').val(gdd.times.generalds[1]);
        }
        //TODO Fix redraw
        var check = document.getElementById('global-downsampling-switsh');
        if (gdd.times.generalds[2])
        {
            if (check.checked !== gdd.times.generalds[2])
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
            showsingleWidget(request_R_index, request_W_index, gdd, action !== "edit", false, false);
        } else
        {
            window.history.pushState({}, "", "?&startdate=" + startdate + "&enddate=" + enddate + "&ds=" + gdd.times.generalds);
            redrawAllJSON(gdd);
        }
        domodifier();
    });
    $("#refreshtime").select2({minimumResultsForSearch: 15});

    if (typeof getmindate === "function") {
        PicerOptionSet1.minDate = getmindate();
    }

    $('#reportrange').daterangepicker(PicerOptionSet1, cbJson(gdd, $('#reportrange')));
//    var mousemovetimer;
//    $('body').on("mousemove", "canvas", function (e) {
//        var item = e.toElement;
//        if ($(item).parents('.locked').length > 0)
//        {
//            e.stopPropagation();
//            clearTimeout(mousemovetimer);
//
//            mousemovetimer = setTimeout(function () {
//                if (item.tagName.toUpperCase() === 'CANVAS')
//                {
//                    $(item).parents('.chartsection').append("<div class='lockedbuttons' style=''> <div class='btn-group btn-group-xs' style=''> <a class='btn btn-default viewchart' type='button' data-toggle='tooltip' data-placement='top' data-original-title='View' style=''>View</a><a class='btn btn-default csv' type='button' data-toggle='tooltip' data-placement='top' title='' data-original-title='Save as csv'>asCsv</a>");
//                    $(item).parents('.chartsection').find('.lockedbuttons').fadeIn(500);
//                    setTimeout(function () {
//                        $(item).parents('.chartsection').find('.lockedbuttons').fadeOut(500, function () {
//                            $(item).parents('.chartsection').find('.lockedbuttons').remove();
//                        });
//                    }, 5000);
//                }
//            }, 1000);
//        }
//    });

    if ($('.text-nowrap').hasClass('current-page')) {
        $('.current-page').find('i').toggleClass('current-i');
    }


    $('body').on("change", "#global-down-sample-ag", function () {
        if (!doapplyjson)
        {
            if (!gdd.times.generalds)
            {
                gdd.times.generalds = [];
            }
            gdd.times.generalds[1] = $(this).val();
            domodifier();
            repaint(true, false);
        }

    });
    $('body').on("blur", "#global-down-sample", function () {
        if (!gdd.times.generalds)
        {
            gdd.times.generalds = [];
        }
        gdd.times.generalds[0] = $(this).val();
        domodifier();
        repaint(true, false);
    });
    $("#addrow").on("click", function () {
        gdd.rows.push({widgets: []});
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        domodifier();
        redrawAllJSON(gdd);
    });
    $('body').on("click", "#deleterowconfirm", function () {
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }

        var ri = $(this).attr("index");
//        console.log($(this).attr("index"));
//        console.log(gdd.rows);
        gdd.rows.splice(ri, 1);
        domodifier();
        redrawAllJSON(gdd);
        $("#deleteConfirm").modal('hide');
    });
    $('body').on("click", ".colapserow", function () {
        $(this).parents('.widgetraw').find('.rowcontent').fadeOut();
        var ri = $(this).parents(".widgetraw").index();
        gdd.rows[ri].colapsed = true;
        for (var lri in gdd.rows)
        {
            for (var wi in    gdd.rows[lri].widgets)
            {
                if (gdd.rows[lri].widgets[wi])
                {
                    clearTimeout(gdd.rows[lri].widgets[wi].timer);
                }
            }
        }

        redrawAllJSON(gdd);
        domodifier();
    });
    $('body').on("click", ".expandrow", function () {
        $(this).parents('.widgetraw').find('.rowcontent').fadeIn();
        var ri = $(this).parents(".widgetraw").index();
        gdd.rows[ri].colapsed = false;
        redrawAllJSON(gdd);
        domodifier();
    });
    $('body').on("click", ".deleterow", function () {
        var ri = $(this).parents(".widgetraw").index();
        $("#deleteConfirm").find('.btn-ok').attr('id', "deleterowconfirm");
        $("#deleteConfirm").find('.btn-ok').attr('index', ri);
        $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-ok btn-danger");
        $("#deleteConfirm").find('.modal-body p').html("Do you want to delete row " + $(this).parents(".raw-controls").find(".title_text span").text() + "?");
        $("#deleteConfirm").find('.modal-body .text-warning').html("");
        $("#deleteConfirm").modal('show');
        domodifier();
    });
    $('body').on("click", "#showasjson", function () {
        $("#showjson").find('.btn-ok').attr('id', "applydashjson");
        var jsonstr = JSON.stringify(gdd, jsonmaker);
        dasheditor.set(JSON.parse(jsonstr));
        $("#showjson").modal('show');
    });
    $('body').on("click", "#applydashjson", function () {

        doapplyjson = true;

        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        gdd = dasheditor.get();
        redrawAllJSON(gdd);

        if (gdd.times.generalds)
        {
            $('#global-down-sample').val(gdd.times.generalds[0]);
            $('#global-down-sample-ag').val(gdd.times.generalds[1]).trigger('change');
            var check = document.getElementById('global-downsampling-switsh');
            if (check.checked !== gdd.times.generalds[2])
            {
                $(check).attr('autoedit', true);
                $(check).trigger('click');
                $(check).removeAttr('autoedit');
            }
        }
        if (gdd.times.intervall)
        {
            $("#refreshtime").val(gdd.times.intervall).trigger('change');
        }
        var label = pickerlabel;
        if (gdd.times.pickerlabel)
        {
            label = gdd.times.pickerlabel;
        }

        $('#reportrange span').html(label);
        if (label === "Custom")
        {
            PicerOptionSet1.startDate = moment(gdd.times.pickerstart);
            PicerOptionSet1.endDate = moment(gdd.times.pickerend);
            $('#reportrange span').html(PicerOptionSet1.startDate.format('MM/DD/YYYY H:m:s') + ' - ' + PicerOptionSet1.endDate.format('MM/DD/YYYY H:m:s'));

        } else
        {
            if (PicerOptionSet1.ranges[label])
            {
                PicerOptionSet1.startDate = PicerOptionSet1.ranges[label][0];
                PicerOptionSet1.endDate = PicerOptionSet1.ranges[label][1];
            }
        }

        $("#showjson").modal('hide');
        doapplyjson = false;
        domodifier();
    });
    $('body').on("click", ".showrowjson", function () {
        var ri = $(this).parents(".widgetraw").index();
        $("#showjson").find('.btn-ok').attr('id', "applyrowjson");
        $("#showjson").find('.btn-ok').attr('index', ri);
        var jsonstr = JSON.stringify(gdd.rows[ri], jsonmaker);
        dasheditor.set(JSON.parse(jsonstr));
        $("#showjson").modal('show');
    });
    $('body').on("click", "#applyrowjson", function () {
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }

        var ri = $(this).attr("index");
        gdd.rows[ri] = dasheditor.get();
        redrawAllJSON(gdd);
        $("#showjson").modal('hide');
        domodifier();
    });
    $('body').on("click", ".minus", function () {
        var ri = $(this).parents(".widgetraw").index();
        var wi = $(this).parents(".chartsection").index();
        if (gdd.rows[ri].widgets[wi].size > 1)
        {
            var olssize = gdd.rows[ri].widgets[wi].size;
            gdd.rows[ri].widgets[wi].size = parseInt(gdd.rows[ri].widgets[wi].size) - 1;
            $(this).parents(".chartsection").attr("size", gdd.rows[ri].widgets[wi].size);
            $(this).parents(".chartsection").removeClass("col-md-" + olssize).addClass("col-md-" + gdd.rows[ri].widgets[wi].size);
            gdd.rows[ri].widgets[wi].echartLine.resize();
            domodifier();
        }

    });
    $('body').on("click", ".plus", function () {

        var ri = $(this).parents(".widgetraw").index();
        var wi = $(this).parents(".chartsection").index();
        if (gdd.rows[ri].widgets[wi].size < 12)
        {

            var olssize = gdd.rows[ri].widgets[wi].size;
            gdd.rows[ri].widgets[wi].size = parseInt(gdd.rows[ri].widgets[wi].size) + 1;
            $(this).parents(".chartsection").attr("size", gdd.rows[ri].widgets[wi].size);
            $(this).parents(".chartsection").removeClass("col-md-" + olssize).addClass("col-md-" + gdd.rows[ri].widgets[wi].size);
            gdd.rows[ri].widgets[wi].echartLine.resize();
            domodifier();
        }
//    redrawAllJSON(gdd);
    });
    $('body').on("click", "#deletewidgetconfirm", function () {

        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        var ri = $(this).attr("ri");
        var wi = $(this).attr("wi");
        gdd.rows[ri].widgets.splice(wi, 1);
        redrawAllJSON(gdd);
        domodifier();
        $("#deleteConfirm").modal('hide');
    });
    $('body').on("click", ".deletewidget", function () {
        var ri = $(this).parents(".widgetraw").index();
        var wi = $(this).parents(".chartsection").index();
        if (getParameterByName("widget") !== null)
        {
            wi = getParameterByName("widget");
        }

        if (getParameterByName("row") !== null)
        {
            ri = getParameterByName("row");
        }

        $("#deleteConfirm").find('.btn-ok').attr('id', "deletewidgetconfirm");
        $("#deleteConfirm").find('.btn-ok').attr('ri', ri);
        $("#deleteConfirm").find('.btn-ok').attr('wi', wi);
        $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-ok btn-danger");
        if (gdd.rows[ri].widgets[wi].options)
        {
            if (gdd.rows[ri].widgets[wi].title)
            {
                $("#deleteConfirm").find('.modal-body p').html("Do you want to delete chart " + gdd.rows[ri].widgets[wi].title.text + " ?");
            } else
            {
                $("#deleteConfirm").find('.modal-body p').html("Do you want to delete chart " + wi + " ?");
            }
        } else
        {
            if (gdd.rows[ri].widgets[wi].title)
            {
                $("#deleteConfirm").find('.modal-body p').html("Do you want to delete chart " + gdd.rows[ri].widgets[wi].title.text + " ?");
            } else
            {
                $("#deleteConfirm").find('.modal-body p').html("Do you want to delete chart " + wi + " ?");
            }
        }

        $("#deleteConfirm").find('.modal-body .text-warning').html("");
        $("#deleteConfirm").modal('show');
    });
    $('body').on("click", ".dublicate", function () {
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }

        var ri = $(this).parents(".widgetraw").index();
        var curentwi = $(this).parents(".chartsection").index();
        if (getParameterByName("widget") !== null)
        {
            curentwi = getParameterByName("widget");
        }

        if (getParameterByName("row") !== null)
        {
            ri = getParameterByName("row");
        }

        var wi = Object.keys(gdd.rows[ri].widgets).length;
        gdd.rows[ri].widgets.push(clone_obg(gdd.rows[ri].widgets[curentwi]));
        delete  gdd.rows[ri].widgets[wi].echartLine;

        window.history.pushState({}, "", "?widget=" + wi + "&row=" + ri + "&action=edit");
        domodifier();
        AutoRefreshSingle(ri, wi);
        $RIGHT_COL.css('min-height', $(window).height());

//        redrawAllJSON(gdd);
    });
    $('body').on("click", ".addchart", function () {

        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        var ri = $(this).parents(".widgetraw").index();
        if (!gdd.rows[ri].widgets)
        {
            gdd.rows[ri].widgets = [];
        }
        var wi = gdd.rows[ri].widgets.length;
        gdd.rows[ri].widgets.push({type: "line", size: 12, options: clone_obg(defoption)});
        window.history.pushState({}, "", "?widget=" + wi + "&row=" + ri + "&action=edit");
        gdd.rows[ri].widgets[wi].options.series[0].symbol = "none";
        gdd.rows[ri].widgets[wi].options.series[0].type = "line";
        gdd.rows[ri].widgets[wi].options.series[0].data = datafunc();
        domodifier();
        AutoRefreshSingle(ri, wi);
        $RIGHT_COL.css('min-height', $(window).height());
    });
    //addchart

    $('body').on("click", ".addcounter", function () {

        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        var ri = $(this).parents(".widgetraw").index();
        if (!gdd.rows[ri].widgets)
        {
            gdd.rows[ri].widgets = [];
        }
        var wi = gdd.rows[ri].widgets.length;
        gdd.rows[ri].widgets.push({type: "counter", size: 2});
        window.history.pushState({}, "", "?widget=" + wi + "&row=" + ri + "&action=edit");
        domodifier();
        AutoRefreshSingle(ri, wi);
        $RIGHT_COL.css('min-height', $(window).height());
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
    $('body').on("click", ".fulldash .change_title_row, .change_title", function () {
        $(this).parent().css("display", "none");
        $(this).parents('.item_title').find('.title_input').css("display", "block");
        $(this).parents('.item_title').find('.title_input input').focus();
    });
    $('body').on("click", ".fulldash .savetitlerow,.dash_header .savetitle", doeditTitle);
    $('body').on("keypress", ".fulldash .enter_title_row,.dash_header .enter_title", doeditTitle);
    $('body').on("click", ".deletedash", function () {
        $("#deleteConfirm").find('.btn-ok').attr('id', "deletedashconfirm");
        $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-ok btn-danger");
        $("#deleteConfirm").find('.modal-body p').html("Do you want to delete this dashboard?");
        $("#deleteConfirm").find('.modal-body .text-warning').html($("#name").val());
        $("#deleteConfirm").modal('show');
    });
    $('body').on("click", ".savedash", savedash);
    $('body').on("click", ".savedashasTemplate", function () {
        var url = cp + "/dashboard/savetemplate";
        var senddata = {};

        if (Object.keys(gdd).length > 0)
        {
            for (var ri in gdd.rows)
            {
                for (var wi in gdd.rows[ri].widgets)
                {
                    delete gdd.rows[ri].widgets[wi].echartLine;
                    if (gdd.rows[ri].widgets[wi].tmpoptions)
                    {
                        gdd.rows[ri].widgets[wi].options = clone_obg(gdd.rows[ri].widgets[wi].tmpoptions);
                        delete gdd.rows[ri].widgets[wi].tmpoptions;
                    }
                    if (gdd.rows[ri].widgets[wi].options)
                    {
                        for (var k in gdd.rows[ri].widgets[wi].options.series) {
                            gdd.rows[ri].widgets[wi].options.series[k].data = [];
                        }
                    }

                }
            }

            senddata.info = JSON.stringify(gdd);
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
        $(".editpanel").empty();
        $(".editpanel").remove();
        Edit_Form = null;
        delete Edit_Form;
        var single_ri = $(this).parents(".widgetraw").index();
        var single_wi = $(this).parents(".chartsection").index();
        if (getParameterByName("widget") !== null)
        {
            single_wi = getParameterByName("widget");
        }

        if (getParameterByName("row") !== null)
        {
            single_ri = getParameterByName("row");
        }

        lockq[single_ri + " " + single_wi] = false;
        window.history.pushState({}, "", "?widget=" + single_wi + "&row=" + single_ri + "&action=edit");
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        AutoRefreshSingle(single_ri, single_wi, false, true);
        $(".editchartpanel select").select2({minimumResultsForSearch: 15});
        $(".select2_group").select2({dropdownCssClass: "menu-select"});
        $RIGHT_COL.css('min-height', $(window).height());
    });
    $('body').on("click", ".viewchart", function () {
        $(".editpanel").empty();
        $(".editpanel").remove();
        Edit_Form = null;
        delete Edit_Form;
        var single_ri = $(this).parents(".widgetraw").index();
        var single_wi = $(this).parents(".chartsection").index();
        if (getParameterByName("widget") !== null)
        {
            single_wi = getParameterByName("widget");
        }

        if (getParameterByName("row") !== null)
        {
            single_ri = getParameterByName("row");
        }
        lockq[single_ri + " " + single_wi] = false;
        window.history.pushState({}, "", "?widget=" + single_wi + "&row=" + single_ri + "&action=view");
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        AutoRefreshSingle(single_ri, single_wi, true, true);
        $RIGHT_COL.css('min-height', $(window).height());
    });
    $('body').on("click", ".backtodush", function () {

        $(".fulldash").show();
        var request_W_index = getParameterByName("widget");
        var request_R_index = getParameterByName("row");
        window.history.pushState({}, "", window.location.pathname);
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        lockq = [];
        $(".right_col .fulldash .dash_header").after($("#dash_main"));
        $(".editpanel").empty();
        $(".editpanel").remove();
        Edit_Form = null;
        delete Edit_Form;
        AutoRefresh();
        var pos = 0;
        if (gdd.rows[request_R_index].widgets[request_W_index].echartLine._dom)
        {
            pos = gdd.rows[request_R_index].widgets[request_W_index].echartLine._dom.getBoundingClientRect().top - 25;
        } else
        {
            pos = gdd.rows[request_R_index].widgets[request_W_index].echartLine.offset().top - 25;
        }
        $('html, body').animate({
            scrollTop: pos
        }, 500);
        $RIGHT_COL.css('min-height', $(window).height());
    });
    $('body').on("click", ".csv", function () {
        var single_ri = $(this).parents(".widgetraw").index();
        var single_wi = $(this).parents(".chartsection").index();

        if (getParameterByName("widget") !== null)
        {
            single_wi = getParameterByName("widget");
        }

        if (getParameterByName("row") !== null)
        {
            single_ri = getParameterByName("row");
        }

        var csvarray = [];
        var filename = "chart";        
        if (gdd.rows[single_ri].widgets[single_wi].title)
            if (gdd.rows[single_ri].widgets[single_wi].title.text)
            {
                csvarray.push([gdd.rows[single_ri].widgets[single_wi].title.text]);
                filename = gdd.rows[single_ri].widgets[single_wi].title.text;
            }

        if (gdd.rows[single_ri].widgets[single_wi].options.xAxis[0].type === "time")
        {
            for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].options.series)
            {
                var Ser = gdd.rows[single_ri].widgets[single_wi].options.series[seriesindex];
                csvarray.push([Ser.name]);
                for (var dataind in Ser.data)
                {
                    csvarray.push([Ser.name, new Date(Ser.data[dataind].value[0]), Ser.data[dataind].value[1]]);
                }
            }
        }
        if (gdd.rows[single_ri].widgets[single_wi].options.xAxis[0].type === "category")
        {
            for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].options.series)
            {
                var Ser = gdd.rows[single_ri].widgets[single_wi].options.series[seriesindex];
                csvarray.push([Ser.name]);
                for (var dataind in Ser.data)
                {
                    csvarray.push([Ser.data[dataind].name, Ser.data[dataind].value]);
                }
            }
        }
        console.log(csvarray);
        exportToCsv(filename + ".csv", csvarray);

    });
    $('body').on("click", "#refresh", function () {
        repaint(true, false);
    });
    $('body').on("click", "#btnlock", function () {
        btnlock();
        currentpagelock();
    });
    $('body').on("click", "#savelock", function () {
        if (btn === null)
        {
            return;
        }

        $('#lockConfirm').modal('hide');
        $('.dash_header,.text-right').hide(500, function () {
            if (!btn.parents('.fulldash').hasClass('locked'))
                btn.parents('.fulldash').toggleClass('locked');
        });
        btn.toggleClass('btnunlock');
        btn.find('i').toggleClass('fa-unlock');
        locktooltip();
        btn.parents('.fulldash').toggleClass('locked');
        gdd.locked = true;
        setTimeout(function () {
            savedash();
        }, 1000);

    });
    $("body").on('keydown', function (event) {
        if ((event.ctrlKey || event.metaKey)) {
            switch (event.which) {
                case 83:
                {
                    if ((dashmodifier === true) && (!$('.fulldash').hasClass('locked'))) {
                        event.preventDefault();
                        savedash();
                    }
                    break;
                }
                case 76:
                {
                    event.preventDefault();
                    btnlock();
                    break;
                }
                default:
                {
                    break;
                }

            }
        }
    });
    $("body").on("click", '.current-i', function () {
        currentpagelock();
        btnlock();
        return false;
    });
    $('body').on("change", "#refreshtime", function () {
        if (!doapplyjson)
        {
            gdd.times.intervall = $(this).val();
            domodifier();
            repaint(true, false);
        }

    });
    $('body').on("click", '#minimize', function () {
        filtershow = false;
        $('#filter').fadeOut(500);
        $('#maximize').fadeIn(500);
    });
    $('body').on("click", '#maximize', function () {
        filtershow = true;
        $('#filter').fadeIn(500);
        $('#maximize').fadeOut(500);
    });
    var whaittimer;
    $('body').on("mouseover mouseout", '.chartSubIcon, .hoverShow, .echart_time_icon', function (e) {
        var elem = $(this);
        clearTimeout(whaittimer);
        whaittimer = setTimeout(function (  ) {
            if (elem.hasClass('chartSubIcon')) {
                elem.parents('.wrap').find('.hoverShow').css({
                    left: 0,
                    top: elem.parents('.wrap').find('.chartSubIcon').outerHeight()
                });
            } else if (elem.hasClass('echart_time_icon')) {
                elem.parents('.wrap').find('.hoverShow').css({
                    right: 0,
                    top: elem.parents('.wrap').find('.echart_time_icon').outerHeight()
                });
            }
            if (e.type === 'mouseover') {
                if (elem.parents('.wrap').find('.hoverShow').css('display') !== 'block') {
                    $('.hoverShow').fadeOut();
                }
                elem.parents('.wrap').find('.hoverShow').fadeIn();
            }
            if (e.type === 'mouseout') {
                $('.hoverShow').fadeOut();
            }
            ;
        }, 500);
    });
//    $('body').on('mouseover', '.chartTitleDiv', function () {
//        $(this).attr("normalcolor", $(this).css('background-color'));
//        $(this).css('background-color', ModifierColor($(this).css('background-color'), 90));
//    });
//    $('body').on('mouseout', '.chartTitleDiv', function () {
//        $(this).css('background-color', $(this).attr("normalcolor"));
//        $(this).removeAttr("normalcolor");
//    });

    $(document).on('click.bs.dropdown.data-api', '.plus, .minus', function (e) {
        e.stopPropagation();
    });
    $('body').on("click", '.dropdown-submenu a.more', function (e) {
        $(this).next('ul').toggle();
        e.stopPropagation();
        e.preventDefault();
    });
    var options = {modes: ['form', 'tree', 'code'], mode: 'code'};
    dasheditor = new JSONEditor(document.getElementById("dasheditor"), options);
    olddashname = $("#name").val();
});
var filtershow = true;

$(document).on('scroll', function () {
    clearTimeout(scrolltimer);
    if ($(document).scrollTop() >= $('#dash_main').offset().top) {
        if (!$('#filter').hasClass("fix"))
        {
            $('#filter').css('left', $(".nav_menu").position().left);
            $('#filter').addClass("fix");
            $('#minimize').css('display', 'block');
            $('#filter').css('display', 'none');
            if (filtershow)
            {
                $('#filter').fadeIn();
            } else
            {

                $('#maximize').css('display', 'block');
            }


        }

    } else {
        if ($('#filter').hasClass("fix"))
        {
            $('#filter').fadeOut("slow", function () {
                $('#filter').removeClass("fix");
                $('#filter').fadeIn();
            });

            $('#minimize').css('display', 'none');
            $('#maximize').css('display', 'none');
        }
    }
    scrolltimer = setTimeout(function () {
        if ($(".fulldash").is(':visible'))
        {
            for (var ri in gdd.rows)
            {
                for (var wi in gdd.rows[ri].widgets)
                {
                    if (gdd.rows[ri].widgets[wi])
                    {
                        var chart = gdd.rows[ri].widgets[wi].echartLine;
                        var oldvisible = gdd.rows[ri].widgets[wi].visible;
                        gdd.rows[ri].widgets[wi].visible = true;
                        if (chart)
                        {
                            if (chart._dom)
                            {
                                if (chart._dom.getBoundingClientRect().bottom < 0)
                                {
                                    gdd.rows[ri].widgets[wi].visible = false;
                                }
                                if (chart._dom.getBoundingClientRect().top > window.innerHeight)
                                {
                                    gdd.rows[ri].widgets[wi].visible = false;
                                }
                            }
                            if (!oldvisible && gdd.rows[ri].widgets[wi].visible)
                            {
                                if (typeof (gdd.rows[ri].widgets[wi].q) !== "undefined")
                                {
                                    setdatabyQ(gdd, ri, wi, "getdata", false);
                                }
                            }

                        }
                    }
                }
            }
        }

    }, 500);
});
window.onresize = function () {
    if ($(".fulldash").is(':visible'))
    {
        for (var ri in gdd.rows)
        {
            for (var wi in    gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    var chart = gdd.rows[ri].widgets[wi].echartLine;
                    var oldvisible = gdd.rows[ri].widgets[wi].visible;
                    gdd.rows[ri].widgets[wi].visible = true;
                    if (chart)
                    {
                        if (chart._dom)
                        {
                            if (chart._dom.getBoundingClientRect().bottom < 0)
                            {
                                gdd.rows[ri].widgets[wi].visible = false;
                            }
                            if (chart._dom.getBoundingClientRect().top > window.innerHeight)
                            {
                                gdd.rows[ri].widgets[wi].visible = false;
                            }

                        }

                        if (!oldvisible && gdd.rows[ri].widgets[wi].visible)
                        {
                            if (typeof (gdd.rows[ri].widgets[wi].q) !== "undefined")
                            {
                                setdatabyQ(gdd, ri, wi, "getdata", false);
                            }
                        }
                        if (gdd.rows[ri].widgets[wi].visible)
                        {
                            if (gdd.rows[ri].widgets[wi].type !== "counter")
                            {
                                chart.resize();
                            }

                        }
                    }

                }
            }
        }
    }
    if ($(".editchartpanel").is(':visible'))
    {
        echartLine.resize();
    }

};
window.onbeforeunload = function () {
    if (dashmodifier === true)
    {
        if ($('#btnlock').hasClass('btnunlock')) {
            return null;
        }
        return true;
    }
    return null;
};
