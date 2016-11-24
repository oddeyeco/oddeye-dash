<script>
    dush_charts_options = [];
    dush_charts = [];
    var singleChart = null;
    var pickerstart;
    var pickerend;
    var pickerlabel = "Last 5 minutes";
    var rangeslabels = {
        'Last 5 minutes': "5m-ago",
        'Last 15 minutes': "15m-ago",
        'Last 30 minutes': "30m-ago",
        'Last 1 hour': "1h-ago",
        'Last 3 hour': "3h-ago",
        'Last 6 hour': "6h-ago",
        'Last 12 hour': "12h-ago",
        'Last 24 hour': "24h-ago",
    }


    function rebuilsCarts(Dashinfo)
    {
        var request_index = getParameterByName("chart");
        if (request_index == null)
        {
            request_index = -1
        }
        if (typeof Dashinfo == "undefined")
        {
            return false;
        }
        if (request_index == -1)
        {
            dush_charts_options = [];
            dush_charts = [];
            for (var index in Dashinfo) {
                var row = Dashinfo[index];
                $("#dashcontent").append($("#rowtemplate").html());
                for (var chartindex in row) {
                    $("#dashcontent .rowcontent:last").append($("#charttemplate").html());
                    var ctx = $("#dashcontent .rowcontent:last").find(".lineChart").last();
                    ctx.attr("datasetindex", dush_charts_options.length);
                    options = row[chartindex];
//                console.log(options);
                    dush_charts_options.push(options);
                    lineChart = new Chart(ctx, JSON.parse(JSON.stringify(options)));
                    dush_charts.push(lineChart);
                }

            }


            $("#dashcontent .rowcontent").each(function (index) {
                itemcount = $(this).find(".lineChart").size();
                size = 12;
                if (itemcount < 12)
                {
                    size = Math.round(12 / itemcount);
                } else
                {
                    size = 1;
                }
                $(this).find(".chartsection").attr("size", size);
                $(this).find(".chartsection").attr("class", "chartsection col-lg-" + size);
            });
        } else
        {
            for (var index in Dashinfo) {                                
                var row = Dashinfo[index];
                for (var chartindex in row) {                    
                    options = row[chartindex];
                    dush_charts_options.push(options);
                }

            }
            showsingleChart(request_index);            
        }
        ;
//        alert('fsdfsd');
        dush_charts.forEach(redrawchart);
    }


    function showsingleChart(datasetindex) {
        $(".editchartpanel").show();
        options = dush_charts_options[datasetindex];
        console.log(options);
        singleChart = null;
        html = $("#charttemplate").html();
        $(".editchartpanel #singlewidget").html(html);
        $(".editchartpanel #singlewidget .controls").remove();
        var ctx = $(".editchartpanel #singlewidget").find(".lineChart").last();
        ctx.height = 600;
        var url = options.data.datasetsUri;
//        var url = "${cp}/getdata" + query;
        drawchart(url, ctx, options);
        $(".editchartpanel").attr("datasetindex", datasetindex);
        $(".fulldash").hide();
        //Fill edit form
        console.log(options.data.datasetsUri);
//            console.log(options.data.datasetsUri);
        if (typeof (options.data.datasetsUri) == "undefined")
        {
            $("#tab_metrics input#tags").val("");
            $("#tab_metrics input#aggregator").val("");
            $("#tab_metrics input#metrics").val("");
            $("#tab_metrics input#down-sample").val("");
        } else
        {
            $("#tab_metrics input#tags").val(getParameterByName("tags", options.data.datasetsUri));
            $("#tab_metrics input#metrics").val(getParameterByName("metrics", options.data.datasetsUri));
        }
    }
    ;

    $(document).ready(function () {
        // datepicer
        var cb = function (start, end, label) {

            pickerstart = start;
            pickerend = end;
            pickerlabel = label;

            if (pickerlabel == "Custom")
            {
                $('#reportrange span').html(start.format('MM/DD/YYYY H:m:s') + ' - ' + end.format('MM/DD/YYYY H:m:s'));
            } else
            {
                $('#reportrange span').html(pickerlabel);
            }
        };
        var optionSet1 = {
            startDate: moment().subtract(5, 'minute'),
            endDate: moment(),
            minDate: moment().subtract(1, 'year'),
            maxDate: moment().add(1, 'days'),
            dateLimit: {
                days: 60
            },
            showDropdowns: true,
            showWeekNumbers: true,
            timePicker: true,
            timePickerIncrement: 15,
            timePicker12Hour: true,
            ranges: {
                'Last 5 minutes': [moment().subtract(5, 'minute'), moment()],
                'Last 15 minutes': [moment().subtract(15, 'minute'), moment()],
                'Last 30 minutes': [moment().subtract(30, 'minute'), moment()],
                'Last 1 hour': [moment().subtract(1, 'hour'), moment()],
                'Last 3 hour': [moment().subtract(3, 'hour'), moment()],
                'Last 6 hour': [moment().subtract(6, 'hour'), moment()],
                'Last 12 hour': [moment().subtract(12, 'hour'), moment()],
                'Last 24 hour': [moment().subtract(24, 'hour'), moment()],
            },
            opens: 'left',
            buttonClasses: ['btn btn-default'],
            applyClass: 'btn-small btn-primary',
            cancelClass: 'btn-small',
            format: 'MM/DD/YYYY H:m:s',
            separator: ' to ',
            locale: {
                applyLabel: 'Submit',
                cancelLabel: 'Clear',
                fromLabel: 'From',
                toLabel: 'To',
                customRangeLabel: 'Custom',
                daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
                monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                firstDay: 1
            }
        };
        $('#reportrange span').html("Last 5 minutes");

        $('#reportrange').daterangepicker(optionSet1, cb);
        pickerstart = optionSet1.startDate;

        $('#reportrange').on('show.daterangepicker', function () {
//            console.log("show event fired");
        });
        $('#reportrange').on('hide.daterangepicker', function () {
//            console.log("hide event fired");
        });
        $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
            console.log(picker);
            var request_index = getParameterByName("chart");
            if (request_index == null)
            {
                request_index = -1
            }
            if (request_index == -1)
            {
                dush_charts.forEach(redrawchart);
            } else
            {
                query = "?metrics=" + $("#metrics").val() + "&tags=" + $("#tags").val() + "&downsample=" + $("#down-sample").val();
                showsingleChart(request_index);
//                alert(dush_charts[request_index]);
//                redrawchart(dush_charts[request_index], request_index)
            }
        });
        $('#reportrange').on('cancel.daterangepicker', function (ev, picker) {
            console.log("cancel event fired");
        });
        $('#destroy').click(function () {
            $('#reportrange').data('daterangepicker').remove();
        });

        // end date picer

        rebuilsCarts(${dashInfo});
        $("#addrow").on("click", function () {
            $("#dashcontent").append($("#rowtemplate").html());
        });
        $('body').on("click", ".addchart", function () {
            $(this).parents(".x_content").first().find(".rowcontent").append($("#charttemplate").html());
            var ctx = $(this).parents(".x_content").first().find(".rowcontent").find(".lineChart").last();
            ctx.attr("datasetindex", dush_charts_options.length);
            var datasets = [];
            var d = [];
            for (i = 0; i < 100; i++)
            {
                defitemdata = {x: moment().subtract(i, "minute"), y: Math.random()};
                d.push(defitemdata);
            }

            defitem = {
                label: "new Chart",
                backgroundColor: "rgba(0, 255, 0, 0.31)",
                borderColor: "rgba(0, 255, 0, 0.7)",
                pointBorderColor: "rgba(0, 255, 0, 0.7)",
                pointBackgroundColor: "rgba(0, 255, 0, 0.7)",
                pointHoverBackgroundColor: "#fff",
                pointHoverBorderColor: "rgba(220,220,220,1)",
                pointBorderWidth: 0,
                data: d,
                pointRadius: 3,
                borderWidth: 2,
            };
            datasets.push(defitem);
            var options = JSON.parse(JSON.stringify(defoptions));
            options.data.datasets = datasets;
            dush_charts_options.push(options);
            lineChart = new Chart(ctx, JSON.parse(JSON.stringify(options)));
            dush_charts.push(lineChart);
            itemcount = $(this).parents(".x_content").first().find(".rowcontent").find(".lineChart").size();
            size = 12;
            if (itemcount < 12)
            {
                size = Math.round(12 / itemcount);
            } else
            {
                size = 1;
            }


            $(this).parents(".x_content").first().find(".rowcontent").find(".chartsection").attr("size", size);
            $(this).parents(".x_content").first().find(".rowcontent").find(".chartsection").attr("class", "chartsection col-lg-" + size);
        });
        $('body').on("click", ".plus", function () {
            block = $(this).parent().parent().parent();
            if (parseInt(block.attr("size")) < 12)
            {
                block.attr("size", (parseInt(block.attr("size")) + 1))
                block.attr("class", "chartsection col-lg-" + block.attr("size"));
            }
        });
        $('body').on("click", ".minus", function () {
            block = $(this).parent().parent().parent();
            if (parseInt(block.attr("size")) > 1)
            {
                block.attr("size", (parseInt(block.attr("size")) - 1))
                block.attr("class", "chartsection col-lg-" + block.attr("size"));
            }
        });

        $('body').on("click", ".editchart", function () {
            datasetindex = $(this).parents(".chartsection").find(".lineChart").attr("datasetindex")
            showsingleChart(datasetindex);
            window.history.pushState({}, "", "?chart=" + datasetindex);
        });

        $('body').on("click", ".backtodush", function () {
            $(".editchartpanel #singlewidget").html("");
            singleChart = null;
            $(".editchartpanel").hide();
            $(".fulldash").show();
//            dush_charts.forEach(redrawchart);
            window.history.pushState({}, "", "?");
            if (dush_charts.length > 0)
            {
                dush_charts.forEach(redrawchart);
            } else
            {
                rebuilsCarts(${dashInfo});
            }
        });

        $('body').on("blur", ".edit-query input", function () {
            datasetindex = $(".editchartpanel").attr("datasetindex");
            query = "?metrics=" + $("#metrics").val() + "&tags=" + $("#tags").val() + "&aggregator=" + $("#aggregator").val()+ "&downsample=" + $("#down-sample").val();
            options = dush_charts_options[datasetindex];
            options.data.datasetsUri = "${cp}/getdata" + query;
//            if (pickerlabel == "Custom")
//            {
//                query = query + "&startdate=" + picker.startDate + "&enddate=" + picker.endDate;
//            } else
//            {
//                query = query + "&startdate=" + rangeslabels[pickerlabel];
//            }

            var url = "${cp}/getdata" + query;
            drawchart(url, $(".editchartpanel #singlewidget").find(".lineChart").last(), options)
        });
        
        
        $('body').on("click", ".deletedash", function () {
            url = "${cp}/dashboard/delete";
            senddata = {};
            senddata.name = $("#name").val();
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            $.ajax({
                url: url,
                data: senddata,
                dataType: 'json',
                type: 'POST',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(header, token);
                },
                success: function (data) {
                    alert(data.sucsses);
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status + ": " + thrownError);
                }
            });
