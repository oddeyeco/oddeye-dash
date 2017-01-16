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
            var input =this.formwraper.find("#tab_general [chart_prop_key='" + key + "']");
            if (input.parent().hasClass("cl_picer"))
            {
                input.parent().colorpicker('setValue',this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key]);
            }
            //TODO check Positions
            var field = this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title;
//                if($('#x_position_text').length>0)
//                {
//                   $('#x_position').removeAttr('value'); 
//                }else
//                {
//                    $('#x_position_text').removeAttr('value');;
//                }
//            
//                if($('#y_position_text').length>0)
//                {
//                   $('#y_position').removeAttr('value'); 
//                }else
//                {
//                    $('#y_position_text').removeAttr('value');;
//                }
            if(jQuery.hasData($('#x_position_text')))
            {
                delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title['x'];
            }
            if(jQuery.hasData($('#x_position')))
            {
                delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title['x_position_text'];
            }
            if(jQuery.hasData($('#y_position_text')))
            {
                delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title['y'];
            }
            if(jQuery.hasData($('#y_position')))
            {
                delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title['y_position_text'];
            }
            
//            console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);
            
            input.val(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key]);
            
            if($("imput[chart_prop_key='show']").attr('checked') == 'checked')
            {
                $("imput[chart_prop_key='show']").css('show: true');
            }else
            {
                $("imput[chart_prop_key='show']").css('show: false');
            }
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

        if (input.parents("form").hasClass("edit-title"))
        {
            var key = input.attr("chart_prop_key");
//            console.log(key);
            if (input.prop("tagName") == "INPUT" || "SELECT" || "CHECKBOX" || "DIV")
            {
//                console.log(key);
//                console.log(input.val());
                if (input.val() == "")
                {
                    delete this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key];
                    if (input.parent().hasClass("cl_picer"))
                    {
                        input.parent().colorpicker('setValue','transparent');
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
//                       console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);
                }

            }
            console.log(input.attr('checked'));
            if(input.attr('checked') == 'checked')
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key] = "show";
            }else
            {
                this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title[key] = "hide";
            }

        }

//        console.log(this.dashJSON[this.row]);


        showsingleChart(this.row, this.index, this.dashJSON);
//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);  
//        this.chart.setOption(this.dashJSON[this.row]["widgets"][this.index].tmpoptions);
//        console.log(this.dashJSON[this.row]["widgets"][this.index].tmpoptions.title);
    }
}
