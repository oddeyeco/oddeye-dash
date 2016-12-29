
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


    var echartLine = echarts.init(document.getElementById('echart_line'), 'macarons');
    var url = "${cp}/getdata?hash=${metric.hashCode()}&startdate=1d-ago";
    drawEchart(url);


    function drawEchart(url)
    {
        $.getJSON(url, null, function (data) {
            console.log(data);
            var date = [];
            var chdata = [];
            var chdata2 = [];
            var dateval = moment();
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
                for (var time in chartline.data) {
                    dateval = moment(time * 1);
                    date.push(dateval.format("HH:mm:ss"));
                    chdata.push(chartline.data[time]);
                    chdata2.push(chartline.data[time] * 2);
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
//                legend: {
//                    x: 220,
//                    y: 40,
//                    data: ['Intent', 'Pre-order', 'Deal']
//                },
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