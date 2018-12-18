<%-- 
    Document   : singlehistoryjs
    Created on : May 23, 2017, 11:54:11 AM
    Author     : vahan
--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js?v=${version}"></script>
<!--<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>-->
<script src="${cp}/assets/js/echarts.min.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>

<script>
    var echartLine = echarts.init(document.getElementById('echart_line'), 'oddeyelight');
    var levels = {"-1": "OK", 0: "All", 1: "Low", 2: "Guarded", 3: "Elevated", 4: "High", 5: "Severe"};
    var hashcode = ${metric.sha256Code()};    
    var locale = {
        "datetime.lastminute": "<spring:message code="datetime.lastminute"/>",
        "datetime.lasthoures": "<spring:message code="datetime.lasthoures"/>",
        "datetime.lasthoures2": "<spring:message code="datetime.lasthoures2"/>",
        "datetime.lastdays": "<spring:message code="datetime.lastdays"/>",
        "datetime.lastdays2": "<spring:message code="datetime.lastdays2"/>",

        "datetime.lastonehoure": "<spring:message code="datetime.lastonehoure"/>",
        "datetime.lastoneday": "<spring:message code="datetime.lastoneday"/>",
        "datetime.general": "<spring:message code="datetime.general"/>",

        "dataTable.processing":"<spring:message code="dataTable.processing" javaScriptEscape="true"/>",
        "dataTable.search":"<spring:message code="dataTable.search" javaScriptEscape="true"/>",
        "dataTable.lengthMenu":"<spring:message code="dataTable.lengthMenu" javaScriptEscape="true"/>",
        "dataTable.info":"<spring:message code="dataTable.info" javaScriptEscape="true"/>",
        "dataTable.infoEmpty":"<spring:message code="dataTable.infoEmpty" javaScriptEscape="true"/>",
        "dataTable.infoFiltered":"<spring:message code="dataTable.infoFiltered" javaScriptEscape="true"/>",
        "dataTable.infoPostFix":"<spring:message code="dataTable.infoPostFix" javaScriptEscape="true"/>",
        "dataTable.loadingRecords":"<spring:message code="dataTable.loadingRecords" javaScriptEscape="true"/>",
        "dataTable.zeroRecords":"<spring:message code="dataTable.zeroRecords" javaScriptEscape="true"/>",
        "dataTable.emptyTable":"<spring:message code="dataTable.emptyTable" javaScriptEscape="true"/>",
        "dataTable.paginate.first":"<spring:message code="dataTable.paginate.first" javaScriptEscape="true"/>",
        "dataTable.paginate.previous":"<spring:message code="dataTable.paginate.previous" javaScriptEscape="true"/>",
        "dataTable.paginate.next":"<spring:message code="dataTable.paginate.next" javaScriptEscape="true"/>",
        "dataTable.paginate.last":"<spring:message code="dataTable.paginate.last" javaScriptEscape="true"/>",
        "dataTable.aria.sortAscending":"<spring:message code="dataTable.aria.sortAscending" javaScriptEscape="true"/>",
        "dataTable.aria.sortDescending":"<spring:message code="dataTable.aria.sortDescending" javaScriptEscape="true"/>"
    };
    
    var DtPicerlocale = {
        applyLabel: '<spring:message code="datetime.submit"/>',
        cancelLabel: '<spring:message code="datetime.clear"/>',
        fromLabel: '<spring:message code="datetime.from"/>',
        toLabel: '<spring:message code="datetime.to"/>',
        customRangeLabel: '<spring:message code="datetime.custom"/>',
        weekLabel: '<spring:message code="datetime.weekLabel"/>',
        
        daysOfWeek: ['<spring:message code="su"/>','<spring:message code="mo"/>',
                     '<spring:message code="tu"/>','<spring:message code="we"/>',
                     '<spring:message code="th"/>','<spring:message code="fr"/>',
                     '<spring:message code="sa"/>'],
         
        monthNames: ['<spring:message code="january"/>','<spring:message code="february"/>',
                     '<spring:message code="march"/>','<spring:message code="april"/>',
                     '<spring:message code="may"/>','<spring:message code="june"/>',
                     '<spring:message code="july"/>','<spring:message code="august"/>',
                     '<spring:message code="september"/>','<spring:message code="october"/>',
                     '<spring:message code="november"/>','<spring:message code="december"/>'],
        firstDay: 1
    };
    $(document).ready(function () {
        lang = {"processing": locale["dataTable.processing"],
        "search": locale["dataTable.search"],
        "lengthMenu": locale["dataTable.lengthMenu"],
        "info": locale["dataTable.info"],
        "infoEmpty": locale["dataTable.infoEmpty"],
        "infoFiltered": locale["dataTable.infoFiltered"],
        "infoPostFix": locale["dataTable.infoPostFix"],
        "loadingRecords": locale["dataTable.loadingRecords"],
        "zeroRecords": locale["dataTable.zeroRecords"],
        "emptyTable": locale["dataTable.emptyTable"],
        "paginate": {
            "first": locale["dataTable.paginate.first"],
            "previous": locale["dataTable.paginate.previous"],
            "next": locale["dataTable.paginate.next"],
            "last": locale["dataTable.paginate.last"]
        },
        "aria": {
            "sortAscending": locale["dataTable.aria.sortAscending"],
            "sortDescending": locale["dataTable.aria.sortDescending"]
        }
    };
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
            startDate: moment(${date.getTime()}),
            locale: DtPicerlocale
        },
                function (start, end, label) {
                    window.open(cp + "/history/${metric.sha256Code()}/" + start.utc().valueOf(), "_self");
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
            "language": lang,
            "pagingType": "full_numbers",            
            "lengthMenu": [[25, 50, 100, 200, -1], [25, 50, 100, 200, "All"]]
        });
        $RIGHT_COL.css('min-height', $(window).height());
        
    });
    window.onresize = echartLine.resize;

    $('body').on("click", "#Clear_reg", function () {
        var sendData = {};
        sendData.hash = hashcode;
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        url = cp + "/resetregression";
        $.ajax({
            dataType: 'json',
            type: 'POST',
            url: url,
            data: sendData,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            }
        }).done(function (msg) {
            if (msg.sucsses)
            {
                setTimeout(function () {
                    location.reload();
                }, 1000);
            } else
            {
                alert(locale["requestFailed"]);
            }
        }).fail(function (jqXHR, textStatus) {
            alert(locale["requestFailed"]);
        });
    });
</script>
