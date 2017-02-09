/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class ChartEditForm {

    constructor(chart, formwraper, row, index, dashJSON) {
        this.chart = chart;
        this.formwraper = formwraper;
        this.row = row;
        this.index = index;
        this.dashJSON = dashJSON;

        if (typeof (dashJSON[row]["widgets"][index].queryes) !== "undefined")
        {
            var query = "?" + dashJSON[row]["widgets"][index].queryes[0];
            this.formwraper.find("#tab_metrics input#tags").val(getParameterByName("tags", query));
            this.formwraper.find("#tab_metrics input#metrics").val(getParameterByName("metrics", query));
            this.formwraper.find("#tab_metrics input#aggregator").val(getParameterByName("aggregator", query));
            this.formwraper.find("#tab_metrics input#down-sample").val(getParameterByName("downsample", query));
        } else
        {
            this.formwraper.find("#tab_metrics input#tags").val("");
            this.formwraper.find("#tab_metrics input#aggregator").val("");
            this.formwraper.find("#tab_metrics input#metrics").val("");
            this.formwraper.find("#tab_metrics input#down-sample").val("");
        }

//        this.formwraper.find("#tab_general input").val("");

//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1]);
//        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis = [{type: 'log'}];
//        this.dashJSON[this.row]["widgets"][this.index].tmpoptions.calculable = true;
        //Init banse X Y  
        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis) == "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis = [{type: 'value', }];
        } else
        {
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0]) == "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis = [{type: 'time', }];
            }
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis) == "undefined")
        {
            this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis = [{type: 'time', }];
        } else
        {
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0]) == "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis = [{type: 'time', }];
            }
        }


//        //left axes part
//        var elem = document.getElementById("left_axes_show");
//        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0].show) == "undefined")
//        {
//            if (!elem.checked)
//            {
//                $(elem).trigger('click');
//            }
//        } else
//        {
//            if (elem.checked != this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0].show)
//            {
//                $(elem).trigger('click');
//            }
//        }
//
//        //Right axes part
//        var elem = document.getElementById("right_axes_show");
//        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1]) == "undefined")
//        {
//            if (elem.checked)
//            {
//                $(elem).trigger('click');
//            }
//        } else
//        {
//            if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1].show) == "undefined")
//            {
//                if (!elem.checked)
//                {
//                    $(elem).trigger('click');
//                }
//            } else
//            {
//                if (elem.checked != this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1].show)
//                {
//                    $(elem).trigger('click');
//                }
//            }
//        }



        var key;
        var formObj = this;


        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0])
        {
            if (key == "show")
            {
                var input = this.formwraper.find("#tab_axes [axes='yAxis'][index='0'][chart_prop_key='" + key + "']");
                var elem = document.getElementById(input.attr("id"));
                if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0].show) == "undefined")
                {
                    if (!elem.checked)
                    {
                        $(elem).trigger('click');
                    }
                } else
                {
                    if (elem.checked != this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0].show)
                    {
                        $(elem).trigger('click');
                    }
                }
            } else
            {
                var inputs = this.formwraper.find("#tab_axes [axes='yAxis'][index='0'][chart_prop_key='" + key + "']");
                inputs.each(function () {
                    console.log(key);
                    formObj.fillinputs($(this), "yAxis", key, 0);
                })
            }
        }

        if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1]) == "undefined")
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
                if (key == "show")
                {
                    var input = this.formwraper.find("#tab_axes [axes='yAxis'][index='1'][chart_prop_key='" + key + "']");
                    var elem = document.getElementById(input.attr("id"));
                    if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1].show) == "undefined")
                    {
                        if (!elem.checked)
                        {
                            $(elem).trigger('click');
                        }
                    } else
                    {
                        if (elem.checked != this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[1].show)
                        {
                            $(elem).trigger('click');
                        }
                    }
                } else
                {
                    var inputs = this.formwraper.find("#tab_axes [axes='yAxis'][index='1'][chart_prop_key='" + key + "']");
                    inputs.each(function () {
                        formObj.fillinputs($(this), "yAxis", key, 0);
                    })
                }
            }
        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0])
        {
            if (key == "show")
            {
                var input = this.formwraper.find("#tab_axes [axes='xAxis'][index='0'][chart_prop_key='" + key + "']");
                var elem = document.getElementById(input.attr("id"));
                if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0].show) == "undefined")
                {
                    if (!elem.checked)
                    {
                        $(elem).trigger('click');
                    }
                } else
                {
                    if (elem.checked != this.dashJSON[this.row]["widgets"][this.index].tmpoptions.xAxis[0].show)
                    {
                        $(elem).trigger('click');
                    }
                }                
            } else
            {
                var inputs = this.formwraper.find("#tab_axes [axes='xAxis'][index='0'][chart_prop_key='" + key + "']");
                inputs.each(function () {
                    formObj.fillinputs($(this), "xAxis", key, 0);
                })
            }
        }

        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title)
        {

            var inputs = this.formwraper.find("#tab_general [chart_prop_key='" + key + "']");
            inputs.each(function () {
                formObj.fillinputs($(this), "title", key);
            })


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
            if (elem.checked != dashJSON[this.row]["widgets"][this.index].transparent)
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
        if (input.parents("form").hasClass("edit-query"))
        {
            this.formwraper.find("#tab_general input").val("");

            var query = "metrics=" + this.formwraper.find("#metrics").val() + "&tags=" + this.formwraper.find("#tags").val() +
                    "&aggregator=" + this.formwraper.find("#aggregator").val() + "&downsample=" + this.formwraper.find("#down-sample").val();
            this.dashJSON[this.row]["widgets"][this.index].queryes = [];
            this.dashJSON[this.row]["widgets"][this.index].queryes.push(query);
        }

//        console.log("dfsdfsdfs");
        if (input.parents("form").hasClass("edit-axes"))
        {
            var key = input.attr("chart_prop_key");
            var index = input.attr("index");
            var axes = input.attr("axes");
            if (typeof (this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]) == "undefined")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index] = {type: 'value', axisLabel: {}};
            }

            if (key == "show")
            {
                var elem = document.getElementById(input.attr("id"));
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index].show = elem.checked;
//                console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index].show);
            } else if (key == "formatter")
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index].unit = input.val();
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index].axisLabel.formatter = input.val();
                // TODO div to koef
