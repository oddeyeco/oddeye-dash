/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


class CounterEditForm extends EditForm {
    inittabcontent()
    {
        super.inittabcontent();        
        this.tabcontent.tab_general.forms[0].content[1]={tag: "div", class: "form-group form-group-custom", content: [
                    {tag: "label", class: "control-label control-label-custom", text: "Colum span", lfor: "dimensions_span"},
                    {tag: "select", class: "form-control dimensions_input", prop_key: "col", id: "dimensions_col", name: "dimensions_col", key_path: 'col', default: "", options: this.spanoptions}
                ]}; 
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