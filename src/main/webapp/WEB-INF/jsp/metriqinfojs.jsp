<%-- 
    Document   : metriqinfojs
    Created on : Dec 5, 2016, 2:38:46 PM
    Author     : vahan
--%>


<script>
    $(document).ready(function () {
        $(".time").each(function () {
            val = $(this).html();
            time = moment(val * 1000);
            $(this).html(time.format("h:mm:ss a"));
        });
    });
</script> 