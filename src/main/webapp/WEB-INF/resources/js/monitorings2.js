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
function redrowtable() {
    $(".metrictable thead").html("<tr>");
    $(".metrictable tbody").html('<tr class="wait"><td>Please wait...</td></tr>');
    $('input[name^=f_col]:checked').each(function () {
        switch (this.value) {
            case 'actions':
            {
                $(".metrictable thead tr").append(
                        '<th class="actions">' +
                        '<input type="checkbox" id="check-all" class="flat">' +
                        '<div class="btn-group">' +
                        '<button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">' +
                        '<span class="caret"></span>' +
                        '<span class="sr-only">Toggle Dropdown</span>' +
                        '</button>' +
                        '<ul class="dropdown-menu" role="menu">' +
                        '<li><a href="#" id="Show_chart">Show Chart</a>' +
                        '</li>' +
                        '<li class="divider"></li>' +
                        '<li><a href="#" id="Clear_reg">Clear Regression</a>' +
                        '</li>' +
                        '</ul>' +
                        '</div>' +
                        '</th>');
                break
            }
            case 'tags':
            {
                $('input[name^=f_tags]:checked').each(function () {
                    $(".metrictable thead tr").append("<th>" + this.value + "</th>");
                });
                break;
            }
            default:
            {
                $(".metrictable thead tr").append("<th>" + this.value + "</th>");
                break;
            }
        }
        $(".metrictable tbody tr.wait td").attr("colspan", $(".metrictable thead tr th").length);
//        console.log(this.value);
    }
    );
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

    var levels = optionsJson.v["allfilter"]["level"];
//    jQuery.each(formData, function (i, field) {
//        if (field.value === "on")
//        {
//            if (field.name.indexOf("check_level_") === 0)
//            {
//                levels.push(field.name.replace("check_level_", ""));
//            }
//        }
//    });

    headers["levels"] = levels;
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
                console.log("monitor connected");
                stompClient.subscribe('/user/' + uuid + '/' + sotoken + '/errors', aftersubscribe);
//                console.log(frame);
            },
            function (message) {
                console.log("Monitor:" + message);
                setTimeout(function () {
                    realtimeconnect(head);
                }, 60000);
            });
}

function aftersubscribe(error) {
    $(".metrictable").find("tr.wait").remove();
    var errorjson = JSON.parse(error.body);
    console.log("aaaaa");
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
            reDrawErrorList(errorlistJson, $(".metrictable"), errorjson);
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
        reDrawErrorList(errorlistJson, $(".metrictable"), errorjson);

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

function drawRaw(errorjson, table, hashindex, update) {
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
    var trclass = "level_" + errorjson.level;
    if (errorjson.isspec !== 0)
    {
        trclass = trclass + " spec";
    }

    if (errorjson.flap > 5)
    {
        trclass = trclass + " flapdetect";
    }

    if (!update)
    {
        var html = "";
        html = html + '<tr id="' + errorjson.hash + '" class="' + trclass + '" time="' + errorjson.time + '">';
        if (document.getElementById("f_col_actions").checked)
        {
            if (errorjson.isspec === 0)
            {
                html = html + '<td class="icons"><input type="checkbox" class="rawflat" name="table_records"><div class="fa-div"> <a href="' + cp + '/chart/' + errorjson.hash + '" target="_blank"><i class="fa fa-area-chart"></i></a><a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a> <i class="action fa ' + arrowclass + '" style="color:' + color + ';"></i></div></td>';
            } else
            {
                html = html + '<td><div class="fa-div"><i class="fa fa-bell"></i> <a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a></div></td>';
            }
        }
        if (document.getElementById("f_col_level").checked)
        {
            html = html + '<td class="level"><div>' + errorjson.levelname + '</div></td>';
        }
        if (document.getElementById("f_col_name").checked)
        {
            if (errorjson.isspec === 0)
            {
                html = html + '<td><a href="' + cp + '/metriq/' + errorjson.hash + '" target="_blank">' + errorjson.info.name + '</a></td>';
            } else
            {
                html = html + '<td>' + errorjson.info.name + '</td>';
            }
        }
        if (document.getElementById("f_col_tags").checked)
        {
            $('input[name^=f_tags]:checked').each(function () {
                if (errorjson.info.tags[$(this).attr("key")])
                {
                    html = html + '<td>' + errorjson.info.tags[$(this).attr("key")].value + '</td>';
                } else
                {
                    html = html + '<td>NaN</td>';
                }

            });
        }

        if (document.getElementById("f_col_info").checked)
        {
            if (errorjson.isspec === 0)
            {
                var valuearrowclass = "fa-long-arrow-down";
                if (errorjson.upstate)
                {
                    valuearrowclass = "fa-long-arrow-up";
                }
                html = html + '<td class="message"><i class="action fa ' + valuearrowclass + '"></i> ' + message + '</td>';
            } else
            {
                html = html + '<td class="message">' + message + '</td>';
            }
        }
        var st = errorjson.starttimes[errorjson.level] ? errorjson.starttimes[errorjson.level] : errorjson.time;
        if (document.getElementById("f_col_sttime").checked)
        {
            html = html + '<td class="starttime">' + moment(st * 1).format(timeformat) + '</td>';
        }
        if (document.getElementById("f_col_lasttime").checked)
        {
            html = html + '<td class="timelocal" >' + moment().format(timeformatsmall) + '</td>';
        }

//        html = html + '<td class="timech" time="' + errorjson.time + '">' + starttime + '</td>';


        html = html + '</tr>';
        if (hashindex === null)
        {
            table.find("tbody").append(html);
        } else
        {
            if (hashindex === 0)
            {
                if (table.find("tbody tr").first().length === 0)
                {
                    table.find("tbody").append(html);
                } else
                {
                    table.find("tbody tr").first().before(html);
                }

            } else
            {
                table.find("tbody tr#" + hashindex).before(html);
            }
        }
        table.find("tbody tr#" + errorjson.hash + " input.rawflat").iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });
    } else
    {
        table.find("tbody tr#" + hashindex).attr("class", trclass);
        table.find("tbody tr#" + hashindex + " .level div").html(errorjson.levelname);
        if (errorjson.starttimes[errorjson.level])
        {
            table.find("tbody tr#" + hashindex + " .starttime").html(moment(errorjson.starttimes[errorjson.level] * 1).format(timeformat));
        }

        table.find("tbody tr#" + hashindex + " .timelocal").html(moment().format(timeformatsmall));
//        table.find("tbody tr#" + hashindex + " .timech").html(starttime + " (" + (errorjson.time - table.find("tbody tr#" + hashindex).attr('time')) + " Repeat " + errorjson.index + ")");
//        table.find("tbody tr#" + hashindex + " .timech").append("<div>" + starttime + ": " + (errorjson.time - table.find("tbody tr#" + hashindex).attr('time')) / 1000 + " " + errorjson.index + "</div>");
        table.find("tbody tr#" + hashindex).attr('time', errorjson.time);
        if (errorjson.isspec === 0)
        {
            var valuearrowclass = "fa-long-arrow-down";
            if (errorjson.upstate)
            {
                valuearrowclass = "fa-long-arrow-up";
            }
            table.find("tbody tr#" + hashindex + " .message").html('<i class="action fa ' + valuearrowclass + '"></i> ' + message);
        } else
        {
            table.find("tbody tr#" + hashindex + " .message").html(message);
        }

//        table.find("tbody tr#" + hashindex + " .message").html(message);
        if (arrowclass !== "")
        {
            table.find("tbody tr#" + hashindex + " .icons i.action").attr("class", "action fa " + arrowclass);
            table.find("tbody tr#" + hashindex + " .icons i.action").css("color", color);
        }

    }
    $('.summary .Tablecount').html(table.find("tbody tr").length);
    $('.summary .regcount').html(array_regular.length);
    $('.summary .Speccount').html(array_spec.length);
}

