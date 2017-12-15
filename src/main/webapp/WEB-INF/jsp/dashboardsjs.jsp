<%-- 
    Document   : dashboardsjs
    Created on : Apr 12, 2017, 12:14:35 PM
    Author     : vahan
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<script>
    $(document).ready(function () {
//        $("input.flat").iCheck({checkboxClass: "icheckbox_flat-green", radioClass: "iradio_flat-green"});

        url = cp + "/getmetastat";
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        $.ajax({
            url: url,
            dataType: 'json',
            type: 'POST',
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            },
            success: function (data) {
                if (data.sucsses)
                {
                    $('#metrics').html(data.names);
                    $('#tags').html(data.tagscount);
                    $('#count').html(data.count);                    
                    jQuery.each(data.tags, function (i, val) {
                        $("#tagslist").append('<div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">' +
                                '<span class="count_top"><i class="fa fa-th-list"></i> Tag "' + i + '" count </span>' +
                                '<div class="count">' + val + '</div>' +
                                '</div>');
                    });
                    $('.count').spincrement({duration: 5000});
                }
                ;
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status + ": " + thrownError);
            }
        });
    });
</script>
