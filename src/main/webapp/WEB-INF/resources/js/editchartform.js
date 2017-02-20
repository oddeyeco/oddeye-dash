/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global getParameterByName, pickerlabel, PicerOptionSet2 */

class ChartEditForm {

    constructor(chart, formwraper, row, index, dashJSON) {
        this.chart = chart;
        this.formwraper = formwraper;
        this.row = row;
        this.index = index;
        this.dashJSON = dashJSON;


//        console.log(dashJSON[row]["widgets"][index].times);
        if (dashJSON[row]["widgets"][index].times)
        {
            if (dashJSON[row]["widgets"][index].times.intervall)
            {
                $("#refreshtime_private").val(dashJSON[row]["widgets"][index].times.intervall);
            }
            $('#reportrange_private span').html(dashJSON[row]["widgets"][index].times.pickerlabel);
            PicerOptionSet2.startDate = PicerOptionSet2.ranges[dashJSON[row]["widgets"][index].times.pickerlabel][0];
            PicerOptionSet2.endDate = PicerOptionSet2.ranges[dashJSON[row]["widgets"][index].times.pickerlabel][1];
        }
        ;

        $('#reportrange_private').daterangepicker(PicerOptionSet2, cbJson(dashJSON[row]["widgets"][index], $('#reportrange_private')));


        if (typeof (dashJSON[row]["widgets"][index].queryes) !== "undefined")
        {
            if ((typeof (dashJSON[row]["widgets"][index].queryes[0])) === "string")
            {
                var query = "?" + dashJSON[row]["widgets"][index].queryes[0];
                var tags = getParameterByName("tags", query).split(";");
                var metrics = getParameterByName("metrics", query).split(";");
                var aggregator = getParameterByName("aggregator", query);
            } else
            {
                var tags = dashJSON[row]["widgets"][index].queryes[0].info.tags.split(";");
                var metrics = dashJSON[row]["widgets"][index].queryes[0].info.metrics.split(";");
                var aggregator = dashJSON[row]["widgets"][index].queryes[0].info.aggregator;
            }


            this.formwraper.find("#tab_metrics div.tags").html("");
            for (var tagindex in tags)
            {
                if (tags[tagindex] !== "")
                {
                    this.formwraper.find("#tab_metrics div.tags").append("<span class='control-label query_tag tag_label' ><span class='tagspan'><span class='text'>" + tags[tagindex] + "</span><a><i class='fa fa-pencil'></i> </a> <a><i class='fa fa-remove'></i></a></span></span>");
                }
            }

            this.formwraper.find("#tab_metrics div.metrics").html("");
            for (var metricindex in metrics)
            {
                if (metrics[metricindex] !== "")
                {
                    this.formwraper.find("#tab_metrics div.metrics").append("<span class='control-label query_metric tag_label' ><span class='tagspan'><span class='text'>" + metrics[metricindex] + "</span><a><i class='fa fa-pencil'></i> </a> <a><i class='fa fa-remove'></i></a></span></span>");
                }
            }


            if (aggregator === "")
            {
                this.formwraper.find("#tab_metrics select#aggregator").val("none");
            } else
            {
                this.formwraper.find("#tab_metrics select#aggregator").val(aggregator);
            }

            if (typeof (dashJSON[row]["widgets"][index].queryes[0].info) !== "undefined")
            {
                this.formwraper.find("#tab_metrics input#alias").val(dashJSON[row]["widgets"][index].queryes[0].info.alias);
                var ds = dashJSON[row]["widgets"][index].queryes[0].info.downsample;
                if (ds === "")
                {

                } else
                {
                    var ds_ = ds.split("-");
                    this.formwraper.find("#tab_metrics input#down-sample-time").val(ds_[0]);
                    this.formwraper.find("#tab_metrics select#down-sample-aggregator").val(ds_[1]);
                }

                var elem = document.getElementById("disable_downsampling");
                if (elem.checked !== dashJSON[row]["widgets"][index].queryes[0].info.downsamplingstate)
                {
                    $(elem).trigger('click');
                }

            }


        } else
        {
            this.formwraper.find("#tab_metrics div.tags").html("");
            this.formwraper.find("#tab_metrics div.metrics").html("");
        }




        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.animation) === "undefined")
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
            if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].tmpoptions.animation)
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

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.dataZoom) === "undefined")
        {
            var input = this.formwraper.find("#display_datazoom");
            var elem = document.getElementById(input.attr("id"));
            if (elem.checked)
            {
                $(elem).trigger('click');
            }

        } else
        {
            var input = this.formwraper.find("#display_datazoom");
            var elem = document.getElementById(input.attr("id"));
            if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].tmpoptions.dataZoom.show)
            {
                $(elem).trigger('click');
            }
        }

        if (key === "dataZoom")
        {
            var elem = document.getElementById(input.attr("id"));
            this.dashJSON[this.row]["widgets"][this.index].tmpoptions.dataZoom.show = elem.checked;
        }

