/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global moment, cp, headerName, token, uuid, sotoken, filterOldJson */

var socket;
var stompClient;
var timeformat = "DD/MM HH:mm:ss";
var timeformatsmall = "HH:mm:ss";
var errorlistJson = {};
var array_regular = [];
var array_spec = [];
//var strop = "<option value='~'>contains</option><option value='!~'>doesn't contain</option><option value='=='>equal</option><option value='!='>not equal</option><option value='!*'>none</option><option value='*'>any</option> <option value='regexp'>RegExp true</option><option value='regexp'>RegExp false</option>";
var strop = "<option value='~'>contains</option><option value='!~'>doesn't contain</option><option value='=='>equal</option><option value='!='>not equal</option>";
var eniumop = "<option value='='>is</option><option value='!'>is not</option>";
function redrawBoard() {
//    optionsJson.f_col.forEach(
//            function (entry) {
//                switch (entry) {
//                    case 'actions':
//                    {
//                        $(".metrictable thead#manualhead tr").append(
//                                '<th class="actions">' +
//                                '<input type="checkbox" id="check-all" class="flat">' +
//                                '<div class="btn-group">' +
//                                '<button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">' +
//                                '<span class="caret"></span>' +
//                                '<span class="sr-only">Toggle Dropdown</span>' +
//                                '</button>' +
//                                '<ul class="dropdown-menu" role="menu">' +
//                                '<li><a href="#" id="Show_chart">Show Chart</a>' +
//                                '</li>' +
//                                '<li class="divider"></li>' +
//                                '<li><a href="#" id="Clear_reg">Clear Regression</a>' +
//                                '</li>' +
//                                '</ul>' +
//                                '</div>' +
//                                '</th>');
//                        $(".metrictable thead#specialhead tr").append(
//                                '<th class="actions">' +
//                                '</th>');
//                        break
//                    }
//                    default:
//                    {
//                        var obj = $('.f_col option[value=' + entry + ']');
//                        $(".metrictable thead tr").append("<th>" + obj.attr("label") + "</th>");
//                        break;
//                    }
//                }
//                $(".metrictable tbody tr.wait td").attr("colspan", $(".metrictable thead tr th").length);
//            }
//    );
//    $('.metrictable thead input.flat').iCheck({
//        checkboxClass: 'icheckbox_flat-green',
//        radioClass: 'iradio_flat-green'
//    });
//
//    $('.bulk_action input#check-all').on('ifChecked', function () {
//        checkState = 'all';
//        countChecked();
//    });
//    $('.bulk_action input#check-all').on('ifUnchecked', function () {
//        checkState = 'none';
//        countChecked();
//    });

    $(".monitorlist ul").html("");

//    optionsJson.fcol.each(
//            
//    );
    if (Object.keys(errorlistJson).length > 0)
    {
        DrawErrorList(errorlistJson, $(".metrictable"));
    }

}

function connectstompClient()
{

    var headers = {};
    headers[headerName] = token;
    headers["sotoken"] = sotoken;
    headers["options"] = JSON.stringify(optionsJson);
    realtimeconnect(headers);
}

function realtimeconnect(head)
{
    console.log("connect START");
    socket = new SockJS(cp + '/subscribe');
    stompClient = Stomp.over(socket);
    stompClient.debug = null;
    stompClient.connect(head,
            function (frame) {
                console.log("Monitor connected");
                stompClient.subscribe('/user/' + uuid + '/' + sotoken + '/errors', aftersubscribe);
//                console.log(frame);
            },
            function (message) {
                console.log("Monitor:" + message);
                setTimeout(function () {
                    realtimeconnect(head);
                }, 6000);
            });
}

