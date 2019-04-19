/* global app */

$(document).ready(function () {
    
    $('#collapseSidebar').on('click', function () {
        $('#sidebar, #content').toggleClass('active');
        $('.collapse.show').toggleClass('show');
        $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        
        if ($('#collapseSidebar i').hasClass('fa-indent'))
        {
            $('#collapseSidebar i').removeClass('fa-indent');
            $('#collapseSidebar i').addClass('fa-outdent');
        } else
        {
            $('#collapseSidebar i').removeClass('fa-outdent');
            $('#collapseSidebar i').addClass('fa-indent');
        }
    });
   
//    $('#collapseFilters').on('click', function () {
//        if ($("button#collapseFilters i").hasClass('fa-indent'))
//        {
//            $("#collapseFilters i").removeClass('fa-indent');
//            $("#collapseFilters i").addClass('fa-outdent');
//            $('#filters').hide();
//        } else
//        {
//            $("#collapseFilters i").removeClass('fa-outdent');
//            $("#collapseFilters i").addClass('fa-indent');
//            $('#filters').show();
//        }
//    });
//    $('#collapseOptions').on('click', function () {
//        if ($("button#collapseOptions i").hasClass('fa-indent'))
//        {
//            $("#collapseOptions i").removeClass('fa-indent');
//            $("#collapseOptions i").addClass('fa-outdent');
//            $('#options').hide();
//        } else
//        {
//            $("#collapseOptions i").removeClass('fa-outdent');
//            $("#collapseOptions i").addClass('fa-indent');
//            $('#options').show();
//        }
//    });
//    $('#collapseNotifiers').on('click', function () {
//        if ($("button#collapseNotifiers i").hasClass('fa-indent'))
//        {
//            $("#collapseNotifiers i").removeClass('fa-indent');
//            $("#collapseNotifiers i").addClass('fa-outdent');
//            $('#notifiers').hide();
//        } else
//        {
//            $("#collapseNotifiers i").removeClass('fa-outdent');
//            $("#collapseNotifiers i").addClass('fa-indent');
//            $('#notifiers').show();
//        }
//    });
//    $('#collapseAll_msg').on('click', function () {
//        if ($("button#collapseAll_msg i").hasClass('fa-indent'))
//        {
//            $("#collapseAll_msg i").removeClass('fa-indent');
//            $("#collapseAll_msg i").addClass('fa-outdent');
//            $('#All_msg').hide();
//        } else
//        {
//            $("#collapseAll_msg i").removeClass('fa-outdent');
//            $("#collapseAll_msg i").addClass('fa-indent');
//            $('#All_msg').show();
//        }
//    });
//    $('#collapseMachine_msg').on('click', function () {
//        if ($("button#collapseMachine_msg i").hasClass('fa-indent'))
//        {
//            $("#collapseMachine_msg i").removeClass('fa-indent');
//            $("#collapseMachine_msg i").addClass('fa-outdent');
//            $('#Machine_msg').hide();
//        } else
//        {
//            $("#collapseMachine_msg i").removeClass('fa-outdent');
//            $("#collapseMachine_msg i").addClass('fa-indent');
//            $('#Machine_msg').show();
//        }
//    });
//    $('#collapseManual_msg').on('click', function () {
//        if ($("button#collapseManual_msg i").hasClass('fa-indent'))
//        {
//            $("#collapseManual_msg i").removeClass('fa-indent');
//            $("#collapseManual_msg i").addClass('fa-outdent');
//            $('#Manual_msg').hide();
//        } else
//        {
//            $("#collapseManual_msg i").removeClass('fa-outdent');
//            $("#collapseManual_msg i").addClass('fa-indent');
//            $('#Manual_msg').show();
//        }
//    });

//var $collapsBtnID;
//var $collapsBodyID;
//
//var $btnID = $('.markBtn').each(function() {
//  $collapsBtnID = '#'+($(this).attr('id'));
//  console.log($collapsBtnID);
//});
//var $bodyID = $('.markBody').each(function() {
//    $collapsBodyID = '#'+($(this).attr('id'));
//    console.log($collapsBodyID);
//});
//
//
//
//var $collapsBtn_i = $collapsBtnID + ' i';
//console.log($collapsBtn_i);
//
//var collaps = {
//    $btnID: $('.markBtn').each(function() {'#'+($(this).attr('id'));}),  
//    $bodyID: $('.markBody').each(function() {'#'+($(this).attr('id'));})
//};
//$.each(collaps, function () {
//   $.each(this, function (key, value) {
//    console.log(value);
//   });
//});
var id = [ 
 { '#collapseFilters': '#filters' },
 { '#collapseAll_msg': '#All_msg' },
 { '#collapseMachine_msg': '#Machine_msg' },
 { '#collapseManual_msg': '#Manual_msg' },
 { '#collapseOptions': '#options' },
 { '#collapseNotifiers': '#notifiers' }
];
    $.each(id, function () {
        $.each(this, function (name, value) {
            $(name).on('click', function () {
                if ($(name + " i").hasClass('fa-indent'))
                {
                    $(name + " i").removeClass('fa-indent');
                    $(name + " i").addClass('fa-outdent');
                    $(value).hide();
                } else
                {
                    $(name + " i").removeClass('fa-outdent');
                    $(name + " i").addClass('fa-indent');
                    $(value).show();
                }
            });
        });
    });
   





// ---- bootstrap-select ---- To style all selects//

//infrastructureFilter 
   
//    $("body").on("click", ".hidefilter", function () {
//        if ($(this).hasClass('fa-chevron-up'))
//        {
//            $(this).removeClass('fa-chevron-up');
//            $(this).addClass('fa-chevron-down');
//            $('.profile_left-form').hide();
//            $('.profile_right-table').css({'flex':'0 0 100%','max-width':'100%'});
//        } else
//        {
//            $(this).removeClass('fa-chevron-down');
//            $(this).addClass('fa-chevron-up');
//            $('.profile_left-form').show();
//            $('.profile_right-table').removeAttr('style');
//        }
//        if (typeof echartLine !== 'undefined')
//        {
//            echartLine.resize();
//        }
//    });
    
    $("body").on("click", ".hidefilter", function () {
        if ($("button#filterCollapse i").hasClass('fa-indent'))
        {
            $("#filterCollapse i").removeClass('fa-indent');
            $("#filterCollapse i").addClass('fa-outdent');
            $('.profile_left-form').hide();
            $('.profile_btn').hide();
            $('.profile_right-table').css({'flex':'0 0 100%','max-width':'100%'});
        } else
        {
            $("#filterCollapse i").removeClass('fa-outdent');
            $("#filterCollapse i").addClass('fa-indent');
            $('.profile_left-form').show();
            $('.profile_btn').show();
            $('.profile_right-table').removeAttr('style');
        }
        if (typeof echartLine !== 'undefined')
        {
            echartLine.resize();
        }
    });
    
    
    
    
    
//    $("#sidebar").mCustomScrollbar({
//        theme: "inset-3"
//    });

//linesHarmony
var linesHarmony = echarts.init(document.getElementById("linesHarmony"));

    option = {
        backgroundColor: '#394056',
        title: {
            text: '请求数',
            textStyle: {
                fontWeight: 'normal',
                fontSize: 16,
                color: '#F1F1F3'
            },
            left: '6%'
        },
        tooltip: {
            trigger: 'axis',
            enterable: true,
            formatter: function (params) {
                var colorSpan = color => '<span style="margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + color + '"></span>';
                var rez = "<div class='tooltip-body' style='width: 250px;height: 250px;overflow-x: auto;overflow-y: auto;'>" + params[0].axisValue;
                params.forEach(item => {
                    var xx = '</br>' + colorSpan(item.color) + ' ' + item.seriesName + ' : ' + item.data + '</br>';
                    rez += xx;
                });
                rez = rez + "</div>";
                return rez;
            },   
            axisPointer: {
                lineStyle: {
                    color: '#57617B'
                }
            }
        },
        legend: {
            icon: 'rect',
            itemWidth: 14,
            itemHeight: 5,
            itemGap: 13,
            data: ['移动', '电信', '联通'],
            right: '4%',
            textStyle: {
                fontSize: 12,
                color: '#F1F1F3'
            }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: [{
                type: 'category',
                boundaryGap: false,
                axisLine: {
                    lineStyle: {
                        color: '#57617B'
                    }
                },
                data: ['13:00', '13:05', '13:10', '13:15', '13:20', '13:25', '13:30', '13:35', '13:40', '13:45', '13:50', '13:55']
            }, {
                axisPointer: {
                    show: false
                },
                axisLine: {
                    lineStyle: {
                        color: '#57617B'
                    }
                },
                axisTick: {
                    show: false
                },

                position: 'bottom',
                offset: 20,
                data: ['', '', '', '', '', '', '', '', '', '', {
                        value: '周六',
                        textStyle: {
                            align: 'left'
                        }
                    }, '周日']
            }],
        yAxis: [{
                type: 'value',
                name: '单位（%）',
                axisTick: {
                    show: false
                },
                axisLine: {
                    lineStyle: {
                        color: '#57617B'
                    }
                },
                axisLabel: {
                    margin: 10,
                    textStyle: {
                        fontSize: 14
                    }
                },
                splitLine: {
                    lineStyle: {
                        color: '#57617B'
                    }
                }
            }],
        series: [
            {
                name: 'line_1',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(137, 189, 27, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(137, 189, 27, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {
                        color: 'rgb(137,189,27)',
                        borderColor: 'rgba(137,189,2,0.27)',
                        borderWidth: 12

                    }
                },
                data: [220, 182, 191, 134, 150, 120, 110, 125, 145, 122, 165, 122]
            },
            {
                name: 'line_2',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(0, 136, 212, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(0, 136, 212, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {
                        color: 'rgb(0,136,212)',
                        borderColor: 'rgba(0,136,212,0.2)',
                        borderWidth: 12

                    }
                },
                data: [120, 110, 129, 245, 224, 165, 122, 220, 182, 191, 134, 150]
            },
            {
                name: 'line_3',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(219, 50, 51, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(219, 50, 51, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {

                        color: 'rgb(219,50,51)',
                        borderColor: 'rgba(219,50,51,0.2)',
                        borderWidth: 12
                    }
                },
                data: [220, 182, 125, 145, 122, 191, 134, 150, 120, 110, 165, 122]
            },
            {
                name: 'line_4',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(255, 153, 51, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(255, 153, 51, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {

                        color: 'rgb(255, 153, 51)',
                        borderColor: 'rgba(255, 153, 51,0.2)',
                        borderWidth: 12
                    }
                },
                data: [120, 82, 225, 185, 142, 197, 164, 72, 81, 113, 135, 112]
            },
            {
                name: 'line_5',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(153, 204, 255, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(153, 204, 255, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {

                        color: 'rgb(153, 204, 255)',
                        borderColor: 'rgba(153, 204, 255,0.2)',
                        borderWidth: 12
                    }
                },
                data: [20, 62, 97, 56, 122, 88, 242, 180, 124, 146, 158, 132]
            },
            {
                name: 'line_6',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(128, 0, 255, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(128, 0, 255, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {

                        color: 'rgb(128, 0, 255)',
                        borderColor: 'rgba(2128, 0, 255,0.2)',
                        borderWidth: 12
                    }
                },
                data: [42, 63, 54, 91, 125, 132, 158, 129, 34, 80, 65, 72]
            },
            {
                name: 'line_7',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(64, 128, 0, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(64, 128, 0, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {

                        color: 'rgb(64, 128, 0)',
                        borderColor: 'rgba(64, 128, 0,0.2)',
                        borderWidth: 12
                    }
                },
                data: [14, 27, 35, 74, 61, 42, 57, 31, 48, 42, 52, 34]
            },
            {
                name: 'line_8',
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: 5,
                showSymbol: false,
                lineStyle: {
                    normal: {
                        width: 1
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0,
                                color: 'rgba(255, 255, 230, 0.3)'
                            }, {
                                offset: 0.8,
                                color: 'rgba(255, 255, 230, 0)'
                            }], false),
                        shadowColor: 'rgba(0, 0, 0, 0.1)',
                        shadowBlur: 10
                    }
                },
                itemStyle: {
                    normal: {

                        color: 'rgb(255, 255, 230)',
                        borderColor: 'rgba(255, 255, 230,0.2)',
                        borderWidth: 12
                    }
                },
                data: [250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250]
            },
        ]
    };
    
if (option && typeof option === "object") {
	linesHarmony.setOption(option, true);
}
    
//chart4  
    
var chart4 = echarts.init(document.getElementById("chart_4"));
var app = {};
option = null;
app.title = '笛卡尔坐标系上的热力图';

var hours = ['12a', '1a', '2a', '3a', '4a', '5a', '6a',
        '7a', '8a', '9a','10a','11a',
        '12p', '1p', '2p', '3p', '4p', '5p',
        '6p', '7p', '8p', '9p', '10p', '11p'];
var days = ['Saturday', 'Friday', 'Thursday',
        'Wednesday', 'Tuesday', 'Monday', 'Sunday'];

var dataMap = [[0,0,5],[0,1,1],[0,2,0],[0,3,0],[0,4,0],[0,5,0],[0,6,0],[0,7,0],[0,8,0],[0,9,0],[0,10,0],[0,11,2],[0,12,4],[0,13,1],[0,14,1],[0,15,3],[0,16,4],[0,17,6],[0,18,4],[0,19,4],[0,20,3],[0,21,3],[0,22,2],[0,23,5],[1,0,7],[1,1,0],[1,2,0],[1,3,0],[1,4,0],[1,5,0],[1,6,0],[1,7,0],[1,8,0],[1,9,0],[1,10,5],[1,11,2],[1,12,2],[1,13,6],[1,14,9],[1,15,11],[1,16,6],[1,17,7],[1,18,8],[1,19,12],[1,20,5],[1,21,5],[1,22,7],[1,23,2],[2,0,1],[2,1,1],[2,2,0],[2,3,0],[2,4,0],[2,5,0],[2,6,0],[2,7,0],[2,8,0],[2,9,0],[2,10,3],[2,11,2],[2,12,1],[2,13,9],[2,14,8],[2,15,10],[2,16,6],[2,17,5],[2,18,5],[2,19,5],[2,20,7],[2,21,4],[2,22,2],[2,23,4],[3,0,7],[3,1,3],[3,2,0],[3,3,0],[3,4,0],[3,5,0],[3,6,0],[3,7,0],[3,8,1],[3,9,0],[3,10,5],[3,11,4],[3,12,7],[3,13,14],[3,14,13],[3,15,12],[3,16,9],[3,17,5],[3,18,5],[3,19,10],[3,20,6],[3,21,4],[3,22,4],[3,23,1],[4,0,1],[4,1,3],[4,2,0],[4,3,0],[4,4,0],[4,5,1],[4,6,0],[4,7,0],[4,8,0],[4,9,2],[4,10,4],[4,11,4],[4,12,2],[4,13,4],[4,14,4],[4,15,14],[4,16,12],[4,17,1],[4,18,8],[4,19,5],[4,20,3],[4,21,7],[4,22,3],[4,23,0],[5,0,2],[5,1,1],[5,2,0],[5,3,3],[5,4,0],[5,5,0],[5,6,0],[5,7,0],[5,8,2],[5,9,0],[5,10,4],[5,11,1],[5,12,5],[5,13,10],[5,14,5],[5,15,7],[5,16,11],[5,17,6],[5,18,0],[5,19,5],[5,20,3],[5,21,4],[5,22,2],[5,23,0],[6,0,1],[6,1,0],[6,2,0],[6,3,0],[6,4,0],[6,5,0],[6,6,0],[6,7,0],[6,8,0],[6,9,0],[6,10,1],[6,11,0],[6,12,2],[6,13,1],[6,14,3],[6,15,4],[6,16,0],[6,17,0],[6,18,0],[6,19,0],[6,20,1],[6,21,2],[6,22,2],[6,23,6]];
dataMap = dataMap.map(function (item) {
                return [item[1], item[0], item[2] || '-'];
              });


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
        data: hours,
        splitArea: {
            show: true
        }
    },
    yAxis: {
        type: 'category',
        data: days,
        splitArea: {
           show: true
        }
   },
   visualMap: {
        min: 0,
        max: 10,
        calculable: true,
//        orient: 'verticale',
        orient: 'horizontal',
        left: 'center',
//        right:'1%',
        bottom: '10%'
    },
    series: [{
        name: 'Punch Card',
        type: 'heatmap',
        data: dataMap,
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
};;
if (option && typeof option === "object") {
    chart4.setOption(option, true);
}  
//graphic
    
var graphic = echarts.init(document.getElementById("graphic"));
var app = {};
option = null;
option = {
    color: ['#8EC9EB'],
    legend: {
        data:['高度(km)与气温(°C)变化关系']
    },
    tooltip: {
        trigger: 'axis',
        formatter: "Temperature : <br/>{b}km : {c}°C"
    },
    grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
    },
    xAxis: {
        type: 'value',
        splitLine: {
            show: false
        },
        axisLabel: {
            formatter: '{value} °C'
        }
    },
    yAxis: {
        type: 'category',
        axisLine: {onZero: false},
        axisLabel: {
            formatter: '{value} km'
        },
        boundaryGap: true,
        data: ['0', '10', '20', '30', '40', '50', '60', '70', '80']
    },
    graphic: [
        {
            type: 'image',
            id: 'logo',
            right: 20,
            top: 20,
            z: -10,
            bounding: 'raw',
            origin: [75, 75],
            style: {
                image: 'http://echarts.baidu.com/images/favicon.png',
                width: 150,
                height: 150,
                opacity: 0.4
            }
        },
        {
            type: 'image',
            id: 'logo2',
            right: 144,
            top: 56,
            z: -10,
            bounding: 'raw',
            origin: [50, 50],     
            style: {
                image: 'images/logo.png',
                shape: {
                    width: 80,
                    height: 60
                },
                opacity: 0.8            
            }
        },
        {
            type: 'group',
            rotation: Math.PI / 4,
            bounding: 'raw',
            right: 110,
            bottom: 110,
            z: 100,
            children: [
                {
                    type: 'rect',
                    left: 'center',
                    top: 'center',
                    z: 100,
                    shape: {
                        width: 400,
                        height: 50
                    },
                    style: {
                        fill: 'rgba(0,0,0,0.3)'
                    }
                },
                {
                    type: 'text',
                    left: 'center',
                    top: 'center',
                    z: 100,
                    style: {
                        fill: '#fff',
                        text: 'ECHARTS BAR CHART',
                        font: 'bold 26px Microsoft YaHei'
                    }
                }
            ]
        },
        {
            type: 'group',
            left: '10%',
            top: 'center',
            children: [
                {
                    type: 'rect',
                    z: 100,
                    left: 'center',
                    top: 'middle',
                    shape: {
                        width: 190,
                        height: 90
                    },
                    style: {
                        fill: '#fff',
                        stroke: '#555',
                        lineWidth: 2,
                        shadowBlur: 8,
                        shadowOffsetX: 3,
                        shadowOffsetY: 3,
                        shadowColor: 'rgba(0,0,0,0.3)'
                    }
                },
                {
                    type: 'text',
                    z: 100,
                    left: 'center',
                    top: 'middle',
                    style: {
                        fill: '#333',
                        text: [
                            '横轴表示温度，单位是°C',
                            '纵轴表示高度，单位是km',
                            '右上角有一个图片做的水印',
                            '这个文本块可以放在图中各',
                            '种位置'
                        ].join('\n'),
                        font: '14px Microsoft YaHei'
                    }
                }
            ]
        }
    ],
    series: [
        {
            name: '高度(km)与气温(°C)变化关系',
            type: 'bar',
            smooth: true,
            barCategoryGap: 25,
            lineStyle: {
                normal: {
                    width: 3,
                    shadowColor: 'rgba(0,0,0,0.4)',
                    shadowBlur: 10,
                    shadowOffsetY: 10
                }
            },
            data:[15, -50, -56.5, -46.5, -22.1, -2.5, -27.7, -55.7, -76.5]
        }
    ]
};

var rotation = 0;
setInterval(function () {
    graphic.setOption({
        graphic: {
            id: 'logo',
            rotation: (rotation -= Math.PI / 360) % (Math.PI * 2)
        }
    });
}, 30);;
setInterval(function () {
    graphic.setOption({
        graphic: {
            id: 'logo2',
            rotation: (rotation -= Math.PI / 360) % (Math.PI * 2)
        }
    });
}, 30);;
if (option && typeof option === "object") {
    graphic.setOption(option, true);
}       
//chart5

var chart5 = echarts.init(document.getElementById("chart_5"));
var app = {};
option = null;
chart5.showLoading();

var data1 = {
    "name": "flare",
    "children": [
        {
            "name": "data",
            "children": [
                {
                     "name": "converters",
                     "children": [
                      {"name": "Converters", "value": 721},
                      {"name": "DelimitedTextConverter", "value": 4294}
                     ]
                },
                {
                    "name": "DataUtil",
                    "value": 3322
                }
            ]
        },
        {
            "name": "display",
            "children": [
                {"name": "DirtySprite", "value": 8833},
                {"name": "LineSprite", "value": 1732},
                {"name": "RectSprite", "value": 3623}
           ]
        },
        {
            "name": "flex",
            "children": [
                {"name": "FlareVis", "value": 4116}
            ]
        },
        {
           "name": "query",
           "children": [
            {"name": "AggregateExpression", "value": 1616},
            {"name": "And", "value": 1027},
            {"name": "Arithmetic", "value": 3891},
            {"name": "Average", "value": 891},
            {"name": "BinaryExpression", "value": 2893},
            {"name": "Comparison", "value": 5103},
            {"name": "CompositeExpression", "value": 3677},
            {"name": "Count", "value": 781},
            {"name": "DateUtil", "value": 4141},
            {"name": "Distinct", "value": 933},
            {"name": "Expression", "value": 5130},
            {"name": "ExpressionIterator", "value": 3617},
            {"name": "Fn", "value": 3240},
            {"name": "If", "value": 2732},
            {"name": "IsA", "value": 2039},
            {"name": "Literal", "value": 1214},
            {"name": "Match", "value": 3748},
            {"name": "Maximum", "value": 843},
            {
             "name": "methods",
             "children": [
              {"name": "add", "value": 593},
              {"name": "and", "value": 330},
              {"name": "average", "value": 287},
              {"name": "count", "value": 277},
              {"name": "distinct", "value": 292},
              {"name": "div", "value": 595},
              {"name": "eq", "value": 594},
              {"name": "fn", "value": 460},
              {"name": "gt", "value": 603},
              {"name": "gte", "value": 625},
              {"name": "iff", "value": 748},
              {"name": "isa", "value": 461},
              {"name": "lt", "value": 597},
              {"name": "lte", "value": 619},
              {"name": "max", "value": 283},
              {"name": "min", "value": 283},
              {"name": "mod", "value": 591},
              {"name": "mul", "value": 603},
              {"name": "neq", "value": 599},
              {"name": "not", "value": 386},
              {"name": "or", "value": 323},
              {"name": "orderby", "value": 307},
              {"name": "range", "value": 772},
              {"name": "select", "value": 296},
              {"name": "stddev", "value": 363},
              {"name": "sub", "value": 600},
              {"name": "sum", "value": 280},
              {"name": "update", "value": 307},
              {"name": "variance", "value": 335},
              {"name": "where", "value": 299},
              {"name": "xor", "value": 354},
              {"name": "_", "value": 264}
             ]
            },
            {"name": "Minimum", "value": 843},
            {"name": "Not", "value": 1554},
            {"name": "Or", "value": 970},
            {"name": "Query", "value": 13896},
            {"name": "Range", "value": 1594},
            {"name": "StringUtil", "value": 4130},
            {"name": "Sum", "value": 791},
            {"name": "Variable", "value": 1124},
            {"name": "Variance", "value": 1876},
            {"name": "Xor", "value": 1101}
           ]
          },
        {
           "name": "scale",
           "children": [
            {"name": "IScaleMap", "value": 2105},
            {"name": "LinearScale", "value": 1316},
            {"name": "LogScale", "value": 3151},
            {"name": "OrdinalScale", "value": 3770},
            {"name": "QuantileScale", "value": 2435},
            {"name": "QuantitativeScale", "value": 4839},
            {"name": "RootScale", "value": 1756},
            {"name": "Scale", "value": 4268},
            {"name": "ScaleType", "value": 1821},
            {"name": "TimeScale", "value": 5833}
           ]
        }
    ]
};

var data2 = {
    "name": "flare",
    "children": [
        {
            "name": "flex",
            "children": [
                {"name": "FlareVis", "value": 4116}
            ]
        },
        {
            "name": "scale",
            "children": [
                {"name": "IScaleMap", "value": 2105},
                {"name": "LinearScale", "value": 1316},
                {"name": "LogScale", "value": 3151},
                {"name": "OrdinalScale", "value": 3770},
                {"name": "QuantileScale", "value": 2435},
                {"name": "QuantitativeScale", "value": 4839},
                {"name": "RootScale", "value": 1756},
                {"name": "Scale", "value": 4268},
                {"name": "ScaleType", "value": 1821},
                {"name": "TimeScale", "value": 5833}
           ]
        },
        {
            "name": "display",
            "children": [
                {"name": "DirtySprite", "value": 8833}
           ]
        }
    ]
};

chart5.hideLoading();

chart5.setOption(option = {
    tooltip: {
        trigger: 'item',
        triggerOn: 'mousemove'
    },
    legend: {
        top: '2%',
        left: '3%',
        orient: 'vertical',
        data: [{
            name: 'tree1',
            icon: 'rectangle'
        } ,
        {
            name: 'tree2',
            icon: 'rectangle'
        }],
    },
    
    series:[
        {
            type: 'tree',
            name: 'tree1',
            data: [data1],
            top: '5%',
            left: '7%',
            bottom: '2%',
            right: '42%',            
            symbolSize: 8,
            label: {
                normal: {
                    position: 'left',
                    verticalAlign: 'middle',
                    align: 'right'
                }
            },
            leaves: {
                label: {
                    normal: {
                        position: 'right',
                        verticalAlign: 'middle',
                        align: 'left'
                    }
                }
            },
            expandAndCollapse: true,
            animationDuration: 550,
            animationDurationUpdate: 750
        },
        {
            type: 'tree',
            name: 'tree2',
            data: [data2],
            top: '20%',
            left: '64%',
            bottom: '22%',
            right: '8%',
            symbolSize: 7,
            label: {
                normal: {
                    position: 'top',
                    verticalAlign: 'middle',
                    align: 'right'
                }
            },
            leaves: {
                label: {
                    normal: {
                        position: 'right',
                        verticalAlign: 'middle',
                        align: 'left'
                    }
                }
            },
            expandAndCollapse: true,
            animationDuration: 550,
            animationDurationUpdate: 750
        }
    ]
});;
if (option && typeof option === "object") {
    chart5.setOption(option, true);
} 
   
    //chart_rose
    
    var chartRose = echarts.init(document.getElementById("chart_rose"));
    var app = {};
    option = null;
    option = {
        backgroundColor: '#2c343c',       
        series: [
            {
                name: 'Rose',
                type: 'pie',
                radius: '55%',
                data: [                    
                    {value: 224, name: '视频广告'},                    
                    {value: 274, name: '联盟广告'},
                    {value: 310, name: '邮件营销'},
                    {value: 335, name: '直接访问'},
                    {value: 372, name: '直接访问'},
                    {value: 400, name: '搜索引擎'}
                ],
                roseType: 'angle',
                label: {
                    normal: {
                        textStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    }
                },
                itemStyle: {
                    normal: {
                        color: "#f8f8f8",
                        shadowBlur: 300,
                        shadowColor: 'rgba(0, 0, 0, 1)'
                    }
                }
            }
        ]
    };;
    
    if (option && typeof option === "object") {
       chartRose.setOption(option, true);
    }
    //chart_rose2
    
    var chartRose2 = echarts.init(document.getElementById("chart_rose2"));
    var app = {};
    option = null;
    option = {
        backgroundColor: '#2c343c',
        visualMap: {
        show: false,
        min: 80,
        max: 600,
        inRange: {
            colorLightness: [0, 1]
        }
    },
        series: [
            {
                name: 'Rose2',
                type: 'pie',
                radius: '55%',
                data: [
                        {value: 124, name: '视频广告'},
                        {value: 187, name: '视频广告'},
                        {value: 256, name: '视频广告'},
                       {value: 221, name: '搜索引擎'},
                       {value: 235, name: '视频广告'},
                       {value: 274, name: '联盟广告'},
                       {value: 299, name: '联盟广告'},
                       {value: 335, name: '直接访问'},
                       {value: 377, name: '搜索引擎'},
                       {value: 345, name: '搜索引擎'}                            
                ],
                roseType: 'angle',
                label: {
                    normal: {
                        textStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    }
                },
                itemStyle: {
                    normal: {
                        color: '#c23531',
                        shadowBlur: 300,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    },
                    emphasis: {
                        shadowBlur: 100,
                        shadowColor: 'rgba(255, 0, 0, 0.8)'
                    }
                }
            }
        ]
    };;
    
    if (option && typeof option === "object") {
       chartRose2.setOption(option, true);
    }
//bar_polar_stack

var dom = document.getElementById("bar_polar_stack");
var barPolarStack = echarts.init(dom, 'dark');
var app = {};
option = null;
option = {
    angleAxis: {
    },
    radiusAxis: {
        type: 'category',
        data: ['1', '2', '3', '4'],
        z: 10
    },
    polar: {
    },
    series: [{
        type: 'bar',
        data: [80, 70, 60, 50],
        coordinateSystem: 'polar',
        name: 'A',
        stack: 'a'
    }, {
        type: 'bar',
        data: [20, 40, 60, 80],
        coordinateSystem: 'polar',
        name: 'B',
        stack: 'a'
    }, {
        type: 'bar',
        data: [10, 20, 30, 40],
        coordinateSystem: 'polar',
        name: 'C',
        stack: 'a'
    }],
    legend: {
        show: true,
        data: ['A', 'B', 'C']
    }
};
;
if (option && typeof option === "object") {
    barPolarStack.setOption(option, true);
}
//bar_polar_stack2

var dom = document.getElementById("bar_polar_stack2");
var barPolarStack2 = echarts.init(dom,'dark');
var app = {};
option = null;
option = {
    angleAxis: {
    },
    radiusAxis: {
        type: 'category',
        data: ['1', '2', '3', '4'],
        z: 10
    },
    polar: {
    },
    series: [{
        type: 'bar',
        data: [80, 60, 70, 50],
        coordinateSystem: 'polar',
        name: 'A',
        stack: 'a'
    }, {
        type: 'bar',
        data: [20, 30, 50, 70],
        coordinateSystem: 'polar',
        name: 'B',
        stack: 'b'
    }, {
        type: 'bar',
        data: [10, 20, 60, 40],
        coordinateSystem: 'polar',
        name: 'C',
        stack: 'c'
    }],
    legend: {
        show: true,
        data: ['A', 'B', 'C']
    }
};
;
if (option && typeof option === "object") {
    barPolarStack2.setOption(option, true);
}

//chart_1

// based on prepared DOM, initialize echarts instance
        var chart1 = echarts.init(document.getElementById('chart_1'));
        // specify chart configuration item and data
        var option = {
            title: {
                text: 'ECharts entry example'
            },
            tooltip: {},
            legend: {
                data:['Sales']
            },
            xAxis: {
                data: ["shirt","cardign","chiffon shirt","pants","heels","socks"]
            },
            yAxis: {},
            series: [{
                name: 'Sales',
                type: 'bar',
                data: [5, 20, 34, 26, 32, 40]
            }]
        };
        // use configuration item and data specified to show chart
        chart1.setOption(option);
        
        //chart_2
var domEl = document.getElementById('chart_2');
var chart2 = echarts.init(domEl);
var option = {
    legend: {
              data:['7']
            },
    xAxis: {
        data: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    },
    yAxis: {},
    series: [{
        name: '7',    
        type: 'line',
        data: [70 , 120, 170, 210, 140, 200, 270]
    }]
};
chart2.setOption(option);

//chart_3
    var chart3 = echarts.init(document.getElementById('chart_3'));
    var app = {};
    option = null;
    option = {
        title: {
            text: 'grup',
            subtext: 'echartsInstance'
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                label: {
                    backgroundColor: '#283b56'
                }
            }
        },
        legend: {
            data: ['line', 'bar']
        },
        toolbox: {
            show: true,
            feature: {
                dataView: {readOnly: false},
                restore: {},
                saveAsImage: {}
            }
        },
        dataZoom: {
            show: false,
            start: 0,
            end: 100
        },
        xAxis: [
            {
                type: 'category',
                boundaryGap: true,
                data: (function () {
                    var now = new Date();
                    var res = [];
                    var len = 10;
                    while (len--) {
                        res.unshift(now.toLocaleTimeString().replace(/^\D*/, ''));
                        now = new Date(now - 2000);
                    }
                    return res;
                })()
            },
            {
                type: 'category',
                boundaryGap: true,
                data: (function () {
                    var res = [];
                    var len = 10;
                    while (len--) {
                        res.push(10 - len - 1);
                    }
                    return res;
                })()
            }
        ],
        yAxis: [
            {
                type: 'value',
                scale: true,
                name: 'Y_1',
                max: 30,
                min: 0,
                boundaryGap: [0.2, 0.2]
            },
            {
                type: 'value',
                scale: true,
                name: 'Y_2',
                max: 1200,
                min: 0,
                boundaryGap: [0.2, 0.2]
            }
        ],
        series: [
            {
                name: 'bar',
                type: 'bar',
                xAxisIndex: 1,
                yAxisIndex: 1,
                data: (function () {
                    var res = [];
                    var len = 10;
                    while (len--) {
                        res.push(Math.round(Math.random() * 1000));
                    }
                    return res;
                })()
            },
            {
                name: 'line',
                type: 'line',
                data: (function () {
                    var res = [];
                    var len = 0;
                    while (len < 10) {
                        res.push((Math.random() * 10 + 5).toFixed(1) - 0);
                        len++;
                    }
                    return res;
                })()
            }
        ]
    };

    app.count = 11;
    setInterval(function () {
        axisData = (new Date()).toLocaleTimeString().replace(/^\D*/, '');

        var data0 = option.series[0].data;
        var data1 = option.series[1].data;
        data0.shift();
        data0.push(Math.round(Math.random() * 1000));
        data1.shift();
        data1.push((Math.random() * 10 + 5).toFixed(1) - 0);

        option.xAxis[0].data.shift();
        option.xAxis[0].data.push(axisData);
        option.xAxis[1].data.shift();
        option.xAxis[1].data.push(app.count++);

        chart3.setOption(option);
    }, 2100);
    
    if (option && typeof option === "object") {
        chart3.setOption(option, true);
    }

//--------------//------------//
});