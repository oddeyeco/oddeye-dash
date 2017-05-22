/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global getParameterByName, pickerlabel, PicerOptionSet2, jsonmaker, editor, chartForm */

class ChartEditForm {

    constructor(chart, formwraper, row, index, dashJSON) {
        this.chart = chart;
        this.formwraper = formwraper;
        this.row = row;
        this.index = index;
        this.dashJSON = dashJSON;
        var elem = document.getElementById("manual");
        if (this.dashJSON[this.row]["widgets"][this.index].manual)
        {
            if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].manual)
            {
                $(elem).trigger('click');
            }
        }

        if (dashJSON[row]["widgets"][index].times)
        {
            if (dashJSON[row]["widgets"][index].times.intervall)
            {
                $("#refreshtime_private").val(dashJSON[row]["widgets"][index].times.intervall);
            }
            $('#reportrange_private span').html(dashJSON[row]["widgets"][index].times.pickerlabel);
            if (dashJSON[row]["widgets"][index].times.pickerlabel)
            {
                if (dashJSON[row]["widgets"][index].times.pickerlabel !== "Custom")
                {
                    PicerOptionSet2.startDate = PicerOptionSet2.ranges[dashJSON[row]["widgets"][index].times.pickerlabel][0];
                    PicerOptionSet2.endDate = PicerOptionSet2.ranges[dashJSON[row]["widgets"][index].times.pickerlabel][1];
                }
            }
        }
        ;

        $('#reportrange_private').daterangepicker(PicerOptionSet2, cbJson(dashJSON[row]["widgets"][index], $('#reportrange_private')));

        var formhtml = $("#form_template").html();
        this.formwraper.find("#tab_metrics #forms").html("");
        if (typeof (dashJSON[row]["widgets"][index].q) !== "undefined")
        {

            for (var qindex in dashJSON[row]["widgets"][index].q)
            {
                var query = "";
                var tags = [];
                var metrics = [];
                var aggregator = "";
                var form = $(formhtml);
                form.attr("id", qindex + "_query");
                form.attr("qindex", qindex);
                form.find("#baze_disable_downsampling").attr("id", qindex + "_disable_downsampling");
                form.find("#baze_enable_rate").attr("id", qindex + "_enable_rate");
                form.find("#" + qindex + "_disable_downsampling").addClass("js-switch-small");
                form.find("#" + qindex + "_enable_rate").addClass("js-switch-small");

                this.formwraper.find("#tab_metrics #forms").append(form);
                if ((typeof (dashJSON[row]["widgets"][index].q[qindex])) === "string")
                {
                    query = "?" + dashJSON[row]["widgets"][index].q[qindex];
                    tags = getParameterByName("tags", query).split(";");
                    metrics = getParameterByName("metrics", query).split(";");
                    aggregator = getParameterByName("aggregator", query);
                } else
                {
                    if (dashJSON[row]["widgets"][index].q[qindex].info)
                    {
                        tags = dashJSON[row]["widgets"][index].q[qindex].info.tags.split(";");
                        metrics = dashJSON[row]["widgets"][index].q[qindex].info.metrics.split(";");
                        aggregator = dashJSON[row]["widgets"][index].q[qindex].info.aggregator;
                    }

                }
                this.formwraper.find("#tab_metrics form#" + qindex + "_query div.tags").html("");
                for (var tagindex in tags)
                {
                    if (tags[tagindex] !== "")
                    {
                        this.formwraper.find("#tab_metrics form#" + qindex + "_query div.tags").append("<span class='control-label query_tag tag_label' ><span class='tagspan'><span class='text'>" + tags[tagindex] + "</span><a><i class='fa fa-pencil'></i> </a> <a><i class='fa fa-remove'></i></a></span></span>");
                    }
                }

                this.formwraper.find("#tab_metrics form#" + qindex + "_query div.metrics").html("");
                for (var metricindex in metrics)
                {
                    if (metrics[metricindex] !== "")
                    {
                        this.formwraper.find("#tab_metrics form#" + qindex + "_query div.metrics").append("<span class='control-label query_metric tag_label' ><span class='tagspan'><span class='text'>" + metrics[metricindex] + "</span><a><i class='fa fa-pencil'></i> </a> <a><i class='fa fa-remove'></i></a></span></span>");
                    }
                }
                if (aggregator === "")
                {
                    this.formwraper.find("#tab_metrics form#" + qindex + "_query select.aggregator").val("none");
                } else
                {
                    this.formwraper.find("#tab_metrics form#" + qindex + "_query select.aggregator").val(aggregator);
                }

                if (typeof (dashJSON[row]["widgets"][index].q[qindex].info) !== "undefined")
                {
                    this.formwraper.find("#tab_metrics form#" + qindex + "_query input.alias").val(dashJSON[row]["widgets"][index].q[qindex].info.alias);
                    this.formwraper.find("#tab_metrics form#" + qindex + "_query input.alias2").val(dashJSON[row]["widgets"][index].q[qindex].info.alias2);
                    var ds = dashJSON[row]["widgets"][index].q[qindex].info.downsample;
                    if (ds === "")
                    {
                        this.formwraper.find("#tab_metrics form#" + qindex + "_query select.down-sample-time").val("");
                        this.formwraper.find("#tab_metrics form#" + qindex + "_query select.down-sample-aggregator").val("none");
                    } else
                    {
                        var ds_ = ds.split("-");
                        this.formwraper.find("#tab_metrics form#" + qindex + "_query input.down-sample-time").val(ds_[0]);
                        this.formwraper.find("#tab_metrics form#" + qindex + "_query select.down-sample-aggregator").val(ds_[1]);
                    }

                    var elem = document.getElementById(qindex + "_disable_downsampling");
                    if (elem.checked !== dashJSON[row]["widgets"][index].q[qindex].info.downsamplingstate)
                    {
                        $(elem).trigger('click');
                    }
                    var elem = document.getElementById(qindex + "_enable_rate");
//                    console.log(dashJSON[row]["widgets"][index].q[qindex].info.rate);
                    if (!dashJSON[row]["widgets"][index].q[qindex].info.rate)
                    {
                        dashJSON[row]["widgets"][index].q[qindex].info.rate = false;
                    }
                    if (elem.checked !== dashJSON[row]["widgets"][index].q[qindex].info.rate)
                    {
                        $(elem).trigger('click');
                    }

                }
            }
            var elems = document.querySelectorAll('#tab_metrics #forms .js-switch-small');
            for (var i = 0; i < elems.length; i++) {
                var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
                elems[i].onchange = function () {
                    if (chartForm !== null)
                    {
                        chartForm.change($(this));
                    }
                };
            }
        } else
        {
            this.formwraper.find("#tab_metrics div.tags").html("");
            this.formwraper.find("#tab_metrics div.metrics").html("");
        }




        if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.animation) === "undefined")
        {
            var input = this.formwraper.find("#display_animation");
            var elem = document.getElementById(input.attr("id"));
            if (!elem.checked)
            {
                $(elem).trigger('click');
            }

        } else
        {
            var input = this.formwraper.find("#display_animation");
            var elem = document.getElementById(input.attr("id"));
            if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].options.animation)
            {
                $(elem).trigger('click');
            }
        }
        if (typeof (this.dashJSON[this.row]["widgets"][this.index].fill) === "undefined")
        {
            this.formwraper.find("#display_fillArea").val("none");
        } else
        {
            this.formwraper.find("#display_fillArea").val(this.dashJSON[this.row]["widgets"][this.index].fill);
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].step) === "undefined")
        {
            this.formwraper.find("#display_steped").val("false");
        } else
        {
            this.formwraper.find("#display_steped").val(this.dashJSON[this.row]["widgets"][this.index].step);
        }


        if (typeof (this.dashJSON[this.row]["widgets"][this.index].stacked) === "undefined")
        {
            var input = this.formwraper.find("#display_stacked");
            var elem = document.getElementById(input.attr("id"));
            if (elem.checked)
            {
                $(elem).trigger('click');
            }

        } else
        {
            var input = this.formwraper.find("#display_stacked");
            var elem = document.getElementById(input.attr("id"));
            if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].stacked)
            {
                $(elem).trigger('click');
            }
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].type) === "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].type = "line";
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].points) !== "undefined")
        {
            this.formwraper.find("#display_points").val(this.dashJSON[this.row]["widgets"][this.index].points);
        } else
        {
            this.formwraper.find("#display_points").val("none");
        }

        this.formwraper.find("#display_charttype").val(this.dashJSON[this.row]["widgets"][this.index].type);


        if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.yAxis) === "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].options.yAxis = [{type: 'value'}];
        } else
        {
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.yAxis[0]) === "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].options.yAxis = [{type: 'time'}];
            }
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.xAxis) === "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].options.xAxis = [{type: 'time'}];
        } else
        {
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.xAxis[0]) === "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].options.xAxis = [{type: 'time'}];
            }
        }
        var key;
        var formObj = this;
        if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.dataZoom) !== "undefined")
        {

            if (this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.constructor !== Array)
            {
                var dz = [];
                dz.push(this.dashJSON[this.row]["widgets"][this.index].options.dataZoom);
                this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [{
                        type: 'inside',
                        xAxisIndex: 0,
                        start: 0,
                        end: 100
                    }];
            }

            var Scrollzoom = false;
            var xzoom = false;
            var yzoom = false;
            for (var ind in this.dashJSON[this.row]["widgets"][this.index].options.dataZoom)
            {
                var zoom = this.dashJSON[this.row]["widgets"][this.index].options.dataZoom[ind];
                if ((zoom.xAxisIndex === 0) && (zoom.type === "inside"))
                {
                    Scrollzoom = true;
                }

                if ((zoom.xAxisIndex === 0) && (zoom.type === "slider"))
                {
                    xzoom = true;
                }

                if ((zoom.yAxisIndex === 0) && (zoom.type === "slider"))
                {
                    yzoom = true;
                }
            }
//            console.log(yzoom);
            var elem = document.getElementById("display_datazoomX");
            if (elem.checked !== xzoom)
            {
                $(elem).trigger('click');
            }
            var elem = document.getElementById("display_datazoomY");
            if (elem.checked !== yzoom)
            {
                $(elem).trigger('click');
            }
            var elem = document.getElementById("display_datazoom");
            if (elem.checked !== Scrollzoom)
            {
                $(elem).trigger('click');
            }
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.grid) !== "undefined")
        {
            for (key in this.dashJSON[this.row]["widgets"][this.index].options.grid)
            {
                var inputs = this.formwraper.find("#tab_display .grid [chart_prop_key='" + key + "']");
                inputs.each(function () {
                    formObj.fillinputs($(this), "grid", key);
                });
            }

        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].options.yAxis[0])
        {
            if (key === "show")
            {
                var input = this.formwraper.find("#tab_axes [axes='yAxis'][index='0'][chart_prop_key='" + key + "']");
                var elem = document.getElementById(input.attr("id"));
                if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.yAxis[0].show) === "undefined")
                {
                    if (!elem.checked)
                    {
                        $(elem).trigger('click');
                    }
                } else
                {
                    if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].options.yAxis[0].show)
                    {
                        $(elem).trigger('click');
                    }
                }
            } else
            {
                var inputs = this.formwraper.find("#tab_axes [axes='yAxis'][index='0'][chart_prop_key='" + key + "']");
                inputs.each(function () {
                    formObj.fillinputs($(this), "yAxis", key, 0);
                });
            }
        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].options.xAxis[0])
        {
            if (key === "show")
            {
                var input = this.formwraper.find("#tab_axes [axes='xAxis'][index='0'][chart_prop_key='" + key + "']");
                var elem = document.getElementById(input.attr("id"));
                if (typeof (this.dashJSON[this.row]["widgets"][this.index].options.xAxis[0].show) === "undefined")
                {
                    if (!elem.checked)
                    {
                        $(elem).trigger('click');
                    }
                } else
                {
                    if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].options.xAxis[0].show)
                    {
                        $(elem).trigger('click');
                    }
                }
            } else
            {
                var inputs = this.formwraper.find("#tab_axes [axes='xAxis'][index='0'][chart_prop_key='" + key + "']");
                inputs.each(function () {
                    formObj.fillinputs($(this), "xAxis", key, 0);
                });
            }
        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].options.title)
        {

            var inputs = this.formwraper.find("#tab_general [chart_prop_key='" + key + "']");
            inputs.each(function () {
                formObj.fillinputs($(this), "title", key);
            });


        }
        ;

        if (typeof (dashJSON[this.row]["widgets"][this.index].height) !== "undefined")
        {
            this.formwraper.find("#tab_general .edit-dimensions input#dimensions_height").val(dashJSON[this.row]["widgets"][this.index].height);
        } else
        {
            this.formwraper.find("#tab_general .edit-dimensions input#dimensions_height").val("300px");
        }
