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
    }
    chage() {
        var query = "metrics=" + this.formwraper.find("#metrics").val() + "&tags=" + this.formwraper.find("#tags").val() + 
                "&aggregator=" + this.formwraper.find("#aggregator").val() + "&downsample=" + this.formwraper.find("#down-sample").val();

        this.dashJSON[this.row]["widgets"][this.index].queryes = [];
        this.dashJSON[this.row]["widgets"][this.index].queryes.push(query);
        showsingleChart(this.row, this.index, this.dashJSON);
//        console.log(this.dashJSON[this.row]["widgets"][this.index].queryes);  
        this.chart.setOption(this.dashJSON[this.row]["widgets"][this.index].tmpoptions);
    }
}
