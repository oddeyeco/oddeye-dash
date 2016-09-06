<!--<script>
    $(document).ready(function () {

    });
</script>-->
<!-- /Flot -->
<!-- bootstrap-daterangepicker -->
<script type="text/javascript">
    var lineChart;


    $(document).ready(function () {

        drawchart(window.location.search);
        setInterval(function () {


        }, 5000);

        var cb = function (start, end, label) {
//            console.log(start.toISOString(), end.toISOString(), label);
            $('#reportrange span').html(start.format('MM/DD/YYYY H:m:s') + ' - ' + end.format('MM/DD/YYYY H:m:s'));
        };
        var optionSet1 = {
            startDate: moment(),
            endDate: moment(),
            minDate: '01/01/2012',
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
//                'Today': [moment(), moment()],
//                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
//                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
//                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
//                'This Month': [moment().startOf('month'), moment().endOf('month')],
//                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
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
        $('#reportrange span').html(moment().subtract(1, 'houre').format('MM/DD/YYYY H:m:s') + ' - ' + moment().format('MM/DD/YYYY H:m:s'));
        $('#reportrange').daterangepicker(optionSet1, cb);
        $('#reportrange').on('show.daterangepicker', function () {
//            console.log("show event fired");
        });
        $('#reportrange').on('hide.daterangepicker', function () {
//            console.log("hide event fired");
        });
        $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
//            console.log("apply event fired, start/end dates are " + picker.startDate.format('MM/DD/YYYY H:m:s') + " to " + picker.endDate.format('MM/DD/YYYY H:m:s'));
            console.log (picker.startDate +" "+ picker.startDate.format('MM/DD/YYYY H:m:s')+" "+ picker.startDate.unix());
            redrawchart(window.location.search + '&startdate=' + picker.startDate);
//            alert (window.location.search+'&startdate='+picker.startDate.unix());


        });
        $('#reportrange').on('cancel.daterangepicker', function (ev, picker) {
            console.log("cancel event fired");
        });
        $('#destroy').click(function () {
            $('#reportrange').data('daterangepicker').remove();
        });
    });

    var colorset = [{
            backgroundColor: "rgba(255, 0, 0, 0.31)",
            borderColor: "rgba(255, 0, 0, 0.7)",
            pointBorderColor: "rgba(255, 0, 0, 0.7)",
            pointBackgroundColor: "rgba(255, 0, 0, 0.7)",
        },
        {
            backgroundColor: "rgba(0, 255, 0, 0.31)",
            borderColor: "rgba(0, 255, 0, 0.7)",
            pointBorderColor: "rgba(0, 255, 0, 0.7)",
            pointBackgroundColor: "rgba(255, 0, 0, 0.7)",
        },
        {
            backgroundColor: "rgba(0, 0, 255, 0.31)",
            borderColor: "rgba(0, 0, 255, 0.7)",
            pointBorderColor: "rgba(0, 0, 255, 0.7)",
            pointBackgroundColor: "rgba(0, 0, 255, 0.7)",
        },
        {
            backgroundColor: "rgba(0, 255, 255, 0.31)",
            borderColor: "rgba(0, 255, 255, 0.7)",
            pointBorderColor: "rgba(0, 255, 255, 0.7)",
            pointBackgroundColor: "rgba(0, 255, 255, 0.7)",
        },
        {
            backgroundColor: "rgba(255, 0, 255, 0.31)",
            borderColor: "rgba(255, 0, 255, 0.7)",
            pointBorderColor: "rgba(255, 0, 255, 0.7)",
            pointBackgroundColor: "rgba(0, 0, 255, 0.7)",
        },
        {
            backgroundColor: "rgba(255, 0, 255, 0.31)",
            borderColor: "rgba(255, 0, 255, 0.7)",
            pointBorderColor: "rgba(255, 0, 255, 0.7)",
            pointBackgroundColor: "rgba(255, 0, 255, 0.7)",
        }];


    function redrawchart(query)
    {
        var d2 = [];
        var datasets = [];
//        //here we generate data for chart
        var url = "${cp}/getdata" + query;
        $.getJSON(url, null, function (data) {
            var pos = 0;
//            for (var i = 0; i < data.chartsdata.length; i++) {
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
//                alert(JSON.stringify(chartline));
                var d = [];
                for (var time in chartline.data) {
                    itemdata = {x: time * 1, y: chartline.data[time]};
                    d.push(itemdata);

                }

                item = {
                    label: chartline.metric + ":" + chartline.tags.host,
                    backgroundColor: colorset[pos].backgroundColor,
                    borderColor: colorset[pos].borderColor,
                    pointBorderColor: colorset[pos].pointBorderColor,
                    pointBackgroundColor: colorset[pos].pointBackgroundColor,
                    pointHoverBackgroundColor: "#fff",
                    pointHoverBorderColor: "rgba(220,220,220,1)",
                    pointBorderWidth: 1,
                    data: d
                };
                datasets.push(item);
                pos++;
                if (pos == 6)
                    pos = 0;
            }


            lineChart.data.datasets = datasets;
            lineChart.update(0, true);
        });
    }

    function drawchart(query)
    {
        var d2 = [];
        var datasets = [];
        //here we generate data for chart
        var url = "${cp}/getdata" + query;
        $.getJSON(url, null, function (data) {

//            for (var k in data) {
//                item = {x: k * 1000, y: data[k]};
//                d2.push(item);
//
//            }
//            console.log(d1);
//            console.log(d2);
//            for (var i = 0; i < json.length; i++) {
//                var obj = json[i];
//
//                console.log(obj.id);
//            }
            var pos = 0;
//            for (var i = 0; i < data.chartsdata.length; i++) {
            for (var k in data.chartsdata) {
                var chartline = data.chartsdata[k];
//                alert(JSON.stringify(chartline));
                var d = [];
                for (var time in chartline.data) {
                    itemdata = {x: time * 1, y: chartline.data[time]};
                    d.push(itemdata);

                }

                item = {
                    label: chartline.metric + ":" + chartline.tags.host,
                    backgroundColor: colorset[pos].backgroundColor,
                    borderColor: colorset[pos].borderColor,
                    pointBorderColor: colorset[pos].pointBorderColor,
                    pointBackgroundColor: colorset[pos].pointBackgroundColor,
                    pointHoverBackgroundColor: "#fff",
                    pointHoverBorderColor: "rgba(220,220,220,1)",
                    pointBorderWidth: 1,
                    data: d
                };
                datasets.push(item);
                pos++;
                if (pos == 6)
                    pos = 0;
            }



//            var chartMaxDate = d2[d2.length - 1][0];
//            var chartMinDate = d2[0][0];
//
//            var tickSize = [1, "second"];
//            var tformat = "%d/%m/%y %H:%M:%S";

            // Line chart
            var ctx = document.getElementById("lineChart");
            lineChart = new Chart(ctx, {
                type: 'line',
                data: {
                    datasets: datasets
                },
                options: {
                    tooltips: {
                        enabled: true,
                    },
                    scales: {
                        xAxes: [{
                                type: 'time',
                                position: 'bottom',
                                time: {
//                                    max: chartMaxDate,
                                    displayFormats: {
                                        second: "HH:mm:ss",
                                        minute: "HH:mm:ss"

                                    },
                                    tooltipFormat: 'DD/MM/YYYY HH:mm:ss',
                                },
                            }]
                    }
                }
            });

        });
    }

</script>