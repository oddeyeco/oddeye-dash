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
    //http://localhost:8080/OddeyeCoconut/getdata?metrics=cpu_user;cpu_idle;&tags=&aggregator=none&downsample=5m-avg&startdate=1h-ago&enddate=now
    var uri = "/OddeyeCoconut/getdata?metrics=cpu_user;cpu_idle;&tags=core=all;&aggregator=none&downsample=2m-max&startdate=1h-ago&enddate=now";
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
            console.log(data.chartsdata);
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
                return [moment(+itm).format("HH:mm")]+"\n"+ [moment(+itm).format("MM/DD")];
            });
            ydata = Object.keys(yjson);

            var max = numbers.basic.max(ydata);
            var i = 0;
            var step = (max-i) / 10;
            var ydataF = [];
            var ydataS = [];
            
            while (i < max)
            {
                ydataF.push(+i.toFixed(2));
                ydataS.push(i.toFixed(2));
                i = i + step;
            }
//            i = i + step;
//            ydataF.push(i.toFixed(2));
            ydataF.push(+max.toFixed(2));
            ydataS.push(+max.toFixed(2));

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
            console.log(ydataF);
            for (var index in data.chartsdata)
            {
                data.chartsdata[index].data.map(function (item) {
                    var hasdata = false;
                    j = 0;
                    for (j in xdata)
                    {
                        for (i in ydataF)
                        {
                            if ((item[0] === +xdata[j]) && (item[1] < ydataF[i]))
                            {
                                hasdata = true;
                                break;
                            }
                        }
                        if (hasdata)
                            break;
                    }
                    i=i-1;
                    if (hasdata)
                    {
//                        console.log(data.chartsdata[index]);
                        if (!chdata[data.chartsdata[index].metric])
                        {
                            chdata[data.chartsdata[index].metric] = [];
                        }
                        if (!datamap[i])
                        {
                            datamap[i] = {};
                        }
                        if (!datamap[i][j])
                        {                                  //TODO ALIAS 1
                            datamap[i][j] = {items:[],name:data.chartsdata[index].metric,time:xdata[j],alias:""};
                        }
                        datamap[i][j].items.push(item);                //TODO ALIAS 2 
                        datamap[i][j].alias=datamap[i][j].alias+"<br>"+data.chartsdata[index].tags.host+'('+item[1].toFixed(2)+')';
                        datamax = Math.max(datamax, datamap[i][j].items.length);
                    }
                });
            }



            for (var i in datamap)
            {
                for (var j in datamap[i])
                {
//                    console.log(datamap[i][j]);
                    var vals= datamap[i][j].items.map(function(it){
                        return it[1];
                    });
                    vals.sort();                    
                    chdata[datamap[i][j].name].push([+j, +i,datamap[i][j].items.length,datamap[i][j].time, vals[0].toFixed(2), vals[vals.length-1].toFixed(2),"unit",datamap[i][j].alias,  datamap[i][j].items.length]);
                }
            }


//            console.log(datamax);


            var data = [];
//            data = chdata;
//            console.log(chdata);
            for (var index in chdata)
            {
                data.push({
                    name: index,
                    type: 'heatmap',
                    data: chdata[index],
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
                })
            }
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
                    data: ydataS,
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
                series: data
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