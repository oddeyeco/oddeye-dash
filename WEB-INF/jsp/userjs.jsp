<%-- 
    Document   : user
    Created on : May 11, 2017, 2:21:00 PM
    Author     : vahan
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script>
    var header = $("meta[name='_csrf_header']").attr("content");
    var token = $("meta[name='_csrf']").attr("content");

    function getmetainfo(tagkey) {
        var url = cp + "/getmetastat/${model.id}";
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
                    $('#uniqtagscount').html(data.uniqtagscount);

                    $("#tagslist").html('');


                    jQuery.each(data.tags, function (i, val) {
                        $("#tagslist").append('<div class="col-lg-2 col-sm-3 col-6 tile_stats_count">' +
                                '<span class="count_top"><i class="fa fa-th-list"></i> Tag "' + i + '" count </span>' +
                                '<div class="count">' + val + '</div>' +
                                '</div>');
                    });

                }
                ;
            },
            error: function (xhr, ajaxOptions, thrownError) {
                getmetainfo();
            }
        });
    }
    ;
    $(document).ready(function () {
        getmetainfo();
    });
</script>    