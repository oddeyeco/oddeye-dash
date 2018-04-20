/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global URL, cp, $RIGHT_COL, echartLine, token,headerName, uuid, Firstlogin, $SIDEBAR_MENU, $BODY */
var globalsocket;
var globalstompClient;
var headers = {};
//headers[headerName] = token;
headers["page"] = document.URL;

globalconnect(headers);
function updatecounter(counter, widget)
{
    if (widget.title)
    {
        counter.find('.tile-stats h3').text(widget.title.text);
        if (widget.title.textStyle)
        {
            counter.find('.tile-stats h3').css(widget.title.textStyle);
        }
        counter.find('.tile-stats p').text(widget.title.subtext);
        if (widget.title.subtextStyle)
        {
            counter.find('.tile-stats p').css(widget.title.subtextStyle);
        }

    }


}
;
function getDecimalSeparator() {
    var n = 1.1;
    n = n.toLocaleString().substring(1, 2);
    return n;
}

function globalconnect(head)
{
    globalsocket = new SockJS(cp + '/subscribe');
    globalstompClient = Stomp.over(globalsocket);
    globalstompClient.debug = null;

    globalstompClient.connect(head, function (frame) {
        console.log("stomp connected");
        globalstompClient.subscribe('/user/' + uuid + '/info', function (message) {

            var event = JSON.parse(message.body);
            switch (event.action) {
                case 'editdash':
                {
                    if (event.unloadRef !== globalstompClient.ws._transport.unloadRef)
                    {
                        if (window.location.pathname === cp + "/dashboard/" + event.name)
                        {
                            location.reload();
                        }

                        if (event.oldname)
                        {
                            if (window.location.pathname === cp + "/dashboard/" + event.oldname)
                            {
                                var uri = encodeURI(cp + "/dashboard/" + event.name);
                                window.location.href = uri;
                            } else
                            {
                                location.reload();
                            }

                        }
                    }
                    break;
                }
                case 'deletedash':
                {
                    if (event.unloadRef !== globalstompClient.ws._transport.unloadRef)
                    {
                        if (window.location.pathname === cp + "/dashboard/" + event.name)
                        {
                            window.location = cp + "/dashboard/";
                        }

                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        });
        globalstompClient.subscribe('/all/info', function (message) {
            //TODO
        });
    }, function (frame) {
        console.log("Stomp:" + frame);
        setTimeout(function () {
            globalconnect(head);
        }, 60000);

    });
}

function menuscroll() {
    var $LEFT_COL = $('.left_col');
    $LEFT_COL.eq(1).css("max-height", $(".sidebar-footer").offset().top);
//    console.log($("li.active-sm .nav.child_menu"));
    if ($('body').hasClass('nav-sm')) {
        $("#sidebar-menu").removeClass('y-overflow');
        if ($('li').hasClass('active')) {
            if ($("li.active .nav.child_menu").length > 0)
            {
                $("li.active .nav.child_menu").css("max-height", $(window).scrollTop() + $(window).height() - $("li.active .nav.child_menu").offset().top);
                $("li.active .nav.child_menu").addClass('y-overflow');
            }

        }

    } else {
        $("#sidebar-menu").css("max-height", $(".sidebar-footer").offset().top - $("#sidebar-menu").offset().top);
        $("li.active .nav.child_menu").removeClass('y-overflow');
        $("li.active .nav.child_menu").css("max-height", "");
        $("#sidebar-menu").addClass('y-overflow');
    }
}

function applyAlias(text, object)
{
    text = text.replace(new RegExp("\\{metric(.*?)\\}", 'g'), replacerM(object.metric));
    text = text.replace(new RegExp("\\{\w+\\}", 'g'), replacer(object.tags));
    text = text.replace(new RegExp("\\{tag.(.*?)\\}", 'g'), replacer(object.tags));
    return text;
}

function replacerM(metric) {
    return function (str, p1) {
        var split_str = p1.split('|');
//        var func_rexp = new RegExp("r\(\"(.*)\",\"(.*)\"\)", 'g')
        if (typeof split_str[1] !== "undefined")
        {
            var func_rexp = new RegExp("r\\(\"(.*)\",\"(.*)\"\\)");
            if (func_rexp.test(split_str[1]))
            {
                var match = split_str[1].match(func_rexp);
                var inputstr = metric;
                return inputstr.replace(match[1], match[2]);
            }

            var func_rexp = new RegExp("s\\(\"(.*)\"\\)");
            if (func_rexp.test(split_str[1]))
            {
                var match = split_str[1].match(func_rexp);
                var inputstr = metric;
                var len = inputstr.indexOf(match[1]);
                if (len === -1)
                {
                    return inputstr;
                }
                return inputstr.substr(0, len);
            }


        }
        return metric;
    };
}

function replacer(tags) {
    return function (str, p1) {
        var split_str = p1.split('|');
//        console.log(split_str[0]);
        if (typeof tags[split_str[0]] === "undefined")
        {
            return "tag." + split_str[0];
        }

//        var func_rexp = new RegExp("r\(\"(.*)\",\"(.*)\"\)", 'g')
        if (typeof split_str[1] !== "undefined")
        {
            var func_rexp = new RegExp("r\\(\"(.*)\",\"(.*)\"\\)");
            if (func_rexp.test(split_str[1]))
            {
                var match = split_str[1].match(func_rexp);
                var inputstr = tags[split_str[0]];
                return inputstr.replace(match[1], match[2]);
            }

            var func_rexp = new RegExp("s\\(\"(.*)\"\\)");
            if (func_rexp.test(split_str[1]))
            {

                var match = split_str[1].match(func_rexp);
                var inputstr = tags[split_str[0]];
                var len = inputstr.indexOf(match[1]);
                if (len === -1)
                {
                    return inputstr;
                }
                return inputstr.substr(0, len);
            }

        }


        return tags[split_str[0]];
    };
}
function compareStrings(a, b) {
    // Assuming you want case-insensitive comparison
    a = a.toLowerCase();
    b = b.toLowerCase();
    return (a < b) ? -1 : (a > b) ? 1 : 0;
}

function compareNameName(a, b) {
    var _aname = a.name2;
    var _bname = b.name2;
    var _aname2 = a.name;
    var _bname2 = b.name;

    return ((_aname2 < _bname2)) ? -1 : ((_aname2 > _bname2)) ? 1 : (((_aname < _bname)) ? -1 : ((_aname > _bname)) ? 1 : 0);
}

function compareMetric(a, b, tagident) {
    var _aname = a.info.name.toLowerCase();
    var _bname = b.info.name.toLowerCase();
    var _atag = "NaN";
    var _btag = "NaN";
    if (a.info.tags[tagident])
    {
        _atag = a.info.tags[tagident].value.toLowerCase();
    }
    if (b.info.tags[tagident])
    {
        _btag = b.info.tags[tagident].value.toLowerCase();
    }
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
        setCookie("fullscreen", true, {path: '/'});
        var right_col_style = $(".right_col").attr('style');
        setCookie("right_col_style", right_col_style, {path: '/'});
        if (window.location.pathname.indexOf("monitoring") !== -1)
        {
            $(".left_col,.nav_menu,#dash_main,.dash_action,.rawButton,.controls,.page-title,.profile_left").hide();
            $(".right_col,.widgetraw,.fulldash,.chartbkg,.editchartpanel").css('margin', "0");
            $(".right_col,.widgetraw,.fulldash,.chartbkg,.editchartpanel").css('padding', "0");
            $(".profile_right").css("width", "100%");
            $RIGHT_COL.css('min-height', $(window).height());
        } else
        {
            location.reload();
        }
    } else
    {
        setCookie("fullscreen", false, {path: '/'});
        if (window.location.pathname.indexOf("monitoring") !== -1)
        {
            $(".left_col,.nav_menu,#dash_main,.dash_action,.rawButton,.controls,.page-title,.profile_left").show();
            $(".right_col").attr('style', getCookie('right_col_style'));
            $(".profile_right,.widgetraw,.fulldash").removeAttr('style');
            $RIGHT_COL.css('min-height', $(window).height());
        } else
        {
            location.reload();
        }

    }

}

function ModifierColor(color, angel) {    
    var colorarray = [];
    var alfa = "1";
    var colorVal = color.match(/^(#?([a-f\d]{3}|[a-f\d]{6})|rgb\((0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d),\s*(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d),\s*(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d)\)|rgba\((0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d),\s*(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d),\s*(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d),\s*(0?\.?\d+|1(\.0)?)\)|hsl\((0|360|35\d|3[0-4]\d|[12]\d\d|0?\d?\d),\s*(0|100|\d{1,\s*2})%,\s*(0|100|\d{1,\s*2})%\)|hsla\((0|360|35\d|3[0-4]\d|[12]\d\d|0?\d?\d),\s*(0|100|\d{1,\s*2})%,\s*(0|100|\d{1,\s*2})%,\s*(0?\.\d+|1(\.0)?)\))$/);    
    if (typeof (colorVal[2]) !== 'undefined') //HEX color
    {
        var hex = colorVal[2];
        var step = hex.length / 3;
        for (var index = 0; index < hex.length; index = index + step)
        {
            colorarray.push(parseInt(hex.substring(index, index + step), 16));
        }
    }
    if (typeof (colorVal[3]) !== 'undefined') //RGB color
    {
        colorarray = colorVal.slice(3, 6);
    }
    if (typeof (colorVal[6]) !== 'undefined') //RGBA color;
    {
        colorarray = colorVal.slice(6, 9);
        alfa = colorVal[9];
    }    
    //TODO hsl
    //**********
    for (var i = 0; i < colorarray.length; i++) {
        colorarray[i] = Math.round(((((colorarray[i] * 360 / 255) + angel) % 360) * 255) / 360);
    }
    var newRgba = 'rgba(' + colorarray[0] + ',' + colorarray[1] + ',' + colorarray[2] + ',' + alfa + ')';
    //TODO return as input    
    return newRgba;
}

var fullscreen = getCookie('fullscreen');
if (fullscreen == 'true')
{
    $(".left_col,.nav_menu,#dash_main,.dash_action,.rawButton,.controls,.page-title,.profile_left").hide();
    var right_col_style = "";
    right_col_style = $(".right_col").attr('style');
    setCookie("right_col_style", right_col_style, {path: '/'});
    $(".right_col,.widgetraw,.fulldash,.chartbkg,.editchartpanel").css('margin', "0");
    $(".right_col,.widgetraw,.fulldash,.chartbkg,.editchartpanel").css('padding', "0");
    $(".profile_right").css("width", "100%");
}

$(document).ready(function () {
    if (Firstlogin)
    {
//        $("#welcomemessage").modal('show');
    }

    if (getCookie('small') == 'true')
    {
        $(' ul.nav.child_menu').hide();
        if ($BODY.hasClass('nav-sm')) {
            $SIDEBAR_MENU.find('li.active ul').hide();
            $SIDEBAR_MENU.find('li.active').addClass('active-sm').removeClass('active');
        }
    }

    if (!$('.profile_left-form').is(":visible"))
    {
        $('.hidefilter').removeClass('fa-chevron-up');
        $('.hidefilter').addClass('fa-chevron-down');
        $('.profile_right-table').css('width', '100%');
    }
    $("body").on("click", ".hidefilter", function () {
        if ($(this).hasClass('fa-chevron-up'))
        {
            $(this).removeClass('fa-chevron-up');
            $(this).addClass('fa-chevron-down');
            $('.profile_left-form').hide();
            $('.profile_right-table').css('width', '100%');
        } else
        {
            $(this).removeClass('fa-chevron-down');
            $(this).addClass('fa-chevron-up');
            $('.profile_left-form').show();
            $('.profile_right-table').removeAttr('style');
        }

        if (typeof echartLine !== 'undefined')
        {
            echartLine.resize();
        }
    });
    $("body").on("click", "input", function (event) {
        ga('send', 'event', 'input click', $(this).attr("name"));
    });
    $("body").on("click", "a", function (event) {
        ga('send', 'event', 'link click', $(this).attr("href"));
    });
    $("body").on("click", "#allowedit", function () {
        var uri = cp + "/switchallow";
        $.getJSON(uri, null, function (data) {
            location.reload();
        });
    });
    $("body").on("click", "#FullScreen", function () {
        fullscreenrequest(getCookie('fullscreen') == 'true');
    });

    $("body").on("click", "#menu_toggle", function () {
        setCookie("small", getCookie('small') != 'true', {path: '/'});
    });
    $('body').on("click", '.nav.side-menu li', function () {
        menuscroll();
    });

    $('.right_col, .nav_menu').on('click', function (ev) {
        if ($('body').hasClass('nav-sm'))
        {
            $SIDEBAR_MENU.find('li').removeClass('active active-sm');
            $SIDEBAR_MENU.find('a').filter(function () {
                return this.href == CURRENT_URL;
            }).parent('li').addClass('current-page').parents('ul').parent().addClass("active-sm");

            $SIDEBAR_MENU.find('li ul').slideUp();
        }


    });
});
$(window).load(function () {
    menuscroll();
});

$(window).resize(function () {
    menuscroll();
});