function aftersubscribe(error) {
    $(".metrictable").find("tr.wait").remove();
    var errorjson = JSON.parse(error.body);
    if (errorlistJson[errorjson.hash])
    {
        errorjson.index = errorlistJson[errorjson.hash].index;
    }
    if (typeof (errorjson.index) !== "undefined")
    {
        errorjson.index = errorjson.index + 1;
    } else
    {
        errorjson.index = 0;
    }
    if (errorlistJson[errorjson.hash])
    {
        if (errorjson.time >= errorlistJson[errorjson.hash].time)
        {
            if (errorjson.level === -1)
            {
                delete errorlistJson[errorjson.hash];
            } else
            {
                errorlistJson[errorjson.hash] = errorjson;
            }
            reDrawErrorList(errorlistJson, "monitorlist", errorjson);
        }
    } else
    {
        if (errorjson.level === -1)
        {
            delete errorlistJson[errorjson.hash];
        } else
        {
            errorlistJson[errorjson.hash] = errorjson;
        }
        reDrawErrorList(errorlistJson, "monitorlist", errorjson);

    }
    if (Object.keys(errorlistJson).length > 200)
    {
//        stompClient.disconnect();
        $('#manyalert').fadeIn();
    } else
    {
        $('#manyalert').fadeOut();
    }
//            console.log(errorlistJson[errorjson.hash]);

}
function findeByhash(element, array) {
    for (var i = 0; i < array.length; i++) {
        if (array[i].hash === element.hash) {
            return i;
        }
    }
    return -1;
}

