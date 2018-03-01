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
});

$('body').on('click', '#mobileLeftMenu', function () {
    var elemWidth = $('#fix').outerWidth();
    console.log("asd");
//    $('#fix').css({height: '100%'});
    $('#fix').css({height: '100%'});
//    $("#fix, .toggle").animate({right: elemWidth})
    $('#fix').toggle(function () {
        $("#fix, .toggle").animate({right: elemWidth});
        $("#fix, .toggle").animate({right: elemWidth});
    });
});