function reDrawErrorListold(listJson, table, errorjson)
{
//    console.log("length " + Object.keys(listJson).length);
//    var elems = document.getElementById("check_level_" + errorjson.level);
    var elems = document.querySelectorAll('[name=check_level_' + errorjson.level + ']');
    elems = elems[0];
    console.log(elems);

    var filtred = true;
    if ((typeof elems !== "undefined") & (elems !== null))
    {
        if (elems.checked)
        {
            filtred = true;
            var filterelems = document.querySelectorAll('.filter-switch');
            for (var i = 0; i < filterelems.length; i++) {
                if (filterelems[i].checked)
                {
                    var filter = $("[name=" + filterelems[i].value + "_input]").val();
                    var regex = new RegExp(filter, 'i');
                    if (filterelems[i].value === "metric")
                    {
                        filtred = regex.test(errorjson.info.name);
                    } else
                    {
                        if (errorjson.info.tags[filterelems[i].value])
                        {
                            filtred = regex.test(errorjson.info.tags[filterelems[i].value].value);
                        }

                    }
                    if (!filtred)
                    {
                        delete listJson[errorjson.hash];
                        break;
                    }
                }
            }
            ;
        } else
        {
            delete listJson[errorjson.hash];
        }
    }
    if (errorjson.isspec === 0)
    {
        var indexregular = findeByhash(errorjson, array_regular);
        if (filtred)
        {
            if (indexregular === -1)
            {
                array_regular.push(errorjson);
//                array_regular.sort(function (a, b) {
//                    var tagident = $("select#ident_tag").val();
//                    return compareMetric(a, b, tagident);
//                });
                var index2 = findeByhash(errorjson, array_regular);
//                console.log(array_regular);
                if (index2 < array_regular.length - 1)
                {
                    drawRaw(array_regular[index2], table, array_regular[index2 + 1].hash);
                } else
                {
                    drawRaw(array_regular[index2], table);
                }
            } else
            {
                array_regular[indexregular] = errorjson;
                drawRaw(array_regular[indexregular], table, array_regular[indexregular].hash, true);
            }
        } else
        {
            if (indexregular !== -1)
            {
//                array_regular[indexregular] = errorjson;
                errorjson.index = 0;
                var hash_r = errorjson.hash;
                array_regular.splice(indexregular, 1);
                table.find("tbody tr#" + hash_r).fadeOut(400, function () {
                    table.find("tbody tr#" + hash_r).remove();
                });
            }
        }
    } else
    {
        var indexspec = findeByhash(errorjson, array_spec);
        if (filtred)
        {

            if (indexspec === -1)
            {
                array_spec.push(errorjson);
//                array_spec.sort(function (a, b) {
//                    var tagident = $("select#ident_tag").val();
//                    return compareMetric(a, b, tagident);
//                });

                var index2 = findeByhash(errorjson, array_spec);
                if (index2 < array_spec.length - 1)
                {
                    drawRaw(array_spec[index2], table, array_spec[index2 + 1].hash);
                } else
                {
                    drawRaw(array_spec[index2], table, 0);
                }
            } else
            {
                array_spec[indexspec] = errorjson;
                drawRaw(array_spec[indexspec], table, array_spec[indexspec].hash, true);
            }
        } else
        {
            if (indexspec !== -1)
            {
//                array_spec[indexspec] = errorjson;
                errorjson.index = 0;
                var hash_s = errorjson.hash;
                array_spec.splice(indexspec, 1);
                table.find("tbody tr#" + hash_s).fadeOut(400, function () {
                    table.find("tbody tr#" + hash_s).remove();
                });
            }

        }
    }
}