function drawUL(errorjson, table, hashindex, update) {
    if (typeof (hashindex) === "undefined")
    {
        hashindex = null;
    }
    if (typeof (update) === update)
    {
        type = false;
    }

    var message = "";
    if (errorjson.isspec === 1)
    {
        message = errorjson.message;
    } else
    {
        var val = 0;
        var count = 0;
        for (var key in errorjson.values)
        {
            val = val + errorjson.values[key].value;
            count++;
//              val = errorjson.values[key].value;
        }
        val = val / count;
        if (val > 1000)
        {
            val = format_metric(errorjson.values[key].value);
        } else
        {
            if (!Number.isInteger(val))
            {
                val = val.toFixed(2);
            }

        }

        message = message + val;
    }
    var starttime = "";
    if (typeof (errorjson.time) !== "undefined")
    {
        starttime = moment(errorjson.time * 1).format(timeformatsmall);
    }
    var arrowclass = "";
    var color = "red";
    if (errorjson.action === 2)
    {
        arrowclass = "fa-long-arrow-down";
        color = "green";
    }
    if (errorjson.action === 3)
    {
        arrowclass = "fa-long-arrow-up";
        color = "red";
    }
    var eRclass = "level_" + errorjson.level;
    var UlID = "regularlist";
    if (errorjson.isspec !== 0)
    {
        eRclass = eRclass + " spec";
        UlID = "speciallist";

    }

    if (errorjson.flap > 5)
    {
        eRclass = eRclass + " flapdetect";
    }

    if (!update)
    {
        var html = '<li style="display:none" id="' + errorjson.hash + '" class="' + eRclass + '" time="' + moment().format("x") + '">';
        var re = /_/gi;
        optionsJson.f_col.forEach(
                function (entry) {                    
                    var obj = $('.f_col option[value=' + entry + ']');
                    if (obj)
                    {
                        switch (obj.attr("key")) {
                            case  "actions":
                            {
                                if (errorjson.isspec === 0)
                                {
//                                html = html + '<div class="inline icons"><input type="checkbox" class="rawflat" name="table_records"><div class="fa-div"> <a href="' + cp + '/chart/' + errorjson.hash + '" target="_blank"><i class="fa fa-area-chart"></i></a><a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a> <i class="action fa ' + arrowclass + '" style="color:' + color + ';"></i></div></div>';
                                    html = html + '<div class="icons"><i class="pull-left action fa ' + arrowclass + '" style="color:' + color + ';"></i> <a href="' + cp + '/chart/' + errorjson.hash + '" target="_blank"><i class="fa fa-area-chart"></i></a><a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a></div>';
                                } else
                                {
                                    html = html + '<div class="icons"><i class="fa fa-bell pull-left"></i> <a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a></div>';
                                }
                                break;
                            }
                            case  "message":
                            {
                                if (errorjson.isspec !== 0)
                                {
                                    html = html + '<div class="message"><i class="fa fa-comment-o"></i> ' + message + '</div>';
                                }
                                break;
                            }
                            case  "info":
                            {
                                if (errorjson.isspec === 0)
                                {
                                    var valuearrowclass = "fa-long-arrow-down";
                                    if (errorjson.upstate)
                                    {
                                        valuearrowclass = "fa-long-arrow-up";
                                    }
                                    html = html + '<div class="valueinfo"><i class="action fa ' + valuearrowclass + '"></i> ' + message + '</div>';
                                }

                                break;
                            }
                            case  "StartTime":
                            {
                                var st = errorjson.starttimes[errorjson.level] ? errorjson.starttimes[errorjson.level] : errorjson.time;
                                html = html + '<div class="inline starttime">' + moment(st * 1).format(timeformat) + '</div>';
                                break;
                            }
                            case  "LastTime":
                            {
                                var st = errorjson.time;
                                html = html + '<div class="inline timelocal">' + moment(st * 1).format(timeformatsmall) + '</div>';
                                break;
                            }

                            case  "updateinterval":
                            {
                                var st = errorjson.starttimes[errorjson.level] ? errorjson.starttimes[errorjson.level] : errorjson.time;
                                html = html + '<div class="inline timeinterval badge bg-white">0</div>';
                                break;
                            }
                            case  "updatecounter":
                            {
                                html = html + '<div class="inline updatecounter badge">0</div>';
                                break;
                            }
                            case  "duration":
                            {
                                var st = errorjson.starttimes[errorjson.level] ? errorjson.starttimes[errorjson.level] : errorjson.time;
                                var lt = errorjson.time;
                                html = html + '<div class="inline duration badge">' + moment.duration(lt - st).humanize() + '</div>';
                                break;
                            }

                            case  "levelname":
                            {
                                html = html + '<div class="label label-info level inline">' + errorjson.levelname + '</div>';
                                break;
                            }
                            //html = html + "<div><span class='timeinterval'>0</span> <span class='refreshes'>1</span></div>";
                            case  "info.name":
                            {
                                var path = obj.attr("key").split(".");
                                var value = errorjson;

                                $.each(path, function (i, item) {
                                    if (value)
                                    {
                                        value = value[item];
                                    }
                                });
                                if (errorjson.isspec === 0)
                                {
                                    if (value)
                                    {
                                        html = html + '<div class="metricname ' + obj.attr("value").replace(re, " ") + '"><div><a href="' + cp + '/metriq/' + errorjson.hash + '" target="_blank">' + value + '</a></div></div>';
                                    }


                                } else
                                {
                                    html = html + '<div class="metricname ' + obj.attr("value").replace(re, " ") + '"><div>' + value + '</div></div>';
                                }
                                break;
                            }
                            default:
                            {
                                var path = obj.attr("key").split(".");
                                var value = errorjson;

                                $.each(path, function (i, item) {
                                    if (value)
                                    {
                                        value = value[item];
                                    }
                                });


                                if (value)
                                {
                                    html = html + '<div class="' + obj.attr("value").replace(re, " ") + '"><div>' + value + '</div></div>';
                                }

                                break;
                            }

                        }
                    }


                }
        );

        html = html + "</li>";
        $("." + table).find("ul#" + UlID).prepend(html);
        $("." + table).find("li#" + errorjson.hash).show("slide", {direction: "left"}, 1000);


    } else
    {
        $("." + table).find("li#" + hashindex + " .info.name").effect("shake", {direction: "down", distance: 2}, "slow");
        $("." + table).find("li#" + hashindex).attr("class", eRclass);
        $("." + table).find("li#" + hashindex + " .level div").html(errorjson.levelname);

        var st = errorjson.starttimes[errorjson.level] ? errorjson.starttimes[errorjson.level] : errorjson.time;
        var lt = errorjson.time;
        $("." + table).find("li#" + hashindex + " .duration").html(moment.duration(lt - st).humanize());

        if (errorjson.starttimes[errorjson.level])
        {
            $("." + table).find("li#" + hashindex + " .starttime").html(moment(st * 1).format(timeformat));
        }
//        var rectime=moment();
        var rectime = moment(lt);
        $("." + table).find("li#" + hashindex + " .timelocal").html(rectime.format(timeformatsmall));
        $("." + table).find("li#" + hashindex).attr('time', moment().format("x"));
        var refreshes = $("." + table).find("li#" + hashindex + " .updatecounter");
        var val = refreshes.text() * 1 + 1;
        refreshes.text(val);
//errorjson.flap
        if (errorjson.isspec === 0)
        {
            var valuearrowclass = "fa-long-arrow-down";
            if (errorjson.upstate)
            {
                valuearrowclass = "fa-long-arrow-up";
            }
            $("." + table).find("li#" + hashindex + " .valueinfo").html('<i class="action fa ' + valuearrowclass + '"></i> ' + message);
        } else
        {
            $("." + table).find("li#" + hashindex + " .message").html('<i class="action fa fa-comment-o"></i> ' + message);
        }
        if (arrowclass !== "")
        {
            $("." + table).find("li#" + hashindex + " .icons i.action").attr("class", "action fa " + arrowclass);
            $("." + table).find("li#" + hashindex + " .icons i.action").css("color", color);
        }

    }
    $('.summary .Tablecount').html(array_regular.length + array_spec.length);
    $('.summary .regcount').html(array_regular.length);
    $('.summary .Speccount').html(array_spec.length);
}

