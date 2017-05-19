/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global URL, cp */

function getCookie(name) {
    var matches = document.cookie.match(new RegExp(
            "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
            ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
}

function setCookie(name, value, options) {
    options = options || {};

    var expires = options.expires;

    if (typeof expires == "number" && expires) {
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

function compareStrings(a, b) {
    // Assuming you want case-insensitive comparison
    a = a.toLowerCase();
    b = b.toLowerCase();
    return (a < b) ? -1 : (a > b) ? 1 : 0;
}

function compareMetric(a, b, tagident) {
    var _aname = a.info.name.toLowerCase();
    var _bname = b.info.name.toLowerCase();
    var _atag = a.info.tags[tagident].value.toLowerCase();
    var _btag = b.info.tags[tagident].value.toLowerCase();
    var _atime = a.time;
    var _btime = b.time;
//    return ((_aname < _bname) && (_atag < _btag) && (_atime < _btime)) ? -1 : ((_aname > _bname) && (_atag > _btag) && (_atime > _btime)) ? 1 : 0;
//    if (_atag == _btag)
//    {
//        console.log;
//    }
    return ((_atag < _btag)) ? -1 : ((_atag > _btag)) ? 1 : (((_aname < _bname)) ? -1 : ((_aname > _bname)) ? 1 : 0);
}

function exportToCsv(filename, rows) {
    var processRow = function (row) {
        var finalVal = '';
        for (var j = 0; j < row.length; j++) {
            var innerValue = row[j] === null ? '' : row[j].toString();
            if (row[j] instanceof Date) {
                innerValue = row[j].toLocaleString();
            }
            ;
            var result = innerValue.replace(/"/g, '""');
            if (result.search(/("|,|\n)/g) >= 0)
                result = '"' + result + '"';
            if (j > 0)
                finalVal += ',';
            finalVal += result;
        }
        return finalVal + '\n';
    };

    var csvFile = '';
    for (var i = 0; i < rows.length; i++) {
        csvFile += processRow(rows[i]);
    }

    var blob = new Blob([csvFile], {type: 'text/csv;charset=utf-8;'});
    if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, filename);
    } else {
        var link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
            // Browsers that support HTML5 download attribute
            var url = URL.createObjectURL(blob);
            link.setAttribute("href", url);
            link.setAttribute("download", filename);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }
}
function fullscreenrequest(fullscreen)
{
    if (!fullscreen)
    {

//        $(".left_col,.nav_menu,.dash_main,.dash_action,.rawButton,.controls,.page-title,.profile_left").hide();
//        var right_col_style = "";
//        right_col_style = $(".right_col").attr('style');
//
//        $(".right_col,.widgetraw,.fulldash").css('margin', "0");
//        $(".right_col,.widgetraw,.fulldash").css('padding', "0");
//        $(".profile_right").css("width", "100%");
        setCookie("fullscreen", true);
        setCookie("right_col_style", right_col_style);
        location.reload();

    } else
    {
//        $(".left_col,.nav_menu,.dash_main,.dash_action,.rawButton,.controls,.page-title,.profile_left").show();
//        $(".right_col").attr('style', getCookie('right_col_style'));
//        $(".profile_right,.widgetraw,.fulldash").removeAttr('style');
        setCookie("fullscreen", false);
    }
    location.reload();
}

var fullscreen = getCookie('fullscreen');
if (fullscreen == 'true')
{
    $(".left_col,.nav_menu,.dash_main,.dash_action,.rawButton,.controls,.page-title,.profile_left").hide();
    var right_col_style = "";
    right_col_style = $(".right_col").attr('style');
    setCookie("right_col_style", right_col_style);
    $(".right_col,.widgetraw,.fulldash,.chartbkg,.editchartpanel").css('margin', "0");
    $(".right_col,.widgetraw,.fulldash,.chartbkg,.editchartpanel").css('padding', "0");
    $(".profile_right").css("width", "100%");
}

$(document).ready(function () {
    $("body").on("click", "#allowedit", function () {
        var uri = cp + "/switchallow";
        $.getJSON(uri, null, function (data) {
            console.log(data);
            location.reload();
        });

    });

    $("body").on("click", "#FullScreen", function () {
        var fullscreen = getCookie('fullscreen');
        fullscreenrequest(fullscreen == 'true');
    });

});