//        console.log(dashJSON[this.row]["widgets"][this.index].size);
        if (typeof (dashJSON[this.row]["widgets"][this.index].size) !== "undefined")
        {
            this.formwraper.find("#tab_general .edit-dimensions select#dimensions_span").val(dashJSON[this.row]["widgets"][this.index].size);
        } else
        {
            this.formwraper.find("#tab_general .edit-dimensions select#dimensions_span").val("12");
        }

        if (typeof (dashJSON[this.row]["widgets"][this.index].transparent) !== "undefined")
        {
            var elem = document.getElementById("dimensions_transparent");
            if (elem.checked !== dashJSON[this.row]["widgets"][this.index].transparent)
            {
                $(elem).trigger('click');
            }
        } else
        {
            var elem = document.getElementById("dimensions_transparent");
            if (elem.checked)
            {
                $(elem).trigger('click');
            }
        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].options.legend)
        {
            var inputs = this.formwraper.find(".edit-legend [chart_prop_key='" + key + "']");
            var formObj = this;
            inputs.each(function () {
                formObj.fillinputs($(this), "legend", key);
            });
        }


    }

    resetjson()
    {
        var jsonstr = JSON.stringify(this.dashJSON[this.row]["widgets"][this.index], jsonmaker);
        editor.set(JSON.parse(jsonstr));
    }

    applyjson()
    {
        var tmpJson = editor.get();
        clearTimeout(this.dashJSON[this.row]["widgets"][this.index].timer);
        for (var key in tmpJson)
        {
            this.dashJSON[this.row]["widgets"][this.index][key] = clone_obg(tmpJson[key]);
        }

        for (var key in this.dashJSON[this.row]["widgets"][this.index])
        {
            if (!tmpJson[key])
            {
                delete this.dashJSON[this.row]["widgets"][this.index][key];
            }

        }
        this.dashJSON[this.row]["widgets"][this.index].manual = true;
        var opt = this.dashJSON[this.row]["widgets"][this.index];
        showsingleChart(this.row, this.index, this.dashJSON, false, true, false, function () {
            var jsonstr = JSON.stringify(opt, jsonmaker);
            editor.set(JSON.parse(jsonstr));
        });
    }

    change(input) {
        if (input.hasClass('Addq'))
        {
            if (!this.dashJSON[this.row]["widgets"][this.index].q)
            {
                this.dashJSON[this.row]["widgets"][this.index].q = [];
            }
            this.dashJSON[this.row]["widgets"][this.index].q.push({});
        }
        if (input.attr('id') === "manual")
        {
            var elem = document.getElementById(input.attr("id"));
            if (elem.checked)
            {
                this.dashJSON[this.row]["widgets"][this.index].manual = true;
            } else
            {
                delete this.dashJSON[this.row]["widgets"][this.index].manual;
            }
        }
        if (!this.dashJSON[this.row]["widgets"][this.index].manual)
        {

            this.dashJSON[this.row]["widgets"][this.index].options.series = [];
        }

        if (input.parents("form").hasClass("edit-times"))
        {
            if (input.attr('id') === "refreshtime_private")
            {
                if (!this.dashJSON[this.row]["widgets"][this.index].times)
                {
                    this.dashJSON[this.row]["widgets"][this.index].times = {};
                }
                this.dashJSON[this.row]["widgets"][this.index].times.intervall = input.val();
            }
        }
        if (input.parents("form").hasClass("edit-query"))
        {
            if (input.hasClass('Removeq'))
            {
                this.dashJSON[this.row]["widgets"][this.index].q.splice(input.parents("form").attr("qindex"), 1);
            } else if (input.hasClass('Duplicateq'))
            {
                this.dashJSON[this.row]["widgets"][this.index].q.push(clone_obg(this.dashJSON[this.row]["widgets"][this.index].q[input.parents("form").attr("qindex")]));
            } else
            {
                var qindex = input.parents("form").attr("qindex");
                var metrics = "";
                this.formwraper.find("form#" + qindex + "_query  .query_metric .text").each(function () {
                    metrics = metrics + $(this).text() + ";";
                });

                var tags = "";
                this.formwraper.find("form#" + qindex + "_query  .query_tag .text").each(function () {
                    tags = tags + $(this).text() + ";";
                });
                downsample = "";
                if (this.formwraper.find("form#" + qindex + "_query  .down-sample-time").val() !== "")
                {
                    var downsample = this.formwraper.find("form#" + qindex + "_query  .down-sample-time").val() + "-" + this.formwraper.find("form#" + qindex + "_query  .down-sample-aggregator").val();
                }
//            this.dashJSON[this.row]["widgets"][this.index].q = [];
                this.dashJSON[this.row]["widgets"][this.index].q[qindex] = {info: {"rate": document.getElementById(qindex + "_enable_rate").checked, "downsample": downsample, "tags": tags, "metrics": metrics, "aggregator": this.formwraper.find("form#" + qindex + "_query  .aggregator").val(), "downsamplingstate": document.getElementById(qindex + "_disable_downsampling").checked, "alias": this.formwraper.find("form#" + qindex + "_query  .alias").val(), "alias2": this.formwraper.find("form#" + qindex + "_query  .alias2").val()}};
            }

        }

        if (input.parents("form").hasClass("edit-display"))
        {
            var key = input.attr("chart_prop_key");
            if (key === "animation")
            {
                var elem = document.getElementById(input.attr("id"));
                this.dashJSON[this.row]["widgets"][this.index].options.animation = elem.checked;
            }
            if (key === "dataZoom")
            {
                var elem = document.getElementById(input.attr("id"));
                if (!this.dashJSON[this.row]["widgets"][this.index].options.dataZoom)
                {
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [{
                            type: 'inside',
                            xAxisIndex: 0,
                            start: 0,
                            end: 100
                        }];
                }

                if (this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.constructor !== Array)
                {
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [{
                            type: 'inside',
                            xAxisIndex: 0,
                            start: 0,
                            end: 100
                        }];
                }
                if (elem.checked)
                {
                    if (!this.dashJSON[this.row]["widgets"][this.index].options.dataZoom)
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [];
                    }
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.push({
                        type: 'inside',
                        xAxisIndex: 0,
                        start: 0,
                        end: 100
                    });

                } else
                {
                    var dz = [];
                    for (var k in this.dashJSON[this.row]["widgets"][this.index].options.dataZoom) {
                        var zoomzoom = this.dashJSON[this.row]["widgets"][this.index].options.dataZoom[k];
                        if ((zoomzoom.xAxisIndex !== 0) || (zoomzoom.type !== "inside"))
                        {
                            dz.push(zoomzoom);
                        }
                    }
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = dz;
                }
            }

            if (key === "stacked")
            {
                var elem = document.getElementById(input.attr("id"));
                if (elem.checked)
                {
                    this.dashJSON[this.row]["widgets"][this.index][key] = elem.checked;
                } else
                {
                    delete this.dashJSON[this.row]["widgets"][this.index][key];
                }
            }
            if (key === "type" || key === "points" || key === "fill" || key === "step")
            {
                this.dashJSON[this.row]["widgets"][this.index][key] = input.val();
                if (key === "type")
                {
                    if (this.dashJSON[this.row]["widgets"][this.index].type !== "line" && this.dashJSON[this.row]["widgets"][this.index].type !== "bar")
                    {
                        this.dashJSON[this.row]["widgets"][this.index].stacked = false;
                        this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.show = false;
                        for (var index in this.dashJSON[this.row]["widgets"][this.index].options.xAxis)
                        {
                            this.dashJSON[this.row]["widgets"][this.index].options.xAxis[index].show = false;
                        }
                        for (var index in this.dashJSON[this.row]["widgets"][this.index].options.yAxis)
                        {
                            this.dashJSON[this.row]["widgets"][this.index].options.yAxis[index].show = false;
                        }
                    }

                }

            }

            if (input.parents(".form_main_block").hasClass("grid"))
            {
                if (!this.dashJSON[this.row]["widgets"][this.index].options.grid)
                {
                    this.dashJSON[this.row]["widgets"][this.index].options.grid = {};
                }
                if (input.val() !== "")
                {
                    this.dashJSON[this.row]["widgets"][this.index].options.grid[key] = input.val();
                } else
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].options.grid[key];
                }
            }

