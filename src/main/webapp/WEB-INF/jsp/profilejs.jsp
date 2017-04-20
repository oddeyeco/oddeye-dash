<script src="${cp}/resources/ludo-jquery-treetable/jquery.treetable.js"></script>
<script>
//    var maetricrawHTML = '<tr><td>[icons]</td><td><a href="${cp}/metriq/[hash]">[metricname]</a></td><td><a>[tags]</a></td><td><a>[lasttime]</a></td><td class="text-nowrap"><a href="javascript:void(0)" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i> Edit </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="[hash]"><i class="fa fa-trash-o"></i> Delete </a></td></tr>';
    var maetricrawHTML = '<tr id=[hash]><td class="icons">[icons]</td><td><a href="${cp}/metriq/[hash]">[metricname]</a></td><td><a>[tags]</a></td><td><a>[lasttime]</a></td><td class="text-nowrap"><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="[hash]"><i class="fa fa-trash-o"></i> Delete </a></td></tr>';
    var chartLinck = '<a href="${cp}/chart/[hash]" target="_blank"><i class="fa fa-area-chart" style="font-size: 18px;"></i></a>';
    var header = $("meta[name='_csrf_header']").attr("content");
    var token = $("meta[name='_csrf']").attr("content");
    function getmetrics(key, idvalue, i) {
        var id = key + "_" + idvalue;
        var re = new RegExp("[//.|///]", 'g');
        id = id.replace(re, "_");
        var html = maetricrawHTML;
        var url = "getmetrics?key=" + key + "&value=" + idvalue;
        $.getJSON(url, function (value) {
            $("#parent_" + i).find(".count").html("#" + value.data.length);
            for (var k in value.data) {
                var metric = value.data[k];
                var input = html.replace("[metricname]", metric.name);
                if (metric.type !== 0)
                {
                    var icons = chartLinck.replace("[hash]", JSON.stringify(metric.hash));
                    input = input.replace("[icons]", icons);
                } else
                {
                    input = input.replace("[icons]", "");
                }

                input = input.replace("[tags]", JSON.stringify(metric.tags));
                input = input.replace("[hash]", JSON.stringify(metric.hash));
                input = input.replace("[hash]", JSON.stringify(metric.hash));
                input = input.replace("[hash]", JSON.stringify(metric.hash));
                input = input.replace("[hash]", JSON.stringify(metric.hash));
                input = input.replace("[lasttime]", moment(metric.lasttime));

                $("#" + id).find("tbody").append(input);
            }
//            $("#parent_" + i).after(biginput);
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
                    jQuery.each(data.data, function (i, val) {
                        $("#listtable").append("<tr id=parent_" + i + " data-tt-id=" + i + "><td>" + val + "</td><td class='count'> <img src='${cp}/assets/images/loading.gif' height='25px'>  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='" + key + "' value='" + val + "'><i class='fa fa-trash-o'></i> Delete All</a></td></tr>");
                        var id = key + "_" + val;
                        var re = new RegExp("[//.|///]", 'g');
                        id = id.replace(re, "_");
//                        $("#listtable").append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped projects"><thead><tr><th>#</th><th>Metric name</th><th>Tags</th><th>Last Time</th><th>Actions</th></tr></thead><tbody></tbody></table></span></td></tr>');
                        $("#listtable").append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li><li><a href="#" class="deletemetricgroup">Delete</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Last Time</th><th>Actions</th></tr></thead><tbody></tbody></table></span></td></tr>');
                        getmetrics(key, val, i);
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

    function getmetanames(tablename, tags) {
        if (!tags)
        {
            var url = cp + "/getfiltredmetricsnames?all=true";
            tags = 'name';
        } else
        {
            var url = cp + "/getfiltredmetricsnames?all=true&tags=" + tags;
        }


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
                    jQuery.each(data.data, function (i, val) {
                        var table = $(tablename);
                        table.append("<tr id=parent_" + i + " data-tt-id=" + i + "><td>" + val + "</td><td class='count'> <img src='${cp}/assets/images/loading.gif' height='25px'>  </td><td class='action text-right'><a href='javascript:void(0)' class='btn btn-danger btn-xs deletemetrics' key='name' value='" + val + "'><i class='fa fa-trash-o'></i> Delete All</a></td></tr>");
                        var id = "name_" + val;
                        var re = new RegExp("[//.|///]", 'g');
                        id = id.replace(re, "_");
//                        table.append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Last Time</th><th>Actions</th></tr></thead><tbody></tbody></table></span></td></tr>');
                        $("#listtable").append('<tr data-tt-id="' + i + '_2" data-tt-parent-id="' + i + '" class="metricinfo" id="' + id + '" style="display: none"><td colspan="3"> <span><table class="table table-striped"> <thead><tr><th><div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li><li><a href="#" class="deletemetricgroup">Delete</a></li></ul></div> </th><th>Metric name</th><th>Tags</th><th>Last Time</th><th>Actions</th></tr></thead><tbody></tbody></table></span></td></tr>');
                        getmetrics("name", val, i);
                    });


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
        $("[data-tt-id=" + this.children[0].id + "]").find('.icons').prepend('<input type="checkbox" class="rawflat" name="table_records">');

        $("[data-tt-id=" + this.children[0].id + "]").find("tbody tr input.rawflat").iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });
    };
    var NodeCollapse = function () {
        $("[data-tt-id=" + this.children[0].id + "]").find('.icons div.icheckbox_flat-green').remove();
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
                    if (!tagkey)
                    {
                        $('#metrics').html(data.names);
                        $('#metrics').after('<span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="name">Show List</a></span>');
                        $('#tags').html(data.tagscount);


                        jQuery.each(data.tags, function (i, val) {
                            $("#tagslist").append('<div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">' +
                                    '<span class="count_top"><i class="fa fa-th-list"></i> Total ' + i + '</span>' +
                                    '<div class="count">' + val + '</div>' +
                                    '<span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="' + i + '">Show List </a></span>' +
                                    '</div>');
                        });

                        $('.count').spincrement({duration: 5000});
                        getmetanames("#listtable");
                    } else
                    {
                        $("#listtable").attr('value', tagkey);
                        $('#metrics').html(data.names);
                        $('#tags').html(data.tagscount);
                        $("#tagslist").html("");
                        jQuery.each(data.tags, function (i, val) {
                            $("#tagslist").append('<div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">' +
                                    '<span class="count_top"><i class="fa fa-th-list"></i> Total ' + i + '</span>' +
                                    '<div class="count">' + val + '</div>' +
                                    '<span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="' + i + '">Show List </a></span>' +
                                    '</div>');
                        });
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
            $.getJSON("deletemetrics?key=" + $(this).attr("key") + "&value=" + $(this).attr("value"), function (data) {
                getmetainfo(key);
            });
        });
        $('body').on("click", ".deletemetric", function () {
            var key = $(this).parents("#listtable").attr("key");
            $.getJSON("deletemetrics?hash=" + $(this).attr("value"), function (data) {
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
                $.getJSON("deletemetrics?hash=" + sendData.hash, function (data) {

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