function reDrawErrorList(listJson, listclass, errorjson)
{
    var filtred = checkfilter(errorjson);
    if (!filtred)
    {
        delete listJson[errorjson.hash];
    }

    if (errorjson.isspec === 0)
    {
        var indexregular = findeByhash(errorjson, array_regular);
        if (filtred)
        {
            if (indexregular === -1)
            {
                array_regular.push(errorjson);
                var index2 = findeByhash(errorjson, array_regular);

                if (index2 < array_regular.length - 1)
                {
                    drawUL(array_regular[index2], listclass, array_regular[index2 + 1].hash);
                } else
                {
                    drawUL(array_regular[index2], listclass);
                }
            } else
            {
                array_regular[indexregular] = errorjson;
                drawUL(array_regular[indexregular], listclass, array_regular[indexregular].hash, true);
            }
        } else
        {
            if (indexregular !== -1)
            {
//                array_regular[indexregular] = errorjson;

                array_regular.splice(indexregular, 1);

            }
            errorjson.index = 0;
            var hash_r = errorjson.hash;
            $("." + listclass).find("li#" + hash_r).hide("slide", {direction: "left"}, 1000, function () {
                $("." + listclass).find("li#" + hash_r).remove();
            });

        }
    } else
    {
        var indexspec = findeByhash(errorjson, array_spec);
        if (filtred)
        {

            if (indexspec === -1)
            {
                array_spec.push(errorjson);
                var index2 = findeByhash(errorjson, array_spec);
                if (index2 < array_spec.length - 1)
                {
                    drawUL(array_spec[index2], listclass, array_spec[index2 + 1].hash);
                } else
                {
                    drawUL(array_spec[index2], listclass, 0);
                }
            } else
            {
                array_spec[indexspec] = errorjson;
                drawUL(array_spec[indexspec], listclass, array_spec[indexspec].hash, true);
            }
        } else
        {
            if (indexspec !== -1)
            {
                array_spec.splice(indexspec, 1);
            }
            errorjson.index = 0;
            var hash_s = errorjson.hash;
            $("." + listclass).find("li#" + hash_s).fadeOut(400, function () {
                $("." + listclass).find("li#" + hash_s).remove();
            });

        }
    }
}

