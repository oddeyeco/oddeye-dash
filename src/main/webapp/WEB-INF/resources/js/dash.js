/* global numbers, cp, colorPalette, format_metric, echarts, rangeslabels, gdd, PicerOptionSet1, cb, pickerlabel, $RIGHT_COL, moment, jsonmaker, EditForm, getmindate, globalstompClient, subtractlist, pieformater, abcformater, getParameterByName, locale, ColorScheme, DtPicerlocale, clr, jackClr, jackSecClr, secClr, html2canvas */
var SingleRedrawtimer;
var dasheditor;
var echartLine;
var basecounter = '<div class="animated flipInY tile_count col-6 chartsection">' +
                    '<div class="tile-stats tile_stats_count card mb-1" id="metricCounter">' +
                        '<h6>Title</h6>' +
                        '<p></p>' +
                        '<div class="count text-break"><span class="number">0</span><span class="param"></span></div>' +
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
    $('.savedash').parent().find('.btn').addClass('btn-outline-warning');
    $('.savedash').parent().find('.btn').removeClass('btn-outline-dark');    
}
;

function dounmodifier()
{
    dashmodifier = false;
    
    $('.savedash').parent().find('.btn').addClass('btn-outline-dark');
    $('.savedash').parent().find('.btn').removeClass('btn-outline-warning');
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
    $('#saveModal .modal-title').text(locale["dashboard.Modal.successfullySaved"]);
    $('#saveModal').modal('show');

    setTimeout(function () {
        $('#saveModal').modal('hide');
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
                            var action = getParameterByName("action");
                            uri = uri + encodeURI("?widget=" + request_W_index + "&row=" + request_R_index + "&action=" + action);

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
                $('#saveModal .modal-title').text(locale["dash.errorSavingData"]);
                $('#saveModal').modal('show');
                setTimeout(function () {
                    $('#saveModal').modal('hide');
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
            $('.dash_header,.raw-controls i,.raw-controls .btn-group').hide();
        }
        if ($('#btnlock').parents('.singleview').hasClass('locked'))
        {
            $('#btnlock').parents('.singleview').toggleClass('locked');
        }

        $('.dash_header,.raw-controls i,.raw-controls .btn-group').show(500);
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
            $('.dash_header,.raw-controls i,.raw-controls .btn-group').hide(500, function () {

                if (!$('#btnlock').parents('.fulldash').hasClass('locked')) {
                    $('#btnlock').parents('.fulldash').toggleClass('locked');
                }

                if (!$('#btnlock').parents('.singleview').hasClass('locked')) {
                    $('#btnlock').parents('.singleview').toggleClass('locked');
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
        $('#btnlock').attr('data-original-title', locale["dash.title.unlockDashboard"]);
    } else {
        $('#btnlock').attr('data-original-title', locale["dash.title.lockDashboard"]);
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
    
//    var tooltipPos = function(pos, params, dom, rect, size) {
//        var posX, posY;
//        posX = pos[0];
//        if (pos[1] < size.viewSize[1] / 2) {
//            posY = pos[1];
//        } else {
//            posY = pos[1] - size.contentSize[1];
//        }
//        if (pos[0] > size.viewSize[0] / 2) {           
//            posX = posX - Math.min(size.contentSize[0], posX);
//            posY = posY - 10;
//        } else {
//            if((posX + size.contentSize[0]) > size.viewSize[0]){
//                posX = posX - ((posX + size.contentSize[0]) - size.viewSize[0]);
//            }            
//        }
//        return [posX, posY];
//    };
    
    return function (data) {
// ---- tooltip.triggerOn + tooltip.enterable
        if (widget.type === "line") {                    
                    if (widget.options.tooltip.triggerOn === "click") {                     
                        widget.options.tooltip = {
                            "trigger": "axis",
                            "triggerOn": "click",
                            "position": function(pos, params, dom, rect, size){
                                if (pos[0] < size.viewSize[0] / 2){
                                    return [pos[0] + 5,pos[1] - 0];
                                }
                                if (pos[0] > size.viewSize[0] / 2){
                                    return [pos[0] - size.contentSize[0] - 10,pos[1] - 10];
                                }                               
                            },                                                        
//                           "position": tooltipPos,
                            "enterable": true,
                            "extraCssText": 'max-height: 415px; overflow-y: auto;'
                        };                        
                    }
                    if (widget.options.tooltip.triggerOn === "mousemove")
                    {
                        widget.options.tooltip = {
                            "trigger": "axis",
                            "triggerOn": "mousemove",
                            
//                           "position": function(pos, params, dom, rect, size){
//                                var p0, p1;
//                                p0 = pos[0] + 5;
//                                if (pos[1] < size.viewSize[1] / 2) {
//                                    p1 = pos[1];
//                                } else {
//                                    p1 = pos[1] - size.contentSize[1];
//                                }
//                                if (pos[0] > size.viewSize[0] / 2) {
//                                    p0 = p0 - size.contentSize[0] - 10;
//                                    p1 = p1 - 10;
//                                } else {
//                                    p0 = pos[0] + 5;
//                                }
//                                return [p0, p1];
//                            },                                                        
//                            "position": tooltipPos,

                            "enterable": false                        
                        };           
                    } 
                }
// ---- /tooltip.triggerOn + tooltip.enterable 
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
                    widget.data.push({data: data.chartsdata[dindex].data, name: name, name2: name2, id: data.chartsdata[dindex].taghash + data.chartsdata[dindex].metric, q_index: q_index});
                }                
            }
            else if (widget.type === "status")
            {
                for (var dindex in data.chartsdata)
                {
                    var metricname = data.chartsdata[dindex].metric;
                    var metriclevel = data.chartsdata[dindex].level;
                    var metricinfo = data.chartsdata[dindex].info;
                    var hasdata = data.chartsdata[dindex].hasData;
                    var nodatatime = data.chartsdata[dindex].noDataTime;
                    
                     if (metriclevel === "NaN -1")
                        {
                            metriclevel = "OK";
                        }
                    if (hasdata === "false")
                        {
                            metriclevel = "Severe";
                            metricinfo = "No data was received during last "+ nodatatime + " minutes";
                        }
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
                    widget.data.push({data: data.chartsdata[dindex].data, hasdata: hasdata, nodatatime:nodatatime, metricinfo: metricinfo, metriclevel: metriclevel, metricname: metricname, name: name, name2: name2, id: data.chartsdata[dindex].taghash + data.chartsdata[dindex].metric, q_index: q_index});
                }
            }
            else if (widget.type === "heatmap")
            {
                if (!widget.data)
                {
                    widget.data = {xjson: {}, yjson: {}, list: {}};
                }
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
                        widget.data.list[index] = data.chartsdata[index];
                        widget.data.list[index].name2 = name2;
                        widget.data.list[index].name1 = name;
                        widget.data.list[index].inverse = widget.q[q_index].info.inverse;
                        data.chartsdata[index].data.map(function (item) {
                            widget.data.xjson[+item[0]] = item;
                            widget.data.yjson[widget.q[q_index].info.inverse ? item[1] * -1 : +item[1]] = item;
                        });
                    }
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
                                    if (Object.keys(widget.q[q_index]).length > 0)
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
                                                var tmptitle = false;
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
                        var nullkeylist = {};

                        for (var index in data.chartsdata)
                        {
                            if (Object.keys(widget.q[q_index]).length > 0)
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
                                    if (!widget.options.xAxis[widget.q[q_index].xAxisIndex[0]])
                                    {
                                        widget.q[q_index].xAxisIndex[0] = 0;
                                    }
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
                                nullkeylist[tmpname] = true;
                                tmp_series_1[name].push({value: Math.round(val * 100) / 100, name: tmpname, unit: widget.options.yAxis[yAxis].unit, isinverse: widget.q[q_index].info.inverse});
                                sdata.push({value: val, name: name});
                            }
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
                                series.data = tmp_series_1[key];
//                                console.log(JSON.stringify(series.data) );
//                                console.log(series.data);

                                if (series.type === "gauge")
                                {
                                    for (i = 0; i < series.data.length; i++)
                                    {
                                        series.data[i].subname = series.data[i].name;
                                        key = key.replace("\\n", '\n');
                                        key = key.replace("\\r", '\r');
                                        series.data[i].name = key;
                                    }
                                }
                                
                                if (series.type === "line")
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
                                
                                if (series.type === "gauge")
                                {
                                    if (!series.axisLabel)
                                    {
                                        series.axisLabel = {};
                                    }
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
                                }

                                index++;
                                var dublicatename = false;
                                for (var s_index in widget.options.series)
                                {
                                    if (widget.options.series[s_index].name === series.name)
                                    {
                                        dublicatename = true;
                                        if (widget.options.series[s_index].data === widget.options.series[s_index].data)
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
                // Second part
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
                        switch (widget.type) {
                            case 'line':
                            {
                                widget.options.xAxis[xAxis_Index].min = moment(widget.options.xAxis[xAxis_Index].max).subtract(subtractlist[start][0], subtractlist[start][1]).valueOf();
                                break;
                            }
                            default:
                            {
                                delete widget.options.xAxis[xAxis_Index].min;
                                break
                            }
                        }
                    } else
                    {
                        if (moment(start).isValid())
                        {
                            widget.options.xAxis[xAxis_Index].min = start;
                        } else
                        {
                            delete(widget.options.xAxis[xAxis_Index].min);
                        }
                    }
// shift =============================================== 
//                    if (widget.times.shift !== "off")
//                    {                           
//                        widget.options.xAxis[xAxis_Index].max = new Date().getTime() - widget.times.shift;                                                                                      
//                    }
// /shift =============================================== 
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
            for (var nullindex in nullkeylist)
            {
                var rr = {};
                for (var Sind in widget.options.series)
                {
                    var isnull = true;
                    for (var Dind in widget.options.series[Sind].data)
                    {
                        if (widget.options.series[Sind].data[Dind].name === nullindex)
                        {
                            rr = clone_obg(widget.options.series[Sind].data[Dind]);
                            isnull = false;
                            break;
                        }
                    }
                    if (isnull)
                        if (widget.type !== "funnel")
                        {
                            rr.name = nullindex;
                            rr.value = null;
                            widget.options.series[Sind].data.push(rr);
                        }
                }
            }

            if (widget.type === "counter")
            {
                if (!redraw)
                {
                    chart.html("");
                }
                widget.data.sort(function (a, b) {
                    return compareNameName(a, b);
                });                
                chart.find(".chartsection").addClass("tmpfix");
                for (var val in widget.data)
                {
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
                    
                    if (chart.attr("id") !== "singlewidget")
                    { 
                       JQcounter = chart.addClass('row').find("#" + widget.data[val].id + val);
                    }
                    if ((!redraw) || (JQcounter.length === 0))
                    {
                        JQcounter = $(basecounter);
                        chart.append(JQcounter);
                        if (!widget.col)
                        {
                            widget.col = 6;
                        }
                        JQcounter.attr("class", "animated flipInY chartsection" + " col-12 col-md-" + widget.col);
                        JQcounter.find('.tile-stats h6').text(widget.data[val].name);
                        if (widget.title)
                        {
                            if (widget.title.textStyle)
                            {
                                JQcounter.find('.tile-stats h6').css(widget.title.textStyle);
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
                        JQcounter.removeClass("tmpfix");
                        JQcounter = chart.find("#" + widget.data[val].id + val);
                    }
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
                chart.find(".tmpfix").remove();
                if (chart.find(".chartsection").length === 0)
                {
                    JQcounter = $(basecounter);
                    chart.append(JQcounter);
                    JQcounter.attr("class", "animated flipInY chartsection" + " col-12");
                    JQcounter.find('.tile-stats h6').text("No data");
                    chart.append(JQcounter);
                }               
                lockq[ri + " " + wi] = false;
                
            } 
            else if (widget.type === "status")
            {                
                if (!redraw)
                {
                    chart.html("");
                }
                widget.data.sort(function (a, b) {
                    return compareNameName(a, b);
                });

                chart.find(".chartsection").addClass("tmpfix");
                for (var val in widget.data)
                {
                    var JQcounter;
                    var widgetVal = widget.data[val];
                    var dataarray = widget.data[val].data;
                    var statusInfo = data.chartsdata[dindex];
                    
                    var basecounterStatus = 
                         '<div class="animated flipInY tile_count col-6 chartsection" >' +
                            '<div class="tile-stats tile_stats_count level_'+ widgetVal.metriclevel +'" id="metricStatus">' +
                                '<div class="metricname"></div>' +                           
                                '<div class="float-left">' +
                                '<h6 class="m-0 text-wrap tags"></h6>'+'<h6 class="m-0 text-wrap alias2"></h6>' +
                                '</div>' +
                                '<div class="float-right">' +
                                '<h4 class="mx-0 my-2"><span class="badge badge-dark p-1 level"></span></h4>' +
                                '</div>' +
                                '<div class="clearfix"></div>'+
                                '<hr></hr>' +                         
                                '<div class="text-wrap message"></div>' +                                       
                            '</div>' +
                        '</div>';
                    if (chart.attr("id") !== "singlewidget")
                    { 
                        JQcounter = chart.addClass('row').find("#" + widgetVal.id + val);
                    }
                    if ((!redraw) || (JQcounter.length === 0))
                    {
                        JQcounter = $(basecounterStatus);
                        chart.append(JQcounter);
                        if (!widget.col)
                        {
                            widget.col = 6;
                        }
                        JQcounter.attr("class", "animated flipInY tile_count chartsection" + " col-12 col-sm-" + widget.col);                        
                        JQcounter.find('.tile-stats h6.tags').text(widgetVal.name);
                        JQcounter.find('.tile-stats div.metricname').text(widgetVal.metricname);                        
                        JQcounter.find('.tile-stats span.level').text(widgetVal.metriclevel);                        
                        JQcounter.find('.tile-stats div.message').text(widgetVal.metricinfo);
                        
                        if (widget.title)
                        {
                            if (widget.title.textStyle)
                            {
                                JQcounter.find('.tile-stats h6.tags').css(widget.title.textStyle);
                            }
                            if (widget.title.subtextStyle)
                            {
                                JQcounter.find('.tile-stats h6.alias2').css(widget.title.subtextStyle);
                            }
                        }
                        JQcounter.find('.tile-stats h6.alias2').text(widget.data[val].name2);

                        if (widget.style)
                        {
                            JQcounter.find('.tile-stats').css(widget.style);
                        }
                        JQcounter.attr("id", widget.data[val].id + val);
                    } else
                    {
                        JQcounter.removeClass("tmpfix");
                        JQcounter = chart.find("#" + widget.data[val].id + val);
                    } 
                }
                chart.find(".tmpfix").remove();
                if (chart.find(".chartsection").length === 0)
                {
                    JQcounter = $(basecounter);
                    chart.append(JQcounter);
                    JQcounter.attr("class", "animated  tile_count flipInY chartsection" + " col-12");
                    JQcounter.find('.tile-stats.tile_stats_count h6').text("No data");
                    chart.append(JQcounter);
                }
                lockq[ri + " " + wi] = false;
            }
            else if (widget.type === "heatmap")
            {
                var xdata = Object.keys(widget.data.xjson);
                xdata.sort();
                var xdataF = xdata.map(function (itm) {
                    return [moment(+itm).format("HH:mm")] + "\n" + [moment(+itm).format("MM/DD")];
                });
                for (var ind in widget.options.xAxis)
                {
                    delete (widget.options.xAxis[ind].max);
                    widget.options.xAxis[ind].type = 'category';
                    widget.options.xAxis[ind].data = xdataF;
                    widget.options.xAxis[ind].splitLine = {show: true};
                }
                var ydata = Object.keys(widget.data.yjson);
                var max = 0;
                for (var ind in widget.options.yAxis)
                {
                    max = numbers.basic.max(ydata);
                    var i = numbers.basic.min(ydata);
                    
                    delete (widget.options.yAxis[ind].max);

                    var step = (max - i) / 10;
                    if (widget.options.yAxis[ind].splitNumber)
                    {
                        step = (max - i) / (widget.options.yAxis[ind].splitNumber - 2);
                    }
                    if (i >= 0)
                    {
                        i = Math.max(0, i - step);
                    } else
                    {
                        i = i - step;
                    }
                    var ydataF = [];
                    var ydataS = [];
                    var previ = i;
                    while (i < max)
                    {
                        if ((previ * i) < 0)
                        {
                            ydataF.push(0);
                            ydataS.push("0");
                        }
                        ydataF.push(+i.toFixed(2));
                        ydataS.push(i.toFixed(2));
                        previ = i;
                        i = i + step;

                    }
                    if (max > ydataF[ydataF.length - 1])
                    {
                        ydataF[ydataF.length - 1] = max;
                        ydataS[ydataS.length - 1] = max.toFixed(2);
                    }

                    widget.options.yAxis[ind].type = 'category';
                    widget.options.yAxis[ind].data = ydataS;

                    var formatter = widget.options.yAxis[ind].unit;

                    if (formatter === "none")
                    {
                        delete widget.options.yAxis[ind].axisLabel.formatter;
                    } else
                    {
                        if (!widget.options.yAxis[ind].axisLabel)
                        {
                            widget.options.yAxis[ind].axisLabel = {};
                        }
                        if (typeof (window[formatter]) === "function")
                        {
                            widget.options.yAxis[ind].axisLabel.formatter = window[formatter];
                        } else
                        {
                            widget.options.yAxis[ind].axisLabel.formatter = formatter;
                        }
                    }
                    widget.options.yAxis[ind].splitLine = {show: true};
                }

                var datamap = {};
                var datamax = 0;
                var chdata = [];
                for (var index in widget.data.list)
                {
                    widget.data.list[index].data.map(function (item) {
                        var hasdata = false;
                        var j = 0;

                        var tmpval = widget.data.list[index].inverse ? item[1] * -1 : +item[1];

                        for (j in xdata)
                        {
                            for (i in ydataF)
                            {
                                if ((item[0] === +xdata[j]) && (tmpval <= ydataF[i]))
                                {
                                    hasdata = true;
                                    break;
                                }
                            }
                            if (hasdata)
                                break;
                        }
                        if (hasdata)
                        {
                            if (!datamap[widget.data.list[index].name1])
                            {
                                datamap[widget.data.list[index].name1] = {};
                            }
                            if (!datamap[widget.data.list[index].name1][i])
                            {
                                datamap[widget.data.list[index].name1][i] = {};
                            }
                            if (!datamap[widget.data.list[index].name1][i][j])
                            {                                  //TODO ALIAS 1
                                datamap[widget.data.list[index].name1][i][j] = {items: [], name: widget.data.list[index].name1, time: xdata[j], alias: []};
                            }
                            datamap[widget.data.list[index].name1][i][j].items.push(item);                //TODO ALIAS 2 
                            var value2 = item[1];
                            if (typeof widget.options.yAxis[0].unit !== "undefined")
                            {
                                if (typeof (window[ widget.options.yAxis[0].unit]) === "function")
                                {
                                    value2 = window[widget.options.yAxis[0].unit](item[1]);
                                } else
                                {
                                    value2 = widget.options.yAxis[0].unit.replace("{value}", item[1].toFixed(2));
                                }
                            }
                            datamap[widget.data.list[index].name1][i][j].alias.push(widget.data.list[index].name2 + ' (' + value2 + ')');
                            datamax = Math.max(datamax, datamap[widget.data.list[index].name1][i][j].items.length);
                        }
                    });
                }

                for (var ind in datamap)
                    for (var i in datamap[ind])
                    {
                        for (var j in datamap[ind][i])
                        {
                            var vals = datamap[ind][i][j].items.map(function (it) {
                                return it[1];
                            });
                            vals.sort(function (a, b) {
                                return a - b;
                            });
                            datamap[ind][i][j].alias.sort();
                            if (!chdata[datamap[ind][i][j].name])
                            {
                                chdata[datamap[ind][i][j].name] = [];
                            }
                            chdata[datamap[ind][i][j].name].push([+j, +i, datamap[ind][i][j].items.length, datamap[ind][i][j].time, vals[0], vals[vals.length - 1], widget.options.yAxis[0].unit, '<br>' + datamap[ind][i][j].alias.join("<br>"), datamap[ind][i][j].items.length]);
                        }
                    }
                    
                var data = [];
                widget.options.legend.data = [];
                for (var index in chdata)
                {
                    widget.options.legend.data.push(index);
                    var ser = {
                        name: index,
                        type: 'heatmap',
                        data: chdata[index],
                        label: {
                            normal: {
                                show: true
                            }
                        },
                        itemStyle: {
                            emphasis: {
                                shadowBlur: 10,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }
                    };
                    if (widget.label)
                    {
                        if (typeof widget.label.show !== "undefined")
                        {
                            ser.label.normal.show = widget.label.show;
                        } else
                        {
                            delete ser.label.normal.show;
                        }
                    } else
                    {
                        delete ser.label.normal.show;
                    }
                    data.push(ser);
                }

                if (!widget.manual)
                {
                    widget.options.tooltip = {
                        "trigger": "item"
                    };
                    if (!widget.options.visualMap)
                    {
                        widget.options.visualMap = {
                            min: 0,
                            max: datamax,
                            calculable: true,
                            itemHeight: "250",
                            top: "0",
                            right: "0",
                            inRange: {}
                        };
                    }
                }

                if (!widget.options.grid)
                {
                    widget.options.grid = {"x2": "60px"};
                } else
                {
                    if (!widget.options.grid.x2)
                    {
                        widget.options.grid.x2 = "60px";
                    }
                }
                if (widget.options.visualMap.other)
                {
                    if (!widget.options.visualMap.other.max)
                    {
                        widget.options.visualMap.max = datamax;
                    } else
                    {
                        widget.options.visualMap.max = widget.options.visualMap.other.max;
                    }
                    if (!widget.options.visualMap.itemHeight)
                    {
                        widget.options.visualMap.itemHeight = "250";
                    }
                    if (!widget.options.visualMap.top)
                    {
                        widget.options.visualMap.top = "0";
                    }
                    if (!widget.options.visualMap.right)
                    {
                        widget.options.visualMap.right = "0";
                    }
                    if (!widget.options.visualMap.other.min)
                    {
                        widget.options.visualMap.min = 0;
                    } else
                    {
                        widget.options.visualMap.min = widget.options.visualMap.other.min;
                    }
                    if (widget.options.visualMap.other.color)
                    {
                        widget.options.visualMap.inRange = {
                            color: ColorScheme[widget.options.visualMap.other.color]
                        };
                    } else
                    {
                        delete(widget.options.visualMap.inRange.color);
                    }
                } else
                {
                    widget.options.visualMap.max = datamax;
                    widget.options.visualMap.min = 0;
                    delete(widget.options.visualMap.inRange.color);
                }

                widget.options.visualMap.calculable = true;
                widget.options.series = data;
                try {
                    if (redraw)
                    {
                        var datalist = [];
                        if (chart.getOption().series.length === widget.options.series.length)
                        {
                            for (var key in widget.options.series)
                            {
                                var ss = widget.options.series[key];
                                datalist.push({data: ss.data});
                            }
                            chart.setOption({series: datalist, xAxis: widget.options.xAxis});
                        } else
                        {
                            chart.setOption({series: widget.options.series, xAxis: widget.options.xAxis});
                        }

                    } else
                    {
                        chart.setOption(widget.options, true);
                    }
                } catch (e) {
                    console.log("***********HHHHHHHHHH*****************");
                    console.log(e);
                    console.log(widget);
                    console.log(uri);
                    console.log(data);
                    console.log("*******************************");
                }
                chart.hideLoading();
                lockq[ri + " " + wi] = false;
                if (callback !== null)
                {
                    callback();
                }
            } else
            {
                widget.options.series.sort(function (a, b) {
                    return compareStrings(a.name, b.name);
                });
                if (!widget.manual)
                {
                    switch (widget.type) {
                        case 'bar':
                        {
                            if (widget.options.series.length === 1)
                            {
                                widget.options.series[0].itemStyle = {normal: {color: function (params) {
                                            return colorPalette[params.dataIndex % colorPalette.length];
                                        }}};
                            }
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
                    case 'treemap':
                    {
                        delete widget.options.dataZoom;
                        widget.options.legend.show = false;
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
                                if (val.children)
                                {
                                    $.each(val.children, function (i, val2) {
                                        val2.formatter = widget.label.parts;
                                    });
                                }
                            });
                        }
                    ;
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
                            if (widget.detail)
                            {
                                ser.detail = widget.detail;
                            }
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
                                        ser.label.normal.formatter = pieformater;
                                        break;
                                    }
                                    default:
                                    {
                                        ser.label.normal.formatter = abcformater;
                                        break
                                    }
                                }
                            }

                            switch (ser.type) {
                                case 'gauge':
                                {
                                    ser.detail.show = ser.label.normal.show;
                                    break;
                                }
                                default:
                                {
                                    break
                                }
                            }
                        }
                    }
                    if (col > cols)
                    {
                        col = 1;
                        row++;
                    }
                    if ((ser.type === "pie") || (ser.type === "gauge"))
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
//                                ser.radius = Math.min(a / 3, b / 3);
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

                    if ((ser.type === "funnel") || (ser.type === "treemap"))
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
                        tmpLegendSer.push(widget.options.series[ind].name.replace("\n", ""));
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

                        if (widget.options.series[ind].type === "gauge")
                        {
                            widget.options.legend.itemWidth = 0;
                        } else
                        {
                            delete widget.options.legend.itemWidth;
                        }
                    }
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
                try {
                    if (redraw)
                    {
                        var datalist = [];
                        if (chart.getOption().series.length === widget.options.series.length)
                        {
                            for (var key in widget.options.series)
                            {
                                var ss = widget.options.series[key];
                                datalist.push({data: ss.data});
                            }
                            chart.setOption({series: datalist, xAxis: widget.options.xAxis});
                        } else
                        {
                            chart.setOption({series: widget.options.series, xAxis: widget.options.xAxis});
                        }
                    } else
                    {
                        chart.setOption(widget.options, true);
                    }
//                    console.log(widget.options);
                } catch (e) {
                    console.log("***********VVVVVVVVV*****************");
                    console.log(e);
                    console.log(widget);
                    console.log(uri);
                    console.log(data);
                    console.log("*******************************");
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
            delete(widget.data);
        };
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

function getURL(type) {
    if(type === "status"){
        return "getStatusData";
    }
    else {
        return "getdata";
    }
}

var lockq = {};
function setdatabyQ(json, ri, wi, url, redraw = false, callback = null, customchart = null) {
    redraw = false;
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
        if (json.times.pickervalue === "custom")
        {
            start = json.times.pickerstart;
            end = json.times.pickerend;
        } else
        {
            if (json.times.pickervalue)
            {
                if (typeof (json.times.pickervalue) !== "undefined")
                {
                    start = json.times.pickervalue;
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
        if (widget.times.pickervalue === "custom")
        {
            start = widget.times.pickerstart;
            end = widget.times.pickerend;
            usePersonalTime = true;
        } else
        {
            if (typeof (widget.times.pickervalue) !== "undefined")
            {
                start = widget.times.pickervalue;
                end = "now";
                usePersonalTime = true;
            }
        }
// shift ===============================================      
        if (widget.times.shift)
        {
            if (widget.times.shift !== "off")
            {
                start = widget.times.pickerstart - widget.times.shift;
                end = widget.times.pickerend - widget.times.shift;
                usePersonalTime = true;
            }
        }
// /shift ===============================================            
    }
                            
    var count = {"value": widget.q.length, "base": widget.q.length};

    for (k in widget.q)
    {
        if (widget.q[k].check_disabled || (!widget.q[k].info) || (!widget.q[k].info.metrics))
        {
            count.base--;
        }
    }
    count.value = count.base;
    var oldseries = {};
    if (widget.type === "counter")
    {
        oldseries = clone_obg(widget.series);
    }
    else if (widget.type === "status")
    {
        oldseries = clone_obg(widget.series);
    }
    else
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
            widget.data = [];
            if (getParameterByName('metrics', uri))
            {
                if (prevuri !== uri)
                {
                    if (chart.attr("id") === "singlewidget")
                    {
                        chart.attr("class", " col-12 col-md-" + widget.size);
                        chart.css({'display' : 'flex', 'flex-wrap':'wrap'});
                    }
                    var inputdata = [k, widget, oldseries, chart, count, json, ri, wi, url, redraw, callback, customchart, start, end, whaitlist, uri];
                    lockq[ri + " " + wi] = true;
                    $.ajax({
                        dataType: "json",
                        url: uri,
                        data: null,
                        success: queryCallback(inputdata),
                        error: function (xhr, error) {
                            console.log(widget.type);
                            if (widget.type === "counter")
                            {
                            } else
                            {
                                chart.hideLoading();
                            }
                            $(chart).before("<h2 class='error'>Invalid Query</h2>");
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
        else if (widget.type === "status")
        {
            widget.data = [];            
            if (getParameterByName('metrics', uri))
            {
                if (prevuri !== uri)
                {
                    if (chart.attr("id") === "singlewidget")
                    { 
                        chart.attr("class", " col-12 col-md-" + widget.size);                        
                        chart.css({'display' : 'flex', 'flex-wrap':'wrap'});
                    }
                    var inputdata = [k, widget, oldseries, chart, count, json, ri, wi, url, redraw, callback, customchart, start, end, whaitlist, uri];
                    lockq[ri + " " + wi] = true;
                    $.ajax({
                        dataType: "json",
                        url: uri,
                        data: null,
                        success: queryCallback(inputdata),
                        error: function (xhr, error) {
                            console.log(widget.type);
                            if (widget.type === "status")
                            {
                            } else
                            {
                                chart.hideLoading();
                            }
                            $(chart).before("<h2 class='error'>Invalid Query</h2>");
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
        else if (chart)
        {
            if (chart._dom.className !== "echart_line_single")
            {
                if ($(chart._dom).css('width') !== $(chart._dom).children().css('width'))
                {
                    try {
                        chart.resize();
                    } catch (e) {
                        console.log(e);
                    }
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
            if (count.base === 0)
            {
                var tmpseries = clone_obg(widget.options.series);
                for (var tk in tmpseries)
                {
                    tmpseries[tk].data = [];
                }
                try {
                    chart.setOption(widget.options);
                } catch (e) {
                    console.log("***********2076*****************");
                    console.log(e);
                    console.log(widget);
                    console.log("*******************************");
                }
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
    });
}

function redrawAllJSON(dashJSON, redraw = false) {
    var ri;
    var wi;
    $(".editchartpanel").hide();
    $(".fulldash").show();
    if (dashJSON.locked)
    {
        $('.fulldash').addClass('locked');
        $('#btnlock').addClass('btnunlock');
        $('#btnlock i').addClass('fa-unlock');
        $('.dash_header,.raw-controls i,.raw-controls .btn-group').hide();
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
            $("#rowtemplate .widgetraw").attr("id", "row" + ri);
            var html = $("#rowtemplate").html();
            $("#dashcontent").append(html);
            $("#rowtemplate .widgetraw").attr("id", "row");
        }
        var name = "";
        if (typeof tmprow.name === "undefined")
        {
            name = locale["dash.row"] + ri;
        } else
        {
            name = tmprow.name;
        }

        $("#row" + ri).find('.item_title .title_text span').html(name);
        $("#row" + ri).find('.item_title .title_input input').val(name);

        if (tmprow.colapsed)
        {
            var colapserow = $("#row" + ri).find('.colapserow');
            var crow = $("#row" + ri);
            colapserow.removeClass('colapserow');
            colapserow.addClass('expandrow');
            colapserow.find('i').removeClass('fa-minus');
            colapserow.find('i').addClass('fa-plus');
            colapserow.attr('data-original-title', locale["dash.title.expand"] + '(' + tmprow.widgets.length + ')');
            crow.find(".title_text span").prepend('(' + tmprow.widgets.length + ')')
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
                    };
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
                        chartobj.find(".chartSubIcon").css({display: 'block'});
                    } else {
                        chartobj.find(".chartSubIcon").css({display: 'none'});
                    }
                }
                chartobj.attr("id", "widget" + ri + "_" + wi);
                chartobj.attr("type", tmprow.widgets[wi].type);
                chartobj.attr("class", "chartsection " + bkgclass + " col-12 col-lg-" + tmprow.widgets[wi].size);
                chartobj.find(".echart_line").attr("id", "echart_line" + ri + "_" + wi);
                chartobj.find(".echart_line").html("");

                if (tmprow.widgets[wi].times)
                {
                    if (tmprow.widgets[wi].times.pickervalue)
                    {
                        chartobj.find(".echart_time_icon").css({display: 'block'});
                        if (tmprow.widgets[wi].times.pickervalue !== "custom")
                        {
                            //??????
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

            if (tmprow.widgets[wi].type !== "counter" && tmprow.widgets[wi].type !== "status")
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
                    if (tmprow.widgets[wi].type === "counter" || tmprow.widgets[wi].type === "status")
                    {
                        $("#echart_line" + ri + "_" + wi).removeAttr("style");
                        tmprow.widgets[wi].echartLine = $("#echart_line" + ri + "_" + wi);
                    } else
                    {
                        tmprow.widgets[wi].echartLine = echarts.init(document.getElementById("echart_line" + ri + "_" + wi), 'oddeyelight');
                    }
                }
                 setdatabyQ(dashJSON, ri, wi, getURL(tmprow.widgets[wi].type), redraw);
            } else
            {
                if (tmprow.widgets[wi].type === "counter" || tmprow.widgets[wi].type === "status")
                {
                    $("#echart_line" + ri + "_" + wi).removeAttr("style");
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
                    try {
                        tmprow.widgets[wi].echartLine.setOption(tmprow.widgets[wi].options);
                    } catch (e) {
                        console.log("***********2376*****************");
                        console.log(e);
                        console.log(tmprow.widgets[wi]);
                        console.log("*******************************");
                    }
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
    if (dashJSON.locked)
    {
        $(".fulldash").addClass('locked');
        $('#btnlock').addClass('btnunlock');
        $('#btnlock i').addClass('fa-unlock');
        $('.dash_header,.raw-controls i,.raw-controls .btn-group').hide();
    }

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
    var acprefix = "dash.edit";
    if (readonly)
    {
        acprefix = "dash.show";
    }
    var title = locale[acprefix + ".chart"];
    var W_type = dashJSON.rows[row].widgets[index].type;

    if (W_type === "table")
    {
        var title = locale[acprefix + ".table"];
    }
    if (W_type === "counter")
    {
        var title = locale[acprefix + ".counter"];
    }
    if (W_type === "status")
    {
        var title = locale[acprefix + ".status"];
    }
    if (W_type === "heatmap")
    {
        var title = locale[acprefix + ".heatmap"];
    }
    if (rebuildform)
    {
        $(".right_col").append('<div class="card shadow editpanel"></div>');
        if (!readonly)
        {
            $(".right_col .editpanel").append('<h5 class="card-header dash_action">' +
                    title +
                    '<div class="float-right">' +
                    '<span><button class="btn btn-sm btn-outline-primary savedash"  type="button">' + locale["save"] + ' </button></span>' +
                    '<button class="btn btn-sm btn-outline-primary ml-1 backtodush" type="button">' + locale["dash.backToDash"] + ' </button>' +
                    '</div>' +
                    '<div class="clearfix"></div>' +
                    '</h5');
            $(".right_col .editpanel").addClass("singleedit");

        } else
        {
            $(".right_col .editpanel").append('<h5 class="card-header dash_action">' +
                    title +
                    '<div class="float-right">' +
                    '<button class="btn btn-sm btn-outline-primary backtodush" type="button">' + locale["dash.backToDash"] + ' </button>' +
                    '</div>' +
                    '<div class="clearfix"></div>' +
                    '</h5>');
            $(".right_col .editpanel").addClass("singleview");
        }
        if (dashJSON.locked)
        {
            $(".right_col .editpanel").addClass('locked');
        }
        $(".right_col .editpanel").append($("#dash_main"));
        $(".right_col .editpanel").append('<div class="clearfix"></div>');
        if (W_type === "counter")
        {
            $(".right_col .editpanel").append('<div class="' + " col-12 col-lg-" + dashJSON.rows[row].widgets[index].size + '" id="singlewidget">' +
                    '<div class="counter_single" id="counter_single"></div>' +
                    '</div>');
            if (!readonly)
            {
                $(".right_col .editpanel").append('<div class="edit-form">');
                Edit_Form = new CounterEditForm($(".edit-form"), row, index, dashJSON, domodifier);
            }
        }
         else if (W_type === "status")
        {
            $(".right_col .editpanel").append('<div class="' + " col-12 col-lg-" + dashJSON.rows[row].widgets[index].size + '" id="singlewidget">' +
                    '<div class="status_single" id="status_single"></div>'+'</div>');
            if (!readonly)
            {
                $(".right_col .editpanel").append('<div class="x_content edit-form">');
                Edit_Form = new StatusEditForm($(".edit-form"), row, index, dashJSON, domodifier);
            }
        }
        else if (W_type === "table")
        {
            $(".right_col .editpanel").append('<div class="card-body" id="singlewidget">' +
                    '<div class="table_single" id="table_single"></div>' +
                    '</div>');
        } else //chart
        {
            if (!redraw)
            {
                if (readonly)
                {
                    $(".right_col .editpanel").append('<div class="card-body" id="singlewidget">' +
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
                    var wraper = $('<div class="card-body" id="singlewidget">' +
                            '<div class="echart_line_single" id="echart_line_single" ></div>' +
                            '</div>');
                    wraper.find(".echart_line_single").css("height", height);
                    $(".right_col .editpanel").append(wraper);
                }
//                console.log(wraper);
                echartLine = echarts.init(document.getElementById("echart_line_single"), 'oddeyelight');
            }
            if (!readonly)
            {
                $(".right_col .editpanel").append('<div class="edit-form">');
                if (W_type === "heatmap")
                {
                    Edit_Form = new HmEditForm(echartLine, $(".edit-form"), row, index, dashJSON, domodifier);
                } else
                {
                    Edit_Form = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON, domodifier);
                }
            }
        }
    } else
    {
        var wraper = $(".right_col .editpanel #singlewidget");
    }
    if (W_type === "counter" || W_type === "status")
    {
        if (typeof (dashJSON.rows[row].widgets[index].q) !== "undefined")
        {
            setdatabyQ(dashJSON, row, index, getURL(W_type), redraw, callback, $(".right_col .editpanel #singlewidget"));
        } else
        {
//                updatecounter($(".right_col .editpanel"), dashJSON.rows[row].widgets[index]);
        }

    } else if (W_type === "table")
    {

    } else //chart
    {
        //TODO Drow single widget title
        var singleWi = dashJSON.rows[row].widgets[index];

        if (rebuildform) {
            wraper.prepend('<div class="chartTitleDiv">' + '<div class="chartDesc wrap">' +
                    '<div class="borderRadius">' + '<span class="chartSubIcon" style="display: none">'
                    + '<i class="fa fas fa-info "></i> ' + '</span>' + '</div>' +
                    '<a class="chartSubText hoverShow">' + '</a>' + '</div>' + '<div class="chartTime wrap">'
                    + '<div class="borderRadius">' + '<span class="echart_time_icon">' + '<i class="fa far fa-clock"></i>'
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
                wraperTitle.find('.chartTitle h3').html('');
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
            wraperTitle.find('.wrap').css({display: 'none'});
        }
        if (singleWi.times) {
            if (singleWi.times.pickervalue)
            {
                ;
                wraperTitle.find(".echart_time_icon").css({display: 'block'});
                if (singleWi.times.pickervalue !== "custom")
                {
                    wraperTitle.find(".echart_time .last").html(singleWi.times.pickerlabel + " ");
                } else
                {
                    wraperTitle.find(".echart_time .last").html("From " + moment(singleWi.times.pickerstart).format('MM/DD/YYYY H:m:s') + " to " + moment(singleWi.times.pickerend).format('MM/DD/YYYY H:m:s') + " ");
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
            if (singleWi.times.intervall === "General" && !singleWi.times.pickervalue) {
                wraperTitle.find(".echart_time_icon").css({display: 'none'});
            }
        } else {
            wraperTitle.find(".echart_time_icon").css({display: 'none'});
        }
        if (singleWi.options)
        {
            if (singleWi.options.backgroundColor)
            {
                wraper.css("background-color", singleWi.options.backgroundColor);
            } else
            {
                wraper.css("background-color", "");
            }
        } else
        {
            wraper.css("background-color", "");
        }

        if (typeof (dashJSON.rows[row].widgets[index].q) !== "undefined")
        {
            setdatabyQ(dashJSON, row, index, "getdata", redraw, callback, echartLine);
        } else
        {
            try {
                echartLine.setOption(dashJSON.rows[row].widgets[index].options);
            } catch (e) {
                console.log("***********1743*****************");
                console.log(e);
                console.log(dashJSON.rows[row].widgets[index]);
                console.log("*******************************");
            }
        }
    }
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
            if (gdd.locked && (action === "edit"))
            {
                window.location.href = window.location.pathname + "?widget=" + request_W_index + "&row=" + request_R_index + "&action=view";
            }
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
            gdd.times.pickerlabel = DtPicerlocale["customRangeLabel"];
            gdd.times.pickervalue = "custom";

        } else
        {
            gdd.times.pickervalue = gdd.times.pickerstart;
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
    if (gdd.times)
    {
        if (gdd.times.pickerlabel === "Last 1 hour")
        {
            gdd.times.pickerlabel = locale["datetime.lastonehoure"];
        }
        if (gdd.times.pickerlabel === "Last 3 hour")
        {
            gdd.times.pickerlabel = replaceArgumets(locale["datetime.lasthoures"], [3]);
        }
        if (gdd.times.pickerlabel === "Last 6 hour")
        {
            gdd.times.pickerlabel = replaceArgumets(locale["datetime.lasthoures"], [6]);
        }
        if (gdd.times.pickerlabel === "Last 12 hour")
        {
            gdd.times.pickerlabel = replaceArgumets(locale["datetime.lasthoures"], [12]);
        }
        if (gdd.times.pickerlabel === "Last 1 day")
        {
            gdd.times.pickerlabel = replaceArgumets(locale["datetime.lastoneday"], []);
        }
        if (gdd.times.pickerlabel === "Last 3 day")
        {
            gdd.times.pickerlabel = replaceArgumets(locale["datetime.lastdays"], [3]);
        }
        if (gdd.times.pickerlabel === "Last 7 day")
        {
            gdd.times.pickerlabel = replaceArgumets(locale["datetime.lastdays2"], [7]);
        }
        if (gdd.times.pickerlabel === "Last 30 day")
        {
            gdd.times.pickerlabel = replaceArgumets(locale["datetime.lastdays2"], [30]);
        }
        if (!gdd.times.pickervalue)
        {
            gdd.times.pickervalue = rangeslabels[gdd.times.pickerlabel];
        } else
        {
            for (var label in rangeslabels)
            {
                if (rangeslabels[label] === gdd.times.pickervalue)
                {
                    gdd.times.pickerlabel = label;
                }
            }
        }
    }
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
            if (wid.times)
            {
                if (wid.times.pickerlabel)
                {
                    if (wid.times.pickerlabel === "Last 1 hour")
                    {
                        wid.times.pickerlabel = locale["datetime.lastonehoure"];
                    }
                    if (wid.times.pickerlabel === "Last 3 hour")
                    {
                        wid.times.pickerlabel = replaceArgumets(locale["datetime.lasthoures"], [3]);
                    }
                    if (wid.times.pickerlabel === "Last 6 hour")
                    {
                        wid.times.pickerlabel = replaceArgumets(locale["datetime.lasthoures"], [6]);
                    }
                    if (wid.times.pickerlabel === "Last 12 hour")
                    {
                        wid.times.pickerlabel = replaceArgumets(locale["datetime.lasthoures"], [12]);
                    }
                    if (wid.times.pickerlabel === "Last 1 day")
                    {
                        wid.times.pickerlabel = replaceArgumets(locale["datetime.lastoneday"], []);
                    }
                    if (wid.times.pickerlabel === "Last 3 day")
                    {
                        wid.times.pickerlabel = replaceArgumets(locale["datetime.lastdays"], [3]);
                    }
                    if (wid.times.pickerlabel === "Last 7 day")
                    {
                        wid.times.pickerlabel = replaceArgumets(locale["datetime.lastdays2"], [7]);
                    }
                    if (wid.times.pickerlabel === "Last 30 day")
                    {
                        wid.times.pickerlabel = replaceArgumets(locale["datetime.lastdays2"], [30]);
                    }
                    if (!wid.times.pickervalue)
                    {
                        wid.times.pickervalue = rangeslabels[wid.times.pickerlabel];
                    } else
                    {
                        for (var label in rangeslabels)
                        {
                            if (rangeslabels[label] === wid.times.pickervalue)
                            {
                                wid.times.pickerlabel = label;
                            }
                        }
                    }
                } else
                {
                    if (wid.times.pickervalue)
                    {
                        for (var label in rangeslabels)
                        {
                            if (rangeslabels[label] === wid.times.pickervalue)
                            {
                                wid.times.pickerlabel = label;
                            }
                        }
                    }
                }
            }
            if (wid.options)
            {
                if (!wid.title)
                {
                    wid.title = wid.options.title;
                }
                delete wid.options.title;
            }
        }
    }
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
        var pickervalue = gdd.times.pickervalue;

        $('#reportrange span').html(label);
        if (pickervalue === "custom")
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
    var switchery = new Switchery(elem, {size: 'small', color: clr, jackColor: jackClr, secondaryColor: secClr, jackSecondaryColor: jackSecClr});
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
        if (gdd.times.pickervalue === 'custom')
        {
            startdate = gdd.times.pickerstart;
            enddate = gdd.times.pickerend;
        } else
        {
            if (typeof (gdd.times.pickervalue) !== "undefined")
            {
                startdate = gdd.times.pickervalue;
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
            for (var wi in gdd.rows[ri].widgets)
            {
                if (gdd.rows[ri].widgets[wi])
                {
                    clearTimeout(gdd.rows[ri].widgets[wi].timer);
                }
            }
        }
        var ri = $(this).attr("index");
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
        console.log("dsfsdf");
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
        $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-sm btn-ok btn-outline-danger");
        $("#deleteConfirm").find('.modal-body p').html(replaceArgumets(locale["dash.modal.confirmDelRow"], [$(this).parents(".raw-controls").find(".title_text span").text()]));
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
        var pickervalue = rangeslabels[label];
        if (gdd.times.pickervalue)
        {
            pickervalue = gdd.times.pickervalue;
        } else
        {
            gdd.times.pickervalue = rangeslabels[label];
        }

        $('#reportrange span').html(label);
        if (pickervalue === "custom")
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
    
    $('body').on("click", ".showJsonRow", function () {
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
        
        if (gdd.rows[ri].widgets[wi].size > 12)
        {
            gdd.rows[ri].widgets[wi].size = 12;
        }
        if (gdd.rows[ri].widgets[wi].size > 1)
        {
            var olssize = gdd.rows[ri].widgets[wi].size;
            gdd.rows[ri].widgets[wi].size = parseInt(gdd.rows[ri].widgets[wi].size) - 1;
            $(this).parents(".chartsection").attr("size", gdd.rows[ri].widgets[wi].size);
            $(this).parents(".chartsection").removeClass("col-lg-" + olssize).addClass("col-lg-" + gdd.rows[ri].widgets[wi].size);
            gdd.rows[ri].widgets[wi].echartLine.resize();
            domodifier();
            if ((gdd.rows[ri].widgets[wi].type === 'gauge') ||
                    (gdd.rows[ri].widgets[wi].type === 'pie') ||
                    (gdd.rows[ri].widgets[wi].type === 'funnel'))
            {
                setdatabyQ(gdd, ri, wi, "getdata", false);
            }
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
            $(this).parents(".chartsection").removeClass("col-lg-" + olssize).addClass("col-lg-" + gdd.rows[ri].widgets[wi].size);
            gdd.rows[ri].widgets[wi].echartLine.resize();
            domodifier();
            if ((gdd.rows[ri].widgets[wi].type === 'gauge') ||
                    (gdd.rows[ri].widgets[wi].type === 'pie') ||
                    (gdd.rows[ri].widgets[wi].type === 'funnel'))
            {
                setdatabyQ(gdd, ri, wi, "getdata", false);
            }
        }
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
        $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-sm btn-ok btn-outline-danger");

        if (gdd.rows[ri].widgets[wi].options)
        {
            if (gdd.rows[ri].widgets[wi].title)
            {
                if (gdd.rows[ri].widgets[wi].title.text)
                {
                    $("#deleteConfirm").find('.modal-body p').html(replaceArgumets(locale["dash.modal.confirmDelChart"], [gdd.rows[ri].widgets[wi].title.text]));
                } else
                {
                    $("#deleteConfirm").find('.modal-body p').html(replaceArgumets(locale["dash.modal.confirmDelChart"], [wi]));
                }
            } else
            {
                $("#deleteConfirm").find('.modal-body p').html(replaceArgumets(locale["dash.modal.confirmDelChart"], [wi]));
            }
        } else
        {
            if (gdd.rows[ri].widgets[wi].title)
            {
                if (gdd.rows[ri].widgets[wi].title.text)
                {
                    $("#deleteConfirm").find('.modal-body p').html(replaceArgumets(locale["dash.modal.confirmDelCounter"], [gdd.rows[ri].widgets[wi].title.text]));
                } else
                {
                    $("#deleteConfirm").find('.modal-body p').html(replaceArgumets(locale["dash.modal.confirmDelCounter"], [wi]));
                }
            } else
            {
                $("#deleteConfirm").find('.modal-body p').html(replaceArgumets(locale["dash.modal.confirmDelCounter"], [wi]));
            }
        }
        $("#deleteConfirm").find('.modal-body .text-warning').html("");
        $("#deleteConfirm").modal('show');
    });
    
    $('body').on("click", ".dublicate", function () {
        for (var ri in gdd.rows)
        {
            for (var wi in gdd.rows[ri].widgets)
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
    });
    
    $('body').on("click", ".addheatmap", function () {
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
        gdd.rows[ri].widgets.push({type: "heatmap", size: 12, options: clone_obg(defoption)});
        window.history.pushState({}, "", "?widget=" + wi + "&row=" + ri + "&action=edit");
        gdd.rows[ri].widgets[wi].options.series[0].symbol = "none";
        gdd.rows[ri].widgets[wi].options.series[0].type = "heatmap";
        domodifier();
        AutoRefreshSingle(ri, wi);
        $RIGHT_COL.css('min-height', $(window).height());
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
        gdd.rows[ri].widgets.push({type: "counter", size: 4});
        window.history.pushState({}, "", "?widget=" + wi + "&row=" + ri + "&action=edit");
        domodifier();
        AutoRefreshSingle(ri, wi);
        $RIGHT_COL.css('min-height', $(window).height());
    });  
    
    $('body').on("click", ".addstatus", function () {
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
        gdd.rows[ri].widgets.push({type: "status", size: 6});
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
    
    $('body').on("click", "#deletedash", function () {
        $("#deleteConfirm").find('.btn-ok').attr('id', "deletedashconfirm");
        $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-sm btn-ok btn-outline-danger");
        $("#deleteConfirm").find('.modal-body p').html(locale["dash.modal.confirmDelDashboard"]);
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
        $(".right_col .fulldash .dash_header").after($("#dash_main"));
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
        $(".right_col .fulldash .dash_header").after($("#dash_main"));
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
        var saveData = [];
        var filename = "oddeyesave";
        var fileFotmat = ".csv";
        if (gdd.rows[single_ri].widgets[single_wi].title)
        {
            saveData.push([gdd.rows[single_ri].widgets[single_wi].title.text ? gdd.rows[single_ri].widgets[single_wi].title.text : "", gdd.rows[single_ri].widgets[single_wi].title.subtext ? gdd.rows[single_ri].widgets[single_wi].title.subtext : ""]);
            filename = gdd.rows[single_ri].widgets[single_wi].title.text ? gdd.rows[single_ri].widgets[single_wi].title.text : filename;
        }
        if (gdd.rows[single_ri].widgets[single_wi].type === 'counter') {
            if (gdd.rows[single_ri].widgets[single_wi].data)
            {
                for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].data)
                {
                    var Ser = gdd.rows[single_ri].widgets[single_wi].data[seriesindex];
                    saveData.push([Ser.name, Ser.data[Ser.data.length - 1][1]]);
                }
            }
        } else {
            if (gdd.rows[single_ri].widgets[single_wi].options.xAxis[0].type === "time")
            {
                for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].options.series)
                {
                    var Ser = gdd.rows[single_ri].widgets[single_wi].options.series[seriesindex];
                    saveData.push([Ser.name]);
                    for (var dataind in Ser.data)
                    {
                        saveData.push([Ser.name, new Date(Ser.data[dataind].value[0]), Ser.data[dataind].value[1]]);
                    }
                }
            }
            if (gdd.rows[single_ri].widgets[single_wi].options.xAxis[0].type === "category")
            {
                for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].options.series)
                {
                    var Ser = gdd.rows[single_ri].widgets[single_wi].options.series[seriesindex];
                    saveData.push([Ser.name]);
                    for (var dataind in Ser.data)
                    {
                        saveData.push([Ser.data[dataind].name, Ser.data[dataind].value]);
                    }
                }
            }
        }
        console.log(saveData);
        exportToCsv(filename + fileFotmat, saveData);
    });
    
    $('body').on('click', '.jsonsave', function () {
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
        var saveData = {title: {},
            data: {}
        };
        var filename = "oddeyesave";
        var fileFotmat = ".json";

        if (gdd.rows[single_ri].widgets[single_wi].title)
        {
            saveData['title'][gdd.rows[single_ri].widgets[single_wi].title.text ? gdd.rows[single_ri].widgets[single_wi].title.text : ""] = gdd.rows[single_ri].widgets[single_wi].title.subtext ? gdd.rows[single_ri].widgets[single_wi].title.subtext : "";
            filename = gdd.rows[single_ri].widgets[single_wi].title.text ? gdd.rows[single_ri].widgets[single_wi].title.text : filename;
        }
        if (gdd.rows[single_ri].widgets[single_wi].type === 'counter') {
            if (gdd.rows[single_ri].widgets[single_wi].data)
            {
                for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].data)
                {
                    var Ser = gdd.rows[single_ri].widgets[single_wi].data[seriesindex];
                    saveData['data'][Ser.name] = {};
                    saveData['data'][Ser.name] = Ser.data[Ser.data.length - 1][1];
                }
            }
        } else {
            if (gdd.rows[single_ri].widgets[single_wi].options.xAxis[0].type === "time")
            {
                for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].options.series)
                {
                    var Ser = gdd.rows[single_ri].widgets[single_wi].options.series[seriesindex];
                    saveData['data'][Ser.name] = {};
                    for (var dataind in Ser.data)
                    {
                        saveData['data'][Ser.name][Ser.data[dataind].value[0]] = Ser.data[dataind].value[1];
                    }
                }
            }
            if (gdd.rows[single_ri].widgets[single_wi].options.xAxis[0].type === "category")
            {
                for (var seriesindex in gdd.rows[single_ri].widgets[single_wi].options.series)
                {
                    var Ser = gdd.rows[single_ri].widgets[single_wi].options.series[seriesindex];
                    saveData['data'][Ser.name] = {};
                    for (var dataind in Ser.data)
                    {
                        saveData['data'][Ser.name][Ser.data[dataind].name] = Ser.data[dataind].value;
                    }
                }
            }
        }
        console.log(saveData);
        exportTojson(filename + fileFotmat, saveData);
    });

    $('body').on("click", ".imagesave", function () {
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
        var imageobg = document.getElementById($(this).parents(".chartsection").attr("id"));
        if (document.getElementById('singlewidget') !== null)
        {
            var imageobg = document.getElementById('singlewidget');
        }
        $(imageobg).find(".fa-chevron-down, .dropdown-menu").hide();

        html2canvas(imageobg).then(canvas => {
            var image = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
            var filename = "oddeyeimage";
            var fileFotmat = ".png";
            if (gdd.rows[single_ri].widgets[single_wi].title)
            {
                filename = gdd.rows[single_ri].widgets[single_wi].title.text ? gdd.rows[single_ri].widgets[single_wi].title.text : filename;
            }
            var a = document.createElement("a");
            document.body.appendChild(a);
            a.style = "display: none";
            a.href = image;
            a.download = filename + fileFotmat;
            a.click();
            window.URL.revokeObjectURL(image);
            $(imageobg).find(".fa-chevron-down").removeAttr("style");
            $(imageobg).find(".dropdown-menu").removeAttr("style");
        });
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
        $('.dash_header,.raw-controls i,.raw-controls .btn-group').hide(500, function () {
            if (!btn.parents('.fulldash').hasClass('locked'))
                btn.parents('.fulldash').toggleClass('locked');
            if (!btn.parents('.singleview').hasClass('locked'))
                btn.parents('.singleview').toggleClass('locked');
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
    
    $('body').on("mouseover", '.chartSubIcon, .hoverShow, .echart_time_icon', function () {
        var elem = $(this);
        clearTimeout(whaittimer);
        whaittimer = setTimeout(function ( ) {
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
            if (elem.parents('.wrap').find('.hoverShow').css('display') !== 'block') {
                $('.hoverShow').fadeOut();
            }
            elem.parents('.wrap').find('.hoverShow').fadeIn();
        }, 500);
    });
    
    $('body').on("mouseout", '.chartSubIcon, .hoverShow, .echart_time_icon', function () {
        clearTimeout(whaittimer);
        whaittimer = setTimeout(function ( ) {
            $('.hoverShow').fadeOut();
        }, 500);
    });

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
            $('#filter').css('left', $("#sidebar").width() + 4);
            $('#filter').addClass("fix");
            $('#minimize').css('display', 'block');
            $('#filter').css('display', 'none');
            $('#filter').css('display', 'flex');
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
                                    setdatabyQ(gdd, ri, wi, getURL(gdd.rows[ri].widgets[wi].type), false);
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
                                setdatabyQ(gdd, ri, wi, getURL(gdd.rows[ri].widgets[wi].type), false);
                            }
                        }
                        if (gdd.rows[ri].widgets[wi].visible)
                        {
                            if (gdd.rows[ri].widgets[wi].type !== "counter" && gdd.rows[ri].widgets[wi].type !== "status")
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