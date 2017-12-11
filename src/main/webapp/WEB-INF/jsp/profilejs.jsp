<script src="${cp}/resources/ludo-jquery-treetable/jquery.treetable.js?v=${version}"></script>
<script>
//    var maetricrawHTML = '<tr><td>{icons}</td><td><a href="${cp}/metriq/{hash}">{metricname}</a></td><td><a>{tags}</a></td><td><a>{lasttime}</a></td><td class="text-nowrap"><a href="javascript:void(0)" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i> Edit </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="{hash}"><i class="fa fa-trash-o"></i> Delete </a></td></tr>';
    var maetricrawHTML = '<tr id={hash}><td class="icons text-nowrap">{icons}<a href="${cp}/history/{hash}" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td><a href="${cp}/metriq/{hash}">{metricname}</a></td><td class="tags">{tags}</td><td class="text-nowrap"><a>{type}</a></td><td class="text-nowrap"><a>{lasttime}</a></td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="{hash}"><i class="fa fa-trash-o"></i> Delete </a></td></tr>';
    var chartLinck = '<a href="${cp}/chart/{hash}" target="_blank"><i class="fa fa-area-chart" style="font-size: 18px;"></i></a>';
    var header = $("meta[name='_csrf_header']").attr("content");
    var token = $("meta[name='_csrf']").attr("content");
    function getmetrics(key, idvalue, i, draw) {
        var id = key + "_" + idvalue;
        var re = new RegExp("[//.|///]", 'g');
        id = id.replace(re, "_");
        var html = maetricrawHTML;
        var url = cp+"/getmetrics?key=" + key + "&value=" + idvalue;
        if (draw)
        {
            $("#" + id).find("td").append("<img src='${cp}/assets/images/loading.gif' height='50px'> ");
            $("#" + id).find("table").hide();
        }
        $.getJSON(url, function (value) {
            $("#parent_" + i).find(".count").html("#" + value.data.length);
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
                    input = input.replace("{tags}", sttags);
                    input = input.replace(new RegExp("{hash}", 'g'), JSON.stringify(metric.hash));
                    input = input.replace("{type}", JSON.stringify(metric.typename));
                    input = input.replace("{lasttime}", moment(metric.lasttime).format("YYYY-MM-DD HH:mm:ss"));
                    biginput = biginput + input;
                }
                $("#" + id).find("tbody").append(biginput);
                if (value.data.length < 1000)
                {
                    $("#" + id).find('.icons').prepend('<input type="checkbox" class="rawflat" name="table_records">');
                    $("#" + id).find('input.rawflat').iCheck({
                        checkboxClass: 'icheckbox_flat-green',
                        radioClass: 'iradio_flat-green'
                    });
                    $("#" + id).find('.dropdown-toggle').show();
                } else
                {
                    $("#" + id).find('.dropdown-toggle').hide();
                }
                $("#" + id).find("img").remove();
                $("#" + id).find("table").show();
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
                $("#listtablediv").html('<table id="listtable" class="table projects" key="' + key + '"></table>');
                if (data.sucsses)
                {
                    jQuery.each(data.data, function (ikey, val) {
                        var re = new RegExp("[//.|///]", 'g');
                        var i = ikey.replace(re, "_");
                        var id = key + "_" + i;
                        id = id.replace(re, "_");
                        $("#listtable").append("<tr id=parent_" + i + " data-tt-id=" + i + " key='" + key + "' value='" + ikey + "'><td>" + ikey + "</td><td class='count'> "+val+"</td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='" + key + "' value='" + ikey + "'><i class='fa fa-trash-o'></i> Delete All</a></td></tr>");
                        $("#listtable").append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li><li><a href="#" class="deletemetricgroup">Delete</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Last Time</th><th></th></tr></thead><tbody></tbody></table></span></td></tr>');
//                        getmetrics(key, val, i);
                    });
//                    $("#listtable").treetable({expandable: true});
                    $("#listtable").treetable({expandable: true, onNodeCollapse: NodeCollapse, onNodeExpand: NodeExpand});
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
        var tags = 'name';

        $.ajax({
            url: url,
            dataType: 'json',
            type: 'POST',
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            },
            success: function (data) {
                $("#listtablediv").html('<table id="listtable" class="table projects" key="' + tags + '"></table>');
                if (data.sucsses)
                {
                    var table = $(tablename);
                    for (var i in data.dataspecial)
                    {
                        var val = data.dataspecial[i];                        
                        table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='name' value='" + i + "'><td>" + i + "</td><td class='count'> " + val + "  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='name' value='" + i + "'><i class='fa fa-trash-o'></i> Delete All</a></td></tr>");
                        var id = "name_" + i;
                        var re = new RegExp("[//.|///]", 'g');
                        id = id.replace(re, "_");
                        table.append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="deletemetricgroup">Delete</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Type</th><th>Last Time</th><th></th></tr></thead><tbody></tbody></table></span></td></tr>');
                    }
                    table.append("<tr><td colspan='3'> </td></tr>");
                    for (var i in data.dataregular)
                    {
                        var val = data.dataregular[i];
                        var table = $(tablename);
                        table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='name' value='" + i + "'><td>" + i + "</td><td class='count'> " + val + "  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='name' value='" + i + "'><i class='fa fa-trash-o'></i> Delete All</a></td></tr>");
                        var id = "name_" + i;
                        var re = new RegExp("[//.|///]", 'g');
                        id = id.replace(re, "_");
                        table.append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li><li><a href="#" class="deletemetricgroup">Delete</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Type</th><th>Last Time</th><th></th></tr></thead><tbody></tbody></table></span></td></tr>');
                    }
//                    jQuery.each(data.dataspecial, function (i, val) {                       
//                        var table = $(tablename);
//                        if (i===data.specialcount)
//                        {
//                            table.append("<tr><td colspan='3'> </td></tr>");
//                        }                                      
//                        table.append("<tr id=parent_" + i + " data-tt-id=" + i + " key='name' value='" + i + "'><td>" + i + "</td><td class='count'> "+val+"  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='name' value='" + val + "'><i class='fa fa-trash-o'></i> Delete All</a></td></tr>");
//                        var id = "name_" + i;
//                        var re = new RegExp("[//.|///]", 'g');
//                        id = id.replace(re, "_");
//                        if (i< data.specialcount)
//                        { //Special
//                            $("#listtable").append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="deletemetricgroup">Delete</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Type</th><th>Last Time</th><th></th></tr></thead><tbody></tbody></table></span></td></tr>');
//                        } 
//                        else
//                        {
//                            $("#listtable").append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li><li><a href="#" class="deletemetricgroup">Delete</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Type</th><th>Last Time</th><th></th></tr></thead><tbody></tbody></table></span></td></tr>');
//                        }
//                        
////                        getmetrics("name", val, i);                        
//                    });


                    $(tablename).treetable({expandable: true, onNodeCollapse: NodeCollapse, onNodeExpand: NodeExpand});
                }
                ;
            },
            error: function (xhr, ajaxOptions, thrownError) {
                $("#listtablediv").html("Loading Error");
            }
        });
    }


    var NodeExpand = function () {
        var key = $("[data-tt-id=" + this.id + "]").attr("key");
        var val = $("[data-tt-id=" + this.id + "]").attr("value");
        getmetrics(key, val, this.id, true);
    };
    var NodeCollapse = function () {
        $("[data-tt-id=" + this.children[0].id + "]").find('tbody').html("");
    };

    //getfiltredmetricsnames?all=all
    function getmetainfo(tagkey) {
        $("#listtablediv").html("<img src='${cp}/assets/images/loading.gif' height='50px'> ");
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
                                '<div class="count">' + val + '</div>' +
                                '<span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="' + i + '">Show List </a></span>' +
                                '</div>');
                    });

                    $('.count').spincrement({duration: 2000});

                    if (!tagkey)
                    {
                        getmetanames("#listtable");
                    } else
                    {
                        if (tagkey === "name")
                        {
                            getmetanames("#listtable");
                        } else
                        {
                            getmetatags(tagkey);
                        }
                    }

                }
                ;
            },
            error: function (xhr, ajaxOptions, thrownError) {
                getmetainfo();
            }
        });
    }
    ;

    $(document).ready(function () {
        getmetainfo();

        $('body').on("click", ".deletemetrics", function () {
            var key = $(this).attr("key");
            console.log($(this).attr("value"));
            $.getJSON("/deletemetrics?key=" + $(this).attr("key") + "&value=" + $(this).attr("value"), function (data) {
                getmetainfo(key);
            });
        });
        $('body').on("click", ".deletemetric", function () {
            var key = $(this).parents("#listtable").attr("key");
            $.getJSON("/deletemetrics?hash=" + $(this).attr("value"), function (data) {
                getmetainfo(key);
            });
        });


        $('body').on("click", ".showtags", function () {
            getmetainfo($(this).attr("value"));
        });

        $('body').on("click", ".deletemetricgroup", function () {
            var key = $(this).parents("#listtable").attr("key");
            $(this).parents('table').find("tbody input[name='table_records']:checked").each(function () {
                var sendData = {};
                sendData.hash = $(this).parents("tr").attr("id");
                $.getJSON("/deletemetrics?hash=" + sendData.hash, function (data) {

                });
            });
            getmetainfo(key);
        });


        $('body').on("click", ".Clear_reg", function () {
            $(this).parents('table').find("tbody input[name='table_records']:checked").each(function () {
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
                
    });
</script>    