//
//            $.post(url, senddata, function (data) {
//                alert(JSON.stringify(data));
//            });

        });        
        
        $('body').on("click", ".savedash", function () {
            url = "${cp}/dashboard/save";
            to_senddata = {};
            senddata = {};
            if ($("#dashcontent .widgetraw").size() > 0)
            {
                $("#dashcontent .widgetraw").each(function (rawindex) {
//                    alert($(this).html());
                    if ($(this).find("canvas").size() > 0)
                    {
                        to_senddata["raw" + rawindex] = {};
                        $(this).find("canvas").each(function (index) {
                            dataindex = $(this).attr("datasetindex");
                            sendchartinfo = JSON.parse(JSON.stringify(dush_charts_options[dataindex]));
                            sendchartinfo.data.datasets.forEach(function (item) {
                                item.data = [];
                            });
                            to_senddata["raw" + rawindex]["chart" + dataindex] = sendchartinfo;
                        });
                    }

                })
            }

            senddata.info = JSON.stringify(to_senddata);
            senddata.name = $("#name").val();
            console.log(senddata);
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            $.ajax({
                url: url,
                data: senddata,
                dataType: 'json',
                type: 'POST',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(header, token);
                },
                success: function (data) {
//                    console.log(data);
                    alert(data.sucsses);
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status + ": " + thrownError);
                }
            });
