<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
    var lineChart;
    var curentvalue = ${Error.getValue()};
    var chartsdata = ${chartdata};
    var colorset = [{
            backgroundColor: "rgba(300, 10, 150, 0.3)",
            borderColor: "rgba(300, 10, 150, 0.9)",
            pointBorderColor: "rgba(300, 10, 150, 0.4)",
            pointBackgroundColor: "rgba(300, 10, 150, 0.4)",
        },
        {
            backgroundColor: "rgba(0, 255, 0, 0.1)",
            borderColor: "rgba(0, 255, 0, 0.9)",
            pointBorderColor: "rgba(0, 255, 0, 0.1)",
            pointBackgroundColor: "rgba(255, 0, 0, 0.1)",
        },
        {
            backgroundColor: "rgba(0, 0, 255, 0.1)",
            borderColor: "rgba(0, 0, 255, 0.9)",
            pointBorderColor: "rgba(0, 0, 255, 0.1)",
            pointBackgroundColor: "rgba(0, 0, 255, 0.1)",
        },
        {
            backgroundColor: "rgba(0, 255, 255, 0.1)",
            borderColor: "rgba(0, 255, 255, 0.9)",
            pointBorderColor: "rgba(0, 255, 255, 0.1)",
            pointBackgroundColor: "rgba(0, 255, 255, 0.1)",
        },
        {
            backgroundColor: "rgba(255, 0, 255, 0.1)",
            borderColor: "rgba(255, 0, 255, 0.9)",
            pointBorderColor: "rgba(255, 0, 255, 0.1)",
            pointBackgroundColor: "rgba(0, 0, 255, 0.1)",
        },
        {
            backgroundColor: "rgba(255, 0, 255, 0.1)",
            borderColor: "rgba(255, 0, 255, 0.9)",
            pointBorderColor: "rgba(255, 0, 255, 0.1)",
            pointBackgroundColor: "rgba(255, 0, 255, 0.1)",
        },
        {
            backgroundColor: "rgba(200, 50, 200, 0.1)",
            borderColor: "rgba(200, 50, 200, 0.9)",
            pointBorderColor: "rgba(200, 50, 200, 0.1)",
            pointBackgroundColor: "rgba(200, 50, 200, 0.1)",
        },
        {
            backgroundColor: "rgba(150, 100, 50, 0.1)",
            borderColor: "rgba(150, 100, 50, 0.9)",
            pointBorderColor: "rgba(150, 100, 50, 0.1)",
            pointBackgroundColor: "rgba(150, 100, 50, 0.1)",
        }];
    $(document).ready(function () {
        drawAnChart();
    });
    function drawAnChart()
    {
        var d2 = [];
        var datasets = [];
        var pos = 0;
        for (var k in chartsdata) {
            var chartline = chartsdata[k];
            var d = [];
            for (var time in chartline.data) {
                htime = moment(time * 1).dayOfYear(0);
                itemdata = {x: htime, y: chartline.data[time]};
//                console.log(htime.format("YYYY-MM-DD h:mm:ss"));
                d.push(itemdata);
            }

//cartedta

            item = {
                label: moment(k * 1).format("DD/MM/YYYY"),                
                fill: false,
                borderColor: colorset[pos].borderColor,
//                pointBorderColor: colorset[pos].pointBorderColor,
//                pointBackgroundColor: colorset[pos].pointBackgroundColor,
//                pointHoverBackgroundColor: "#fff",
//                pointHoverBorderColor: "rgba(220,220,220,1)",
//                pointBorderWidth: 1,                
                borderWidth: 1,
                radius: 0,
                data: d
                
            };
            datasets.push(item);
            pos++;
        }

        var cd = [];
        for (var index in d) {            
            i_data = d[index];            
            itemdata = {x: i_data.x, y: curentvalue};
            cd.push(itemdata);
        }

        item = {
            label: "Curent Value",
            fill: false,
            borderColor: "rgba(255, 0, 0, 0.8)",            
//            pointBorderColor: "rgba(255, 0, 0, 0.8)",
//            pointBackgroundColor: "rgba(255, 0, 0, 0.8)",
//            pointHoverBackgroundColor: "#fff",
//            pointHoverBorderColor: "rgba(255, 0, 0, 0.8)",
//            pointBorderWidth: 0,
            radius: 0,
            borderWidth: 3,
            data: cd
        };

        datasets.push(item);

        // Line chart
        var ctx = document.getElementById("lineChart");
        lineChart = new Chart(ctx, {
            type: 'line',            
            data: {
                labels: [],
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
                                displayFormats: {
                                    second: "mm:ss",
                                    minute: "mm:ss"

                                },
                                tooltipFormat: 'mm:ss',
                            },
                        }]
                }
            }
        });


    }

</script>
