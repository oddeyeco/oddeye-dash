/* global numbers, cp, colorPalette, format_metric, echarts, pickerlabel, pickerstart, pickerend, rangeslabels, dashJSONvar */

var AllRedrawtimer;
var SingleRedrawtimer;

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

function replacer(tags) {
    return function (str, p1, p2, offset, s) {
        if (typeof tags[p1] === "undefined")
        {
            return "tag." + p1;
        }
        return tags[p1];
    };
}

function setdatabyQueryes(option, url, start, end, chart, redraw = false)
{
//    console.log(option.queryes);
    var k;
    option.tmpoptions.series = [];
    option.tmpoptions.legend.data = [];

//    option.tmpoptions.toolbox.feature.magicType.show = true;
    option.tmpoptions.toolbox.feature.magicType.title = {
        line: 'Line',
        bar: 'Bar',
        stack: 'Stacked',
        tiled: 'Tiled'
    },
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
        $.getJSON(uri, null, function (data) {
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
                            if (!series.itemStyle)
                            {
                                series.itemStyle = {normal: {}};
                            }
                            if (option.fill)
                            {
                                if (!series.itemStyle.normal)
                                {
                                    series.itemStyle.normal = {};
                                }
                                if (!series.itemStyle.normal.areaStyle)
                                {
                                    series.itemStyle.normal.areaStyle = {};
                                }
                                series.itemStyle.normal.areaStyle.type = 'default';
                            } else
                            {
                                delete series.itemStyle.normal.areaStyle;
                            }
//                            series.itemStyle = {normal: {areaStyle: {type: 'default'}}};
                            option.tmpoptions.series.push(series);
                        }
                    }
                    option.tmpoptions.tooltip.trigger = 'axis';
                }

                if (option.tmpoptions.xAxis[0].type === "category")
                {
                    option.tmpoptions.series = [];
                    var m_sample = option.tmpoptions.xAxis[0].m_sample;
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
                        if (!tmpseries[data.chartsdata[index].metric])
                        {
                            tmpseries[data.chartsdata[index].metric] = [];
                        }

                        tmpseries[data.chartsdata[index].metric].push({value: val, name: name});

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

                            data.push({value: val, name: key, children: cildren})
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
                            if (option.type === "bar")
                            {
                                option.tmpoptions.legend.data.push(key);
                            }
                            series.data = tmpseries[key];
                            series.type = option.type;
                            if (option.type === "pie")
                            {
                                series.radius = radius + "%";
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
                                    },
                                };
                                series.width = radius - 5 + "%";
                                series.height = 100 / rows - 5 + "%";
                                series.x = index * radius - radius + '%';
                                series.y = (row * 50 + 2.5) + "%";
                            }

                            option.tmpoptions.tooltip.trigger = 'item';
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

        });
}

}

var defserie = {
    name: null,
    type: 'line',
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
var interval = 10000;

function AutoRefresh(redraw = false)
{    
    redrawAllJSON(dashJSONvar, redraw);
    AllRedrawtimer = setTimeout(function () {
        AutoRefresh(true);
    }, interval);
}

function AutoRefreshSingle(row, index, readonly = false, rebuildform = true, redraw = false)
{        
    showsingleChart(row, index, dashJSONvar, readonly, rebuildform, redraw);
    SingleRedrawtimer = setTimeout(function () {
        AutoRefreshSingle(row, index, readonly, false, true);
    }, interval);
}


function redrawAllJSON(dashJSON, redraw = false)
{
    var rowindex;
    var widgetindex;
    if (!redraw)
    {
        $("#dashcontent").html("");
    }
    for (rowindex in dashJSON)
    {
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
//            console.log(widgetindex);
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
                $("#charttemplate .chartsection").attr("class", "chartsection " + bkgclass + "col-xs-12 col-md-" + dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").find(".echart_line").attr("id", "echart_line" + rowindex + "_" + widgetindex);

                if (typeof (dashJSON[rowindex]["widgets"][widgetindex].height) !== "undefined")
                {
                    $("#charttemplate .chartsection").find(".echart_line").css("height", dashJSON[rowindex]["widgets"][widgetindex].height);
                    if (dashJSON[rowindex]["widgets"][widgetindex].height == "")
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
                    if (pickerlabel === "Custom")
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

                    setdatabyQueryes(dashJSON[rowindex]["widgets"][widgetindex], "getdata", startdate, enddate, dashJSON[rowindex]["widgets"][widgetindex].echartLine, redraw);
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
    }
    if (typeof (dashJSON[row]["widgets"][index].queryes) !== "undefined")
    {

        var startdate = "5m-ago";
        var enddate = "now";
        if (pickerlabel === "Custom")
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

        setdatabyQueryes(dashJSON[row]["widgets"][index], "getdata", startdate, enddate, echartLine, redraw);
    } else
    {
        echartLine.setOption(dashJSON[row]["widgets"][index].tmpoptions);
    }
    if (rebuildform)
    {
        chartForm = new ChartEditForm(echartLine, $(".edit-form"), row, index, dashJSON);
    }
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


$('#reportrange').on('apply.daterangepicker', function (ev, picker) {
    var startdate = "5m-ago";
    var enddate = "now";
    if (pickerlabel === "Custom")
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

$(document).ready(function () {
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
})

$('body').on("change", ".edit-form select#axes_mode_x", function () {
    if ($(this).val() === 'category') {
        $('.only-Series').fadeIn();
    } else {
        $('.only-Series').fadeOut();
    }
});