<%-- 
    Document   : testjs
    Created on : Apr 26, 2017, 12:06:56 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>
<!--<script src="${cp}/resources/echarts/dist/extension/dataTool.min.js?v=${version}"></script>-->
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
<script src="${cp}/resources/numbersjs/src/numbers.min.js?v=${version}"></script>

<script>
    var uri = "/OddeyeCoconut/getdata?metrics=cpu_user;;&tags=core=all;&aggregator=none&downsample=2m-max&startdate=1h-ago&enddate=now";
    var xjson = {};
    var xdata = {};
    var yjson = {};
    var ydata = {};
    var chdata = [];
    $.ajax({
        dataType: "json",
        url: uri,
        data: null,
        success: function (data) {
//            console.log(data.chartsdata);
            for (var index in data.chartsdata)
            {
//                console.log(data.chartsdata[index]);
                data.chartsdata[index].data.map(function (item) {
                    xjson[+item[0]] = item;
                    yjson[+item[1]] = item;
                });
            }
            xdata = Object.keys(xjson);
            xdata.sort();
            xdataF = xdata.map(function (itm) {
                return [moment(+itm).format("HH:mm")];
            });
            ydata = Object.keys(yjson);

            var max = numbers.basic.max(ydata);
            var step =max/20;
            var ydataF = [];
            var i = 0;
            while (i < max)
            {
                ydataF.push(i.toFixed(2));
                i = i + step;
            }
            i = i + step;
            ydataF.push(i.toFixed(2));
//            ydataF.push(max.toFixed(2));

//            console.log(max);
//            console.log(ydata);

            var hours = ['12a', '1a', '2a', '3a', '4a', '5a', '6a',
                '7a', '8a', '9a', '10a', '11a',
                '12p', '1p', '2p', '3p', '4p', '5p',
                '6p', '7p', '8p', '9p', '10p', '11p'];

            var days = ['Saturday', 'Friday', 'Thursday',
                'Wednesday', 'Tuesday', 'Monday', 'Sunday'];

            var hasdata = false;
            var j = 0;
            var i = 0;
            /*            
             for (j in xdata)
             {
             console.log(xjson[xdata[j]]);
             for (i in ydataF)
             {
             hasdata = false;
             if (xjson[xdata[i]][1] < ydataF[i])
             {
             chdata.push([+i, +j, 5]);
             hasdata = true;
             break;
             }
             }
             if (hasdata)
             {
             console.log("hasdata");
             console.log(i);
             }
             }
             */
//            console.log(max);
            var datamap = {};
            var datamax = 0;
            for (var index in data.chartsdata)
            {
                data.chartsdata[index].data.map(function (item) {
                    var hasdata = false;
                    j = 0;
                    for (j in xdata)
                    {
                        for (i in ydataF)
                        {
                            if ((item[0] === +xdata[j]) && (item[1] <= ydataF[i]))
                            {
                                hasdata = true;
                                break;
                            }
                        }
                        if (hasdata)
                            break;
                    }

                    if (hasdata)
                    {
                        if (!datamap[i])
                        {
                            datamap[i] = {};
                        }
                        if (!datamap[i][j])
                        {
                            datamap[i][j] = 0;
                        }                        
                        datamap[i][j] = datamap[i][j] + 1;
                        datamax = Math.max(datamax,datamap[i][j]);
                        chdata.push([+j, +i, datamap[i][j]]);
                    }
                });
            }
//            console.log(datamax);


            var data = [[0, 0, 10]];
            data = chdata;
//            console.log(chdata);
//            data = chdata.map(function (item) {
//                return [item[1], item[0], item[2] || '-'];
//            });
//    console.log(data);
            option = {
                tooltip: {
                    position: 'top'
                },
                animation: false,
                grid: {
                    height: '50%',
                    y: '10%'
                },
                xAxis: {
                    type: 'category',
                    data: xdataF,
                    splitLine: {
                        show: true,
                        lineStyle: {
                            color: ["#aaa"]
                        }
                    }
                },
                yAxis: {
                    type: 'category',
                    data: ydataF,
                    splitLine: {
                        show: true,
                        lineStyle: {
                            color: ["#aaa"]
                        }
                    }
                },
                visualMap: {
                    min: 0,
                    max: datamax,
                    color: ['#00FF00', '#0000ff', '#ff0000'],
                    calculable: true,
                    orient: 'horizontal',
                    left: 'center',
                    top: '0'
                },
                series: [{
                        name: 'Series1 ',
                        type: 'heatmap',
                        data: data,
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
            var echartLine = echarts.init(document.getElementById("echart_line"), 'oddeyelight');
            echartLine.setOption(option);

        },
        error: function (xhr, error) {
//            chart.hideLoading();
//            $(chart._dom).before("<h2 class='error'>Invalid Query");
        }
    });





</script>