
<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/echarts/theme/macarons.js"></script>

<script>
    $(document).ready(function () {
        // datepicer
        var cb = function (start, end, label) {

            pickerstart = start;
            pickerend = end;
            pickerlabel = label;

            if (pickerlabel == "Custom")
            {
                $('#reportrange span').html(start.format('MM/DD/YYYY H:m:s') + ' - ' + end.format('MM/DD/YYYY H:m:s'));
            } else
            {
                $('#reportrange span').html(pickerlabel);
            }
        };
        var optionSet1 = {
            startDate: moment().subtract(5, 'minute'),
            endDate: moment(),
            minDate: moment().subtract(1, 'year'),
            maxDate: moment().add(1, 'days'),
            dateLimit: {
                days: 60
            },
            showDropdowns: true,
            showWeekNumbers: true,
            timePicker: true,
            timePickerIncrement: 15,
            timePicker12Hour: true,
            ranges: {
                'Last 5 minutes': [moment().subtract(5, 'minute'), moment()],
                'Last 15 minutes': [moment().subtract(15, 'minute'), moment()],
                'Last 30 minutes': [moment().subtract(30, 'minute'), moment()],
                'Last 1 hour': [moment().subtract(1, 'hour'), moment()],
                'Last 3 hour': [moment().subtract(3, 'hour'), moment()],
                'Last 6 hour': [moment().subtract(6, 'hour'), moment()],
                'Last 12 hour': [moment().subtract(12, 'hour'), moment()],
                'Last 24 hour': [moment().subtract(24, 'hour'), moment()],
            },
            opens: 'left',
            buttonClasses: ['btn btn-default'],
            applyClass: 'btn-small btn-primary',
            cancelClass: 'btn-small',
            format: 'MM/DD/YYYY H:m:s',
            separator: ' to ',
            locale: {
                applyLabel: 'Submit',
                cancelLabel: 'Clear',
                fromLabel: 'From',
                toLabel: 'To',
                customRangeLabel: 'Custom',
                daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
                monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                firstDay: 1
            }
        };
        $('#reportrange span').html("Last 5 minutes");
        $('#reportrange').daterangepicker(optionSet1, cb);
    });