function DrawErrorList(listJson, table)
{
    array_regular = [];
    array_spec = [];

    for (var key in listJson) {
        var errorjson = listJson[key];
        var filtred = checkfilter(errorjson);

        if (filtred)
        {
            if (errorjson.isspec === 0)
            {
                array_regular.push(errorjson);
            } else
            {
                array_spec.push(errorjson);
            }
        } else
        {
            delete listJson[key];
        }
    }

    for (key in array_spec)
    {
        drawUL(array_spec[key], "monitorlist");
    }
    for (key in array_regular)
    {
        drawUL(array_regular[key], "monitorlist");
    }
    table.find('tbody input.rawflat').iCheck({
        checkboxClass: 'icheckbox_flat-green',
        radioClass: 'iradio_flat-green'
    });
}


function checkfilter(message)
{
    var filtred = true;

    for (var filterindex in optionsJson.v)
    {
        if ((filterindex === "allfilter") ||
                ((filterindex === "mlfilter") && (message.isspec === 0)) ||
                ((filterindex === "manualfilter") && (message.isspec !== 0))
                )
        {

            for (var fvalue in optionsJson.v[filterindex])
            {
                var filtervalue = optionsJson.v[filterindex][fvalue];
                var filterop = optionsJson.op[filterindex][fvalue];
                var path = fvalue.split(".");
                var value = message;
                $.each(path, function (i, item) {
                    value = value[item];
                });
                if (filterop === "=")
                {
                    filtred = filtervalue.indexOf("" + value) !== -1;
                } else if (filterop === "!")
                {
                    filtred = filtervalue.indexOf("" + value) === -1;
                } else if (filterop === "~")
                {
                    filtred = value.indexOf("" + filtervalue) !== -1;
                } else if (filterop === "!~")
                {
                    filtred = value.indexOf("" + filtervalue) === -1;
                } else if (filterop === "==")
                {
                    filtred = value === filtervalue;
                } else if (filterop === "!=")
                {
                    filtred = value !== filtervalue;
                } else
                {
                    console.log(value);
                    console.log(filterop);
                }
                if (!filtred)
                {
                    break;
                }

            }
        }
        if (!filtred)
        {
            break;
        }

    }
    return filtred;
}

