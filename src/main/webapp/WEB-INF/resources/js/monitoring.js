/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global moment, cp, headerName, token, uuid, sotoken */

var stompClient = null;
var timeformat = "DD/MM HH:mm:ss";
var timeformatsmall = "HH:mm:ss";
var errorlistJson = {};
var array_regular = [];
var array_spec = [];
function findeByhash(element, array) {
    for (var i = 0; i < array.length; i++) {
        if (array[i].hash === element.hash) {
            return i;
        }
    }
    return -1;
}
function reDrawErrorList(listJson, table, errorjson)
{
    var elems = document.getElementById("check_level_" + errorjson.level);
    var filtred = false;
    if (elems !== null)
    {
        if (elems.checked)
        {
            filtred = true;
            var filterelems = document.querySelectorAll('.filter-switch');
            for (var i = 0; i < filterelems.length; i++) {
                if (filterelems[i].checked)
                {
                    var filter = $("#" + filterelems[i].value + "_input").val();
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
                        break;
                    }
                }
            }
            ;
        }
    }
    if (errorjson.isspec === 0)
    {
        var index = findeByhash(errorjson, array_regular);
        if (filtred)
        {
            if (index === -1)
            {
                array_regular.push(errorjson);
                array_regular.sort(function (a, b) {
                    var tagident = $("select#ident_tag").val();
                    return compareMetric(a, b, tagident);
                });
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
                array_regular[index] = errorjson;
                drawRaw(array_regular[index], table, array_regular[index].hash, true);
            }
        } else
        {
            if (index !== -1)
            {
                array_regular[index] = errorjson;
                table.find("tbody tr#" + errorjson.hash).fadeOut(400, function () {
                    table.find("tbody tr#" + errorjson.hash).remove();
                    errorjson.index = 0;
                    array_regular.splice(index, 1);
                });
            }
        }
    } else
    {
        var index = findeByhash(errorjson, array_spec);
        if (filtred)
        {
            if (index === -1)
            {
                array_spec.push(errorjson);
                array_spec.sort(function (a, b) {
//                    return compareStrings(a.info.tags[$("select#ident_tag").val()].value, b.info.tags[$("select#ident_tag").val()].value);
                    var tagident = $("select#ident_tag").val();
                    return compareMetric(a, b, tagident);
                });
                var index2 = findeByhash(errorjson, array_spec);
//                console.log(index2);
                if (index2 < array_spec.length - 1)
                {
                    drawRaw(array_spec[index2], table, array_spec[index2 + 1].hash);
                } else
                {
                    drawRaw(array_spec[index2], table, 0);
                }
            } else
            {
                array_spec[index] = errorjson;
                drawRaw(array_spec[index], table, array_spec[index].hash, true);
            }
        } else
        {

            if (index !== -1)
            {
                array_spec[index] = errorjson;
                table.find("tbody tr#" + errorjson.hash).fadeOut(400, function () {
                    table.find("tbody tr#" + errorjson.hash).remove();
                    errorjson.index = 0;
                    array_spec.splice(index, 1);
                });
            }

        }
    }
}
function DrawErrorList(listJson, table)
{
// console.log(Object.keys(listJson).length);
    $("select").attr('disabled', true);
    table.find("tbody").html("");
    array_regular = [];
    array_spec = [];
    for (var key in listJson) {
        var errorjson = listJson[key];
        var elems = document.getElementById("check_level_" + errorjson.level);
        filtred = true;
        if (elems !== null)
        {
            if (elems.checked)
            {
                filterelems = document.querySelectorAll('.filter-switch');
                for (var i = 0; i < filterelems.length; i++) {
                    if (filterelems[i].checked)
                    {
                        var filter = $("#" + filterelems[i].value + "_input").val();
                        regex = new RegExp(filter, 'i');
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
                            break;
                        }
                    }
                }
                ;
                if (filtred)
                {
                    if (errorjson.isspec === 0)
                    {
                        array_regular.push(errorjson);
                    } else
                    {
                        array_spec.push(errorjson);
                    }
                }
            } else
            {
                delete listJson[key];
            }
        }
    }
    array_spec.sort(function (a, b) {
        var tagident = $("select#ident_tag").val();
        return compareMetric(a, b, tagident);
    });
    array_regular.sort(function (a, b) {
        var tagident = $("select#ident_tag").val();
        return compareMetric(a, b, tagident);
    });    
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
    $("select").attr('disabled', false);
}
function drawRaw(errorjson, table, hashindex = null, update = false) {
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
        }
        val = val / count;
        if (val > 1000)
        {
            val = format_metric(errorjson.values[key].value);
        } else
        {
            val = val.toFixed(2);
        }
        message = message + "<span class='pull-left level' >" + val + "</span>";
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
        trclass = "spec";
    }

    if (!update)
    {
//        if (arrowclass === "")
//        {
//            arrowclass = "fa-long-arrow-up";
//            color = "red";
//        }
        var html = "";
        html = html + '<tr id="' + errorjson.hash + '" class="' + trclass + '">';
        if (errorjson.isspec === 0)
        {
            html = html + '<td class="icons"><input type="checkbox" class="rawflat" name="table_records"><div class="fa-div"> <a href="' + cp + '/chart/' + errorjson.hash + '" target="_blank"><i class="fa fa-area-chart"></i></a><i class="action fa ' + arrowclass + '" style="color:' + color + ';"></i></div></td>';
        } else
        {
            html = html + '<td><i class="fa fa-bell" style="color:red; font-size: 18px;"></i></td>';
        }
        html = html + '<td class="level"><div>' + errorjson.levelname + '</div></td>';
        html = html + '<td>' + errorjson.info.name + '</td>';
        html = html + '<td>' + errorjson.info.tags[$("select#ident_tag").val()].value + '</td>';
        html = html + '<td class="message">' + message + '</td>';
        html = html + '<td class="">' + moment(errorjson.starttimes[errorjson.level] * 1).format(timeformat) + '</td>';
        html = html + '<td class="timech" time="' + errorjson.time + '">' + starttime + '</td>';
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
//        console.log((table.find("tbody tr#" + index + " .timech").attr('time')-errorjson.time));
        table.find("tbody tr#" + hashindex + " .timech").html(starttime + " (" + (errorjson.time - table.find("tbody tr#" + hashindex + " .timech").attr('time')) / 1000 + " Sec. Repeat " + errorjson.index + ")");
//        table.find("tbody tr#" + index + " .timech").append("<div>" + starttime + ": " + (errorjson.time - table.find("tbody tr#" + index + " .timech").attr('time')) / 1000 + " " + errorjson.index + "</div>")
        table.find("tbody tr#" + hashindex + " .timech").attr('time', errorjson.time);
        table.find("tbody tr#" + hashindex + " .message").html(message);
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

var beginlisen = false;
function startlisen()
{
    if (!beginlisen)
    {
        beginlisen = true;
        var formData = $("form.form-filter").serializeArray();
        for (var ind in switcherylist)
        {
            switcherylist[ind].disable();
        }
        var url = cp + "/startlisener";
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        var sendData = {};
        sendData.levels = [];
        jQuery.each(formData, function (i, field) {
            if (field.value === "on")
            {
                if (field.name.indexOf("check_level_") === 0)
                {
                    sendData.levels.push(field.name.replace("check_level_", ""));
                }
            }
        });
        sendData.sotoken = sotoken;
        $.ajax({
            dataType: 'json',
            type: 'POST',
            url: url,
            data: sendData,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            }
        }).done(function (msg) {
            beginlisen = false;
            for (var ind in switcherylist)
            {
                switcherylist[ind].enable();
            }
        });
    }
}
var switcherylist = [];
$(document).ready(function () {
    $(".timech").each(function () {
        val = $(this).html();
        time = moment(parseFloat(val));
        $(this).html(time.format(timeformat));
    });
    $('.autocomplete-append-metric').each(function () {
        var input = $(this);
        var uri = cp + "/getfiltredmetricsnames?filter=^(.*)$";
        $.getJSON(uri, null, function (data) {
            input.autocomplete({
                lookup: data.data,
                appendTo: '.autocomplete-container-metric'
            });
        });
    });
    $('.autocomplete-append').each(function () {
        var input = $(this);
        var uri = cp + "/gettagvalue?key=" + input.attr("tagkey") + "&filter=^(.*)$";
        $.getJSON(uri, null, function (data) {
            input.autocomplete({
                lookup: data.data,
                appendTo: '.autocomplete-container_' + input.attr("tagkey")
            });
        });
    });
    var elems = document.querySelectorAll('.js-switch-small');
    for (var i = 0; i < elems.length; i++) {
        if (typeof (filterJson[elems[i].id]) !== "undefined")
            if (filterJson[elems[i].id] !== "")
            {
                if (!elems[i].checked)
                    $(elems[i]).trigger('click');
            } else
            {
                if (elems[i].checked)
                    $(elems[i]).trigger('click');
            }
        var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        switcherylist.push(switchery);
        elems[i].onchange = function () {
            DrawErrorList(errorlistJson, $(".metrictable"));
        };
    }
    var first = true;
    $("body").on("change", ".js-switch-small", function () {
        if (!first)
        {
            startlisen();
            first = true;
        } else
        {
            first = false;
        }
    });
    $("body").on("blur", ".filter-input", function () {
        DrawErrorList(errorlistJson, $(".metrictable"));
    });
    $(".filter-input").each(function () {
        $(this).val(filterJson[$(this).attr("name")]);
    });
//    DrawErrorList(errorlistJson, $(".metrictable"));

    var socket = new SockJS(cp + '/subscribe');
    var stompClient = Stomp.over(socket);
    stompClient.debug = null;
    var headers = {};
    headers[headerName] = token;
    stompClient.connect(headers, function (frame) {
        stompClient.subscribe('/user/' + uuid + '/' + sotoken + '/errors', function (error) {
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

            if (errorjson.level === -1)
            {
                delete errorlistJson[errorjson.hash];
            } else
            {
                errorlistJson[errorjson.hash] = errorjson;
            }
            reDrawErrorList(errorlistJson, $(".metrictable"), errorjson);
        });
    });
    startlisen();
    $(window).bind('beforeunload', function () {
        var url = cp + "/stoplisener";
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        var sendData = {};
        sendData.sotoken = sotoken;
        $.ajax({
            dataType: 'json',
            type: 'POST',
            url: url,
            data: sendData,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            }
        });
    });
    $('body').on("change", "#ident_tag", function () {
        DrawErrorList(errorlistJson, $(".metrictable"));
    });
    $('body').on("click", "#Default", function () {
        var formData = $("form.form-filter").serializeArray();
        filterJson = {};
        jQuery.each(formData, function (i, field) {
            if (field.value !== "")
            {
                filterJson[field.name] = field.value;
            }
        });
        var sendData = {};
        sendData.filter = JSON.stringify(filterJson);
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        url = cp + "/savefilter";
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
    }
    );
    $('body').on("click", "#Clear_reg", function () {
        $(".bulk_action tbody input[name='table_records']:checked").each(function () {
            var sendData = {};
            sendData.hash = $(this).parents("tr").attr("id");
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            url = cp + "/resetregression";
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
                    console.log("Message Sended ");
                } else
                {
                    console.log("Request failed");
                }
            }).fail(function (jqXHR, textStatus) {
                console.log("Request failed");
            });
        });
    });
    $('body').on("click", "#Show_chart", function () {
        hashes = "";
        if ($(".bulk_action tbody input[name='table_records']:checked").length === 1)
        {
            hashes = "/" + $(".bulk_action tbody input[name='table_records']:checked").first().parents("tr").attr("id");
        } else
        {
            hashes = "?hashes=";
            $(".bulk_action tbody input[name='table_records']:checked").each(function () {
                hashes = hashes + $(this).parents("tr").attr("id") + ";";
            });
        }
        var win = window.open(cp + "/chart" + hashes, '_blank');
        win.focus();
    });
});