//
//            $.post(url, senddata, function (data) {
//                alert(JSON.stringify(data));
//            });

        });
    });
    var defoptions = {
        type: 'line',
        data: {
            datasets: []
        },
        options: {
//            maintainAspectRatio: false,
            legend: {
                display: false,
            },
            tooltips: {
//                responsive
                enabled: true,
            },
            scales: {
                xAxes: [{
                        type: 'time',
                        position: 'bottom',
                        time: {
//                                    max: chartMaxDate,
                            displayFormats: {
                                second: "mm:ss",
                                minute: "HH:mm:ss",
                                houre: "HH:mm"
                            },
                            tooltipFormat: 'DD/MM/YYYY HH:mm:ss',
                        },
                    }]
            }
        }
    };
    function redrawchart(chart, index)
    {
        url = dush_charts_options[index].data.datasetsUri;
        if (pickerlabel == "Custom")
        {
            url = url + $("#down-sample").val() + "&startdate=" + pickerstart + "&enddate=" + pickerend;
        } else
        {
            if (typeof (rangeslabels[pickerlabel]) == "undefined")
            {
                url = url + "&startdate=5m-ago";
            } else
            {
                url = url + "&startdate=" + rangeslabels[pickerlabel];
            }

        }
        UpdateChart(chart, url);
    }

    function UpdateChart(chart, url)
    {
        var datasets = chart.data.datasets;
        $.getJSON(url, null, function (data) {
            var pos = 0;
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                var d = [];
                for (var time in chartline.data) {
                    itemdata = {x: time * 1, y: chartline.data[time]};
                    d.push(itemdata);
                }
                d.sort(function (a, b) {
                    return parseInt(a.x) - parseInt(b.x);
                });
//                console.log(pos);
//                console.log(datasets.length);
                if (pos < datasets.length)
                {
                    item = datasets[pos];
                    item.data = d;
                    item.label = chartline.metric + ":" + chartline.tags.host;
                } else
                {
                    item = {
                        label: chartline.metric + ":" + chartline.tags.host,
                        backgroundColor: "rgba(0, 255, 0, 0.31)",
                        borderColor: "rgba(0, 255, 0, 0.7)",
                        pointBorderColor: "rgba(0, 255, 0, 0.7)",
                        pointBackgroundColor: "rgba(0, 255, 0, 0.7)",
                        pointHoverBackgroundColor: "#fff",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointBorderWidth: 1,
                        data: d
                    };
                    datasets.push(item);
                }
                pos++;
            }

            chart.data.datasets = datasets;
            chart.update(0, true);
        });
    }

    function drawchart(url, ctx, options)
    {
        var datasets = [];
        var uri = url;
        if (pickerlabel == "Custom")
        {
            uri = url + "&startdate=" + pickerstart + "&enddate=" + pickerend;
        } else
        {
            uri = url + "&startdate=" + rangeslabels[pickerlabel];
        }
        $.getJSON(uri, null, function (data) {
            var pos = 0;
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                var d = [];
                for (var time in chartline.data) {
                    itemdata = {x: time * 1, y: chartline.data[time]};
                    d.push(itemdata);
                }
                d.sort(function (a, b) {
                    return parseInt(a.x) - parseInt(b.x);
                });
//                console.log(d.constructor.name);
                item = {
                    label: chartline.metric + ":" + chartline.tags.host,
                    backgroundColor: "rgba(0, 255, 0, 0.31)",
                    borderColor: "rgba(0, 255, 0, 0.7)",
                    pointBorderColor: "rgba(0, 255, 0, 0.7)",
                    pointBackgroundColor: "rgba(0, 255, 0, 0.7)",
                    pointHoverBackgroundColor: "#fff",
                    pointHoverBorderColor: "rgba(220,220,220,1)",
                    pointBorderWidth: 1,
                    data: d
                };
                datasets.push(item);
                pos++;
                if (pos == 6)
                    pos = 0;
            }
            options.data.datasets = datasets;
            options.data.datasetsUri = url;
            if (singleChart == null)
            {
                singleChart = new Chart(ctx, JSON.parse(JSON.stringify(options)));
            } else
            {
                singleChart.data.datasets = JSON.parse(JSON.stringify(datasets));
                singleChart.update(0, true);
            }

        });
    }
    ;
// TODO To some global js    
    function getParameterByName(name, url) {
        if (!url)
            url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
        if (!results)
            return null;
        if (!results[2])
            return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }


</script>        