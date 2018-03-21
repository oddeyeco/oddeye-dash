/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global cp, header, token, moment */

function getmetainfo(tagkey) {
    $("#listtablediv").html("<img src='" + cp + "/assets/images/loading.gif' height='50px'> ");
    var url = cp + "/getmetastat";
    $.ajax({
        url: url,
        dataType: 'json',
        type: 'POST',
        beforeSend: function (xhr) {
            xhr.setRequestHeader(header, token);
        },
        success: function (data) {
            if (data.sucsses)
            {
                $('#metrics').html(data.names);
//                    $('#metrics').after('<span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="name">Show List</a></span>');
                $('#tags').html(data.tagscount);
                $('#count').html(data.count);
//                    $('#uniqtagscount').html(data.uniqtagscount);

                $("#tagslist").html('');


                jQuery.each(data.tags, function (i, val) {                    
                    $("#tagslist").append('<div class="col-lg-2 col-sm-3 col-xs-6 tile_stats_count">' +
                            '<span class="count_top"><i class="fa fa-th-list"></i> Tag "' + i + '" count </span>' +
                            '<div class="count spincrement">' + val + '</div>' +
                            '<span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="' + i + '">Show List</a></span>' +
                            '</div>');
                });

                $('.spincrement').spincrement({duration: 2000});
            }
        },
        error: function (xhr, ajaxOptions, thrownError) {
            getmetainfo();
        }
    });
}
var tablemeta = null;
var tablelist = null;
function getmetanames(tablename) {
    var url = cp + "/getmetricsnamesinfo";
    var tags = 'name';

    $.ajax({
        url: url,
        dataType: 'json',
        type: 'POST',
        beforeSend: function (xhr) {
            xhr.setRequestHeader(header, token);
        },
        success: function (data) {
            if (data.sucsses)
            {
                var table = $(tablename);
                for (var i in data.dataspecial)
                {
                    var val = data.dataspecial[i];
                    table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='name' value='" + i + "'><td><input type='checkbox' class='rawflat' name='table_records'></td><td>" + i + "</td><td class='count'> " + val + "  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-primary btn-xs showtagsl2' key='_name' value='" + i + "'><i class='fa fa-list'></i> Show List</a>  <a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='_name' value='" + i + "'><i class='fa fa-trash-o'></i> Delete</a></td></tr>");
                }
                for (var i in data.dataregular)
                {
                    var val = data.dataregular[i];
                    var table = $(tablename);
                    table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='name' value='" + i + "'><td><input type='checkbox' class='rawflat' name='table_records'></td><td>" + i + "</td><td class='count'> " + val + "  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-primary btn-xs showtagsl2' key='_name' value='" + i + "'><i class='fa fa-list'></i> Show List</a>  <a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='_name' value='" + i + "'><i class='fa fa-trash-o'></i> Delete</a></td></tr>");
                }
//                $('#listtable').DataTable({});
                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: 'icheckbox_flat-green',
                    radioClass: 'iradio_flat-green'
                });
                tablelist = $('#listtable').DataTable({
                    "order": [[1, "asc"]],
                    'columnDefs': [{
                            'orderable': false,
                            'targets': [0, 3] /* 1st one, start by the right */
                        }]});
                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: 'icheckbox_flat-green',
                    radioClass: 'iradio_flat-green'
                });
                tablelist.on('draw', function () {
                    $('#listtable').find('td input.rawflat').iCheck({
                        checkboxClass: 'icheckbox_flat-green',
                        radioClass: 'iradio_flat-green'
                    });
                });
                $("#modall1").modal('show');
            }
            ;
        },
        error: function (xhr, ajaxOptions, thrownError) {
            $("#listtablediv").html("Loading Error");
        }
    });
}


