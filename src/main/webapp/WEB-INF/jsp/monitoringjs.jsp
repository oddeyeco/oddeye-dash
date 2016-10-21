<script>
    $(document).ready(function () {
        $(".time").each(function (){
            val = $(this).html();
            time = moment(val*1000);
            $(this).html(time.format("h:mm:ss a"));
            
        })

    });
</script>    
