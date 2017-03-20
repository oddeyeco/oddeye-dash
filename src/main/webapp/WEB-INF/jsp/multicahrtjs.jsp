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
        data: null
    };
    window.onresize = echartLine.resize;
    $(document).ready(function () {
        $('#reportrange span').html(pickerlabel);
        $('#reportrange').daterangepicker(PicerOptionSet1, cb);
        drawEchart(hashes, echartLine);
    });

    $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
        drawEchart(hashes, echartLine);
    });


    function drawEchart(hashes, echartLine, reload = false)
    {
        var requestcount = 0;
        var series = [];
        var legend = [];
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
            requestcount++;
            echartLine.showLoading("default", {
                text: '',
                color: colorPalette[0],
                textColor: '#000',
                maskColor: 'rgba(255, 255, 255, 0)',
                zlevel: 0
            });

            $.getJSON(url, null, function (data) {
                var chdata = [];
                requestcount--;

                for (key in data.chartsdata)
                {
                    var chartline = data.chartsdata[key];
                    chdata = chartline.data;
                    var serie = clone_obg(defserie);

//                    serie.data = chdata;
                    serie.data = [];
                    for (var ind in chdata)
                    {
                        serie.data.push({value: chdata[ind], 'unit': "format_metric"});
                    }
                    var name = data.chartsdata[key].metric + JSON.stringify(data.chartsdata[key].tags)
                    serie.name = name;
                    series.push(serie);
                    legend.push(name);
                    if (requestcount == 0)
                    {
                        echartLine.hideLoading();
                        series.sort(function (a, b) {
                            return compareStrings(a.name, b.name);
                        });
                        if (!reload)
                        {
                            echartLine.setOption({
                                title: {
                                    text: ""
                                },
                                tooltip: {
                                    trigger: 'axis'
                                },
                                toolbox: {},
                                xAxis: [{
                                        type: 'time',
                                    }],
                                yAxis: [{
                                        type: 'value',
                                        axisLabel:
                                                {
                                                    formatter: format_metric
                                                },
                                    }],
                                dataZoom: [{
                                        type: 'inside',
                                        xAxisIndex: 0,
                                        show: true,
                                        start: 0,
                                        end: 100
                                    }],
                                series: series
                            });
                        } else
                        {
                            echartLine.setOption({series: series});
                            echartLine.resize();
                        }
                        timer = setTimeout(function () {
                            drawEchart(hashes, echartLine, true);
                        }, interval);
                    }
                }
            })
                    .done(function () {
                    })
                    .fail(function (jqXHR, textStatus, errorThrown) {
                        console.log('getJSON request failed! ' + textStatus);
                    })
                    ;
        });        
    }       
</script>    