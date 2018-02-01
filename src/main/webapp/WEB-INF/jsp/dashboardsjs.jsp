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
        $(".Consumptions .green").each(function (){
           var val=$(this).text();
           if (getDecimalSeparator()===".")
           {               
               val=val.replace(",",".");               
           }
           else
           {
               val=val.replace(".",",");
           }
           $(this).text(val);
        });
 
        var value=25;
        value = value + value * pp / 100 + pf;
        $("#oddeyeAmmount").val(value.toFixed(2));
        $("#paypalAmmount").val($("#oddeyeAmmount").val());
        $('body').on("blur", "#oddeyeAmmount", function () {
            var value = Number($(this).val());
            value = (value - 0.3) / (1 + 2 / 100);
            $("#paypalAmmount").val($("#oddeyeAmmount").val());
        });
    });
</script>
