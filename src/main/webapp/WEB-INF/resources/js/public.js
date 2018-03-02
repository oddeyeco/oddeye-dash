/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function () {
    $('input.flat').iCheck({
        checkboxClass: 'icheckbox_flat-green',
        radioClass: 'iradio_flat-green'
    });

    if ($(window).width() < 767) {
        var isTrue = true;
        var elem = $('#fix'), elemWidth = $('#fix').outerWidth();
        elem.css({left: -elemWidth, display: 'block'});
        $('body').on('click', '#mobileLeftMenu', function () {

            console.log(isTrue);
            if (isTrue) {
                $(".toggle").animate({left: elemWidth});
                elem.animate({left: 0});
                isTrue = false;
            } else {
                $(".toggle").animate({left: 0});
                elem.animate({left: -elemWidth});
                isTrue = true;
            }
            ;
        });
        $('#return-to-top').click(function (e) {
            e.preventDefault();
            $('body,html').animate({
                scrollTop: 0
            }, 500);
        });
        $(document).on('scroll', function () {

            if ($(this).scrollTop() >= 500) {
                $('#return-to-top').fadeIn(200);
            } else {
                $('#return-to-top').fadeOut(200);
            }
            elem.css({height: $(document).height()});
            if ($(document).scrollTop() > $('.left_col').offset().top + $('#fix .side-menu').height()) {
                console.log("if ashxatesc");

                clearTimeout(whaittimer)
                whaittimer = setTimeout(function () {

                    $(".toggle").animate({left: 0});
                    elem.animate({left: -elemWidth});
                    var isTrue = true;
                }, 1000);
            }
        });
    }
    ;
});