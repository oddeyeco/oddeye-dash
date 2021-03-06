/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global cp, header, token, moment, locale */

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
                $('#typecount').html(data.types);
                $('#tags').html(data.tagscount);
                $('#count').html(data.count);
                $("#tagslist").html('');
                jQuery.each(data.tags, function (i, val) {
                    $("#tagslist").append('<div class="col-lg-2 col-md-4 col-xs-6 tile_stats_count">' +
                            '<div class="tile_stats_inside">' +                    
                            '<span class="count_top"><i class="fa fa-th-list"></i> ' + locale["metricinfo.tagtitle"].replace("{0}", i) + '</span>' +
                            '<div class="count spincrement">' + val + '</div>' +
                            '<span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="' + i + '">' + locale["metricinfo.showList"] + '</a></span>' +
                            '</div>' + '</div>');
                            
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

var maetricrow_regular_HTML = '';
var maetricrow_special_HTML = '';
var chartLinck = '';
var lang;
function getmetatypes(tablename) {
    var url = cp + "/gettypesinfo";
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
                for (var i in data.data)
                {
                    var val = data.data[i];
                    table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='type' value='" + val.value + "'><td><input type='checkbox' class='rawflat' name='table_records'></td><td>" + i + "</td><td class='count'> " + val.count + "  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-primary btn-xs showtagsl2' title_text='" + locale["metricinfo.metricsWithType"] + "' key='_type' value='" + val.value + "' valuetext='" + i + "'><i class='fa fa-list'></i> " + locale["metricinfo.showList"] + "</a>  <a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='_type' value='" + val.value + "'><i class='fa far fa-trash-alt-o'></i> " + locale["delete"] + "</a></td></tr>");
                }
//                $('#listtable').DataTable({});
                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: icheckbox_flat_clr,
                    radioClass: iradio_flat_clr
                });
                tablelist = $('#listtable').DataTable({
                    "language": lang,
                    "order": [[1, "asc"]],
                    'columnDefs': [{
                            'orderable': false,
                            'targets': [0, 3] /* 1st one, start by the right */
                        }]});

                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: icheckbox_flat_clr,
                    radioClass: iradio_flat_clr
                });
                tablelist.on('draw', function () {
                    $('#listtable').find('td input.rawflat').iCheck({
                        checkboxClass: icheckbox_flat_clr,
                        radioClass: iradio_flat_clr
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

function getmetanames(tablename) {
    var url = cp + "/getmetricsnamesinfo";
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
                    table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='name' value='" + i + "'><td><input type='checkbox' class='rawflat' name='table_records'></td><td>" + i + "</td><td class='count'> " + val + "  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-primary btn-xs showtagsl2' title_text='" + locale["metricinfo.metricsWithName"] + "' key='_name' value='" + i + "'><i class='fa fa-list'></i> " + locale["metricinfo.showList"] + "</a>  <a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='_name' value='" + i + "'><i class='fa far fa-trash-alt-o'></i> " + locale["delete"] + "</a></td></tr>");
                }
                for (var i in data.dataregular)
                {
                    var val = data.dataregular[i];
                    var table = $(tablename);
                    table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='name' value='" + i + "'><td><input type='checkbox' class='rawflat' name='table_records'></td><td>" + i + "</td><td class='count'> " + val + "  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-primary btn-xs showtagsl2' title_text='" + locale["metricinfo.metricsWithName"] + "' key='_name' value='" + i + "'><i class='fa fa-list'></i> " + locale["metricinfo.showList"] + "</a>  <a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='_name' value='" + i + "'><i class='fa far fa-trash-alt-o'></i> " + locale["delete"] + "</a></td></tr>");
                }
//                $('#listtable').DataTable({});
                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: icheckbox_flat_clr,
                    radioClass: iradio_flat_clr
                });
                tablelist = $('#listtable').DataTable({
                    "language": lang,
                    "order": [[1, "asc"]],
                    'columnDefs': [{
                            'orderable': false,
                            'targets': [0, 3] /* 1st one, start by the right */
                        }]});
                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: icheckbox_flat_clr,
                    radioClass: iradio_flat_clr
                });
                tablelist.on('draw', function () {
                    $('#listtable').find('td input.rawflat').iCheck({
                        checkboxClass: icheckbox_flat_clr,
                        radioClass: iradio_flat_clr
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
                    $("#listtable").append("<tr id=parent_" + i + " data-tt-id=" + i + " key='" + key + "' value='" + ikey + "'><td><input type='checkbox' class='rawflat' name='table_records'></td><td>" + ikey + "</td><td class='count'> " + val + "</td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-primary btn-xs showtagsl2' title_text='" + locale["metricinfo.metricsWithTag"] + "' key='" + key + "' value='" + ikey + "'><i class='fa fa-list'></i> " + locale["metricinfo.showList"] + "</a><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='" + key + "' value='" + ikey + "'><i class='fa far fa-trash-alt-o'></i> " + locale["delete"] + "</a></td></tr>");
                });



                tablelist = $('#listtable').DataTable({
                    "language": lang,
                    "order": [[1, "asc"]],
                    'columnDefs': [{
                            'orderable': false,
                            'targets': [0, 3] /* 1st one, start by the right */
                        }]});
                $('#listtable').find('td input.rawflat').iCheck({
                    checkboxClass: icheckbox_flat_clr,
                    radioClass: iradio_flat_clr
                });
                tablelist.on('draw', function () {
                    $('#listtable').find('td input.rawflat').iCheck({
                        checkboxClass: icheckbox_flat_clr,
                        radioClass: iradio_flat_clr
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

function getmetrics(key, idvalue, id, draw) {

//    var re = new RegExp("[//.|///]", 'g');
//    id = id.replace(re, "_");


    var url = cp + "/getmetrics?key=" + key + "&value=" + idvalue;
    $.getJSON(url, function (value) {
//        console.log(value);
        var biginput = "";
        if (draw)
        {
            for (var k in value.data) {
                var metric = value.data[k];

                if (metric.type !== 0)
                {
                    var html = maetricrow_regular_HTML;
                } else
                {
                    var html = maetricrow_special_HTML;
                }
                var input = html.replace("{metricname}", metric.name);
                if (metric.type !== 0)
                {
//                    console.log(chartLinck);
//                    console.log(metric.hash);
//                    console.log(chartLinck.replace("{hash}", metric.hash));
                    var icons = chartLinck.replace("{hash}", metric.hash);
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
                input = input.replace(new RegExp("{hash}", 'g'), metric.hash);
                input = input.replace("{type}", JSON.stringify(metric.typename));
                input = input.replace("{lasttime}", moment(metric.lasttime).format("YYYY-MM-DD HH:mm:ss"));
                input = input.replace("{firsttime}", moment(metric.inittime).format("YYYY-MM-DD HH:mm:ss"));
                input = input.replace("{livedays}", metric.livedays);
                input = input.replace("{silencedays}", metric.silencedays);

                biginput = biginput + input;
            }

            $("#" + id).find("tbody").append(biginput);

            tablemeta = $("#" + id).DataTable({
                "language": lang,
                "order": [[1, "asc"]],
                'columnDefs': [{
                        'orderable': false,
                        'targets': [0, 8] /* 1st one, start by the right */
                    }]});

            $("#" + id).find('td input.rawflat').iCheck({
                checkboxClass: icheckbox_flat_clr,
                radioClass: iradio_flat_clr
            });
            tablemeta.on('draw', function () {
                $("#" + id).find('td input.rawflat').iCheck({
                    checkboxClass: icheckbox_flat_clr,
                    radioClass: iradio_flat_clr
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

    lang = {
        "processing": locale["dataTable.processing"],
        "search": locale["dataTable.search"],
        "lengthMenu": locale["dataTable.lengthMenu"],
        "info": locale["dataTable.info"],
        "infoEmpty": locale["dataTable.infoEmpty"],
        "infoFiltered": locale["dataTable.infoFiltered"],
        "infoPostFix": locale["dataTable.infoPostFix"],
        "loadingRecords": locale["dataTable.loadingRecords"],
        "zeroRecords": locale["dataTable.zeroRecords"],
        "emptyTable": locale["dataTable.emptyTable"],
        "paginate": {
            "first": locale["dataTable.paginate.first"],
            "previous": locale["dataTable.paginate.previous"],
            "next": locale["dataTable.paginate.next"],
            "last": locale["dataTable.paginate.last"]
        },
        "aria": {
            "sortAscending": locale["dataTable.aria.sortAscending"],
            "sortDescending": locale["dataTable.aria.sortDescending"]
        }
    };


    maetricrow_regular_HTML = '<tr class="metricinfo" id={hash}><td class="icons text-nowrap"><input type="checkbox" class="rawflat" name="table_records">{icons}<a href="' + cp + '/history/{hash}" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td><a href="' + cp + '/metriq/{hash}">{metricname}</a></td><td class="tags">{tags} </td><td class="text-nowrap">{type}</td><td class="text-nowrap">{firsttime}</td><td class="text-nowrap">{lasttime}</td> <td class="text-nowrap">{livedays}</td><td class="text-nowrap">{silencedays}</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="{hash}"> ' + locale["metricinfo.clearRegression"] + ' </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="{hash}"><i class="fa far fa-trash-alt-o"></i> ' + locale["delete"] + ' </a></td></tr>';
    maetricrow_special_HTML = '<tr class="metricinfo" id={hash}><td class="icons text-nowrap"><input type="checkbox" class="rawflat" name="table_records">{icons}<a href="' + cp + '/history/{hash}" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td><a href="' + cp + '/metriq/{hash}">{metricname}</a></td><td class="tags">{tags} </td><td class="text-nowrap">{type}</td><td class="text-nowrap">{firsttime}</td><td class="text-nowrap">{lasttime}</td> <td class="text-nowrap">{livedays}</td><td class="text-nowrap">{silencedays}</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="{hash}"><i class="fa far fa-trash-alt-o"></i> ' + locale["delete"] + ' </a></td></tr>';
    chartLinck = '<a href="' + cp + '/chart/{hash}" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a>';

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
        $("#modall1").find(".modal-body").append('<div id="listtablediv" class="table-responsive"><table id="listtable" class="table table-striped dt-responsive nowrap" cellspacing="0" width="100%"><thead><tr><th><input type="checkbox" class="rawflat checkall" name="table_records"> </th><th>' + locale["name2"] + '</th><th>' + locale["count"] + '</th><th><a href="#" class="deletemetriclistgroup btn btn-danger btn-xs pull-right"><i class="fa far fa-trash-alt-o"></i> ' + locale["deleteSelected"] + '</a></th></tr> </thead><tbody></tbody> </table></div>');

        $('#listtable th input.checkall').iCheck({
            checkboxClass: icheckbox_flat_clr,
            radioClass: iradio_flat_clr
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
            $("#modall1").find(".modal-title").text(locale["metricsList"]);
            getmetanames("#listtable");
        } else
        {
            if (tagkey === "_name")
            {
                $("#modall1").find(".modal-title").text(locale["metricsList"]);
                getmetanames("#listtable");
            } else if (tagkey === "_type")
            {
                $("#modall1").find(".modal-title").text(locale["typesList"]);
                getmetatypes("#listtable");
            } else
            {
                $("#modall1").find(".modal-title").text(locale["metricinfo.tagList"].replace("{0}", tagkey));
                getmetatags(tagkey);
            }
        }

    });

    $('body').on("click", ".showtagsl2", function () {
//      $("#modall2").find(".modal-title").text("Show list with " + $(this).attr("key") + " is " + $(this).attr("value"));
        var arg = [$(this).attr("key"), $(this).attr("value"), $(this).attr("valuetext")];
        var text = replaceArgumets($(this).attr("title_text"), arg);
        $("#modall2").find(".modal-title").text(text);
        $("#modall2").find(".modal-body").html("");
        var key = $(this).attr("key");
        var val = $(this).attr("value");
        $("#modall2").find(".modal-body").append('<div id="listtablediv" class="table-responsive"><table id="listtable2" class="table table-striped dt-responsive nowrap" cellspacing="0" width="100%"><thead><tr><th><input type="checkbox" class="rawflat checkall" name="table_records"> <div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">' + locale["metricinfo.showChart"] + '</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">' + locale["metricinfo.clearRegression"] + '</a></li></ul></div></th><th>' + locale["name2"] + '</th><th>' + locale["tags"] + '</th><th>' + locale["adminlist.type"] + '</th><th>' + locale["firstTime"] + '</th> <th>' + locale["lastTime"] + '</th><th>' + locale["aliveDays"] + '</th><th>' + locale["silenceDays"] + '</th><th><a href="#" class="deletemetricgroup btn btn-danger btn-xs pull-right"><i class="fa far fa-trash-alt-o"></i> ' + locale["deleteSelected"] + '</a></th></tr> </thead><tbody></tbody> </table></div>');
        getmetrics(key, val, "listtable2", true);
        $("#listtable2 th input.checkall").iCheck({
            checkboxClass: icheckbox_flat_clr,
            radioClass: iradio_flat_clr
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
            $(this).parents("table").find("th .checkall").iCheck('uncheck');                   
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
            $(this).parents("table").find("th .checkall").iCheck('uncheck');                
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
//                location.reload();
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
                    setTimeout(function () {
                        location.reload();
                    }, 1000);
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