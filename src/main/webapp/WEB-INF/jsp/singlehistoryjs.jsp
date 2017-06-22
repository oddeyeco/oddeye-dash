<%-- 
    Document   : singlehistoryjs
    Created on : May 23, 2017, 11:54:11 AM
    Author     : vahan
--%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var levels = {"-1": "OK", 0: "All", 1: "Low", 2: "Guarded", 3: "Elevated", 4: "High", 5: "Severe"};

    $(document).ready(function () {
        var series = {
            name: "errors",
            type: "line",
            step: "start",
            smooth: false,
            data: []
        };
        $("#datatable tbody tr").each(function (i, val) {
            var interval = parseInt($(this).find('.timeinterval').attr('value'));
            if (i === 0)
            {
                var time = moment(${date.getTime()}).set({hour: 23, minute: 59, second: 59, millisecond: 0}).valueOf();
                if (moment().valueOf() < time)
                {
                    time = moment().valueOf();
                }
                series.data.push([time, $(this).attr('level'), 0]);

            }
            series.data.push([parseInt($(this).attr('time')), $(this).attr('level'), moment.utc(interval).format("HH:mm:ss"), $(this).find('.level div').html()]);
            if (i === $("#datatable tbody tr").length - 1)
            {
                var time = moment(${date.getTime()}).set({hour: 0, minute: 0, second: 0, millisecond: 0}).valueOf();
                series.data.push([time, $(this).attr('level'), 1]);
            }

        });

        echartLine.setOption({
            title: {
                text: ""
            },
            tooltip: {
                trigger: 'axis',
                formatter: function (params) {
                    if (params[0].data[2] === 0)
                    {
                        return "Now";
                    }
                    if (params[0].data[2] === 1)
                    {
                        return "";
                    }

                    var out = format_date(params[0].value[0], 0) + ":" + params[0].data[3] + ':' + params[0].data[2];
                    return out;
                }
            },
            toolbox: {feature: {magicType: {show: false}}},
            xAxis: [{
                    type: 'time',
                    max: moment(${date.getTime()}).set({hour: 23, minute: 59, second: 59, millisecond: 0}).valueOf(),
                    min: moment(${date.getTime()}).set({hour: 0, minute: 0, second: 0, millisecond: 0}).valueOf(),
                    splitNumber: 20,
                    axisLine: {onZero: false}
//                    show: false
                }],
            yAxis: [{
                    type: 'value',
                    max: 5,
                    min: -1,
                    splitNumber: 5,
                    splitArea: {show: false},
                    axisLabel: {
                        formatter: function (param) {
                            return  levels[param];
                        }
                    },
                    axisLine: {show: false}

                }],
            dataZoom: [{
                    type: 'inside',
                    xAxisIndex: 0,
                    show: true,
                    start: 0,
                    end: 100
                }],
            grid: {
                containLabel: false,
                x: 60,
                x2: 0,
                y2: 30,
                y: 10
            },
            series: series
        });


        $('#reportrange').daterangepicker({
            singleDatePicker: true,
            showDropdowns: true,
            startDate: moment(${date.getTime()})

        },
                function (start, end, label) {
                    window.open(cp + "/history/${metric.hashCode()}/" + start.utc().valueOf(), "_self");
                });

        $('.timeinterval').each(function () {
            var interval = parseInt($(this).attr('value'));
            var dur = moment.utc(interval).format("HH:mm:ss");
            $(this).html(dur);
            var message = $(this).parent().find('.message').attr('value');
            if (message)
            {
                message = message.replace("{DURATION}", dur);
                $(this).parent().find('.message').html(message);
            }
        });

        $('#datatable').dataTable({
            "pagingType": "full_numbers",
            "lengthMenu": [[25, 50, 100, 200, -1], [25, 50, 100, 200, "All"]]
        });
    });
    window.onresize = echartLine.resize;
</script>
