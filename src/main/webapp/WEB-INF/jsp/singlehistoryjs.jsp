<%-- 
    Document   : singlehistoryjs
    Created on : May 23, 2017, 11:54:11 AM
    Author     : vahan
--%>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
<!--<script src="${cp}/resources/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.flash.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.html5.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.print.min.js"></script>
<script src="${cp}/resources/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>-->

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
        });
        
        $('#datatable').dataTable();
    });
</script>
