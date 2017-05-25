<%-- 
    Document   : singlehistoryjs
    Created on : May 23, 2017, 11:54:11 AM
    Author     : vahan
--%>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script>
    $(document).ready(function () {

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

            //moment.duration(interval).humanize()
        });


    });
</script>
