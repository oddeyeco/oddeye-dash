/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global getParameterByName, pickerlabel, PicerOptionSet2, jsonmaker, editor, EditForm, colorPalette, EditForm */

class ChartEditForm extends EditForm {
//    tabcontent = {};

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
    ;
            constructor(chart, formwraper, row, index, dashJSON, aftermodifier = null) {
//        this.chart = chart;
        super(formwraper, row, index, dashJSON, aftermodifier);
        // Add castoms
        this.deflist["options.title.show"] = true;
        this.deflist["max"] = "";
        this.deflist["min"] = "";

        this.jspluginsinit();
    }
    jspluginsinit()
    {
        super.jspluginsinit();
        this.axesmode();
        this.typemode();
        this.initzoomtype();
        var current = this;
        this.formwraper.find('[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            if (e.delegateTarget.hash === "#tab_data_zoom")
            {
                var contener = $(e.delegateTarget.hash + ' .form_main_block[key_path="options.dataZoom"]');
                current.repaintdatazoom(contener, current.gettabcontent('tab_data_zoom').forms[0].content[0].content);
            }
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
    axesmode() {
        this.formwraper.find('[name=axes_mode_x]').each(function () {
            if ($(this).val() === 'category') {
                $(this).parent().parent().find('.only-Series').show();
            } else {
                $(this).parent().parent().find('.only-Series').hide();
            }
        });
    }

    typemode(duration = 0) {

        this.formwraper.find('[name=display_charttype]').each(function () {
            switch ($(this).val()) {
                case 'line':
                    $(this).parents('.edit-display').find('.custominputs .typeline').fadeIn(duration);
                    $(this).parents('.edit-display').find('.custominputs >:not(.typeline)').fadeOut(duration);
                    break

                case 'bar':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >.typebars').fadeIn(duration);
                    $(this).parents('.edit-display').find('.custominputs >:not(.typebars)').fadeOut(duration);
                    break
                case 'pie':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >.typepie').fadeIn(duration);
                    $(this).parents('.edit-display').find('.custominputs >:not(.typepie)').fadeOut(duration);
                    break
                case 'funnel':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >.typefunnel').fadeIn(duration);
                    $(this).parents('.edit-display').find('.custominputs >:not(.typefunnel)').fadeOut(duration);
                    break
//typefunnel
                default:
                    $(this).parents('.edit-display').find('.custominputs > .form-group').fadeOut(duration);
                    break
            }

        });
    }

    gettabs()
    {
        return [{id: "general-tab", title: "General", contentid: "tab_general"},
            {id: "metrics-tab", title: "Metrics", contentid: "tab_metric"},
            {id: "axes-tab", title: "Axes", contentid: "tab_axes"},
            {id: "data_zoom_tab", title: "Data Zoom", contentid: "tab_data_zoom"},
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
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "position_block", id: "button_title_position", text: "Positions", content: [{tag: "i", class: "fa fa-chevron-circle-down"}],actions: {click: this.opencontent}},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "color_block", id: "button_title_color", text: "Colors", content: [{tag: "i", class: "fa fa-chevron-circle-down"}],actions: {click: this.opencontent}},
                            {tag: "button", type: "button", class: "btn btn-primary btn-xs button_title_adv", target: "border_block", id: "button_title_border", text: "Border", content: [{tag: "i", class: "fa fa-chevron-circle-down"}],actions: {click: this.opencontent}}
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
                    {tag: "div", class: "btn btn-success dublicateq btn-xs", id: "{index}_dublicateaxesy",
                        text: "Dublicate",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON.rows[current.row].widgets[current.index].options.yAxis[curindex]);
                                current.dashJSON.rows[current.row].widgets[current.index].options.yAxis.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.change($(this));
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-danger removeq btn-xs", id: "{index}_removeaxesy",
                        text: "Remove",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON.rows[current.row].widgets[current.index].options.yAxis.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
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
                                if (!current.dashJSON.rows[current.row].widgets[current.index].options.yAxis)
                                {
                                    current.dashJSON.rows[current.row].widgets[current.index].options.yAxis = [];
                                }
                                current.dashJSON.rows[current.row].widgets[current.index].options.yAxis.push({});
                                var contener = $(this).parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);

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
//                    {tag: "div", class: "form-group form-group-custom", content: [
//                            {tag: "label", class: "control-label control-label-custom-legend", text: "Location", lfor: "axes_nameLocation_x"},
//                            {tag: "input", type: "text", class: "form-control axes_select", prop_key: "nameLocation", id: "{index}_axes_nameLocation_x", name: "axes_nameLocation_x", key_path: 'nameLocation', default: ""}
//                        ]},                    
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Position", lfor: "axes_position_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "position", id: "{index}_axes_position_x", name: "axes_position_x", key_path: 'position', default: "", options: this.xpos}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Scale", lfor: "axes_mode_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "type", id: "{index}_axes_mode_x", name: "axes_mode_x", key_path: 'type', default: "time", options: {time: "Time", category: "Series"}, actions: {"change": function () {
                                        if ($(this).val() === 'category') {
                                            $(this).parent().parent().find('.only-Series').fadeIn();
                                        } else {
                                            $(this).parent().parent().find('.only-Series').fadeOut();
                                        }
                                    }}}
                        ]},
                    {tag: "div", class: "form-group form-group-custom only-Series", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Value", lfor: "axes_value_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "m_sample", id: "{index}_axes_value_x", name: "axes_value_x", key_path: 'm_sample', default: "", options: {"avg": "Avg",
                                    "min": "Min",
                                    "max": "Max",
                                    "total": "Total",
                                    "count": "Count",
                                    "current": "Current",
                                    "product": "Product"}}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Split Number", lfor: "axes_splitNumber_x"},
                            {tag: "input", type: "number", class: "form-control axes_select", prop_key: "splitNumber", id: "{index}_splitNumber_x", name: "splitNumber_x", key_path: 'splitNumber', default: ""}
                        ]},
                    {tag: "div", class: "btn btn-success dublicateq btn-xs", id: "{index}_dublicateaxesx",
                        text: "Dublicate",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON.rows[current.row].widgets[current.index].options.xAxis[curindex]);
                                current.dashJSON.rows[current.row].widgets[current.index].options.xAxis.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.axesmode();
                                current.change($(this));
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-danger removeq btn-xs", id: "{index}_removeaxesx",
                        text: "Remove",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON.rows[current.row].widgets[current.index].options.xAxis.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.axesmode();
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
                                if (!current.dashJSON.rows[current.row].widgets[current.index].options.xAxis)
                                {
                                    current.dashJSON.rows[current.row].widgets[current.index].options.xAxis = [];
                                }
                                current.dashJSON.rows[current.row].widgets[current.index].options.xAxis.push({});
                                var contener = $(this).parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.axesmode();

                            }
                        }
                    }
                ]}]
                ;
