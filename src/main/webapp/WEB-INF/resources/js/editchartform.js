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
        var edit_chart_title = {tag: "form", class: "form-horizontal form-label-left pull-left", id: "edit_chart_title", label: {show: true, text: 'Info', checker: {tag: "input", type: "checkbox", class: "js-switch-small", prop_key: "show", id: "title_show", name: "title_show", key_path: 'options.title.show', default: true}}};
        edit_chart_title.content = [{tag: "div", class: "form-group form-group-custom",
                content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Title", lfor: "title_text"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "text", id: "title_text", name: "title_text", key_path: 'options.title.text', default: ""},
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down", target: "title_subtitle", id: "button_title_subtitle"},
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
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down", target: "title_subdescription", id: "button_title_description"},
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
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "position_block", id: "button_title_position", text: "Positions", content: [{tag: "i", class: "fa fa-chevron-circle-down"}]},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "color_block", id: "button_title_color", text: "Colors", content: [{tag: "i", class: "fa fa-chevron-circle-down"}]},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "border_block", id: "button_title_border", text: "Border", content: [{tag: "i", class: "fa fa-chevron-circle-down"}]}
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

        this.tabcontent.tab_axes = {};
        var edit_axes_y = {tag: "div", class: 'form_main_block pull-left', id: "edit_y", label: {show: true, text: 'Y axes'}};
        var current = this;

        var axes_template = [{tag: "form", class: "form-horizontal form-label-left edit-axes", id: "{index}_yaxes", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Show", lfor: "axes_show_y"},
                            {tag: "input", type: "checkbox", class: "js-switch-small axes_show_y", prop_key: "show", id: "{index}_axes_show_y", name: "axes_show_y", key_path: 'show', default: true}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Unit", lfor: "axes_unit_y"},
                            {tag: "select", class: "form-control axes_select", prop_key: "unit", id: "{index}_axes_unit_y", name: "axes_unit_y", key_path: 'unit', default: "", options: this.units}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Y-Min", lfor: "axes_min_y"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "min", id: "{index}_axes_min_y", name: "axes_min_y", key_path: 'min', default: ""},
                            {tag: "label", class: "control-label control-label-custom-axes", text: "Y-Max", lfor: "axes_max_y"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "max", id: "{index}_axes_max_y", name: "axes_max_y", key_path: 'max', default: ""}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Label", lfor: "axes_name_y"},
                            {tag: "input", type: "text", class: "form-control axes_select", prop_key: "name", id: "{index}_axes_name_y", name: "axes_name_y", key_path: 'name', default: ""}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Position", lfor: "axes_position_y"},
                            {tag: "select", class: "form-control axes_select", prop_key: "position", id: "{index}_axes_position_y", name: "axes_position_y", key_path: 'position', default: "", options: this.ypos}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Split Number", lfor: "axes_splitNumber_y"},
                            {tag: "input", type: "number", class: "form-control axes_select", prop_key: "splitNumber", id: "{index}_splitNumber_y", name: "splitNumber_y", key_path: 'splitNumber', default: ""}
                        ]},
                    {tag: "div", class: "btn btn-success dublicateq btn-xs", id: "{index}_dublicateq",
                        text: "Dublicate",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON[current.row]["widgets"][current.index].options.yAxis[curindex]);
                                current.dashJSON[current.row]["widgets"][current.index].options.yAxis.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON[current.row]["widgets"][current.index]);
                                current.change($(this));
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-danger removeq btn-xs", id: "{index}_removeq",
                        text: "Remove",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON[current.row]["widgets"][current.index].options.yAxis.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON[current.row]["widgets"][current.index]);
                                current.change($(this));
                            }
                        }
                    }
                ]}];
        edit_axes_y.content = [{tag: "div", class: "form_main_block", content: [{tag: "button", class: "btn btn-success Addq btn-xs",
                        text: "Add",
                        id: "addq",
                        key_path: "options.yAxis",
                        template: axes_template,
                        actions: {click: function () {
                                current.dashJSON[current.row]["widgets"][current.index].options.yAxis.push({});
                                var qindex = current.dashJSON[current.row]["widgets"][current.index].options.yAxis.length - 1;
                                var contener = $(this).parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON[current.row]["widgets"][current.index]);

                            }
                        }
                    }
                ]}]
                ;

        var edit_axes_x = {tag: "section", class: 'form_main_block pull-left', id: "edit_x", label: {show: true, text: 'X axes'}};
        var current = this;

        var axes_template = [{tag: "form", class: "form-horizontal form-label-left edit-axes", id: "{index}_xaxes", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Show", lfor: "axes_show_x"},
                            {tag: "input", type: "checkbox", class: "js-switch-small axes_show_x", prop_key: "show", id: "{index}_axes_show_x", name: "axes_show_x", key_path: 'show', default: true}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Label", lfor: "axes_name_x"},
                            {tag: "input", type: "text", class: "form-control axes_select", prop_key: "name", id: "{index}_axes_name_x", name: "axes_name_x", key_path: 'name', default: ""}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Position", lfor: "axes_position_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "position", id: "{index}_axes_position_x", name: "axes_position_x", key_path: 'position', default: "", options: this.xpos}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Split Number", lfor: "axes_splitNumber_x"},
                            {tag: "input", type: "number", class: "form-control axes_select", prop_key: "splitNumber", id: "{index}_splitNumber_x", name: "splitNumber_x", key_path: 'splitNumber', default: ""}
                        ]},
                    {tag: "div", class: "btn btn-success dublicateq btn-xs", id: "{index}_dublicateq",
                        text: "Dublicate",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON[current.row]["widgets"][current.index].options.xAxis[curindex]);
                                current.dashJSON[current.row]["widgets"][current.index].options.xAxis.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON[current.row]["widgets"][current.index]);
                                current.change($(this));
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-danger removeq btn-xs", id: "{index}_removeq",
                        text: "Remove",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON[current.row]["widgets"][current.index].options.xAxis.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON[current.row]["widgets"][current.index]);
                                current.change($(this));
                            }
                        }
                    }
                ]}];
        edit_axes_x.content = [{tag: "div", class: "form_main_block", content: [{tag: "button", class: "btn btn-success Addq btn-xs",
                        text: "Add",
                        id: "addq",
                        key_path: "options.xAxis",
                        template: axes_template,
                        actions: {click: function () {
                                current.dashJSON[current.row]["widgets"][current.index].options.xAxis.push({});
                                var qindex = current.dashJSON[current.row]["widgets"][current.index].options.xAxis.length - 1;
                                var contener = $(this).parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON[current.row]["widgets"][current.index]);

                            }
                        }
                    }
                ]}]
                ;
        this.tabcontent.tab_axes.forms = [edit_axes_y, edit_axes_x];

        this.tabcontent.tab_legend = {};
        this.tabcontent.tab_legend.active = true;
