<script>
    dush_charts_options = [];
    dush_charts = [];
    var singleChart = null;
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

    function rebuilsCarts(Dashinfo)
    {
//            Dashinfo = {};
        if (typeof Dashinfo == "undefined")
        {
            return false;
        }
//        alert(Dashinfo.constructor.name);
        for (var index in Dashinfo) {
            var row = Dashinfo[index];
            $("#dashcontent").append($("#rowtemplate").html());
            for (var chartindex in row) {
                $("#dashcontent .rowcontent:last").append($("#charttemplate").html());
                var ctx = $("#dashcontent .rowcontent:last").find(".lineChart").last();
                ctx.attr("datasetindex", dush_charts_options.length);
                options = row[chartindex];
                console.log(options);
                dush_charts_options.push(options);
//            legend: {
//                display: false,
//            },                
                options.options.legend = {};    
                options.options.legend.display = false;
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
        dush_charts.forEach(redrawchart);
    }

    $(document).ready(function () {

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
            drawchart(url, ctx, options);
//            console.log(options);  
//            singleChart = new Chart(ctx, JSON.parse(JSON.stringify(options)));
            $(".editchartpanel").attr("datasetindex", datasetindex);
            $(".fulldash").hide();
            //Fill edit form
            console.log(options.data.datasetsUri);
//            console.log(options.data.datasetsUri);
            if (typeof (options.data.datasetsUri) == "undefined")
            {
                $("#tab_metrics input#tags").val("");
                $("#tab_metrics input#metrics").val("");
                $("#tab_metrics input#down-sample").val("");
            } else
            {
//                dsadsa
//                var url = document.createElement('a');
//                url.href = options.data.datasetsUri;
                $("#tab_metrics input#tags").val(getParameterByName("tags", options.data.datasetsUri));
                $("#tab_metrics input#metrics").val(getParameterByName("metrics", options.data.datasetsUri));
            }
        });
        $('body').on("click", ".backtodush", function () {
            $(".editchartpanel #singlewidget").html("");
            singleChart = null;
            $(".editchartpanel").hide();
            $(".fulldash").show();
            dush_charts.forEach(redrawchart)
//            redrawchart(dush_charts[0]);
        });
//        $("input").blur()
        $('body').on("blur", ".edit-query input", function () {
            datasetindex = $(".editchartpanel").attr("datasetindex");
            query = "?metrics=" + $("#metrics").val() + "&tags=" + $("#tags").val() + "&downsample=" + $("#down-sample").val();
            options = dush_charts_options[datasetindex];
            var url = "${cp}/getdata" + query;
            drawchart(url, $(".editchartpanel #singlewidget").find(".lineChart").last(), options)
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
//            console.log(senddata);
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            $.ajax({
                url: url,
                data: senddata,
                type: 'POST',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(header, token);
                },
                success: function (data) {
                    alert(JSON.stringify(data));
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
                                second: "HH:mm:ss",
                                minute: "HH:mm:ss"
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
//        console.log("URL=" + url);
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
//        var url = "${cp}/getdata" + query;
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
</script>    