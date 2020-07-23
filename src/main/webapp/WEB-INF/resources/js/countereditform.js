/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global locale */

class CounterEditForm extends EditForm {
    inittabcontent()
    {
        super.inittabcontent();

        var dimensions_columnSpan = {tag: "div", class: "form_main_block depthShadowLightHover mb-0 p-2", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: locale["editform.span"], lfor: "dimensions_span"},
                            {tag: "select", class: "form-control dimensions_input", prop_key: "size", id: "dimensions_span", name: "dimensions_span", key_path: 'size', default: "", options: this.spanoptions}
                        ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["countereditform.columnSpan"], lfor: "dimensions_span"},
                                    {tag: "select", class: "form-control dimensions_input", prop_key: "col", id: "dimensions_col", name: "dimensions_col", key_path: 'col', default: "", options: this.spanoptions}
                                ]}
                    ]};            
        
        this.tabcontent.tab_general.forms[0].content.splice(0, 1, dimensions_columnSpan);        
        
        var edit_chart_title = {tag: "form", class: "form-horizontal form-label-left pull-left", id: "edit_chart_title", label: {show: true, text: locale["info"]}};
        edit_chart_title.content = [{tag: "div", class: "form_main_block depthShadowLightHover p-2", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label", text: locale["title"], lfor: "title_text"},
                            {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "text", id: "title_text", name: "title_text", key_path: 'title.text', default: ""}
                        ]}
                ]}
        ];

        this.tabcontent.tab_general.forms.splice(0, 0, edit_chart_title);

        this.tabcontent.tab_display = {};//suren

        var edit_display = {tag: "div", class: 'forms counterDisplay', id: "edit_display"};
        edit_display.content = [{tag: "div", class: "form-horizontal form-label-left edit-display float-left counter-colors",
                content: [
                    {tag: "div", class: "form-group form-group-custom text-left h5", content: [
                            {tag: "label", class: "control-label", text: locale["countereditform.backgroundColors"]}
                        ]},
                    {tag: "div", class: "form_main_block depthShadowLightHover p-2", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120-left", text: locale["editform.alias"], lfor: "titlebackground-color"},
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "titlebackground-color", id: "titlebackground-color", name: "titlebackground-color", key_path: 'title.textStyle.background-color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120-left", text: locale["editform.aliasSecondary"], lfor: "subtextbackground-color"},
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "subtextbackground-color", id: "subtextbackground-color", name: "subtextbackground-color", key_path: 'title.subtextStyle.background-color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120-left", text: locale["editchartform.value"], lfor: "valuebackground-color"},
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "valuebackground-color", id: "valuebackground-color", name: "valuebackground-color", key_path: 'valueStyle.background-color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120-left", text: locale["editchartform.unit"], lfor: "unitbackground-color"},
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "unitbackground-color", id: "unitbackground-color", name: "unitbackground-color", key_path: 'unitStyle.background-color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120-left", text: locale["countereditform.box"], lfor: "background-color"},
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "background-color", id: "background-color", name: "background-color", key_path: 'style.background-color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]}
                        ]}

                ]},
            {tag: "div", class: "form-horizontal form-label-left edit-display float-left counter-colors",
                content: [{tag: "div", class: "form-group form-group-custom text-left h5", content: [
                            {tag: "label", class: "control-label", text: locale["countereditform.fontColors"]}
                        ]},
                    {tag: "div", class: "form_main_block depthShadowLightHover p-2", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "titlefont-color", id: "titlefont-color", name: "titlefont-color", key_path: 'title.textStyle.color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "subtextfont-color", id: "subtextfont-color", name: "subtextfont-color", key_path: 'title.subtextStyle.color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "valuefont-color", id: "valuefont-color", name: "valuefont-color", key_path: 'valueStyle.color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "div", class: "title_input_midle", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "unitfont-color", id: "unitfont-color", name: "unitfont-color", key_path: 'unitStyle.color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i", class: "fas fa-fill-drip"}]}
                                                ]}
                                        ]}
                                ]}
                        ]}
                ]},
            {tag: "div", class: "form-horizontal form-label-left edit-display float-left",
                content: [{tag: "div", class: "form-group form-group-custom text-left h5", content: [
                            {tag: "label", class: "control-label", text: locale["countereditform.fontSize"]}
                        ]},
                    {tag: "div", class: "form_main_block depthShadowLightHover p-2", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "input", type: "number", class: "form-control general_font", prop_key: "titlefont-font-size", id: "titlefont-font-size", name: "titlefont-font-size", key_path: 'title.textStyle.font-size', default: "24"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "input", type: "number", class: "form-control general_font", prop_key: "subtextfont-font-size", id: "subtextfont-font-size", name: "subtextfont-font-size", key_path: 'title.subtextStyle.font-size', default: "12"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "input", type: "number", class: "form-control general_font", prop_key: "valuefont-font-size", id: "valuefont-font-size", name: "valuefont-font-size", key_path: 'valueStyle.font-size', default: "50"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "input", type: "number", class: "form-control general_font", prop_key: "unitfont-font-size", id: "unitfont-font-size", name: "unitfont-font-size", key_path: 'unitStyle.font-size', default: "30"}
                                ]}
                        ]}
                ]}
        ];
        
        this.tabcontent.tab_display.forms = [edit_display];//suren            
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content[4].content.push({tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label", text: locale["editchartform.unit"], lfor: "axes_unit_y"},
                {tag: "select", class: "form-control axes_select", prop_key: "unit", id: "{index}_axes_unit_y", name: "axes_unit_y", key_path: 'unit', default: "", options: this.units}
            ]}, );
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
//            {id: "time-tab", title: locale["editchartform.timeRange"], contentid: "tab_time"},
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