<!--<script>
    $(document).ready(function () {

    });
</script>-->
<!-- /Flot -->
<!-- bootstrap-daterangepicker -->
<script type="text/javascript">
    $(document).ready(function () {
        drawchart("${tagkey}", "${tagname}", "${metric}", moment(), 1000);
        var cb = function (start, end, label) {
            console.log(start.toISOString(), end.toISOString(), label);
            $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
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
            timePicker: false,
            timePickerIncrement: 1,
            timePicker12Hour: true,
            ranges: {
                'Today': [moment(), moment()],
                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                'This Month': [moment().startOf('month'), moment().endOf('month')],
                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            },
            opens: 'left',
            buttonClasses: ['btn btn-default'],
            applyClass: 'btn-small btn-primary',
            cancelClass: 'btn-small',
            format: 'MM/DD/YYYY',
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
        $('#reportrange span').html(moment().format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
        $('#reportrange').daterangepicker(optionSet1, cb);
        $('#reportrange').on('show.daterangepicker', function () {
            console.log("show event fired");
        });
        $('#reportrange').on('hide.daterangepicker', function () {
            console.log("hide event fired");
        });
        $('#reportrange').on('apply.daterangepicker', function (ev, picker) {
            console.log("apply event fired, start/end dates are " + picker.startDate.format('MMMM D, YYYY') + " to " + picker.endDate.format('MMMM D, YYYY'));
//            drawchart();

        });
        $('#reportrange').on('cancel.daterangepicker', function (ev, picker) {
            console.log("cancel event fired");
        });
        $('#destroy').click(function () {
            $('#reportrange').data('daterangepicker').remove();
        });
    });
    function drawchart(tagkey, tagname, metric, fromdate, count)
    {
        //define chart clolors ( you maybe add more colors if you want or flot will add it automatic )
        var chartColours = ['#96CA59', '#3F97EB', '#72c380', '#6f7a8a', '#f7cb38', '#5a8022', '#2c7282'];
//        var d1 = [];
        var d2 = [];
        //here we generate data for chart
        var url = "${cp}/getdata/" + tagkey + "/" + tagname + "/" + metric + "/" + Math.floor(fromdate / 1000) + "/" + count;
        $.getJSON(url, null, function (data) {

            for (var k in data) {
//                d1.push([k * 1000, data[k]]);
                item = {x: k * 1000, y: data[k]};
                d2.push(item);
            }
//            console.log(d1);
//            console.log(d2);


//            var chartMaxDate = d1[d1.length - 1][0]; //first day
//            var chartMinDate = d1[0][0]; //last day
//
//            var tickSize = [1, "second"];
//            var tformat = "%d/%m/%y %H:%M:%S";

            // Line chart
            var ctx = document.getElementById("lineChart");
            var lineChart = new Chart(ctx, {
                type: 'line',
                data: {
                    datasets: [{
                            label: metric,
                            backgroundColor: "rgba(38, 185, 154, 0.31)",
                            borderColor: "rgba(38, 185, 154, 0.7)",
                            pointBorderColor: "rgba(38, 185, 154, 0.7)",
                            pointBackgroundColor: "rgba(38, 185, 154, 0.7)",
                            pointHoverBackgroundColor: "#fff",
                            pointHoverBorderColor: "rgba(220,220,220,1)",
                            pointBorderWidth: 1,
                            data: d2
                        }]
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