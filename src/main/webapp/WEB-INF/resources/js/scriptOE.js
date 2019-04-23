/* global app */

$(document).ready(function () {
    
    $('#menu_toggle').on('click', function () {
        $('#sidebar, #content').toggleClass('active');
        $('.collapse.show').toggleClass('show');
        $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        
        if ($('#menu_toggle i').hasClass('fa-indent'))
        {
            $('#menu_toggle i').removeClass('fa-indent');
            $('#menu_toggle i').addClass('fa-outdent');
        } else
        {
            $('#menu_toggle i').removeClass('fa-outdent');
            $('#menu_toggle i').addClass('fa-indent');
        }
    });
    
var id = [ 
 { '#collapseFilters': '#filters' },
 { '#collapseAll_msg': '#All_msg' },
 { '#collapseMachine_msg': '#Machine_msg' },
 { '#collapseManual_msg': '#Manual_msg' },
 { '#collapseOptions': '#options' },
 { '#collapseNotifiers': '#notifiers' }
];
    $.each(id, function () {
        $.each(this, function (name, value) {
            $(name).on('click', function () {
                if ($(name + " i").hasClass('fa-indent'))
                {
                    $(name + " i").removeClass('fa-indent');
                    $(name + " i").addClass('fa-outdent');
                    $(value).hide();
                } else
                {
                    $(name + " i").removeClass('fa-outdent');
                    $(name + " i").addClass('fa-indent');
                    $(value).show();
                }
            });
        });
    });


// ================== bootstrap-select ================ To style all selects//
//infrastructureFilter 
  
  $("body").on("click", ".hidefilter", function () {
        if ($("button#filterCollapse i").hasClass('fa-indent'))
        {
            $("#filterCollapse i").removeClass('fa-indent');
            $("#filterCollapse i").addClass('fa-outdent');
            $('.profile_left-form').hide();
            $('.profile_btn').hide();
            $('.profile_right-table').css({'flex':'0 0 100%','max-width':'100%'});
        } else
        {
            $("#filterCollapse i").removeClass('fa-outdent');
            $("#filterCollapse i").addClass('fa-indent');
            $('.profile_left-form').show();
            $('.profile_btn').show();
            $('.profile_right-table').removeAttr('style');
        }
        if (typeof echartLine !== 'undefined')
        {
            echartLine.resize();
        }
    });
      
});