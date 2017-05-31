/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global PicerOptionSet2, getParameterByName, colorPalette, chartForm, jsonmaker, editor */

class EditForm {

    constructor(formwraper, row, index, dashJSON) {
        this.formwraper = formwraper;
        this.row = row;
        this.index = index;
        this.dashJSON = dashJSON;
        var checked = false;
        if (this.dashJSON[this.row]["widgets"][this.index].manual)
        {
            checked = this.dashJSON[this.row]["widgets"][this.index].manual;
        }

        this.formwraper.append('<div class="pull-right tabcontrol"><label class="control-label" >JSON Manual Edit:</label>' +
                '<div class="checkbox" style="display: inline-block">' +
                '<input type="checkbox" class="js-switch-small"  chart_prop_key="manual" id="manual" name="manual" /> ' +
                '</div> '
                );
        if (checked)
        {
            this.formwraper.find('#manual').attr("checked", checked);
        } else
        {
            this.formwraper.find('#manual').removeAttr("checked");
        }
        this.formwraper.append('<div role="tabpanel" id="tabpanel">');
        this.formwraper.find('#tabpanel').append('<ul id="formTab" class="nav nav-tabs bar_tabs" role="tablist">');
        this.formwraper.find('#tabpanel').append('<div id="TabContent" class="tab-content" >');
        var tabs = this.gettabs();
        for (var key in tabs)
        {
            var tab = tabs[key];
            this.formwraper.find('#tabpanel #formTab').append('<li role="presentation"><a href="#' + tab.contentid + '" id="' + tab.id + '" role="tab" data-toggle="tab">' + tab.title + '</a>');
            this.formwraper.find('#tabpanel #TabContent').append('<div role="tabpanel" class="tab-pane fade in" id="' + tab.contentid + '" aria-labelledby="' + tab.id + '"> ');
//            console.log(this.gettabcontent(tab.contentid));
            if (this.gettabcontent(tab.contentid))
            {
                var content = this.gettabcontent(tab.contentid);
                if (content.active)
                {
                    this.formwraper.find('#tabpanel #formTab #' + tab.id).parent().addClass('active');
                    this.formwraper.find('#tabpanel #TabContent #' + tab.contentid).addClass('active');
                }
                this.formwraper.find('#tabpanel #TabContent #' + tab.contentid).append('<div class="row">');
                var contenttab = this.formwraper.find('#tabpanel #TabContent #' + tab.contentid + ' div');
                if (content.forms)
                {
                    for (var f_key in content.forms)
                    {
                        var form = content.forms[f_key];
                        contenttab.append('<form class="form-horizontal form-label-left pull-left" id="' + form.id + '"><div class="form_main_block">');
                        if (form.label)
                        {
                            if (form.label.show)
                            {
                                contenttab.find('#' + form.id + ' .form_main_block').append('<h3><label class="control-label" >' + form.label.text + '</label></h3>');
                                if (form.label.checker)
                                {
                                    contenttab.find('#' + form.id + ' .form_main_block h3').append('<div class="checkbox" style="display: inline-block">' +
                                            '<' + form.label.checker.tag + ' type="' + form.label.checker.type + '" class="' + form.label.checker.class + '" prop_key="' + form.label.checker.prop_key + '" id="' + form.label.checker.id + '" name="' + form.label.checker.name + '" /> ' +
                                            '</div>');

                                    checked = this.getvaluebypath(form.label.checker.key_path, form.label.checker.default);
                                    if (checked)
                                    {
                                        contenttab.find('#' + form.label.checker.id).attr("checked", checked);
                                    } else
                                    {
                                        contenttab.find('#' + form.label.checker.id).removeAttr("checked");
                                    }
                                }
                            }

                        }
                        var formcontent = form.content;
                        var contener = contenttab.find('#' + form.id + ' .form_main_block');
                        this.drawcontent(formcontent, contener);
                    }
                }

            }

        }

    }
    drawcontent(formcontent, contener)
    {
        if (formcontent)
        {

            for (var c_index in formcontent)
            {
                var item = formcontent[c_index];

                var jobject = $('<' + item.tag + '/>');
                if (item.tag === "select")
                {
                    if (item.options)
                    {
                        for (var opt_key in item.options)
                        {
                            jobject.append('<option value="' + opt_key + '">' + item.options[opt_key] + '</option>');
                        }

                    }
                }
                if (item.class)
                {
                    jobject.addClass(item.class);
                }
                if (item.text)
                {
                    jobject.html(item.text);
                }
                if (item.lfor)
                {
                    jobject.attr('for', item.lfor);
                }
                if (item.target)
                {
                    jobject.attr('target', item.target);
                }
                if (item.id)
                {
                    jobject.attr('id', item.id);
                }
                if (item.type)
                {
                    jobject.attr('type', item.type);
                }
                if (item.prop_key)
                {
                    jobject.attr('prop_key', item.prop_key);
                }
                if (item.name)
                {
                    jobject.attr('name', item.name);
                }
                if (item.style)
                {
                    jobject.attr('style', item.style);
                }
                if (item.key_path)
                {
                    if (item.type === 'checkbox')
                    {
                        var check = this.getvaluebypath(item.key_path, item.default);
                        if (check)
                        {
                            jobject.attr("checked", check);
                        } else
                        {
                            jobject.removeAttr("checked");
                        }
//                        console.log(this.getvaluebypath(item.key_path, item.default));
                    } else
                    {
                        jobject.val(this.getvaluebypath(item.key_path, item.default));
                    }

                }

                jobject.appendTo(contener);
                if (item.content)
                {
                    this.drawcontent(item.content, jobject);
                }
            }
        }
    }
    getvaluebypath(path, def)
    {
        var a_path = path.split('.');
        var object = this.dashJSON[this.row]["widgets"][this.index];
        for (var key in a_path)
        {
            object = object[a_path[key]];
            if (!object)
            {
                return def;
            }

        }
        return object;
    }
    get targetoptions()
    {
        return {"": "&nbsp;", "self": "Self", "blank": "Blank"};
    }

