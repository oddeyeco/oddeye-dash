<script>
//    var maetricrawHTML = '<tr><td>[icons]</td><td><a href="${cp}/metriq/[hash]">[metricname]</a></td><td><a>[tags]</a></td><td><a>[lasttime]</a></td><td class="text-nowrap"><a href="javascript:void(0)" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i> Edit </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="[hash]"><i class="fa fa-trash-o"></i> Delete </a></td></tr>';
    var maetricrawHTML = '<tr><td>[icons]</td><td><a href="${cp}/metriq/[hash]">[metricname]</a></td><td><a>[tags]</a></td><td><a>[lasttime]</a></td><td class="text-nowrap"><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="[hash]"><i class="fa fa-trash-o"></i> Delete </a></td></tr>';
    var chartLinck = '<a href="${cp}/chart/[hash]" target="_blank"><i class="fa fa-area-chart" style="font-size: 18px;"></i></a>';

    $(document).ready(function () {
        $('body').on("click", ".showtags", function () {

            $(".item_list").hide();
            $("#" + $(this).attr("value")).fadeIn(500, "linear", function () {
                // Animation complete.
            });
        });


        $('body').on("click", ".view", function () {
            var id = $(this).attr("key") + "_" + $(this).attr("idvalue");
            $(".metricinfo").hide();
            var html = maetricrawHTML;
            $("#" + id).find("tbody").html("");
            $.getJSON("getmetrics?key=" + $(this).attr("key") + "&value=" + $(this).attr("value"), function (value) {
                for (var k in value.data) {
                    metric = value.data[k];
//                    console.log(metric);
                    input = html.replace("[metricname]", metric.name);
                    if (metric.type != 0)
                    {
                        icons = chartLinck.replace("[hash]", JSON.stringify(metric.hash));
                        input = input.replace("[icons]", icons);
                    }
                    else
                    {
                        input = input.replace("[icons]", "");
                    }

                    input = input.replace("[tags]", JSON.stringify(metric.tags));
                    input = input.replace("[hash]", JSON.stringify(metric.hash));
                    input = input.replace("[hash]", JSON.stringify(metric.hash));
                    input = input.replace("[hash]", JSON.stringify(metric.hash));
                    input = input.replace("[lasttime]", moment(metric.lasttime));

                    $("#" + id).find("tbody").append(input);
                }
            });
            $("#" + id).fadeIn(1000, "linear", function () {
                // Animation complete.
            });


        });

        $('body').on("click", ".deletemetric", function () {
            alert($(this).attr("value"));
            $.getJSON("deletemetrics?hash=" + $(this).attr("value"), function (data) {
                //TODO Chage in js
                location.reload();
            });


        });

        $('body').on("click", ".deletemetrics", function () {
//            alert($(this).attr("value"));
            $.getJSON("deletemetrics?key=" + $(this).attr("key") + "&value=" + $(this).attr("value"), function (data) {
                //TODO Chage in js
                location.reload();
            });


        });

    })
</script>    