//        delete  this.dashJSON[this.row]["widgets"][this.index].type;

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].type) === "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].type = "line";
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].points) !== "undefined")
        {
            this.formwraper.find("#display_points").val(this.dashJSON[this.row]["widgets"][this.index].points);
        } else
        {
            this.formwraper.find("#display_points").val("circle");
        }

        this.formwraper.find("#display_charttype").val(this.dashJSON[this.row]["widgets"][this.index].type);


        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis) === "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis = [{type: 'value'}];
        } else
        {
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0]) === "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis = [{type: 'time'}];
            }
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis) === "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis = [{type: 'time'}];
        } else
        {
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0]) === "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis = [{type: 'time'}];
            }
        }
        var key;
        var formObj = this;

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.grid) !== "undefined")
        {
            for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.grid)
            {
                var inputs = this.formwraper.find("#tab_display .grid [chart_prop_key='" + key + "']");
                inputs.each(function () {
                    formObj.fillinputs($(this), "grid", key);
                });
            }

        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0])
        {
            if (key === "show")
            {
                var input = this.formwraper.find("#tab_axes [axes='yAxis'][index='0'][chart_prop_key='" + key + "']");
                var elem = document.getElementById(input.attr("id"));
                if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0].show) === "undefined")
                {
                    if (!elem.checked)
                    {
                        $(elem).trigger('click');
                    }
                } else
                {
                    if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0].show)
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

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1]) === "undefined")
        {
            var elem = document.getElementById("right_axes_show");
            if (elem.checked)
            {
                $(elem).trigger('click');
            }
        } else
        {
            for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1])
            {
                if (key === "show")
                {
                    var input = this.formwraper.find("#tab_axes [axes='yAxis'][index='1'][chart_prop_key='" + key + "']");
                    var elem = document.getElementById(input.attr("id"));
                    if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1].show) === "undefined")
                    {
                        if (!elem.checked)
                        {
                            $(elem).trigger('click');
                        }
                    } else
                    {
                        if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1].show)
                        {
                            $(elem).trigger('click');
                        }
                    }
                } else
                {
                    var inputs = this.formwraper.find("#tab_axes [axes='yAxis'][index='1'][chart_prop_key='" + key + "']");
                    inputs.each(function () {
                        formObj.fillinputs($(this), "yAxis", key, 0);
                    });
                }
            }
        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0])
        {
            if (key === "show")
            {
                var input = this.formwraper.find("#tab_axes [axes='xAxis'][index='0'][chart_prop_key='" + key + "']");
                var elem = document.getElementById(input.attr("id"));
                if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0].show) === "undefined")
                {
                    if (!elem.checked)
                    {
                        $(elem).trigger('click');
                    }
                } else
                {
                    if (elem.checked !== this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0].show)
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

        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title)
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

        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend)
        {
            var inputs = this.formwraper.find(".edit-legend [chart_prop_key='" + key + "']");
            var formObj = this;
            inputs.each(function () {
                formObj.fillinputs($(this), "legend", key);
            });
        }


    }

    chage(input) {

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
//            console.log(input);
            var metrics = "";
            this.formwraper.find(".query_metric .text").each(function () {
                metrics = metrics + $(this).text() + ";";
            });

            var tags = "";
            this.formwraper.find(".query_tag .text").each(function () {
                tags = tags + $(this).text() + ";";
            });
            downsample = "";
            if (this.formwraper.find("#down-sample-time").val() !== "")
            {
                var downsample = this.formwraper.find("#down-sample-time").val() + "-" + this.formwraper.find("#down-sample-aggregator").val();
            }

            var query = "metrics=" + metrics + "&tags=" + tags +
                    "&aggregator=" + this.formwraper.find("#aggregator").val() + "&downsample=" + downsample;


            this.dashJSON[this.row]["widgets"][this.index].queryes = [];
            this.dashJSON[this.row]["widgets"][this.index].queryes.push({"url": query, info: {"downsample": downsample, "tags": tags, "metrics": metrics, "aggregator": this.formwraper.find("#aggregator").val(), "downsamplingstate": document.getElementById("disable_downsampling").checked, "alias": this.formwraper.find("#alias").val()}});
//            console.log(this.dashJSON[this.row]["widgets"][this.index].queryes);
        }

