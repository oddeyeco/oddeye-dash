/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global getParameterByName, pickerlabel, PicerOptionSet2, jsonmaker, editor, EditForm, colorPalette, EditForm */

class ChartEditForm extends EditForm {
//    tabcontent = {};

    constructor(chart, formwraper, row, index, dashJSON) {
//        this.chart = chart;
        super(formwraper, row, index, dashJSON);
        // Add castoms
        this.deflist["options.title.show"] = true;
        super.jspluginsinit();
    }

    gettabs()
    {
        return [{id: "general-tab", title: "General", contentid: "tab_general"},
            {id: "metrics-tab", title: "Metrics", contentid: "tab_metric"},
            {id: "axes-tab", title: "Axes", contentid: "tab_axes"},
            {id: "legend-tab", title: "Legend", contentid: "tab_legend"},
            {id: "display-tab", title: "Display", contentid: "tab_display"},
            {id: "time-tab", title: "Time Range", contentid: "tab_time"},
            {id: "json-tab", title: "Json", contentid: "tab_json"}
        ];
    }
    
    getdefvalue(path)
    {
        if (path === null)
        {
            return this.deflist;
        }
        return this.deflist[path];
    }    
    
    inittabcontent()
    {    
        super.inittabcontent();
//        this.tabcontent.tab_general.active = true;
        var edit_chart_title = {tag:"form", class:"form-horizontal form-label-left pull-left", id: "edit_chart_title", label: {show: true, text: 'Info', checker: {tag: "input", type: "checkbox", class: "js-switch-small", prop_key: "show", id: "title_show", name: "title_show", key_path: 'options.title.show', default: true}}};
        edit_chart_title.content = [{tag: "div", class: "form-group form-group-custom",
                content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Title", lfor: "title_text"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "text", id: "title_text", name: "title_text", key_path: 'options.title.text', default: ""},
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down", target:"title_subtitle", id: "button_title_subtitle"},
                    {tag: "div", class: "form-group form-group-custom", style: "display: none;", id: "title_subtitle",
                        content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Link", lfor: "title_link"},
                            {tag: "input", type: "text", class: "form-control title_input", prop_key: "link", id: "title_link", name: "title_link", key_path: 'options.title.link', default: ""},
                            {tag: "label", class: "control-label control-label-custom2", text: "Target", lfor: "title_target"},
                            {tag: "select", class: "form-control title_select", prop_key: "target", id: "title_target", name: "title_target", key_path: 'options.title.target', default: "", options: this.targetoptions}
                        ]
                    }

                ]},
            {tag: "div", class: "form-group form-group-custom",
                content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Description", lfor: "title_subtext"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "subtext", id: "title_subtext", name: "title_subtext", key_path: 'options.title.subtext', default: ""},
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down",target:"title_subdescription", id: "button_title_description"},
                    {tag: "div", class: "form-group form-group-custom", style: "display: none;", id: "title_subdescription",
                        content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Link", lfor: "title_sublink"},
                            {tag: "input", type: "text", class: "form-control title_input", prop_key: "sublink", id: "title_sublink", name: "title_sublink", key_path: 'options.title.sublink', default: ""},
                            {tag: "label", class: "control-label control-label-custom2", text: "Target", lfor: "title_subtarget"},
                            {tag: "select", class: "form-control title_select", prop_key: "subtarget", id: "title_subtarget", name: "title_subtarget", key_path: 'options.title.subtarget', default: "", options: this.targetoptions}
                        ]
                    }

                ]},
            {tag: "div", class: "raw", content: [
                    {tag: "div", id: "buttons_div", content: [
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target:"position_block", id: "button_title_position", text: "Positions", content: [{tag: "i", class: "fa fa-chevron-circle-down"}]},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target:"color_block", id: "button_title_color", text: "Colors", content: [{tag: "i", class: "fa fa-chevron-circle-down"}]},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target:"border_block", id: "button_title_border", text: "Border", content: [{tag: "i", class: "fa fa-chevron-circle-down"}]}
                        ]}
                ]},
            {tag: "div", id: "position_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "X", lfor: "title_x_position"},
                            {tag: "select", class: "form-control title_select", prop_key: "x", id: "title_x_position", name: "title_x_position", key_path: 'options.title.x', default: "", options: this.xpositionoptions},
                            {tag: "label", class: "control-label control-label-custom3 control_label_or", text: "OR"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "x", id: "title_x_position_text", name: "title_x_position_text", key_path: 'options.title.x', default: ""},
                            {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"},
                            {tag: "label", class: "control-label control-label_Y", text: "Y", lfor: "title_y_position"},
                            {tag: "select", class: "form-control title_select", prop_key: "y", id: "title_y_position", name: "title_y_position", key_path: 'options.title.y', default: "", options: this.ypositionoptions},
                            {tag: "label", class: "control-label control-label-custom3 control_label_or", text: "OR"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "y", id: "title_y_position_text", name: "title_y_position_text", key_path: 'options.title.y', default: ""},
                            {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                        ]
                    }]},
            {tag: "div", id: "color_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "Border", lfor: "title_border_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "title_border_color", name: "title_border_color", key_path: 'options.title.borderColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label-custom", text: "Background", lfor: "title_background_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "title_background_color", name: "title_background_color", key_path: 'options.title.backgroundColor', default: ""},
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
                                            {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "title_border_color", name: "title_border_color", key_path: 'options.title.borderColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label2", text: "Width", lfor: "title_border_width"},
                            {tag: "div", class: "titile_input_midle2", content: [
                                    {tag: "div", class: "input-group", content: [
                                            {tag: "input", type: "number", class: "form-control titile_input_midle", prop_key: "borderWidth", id: "title_border_width", name: "title_border_width", key_path: 'options.title.borderWidth', default: ""}
                                        ]}
                                ]}
                        ]
                    }]}
        ];

        this.tabcontent.tab_general.forms.splice(0, 0, edit_chart_title);
    }    
    
    gettabcontent(key)
    {        
        if (key === null)
        {
            return this.tabcontent;
        }
        return this.tabcontent[key];
    }
}