function getmetatags(key) {
    var url = cp + "/gettagvalue?key=" + key;
    $.ajax({
        url: url,
        dataType: 'json',
        type: 'POST',
        beforeSend: function (xhr) {
            xhr.setRequestHeader(header, token);
        },
        success: function (data) {
            if (data.sucsses)
            {
                jQuery.each(data.data, function (ikey, val) {
                    var re = new RegExp("[//.|///]", 'g');
                    var i = ikey.replace(re, "_");
                    var id = key + "_" + i;
                    id = id.replace(re, "_");
                    $("#listtable").append("<tr id=parent_" + i + " data-tt-id=" + i + " key='" + key + "' value='" + ikey + "'><td><input type='checkbox' class='rawflat' name='table_records'></td><td>" + ikey + "</td><td class='count'> " + val + "</td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-primary btn-xs showtagsl2' key='" + key + "' value='" + ikey + "'><i class='fa fa-list'></i> Show List</a><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='" + key + "' value='" + ikey + "'><i class='fa fa-trash-o'></i> Delete</a></td></tr>");
                });



                tablelist = $('#listtable').DataTable({
                    "order": [[1, "asc"]],
                    'columnDefs': [{
                            'orderable': false,
                            'targets': [0, 3] /* 1st one, start by the right */
                        }]});
                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: 'icheckbox_flat-green',
                    radioClass: 'iradio_flat-green'
                });
                tablelist.on('draw', function () {
                    $('#listtable').find('td input.rawflat').iCheck({
                        checkboxClass: 'icheckbox_flat-green',
                        radioClass: 'iradio_flat-green'
                    });
                });
                $("#modall1").modal('show');
            }
            ;
        },
        error: function (xhr, ajaxOptions, thrownError) {
            $("#listtablediv").html("Loading Error");
        }
    });
}
var maetricrawHTML = '<tr class="metricinfo" id={hash}><td class="icons text-nowrap"><input type="checkbox" class="rawflat" name="table_records">{icons}<a href="' + cp + '/history/{hash}" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td><a href="' + cp + '/metriq/{hash}">{metricname}</a></td><td class="tags">{tags} </td><td class="text-nowrap"><a>{type}</a></td><td class="text-nowrap"><a>{firsttime}</a></td><td class="text-nowrap"><a>{lasttime}</a></td> <td class="text-nowrap"><a>{livedays}</a></td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="{hash}"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="{hash}"><i class="fa fa-trash-o"></i> Delete </a></td></tr>';
var chartLinck = '<a href="' + cp + '/chart/{hash}" target="_blank"><i class="fa fa-area-chart" style="font-size: 18px;"></i></a>';
function getmetrics(key, idvalue, id, draw) {

//    var re = new RegExp("[//.|///]", 'g');
//    id = id.replace(re, "_");
    var html = maetricrawHTML;
    var url = cp + "/getmetrics?key=" + key + "&value=" + idvalue;
    $.getJSON(url, function (value) {
//        console.log(value);
        var biginput = "";
        if (draw)
        {
            for (var k in value.data) {
                var metric = value.data[k];
                var input = html.replace("{metricname}", metric.name);
                if (metric.type !== 0)
                {
                    var icons = chartLinck.replace("{hash}", JSON.stringify(metric.hash));
                    input = input.replace("{icons}", icons);
                } else
                {
                    input = input.replace("{icons}", "");
                }
                var sttags = "";
                for (var ind in metric.tags)
                {
                    var tag = metric.tags[ind];
                    sttags = sttags + "<div>" + ind + ":\"" + tag + "\"</div>";
                }
//                console.log(metric.tags);
//                console.log(Object.keys(metric.tags).length);
//                input = input.replace("{tagscount}", Object.keys(metric.tags).length);
                input = input.replace("{tags}", sttags);
                input = input.replace(new RegExp("{hash}", 'g'), JSON.stringify(metric.hash));
                input = input.replace("{type}", JSON.stringify(metric.typename));
                input = input.replace("{lasttime}", moment(metric.lasttime).format("YYYY-MM-DD HH:mm:ss"));
                input = input.replace("{firsttime}", moment(metric.inittime).format("YYYY-MM-DD HH:mm:ss"));
                input = input.replace("{livedays}", metric.livedays);
                
                biginput = biginput + input;
            }

            $("#" + id).find("tbody").append(biginput);

            tablemeta = $("#" + id).DataTable({
                "order": [[1, "asc"]],
                'columnDefs': [{
                        'orderable': false,
                        'targets': [0, 7] /* 1st one, start by the right */
                    }]});

            $("#" + id).find('td input.rawflat').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
            tablemeta.on('draw', function () {
                $("#" + id).find('td input.rawflat').iCheck({
                    checkboxClass: 'icheckbox_flat-green',
                    radioClass: 'iradio_flat-green'
                });
            });
            tmphide = false;

            $("#modall1").modal('hide');
            $("#modall2").modal('show');
        }

    });
}
tmphide = true;
$(document).ready(function () {
    getmetainfo();

    $('body').on('hidden.bs.modal', '#modall2', function (e) {
        $("#modall1").modal('show');
        tmphide = true;
    });
    $('body').on('hidden.bs.modal', '#modall1', function (e) {
        if (tmphide)
        {
            getmetainfo();
        }
    });

    $('body').on("click", ".showtags", function () {
        $("#modall1").find(".modal-body").html("");
        $("#modall1").find(".modal-body").append('<div id="listtablediv" class="table-responsive"><table id="listtable" class="table table-striped dt-responsive nowrap" cellspacing="0" width="100%"><thead><tr><th><input type="checkbox" class="rawflat checkall" name="table_records"> </th><th>Name</th><th>Count</th><th><a href="#" class="deletemetriclistgroup btn btn-danger btn-xs pull-right"><i class="fa fa-trash-o"></i> Delete selected</a></th></tr> </thead><tbody></tbody> </table></div>');

        $('#listtable th input.checkall').iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });

        $('#listtable th input.checkall').on('ifChecked', function () {
            $(this).parents("table").find("td .rawflat").iCheck('check');
        });
        $('#listtable th input.checkall').on('ifUnchecked', function () {
            $(this).parents("table").find("td .rawflat").iCheck('uncheck');
        });

        var tagkey = $(this).attr("value");
        if (!tagkey)
        {
            $("#modall1").find(".modal-title").text("Metric Names list");
            getmetanames("#listtable");
        } else
        {
            if (tagkey === "_name")
            {
                $("#modall1").find(".modal-title").text("Metric Names list");
                getmetanames("#listtable");
            } else
            {
                $("#modall1").find(".modal-title").text('Tag "' + tagkey + '" list');
                getmetatags(tagkey);
            }
        }

    });

    $('body').on("click", ".showtagsl2", function () {
        $("#modall2").find(".modal-title").text("Show list with " + $(this).attr("key") + " is " + $(this).attr("value"));
        $("#modall2").find(".modal-body").html("");
        var key = $(this).attr("key");
        var val = $(this).attr("value");
        $("#modall2").find(".modal-body").append('<div id="listtablediv" class="table-responsive"><table id="listtable2" class="table table-striped dt-responsive nowrap" cellspacing="0" width="100%"><thead><tr><th><input type="checkbox" class="rawflat checkall" name="table_records"> <div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li></ul></div></th><th>Name</th><th>Tags</th><th>Type</th><th>First time</th> <th>Last time</th><th>Days</th><th><a href="#" class="deletemetricgroup btn btn-danger btn-xs pull-right"><i class="fa fa-trash-o"></i> Delete selected</a></th></tr> </thead><tbody></tbody> </table></div>');
        getmetrics(key, val, "listtable2", true);
        $("#listtable2 th input.checkall").iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });

        $('#listtable2 th input.checkall').on('ifChecked', function () {
            $(this).parents("table").find("td .rawflat").iCheck('check');
        });
        $('#listtable2 th input.checkall').on('ifUnchecked', function () {
            $(this).parents("table").find("td .rawflat").iCheck('uncheck');
        });
    });



