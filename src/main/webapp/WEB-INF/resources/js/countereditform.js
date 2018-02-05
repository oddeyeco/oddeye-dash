/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


class CounterEditForm extends EditForm {
    inittabcontent()
    {
        super.inittabcontent();
        var edit_chart_title = {tag: "form", class: "form-horizontal form-label-left pull-left", id: "edit_chart_title", label: {show: true, text: 'Info', checker: {tag: "input", type: "checkbox", class: "js-switch-small", prop_key: "show", id: "title_show", name: "title_show", key_path: 'title.show', default: true}}};
        edit_chart_title.content = [{tag: "div", class: "form-group form-group-custom",
                content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Title", lfor: "title_text"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "text", id: "title_text", name: "title_text", key_path: 'title.text', default: ""},
                    {tag: "label", class: "control-label control-label-custom2", text: "Font Size ", lfor: "title_font"},
                    {tag: "input", type: "number", class: "form-control title_input_large general_font", prop_key: "text", id: "title_font", name: "title_font", key_path: 'title.textStyle.fontSize', default: "18"},
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down", target: "title_subtitle", id: "button_title_subtitle", actions: {click: this.opencontent}},
                    {tag: "div", class: "form-group form-group-custom", style: "display: none;", id: "title_subtitle",
                        content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Link", lfor: "title_link"},
                            {tag: "input", type: "text", class: "form-control title_input", prop_key: "link", id: "title_link", name: "title_link", key_path: 'title.link', default: ""},
                            {tag: "label", class: "control-label control-label-custom2", text: "Target", lfor: "title_target"},
                            {tag: "select", class: "form-control title_select_gen", prop_key: "target", id: "title_target", name: "title_target", key_path: 'title.target', default: "", options: this.targetoptions}
                        ]
                    }

                ]},
            {tag: "div", class: "form-group form-group-custom",
                content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Description", lfor: "title_subtext"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "subtext", id: "title_subtext", name: "title_subtext", key_path: 'title.subtext', default: ""},
                    {tag: "label", class: "control-label control-label-custom2", text: "Font Size ", lfor: "description_font"},
                    {tag: "input", type: "number", class: "form-control title_input_large general_font", prop_key: "text", id: "description_font", name: "description_font", key_path: 'title.subtextStyle.fontSize', default: "12"},
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down", target: "title_subdescription", id: "button_title_description", actions: {click: this.opencontent}},
                    {tag: "div", class: "form-group form-group-custom", style: "display: none;", id: "title_subdescription",
                        content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Link", lfor: "title_sublink"},
                            {tag: "input", type: "text", class: "form-control title_input", prop_key: "sublink", id: "title_sublink", name: "title_sublink", key_path: 'title.sublink', default: ""},
                            {tag: "label", class: "control-label control-label-custom2", text: "Target", lfor: "title_subtarget"},
                            {tag: "select", class: "form-control title_select_gen ", prop_key: "subtarget", id: "title_subtarget", name: "title_subtarget", key_path: 'title.subtarget', default: "", options: this.targetoptions}
                        ]
                    }

                ]},
            {tag: "div", class: "raw", content: [
                    {tag: "div", id: "buttons_div", content: [
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "position_block", id: "button_title_position", text: "Positions", content: [{tag: "i", class: "fa fa-chevron-circle-down"}], actions: {click: this.opencontent}},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "color_block", id: "button_title_color", text: "Colors", content: [{tag: "i", class: "fa fa-chevron-circle-down"}], actions: {click: this.opencontent}},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "border_block", id: "button_title_border", text: "Border", content: [{tag: "i", class: "fa fa-chevron-circle-down"}], actions: {click: this.opencontent}}
                        ]}
                ]},
            {tag: "div", id: "position_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "X", lfor: "title_x_position"},
                            {tag: "select", class: "form-control title_select", prop_key: "x", id: "title_x_position", name: "title_x_position", key_path: 'title.x', default: "", options: this.xpositionoptions},
                            {tag: "label", class: "control-label control-label-custom3 control_label_or", text: "OR"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "x", id: "title_x_position_text", name: "title_x_position_text", key_path: 'title.x', default: ""},
                            {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"},
                            {tag: "label", class: "control-label control-label_Y", text: "Y", lfor: "title_y_position"},
                            {tag: "select", class: "form-control title_select", prop_key: "y", id: "title_y_position", name: "title_y_position", key_path: 'title.y', default: "", options: this.ypositionoptions},
                            {tag: "label", class: "control-label control-label-custom3 control_label_or", text: "OR"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "y", id: "title_y_position_text", name: "title_y_position_text", key_path: 'title.y', default: ""},
                            {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                        ]
                    }]},
            {tag: "div", id: "color_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", id: "title_color", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Border", lfor: "title_border_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "title_border_color", name: "title_border_color", key_path: 'title.borderColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label-custom", text: "Background", lfor: "title_background_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "title_background_color", name: "title_background_color", key_path: 'title.backgroundColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]
                    },

                    {tag: "div", class: "form-group form-group-custom ", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Title", lfor: "title_name_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "TitleColor", id: "title_name_color", name: "title_name_color", key_path: 'title.textStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label-custom", text: "Description", lfor: "title_description_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "descriptioncolor", id: "title_description_color", name: "title_description_color", key_path: 'title.subtextStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]
                    }]},

            {tag: "div", id: "border_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Color", lfor: "title_border_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "title_border_color", name: "title_border_color", key_path: 'title.borderColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label2", text: "Width", lfor: "title_border_width"},
                            {tag: "div", class: "titile_input_midle2", content: [
                                    {tag: "div", class: "input-group", content: [
                                            {tag: "input", type: "number", class: "form-control titile_input_midle", prop_key: "borderWidth", id: "title_border_width", name: "title_border_width", key_path: 'title.borderWidth', default: ""}
                                        ]}
                                ]}
                        ]
                    }]}
        ];

        this.tabcontent.tab_general.forms.splice(0, 0, edit_chart_title);
        this.tabcontent.tab_general.active = true;
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