//this.dashJSON[this.row]["widgets"][this.index].type
        }
        if (input.parents("form").hasClass("edit-axes"))
        {
            var key = input.attr("chart_prop_key");
            var index = input.attr("index");
            var axes = input.attr("axes");

            if (typeof (this.dashJSON[this.row]["widgets"][this.index].options[axes][index]) === "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].options[axes][index] = {type: 'value', axisLabel: {}};
            }

            if (key === "dataZoomY")
            {
                var elem = document.getElementById(input.attr("id"));
                if (this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.constructor !== Array)
                {
                    var dz = [];
                    dz.push(this.dashJSON[this.row]["widgets"][this.index].options.dataZoom);
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [{
                            type: 'slider',
                            yAxisIndex: 0,
                            start: 0,
                            end: 100
                        }];
                }
                ;
                if (elem.checked)
                {
                    if (!this.dashJSON[this.row]["widgets"][this.index].options.dataZoom)
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [];
                    }
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.push({
                        type: 'slider',
                        yAxisIndex: 0,
                        start: 0,
                        end: 100
                    });

                } else
                {
                    var dz = [];
                    for (var k in this.dashJSON[this.row]["widgets"][this.index].options.dataZoom) {
                        var zoomzoom = this.dashJSON[this.row]["widgets"][this.index].options.dataZoom[k];

                        if ((zoomzoom.yAxisIndex !== 0) || (zoomzoom.type !== "slider"))
                        {
                            dz.push(zoomzoom);
                        }
                    }
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = dz;
                }
            } else if (key === "dataZoomX")
            {
                var elem = document.getElementById(input.attr("id"));
                if (this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.constructor !== Array)
                {
                    var dz = [];
                    dz.push(this.dashJSON[this.row]["widgets"][this.index].options.dataZoom);
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [{
                            type: 'slider',
                            xAxisIndex: 0,
                            start: 0,
                            end: 100
                        }];
                }
                ;
                if (elem.checked)
                {
                    if (!this.dashJSON[this.row]["widgets"][this.index].options.dataZoom)
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = [];
                    }
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom.push({
                        type: 'slider',
                        xAxisIndex: 0,
                        start: 0,
                        end: 100
                    });

                } else
                {
                    dz = [];
                    for (var k in this.dashJSON[this.row]["widgets"][this.index].options.dataZoom) {
                        var zoomzoom = this.dashJSON[this.row]["widgets"][this.index].options.dataZoom[k];

                        if ((zoomzoom.xAxisIndex !== 0) || (zoomzoom.type !== "slider"))
                        {
                            dz.push(zoomzoom);
                        }
                    }
                    this.dashJSON[this.row]["widgets"][this.index].options.dataZoom = dz;
                }
            } else if (key === "show")
            {
                var elem = document.getElementById(input.attr("id"));
                this.dashJSON[this.row]["widgets"][this.index].options[axes][index].show = elem.checked;
            } else if (key === "unit")
            {
                this.dashJSON[this.row]["widgets"][this.index].options[axes][index].unit = input.val();
            } else
            {
                if (input.val() === "")
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].options[axes][index][key];
                } else
                {
                    if ($.isNumeric(input.val()))
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options[axes][index][key] = parseFloat(input.val());
                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options[axes][index][key] = input.val();
                    }

                    if (key === "type")
                    {
                        if (input.val() === "category")
                        {
                            if (typeof (this.dashJSON[this.row]["widgets"][this.index].options[axes][index]["m_sample"]) === "undefined")
                            {
                                this.dashJSON[this.row]["widgets"][this.index].options[axes][index]["m_sample"] = "avg";
                            }
                            if (typeof (this.dashJSON[this.row]["widgets"][this.index].options[axes][index]["m_tags"]) === "undefined")
                            {
                                this.dashJSON[this.row]["widgets"][this.index].options[axes][index]["m_tags"] = 0;
                            }
                        } else
                        {
                            this.dashJSON[this.row]["widgets"][this.index].options[axes][index].data = [];
                        }
                    }

                }
            }
        }
        if (input.parents("form").hasClass("edit-dimensions"))
        {
            if (input.attr("id") === "dimensions_height")
            {
                var points = "";
                if ($.isNumeric(input.val()))
                {
                    points = "px";
                }
                if (input.val() === "")
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].height;
                }
                this.dashJSON[this.row]["widgets"][this.index].height = input.val() + points;
            }
            if (input.attr("id") === "dimensions_span")
            {
                this.dashJSON[this.row]["widgets"][this.index].size = input.val();
            }
            if (input.attr("id") === "dimensions_transparent")
            {
                var elem = document.getElementById(input.attr("id"));
                if (elem.checked)
                {
                    this.dashJSON[this.row]["widgets"][this.index].transparent = true;
                } else
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].transparent;
                }
            }
        }


        if (input.parents("form").hasClass("edit-title"))
        {
            var key = input.attr("chart_prop_key");

            this.formwraper.find(".edit-title " + input.prop("tagName") + "[chart_prop_key='" + key + "']").val(input.val());

            if (input.prop("tagName") === "INPUT" || "SELECT" || "DIV")
            {
                if (input.val() === "")
                {
                    var inputs = this.formwraper.find(".edit-title [chart_prop_key='" + key + "']");
                    if (inputs.length === 1)
                    {
                        if (this.dashJSON[this.row]["widgets"][this.index].options.title)
                        {
                            delete this.dashJSON[this.row]["widgets"][this.index].options.title[key];
                        }

                    }
                    if (inputs.length > 1)
                    {
                        var empty = true;
                        inputs.each(function () {
                            empty = empty & ($(this).val() === "");
                        });
                        if (empty)
                        {
                            delete this.dashJSON[this.row]["widgets"][this.index].options.title[key];
                        }
                    }

                    if (input.parent().hasClass("cl_picer"))
                    {
                        inputs.each(function () {
                            $(this).parent().colorpicker('setValue', 'transparent');
                        });

                    }
                } else
                {
                    if (!this.dashJSON[this.row]["widgets"][this.index].options.title)
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.title = {};
                    }
                    if ($.isNumeric(input.val()))
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.title[key] = parseInt(input.val());
                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.title[key] = input.val();
                    }

                }

                if (input.attr("type") === "checkbox")
                {
                    var elem = document.getElementById(input.attr("id"));
                    if (elem.checked)
                    {
                        delete this.dashJSON[this.row]["widgets"][this.index].options.title[key];
                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.title[key] = false;
                    }
                }


            }
        }

        if (input.parents("form").hasClass("edit-legend"))
        {
            var key = input.attr("chart_prop_key");

            if (input.prop("tagName") === "INPUT" || "SELECT" || "DIV")
            {
                if (input.val() === "")
                {
                    if (!this.dashJSON[this.row]["widgets"][this.index].options.legend[key] || !input.val()) {
                        delete this.dashJSON[this.row]["widgets"][this.index].options.legend[key];
                    }

                    if (input.parent().hasClass("cl_picer"))
                    {
                        input.parent().colorpicker('setValue', 'transparent');
                    }
                } else
                {
                    if ($.isNumeric(input.val()))
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.legend[key] = parseInt(input.val());
                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.legend[key] = input.val();
                    }

                }

                if (input.attr("type") === "checkbox")
                {
                    var elem = document.getElementById(input.attr("id"));
                    if (elem.checked)
                    {
                        delete this.dashJSON[this.row]["widgets"][this.index].options.legend[key];

                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].options.legend[key] = false;
                    }
                }
            }
        }
        var opt = this.dashJSON[this.row]["widgets"][this.index];
        showsingleChart(this.row, this.index, this.dashJSON, false, true, false, function () {
            var jsonstr = JSON.stringify(opt, jsonmaker);
            editor.set(JSON.parse(jsonstr));
        });
    }

    fillinputs(input, item, key, index = null)
    {
        if (input.parent().hasClass("cl_picer"))
        {
            input.parent().colorpicker('setValue', this.dashJSON[this.row]["widgets"][this.index].options[item][key]);
//            console.log(this.dashJSON[this.row]["widgets"][this.index].options[item][key]+" "+key);
        }
        if (typeof (input.attr("type")) === "undefined")
        {
//            if (input.prop("tagName").toLowerCase() === "select")
//            {
            if (index === null)
            {
                input.val(this.dashJSON[this.row]["widgets"][this.index].options[item][key]);
            } else
            {
                input.val(this.dashJSON[this.row]["widgets"][this.index].options[item][index][key]);
            }
//            }


        } else
        {
            if (input.attr("type").toLowerCase() === "number")
            {
                if (index === null)
                {
                    if ($.isNumeric(this.dashJSON[this.row]["widgets"][this.index].options[item][key]))
                    {
                        input.val(this.dashJSON[this.row]["widgets"][this.index].options[item][key]);
                    }
                } else
                {
//                    input.val(this.dashJSON[this.row]["widgets"][this.index].options[item][index][key]);
                    if ($.isNumeric(this.dashJSON[this.row]["widgets"][this.index].options[item][index][key]))
                    {
                        input.val(this.dashJSON[this.row]["widgets"][this.index].options[item][index][key]);
                    }
                }


            }

            if (input.attr("type").toLowerCase() === "text")
            {

                if (index === null)
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].options[item][key]);
                } else
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].options[item][index][key]);
                }

            }
            if (input.attr("type").toLowerCase() === "checkbox")
            {
                var elem = document.getElementById(input.attr("id"));

                if (this.dashJSON[this.row]["widgets"][this.index].options[item][key])
                {
                    if (!elem.checked)
                    {
                        $(elem).trigger('click');
                    }

                } else
                {
                    if (elem.checked)
                    {
                        $(elem).trigger('click');
                    }
                }


            }
    }
    }
}