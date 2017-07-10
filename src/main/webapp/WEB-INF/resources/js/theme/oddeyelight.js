/* global define, format_date, format_data, format_metric */

//var colorPalette = ["#DDCCAA","#ADB9D8","#799AF2","#8899AA","#1ABAE9","#776655","#886611","#0082A8","#3F517F","#116688","#883311","#3D494C","#224499","#005566","#004E66","#2B2B2B","#002733","#101011","#000022"];

var colorPalette = [
    '#2ec7c9', '#5ab1ef', '#ffb980', '#d87a80', '#b6a2de',
    '#8d98b3', '#e5cf0d', '#97b552', '#95706d', '#dc69aa',
    '#07a2a4', '#9a7fd1', '#588dd5', '#f5994e', '#c05050',
    '#59678c', '#c9ab00', '#7eb00a', '#6f5553', '#c14089'
];


colorPalette.reverse();


var abcformater = function (params) {
    var formatter = params.data.unit;
    if (params.data.formatter)
    {
        formatter = params.data.formatter;
    }
    if (!formatter)
    {
        return  formatter;
    }
    var valueformatter = params.data.unit;
    if (typeof (window[valueformatter]) === "function")
    {
        valueformatter = window[valueformatter];
    }
    if (params.data.valueformatter)
    {
        valueformatter = params.data.valueformatter;
    }
    if (!valueformatter)
    {
        valueformatter = "{value}";
    }
    var value = params.value;
    if (params.value.constructor === Array)
    {
        value = params.value[1];
    }
    if (params.data.isinverse)
    {
        value = value * -1;
    }
    if (typeof (window[formatter]) === "function")
    {
        formatter = window[formatter](value);
    } else
    {
        formatter = formatter.replace(new RegExp("{a1}", 'g'), params.seriesName);
        formatter = formatter.replace(new RegExp("{a2}", 'g'), params.name);

        if (typeof (valueformatter) === "function")
        {
            formatter = formatter.replace(new RegExp("{value}", 'g'), valueformatter(value));
        } else
        {
            formatter = formatter.replace(new RegExp("{value}", 'g'), valueformatter.replace(new RegExp("{value}", 'g'), value.toFixed(2)));

        }
    }

    return formatter;
};

var encodeHTML = function (source) {
    return String(source)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
};