//        this.tabcontent.tab_axes.active = true;
        this.tabcontent.tab_axes.forms = [edit_axes_y, edit_axes_x];

        this.tabcontent.tab_legend = {};
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

        //SURO
        this.tabcontent.tab_display = {};//suren

        var edit_display = {tag: "div", class: 'forms', id: "edit_display"};
        edit_display.content = [{tag: "div", class: "form-horizontal form-label-left edit-display pull-left",
                content: [
                    {tag: "div", class: "form_main_block pull-left", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: "Chart Type", lfor: "display_charttype"},
                                    {tag: "select", class: "form-control title_select", prop_key: "type", id: "display_charttype", name: "display_charttype", key_path: 'type', default: "", options: {"line": "Lines",
                                            "bar": "Bars",
                                            "pie": "Pie",
                                            "gauge": "Gauge",
                                            "funnel": "Funnel",
                                            "treemap": "Treemap"}, actions: {change: function () {
                                                current.typemode("slow");

                                            }
                                        }},
                                    {tag: "label", class: "control-label control-label-custom", text: "Color", lfor: "backgroundColor"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "backgroundColor", name: "backgroundColor", key_path: 'options.backgroundColor', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                                ]}
                                        ]}

                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: "Animation", lfor: "display_animation"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "animation", id: "display_animation", name: "display_animation", key_path: 'options.animation', default: true}
                                        ]},
                                    {tag: "label", class: "control-label control-label-custom120", text: "Contains label", lfor: "display_containLabel"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "containLabel", id: "display_containLabel", name: "display_containLabel", key_path: 'options.grid.containLabel', default: true}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: "Left", lfor: "padding_left"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_left", name: "padding_left", prop_key: "x", key_path: 'options.grid.x'},
                                    {tag: "label", class: "control-label control-label-custom", text: "Top", lfor: "padding_top"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_top", name: "padding_top", prop_key: "y", key_path: 'options.grid.y'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: " Right", lfor: "padding_right"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_right", name: "padding_right", prop_key: "x2", key_path: 'options.grid.x2'},
                                    {tag: "label", class: "control-label control-label-custom", text: "Bottom", lfor: "padding_bottom"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_bottom", name: "padding_bottom", prop_key: "y2", key_path: 'options.grid.y2'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: "Width", lfor: "padding_width"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_width", name: "padding_width", prop_key: "width", key_path: 'options.grid.width'},
                                    {tag: "label", class: "control-label control-label-custom", text: "Height", lfor: "padding_height"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_height", name: "padding_height", prop_key: "height", key_path: 'options.grid.height'}

                                ]}
                        ]},
                    {tag: "div", class: "form_main_block pull-left custominputs", content: [
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: "Points", lfor: "display_points"},
                                    {tag: "select", class: "form-control title_select", prop_key: "points", id: "display_points", name: "display_points", key_path: 'points', default: "none", options: {
                                            "none": "None",
                                            "circle": "Circle",
                                            "rectangle": "Rectangle",
                                            "triangle": "Triangle",
                                            "diamond": "Diamond",
                                            "emptyCircle": "Empty Circle",
                                            "emptyRectangle": "Empty Rectang",
                                            "emptyTriangle": "Empty Triangl",
                                            "emptyDiamond": "Empty Diamond"
                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: "Fill Area", lfor: "display_fillArea"},
                                    {tag: "select", class: "form-control title_select", prop_key: "fill", id: "display_fillArea", name: "display_fillArea", key_path: 'fill', default: "none", options: {"none": "None",
                                            "0.1": "1",
                                            "0.2": "2",
                                            "0.3": "3",
                                            "0.4": "4",
                                            "0.5": "5",
                                            "0.6": "6",
                                            "0.7": "7",
                                            "0.8": "8",
                                            "0.9": "9",
                                            "1.0": "10"
                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: "Staircase", lfor: "display_steped"},
                                    {tag: "select", class: "form-control title_select", prop_key: "step", id: "step", name: "display_steped", key_path: 'step', default: "", options: {
                                            "": "None",
                                            "start": "start",
                                            "middle": "middle",
                                            "end": "end"

                                        }}

                                ]}
                        ]},
                    {tag: "div", class: "form_main_block pull-left custominputs", content: [
                            {tag: "div", class: "form-group form-group-custom typeline typebars", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Label Position", lfor: "display_label_pos"},
                                    {tag: "select", class: "form-control axes_select", prop_key: "label.position", id: "display_label_pos", name: "display_label_pos", key_path: 'label.position', default: "inside", options: {
                                            'top': 'Top',
                                            'left': 'Left',
                                            'right': 'Right',
                                            'bottom': 'Bottom',
                                            'inside': 'Inside',
                                            'insideLeft': 'Inside Left',
                                            'insideRight': 'Inside Right',
                                            'insideTop': 'Inside Top',
                                            'insideBottom': 'Inside Bottom'

                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typefunnel ", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Label Position", lfor: "display_label_pos"},
                                    {tag: "select", class: "form-control axes_select", prop_key: "label.position", id: "display_label_pos", name: "display_label_pos", key_path: 'label.position', default: "outside", options: {
                                            'left': 'Left',
                                            'right': 'Right',
                                            'inside': 'Inside'

                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typepie ", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Label Position", lfor: "display_label_pos"},
                                    {tag: "select", class: "form-control axes_select", prop_key: "label.position", id: "display_label_pos", name: "display_label_pos", key_path: 'label.position', default: "outside", options: {
                                            'outside': 'Outside',
                                            'inner': 'Inner',
                                            'center': 'Center'

                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typepie typefunnel typeline typebars", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Label format", lfor: "display_label_parts", info: {text: "Use patterns {a1},{a2},{value},{p} replace part of the label for a Alias, Alias secondary, data, and percent respectively values"}},
                                    {tag: "input", type: "text", class: "form-control query_input display_label_parts", prop_key: "parts", id: "display_label_parts", name: "display_label_parts", key_path: 'label.parts', default: ""}
                                ]},

                            {tag: "div", class: "form-group form-group-custom typeline typebars", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Label show", lfor: "display_label"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "label.show", id: "display_label", name: "display_label", key_path: 'label.show', default: false}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom typepie typefunnel", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Label show", lfor: "display_label_2"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "label.show", id: "display_label_2", name: "display_label_2", key_path: 'label.show', default: true}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline typebars", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Stacked", lfor: "display_stacked"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "stacked", id: "display_stacked", name: "display_stacked", key_path: 'stacked', default: false}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: "Smooth", lfor: "display_smooth"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "smooth", id: "display_smooth", name: "display_smooth", key_path: 'smooth', default: true}
                                        ]}
                                ]}
                        ]}
                ]}
        ];

        this.tabcontent.tab_display.forms = [edit_display];//suren
        this.tabcontent.tab_data_zoom = {};//suren

        var data_zoom_template = [{tag: "form", class: "form-horizontal form-label-left edit-datazoom pull-left", id: "{index}_data_zoom", content: [
                    {tag: "div", class: "form-group form-group-custom forslider", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Show", lfor: "data_zoom_show"},
                            {tag: "input", type: "checkbox", class: "js-switch-small data_zoom_show", prop_key: "show", id: "{index}_data_zoom_show", name: "data_zoom_show", key_path: 'show', default: true}
                        ]},
                    {tag: "div", class: "form-group form-group-custom forinside", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Disabled", lfor: "data_zoom_disabled"},
                            {tag: "input", type: "checkbox", class: "js-switch-small data_zoom_disabled", prop_key: "disabled", id: "{index}_data_zoom_disabled", name: "data_zoom_disabled", key_path: 'disabled', default: false}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Start %", lfor: "datazoom_start"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "start", id: "{index}_datazoom_start", name: "datazoom_start", key_path: 'start', default: 0, min: 0, max: 100},
                            {tag: "label", class: "control-label control-label-custom-axes", text: "End %", lfor: "datazoom_end"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "end", id: "{index}_datazoom_end", name: "datazoom_end", key_path: 'end', default: 100, min: 0, max: 100}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "Type", lfor: "datazoom_type"},
                            {tag: "select", class: "form-control query_input", prop_key: "type", id: "datazoom_type", name: "datazoom_type", key_path: 'type', default: "slider",
                                options: {"slider": "Slider", "inside": "Inside"}
                                , actions: {"change": function () {
                                        if ($(this).val() === 'slider') {
                                            $(this).parent().parent().find('.forslider').fadeIn();
                                        } else {
                                            $(this).parent().parent().find('.forslider').fadeOut();
                                        }
                                        if ($(this).val() === 'inside') {
                                            $(this).parent().parent().find('.forinside').fadeIn();
                                        } else {
                                            $(this).parent().parent().find('.forinside').fadeOut();
                                        }
                                    }}
                            }

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "xAxisIndex", lfor: "data_zoom_xAxisIndex"},
                            {tag: "div", type: "choose_array", init_key_path: "options.xAxis", key_path: "xAxisIndex", style: "display:inline-block", id: "{index}_data_zoom_xAxisIndex", name: "data_zoom_xAxisIndex"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: "YAxisIndex", lfor: "data_zoom_yAxisIndex"},
                            {tag: "div", type: "choose_array", init_key_path: "options.yAxis", key_path: "yAxisIndex", style: "display:inline-block", id: "{index}_data_zoom_yAxisIndex", name: "data_zoom_yAxisIndex"}
                        ]},
                    {tag: "div", class: "btn btn-success dublicateq btn-xs pull-right", id: "{index}_dublicatedatazoom",
                        text: "Dublicate",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom[curindex]);
                                current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                current.repaintdatazoom(contener, edit_data_zoom.content[0].content);
                                current.change($(this));
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-danger removeq btn-xs pull-right", id: "{index}_removedatazoom",
                        text: "Remove",
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                current.repaintdatazoom(contener, edit_data_zoom.content[0].content);
                                current.change($(this));
                            }
                        }
                    }

                ]}];

        var edit_data_zoom = {tag: "div", class: 'forms', id: "edit_data_zoom"};
        edit_data_zoom.content = [{tag: "div", class: "form_main_block", content: [{tag: "button", class: "btn btn-success Addq btn-xs",
                        text: "Add",
                        id: "addq",
                        key_path: "options.dataZoom",
                        template: data_zoom_template,
                        actions: {click: function () {
                                if (!current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom)
                                {
                                    current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom = [];
                                }
                                current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom.push({});
                                var contener = $(this).parent();
                                current.repaintdatazoom(contener, edit_data_zoom.content[0].content);

                            }
                        }
                    }
                ]}];
        this.tabcontent.tab_data_zoom.forms = [edit_data_zoom];//suren
        var xfieds = {tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label control-label-custom-legend", text: "Axis Indexes"},
                {tag: "label", class: "control-label ", text: "X", lfor: "q_xAxisIndex"},
                {tag: "div", type: "choose_array", init_key_path: "options.xAxis", key_path: "xAxisIndex", style: "display:inline-block", id: "{index}_q_xAxisIndex", name: "q_xAxisIndex"},
                {tag: "label", class: "control-label", text: "Y", lfor: "q_yAxisIndex"},
                {tag: "div", type: "choose_array", init_key_path: "options.yAxis", key_path: "yAxisIndex", style: "display:inline-block", id: "{index}_q_yAxisIndex", name: "q_yAxisIndex"}
            ]};
        var inversef = {tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label control-label-custom-legend", text: "Inverse"},
                {tag: "input", type: "checkbox", class: "js-switch-small enable_inverse", prop_key: "inverse", id: "{index}_enable_inverse", name: "enable_inverse", key_path: 'info.inverse', default: false}
            ]};
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content.splice(this.tabcontent.tab_metric.forms[0].content[0].template[0].content.length - 2, 0, inversef);
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content.splice(this.tabcontent.tab_metric.forms[0].content[0].template[0].content.length - 2, 0, xfieds);

        this.tabcontent.tab_metric.active = true;

    }

    repaintdatazoom(contener, content) {
        contener.empty();
        this.drawcontent(content, contener, this.dashJSON.rows[this.row]["widgets"][this.index]);
        this.formwraper.find("input.flat").iCheck({checkboxClass: "icheckbox_flat-green", radioClass: "iradio_flat-green"});
        this.initzoomtype();
    }

    initzoomtype() {
        this.formwraper.find('[name=datazoom_type]').each(function () {
            if ($(this).val() === 'slider') {
                $(this).parent().parent().find('.forslider').show();
            } else {
                $(this).parent().parent().find('.forslider').hide();
            }

            if ($(this).val() === 'inside') {
                $(this).parent().parent().find('.forinside').show();
            } else {
                $(this).parent().parent().find('.forinside').hide();
            }
        });
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
