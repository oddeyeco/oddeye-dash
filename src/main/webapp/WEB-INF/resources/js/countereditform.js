/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


class CounterEditForm extends EditForm {
    inittabcontent()
    {
        super.inittabcontent();
        this.tabcontent.tab_general.forms[0].content[1] = {tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label control-label-custom", text: "Colum span", lfor: "dimensions_span"},
                {tag: "select", class: "form-control dimensions_input", prop_key: "col", id: "dimensions_col", name: "dimensions_col", key_path: 'col', default: "", options: this.spanoptions}
            ]};

        this.tabcontent.tab_display = {};//suren

        var edit_display = {tag: "div", class: 'forms', id: "edit_display"};
        edit_display.content = [{tag: "div", class: "form-horizontal form-label-left edit-display pull-left counter-colors",
                content: [

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label", text: "Background colors"},
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Title", lfor: "titlebackground-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "titlebackground-color", id: "titlebackground-color", name: "titlebackground-color", key_path: 'title.textStyle.background-color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Subtitle", lfor: "subtextbackground-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "subtextbackground-color", id: "subtextbackground-color", name: "subtextbackground-color", key_path: 'title.subtextStyle.background-color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Value", lfor: "valuebackground-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "valuebackground-color", id: "valuebackground-color", name: "valuebackground-color", key_path: 'valueStyle.background-color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Unit", lfor: "unitbackground-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "unitbackground-color", id: "unitbackground-color", name: "unitbackground-color", key_path: 'unitStyle.background-color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Box", lfor: "background-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "background-color", id: "background-color", name: "background-color", key_path: 'style.background-color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]}
                ]},
            //**********************************
            {tag: "div", class: "form-horizontal form-label-left edit-display pull-left counter-colors",
                content: [

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label", text: "Font colors"}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Title", lfor: "titlefont-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "titlefont-color", id: "titlefont-color", name: "titlefont-color", key_path: 'title.textStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Subtitle", lfor: "subtextfont-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "subtextfont-color", id: "subtextfont-color", name: "subtextfont-color", key_path: 'title.subtextStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Value", lfor: "valuefont-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "valuefont-color", id: "valuefont-color", name: "valuefont-color", key_path: 'valueStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Unit", lfor: "unitfont-color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "unitfont-color", id: "unitfont-color", name: "unitfont-color", key_path: 'unitStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]}
                ]},
            //*************************************
            {tag: "div", class: "form-horizontal form-label-left edit-display pull-left",
                content: [

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label", text: "Font size"}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Title", lfor: "titlefont-font-size"},

                            {tag: "input", type: "number", class: "form-control general_font", prop_key: "titlefont-font-size", id: "titlefont-font-size", name: "titlefont-font-size", key_path: 'title.textStyle.font-size', default: "24"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Subtitle", lfor: "subtextfont-font-size"},

                            {tag: "input", type: "number", class: "form-control general_font", prop_key: "subtextfont-font-size", id: "subtextfont-font-size", name: "subtextfont-font-size", key_path: 'title.subtextStyle.font-size', default: "12"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Value", lfor: "valuefont-font-size"},

                            {tag: "input", type: "number", class: "form-control general_font", prop_key: "valuefont-font-size", id: "valuefont-font-size", name: "valuefont-font-size", key_path: 'valueStyle.font-size', default: "50"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Unit", lfor: "unitfont-font-size"},

                            {tag: "input", type: "number", class: "form-control general_font", prop_key: "unitfont-font-size", id: "unitfont-font-size", name: "unitfont-font-size", key_path: 'unitStyle.font-size', default: "30"}
                        ]}
                ]}
        ];


//                    {tag: "div", class: "form-group form-group-custom", content: [
//                            {tag: "label", class: "control-label control-label-custom-legend", text: "Unit", lfor: "axes_unit_y"},
//                            {tag: "select", class: "form-control axes_select", prop_key: "unit", id: "{index}_axes_unit_y", name: "axes_unit_y", key_path: 'unit', default: "", options: this.units}
//                        ]},

        this.tabcontent.tab_display.forms = [edit_display];//suren            
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content[4].content.push({tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label control-label-custom-legend", text: "Unit", lfor: "axes_unit_y"},
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
        return [{id: "general-tab", title: "General", contentid: "tab_general"},
            {id: "metrics-tab", title: "Metrics", contentid: "tab_metric"},
            {id: "display-tab", title: "Display", contentid: "tab_display"},
            {id: "time-tab", title: "Time Range", contentid: "tab_time"},
            {id: "json-tab", title: "Json", contentid: "tab_json"}
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