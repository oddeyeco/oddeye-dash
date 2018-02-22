/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var test = false;
var b = document.location.hostname.split(".");
var host = "." + b[b.length - 2] + "." + b[b.length - 1];
if (!getCookie("feh"))
{
    setCookie("feh", document.location.href, {domain: host, path: '/', expires: 50000000000});
}
if (!getCookie("fep"))
{
    setCookie("fep", document.location.pathname, {domain: host, path: '/', expires: 50000000000});
}
if (!getCookie("feq"))
{
    setCookie("feq", document.location.search, {domain: host, path: '/', expires: 50000000000});
}
if (!getCookie("fed"))
{
    setCookie("fed", document.location.hostname, {domain: host, path: '/', expires: 50000000000});
}
if (document.referrer)
{
    if (!getCookie("fer"))
    {
        setCookie("fer", document.referrer, {domain: host, path: '/', expires: 50000000000});
    }
    setCookie("lar", document.referrer, {domain: host, path: '/', expires: 50000000000});
}
$(document).ready(function () {
    $("body").on("click", ".addtagq", function () {
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

function getCookie(name) {
    var matches = document.cookie.match(new RegExp(
            "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
            ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
}

function setCookie(name, value, options) {
    options = options || {};
    var expires = options.expires;
    if (typeof expires === "number" && expires) {
        var d = new Date();
        d.setTime(d.getTime() + expires * 1000);
        expires = options.expires = d;
    }
    if (expires && expires.toUTCString) {
        options.expires = expires.toUTCString();
    }

    value = encodeURIComponent(value);
    var updatedCookie = name + "=" + value;
    for (var propName in options) {
        updatedCookie += "; " + propName;
        var propValue = options[propName];
        if (propValue !== true) {
            updatedCookie += "=" + propValue;
        }
    }

    document.cookie = updatedCookie;
}