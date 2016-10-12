<script>
    dush_charts_options = [];
    $(document).ready(function () {
        $("#addrow").on("click", function () {
            $("#dashcontent").append($("#rowtemplate").html());
        });

//        $().live

        $('body').on("click", ".addchart", function () {
            $(this).parents(".x_content").first().find(".rowcontent").append($("#charttemplate").html());
            var ctx = $(this).parents(".x_content").first().find(".rowcontent").find(".lineChart").last();
            ctx.height = 300;
            ctx.attr("datasetindex", dush_charts_options.length);
            var datasets = [];
            var d = [];
            for (i = 0; i < 100; i++)
            {
                defitemdata = {x: moment().subtract(i, "minute"), y: Math.random()};
                d.push(defitemdata);
            }

            defitem = {
                label: "new Chart",
                backgroundColor: "rgba(0, 255, 0, 0.31)",
                borderColor: "rgba(0, 255, 0, 0.7)",
                pointBorderColor: "rgba(0, 255, 0, 0.7)",
                pointBackgroundColor: "rgba(0, 255, 0, 0.7)",
                pointHoverBackgroundColor: "#fff",
                pointHoverBorderColor: "rgba(220,220,220,1)",
                pointBorderWidth: 0,
                data: d,
                pointRadius: 3,
                borderWidth: 2,
            };
            datasets.push(defitem);           
            var options = JSON.parse(JSON.stringify(defoptions));
            options.data.datasets = datasets;
            dush_charts_options.push(options);
            lineChart = new Chart(ctx, options);


            itemcount = $(this).parents(".x_content").first().find(".rowcontent").find(".lineChart").size();

            size = 12;
            if (itemcount < 12)
            {
                size = Math.round(12 / itemcount);
            } else
            {
                size = 1;
            }


            $(this).parents(".x_content").first().find(".rowcontent").find(".chartsection").attr("size", size);
            $(this).parents(".x_content").first().find(".rowcontent").find(".chartsection").attr("class", "chartsection col-lg-" + size);

        });


        $('body').on("click", ".plus", function () {
            block = $(this).parent().parent().parent();
            if (parseInt(block.attr("size")) < 12)
            {
                block.attr("size", (parseInt(block.attr("size")) + 1))
                block.attr("class", "chartsection col-lg-" + block.attr("size"));
            }
        });


        $('body').on("click", ".minus", function () {
            block = $(this).parent().parent().parent();
            if (parseInt(block.attr("size")) > 1)
            {
                block.attr("size", (parseInt(block.attr("size")) - 1))
                block.attr("class", "chartsection col-lg-" + block.attr("size"));
            }
        });

        $('body').on("click", ".editchart", function () {
            datasetindex = $(this).parents(".chartsection").find(".lineChart").attr("datasetindex")
            html = $("#charttemplate").html();
            $(".editchartpanel").show();
            $(".editchartpanel #singlewidget").html(html);
            $(".editchartpanel #singlewidget .controls").remove();
            var ctx = $(".editchartpanel #singlewidget").find(".lineChart").last();
            ctx.height = 600;
            console.log(datasetindex);
            options = dush_charts_options[datasetindex];
            console.log(options);            
            lineChart = new Chart(ctx, options);
            $(".fulldash").hide();
        });
        
        $('body').on("click", ".backtodush", function () {
            $(".editchartpanel #singlewidget").html("");
            $(".editchartpanel").hide();
            $(".fulldash").show();
        });
    });



    var defoptions = {
        type: 'line',
        data: {
            datasets: []
        },
        options: {
            maintainAspectRatio: false,
            tooltips: {
//                responsive
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
    };

</script>    