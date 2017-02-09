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
    option.tmpoptions.legend.data = [];
    for (k in option.queryes)
    {
        var query = option.queryes[k];
        var uri = cp + "/" + url + "?" + query + "&startdate=" + start + "&enddate=" + end;
        $.getJSON(uri, null, function (data) {
            if (Object.keys(data.chartsdata).length > 0)
            {
                if (option.tmpoptions.xAxis[0].type == "time")
                {
                    for (index in data.chartsdata)
                    {
                        var series = clone_obg(defserie);
                        var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags)
                        series.name = name;
                        option.tmpoptions.legend.data.push({"name": name});
                        var chdata = [];
                        for (var time in data.chartsdata[index].data) {
                            var dateval = moment(time * 1);
                            chdata.push([dateval.toDate(), data.chartsdata[index].data[time]]);
                            delete dateval;
                        }
                        series.data = chdata;                        
                        option.tmpoptions.series.push(series);
                    }
                option.tmpoptions.tooltip.trigger = 'axis';
                }

                if (option.tmpoptions.xAxis[0].type == "category")
                {
//                    console.log(option.tmpoptions.xAxis[0]);
                    var m_sample = option.tmpoptions.xAxis[0].m_sample;
                    var tag = option.tmpoptions.xAxis[0].m_tags;
                    var xdata = [];
                    var loop = 0;
                    var sdata = [];
                    for (index in data.chartsdata)
                    {
                        var tagn = Object.keys(data.chartsdata[index].tags)[tag]
                        xdata.push(data.chartsdata[index].tags[tagn]);

                        var chdata = [];
//                        var series = clone_obg(defserie);
//                        series.type = "bar";
//                        var name = data.chartsdata[index].metric + JSON.stringify(data.chartsdata[index].tags)
//                        series.name = name;
//                        option.tmpoptions.legend.data.push({"name": name});


//                        console.log(xdata);
                        var val;
                        for (var time in data.chartsdata[index].data) {
                            chdata.push(data.chartsdata[index].data[time]);
                            val = data.chartsdata[index].data[time];
                        }


//                        for (i = 0; i < loop; i++) { 
//                            sdata.push(null);
//                        }                   
//                        loop++;

                        if (m_sample == "avg")
                        {
                            val = numbers.statistic.mean(chdata);
                        }
                        if (m_sample == "min")
                        {

                            val = numbers.basic.min(chdata);

                        }
                        if (m_sample == "max")
                        {
                            val = numbers.basic.max(chdata);
                        }
                        if (m_sample == "total")
                        {
                            val = numbers.basic.sum(chdata);
                        }
                        if (m_sample == "product")
                        {
                            val = numbers.basic.product(chdata);
                        }
                        if (m_sample == "count")
                        {
                            val = chdata.length;
                        }


                        sdata.push(val);
//                        series.data = sdata;
//                        
//                        option.tmpoptions.series.push(series);                        
                    }
                    var series = clone_obg(defserie);
                    series.data = sdata;
                    series.type = "bar";
                    option.tmpoptions.tooltip.trigger = 'item';

                    series.itemStyle = {
                        normal: {
                            color: function (params) {
                                return colorPalette[params.dataIndex]
                            }
                        }
                    };
                    option.tmpoptions.series.push(series);
                    option.tmpoptions.xAxis[0].data = xdata;
                }
            }
            chart.setOption(option.tmpoptions);
        });
    }

}


//    markPoint: {
//        data: [
//            {type: 'max', name: 'max', symbol: 'diamond', symbolSize: 20, itemStyle: {
//                    normal: {
//                        label: {position: "top", formatter: format_func}
//                    }}},
//            {type: 'min', name: 'min', symbol: 'triangle', symbolSize: 20, itemStyle: {normal: {label: {position: 'top', formatter: format_func}}}},
//        ]
//    },

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
                var bkgclass = ""
                if (typeof (dashJSON[rowindex]["widgets"][widgetindex].transparent) == "undefined")
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

//                console.log(dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").attr("size", dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").attr("index", widgetindex);
                $("#charttemplate .chartsection").attr("id", "widget" + rowindex + "_" + widgetindex);
                $("#charttemplate .chartsection").attr("type", dashJSON[rowindex]["widgets"][widgetindex].type);
                $("#charttemplate .chartsection").attr("class", "chartsection " + bkgclass + "col-xs-12 col-md-" + dashJSON[rowindex]["widgets"][widgetindex].size);
                $("#charttemplate .chartsection").find(".echart_line").attr("id", "echart_line" + rowindex + "_" + widgetindex);
//                console.log(dashJSON[rowindex]["widgets"][widgetindex].height);
                if (typeof (dashJSON[rowindex]["widgets"][widgetindex].height) === "undefined")
                {
                    $("#charttemplate .chartsection").find(".echart_line").css("height", dashJSON[rowindex]["widgets"][widgetindex].height)
                } else
                {
                    $("#charttemplate .chartsection").find(".echart_line").css("height", "300px")
                }
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
                        dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'oddeyelight');
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
                        dashJSON[rowindex]["widgets"][widgetindex].echartLine = echarts.init(document.getElementById("echart_line" + rowindex + "_" + widgetindex), 'oddeyelight');
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

    if (typeof (dashJSON[row]["widgets"][index].transparent) == "undefined")
    {
        $(".editchartpanel #singlewidget").addClass("chartbkg")

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

//    dashJSON[row]["widgets"][index].tmpoptions.legend.show = true;
    echartLine = echarts.init(document.getElementById("echart_line_single"), 'oddeyelight');
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

//    console.log(dashJSON[row]["widgets"][index].tmpoptions.legend);
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


$(document).ready(function () {


    $('body').on("mouseenter", ".select2-container--default .menu-select .select2-results__option[role=group]", function () {
        $(this).find("ul").css("top", $(this).position().top);
        var curent = $(this);
        if ($(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").length == 0)
        {
            curent.find("ul:hidden").show();
        } else
        {
            if ($(".select2-container--default .menu-select .select2-results__option[role=group] ul:visible").parents(".select2-results__option[role=group]").attr("aria-label") != $(this).attr("aria-label"))
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