//                console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.yAxis[0]);
            } else
            {
                if (input.val() == "")
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index][key];
                } else
                {
                    this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index][key] = input.val();
                    if ((key=="type")&&(input.val()=="category") )
                    {
                        if (typeof(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_sample"])=="undefined" )
                        {
                            this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_sample"] = "avg";
                        }
                        if (typeof(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_tags"])=="undefined" )
                        {
                            this.dashJSON[this.row]["widgets"][this.index].tmpoptions[axes][index]["m_tags"] = 0;
                        }                        
                    }
                }
            }
        }
        if (input.parents("form").hasClass("edit-dimensions"))
        {
            if (input.attr("id") == "dimensions_height")
            {
                var points = ""
                if ($.isNumeric(input.val()))
                {
                    points = "px";
                }
                if (input.val() == "")
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].height;
                }
                this.dashJSON[this.row]["widgets"][this.index].height = input.val() + points;
            }
            if (input.attr("id") == "dimensions_span")
            {
                this.dashJSON[this.row]["widgets"][this.index].size = input.val();
            }
            if (input.attr("id") == "dimensions_transparent")
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

            if (input.prop("tagName") == "INPUT" || "SELECT" || "DIV")
            {
                if (input.val() == "")
                {
                    var inputs = this.formwraper.find(".edit-title [chart_prop_key='" + key + "']");
                    if (inputs.length == 1)
                    {
                        delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key];
                    }
                    if (inputs.length > 1)
                    {
                        var empty = true;
                        inputs.each(function () {
                            empty = empty & ($(this).val() == "")
                        });
                        if (empty)
                        {
                            delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key];
                        }
                    }

//                    if (!this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key] || !input.val()) {

//                    }
                    if (input.parent().hasClass("cl_picer"))
                    {
                        inputs.each(function () {
                            $(this).parent().colorpicker('setValue', 'transparent');
                        })
//                        input.parent().colorpicker('setValue', 'transparent');
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

                if (input.attr("type") == "checkbox")
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

            if (input.prop("tagName") == "INPUT" || "SELECT" || "DIV")
            {
                if (input.val() == "")
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

                if (input.attr("type") == "checkbox")
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
//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key]);
        showsingleChart(this.row, this.index, this.dashJSON);
//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);  
//        this.chart.setOption(this.dashJSON[this.row]["widgets"][this.index].tmpoptions);
//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);
    }

    fillinputs(input, item, key, index = null)
    {

        if (input.parent().hasClass("cl_picer"))
        {
            input.parent().colorpicker('setValue', this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
//            console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]+" "+key);
        }

        if (typeof (input.attr("type")) == "undefined")
        {
            if (input.prop("tagName").toLowerCase() == "select")
            {
                if (index == null)
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
                } else
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][index][key]);
                }
            }
        } else
        {
            if (input.attr("type").toLowerCase() == "number")
            {
                if ($.isNumeric(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]))
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
                }
            }
            if (input.attr("type").toLowerCase() == "text")
            {
                if (index == null)
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
                } else
                {
                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][index][key]);
//                    input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][index][key]);
                }                
                
            }
            if (input.attr("type").toLowerCase() == "checkbox")
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