//    var theme = {
//        color: [
//            '#26B99A', '#34495E', '#BDC3C7', '#3498DB',
//            '#9B59B6', '#8abb6f', '#759c6a', '#bfd3b7'
//        ],
//
//        title: {
//            itemGap: 8,
//            textStyle: {
//                fontWeight: 'normal',
//                color: '#408829'
//            }
//        },
//
//        dataRange: {
//            color: ['#1f610a', '#97b58d']
//        },
//
//        toolbox: {
//            color: ['#408829', '#408829', '#408829', '#408829']
//        },
//
//        tooltip: {
//            backgroundColor: 'rgba(0,0,0,0.5)',
//            axisPointer: {
//                type: 'line',
//                lineStyle: {
//                    color: '#408829',
//                    type: 'dashed'
//                },
//                crossStyle: {
//                    color: '#408829'
//                },
//                shadowStyle: {
//                    color: 'rgba(200,200,200,0.3)'
//                }
//            }
//        },
//
//        dataZoom: {
//            dataBackgroundColor: '#eee',
//            fillerColor: 'rgba(64,136,41,0.2)',
//            handleColor: '#408829'
//        },
//        grid: {
//            borderWidth: 0
//        },
//
//        categoryAxis: {
//            axisLine: {
//                lineStyle: {
//                    color: '#408829'
//                }
//            },
//            splitLine: {
//                lineStyle: {
//                    color: ['#eee']
//                }
//            }
//        },
//
//        valueAxis: {
//            axisLine: {
//                lineStyle: {
//                    color: '#408829'
//                }
//            },
//            splitArea: {
//                show: true,
//                areaStyle: {
//                    color: ['rgba(250,250,250,0.1)', 'rgba(200,200,200,0.1)']
//                }
//            },
//            splitLine: {
//                lineStyle: {
//                    color: ['#eee']
//                }
//            }
//        },
//        timeline: {
//            lineStyle: {
//                color: '#408829'
//            },
//            controlStyle: {
//                normal: {color: '#408829'},
//                emphasis: {color: '#408829'}
//            }
//        },
//
//        k: {
//            itemStyle: {
//                normal: {
//                    color: '#68a54a',
//                    color0: '#a9cba2',
//                    lineStyle: {
//                        width: 1,
//                        color: '#408829',
//                        color0: '#86b379'
//                    }
//                }
//            }
//        },
//        map: {
//            itemStyle: {
//                normal: {
//                    areaStyle: {
//                        color: '#ddd'
//                    },
//                    label: {
//                        textStyle: {
//                            color: '#c12e34'
//                        }
//                    }
//                },
//                emphasis: {
//                    areaStyle: {
//                        color: '#99d2dd'
//                    },
//                    label: {
//                        textStyle: {
//                            color: '#c12e34'
//                        }
//                    }
//                }
//            }
//        },
//        force: {
//            itemStyle: {
//                normal: {
//                    linkStyle: {
//                        strokeColor: '#408829'
//                    }
//                }
//            }
//        },
//        chord: {
//            padding: 4,
//            itemStyle: {
//                normal: {
//                    lineStyle: {
//                        width: 1,
//                        color: 'rgba(128, 128, 128, 0.5)'
//                    },
//                    chordStyle: {
//                        lineStyle: {
//                            width: 1,
//                            color: 'rgba(128, 128, 128, 0.5)'
//                        }
//                    }
//                },
//                emphasis: {
//                    lineStyle: {
//                        width: 1,
//                        color: 'rgba(128, 128, 128, 0.5)'
//                    },
//                    chordStyle: {
//                        lineStyle: {
//                            width: 1,
//                            color: 'rgba(128, 128, 128, 0.5)'
//                        }
//                    }
//                }
//            }
//        },
//        gauge: {
//            startAngle: 225,
//            endAngle: -45,
//            axisLine: {
//                show: true,
//                lineStyle: {
//                    color: [[0.2, '#86b379'], [0.8, '#68a54a'], [1, '#408829']],
//                    width: 8
//                }
//            },
//            axisTick: {
//                splitNumber: 10,
//                length: 12,
//                lineStyle: {
//                    color: 'auto'
//                }
//            },
//            axisLabel: {
//                textStyle: {
//                    color: 'auto'
//                }
//            },
//            splitLine: {
//                length: 18,
//                lineStyle: {
//                    color: 'auto'
//                }
//            },
//            pointer: {
//                length: '90%',
//                color: 'auto'
//            },
//            title: {
//                textStyle: {
//                    color: '#333'
//                }
//            },
//            detail: {
//                textStyle: {
//                    color: 'auto'
//                }
//            }
//        },
//        textStyle: {
//            fontFamily: 'Arial, Verdana, sans-serif'
//        }
//    };


    var echartLine = echarts.init(document.getElementById('echart_line'), 'macarons');
    var date = [];
    var chdata = [];
    var dateval = moment();
    var url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=5d-ago";
    drawEchart(url);
    
    
    function drawEchart (url)
    {
        $.getJSON(url, null, function (data) {
            console.log(data);
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var time in chartline.data) {
                    dateval = moment(time * 1);
                    date.push(dateval.format("h:m:s"));
                    chdata.push(chartline.data[time]);
                }
            }
            echartLine.setOption({
                title: {
                    text: chartline.metric,
                    subtext: JSON.stringify(chartline.tags)
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    x: 220,
                    y: 40,
                    data: ['Intent', 'Pre-order', 'Deal']
                },
                toolbox: {
                    show: true,
                    feature: {
                        magicType: {
                            show: true,
                            title: {
                                line: 'Line',
                                bar: 'Bar',
                                stack: 'Stack',
                                tiled: 'Tiled'
                            },
                            type: ['line', 'bar', 'stack', 'tiled']
                        },
                        saveAsImage: {
                            show: true,
                            title: "Save Image"
                        }
                    }
                },
                calculable: true,
                xAxis: [{
                        type: 'category',
//                splitNumber:10
//                scale: 
//                boundaryGap: false,
                        data: date
                    }],
                yAxis: [{
                        type: 'value'
                    }],
                dataZoom: {
                    show: true,
                    realtime: true,
                    start: 90,
                    end: 100
                },
                series: [{
                        name: 'Deal',
                        type: 'line',
                        smooth: true,
                        sampling: 'average',
                        itemStyle: {
                            normal: {
                                areaStyle: {
                                    type: 'default'
                                }
                            }
                        },
                        data: chdata
                    }]
            });

        });        
    }
//    for (var i = 1; i < 200; i++) {
//        
//        date.push(dateval.format("h:m:s"));
//        dateval = dateval.subtract(1, 'hour');
//        data.push(Math.round((Math.random() - 0.5) * 20 + data[i - 1]));
//    }

</script>