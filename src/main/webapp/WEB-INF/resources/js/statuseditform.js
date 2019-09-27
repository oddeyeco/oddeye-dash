/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global locale */

class StatusEditForm extends EditForm {
    makeMetricInput(metricinput, wraper, metricFilter)
    {
        var tags = "";
        wraper.parents("form").find(".tagspan .text").each(function () {
            tags = tags + $(this).text().replace("*", "(.*)") + ";";
        });

        var uri = cp + "/getSpecialMetricsNames?tags=" + tags + "&filter=" + encodeURIComponent("^(.*)$");
        $.getJSON(uri, null, function (data) {
            metricinput.autocomplete({
                lookup: data.data,
                minChars: 0
            });
        });
    }    
    
    inittabcontent()
    {
        super.inittabcontent();
        
//        this.tabcontent.tab_general.forms[0].content[2] = {tag: "div", class: "form-group form-group-custom", content: [
//                {tag: "label", class: "control-label control-label-custom120", text: locale["countereditform.columnSpan"], lfor: "dimensions_span"},
//                {tag: "select", class: "form-control dimensions_input", prop_key: "col", id: "dimensions_col", name: "dimensions_col", key_path: 'col', default: "", options: this.spanoptions}
//            ]};
        this.tabcontent.tab_general.forms[0].content[1] = {tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label control-label-custom120", text: locale["countereditform.columnSpan"], lfor: "dimensions_span"},
                {tag: "select", class: "form-control dimensions_input", prop_key: "col", id: "dimensions_col", name: "dimensions_col", key_path: 'col', default: "", options: this.spanoptions}
            ]};
        
        var edit_chart_title = {tag: "form", class: "form-horizontal form-label-left pull-left", id: "edit_chart_title", label: {show: true, text: locale["info"]}};
        edit_chart_title.content = [{tag: "div", class: "form-group form-group-custom", content: [
                    {tag: "label", class: "control-label control-label-custom", text: locale["title"], lfor: "title_text"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "text", id: "title_text", name: "title_text", key_path: 'title.text', default: ""}
                ]}];

        this.tabcontent.tab_general.forms.splice(0, 0, edit_chart_title);

        this.tabcontent.tab_display = {};

        var edit_display = {tag: "div", class: 'statusDisplay forms', id: "edit_display"};
        edit_display.content = [
            {tag: "div", class: "form-horizontal form-label-left edit-display pull-left counter-colors", content: [
                    {tag: "div", class: "form-group form-group-custom text-center h4", content: [
                            {tag: "label", class: "control-label", text: locale["countereditform.fontColors"]}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom120-left", text: locale["editform.alias"], lfor: "titlebackground-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "titlefont-color", id: "titlefont-color", name: "titlefont-color", key_path: 'title.textStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom120-left", text: locale["editform.aliasSecondary"], lfor: "subtextbackground-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "subtextfont-color", id: "subtextfont-color", name: "subtextfont-color", key_path: 'title.subtextStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}
                        ]}
                ]},
            //*************************************
            {tag: "div", class: "form-horizontal form-label-left edit-display pull-left",
                content: [
                    {tag: "div", class: "form-group form-group-custom text-left h4", content: [
                            {tag: "label", class: "control-label", text: locale["countereditform.fontSize"]}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "input", type: "number", class: "form-control general_font", prop_key: "titlefont-font-size", id: "titlefont-font-size", name: "titlefont-font-size", key_path: 'title.textStyle.font-size', default: "24"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "input", type: "number", class: "form-control general_font", prop_key: "subtextfont-font-size", id: "subtextfont-font-size", name: "subtextfont-font-size", key_path: 'title.subtextStyle.font-size', default: "12"}
                        ]}
                ]}
        ];

        this.tabcontent.tab_display.forms = [edit_display];
        
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content.shift();
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content.splice(3, 2);
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content[2].content.splice(0, 2);                       
        this.tabcontent.tab_metric.active = true;
    }

    constructor(formwraper, row, index, dashJSON, aftermodifier = null) {
        super(formwraper, row, index, dashJSON, aftermodifier);
        this.jspluginsinit();
    }

    gettabs()
    {
        return [{id: "general-tab", title: locale["editchartform.general"], contentid: "tab_general"},
            {id: "metrics-tab", title: locale["metrics"], contentid: "tab_metric"},
            {id: "display-tab", title: locale["display"], contentid: "tab_display"},
            {id: "json-tab", title: locale["editchartform.json"], contentid: "tab_json"}
        ];
    }

    jspluginsinit()
    {
        super.jspluginsinit();
        var current = this;

        this.formwraper.find('[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            if (e.delegateTarget.hash === "#tab_metric")
            {
                var contener = $(e.delegateTarget.hash + ' .form_main_block[key_path="q"]');
                current.repaintq(contener, current.gettabcontent('tab_metric').forms[0].content);
            }
            if (contener)
            {
                contener.find("select").select2({minimumResultsForSearch: 15});
                contener.find('[data-toggle="tooltip"]').tooltip();
            }

        });

    }
    opencontent() {
        var target = $(this).attr('target');
        var shevron = $(this);
        if ($(this).hasClass("button_title_adv"))
        {
            shevron = $(this).find('i');
        }
        $('#' + $(this).attr('target')).fadeToggle(500, function () {
            if ($('#' + target).css('display') === 'block')
            {
                shevron.removeClass("fa-chevron-circle-down");
                shevron.addClass("fa-chevron-circle-up");
            } else
            {
                shevron.removeClass("fa-chevron-circle-up");
                shevron.addClass("fa-chevron-circle-down");

            }
        });
    }
}