$(document).ready(function () {

    $("body").on("click", "#apply_filter", function () {
        updateFilter();
        stompClient.send("/input/chagefilter/", {}, JSON.stringify(optionsJson));
        redrawBoard();
    });




    $("body").on("click", "#add_filter", function () {
        updateFilter();
        var sendData = {};
        url = cp + "/addmonitoringpage/";
        sendData.optionsjson = JSON.stringify(optionsJson);
        sendData.optionsname = $("#saveas_name").val();
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        $.ajax({
            dataType: 'json',
            type: 'POST',
            url: url,
            data: sendData,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            }
        }).done(function (msg) {
            if (msg.sucsses)
            {
                alert("Data Saved ");
            } else
            {
                alert("Request failed");
            }
        }).fail(function (jqXHR, textStatus) {
            alert("Request failed");
        });

    });

    $("body").on("click", "#save_filter", function () {
        updateFilter();
        var sendData = {};
        url = cp + "/addmonitoringpage/";
        sendData.optionsjson = JSON.stringify(optionsJson);
        sendData.optionsname = nameoptions;
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        $.ajax({
            dataType: 'json',
            type: 'POST',
            url: url,
            data: sendData,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            }
        }).done(function (msg) {
            if (msg.sucsses)
            {
                alert("Data Saved ");
            } else
            {
                alert("Request failed");
            }
        }).fail(function (jqXHR, textStatus) {
            alert("Request failed");
        });

    });


    $("body").on("click", "#rem_filter", function () {
        url = cp + "/deletemonitoringpage/";
        sendData = {optionsname: nameoptions};
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        $.ajax({
            dataType: 'json',
            type: 'POST',
            url: url,
            data: sendData,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            }
        }).done(function (msg) {
            if (msg.sucsses)
            {
                window.location = cp + "/monitoring/";
            } else
            {
                alert("Request failed");
            }
        }).fail(function (jqXHR, textStatus) {
            alert("Request failed");
        });

    });

    setInterval(function () {
        $(".monitorlist li ul li").each(function () {
            var interval = moment($(this).attr("time") * 1).diff(moment()) / -1000;
//            if ((interval > 10) || (interval < 0))
//            {
//                $(this).find(".timeinterval").css("background-color", "#f00");
//            } else
//            {
            $(this).find(".timeinterval").removeAttr("style");
//            }
            $(this).find(".timeinterval").text(interval.toFixed(0));
        });
    }, 1000);
    $("body").on("change", ".add_filter_select", function () {
        $(this).find(':selected').attr("disabled", "disabled");
        var row = $("<tr>");
        row.append("<td class='filter_label'>" + $(this).find(':selected').attr("fname") + "</td>");
        if ($(this).find(':selected').attr("value") === 'level')
        {

            row.append('<td class="action"><select class="operators_' + $(this).find(':selected').attr("value") + '" name="op[' + $(this).attr("id") + "_" + $(this).find(':selected').attr("value") + ']">' + eniumop + '</select> </td>');
            row.append('<td class="value"><select class="value" id="values_' + $(this).find(':selected').attr("value") + '_1" name="v[' + $(this).attr("id") + "_" + $(this).find(':selected').attr("value") + '][]" multiple="multiple" size="4"><option value="0">All</option><option value="1">Low</option><option value="2">Guarded</option><option value="3">Elevated</option><option value="4">High</option><option value="5">Severe</option></select></td>');
        } else
        {
            row.append("<td class='action'> <select class='operators_subject' name='op[" + $(this).attr("id") + "_" + $(this).find(':selected').attr("value") + "]' tagkey='" + $(this).find(':selected').attr("value") + "'>" + strop + " </select> </td>");
            row.append("<td class='value'><input class='filter-value' type='text' name='v[" + $(this).attr("id") + "_" + $(this).find(':selected').attr("value") + "]' tagkey='" + $(this).find(':selected').attr("value") + "' autocomplete='off'></td>");

        }


        $(this).parents(".filter").find(".filters-table").append(row);
        //filters-table
        $(this).find('option').prop('selected', function () {
            return this.defaultSelected;
        });
        $("select").select2({minimumResultsForSearch: 15});
    });
    if (optionsJson === null)
    {
        var levels = [];
        for (var Oldindex in filterOldJson)
        {
            var filteritem = filterOldJson[Oldindex];

            if (Oldindex.indexOf("check_") !== -1)
            {

                if (Oldindex.indexOf("check_level_") !== -1)
                {
                    levels.push(Oldindex.replace("check_level_", ""));
                } else
                {
                    var row = $("<tr>");
                    var name = Oldindex.replace("check_", "");
                    var opt = $(".all_filter .add_filter_select option[alias=" + name + "]:first");
                    opt.attr("disabled", "disabled");
                    row.append("<td class='filter_label'>" + opt.attr("fname") + "</td>");

                    row.append("<td class='action'> <select class='operators_subject' name='op[" + $(".all_filter .add_filter_select").attr("id") + "_" + opt.attr("value") + "]' tagkey='" + opt.attr("value") + "'>" + strop + " </select> </td>");
                    row.append("<td class='value'><input class='filter-value' type='text' name='v[" + $(".all_filter .add_filter_select").attr("id") + "_" + opt.attr("value") + "]' tagkey='" + opt.attr("value") + "' autocomplete='off' value=" + filterOldJson[name + "_input"] + "></td>");
                    $(".all_filter").find(".filters-table").append(row);
                }

            }

        }
        if (levels.length > 0)
        {
            var row = $("<tr>");
            var name = "level";
            var opt = $(".all_filter .add_filter_select option[value=" + name + "]:first");
            opt.attr("disabled", "disabled");
            row.append("<td class='filter_label'>" + opt.attr("fname") + "</td>");
            $(".all_filter").find(".filters-table").append(row);

            row.append('<td class="action"><select tagkey="' + opt.attr("value") + '" class="operators_' + opt.attr("value") + '" name="op[' + $(".all_filter .add_filter_select").attr("id") + "_" + opt.attr("value") + ']">' + eniumop + '</select> </td>');
            row.append('<td class="value"><select tagkey="' + opt.attr("value") + '"class="value" id="values_' + opt.attr("value") + '_1" name="v[' + $(".all_filter .add_filter_select").attr("id") + "_" + opt.attr("value") + '][]" multiple="multiple" size="4">' +
                    '<option value="0" ' + (levels.indexOf("0") !== -1 ? ' selected="selected" ' : "") + '>All</option>' +
                    '<option value="1" ' + (levels.indexOf("1") !== -1 ? ' selected="selected" ' : "") + '>Low</option>' +
                    '<option value="2" ' + (levels.indexOf("2") !== -1 ? ' selected="selected" ' : "") + '>Guarded</option>' +
                    '<option value="3" ' + (levels.indexOf("3") !== -1 ? ' selected="selected" ' : "") + '>Elevated</option>' +
                    '<option value="4" ' + (levels.indexOf("4") !== -1 ? ' selected="selected" ' : "") + '>High</option>' +
                    '<option value="5" ' + (levels.indexOf("5") !== -1 ? ' selected="selected" ' : "") + ' >Severe</option>' +
                    '</select></td>');
        }
        $(".card-fields.value .f_col option").prop('selected', 'selected');

        updateFilter();

    } else
    {
        optionsJson.f_col.forEach(function (entry) {
            $(".card-fields.value .f_col option[value=" + entry + "]").prop('selected', 'selected');
        }
        );
        for (var section in optionsJson.v)
        {
            var Domsection = $(".add_filter_select#" + section).parents(".filter");
            for (var filter in optionsJson.v[section])
            {

                if (filter === "level")
                {
                    levels = optionsJson.v[section][filter];
                    var row = $("<tr>");
                    var name = "level";
                    var opt = Domsection.find(".add_filter_select option[value=" + name + "]:first");
                    opt.attr("disabled", "disabled");
                    row.append("<td class='filter_label'>" + opt.attr("fname") + "</td>");
                    Domsection.find(".filters-table").append(row);

                    row.append('<td class="action"><select tagkey="' + opt.attr("value") + '" class="operators_' + opt.attr("value") + '" name="op[' + Domsection.find(".add_filter_select").attr("id") + "_" + opt.attr("value") + ']">' + eniumop + '</select> </td>');
                    row.find(".action option[value='" + optionsJson.op[section][filter] + "']").prop('selected', 'selected');
                    row.append('<td class="value"><select tagkey="' + opt.attr("value") + '"class="value" id="values_' + opt.attr("value") + '_1" name="v[' + Domsection.find(".add_filter_select").attr("id") + "_" + opt.attr("value") + '][]" multiple="multiple" size="4">' +
                            '<option value="0" ' + (levels.indexOf("0") !== -1 ? ' selected="selected" ' : "") + '>All</option>' +
                            '<option value="1" ' + (levels.indexOf("1") !== -1 ? ' selected="selected" ' : "") + '>Low</option>' +
                            '<option value="2" ' + (levels.indexOf("2") !== -1 ? ' selected="selected" ' : "") + '>Guarded</option>' +
                            '<option value="3" ' + (levels.indexOf("3") !== -1 ? ' selected="selected" ' : "") + '>Elevated</option>' +
                            '<option value="4" ' + (levels.indexOf("4") !== -1 ? ' selected="selected" ' : "") + '>High</option>' +
                            '<option value="5" ' + (levels.indexOf("5") !== -1 ? ' selected="selected" ' : "") + ' >Severe</option>' +
                            '</select></td>');
                } else
                {
                    var row = $("<tr>");
                    var name = filter;
                    var opt = Domsection.find(".add_filter_select option[value='" + name + "']:first");
                    opt.attr("disabled", "disabled");
                    row.append("<td class='filter_label'>" + opt.attr("fname") + "</td>");

                    row.append("<td class='action'> <select class='operators_subject' name='op[" + Domsection.find(".add_filter_select").attr("id") + "_" + opt.attr("value") + "]' tagkey='" + opt.attr("value") + "'>" + strop + " </select> </td>");
                    row.append("<td class='value'><input class='filter-value' type='text' name='v[" + Domsection.find(".add_filter_select").attr("id") + "_" + opt.attr("value") + "]' tagkey='" + opt.attr("value") + "' autocomplete='off' value=" + optionsJson.v[section][filter] + "></td>");
                    row.find(".action option[value='" + optionsJson.op[section][filter] + "']").prop('selected', 'selected');
                    Domsection.find(".filters-table").append(row);
                }
            }

        }
    }

