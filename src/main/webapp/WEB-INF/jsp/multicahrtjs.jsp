<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    pickerlabel = "Last 1 hour";

    var hashes =${hashes};
    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var timer;    
    var interval = 10000;
    series = [];

    var defserie = {
        name: null,
        type: 'line',
        sampling: 'average',
        data: null
    };
    window.onresize = echartLine.resize;
    $(document).ready(function () {
        $('#reportrange span').html(pickerlabel);
        $('#reportrange').daterangepicker(PicerOptionSet1, cb);
//        clearTimeout(timer);
        drawEchart(hashes, echartLine);
//        timer = setInterval(function () {
//            drawEchart(hashes, echartLine);
//        }, interval);
    });

    $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
//        clearTimeout(timer);
        drawEchart(hashes, echartLine);
//        timer = setInterval(function () {
//            drawEchart(hashes, echartLine);
//        }, interval);
    });


    function drawEchart(hashes, echartLine, reload = false)
    {
        var requestcount = 0;
        hashes.forEach(function (item, i, arr) {
            var url;
            if (pickerlabel == "Custom")
            {
                url = "${cp}/getdata?hash=" + item + "&startdate=" + pickerstart + "&enddate=" + pickerend;
            } else
            {
                if (typeof (rangeslabels[pickerlabel]) == "undefined")
                {
                    url = "${cp}/getdata?hash=" + item + "&startdate=1d-ago";
                } else
                {
                    url = "${cp}/getdata?hash=" + item + "&startdate=" + rangeslabels[pickerlabel];
                }

            }
            series = [];
            legend = [];
            requestcount++;
            $.getJSON(url, null, function (data) {
                var chdata = [];
                requestcount--;
                
                for (key in data.chartsdata)
                {
                    var chartline = data.chartsdata[key];

                    for (var time in chartline.data) {
                        var dateval = moment(time * 1);
                        chdata.push([dateval.toDate(), chartline.data[time]]);
                    }
                    var serie = clone_obg(defserie);

                    serie.data = chdata;
                    var name = data.chartsdata[key].metric + JSON.stringify(data.chartsdata[key].tags)
                    serie.name = name;
                    series.push(serie);
                    legend.push(name);                                                            
                    if (requestcount==0)
                    {                        
                        series.sort(function (a, b) {
                            return compareStrings(a.name, b.name);
                        });
                        if (!reload)
                        {
                            echartLine.setOption({
                                title: {
                                    show: false,
                                },
                                tooltip: {
                                    trigger: 'axis'
                                },
                                legend: {
                                    data: legend
                                },
//                                animation: false,
                                toolbox: {
                                    show: true,
                                    feature: {
                                        magicType: {
                                            show: true,
                                            title: {
                                                line: 'Line',
                                                bar: 'Bar',
                                            },
                                            type: ['line', 'bar']
                                        },
                                        saveAsImage: {
                                            show: true,
                                            title: "Save Image"
                                        }
                                    }
                                },
                                grid: {
                                    x: 90,
                                    y: 40,
                                    x2: 20,
                                    y2: 80
                                },
                                xAxis: [{
                                        type: 'time',
                                        splitNumber: 20,
//                                        axisLabel: {
//                                            formatter: format_date
//                                        }
                                    }],
                                yAxis: [{
                                        type: 'value',
                                        axisLabel: {
                                            formatter: format_data
                                        }
                                    }],
                                dataZoom: {
                                    show: true,
                                    start: 0,
                                    end: 100
                                },
                                series: series
                            });
                        } else
                        {
                            echartLine.setOption({series: series});
//                           echartLine.setSeries(series); 
                            echartLine.resize();
                        }
                        timer = setTimeout(function () {
                            drawEchart(hashes, echartLine, true);
                        }, interval);
                    }
                }
            })
                    .done(function () {
//                        console.log('getJSON request succeeded!');
                    })
                    .fail(function (jqXHR, textStatus, errorThrown) {
                        console.log('getJSON request failed! ' + textStatus);
                    })
                    ;
        });        
    }       
</script>    