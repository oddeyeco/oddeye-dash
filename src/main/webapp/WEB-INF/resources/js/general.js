/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var test = false;

$(document).ready(function () {
    $("body").on("click", "#addtagq", function () {
        if ($(this).hasClass("hider"))
        {
            $(this).parents(".form-group").find(".tagfilter").hide();
            $(this).text("Edit tag filer");
            $(this).removeClass("hider");            
        } else
        {
            $(this).parents(".form-group").find(".tagfilter").show();
            $(this).text("Hide");
            $(this).addClass("hider");
        }
    });    
    
    $("body").on("click", "input", function (event) {
        ga('send', 'event', 'input click', $(this).attr("name"));
    });

    $("body").on("click", "a", function (event) {
        ga('send', 'event', 'link click', $(this).attr("href"));
    });

//    $('input.flat').iCheck({
//        checkboxClass: 'icheckbox_flat-green',
//        radioClass: 'iradio_flat-green'
//    });
});
var getQueryString = function (url ) {   
    var href = url ? url : window.location.href;        
    return string ? string[1] : null;
};

function getParameterByName(name, url) {
    if (!url)
        url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
    if (!results)
        return null;
    if (!results[2])
        return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}