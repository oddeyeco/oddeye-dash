/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var test = false;

$(document).ready(function () {
    var value = 10;
    $("#oddeyeQuantity").val(value.toFixed(2));
    value = value + value * 2 / 100 + 0.3;
    $("#oddeyeAmmount").val(value.toFixed(2));
    $("#paypalAmmount").val($("#oddeyeAmmount").val());

    $('body').on("blur", "#oddeyeQuantity", function () {
        var value = Number($(this).val());
        value = value + value * 2 / 100 + 0.3;
        $("#oddeyeAmmount").val(value.toFixed(2));
        $("#paypalAmmount").val($("#oddeyeAmmount").val());
    });

    $('body').on("blur", "#oddeyeAmmount", function () {
        var value = Number($(this).val());
        value = (value - 0.3) / (1 + 2 / 100);
        $("#oddeyeQuantity").val(value.toFixed(2));
        $("#paypalAmmount").val($("#oddeyeAmmount").val());
    });

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

    $("body").on("click", "a.idcheck", function (event) {
        ga('send', 'event', $(this).attr("id"), $(this).text());
    });
});
var getQueryString = function (url) {
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