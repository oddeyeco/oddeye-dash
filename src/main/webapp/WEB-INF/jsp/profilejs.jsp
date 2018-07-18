<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js?v=${version}"></script>
<script src="${cp}/assets/js/metricinfo.min.js?v=${version}"></script>
<script>
    var header = $("meta[name='_csrf_header']").attr("content");
    var token = $("meta[name='_csrf']").attr("content");
    
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
      "metricinfo.metricsWithTag":"<spring:message code="metricinfo.metricsWithTag" javaScriptEscape="true"/>"
      
    }
</script>