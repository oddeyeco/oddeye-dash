<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.flash.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.html5.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.print.min.js"></script>
<script src="${cp}/resources/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>


<script>
    $(document).ready(function () {
        var table = $('.table-striped').DataTable({
            fixedHeader: false;
            "paging": false,
        });


        $(".metrictable").each(function () {
            var val = $(this).find("tbody tr").length;
            if (val == 0)
            {
                $(this).parents(".panel").hide();
            }
        });
//        $(".metrictable tr").each(function (){
//            var val =Math.abs(parseFloat($(this).find(".value").html()));
//            if (val<1)
//            {
//                $(this).hide();
//            }
//            var val =Math.abs(parseFloat($(this).find(".persent").html()));
//            if (val<50)
//            {
//                $(this).hide();
//            }
//
//            var val =Math.abs(parseFloat($(this).find(".weight").html()));
//            if (val<8)
//            {
//                $(this).hide();
//            }
//        
//                
//        });




//        $("td.value").filter(function () {
//            return $(this).html() == 1;
//        }).hide();
    });</script>

<script>
    $(document).ready(function () {
        $(".time").each(function () {
            val = $(this).html();
            time = moment(val * 1000);
            $(this).html(time.format("h:mm:ss a"));

        })

    });
</script>    
