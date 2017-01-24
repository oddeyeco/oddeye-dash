<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/echarts/theme/macarons.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    pickerlabel = "Last 1 day";

    var hashes =${hashes};
    var echartLine = echarts.init(document.getElementById('echart_line'), 'macarons');
    var timer;
    var cp = "${cp}";
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


    function drawEchart(hashes, echartLine)
    {
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
            $.getJSON(url, null, function (data) {
                var chdata = [];

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
                    if (series.length == hashes.length)
                    {
//                        console.log(series);
                        echartLine.setOption({
                            title: {
                                show: false,                                
                            },
                            tooltip: {
                                trigger: 'axis'
                            },
//                    legend: {
//                        data: legend
//                    },
                            animation: false,
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
                                }],
                            yAxis: [{
                                    type: 'value',
                                    axisLabel: {
                                        formatter: format_func
                                    }
                                }],
                            dataZoom: {
                                show: true,
                                start: 0,
                                end: 100
                            },
                            series: series
                        });

                        timer = setTimeout(function () {
                            drawEchart(hashes, echartLine);
                        }, interval);
                    }
                }
            });
        });        
    }       
</script>    