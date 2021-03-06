/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global moment, cp, headerName, token, uuid, sotoken, filterOldJson ,*/

var socket;
var stompClient;
var timeformat = "DD/MM HH:mm:ss";
var timeformatsmall = "HH:mm:ss";
var errorlistJson = {};
var array_regular = [];
var array_spec = [];
//var strop = "<option value='~'>contains</option><option value='!~'>doesn't contain</option><option value='=='>equal</option><option value='!='>not equal</option><option value='!*'>none</option><option value='*'>any</option> <option value='regexp'>RegExp true</option><option value='regexp'>RegExp false</option>";
var strop = "<option value='~'>" + locale['contains'] + "</option><option value='!~'>" + locale['doesntContain'] + "</option><option value='=='>" + locale['equal'] + "</option><option value='!='>" + locale['notEqual'] + "</option>";
var eniumop = "<option value='='>" + locale['is'] + "</option><option value='!'>" + locale['isNot'] + "</option>";
function redrawBoard() {
    $(".monitorlist ul").html("");
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

function findeBy_ihash(hash, array) {
    for (var i = 0; i < array.length; i++) {
        if (array[i].hash === hash) {
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
        arrowclass = "fas fa-long-arrow-alt-down";
        color = "green";
    }
    if (errorjson.action === 3)
    {
        arrowclass = "fas fa-long-arrow-alt-up";
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
        console.log(errorjson.info.name + " " + errorjson.flap);
        eRclass = eRclass + " flapdetect";
    }
    
    if (!update)
    {
        var html = '<li style="display:none" id="' + errorjson.hash + '" class="' + eRclass + '" time="' + moment().format("x") + '">';
        var re = /_/gi;
        optionsJson.f_col.forEach(
                function (entry) {
                    var obj = $('.f_col option[value=' + entry + ']');
//                    if (obj.length === 0)
//                    {
//                        console.log(entry);
//                    }

                    switch (obj.attr("key")) {
                        case  "actions":
                        {
                            if (errorjson.isspec === 0)
                            {
//                                html = html + '<div class="inline icons"><input type="checkbox" class="rawflat" name="table_records"><div class="fa-div"> <a href="' + cp + '/chart/' + errorjson.hash + '" target="_blank"><i class="fa fas fa-chart-area"></i></a><a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a> <i class="action fa ' + arrowclass + '" style="color:' + color + ';"></i></div></div>';
                                html = html + '<div class="icons"><i class="pull-left action fa ' + arrowclass + '" style="color:' + color + ';"></i> <a href="' + cp + '/chart/' + errorjson.hash + '" target="_blank"><i class="fa fas fa-chart-area"></i></a><a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a>' +
                                        '<a href="#"><i class="fa far fa-bell-slash resetregretion"></i></a>' +
                                        '<a href="#"><i class="fa far fa-trash-alt deletemetric"></i></a>' +
//                                        '<a href="#"><span class="glyphicon glyphicon-trash resetrules" aria-hidden="true"></span></a>' +
                                        '</div>';
                            } else
                            {
                                html = html + '<div class="icons"><i class="fa fa-bell pull-left"></i> <a href="' + cp + '/history/' + errorjson.hash + '" target="_blank"><i class="fa fa-history"></i></a><a href="#"><i class="fa far fa-trash-alt deletemetric"></i></a></div>';
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
                                var valuearrowclass = "fas fa-long-arrow-alt-down";
                                if (errorjson.upstate)
                                {
                                    valuearrowclass = "fas fa-long-arrow-alt-up";
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
                            html = html + '<div class="label label-info level inline">' + locale['level_'+errorjson.level]  + '</div>';
                            break;
                        }
                        //html = html + "<div><span class='timeinterval'>0</span> <span class='refreshes'>1</span></div>";
                        case  "info.name":
                        {
                            var value = errorjson.info.name;
                            if (errorjson.isspec === 0)
                            {
                                if (value)
                                {
                                    html = html + '<div class="metricname ' + entry.replace(re, " ") + '"><div> <i class="samegroup fas fa-object-group" data-key="_name" data-value="' + value + '" data-toggle="tooltip" data-placement="top" title="'+ locale['title.selectIdentic'] +'"></i> <a href="' + cp + '/metriq/' + errorjson.hash + '" target="_blank">' + value + '</a></div></div>';
                                }


                            } else
                            {
                                html = html + '<div class="metricname ' + entry.replace(re, " ") + '"><div> <i class="samegroup fas fa-object-group" data-key="_name" data-value="' + value + '" data-toggle="tooltip" data-placement="top" title="'+ locale["title.selectIdentic"] +'"></i> ' + value + '</div></div>';
                            }
                            break;
                        }
                        default:
                        {
//                            console.log(entry);
//                            console.log(obj);
//                            console.log(obj.attr("key"));
                            if (obj.attr("key"))
                            {
                                var path = obj.attr("key").split(".");
                            } else
                            {
                                var path = entry.split("_");
                            }

                            var value = errorjson;
                            $.each(path, function (i, item) {
                                if (value)
                                {
                                    value = value[item];
                                }
                            });


                            if (value)
                            {
                                html = html + '<div class="' + entry.replace(re, " ") + '"><div><i class="samegroup fas fa-object-group" data-key="' + path.join("_") + '" data-value="' + value + '" data-toggle="tooltip" data-placement="top" title ="'+ locale["title.selectIdentic"]+'"></i> ' + value + '</div></div>';
                            }

                            break;
                        }

                    }


                }
        );

        html = html + "</li>";
        $("." + table).find("ul#" + UlID).prepend(html);
        
        $("." + table).find("li#" + errorjson.hash).find('[data-toggle="tooltip"]').tooltip();
        $("." + table).find("li#" + errorjson.hash).show("slide", {direction: "left"}, 1000);


    } else
    {
        $("." + table).find("li#" + hashindex + " .info.metricname").effect("shake", {direction: "down", distance: 2}, "slow");
        /*
         var index = $("." + table).find("li#" + hashindex).index() % 10+1;        
         var audio = new Audio(cp+"/assets/Sounds/"+index+".mp3");
         audio.play();
         */
        $("." + table).find("li#" + hashindex).removeClass(function (index, className) {
            return (className.match(/(^|\s)level_\S+/g) || []).join(' ');
        });
        $("." + table).find("li#" + hashindex).addClass("level_" + errorjson.level);
        //var eRclass = "level_" + errorjson.level;

//            .attr("class", eRclass);
        $("." + table).find("li#" + hashindex + " .level").html(locale['level_'+errorjson.level]);
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
            var valuearrowclass = "fas fa-long-arrow-alt-down";
            if (errorjson.upstate)
            {
                valuearrowclass = "fas fa-long-arrow-alt-up";
            }
            $("." + table).find("li#" + hashindex + " .valueinfo").html('<i class="action fa ' + valuearrowclass + '"></i> ' + message);
        } else
        {
            $("." + table).find("li#" + hashindex + " .message").html('<i class="action fa fa-comment-o"></i> ' + message);
        }
        if (arrowclass !== "")
        {
            $("." + table).find("li#" + hashindex + " .icons i.action").attr("class", "action pull-left fa " + arrowclass);
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
                array_regular.splice(indexregular, 1);
            }
            errorjson.index = 0;
            var hash_r = errorjson.hash;
            $("." + listclass).find("li#" + hash_r).hide("slide", {direction: "left"}, 1000, function () {
                $("." + listclass).find("li#" + hash_r).remove();
                $("." + listclass).find(".ui-effects-placeholder").remove();                                
            });
//            console.log($("." + listclass).find(".ui-effects-placeholder").length);
        }
    } else
    {
//        console.log($("." + listclass).remove(".ui-effects-placeholder").length);

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
                $("." + listclass).find(".ui-effects-placeholder").remove();
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
//                    console.log(value);
//                    console.log(filterop);
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


    $('body').on("click", "#Show_chart", function () {
        hashes = "";
        if ($("#regularlist li.selected").length === 1)
        {
            hashes = "/" + $("#regularlist li.selected").first().attr("id");
        } else
        {
            hashes = "?hashes=";
            $("#regularlist li.selected").each(function () {
                hashes = hashes + $(this).attr("id") + ";";
            });
        }
        var win = window.open(cp + "/chart" + hashes, '_blank');
        win.focus();
    });


    function cleareregresion() {
        var sendData = {};
        sendData.hash = $(this).attr("id");
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
                console.log("Message Sended " + sendData.hash);
            } else
            {
                console.log("Request failed " + sendData.hash);
            }
        }).fail(function (jqXHR, textStatus) {
            console.log("Request failed");
        });
    }
    $('body').on("click", ".monitorlist li ul li a", function (e) {
        e.stopPropagation();
    });



    $('body').on("click", ".deletemetric", function (e) {
        e.stopPropagation();
        $(this).closest("li").each(function () {
            $.getJSON(cp + "/deletemetrics?hash=" + $(this).attr("id"), function (data) {});
            var index = findeBy_ihash($(this).attr("id"), array_regular);
            if (index !== -1)
            {
                array_regular.splice(index, 1);
            }
            index = findeBy_ihash($(this).attr("id") * 1, array_spec);
            if (index !== -1)
            {
                array_spec.splice(index, 1);
            }
            $(this).hide("slide", {direction: "left"}, 1000, function () {
                $(this).remove();
                $(this).parent().remove(".ui-effects-placeholder");
            });
        });
    });

    $('body').on("click", ".resetregretion", function (e) {
        e.stopPropagation();
        $(this).closest("li").each(cleareregresion);
    });

    $('body').on("click", "#Clear_reg", function (e) {
        $("#regularlist li.selected").each(cleareregresion);
    });


    $('body').on("click", "#Move_down", function (e) {

        $("li.selected").each(function () {
            $(this).hide("slide", {direction: "left"}, 1000, function () {
                $(this).parent().append(this);
                $(this).show("slide", {direction: "left"}, 1000);
            });

        });
    });

    $('body').on("click", "#Move_top", function (e) {

        $("li.selected").each(function () {
            $(this).hide("slide", {direction: "left"}, 1000, function () {
                $(this).parent().prepend(this);
                $(this).show("slide", {direction: "left"}, 1000);
            });

        });
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
                $('#saveModal .modal-title').text(locale["dashboard.Modal.successfullySaved"]);
                $('#saveModal').modal('show');

                setTimeout(function () {
                    $('#saveModal').modal('hide');
                }, 2000);
            } else
            {
                $('#saveModal .modal-title').text(locale["dash.errorSavingData"]);
                $('#saveModal').modal('show');

                setTimeout(function () {
                    $('#saveModal').modal('hide');
                }, 2000);
            }
        }).fail(function (jqXHR, textStatus) {
            alert(locale["requestFailed"]);
        });

    });

    $("body").on("click", "#save_filter", function () {
        updateFilter();
        var sendData = {};
        url = cp + "/addmonitoringpage/";
        sendData.optionsjson = JSON.stringify(optionsJson);
        sendData.optionsname = nameoptions;
//        console.log(sendData.optionsname);
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
                $('#saveModal .modal-title').text(locale["dashboard.Modal.successfullySaved"]);
                $('#saveModal').modal('show');

                setTimeout(function () {
                    $('#saveModal').modal('hide');
                }, 2000);
            } else
            {
                $('#saveModal .modal-title').text(locale["dash.errorSavingData"]);
                $('#saveModal').modal('show');

                setTimeout(function () {
                    $('#saveModal').modal('hide');
                }, 2000);
            }
        }).fail(function (jqXHR, textStatus) {
            alert(locale["requestFailed"]);
        });

    });


    $("body").on("click", "#deleteviewconfirm", function () {
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
                alert(locale["requestFailed"]);
            }
        }).fail(function (jqXHR, textStatus) {
            alert(locale["requestFailed"]);
        });

    });


    $('body').on("click", "#rem_filter", function () {
        $("#deleteConfirm").find('.btn-ok').attr('id', "deleteviewconfirm");
        $("#deleteConfirm").find('.btn-ok').attr('class', "btn btn-ok btn-danger");
        $("#deleteConfirm").find('.modal-body p').html(locale["monitorings2.modal.confirmDelView"]);
        $("#deleteConfirm").find('.modal-body .text-warning').html(nameoptions);
        $("#deleteConfirm").modal('show');
    });

    setInterval(function () {
        $(".monitorlist li ul li").each(function () {
            var interval = moment($(this).attr("time") * 1).diff(moment()) / -1000;
            $(this).find(".timeinterval").text(interval.toFixed(0) + "sec.");

        });
    }, 1000);

    $("body").on("change", ".add_filter_select", function () {
        $(this).find(':selected').attr("disabled", "disabled");
        var row = $("<tr>");
        row.append("<td class='filter_label'>" + $(this).find(':selected').attr("fname") + "</td>");
        if ($(this).find(':selected').attr("value") === 'level')
        {

            row.append('<td class="action"><select class="operators_' + $(this).find(':selected').attr("value") + '" name="op[' + $(this).attr("id") + "_" + $(this).find(':selected').attr("value") + ']">' + eniumop + '</select> </td>');
            row.append('<td class="value"><select class="value" id="values_' + $(this).find(':selected').attr("value") + '_1" name="v[' + $(this).attr("id") + "_" + $(this).find(':selected').attr("value") + '][]" multiple="multiple" size="4"><option value="0">' + locale["level_0"] + '</option><option value="1">' + locale["level_1"] + '</option><option value="2">' + locale["level_2"] + '</option><option value="3">' + locale["level_3"] + '</option><option value="4">' + locale["level_4"] + '</option><option value="5">' + locale["level_5"] + '</option></select></td>');
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

    $("body").on("change", ".add_notifier_select", function () {
//        $(this).find(':selected').attr("disabled", "disabled");

        var row = $("<div class='col-lg-4 col-md-6'>");
        row.append("<div class='item notifier_label'>" + $(this).find(':selected').attr("fname") + "</div>");
        row.append("<div class='item value'><input class='notifier-value' type='text' name='notifier-v[" + $(this).find(':selected').attr("value") + "][]' autocomplete='off'></div>");
        $(this).parents(".filter-body").find(".notifiers-table").append(row);

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
                    '<option value="0" ' + (levels.indexOf("0") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_0"] + '</option>' +
                    '<option value="1" ' + (levels.indexOf("1") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_1"] + '</option>' +
                    '<option value="2" ' + (levels.indexOf("2") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_2"] + '</option>' +
                    '<option value="3" ' + (levels.indexOf("3") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_3"] + '</option>' +
                    '<option value="4" ' + (levels.indexOf("4") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_4"] + '</option>' +
                    '<option value="5" ' + (levels.indexOf("5") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_5"] + '</option>' +
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
                            '<option value="0" ' + (levels.indexOf("0") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_0"] + '</option>' +
                            '<option value="1" ' + (levels.indexOf("1") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_1"] + '</option>' +
                            '<option value="2" ' + (levels.indexOf("2") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_2"] + '</option>' +
                            '<option value="3" ' + (levels.indexOf("3") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_3"] + '</option>' +
                            '<option value="4" ' + (levels.indexOf("4") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_4"] + '</option>' +
                            '<option value="5" ' + (levels.indexOf("5") !== -1 ? ' selected="selected" ' : "") + '>' + locale["level_5"] + '</option>' +
                            '</select></td>');
                } else
                {
                    if (optionsJson.op[section])
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
        var Domsection = $(".add_notifier_select").parents(".filter-body");
        for (var notifier in optionsJson["notifier-v"])
        {
            name = notifier;
            var opt = Domsection.find(".add_notifier_select option[value='" + name + "']:first");
            for (var nvalue in optionsJson["notifier-v"][notifier])
            {
//                console.log(notifier + "=" + optionsJson["notifier-v"][notifier][nvalue]);
                var row = $("<div class='col-lg-4 col-md-6'>");
                row.append("<div class='item notifier_label'>" + opt.attr("fname") + "</div>");
                row.append("<div class='item value'><input class='notifier-value' type='text' name='notifier-v[" + opt.attr("value") + "][]' value='" + optionsJson["notifier-v"][notifier][nvalue] + "' autocomplete='off'></div>");
                Domsection.find(".notifiers-table").append(row);
            }

        }


    }
    $('body').on("click", '.monitorlist li ul li .samegroup', function (e) {
        e.stopPropagation();
        var ctrl = e.ctrlKey;
        
        var key = $(this).attr("data-key");
        var value = $(this).attr("data-value");
        if (!ctrl)
        {
            $(".selected").toggleClass("selected");
        }
        $("[data-key='" + key + "'][data-value='" + value + "']").each(function () {
            $(this).parents("li:first").addClass("selected");
        });

        if ($("#regularlist .selected").length > 0)
        {
            $(".selected-actions").show("slide", {direction: "right"}, 1000);
        } else
        {
            $(".selected-actions").hide("slide", {direction: "right"}, 1000);
        }
        $(".selected-actions .badge").text($("#regularlist .selected").length);
    });

    $('body').on("click", '.monitorlist li ul li', function (e) {

        $(this).toggleClass("selected");
        if ($("#regularlist .selected").length > 0)
        {
            $(".selected-actions").show("slide", {direction: "right"}, 1000);
        } else
        {
            $(".selected-actions").hide("slide", {direction: "right"}, 1000);
        }
        $(".selected-actions .badge").text($("#regularlist .selected").length);

    });
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
    const regex = /[a-zA-Z-.]+/g;
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

                name = field.name.substring(0, field.name.indexOf("v[") + 1);
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
                    if (fname)
                    {
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
                        if (!optionsJson[name][fgroup])
                        {
                            optionsJson[name][fgroup] = [];
                        }
                        optionsJson[name][fgroup].push(field.value);
                    }

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