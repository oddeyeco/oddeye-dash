<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script>
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var sotoken = ${_sotoken};
    var uuid = "${curentuser.proxy().getId()}";
    var filterOldJson = ${curentuser.proxy().getDefaultFilter()};
//    var filtersJson = {};

    <c:if test="${!empty defoptions}">
    var optionsJson = ${defoptions};
    </c:if>
    <c:if test="${empty defoptions}">
    var optionsJson = null;
    </c:if>

    <c:if test="${!empty nameoptions}">
    var nameoptions ="${fn:escapeXml(nameoptions)}";
    </c:if>
    <c:if test="${empty nameoptions}">
    var nameoptions = "@%@@%@default_page_filter@%@@%@";;
    </c:if>

    var cp = "${cp}";
    var locale = {
        "level":"<spring:message code="level"/>",
        "level_0":"<spring:message code="level_0"/>",
        "level_1":"<spring:message code="level_1"/>",
        "level_2":"<spring:message code="level_2"/>",
        "level_3":"<spring:message code="level_3"/>",
        "level_4":"<spring:message code="level_4"/>",
        "level_5":"<spring:message code="level_5"/>",
        "is":"<spring:message code="is"/>",
        "isNot":"<spring:message code="isNot"/>",
        "contains":"<spring:message code="contains"/>",
        "doesntContain":"<spring:message code="doesntContain"/>",
        "equal":"<spring:message code="equal"/>",
        "notEqual":"<spring:message code="notEqual"/>",
        "title.selectIdentic":"<spring:message code="title.selectIdentic"/>",
        "monitorings2.modal.confirmDelView":"<spring:message code="monitorings2.modal.confirmDelView"/>",
        "dashboard.Modal.successfullySaved":"<spring:message code="dashboard.Modal.successfullySaved"/>",
        "dash.errorSavingData":"<spring:message code="dash.errorSavingData"/>",
        "requestFailed":"<spring:message code="requestFailed"/>"
        };        
</script> 
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
<script src="${cp}/assets/js/monitoring2.min.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/monitoring2.js?v=${version}"></script>-->
