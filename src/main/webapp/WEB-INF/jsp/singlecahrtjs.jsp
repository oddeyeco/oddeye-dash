
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
                'Last 1 day': [moment().subtract(24, 'hour'), moment()],
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
        $('#reportrange span').html("Last 1 day");
        $('#reportrange').daterangepicker(optionSet1, cb);
    });


    var echartLine = echarts.init(document.getElementById('echart_line'), 'macarons');
    var url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=1d-ago";
    drawEchart(url);
    function drawEchart(url)
    {
        $.getJSON(url, null, function (data) {
//            console.log(data);
            var date = [];
            var chdata = [];
            var dateval = moment();
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var time in chartline.data) {
                    dateval = moment(time * 1);
                    date.push(dateval.format("HH:mm:ss"));
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
                toolbox: {
                    show: true,
                    feature: {
                        magicType: {
                            show: true,
                            title: {
                                line: 'Line',
                                bar: 'Bar',
//                                stack: 'Stack',
//                                tiled: 'Tiled'
                            },
                            type: ['line', 'bar']
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
                        data: date
                    }],
                yAxis: [{
                        type: 'value',
                    }],
                dataZoom: {
                    show: true,
                    realtime: true,
                    start: 0,
                    end: 100
                },
                series: [{
                        name: chartline.metric,
                        type: 'line',
                        sampling: 'average',
                        itemStyle: {
                            normal: {
                                areaStyle: {
                                    type: 'default'
                                }
                            }
                        },
                        markPoint: {
                            data: [
                                {type: 'max', name: 'max'},
                                {type: 'min', name: 'min'}
                            ]
                        },
                        markLine: {
                            data: [
                                {type: 'average', name: 'average'}
                            ]
                        },
                        data: chdata
                    },
                    {
                        name: 'Last',
                        type: 'gauge',
                        axisLabel: {show: false},
                        center: ['91%', '35%'],
                        radius: '48%',
                        startAngle: 90,
                        endAngle: -90,
                        min: Math.min.apply(null, chdata),
                        max: Math.max.apply(null, chdata),
                        splitNumber: 3,
                        title: {
                            show: true,
                            textStyle: {
                                color: 'rgba(255, 255, 255, 0.8)',
                                fontSize: 15
                            }
                        },
                        axisLine: {
                            lineStyle: {
                                width: 10
                            }
                        },
                        pointer: {
                            width: 4,
                            length: '100%',
                        },
                        title: {
                            show: true,
                            offsetCenter: ["50%", "120%"],
                            textStyle: {
                                color: '#333',
                                fontSize: 15
                            }
                        },
                        detail: {
                            show: true,
                            backgroundColor: 'rgba(0,0,0,0)',
                            borderWidth: 0,
                            borderColor: '#ccc',
                            width: 100,
                            height: 40,
                            offsetCenter: ["50%", "140%"],
                            formatter: '{value}',
                            textStyle: {
                                color: 'auto',
                                fontSize: 30
                            }
                        },
                        data: [{value: chdata[chdata.length - 1], name: 'Last Value'}]
                    }]
            });
            setTimeout(function () {
                ReDrawEchart(url)
            }, 10000);
        });
    }


    function ReDrawEchart(url)
    {
        $.getJSON(url, null, function (data) {
//            console.log(data);
            var date = [];
            var chdata = [];
            var dateval = moment();
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var time in chartline.data) {
                    dateval = moment(time * 1);
                    date.push(dateval.format("HH:mm:ss"));
                    chdata.push(chartline.data[time]);
                }
            }
            var options = echartLine.getOption();

            options.series[1].data[0].value = chdata[chdata.length - 1];
            options.series[0].data = chdata;
            options.xAxis[0].data = date;
            echartLine.setOption(options);
            setTimeout(function () {
                ReDrawEchart(url)
            }, 10000);
        });
    }

</script>