function reDrawErrorList(listJson, table, errorjson)
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
                    drawRaw(array_regular[index2], table, array_regular[index2 + 1].hash);
                } else
                {
                    drawRaw(array_regular[index2], table);
                }
            } else
            {
                array_regular[indexregular] = errorjson;
                drawRaw(array_regular[indexregular], table, array_regular[indexregular].hash, true);
            }
        } else
        {
            if (indexregular !== -1)
            {
//                array_regular[indexregular] = errorjson;
                errorjson.index = 0;
                var hash_r = errorjson.hash;
                array_regular.splice(indexregular, 1);
                table.find("tbody tr#" + hash_r).fadeOut(400, function () {
                    table.find("tbody tr#" + hash_r).remove();
                });
            }
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
                    drawRaw(array_spec[index2], table, array_spec[index2 + 1].hash);
                } else
                {
                    drawRaw(array_spec[index2], table, 0);
                }
            } else
            {
                array_spec[indexspec] = errorjson;
                drawRaw(array_spec[indexspec], table, array_spec[indexspec].hash, true);
            }
        } else
        {
            if (indexspec !== -1)
            {
                errorjson.index = 0;
                var hash_s = errorjson.hash;
                array_spec.splice(indexspec, 1);
                table.find("tbody tr#" + hash_s).fadeOut(400, function () {
                    table.find("tbody tr#" + hash_s).remove();
                });
            }

        }
    }    
}

function DrawErrorList(listJson, table)
{
    $(".metrictable").find("tr.wait").remove();
    array_regular = [];
    array_spec = [];
    console.log(optionsJson);
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
        drawRaw(array_spec[key], table);
    }
    for (key in array_regular)
    {
        drawRaw(array_regular[key], table);
    }
    table.find('tbody input.rawflat').iCheck({
        checkboxClass: 'icheckbox_flat-green',
        radioClass: 'iradio_flat-green'
    });
}


function checkfilter(value)
{
    var filtred = true;

    for (var filterindex in optionsJson.v)
    {

        if ((filterindex === "allfilter") ||
                ((filterindex === "mlfilter") && (errorjson.isspec === 0)) ||
                ((filterindex === "manualfilter") && (errorjson.isspec !== 0))
                )
        {
            for (var fvalue in optionsJson.v[filterindex])
            {
                var filtervalue = optionsJson.v[filterindex][fvalue];
                var filterop = optionsJson.op[filterindex][fvalue];
                var path = fvalue.split(".");
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
    redrowtable();
    $("body").on("click", "#apply_filter", function () {
        updateFilter();
        redrowtable();
    });

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
            row.append("<td class='value'><input class='' type='text' name='v[" + $(this).attr("id") + "_" + $(this).find(':selected').attr("value") + "]' tagkey='" + $(this).find(':selected').attr("value") + "' autocomplete='off'></td>");

        }


        $(this).parents(".filter").find(".filters-table").append(row);
        //filters-table
        $(this).find('option').prop('selected', function () {
            return this.defaultSelected;
        });
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
                    row.append("<td class='value'><input class='' type='text' name='v[" + $(".all_filter .add_filter_select").attr("id") + "_" + opt.attr("value") + "]' tagkey='" + opt.attr("value") + "' autocomplete='off' value=" + filterOldJson[name + "_input"] + "></td>");
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

        updateFilter();

    } else
    {

    }
    
//    $("select").select2({minimumResultsForSearch: 15});

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

//                    if (!optionsJson[name][fgroup])
//                    {
//                        optionsJson[name][fgroup] = {};
//                    }
//                    optionsJson[name][fgroup][fname] = field.value;                    

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
                    if (!optionsJson[name])
                    {
                        optionsJson[name] = [];
                    }
                    optionsJson[name].push(field.value);
                } else
                {
                    optionsJson[field.name] = field.value;
                }

            }

        }
    });
}