    get positionoptions()
    {
        return {"": "&nbsp;", "center": "Center", "left": "Left", "right": "Right"};
    }
    get spanoptions()
    {
        var obj = {};
        for (var i = 1; i < 13; i++) {
            obj[i] = i;
        }
        return obj;
    }

    get tabs()
    {
        return [{id: "general-tab", title: "General", contentid: "tab_general"},
            {id: "metrics-tab", title: "Metrics", contentid: "tab_metric"},
            {id: "json-tab", title: "Json", contentid: "tab_json"}
        ];
    }

    gettabcontent(key)
    {
        var tabcontent = {};
        tabcontent.tab_general = {};
        tabcontent.tab_metric = {};
        tabcontent.tab_json = {};
        var edit_dimensions = {id: "edit_dimensions", label: {show: true, text: 'Dimensions', checker: false}};
        edit_dimensions.content = [{tag: "div", class: "form-group form-group-custom", content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Span", lfor: "dimensions_span"},
                    {tag: "select", class: "form-control dimensions_input", prop_key: "size", id: "dimensions_span", name: "dimensions_span", key_path: 'size', default: "", options: this.spanoptions}
                ]},
            {tag: "div", class: "form-group form-group-custom", content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Height", lfor: "dimensions_height"},
                    {tag: "input", type: "text", class: "form-control dimensions_input", prop_key: "height", id: "dimensions_height", name: "dimensions_height", key_path: 'height', default: "300px"}
                ]},
            {tag: "div", class: "form-group form-group-custom", content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Transparent", lfor: "dimensions_transparent"},
                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                            {tag: "input", type: "checkbox", class: "js-switch-small", prop_key: "height", id: "dimensions_transparent", name: "dimensions_transparent", key_path: 'transparent', default: false}
                        ]}
//                    
                ]}
        ];
        tabcontent.tab_general.forms = [edit_dimensions];
        if (key === null)
        {
            return tabcontent;
        }
        return tabcontent[key];
    }

    jspluginsinit() {
        var elems = document.querySelectorAll(this.formwraper.selector + ' .js-switch-small');
        var form = this;
        for (var i = 0; i < elems.length; i++) {
            var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
            elems[i].onchange = function () {
                form.change($(this));
            };
        }

        this.formwraper.find("select").select2({minimumResultsForSearch: 15});

        this.formwraper.find('.cl_picer_input').colorpicker().on('hidePicker', function () {
            form.change($(this).find("input"));
        });
        this.formwraper.find('.cl_picer_noinput').colorpicker({format: 'rgba'}).on('hidePicker', function () {
            form.change($(this).find("input"));
        });
    }

    resetjson()
    {

    }

    applyjson()
    {

    }

    change(input) {
        console.log("dsdasasd");
    }
}