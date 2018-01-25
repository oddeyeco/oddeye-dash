<%-- 
    Document   : dashboardsjs
    Created on : Apr 12, 2017, 12:14:35 PM
    Author     : vahan
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js?v=${version}"></script>
<script src="${cp}/assets/js/metricinfo.min.js?v=${version}"></script>
<script>
    var header = $("meta[name='_csrf_header']").attr("content");
    var token = $("meta[name='_csrf']").attr("content");
    var pp =${paypal_percent};
    var pf = ${paypal_fix};
    $(document).ready(function () {
//        $("input.flat").iCheck({checkboxClass: "icheckbox_flat-green", radioClass: "iradio_flat-green"});

        var value = 25;
//        $("#oddeyeQuantity").val(value.toFixed(2));
        value = value + value * pp / 100 + pf;
        $("#oddeyeAmmount").val(value.toFixed(2));
        $("#paypalAmmount").val($("#oddeyeAmmount").val());
//        $("#paypalItemName").val($("#oddeyeQuantity").val() + " " + $("#paypalItemName").attr("text"));


//        $('body').on("blur", "#oddeyeQuantity", function () {
//            var value = Number($(this).val());
//            value = value + value * pp / 100 + pf;
//            $("#oddeyeAmmount").val(value.toFixed(2));
//            $("#paypalAmmount").val($("#oddeyeAmmount").val());
//            $("#paypalItemName").val($("#oddeyeQuantity").val() + " " + $("#paypalItemName").attr("text"));
//        });

        $('body').on("blur", "#oddeyeAmmount", function () {
            var value = Number($(this).val());
            value = (value - 0.3) / (1 + 2 / 100);
//            $("#oddeyeQuantity").val(value.toFixed(2));
            $("#paypalAmmount").val($("#oddeyeAmmount").val());
//            $("#paypalItemName").val($("#oddeyeQuantity").val() + " " + $("#paypalItemName").attr("text"));
        });

//        url = cp + "/getmetastat";

//        $.ajax({
//            url: url,
//            dataType: 'json',
//            type: 'POST',
//            beforeSend: function (xhr) {
//                xhr.setRequestHeader(header, token);
//            },
//            success: function (data) {
//                if (data.sucsses)
//                {
//                    $('#metrics').html(data.names);
//                    $('#tags').html(data.tagscount);
//                    $('#count').html(data.count);
//                    jQuery.each(data.tags, function (i, val) {
//                        $("#tagslist").append('<div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">' +
//                                '<span class="count_top"><i class="fa fa-th-list"></i> Tag "' + i + '" count </span>' +
//                                '<div class="count spincrement">' + val + '</div>' +
//                                '</div>');
//                    });
//                    $('.spincrement').spincrement({duration: 2000});
//                }
//                ;
//            },
//            error: function (xhr, ajaxOptions, thrownError) {
//                console.log(xhr.status + ": " + thrownError);
//            }
//        });
    });
</script>
