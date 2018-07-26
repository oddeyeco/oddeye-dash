<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
<script src="${cp}/resources/js/dash.js?v=${version}"></script>
<script src="${cp}/resources/js/editform.js?v=${version}"></script>
<script src="${cp}/resources/js/editchartform.js?v=${version}"></script>
<script src="${cp}/resources/js/countereditform.js?v=${version}"></script>
<script src="${cp}/resources/numbersjs/src/numbers.min.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<script src="${cp}/resources/jsoneditor/dist/jsoneditor.min.js?v=${version}"></script>
<script src="${cp}/resources/html2canvas/html2canvas.min.js?v=${version}"></script>

<script>
    var gdd = ${dashInfo};
    var Edit_Form;
    var balanse = 0;
    var locale = {
      "save":"<spring:message code="save"/>",
      "dash.backToDash":"<spring:message code="dash.backToDash"/>",
      
      "dash.edit.chart":"<spring:message code="dash.edit.chart"/>",
      "dash.edit.counter":"<spring:message code="dash.edit.counter"/>",
      "dash.edit.table":"<spring:message code="dash.edit.table"/>",      
      "dash.show.chart":"<spring:message code="dash.show.chart"/>",
      "dash.show.counter":"<spring:message code="dash.show.counter"/>",
      "dash.show.table":"<spring:message code="dash.show.table"/>",
      
      "dash.title.lockDashboard":"<spring:message code="dash.title.lockDashboard"/>",
      "dash.title.unlockDashboard":"<spring:message code="dash.title.unlockDashboard"/>",     
      "dash.row":"<spring:message code="dash.row"/>",      
      "dash.title.expand":"<spring:message code="dash.title.expand"/>",
      
      "datetime.lastminute":"<spring:message code="datetime.lastminute"/>",
      "datetime.lasthoures":"<spring:message code="datetime.lasthoures"/>",
      "datetime.lasthoures2":"<spring:message code="datetime.lasthoures2"/>",
      "datetime.lastdays":"<spring:message code="datetime.lastdays"/>",
      "datetime.lastdays2":"<spring:message code="datetime.lastdays2"/>",

      "datetime.lastonehoure":"<spring:message code="datetime.lastonehoure"/>",
      "datetime.lastoneday":"<spring:message code="datetime.lastoneday"/>", 
      "datetime.general":"<spring:message code="datetime.general"/>"    
    };
    var DtPicerlocale = {
            applyLabel: '<spring:message code="datetime.submit"/>',
            cancelLabel: '<spring:message code="datetime.clear"/>',
            fromLabel: '<spring:message code="datetime.from"/>',
            toLabel: '<spring:message code="datetime.to"/>',
            customRangeLabel: '<spring:message code="datetime.custom"/>',
            weekLabel: '<spring:message code="datetime.weekLabel"/>',
            daysOfWeek: ['<spring:message code="su"/>', '<spring:message code="mo"/>', '<spring:message code="tu"/>', '<spring:message code="we"/>', '<spring:message code="th"/>', '<spring:message code="fr"/>', '<spring:message code="sa"/>'],
            monthNames: ['<spring:message code="january"/>', '<spring:message code="february"/>', '<spring:message code="march"/>', '<spring:message code="april"/>', '<spring:message code="may"/>', '<spring:message code="june"/>', '<spring:message code="july"/>', '<spring:message code="august"/>', '<spring:message code="september"/>', '<spring:message code="october"/>', '<spring:message code="november"/>', '<spring:message code="december"/>'],
            firstDay: 1
    };
    <c:if test="${curentuser.getBalance()!=null}">
    balanse = ${curentuser.getBalance()};
    </c:if>
</script>