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
    $(document).ready(function () {
        var series = {
            name: "errors",
            sampling: 'average',
            type: "line",
            step: "start",
            smooth: false,
            data: []
        };
        $("#datatable tr").each(function () {
            var interval = parseInt($(this).find('.timeinterval').attr('value'));
            series.data.push([$(this).attr('time'), $(this).attr('level'), moment.utc(interval).format("HH:mm:ss"),$(this).find('.level div').html() ]);
        });
        echartLine.setOption({
            title: {
                text: ""
            },
            tooltip: {
                trigger: 'axis',
                formatter: function (params) {                    
                    var out = params[0].data[3]+':'+params[0].data[2];
                    return out;
                    
                }
            },
            toolbox: {feature: {magicType: {show: false}}},
            xAxis: [{
                    type: 'time',                    
                    max: moment(${date.getTime()}).hour(23).minute(59).valueOf(),
                    show: false
                    
                }],
            yAxis: [{
                    type: 'value',
                    max: 5,
                    splitNumber:5,
                    splitArea:{show: false},
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
                left: 0,
                right: 0,
                bottom: 2,
                top: 2
            },
            series: series
        });
        $('#reportrange').daterangepicker({
            singleDatePicker: true,
            showDropdowns: true,
            startDate: moment(${date.getTime()})

        },
                function (start, end, label) {
                    window.open(cp + "/history/${metric.hashCode()}/" + start.utc().valueOf(), "_self")
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