//        console.log("dfsdfsdfs");



        if (input.parents("form").hasClass("edit-display"))
        {
            var key = input.attr("chart_prop_key");
            if (key === "animation")
            {
                var elem = document.getElementById(input.attr("id"));
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.animation = elem.checked;
            }
            if (key === "dataZoom")
            {
                var elem = document.getElementById(input.attr("id"));
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.dataZoom.show = elem.checked;
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
                    console.log(this.dashJSON[this.row]["widgets"][this.index].type);
                    if (this.dashJSON[this.row]["widgets"][this.index].type !== "line" && this.dashJSON[this.row]["widgets"][this.index].type !== "bar")
                    {
                        console.log("valod");
                        this.dashJSON[this.row]["widgets"][this.index].stacked = false;
                        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.dataZoom.show = false;
                        for (var index in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis)
                        {
                            this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[index].show = false;
                        }
                        for (var index in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis)
                        {
                            this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[index].show = false;
                        }                        
                    }
                    
                }

            }

            if (input.parents(".form_main_block").hasClass("grid"))
            {
                if (!this.dashJSON[this.row]["widgets"][this.index].tmpoptions.grid)
                {
                    this.dashJSON[this.row]["widgets"][this.index].tmpoptions.grid = {};
                }
                if (input.val() !== "")
                {
                    this.dashJSON[this.row]["widgets"][this.index].tmpoptions.grid[key] = input.val();
                } else
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.grid[key];
                }
            }

//this.dashJSON[this.row]["widgets"][this.index].type
        }
        if (input.parents("form").hasClass("edit-axes"))
        {
            var key = input.attr("chart_prop_key");
            var index = input.attr("index");
            var axes = input.attr("axes");
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]) === "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index] = {type: 'value', axisLabel: {}};
            }

            if (key === "show")
            {
                var elem = document.getElementById(input.attr("id"));
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index].show = elem.checked;
            } else if (key === "unit")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index].unit = input.val();
            } else
            {
                if (input.val() === "")
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index][key];
                } else
                {

                    this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index][key] = input.val();
                    if ((key === "type") && (input.val() === "category"))
                    {
//                        if (input.val() === "category")
//                        {
//                            this.dashJSON[this.row]["widgets"][this.index].type = "bar";
//                        } else
//                        {
//                            this.dashJSON[this.row]["widgets"][this.index].type = "line";
//                        }
                        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_sample"]) === "undefined")
                        {
                            this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_sample"] = "avg";
                        }
                        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_tags"]) === "undefined")
                        {
                            this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_tags"] = 0;
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
                        delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key];
                    }
                    if (inputs.length > 1)
                    {
                        var empty = true;
                        inputs.each(function () {
                            empty = empty & ($(this).val() === "");
                        });
                        if (empty)
                        {
                            delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key];
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
                    if ($.isNumeric(input.val()))
                    {
                        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key] = parseInt(input.val());
                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key] = input.val();
                    }

                }

                if (input.attr("type") === "checkbox")
                {
                    var elem = document.getElementById(input.attr("id"));
                    if (elem.checked)
                    {
                        delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key];
                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key] = false;
                    }
//                    console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key]);
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
                    if (!this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key] || !input.val()) {
                        delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key];
                    }

                    if (input.parent().hasClass("cl_picer"))
                    {
                        input.parent().colorpicker('setValue', 'transparent');
                    }
                } else
                {
                    if ($.isNumeric(input.val()))
                    {
                        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key] = parseInt(input.val());
                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key] = input.val();
                    }

                }

                if (input.attr("type") === "checkbox")
                {
                    var elem = document.getElementById(input.attr("id"));
                    if (elem.checked)
                    {
                        delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key];

                    } else
                    {
                        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key] = false;
                    }
                }
            }
        }
        showsingleChart(this.row, this.index, this.dashJSON);
    }

    fillinputs(input, item, key, index = null)
    {

        if (input.parent().hasClass("cl_picer"))
        {
            input.parent().colorpicker('setValue', this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
//            console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]+" "+key);
        }
        if (typeof (input.attr("type")) === "undefined")
        {
//            if (input.prop("tagName").toLowerCase() === "select")
//            {
            if (index === null)
            {
                input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
            } else
            {
                input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][index][key]);
            }
//            }


        } else
        {
            if (input.attr("type").toLowerCase() === "number")
            {
                if ($.isNumeric(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]))
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
                }
            }

            if (input.attr("type").toLowerCase() === "text")
            {

                if (index === null)
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
                } else
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][index][key]);
//                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][index][key]);
                }

            }
            if (input.attr("type").toLowerCase() === "checkbox")
            {
                var elem = document.getElementById(input.attr("id"));

                if (this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key])
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