//    redrawBoard();
    $('body').on("click", 'fieldset.collapsible legend', function () {
        if ($(this).parent().hasClass("collapsed"))
        {
            $(this).parent().removeClass("collapsed");
            $(this).find(".fa-chevron-down").addClass("fa-chevron-up");
            $(this).parent().find(".fa-chevron-down").removeClass("fa-chevron-down");
            $(this).parent().find("select").select2({minimumResultsForSearch: 15});
        } else
        {
            $(this).parent().addClass("collapsed");
            $(this).find(".fa-chevron-up").addClass("fa-chevron-down");
            $(this).find(".fa-chevron-up").removeClass("fa-chevron-up");

        }
    });

    $("select").select2({minimumResultsForSearch: 15});

    connectstompClient();

});

function updateFilter() {
    var formData = $("form.form-options").serializeArray();
    optionsJson = {};
    const regex = /[a-zA-Z.]+/g;
    jQuery.each(formData, function (i, field) {
        if (field.value !== "")
        {
            var name = field.name;

            if (field.name.indexOf("op[") !== -1)
            {
                name = "op";
                if (!optionsJson[name])
                {
                    optionsJson[name] = {};
                }
                var m = field.name.match(regex);


                var fgroup = m[1];
                var fname = m[2];
                if (!optionsJson[name][fgroup])
                {
                    optionsJson[name][fgroup] = {};
                }
                optionsJson[name][fgroup][fname] = field.value;


            } else if (field.name.indexOf("v[") !== -1)
            {
                name = "v";
                if (!optionsJson[name])
                {
                    optionsJson[name] = {};
                }
                if (field.name.indexOf("[]") !== -1)
                {
                    var lname = field.name.replace("[]", "");
                    var m = lname.match(regex);
                    var fgroup = m[1];
                    var fname = m[2];

                    if (!optionsJson[name][fgroup])
                    {
                        optionsJson[name][fgroup] = {};
                    }
                    if (!optionsJson[name][fgroup][fname])
                    {
                        optionsJson[name][fgroup][fname] = [];
                    }
                    optionsJson[name][fgroup][fname].push(field.value);
                } else
                {
                    var m = field.name.match(regex);
                    var fgroup = m[1];
                    var fname = m[2];
                    if (!optionsJson[name][fgroup])
                    {
                        optionsJson[name][fgroup] = {};
                    }
                    optionsJson[name][fgroup][fname] = field.value;
                }


            } else
            {
                if (field.name.indexOf("[]") !== -1)
                {
                    lname = field.name.replace("[]", "");
                    if (!optionsJson[lname])
                    {
                        optionsJson[lname] = [];
                    }
                    optionsJson[lname].push(field.value);
                } else
                {
                    optionsJson[field.name] = field.value;
                }

            }

        }
    });
}