//    $('body').on("click", ".deletemetricgroup", function () {
//        var key = $(this).parents("#listtable").attr("key");
//        $(this).parents('table').find("tbody input[name='table_records']:checked").each(function () {
//            var sendData = {};
//            sendData.hash = $(this).parents("tr").attr("id");
//            $.getJSON(cp + "/deletemetrics?hash=" + sendData.hash, function (data) {
//                console.log(data);
//            });
//        });
////        getmetainfo(key);
//    });


    $('body').on('click', '.deletemetriclistgroup', function (e) {
        $(this).parents("table").find("td input:checked").parents("tr").each(function () {
            if (tablelist)
            {
                $.getJSON(cp + "/deletemetrics?key=" + $(this).find(".deletemetrics").attr("key") + "&value=" + $(this).find(".deletemetrics").attr("value"), function (data) {});
                tablelist.row($(this)).remove();
            }

        });
        if (tablelist)
        {
            tablelist.draw(false);
        }
    });
    $('body').on('click', '.deletemetricgroup', function (e) {

        $(this).parents("table").find("td input:checked").parents("tr").each(function () {
            if (tablemeta)
            {
                $.getJSON(cp + "/deletemetrics?hash=" + $(this).find(".deletemetric").attr("value"), function (data) {});
                tablemeta.row($(this)).remove();
            }

        });
        if (tablemeta)
        {
            tablemeta.draw(false);
        }
    });


    $('body').on("click", ".deletemetrics", function () {
        if (tablelist)
        {
            tablelist.row($(this).parents("tr")).remove();
            tablelist.draw(false);
        }

        $.getJSON(cp + "/deletemetrics?key=" + $(this).attr("key") + "&value=" + $(this).attr("value"), function (data) {});
    });
    $('body').on("click", ".deletemetric", function () {
        if (tablemeta)
        {
            tablemeta.row($(this).parents("tr")).remove();
            tablemeta.draw(false);
        }

        $.getJSON(cp + "/deletemetrics?hash=" + $(this).attr("value"), function (data) {});
    });

    $('body').on("click", ".clreg", function () {
        var sendData = {};
        sendData.hash = $(this).parents("tr").attr("id");
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");

        var url = cp + "/resetregression";
//        console.log(url);
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
                location.reload();
            } else
            {
                console.log("Request failed");
            }
        }).fail(function (jqXHR, textStatus) {
            console.log("Request failed");
        });


    });


    $('body').on("click", ".Show_chart", function () {
        hashes = "";
        if ($(this).parents('table').find("tbody input[name='table_records']:checked").length === 1)
        {
            hashes = "/" + $(this).parents('table').find("tbody input[name='table_records']:checked").first().parents("tr").attr("id");
        } else
        {
            hashes = "?hashes=";
            $(this).parents('table').find("tbody input[name='table_records']:checked").each(function () {
                hashes = hashes + $(this).parents("tr").attr("id") + ";";
            });
        }
        var win = window.open(cp + "/chart" + hashes, '_blank');
        win.focus();
    });

    $('body').on("click", ".Clear_reg", function () {
        $(this).parents('table').find("tbody input[name='table_records']:checked").each(function () {
            var sendData = {};
            sendData.hash = $(this).parents("tr").attr("id");
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");

            var url = cp + "/resetregression";
//            console.log(url);
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
                    setTimeout(function (){location.reload();}, 1000);
                } else
                {
                    console.log("Request failed");
                }
            }).fail(function (jqXHR, textStatus) {
                console.log("Request failed");
            });
        });
    });
});