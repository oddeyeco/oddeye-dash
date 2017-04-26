<%-- 
    Document   : testjs
    Created on : Apr 26, 2017, 12:06:56 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    $(document).ready(function () {
        var url = cp + "/getdata?metrics=bytes_rx_eth0;&tags=cluster=*;&aggregator=none&downsample=1h-max&startdate=1d-ago&enddate=now"
        var echartLine = echarts.init(document.getElementById("echart_line"), 'oddeyelight');

        $.getJSON(url, null, function (data) {
            console.log(data.chartsdata);
            var ydata = [];
            var xdata = [];
            var s_data = [];
            var yindex = 0;
            for (var index in data.chartsdata)
            {
                var metric = data.chartsdata[index];
                ydata.push(metric.tags.host);
                for (var ind in metric.data)
                {
                    var times = moment(metric.data[ind][0]);
                    var h = times.hour() + 1;

                    if (xdata.indexOf(h) === -1)
                    {
                        xdata.push(h);
//                        xdata.sort(function (a, b) {
//                            return a - b;
//                        });
                    }
                }

                for (var ind in metric.data)
                {
                    var times = moment(metric.data[ind][0]);
                    var h = times.hour() + 1;

                    var xindex = xdata.indexOf(h);
                    s_data.push([xindex, yindex,  metric.data[ind][1]]);

                }

                yindex = yindex + 1;
            }
            console.log(xdata);

            var option = {
                tooltip: {},
                xAxis: {
                    type: 'category',
                    data: xdata
                },
                yAxis: {
                    type: 'category',
                    data: ydata
                },
                grid: {
                    left: "170",
                    height: '50%',
                    y: '10%'
                },

                visualMap: {                    
                    min: 0,
                    max: 70000000,
                    calculable: true,
                    realtime: false,
                    orient: 'horizontal',
                    left: 'center',
                    bottom: '15%',
                    inRange: {
                        color: ['#313695', '#4575b4', '#74add1', '#abd9e9', '#e0f3f8', '#ffffbf', '#fee090', '#fdae61', '#f46d43', '#d73027', '#a50026']
                    }
                },
                series: [{
                        name: 'Gaussian',
                        type: 'heatmap',
                        data: s_data,
                        itemStyle: {
                            emphasis: {
                                borderColor: '#333',
                                borderWidth: 1
                            }
                        },
                        label: {
                            normal: {
                                show: true
                            }
                        },
                        itemStyle: {
                            emphasis: {
                                shadowBlur: 10,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }
                    }]
            };
            echartLine.setOption(option);
        });
    });

</script>