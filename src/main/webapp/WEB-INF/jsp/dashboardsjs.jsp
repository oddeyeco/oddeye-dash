<%-- 
    Document   : dashboardsjs
    Created on : Apr 12, 2017, 12:14:35 PM
    Author     : vahan
--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js?v=${version}"></script>
<!--<script src="${cp}/assets/js/metricinfo.min.js?v=${version}"></script>-->
<script src="${cp}/resources/js/metricinfo.js?v=${version}"></script>
<script>
    var header = $("meta[name='_csrf_header']").attr("content");
    var token = $("meta[name='_csrf']").attr("content");
    var pp =${paypal_percent};
    var pf = ${paypal_fix};
    var locale = {
      "metricinfo.showList":"<spring:message code="metricinfo.showList"/>",
      "metricinfo.tagtitle":"<spring:message code="metricinfo.tagtitle" javaScriptEscape="true"/>",
      "metricsList":"<spring:message code="metricsList"/>",
      "typesList":"<spring:message code="typesList"/>",
      "name2":"<spring:message code="name2" javaScriptEscape="true"/>",
      "count":"<spring:message code="count" javaScriptEscape="true"/>",
      "delete":"<spring:message code="delete" javaScriptEscape="true"/>",
      "deleteSelected":"<spring:message code="deleteSelected" javaScriptEscape="true"/>",
      "metricinfo.tagList":"<spring:message code="metricinfo.tagList" javaScriptEscape="true"/>",
      "metricinfo.metricsWithTag":"<spring:message code="metricinfo.metricsWithTag" javaScriptEscape="true"/>",
      "metricinfo.metricsWithName":"<spring:message code="metricinfo.metricsWithName" javaScriptEscape="true"/>",
      "metricinfo.metricsWithType":"<spring:message code="metricinfo.metricsWithType" javaScriptEscape="true"/>",      
      "metricinfo.clearRegression":"<spring:message code="metricinfo.clearRegression" javaScriptEscape="true"/>",      
      "metricinfo.showChart":"<spring:message code="metricinfo.showChart" javaScriptEscape="true"/>",      
      "tags":"<spring:message code="tags" javaScriptEscape="true"/>",      
      "adminlist.type":"<spring:message code="adminlist.type" javaScriptEscape="true"/>",      
      "firstTime":"<spring:message code="firstTime" javaScriptEscape="true"/>",      
      "lastTime":"<spring:message code="lastTime" javaScriptEscape="true"/>",      
      "aliveDays":"<spring:message code="aliveDays" javaScriptEscape="true"/>",      
      "silenceDays":"<spring:message code="silenceDays" javaScriptEscape="true"/>"    
    }    
    
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