//        var edit_legend = {tag: "div", class: 'form-horizontal form-label-left edit-legend pull-left', id: "edit_legend", label: {show: true, text: 'Legend'}};

        var edit_legend = {tag: "div", class: "form-horizontal form-label-left edit-legend pull-left", id: "edit_legend", label: {show: true, text: 'Legend', checker: {tag: "input", type: "checkbox", class: "js-switch-small", prop_key: "show", id: "legend_show", name: "legend_show", key_path: 'options.legend.show', default: true}}};
        edit_legend.content = [{tag: "div", class: "legendform", content: [
                    {tag: "div", class: "form_main_block pull-left", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: "Orient", lfor: "legend_orient"},
                                    {tag: "select", class: "form-control title_select", prop_key: "orient", id: "legend_orient", name: "legend_orient", key_path: 'options.legend.orient', default: "", options: this.legendOrient}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: "Select Mode", lfor: "legend_select_mode"},
                                    {tag: "select", class: "form-control title_select", prop_key: "selectedMode", id: "legend_select_mode", name: "legend_select_mode", key_path: 'options.legend.selectedMode', default: "", options: this.legendMode}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: "Background", lfor: "legend_background_color"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "legend_background_color", name: "legend_background_color", key_path: 'options.legend.backgroundColor', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: "Text Color", lfor: "legend_text_color"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "color", id: "legend_text_color", name: "legend_text_color", key_path: 'options.legend.textStyle.color', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                                ]}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", class: "form_main_block pull-left", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: "X", lfor: "legend_x_position"},
                                    {tag: "select", class: "form-control title_select", prop_key: "x", id: "legend_x_position", name: "legend_x_position", key_path: 'options.legend.x', default: "", options: this.xpositionoptions},
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: "OR"},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "x", id: "legend_x_position_text", name: "legend_x_position_text", key_path: 'options.legend.x', default: ""},
                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: "Y", lfor: "legend_y_position"},
                                    {tag: "select", class: "form-control title_select", prop_key: "y", id: "legend_y_position", name: "legend_y_position", key_path: 'options.legend.y', default: "", options: this.ypositionoptions},
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: "OR"},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "y", id: "legend_y_position_text", name: "legend_y_position_text", key_path: 'options.legend.y', default: ""},
                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: "Shape Width", lfor: "legend_shape_width"},
                                    {tag: "input", type: "number", class: "form-control title_select", prop_key: "itemWidth", id: "legend_shape_width", name: "legend_shape_width", key_path: 'options.legend.itemWidth', default: ""},
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: "Height", lfor: "legend_shape_height"},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "itemHeight", id: "legend_shape_height", name: "legend_shape_height", key_path: 'options.legend.itemHeight', default: ""},
                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: "Border Color", lfor: "legend_border_color"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "legend_border_color", name: "legend_border_color", key_path: 'options.legend.borderColor', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                                ]}
                                        ]},
                                    {tag: "label", class: "control-label control-label-custom-legend3", text: "Width", lfor: "legend_border_width"},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "borderWidth", id: "legend_border_width", name: "legend_border_width", key_path: 'options.legend.borderWidth', default: ""},
                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}                                    
                                ]}
                        ]}
                ]}];


        this.tabcontent.tab_legend.forms = [edit_legend];

    }

    gettabcontent(key)
    {
        if (key === null)
        {
            return this.tabcontent;
        }
        return this.tabcontent[key];
    }
    get ypos()
    {
        return {"": "&nbsp", left: "Left", right: "Right"};
    }

    get xpos()
    {
        return {"": "&nbsp", bottom: "Bottom", top: "Top"};
    }
    get legendOrient()
    {
        return {horizontal: "Horizontal", vertical: "Vertical"};
    }

    get legendMode()
    {
        return {single: "Single", multiple: "Multiple"};
    }

}