(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports, require('echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
}(this, function (exports, echarts) {
    var log = function (msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }

    var theme = {
        color: colorPalette,

        title: {
            textStyle: {
                fontWeight: 'normal',
                color: '#008acd'
            }
        },

        visualMap: {
            itemWidth: 15,
            color: ['#5ab1ef', '#e0ffff']
        },
        legend: {
            show: true
        },
        toolbox: {
            show: true,
            feature: {
                magicType: {
                    show: true,
                    title: {
                        line: 'Line',
                        bar: 'Bar',
                        stack: 'Stacked',
                        tiled: 'Tiled'
                    },
                    type: ['line', 'bar', 'stack', "tiled"]
                },
                saveAsImage: {
                    show: true,
                    title: "Save Image"
                }
            },
            iconStyle: {
                normal: {
//                    borderColor: colorPalette[0]
                }
            }
        },

        tooltip: {
            backgroundColor: 'rgba(50,50,50,0.5)',
            formatter: function (params) {
                
                var out = "";
                if (params.constructor === Array)
                {
                    out = params[0].name;
                    for (var ind in params)
                    {
                       
                        param = params[ind];                        
                        if (typeof (param.value) === 'undefined')
                        {
                            continue;
                        }

                        var value;
                        var firstparam = "";
                        if (param.value instanceof Array)
                        {
                            value = param.value[1];
                            firstparam = format_date(param.value[0], 0);
                        } else
                        {
                            value = param.value;
                        }
                        if (param.data.isinverse === true)
                        {
                            value = value * -1;
                        }
                        
                        if (param.data.unit)
                        {
                            
                            if (typeof (window[param.data.unit]) === "function")
                            {
                                value = window[param.data.unit](value);
                            } else
                            {
                                if (typeof (value) !== "string")
                                {
                                    value = value.toFixed(2);
                                }
                                value = param.data.unit.replace("{value}", value);
                            }
                        } else
                        {
                            console.log(param.data.unit);
                            console.log(param);
//                            value = format_metric(value);
                            if (typeof (value) !== "string")
                            {
                                if (param.data.isinverse === true)
                                {
                                    value = value * -1;
                                }
                                value = value.toFixed(2);
                            }

                        }
                        out = out + '<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + param.color + '"></span>' + firstparam + " " + param.seriesName + ' : ' + value;
                    }
                } else
                {
                    var value = params.data.value;
                    if (params.data.isinverse === true)
                    {
                        value = value * -1;
                    }
                    if (typeof value !== 'undefined')
                    {
                        if (value.constructor === Array)
                        {
                            if (typeof (window[params.data.unit]) === "function")
                            {
                                func = window[params.data.unit];
                            } else
                            {
                                func = format_metric;
                            }
                            if (params.componentSubType === "candlestick")
                            {
                                if (params.data.info)
                                {

                                    value = "<br>";
                                    for (var key in params.data.info)
                                    {
                                        value = value + key + ":" + func(params.data.info[key]) + "<br>";
                                    }
                                } else
                                {

                                    value = "<br>" + value[0] + "<br>" + value[1] + "<br>" + value[2] + "<br>" + value[3];
                                }

                            } else if (params.componentSubType === "boxplot")
                            {
                                if (params.data.info)
                                {

                                    value = "<br>";
                                    for (var key in params.data.info)
                                    {
                                        value = value + key + ":" + func(params.data.info[key]) + "<br>";
                                    }
                                } else
                                {
                                    value = "<br>" + value[0] + "<br>" + value[1] + "<br>" + value[2] + "<br>" + value[3];
                                }

                            } else if (params.componentSubType === "bar")
                            {
                                value = format_date(value[0], 0) + ":" + value[1].toFixed(2);
                                out = params.seriesName + '<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params.color + '"></span>' + value;
                                return out;

                            } else
                            {
                                value = value[1];
                                if (params.data.unit)
                                {
                                    if (typeof (window[params.data.unit]) === "function")
                                    {
                                        value = window[params.data.unit](value);
                                    } else
                                    {
                                        if (typeof (value) !== "string")
                                        {
                                            value = value.toFixed(2);
                                        }
                                    }
                                } else
                                {
                                    if (typeof (value) !== "string")
                                    {
                                        value = value.toFixed(2);
                                    }
//                                    value = format_metric(value);
                                }
                            }

                        } else
                        {
                            if (params.data.unit)
                            {
                                if (typeof (window[params.data.unit]) === "function")
                                {
                                    value = window[params.data.unit](value);
                                } else
                                {
                                    if (typeof (value) !== "string")
                                    {
                                        value = value.toFixed(2);
                                    }
                                    value = params.data.unit.replace("{value}", value);
                                }
                            }
                        }


                        if (params.componentSubType === "treemap")
                        {
                            var head = "";
                            for (var ii in params.treePathInfo)
                            {
                                if ((ii > 0) && (ii < (params.treePathInfo.length - 1)))
                                {
                                    head = head + " " + params.treePathInfo[ii].name;
                                }
                            }
                            out = head + '<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params.color + '"></span>' + params.name + ' : ' + value;
                        } else
                        {
                            out = params.seriesName + '<br><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:' + params.color + '"></span>' + params.name + ' : ' + value;
                        }

                    } else
                    {
                        if (params.componentSubType === "candlestick")
                        {
                            out = params.seriesName;
                        }
                    }
                }

                return out;
            },
            axisPointer: {
                type: 'line',
                lineStyle: {
                    color: '#008acd'
                },
                crossStyle: {
                    color: '#008acd'
                },
                shadowStyle: {
                    color: 'rgba(200,200,200,0.2)'
                }
            }
        },

        dataZoom: {
            dataBackgroundColor: '#efefff',
            fillerColor: 'rgba(182,162,222,0.2)',
            handleColor: '#008acd'
        },

        grid: {            
            left: 0,
            right: 20,
            top: 40,
            bottom: 5,
            containLabel: true
        },

        timeAxis: {
            splitNumber: 7,
            nameLocation: "middle",
            nameGap: 25,
//            axisLabel:
//                    {
//                        formatter: format_date
//                    },
            axisLine: {
                lineStyle: {
                    color: '#008acd'
                }
            },
            splitLine: {
                lineStyle: {
                    type: 'dashed',
                    width: 2,
                    color: ['#eee']
                }
            }
        },

        categoryAxis: {
            axisLine: {
                lineStyle: {
                    color: '#008acd'
                }
            },
            splitLine: {
                lineStyle: {
                    color: ['#eee']
                }
            }
        },
        animation: true,
        animationEasing: 'bounceOut',
        valueAxis: {
            axisLine: {
                lineStyle: {
                    color: '#008acd'
                }
            },
            splitArea: {
                show: true,
                areaStyle: {
                    color: ['rgba(250,250,250,0.2)', 'rgba(150,150,150,0.3)']
                }
            },
            splitLine: {
                lineStyle: {
                    color: ['#eee']
                }
            }
        },

        timeline: {
            lineStyle: {
                color: '#008acd'
            },
            controlStyle: {
                normal: {color: '#008acd'},
                emphasis: {color: '#008acd'}
            },
            symbol: 'emptyCircle',
            symbolSize: 3
        },
        line: {
            smooth: true,
            showSymbol: false,
            symbol: 'pin',
            symbolSize: 5,
            label: {
                normal: {
                    formatter: abcformater
                },
                emphasis: {
                    formatter: abcformater
                }
            }
        },

        candlestick: {
            itemStyle: {
                normal: {
                    color: '#d87a80',
                    color0: '#2ec7c9',
                    lineStyle: {
                        color: '#d87a80',
                        color0: '#2ec7c9'
                    }
                }
            }
        },

        scatter: {
            symbol: 'circle',
            symbolSize: 4
        },

        map: {
            label: {
                normal: {
                    textStyle: {
                        color: '#d87a80'
                    }
                }
            },
            itemStyle: {
                normal: {
                    borderColor: '#eee',
                    areaColor: '#ddd'
                },
                emphasis: {
                    areaColor: '#fe994e'
                }
            }
        },

        graph: {
            color: colorPalette
        },
        pie: {
            label: {
                normal: {
                    formatter: function (params) {
                        var formatter = params.data.formatter;
                        if (!formatter)
                        {
                            return formatter;
                        }
                        var valueformatter = params.data.unit;

                        if (typeof (window[params.data.unit]) === "function")
                        {
                            valueformatter = window[params.data.unit];
                        }
                        if (params.data.valueformatter)
                        {
                            valueformatter = params.data.valueformatter;
                        }
                        if (!valueformatter)
                        {
                            valueformatter = "{value}";
                        }

                        formatter = formatter.replace(new RegExp("{a1}", 'g'), params.seriesName);
                        formatter = formatter.replace(new RegExp("{a2}", 'g'), params.name);
                        formatter = formatter.replace(new RegExp("{p}", 'g'), params.percent);
                        if (typeof (valueformatter) === "function")
                        {
                            formatter = formatter.replace(new RegExp("{value}", 'g'), valueformatter(params.value));
                        } else
                        {
                            formatter = formatter.replace(new RegExp("{value}", 'g'), valueformatter.replace(new RegExp("{value}", 'g'), params.value));
                        }
                        return formatter;
                    }
                }
            }
        },
        funnel: {
            label: {
                normal: {
                    formatter: abcformater
                }
            }
        },
        bar: {
            label: {
                normal: {
                    formatter: abcformater
                }
            }
        },
        gauge: {
            tooltip: {
                formatter: function (params) {
                    var value = params.data.value;
                    if (typeof params.data.unit !== "undefined")
                    {
                        if (typeof (window[params.data.unit]) === "function")
                        {
                            value = window[params.data.unit](value);
                        } else
                        {
                            value = params.data.unit.replace("{value}", value);
                        }

                    }

                    return '<span style="font-size:16px;color:#fff">' + params.seriesName + "<br>" + '<span style="display:inline-block;margin-left:5px;color:#fff">' + params.data.subname + " : " + value + '</span></span>';
                }
            },
            axisLine: {
                lineStyle: {
                    width: 10,
                    color: [[0.2, colorPalette[2]], [0.8, colorPalette[7]], [1, colorPalette[0]]],
                    shadowColor: colorPalette[1],
                    shadowBlur: 10
                }
            },
            axisTick: {
                splitNumber: 10,
                length: 15,
                lineStyle: {
                    color: 'auto'
                }
            },
            splitLine: {
                length: 22,
                lineStyle: {
                    color: 'auto'
                }
            },
            pointer: {
                width: 5
            }
        }
    };

    echarts.registerTheme('oddeyelight', theme);
}));