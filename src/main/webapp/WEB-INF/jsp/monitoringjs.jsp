<script>
    $(document).ready(function () {
//        $('.collapse').on('shown.bs.collapse', function () {
//            alert($(this).attr("filter"));
//            $(this).find("table .metricrow").each(function () {
//                alert($(this).attr("name"));
//            })
//        });
        
        console.log($("table .metricrow").size());
        $("table .metricrow").each(function () {
            console.log($(this).attr("name")+$(this).attr("filter"));
        })
    });
</script>    
