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
//        console.log(this.row);
//        console.log(this.index);
        this.dashJSON = dashJSON;
        //TODO For many qyery
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

        this.formwraper.find("#tab_general input").val("");
        var key;
        for (key in this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title)
        {
            var inputs = this.formwraper.find("#tab_general [chart_prop_key='" + key + "']");
            var formObj = this;
            inputs.each(function () {
                formObj.fillinputs($(this),"title", key);
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
                formObj.fillinputs($(this),"legend", key);
            })

        }

//        if (document.getElementById("legend_show").checked != dashJSON[this.row]["widgets"][this.index].tmpoptions.legend.show)
//        {
//            document.getElementById("legend_show").click();
//        }

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

//        console.log($(this.dashJSON));
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
//            console.log(input.attr("id"));
        }


        if (input.parents("form").hasClass("edit-title"))
        {
            var key = input.attr("chart_prop_key");

            if (input.prop("tagName") == "INPUT" || "SELECT" || "DIV")
            {

//                console.log(key);
//                console.log(input.val());
//                console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key]);
                if (input.val() == "")
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key];
                    if (input.parent().hasClass("cl_picer"))
                    {
                        input.parent().colorpicker('setValue', 'transparent');
                    }
                } else
                {
//                    console.log($.isNumeric(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key]));
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
                    delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key];
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


//                    console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions);
                }
            }
        }

//        console.log(input.attr("type"));

//        this.dashJSON[this.row]["widgets"][this.index].transparent = input.val();

//        console.log(this.dashJSON[this.row]["widgets"][this.index]);


        showsingleChart(this.row, this.index, this.dashJSON);
//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);  
//        this.chart.setOption(this.dashJSON[this.row]["widgets"][this.index].tmpoptions);
//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);
    }

    fillinputs(input,item, key)
    {

        if (input.parent().hasClass("cl_picer"))
        {
            input.parent().colorpicker('setValue', this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
        }
//        console.log(input.attr("type"));
        //TODO check Positions
        if (typeof (input.attr("type")) == "undefined")
        {
            if (input.prop("tagName").toLowerCase() == "select")
            {
                input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
            }
        } else
        {
            if (input.attr("type").toLowerCase() == "number")
            {
                input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
            }
            if (input.attr("type").toLowerCase() == "text")
            {
                input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions[item][key]);
            }
            if (input.attr("type").toLowerCase() == "checkbox")
            {
//                console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key]);
                var elem = document.getElementById(input.attr("id"));

                console.log(input.attr("id"));

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

//                if (this.dashJSON[this.row]["widgets"][this.index].tmpoptions.legend[key])
//                {
//                    if (!elem.checked)
//                    {
//                        $(elem).trigger('click');
//                    }
//
//                } else
//                {
//                    if (elem.checked)
//                    {
//                        $(elem).trigger('click');
//                    }
//                }

            }
        }
    }
}
