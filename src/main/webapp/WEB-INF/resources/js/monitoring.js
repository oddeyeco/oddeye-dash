/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global moment, cp, headerName, token, uuid, sotoken, datatable */

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

function filtredcheck(errorjson)
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
    return filtred;
}

function reDrawErrorList(errorjson)
{
//    console.log(errorjson.level);

    if (filtredcheck(errorjson))
    {
        var rowNode = null;
        var rawItem = new Jsontoraw(errorjson);
        if ($("#" + errorjson.hash).length > 0)
        {
            var row = datatable.row($("#" + errorjson.hash));
            var data = row.data();
            rowNode = row.node();
            data.index++;
            data.level=rawItem.level;
            data.info=rawItem.info;
            data.starttime=rawItem.starttime;
            data.lasttime=rawItem.lasttime + " (" + timems(rawItem.lastTS - data.lastTS) + " Repeat " + data.index + ")";
            data.lastTS = rawItem.lastTS;
            row.invalidate();
            row.draw();            
            $(rowNode).removeClass(data.class);
        } else
        {
            rowNode = datatable.row.add(rawItem).draw().node();
//            $(rowNode).find("input.rawflat").iCheck({
//                checkboxClass: 'icheckbox_flat-green',
//                radioClass: 'iradio_flat-green'
//            });
        }
        $(rowNode).addClass(rawItem.class);
        $(rowNode).attr('id', errorjson.hash);
    } else
    {
        datatable.row($("#" + errorjson.hash)).remove().draw();
    }
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
    var checttimer;
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
            var elem = this;
            clearTimeout(checttimer);
            checttimer = setTimeout(function () {
                datatable.rows().every(
                        function (rowIdx, tableLoop, rowLoop) {
                            var row = this;
                            var data = row.data();
                            if (!filtredcheck(data.json))
                            {
                                $(row.node()).addClass("remove");
                            }
                        }
                );
                datatable.rows('.remove').remove().draw();
            }, 1);
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
        {
            datatable.rows().every(
                    function (rowIdx, tableLoop, rowLoop) {
                        var row = this;
                        var data = row.data();
                        if (!filtredcheck(data.json))
                        {
                            $(row.node()).addClass("remove");
                        }
                    }
            );
            datatable.rows('.remove').remove().draw();
        }
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
//            if (errorlistJson[errorjson.hash])
//            {
//                errorjson.index = errorlistJson[errorjson.hash].index;
//            }
//
//            if (typeof (errorjson.index) !== "undefined")
//            {
//                errorjson.index = errorjson.index + 1;
//            } else
//            {
//                errorjson.index = 0;
//            }
//
//            if (errorjson.level === -1)
//            {
//                delete errorlistJson[errorjson.hash];
//            } else
//            {
//                errorlistJson[errorjson.hash] = errorjson;
//            }
            reDrawErrorList(errorjson);
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
        datatable.rows().every(
                function (rowIdx, tableLoop, rowLoop) {
                    var row = this;
                    var data = row.data();
                    data.showtags = data.json.info.tags[$("select#ident_tag").val()].value
                    this.invalidate();
                }
        );
        datatable.draw();
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