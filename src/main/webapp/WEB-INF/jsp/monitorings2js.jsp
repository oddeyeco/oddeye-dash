<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var sotoken = ${_sotoken};
    var uuid = "${curentuser.getId()}";
    var filterOldJson = ${curentuser.getDefaultFilter()};
//    var filtersJson = {};

    <c:if test="${!empty defoptions}">
    var optionsJson = ${defoptions};
    </c:if>
    <c:if test="${empty defoptions}">
    var optionsJson = null;
    </c:if>

    var cp = "${cp}";
</script> 
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
<!--<script src="${cp}/assets/js/monitoring.min.js?v=${version}"></script>-->
<script src="${cp}/resources/js/monitorings2.js?v=${version}"></script>