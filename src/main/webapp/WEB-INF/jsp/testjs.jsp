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
        var url = cp + "/getdata?metrics=sys_load_1;&tags=group=*;&aggregator=max&downsample=1h-max&startdate=1d-ago&enddate=now"
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
                ydata.push(metric.tags.group);
                for (var ind in metric.data)
                {
                    var times = moment(metric.data[ind][0]);
                    var h = times.minute();

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
                    var h = times.minute();

                    var xindex = xdata.indexOf(h);
                    s_data.push([xindex, yindex,  metric.data[ind][1].toFixed(2)]);

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
                    
                    height: '80%',                    
                },

                visualMap: {                    
                    min: 0,
                    max: 15,
                    calculable: true,
                    realtime: false,                    
                    orient: 'horizontal',
                    left: 'center',
                    top: '0',
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
                                shadowBlur: 20,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'                                
                            }
                        },
                        label: {                            
                            normal: {
                                show: true,                                
                            }
                        },
                    }]
            };
            echartLine.setOption(option);
        });
    });

</script>