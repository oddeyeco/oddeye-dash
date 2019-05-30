/* global app */

var CURRENT_URL = window.location.href.split('?')[0],
    $BODY = $('body'),
    $MENU_TOGGLE = $('#menu_toggle'),
    $SIDEBAR_MENU = $('#sidebar-menu'),
    $SIDEBAR_FOOTER = $('.sidebar-footer'),
    $LEFT_COL = $('.left_col'),
    $RIGHT_COL = $('.right_col'),
    $NAV_MENU = $('.nav_menu'),
    $FOOTER = $('footer');

// Sidebar
$(document).ready(function() {
    

//    // toggle small or large menu
//    $MENU_TOGGLE.on('click', function() {
//        if ($BODY.hasClass('nav-md')) {
//            $SIDEBAR_MENU.find('li.active ul').hide();
//            $SIDEBAR_MENU.find('li.active').addClass('active-sm').removeClass('active');
//        } else {
//            $SIDEBAR_MENU.find('li.active-sm ul').show();
//            $SIDEBAR_MENU.find('li.active-sm').addClass('active').removeClass('active-sm');
//        }        
//        $BODY.toggleClass('nav-md nav-sm');        
//    });
    // toggle small or large menu
    $MENU_TOGGLE.on('click', function() {
        if ($BODY.hasClass('nav-md')) {
            $('#sidebar, #content').addClass('active');
        } else {
            $('#sidebar, #content').removeClass('active');
            $('#sidebarMenu').show();
        }        
        $BODY.toggleClass('nav-md nav-sm');
        
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

    // check active menu
    $SIDEBAR_MENU.find('a[href="' + CURRENT_URL + '"]').parent('li').addClass('current-page');

    $SIDEBAR_MENU.find('a').filter(function () {
        return this.href == CURRENT_URL;
    }).parent('li').addClass('current-page').parents('.collapse').collapse('show').parent().addClass('active');

    // fixed sidebar
//    if ($.fn.mCustomScrollbar) {
//        $('.menu_fixed').mCustomScrollbar({
//            autoHideScrollbar: true,
//            theme: 'dark',
//            mouseWheel:{ preventDefault: true }
//        });
//    }

});
// /Sidebar

// Panel toolbox
$(document).ready(function() {
    $('.collapse-link').on('click', function() {
        var $BOX_PANEL = $(this).closest('.x_panel'),
            $ICON = $(this).find('i'),
            $BOX_CONTENT = $BOX_PANEL.find('.x_content');
        
        // fix for some div with hardcoded fix class
        if ($BOX_PANEL.attr('style')) {
            $BOX_CONTENT.slideToggle(200, function(){
                $BOX_PANEL.removeAttr('style');
            });
        } else {
            $BOX_CONTENT.slideToggle(200); 
            $BOX_PANEL.css('height', 'auto');  
        }

        $ICON.toggleClass('fa-chevron-up fa-chevron-down');
    });

    $('.close-link').click(function () {
        var $BOX_PANEL = $(this).closest('.x_panel');

        $BOX_PANEL.remove();
    });
});
// /Panel toolbox

// Tooltip
$(document).ready(function() {
    $('[data-toggle="tooltip"]').tooltip({
        container: 'body'
    });
});
// /Tooltip

// Progressbar
if ($(".progress .progress-bar")[0]) {
    $('.progress .progress-bar').progressbar();
}
// /Progressbar

// Switchery
$(document).ready(function() {
    if ($(".js-switch")[0]) {
        var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
        elems.forEach(function (html) {
            var switchery = new Switchery(html, {
                color: '#26B99A'
            });
        });
    }
});
// /Switchery

// iCheck
$(document).ready(function() {
    if ($("input.flat")[0]) {
        $(document).ready(function () {
            $('input.flat').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        });
    }
});
// /iCheck

// Table
$('table input').on('ifChecked', function () {
    checkState = '';
    $(this).parent().parent().parent().addClass('selected');
    countChecked();
});
$('table input').on('ifUnchecked', function () {
    checkState = '';
    $(this).parent().parent().parent().removeClass('selected');
    countChecked();
});

var checkState = '';

$('.bulk_action input').on('ifChecked', function () {
    checkState = '';
    $(this).parent().parent().parent().addClass('selected');
    countChecked();
});
$('.bulk_action input').on('ifUnchecked', function () {
    checkState = '';
    $(this).parent().parent().parent().removeClass('selected');
    countChecked();
});
$('.bulk_action input#check-all').on('ifChecked', function () {
    checkState = 'all';
    countChecked();
});
$('.bulk_action input#check-all').on('ifUnchecked', function () {
    checkState = 'none';
    countChecked();
});

function countChecked() {
    if (checkState === 'all') {
        $(".bulk_action input[name='table_records']").iCheck('check');
    }
    if (checkState === 'none') {
        $(".bulk_action input[name='table_records']").iCheck('uncheck');
    }

    var checkCount = $(".bulk_action input[name='table_records']:checked").length;

    if (checkCount) {
        $('.column-title').hide();
        $('.bulk-actions').show();
        $('.action-cnt').html(checkCount + ' Records Selected');
    } else {
        $('.column-title').show();
        $('.bulk-actions').hide();
    }
}

// Accordion
$(document).ready(function() {
    $(".expand").on("click", function () {
        $(this).next().slideToggle(200);
        $expand = $(this).find(">:first-child");

        if ($expand.text() == "+") {
            $expand.text("-");
        } else {
            $expand.text("+");
        }
    });
});

// NProgress
if (typeof NProgress != 'undefined') {
    $(document).ready(function () {
        NProgress.start();
    });

    $(window).load(function () {
        NProgress.done();
    });
}
/**
 * Resize function without multiple trigger
 * 
 * Usage:
 * $(window).smartresize(function(){  
 *     // code here
 * });
 */
(function($,sr){
    // debouncing function from John Hann
    // http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
    var debounce = function (func, threshold, execAsap) {
      var timeout;

        return function debounced () {
            var obj = this, args = arguments;
            function delayed () {
                if (!execAsap)
                    func.apply(obj, args);
                timeout = null; 
            }

            if (timeout)
                clearTimeout(timeout);
            else if (execAsap)
                func.apply(obj, args);

            timeout = setTimeout(delayed, threshold || 100); 
        };
    };

    // smartresize 
    jQuery.fn[sr] = function(fn){  return fn ? this.bind('resize', debounce(fn)) : this.trigger(sr); };

})(jQuery,'smartresize');
// ========================================================================================================
$(document).ready(function () {
    
//    $('#menu_toggle').on('click', function () {
//        $('#sidebar, #content').toggleClass('active');
//        $('.collapse.show').toggleClass('show');
//        $('a[aria-expanded=true]').attr('aria-expanded', 'false');
//        
//        if ($('#menu_toggle i').hasClass('fa-indent'))
//        {
//            $('#menu_toggle i').removeClass('fa-indent');
//            $('#menu_toggle i').addClass('fa-outdent');
//        } else
//        {
//            $('#menu_toggle i').removeClass('fa-outdent');
//            $('#menu_toggle i').addClass('fa-indent');
//        }
//    });
    
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