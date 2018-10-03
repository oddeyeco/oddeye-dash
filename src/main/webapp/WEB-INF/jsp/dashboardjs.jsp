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
      "datetime.general":"<spring:message code="datetime.general"/>", 
      
      "editform.jsonManualEdit":"<spring:message code="editform.jsonManualEdit"/>",
      
      "editchartform.general":"<spring:message code="editchartform.general"/>",    
      "metrics":"<spring:message code="metrics"/>",    
      "editchartform.axes":"<spring:message code="editchartform.axes"/>",    
      "editchartform.dataZoom":"<spring:message code="editchartform.dataZoom"/>", 
      "editchartform.legend":"<spring:message code="editchartform.legend"/>", 
      "display":"<spring:message code="display"/>", 
      "editchartform.timeRange":"<spring:message code="editchartform.timeRange"/>", 
      "editchartform.json":"<spring:message code="editchartform.json"/>",
      "info":"<spring:message code="info"/>",
      "title":"<spring:message code="title"/>",
      "editchartform.dimensions":"<spring:message code="editchartform.dimensions"/>",
      "editchartform.description":"<spring:message code="editchartform.description"/>",
      "editchartform.link":"<spring:message code="editchartform.link"/>",
      "editchartform.target":"<spring:message code="editchartform.target"/>",
      "editchartform.self":"<spring:message code="editchartform.self"/>",
      "editchartform.blank":"<spring:message code="editchartform.blank"/>",
      "editchartform.fontSize":"<spring:message code="editchartform.fontSize"/>",
      "editchartform.span":"<spring:message code="editchartform.span"/>",
      "editchartform.height":"<spring:message code="editchartform.height"/>",
      "editchartform.positions":"<spring:message code="editchartform.positions"/>",
      "editchartform.colors":"<spring:message code="editchartform.colors"/>",
      "editchartform.border":"<spring:message code="editchartform.border"/>",
      "editchartform.OR":"<spring:message code="editchartform.OR"/>",
      "editchartform.background":"<spring:message code="editchartform.background"/>",
      "editchartform.width":"<spring:message code="editchartform.width"/>",
      "editchartform.center":"<spring:message code="editchartform.center"/>",
      "editchartform.left":"<spring:message code="editchartform.left"/>",
      "editchartform.right":"<spring:message code="editchartform.right"/>",
      "editchartform.top":"<spring:message code="editchartform.top"/>",
      "editchartform.bottom":"<spring:message code="editchartform.bottom"/>",
      "editchartform.disabled":"<spring:message code="editchartform.disabled"/>",
      "tags":"<spring:message code="tags"/>",
      "editchartform.aggregator":"<spring:message code="editchartform.aggregator"/>",
      "editchartform.downSample":"<spring:message code="editchartform.downSample"/>",
      "editchartform.disableDownsampling":"<spring:message code="editchartform.disableDownsampling"/>",
      "editchartform.alias":"<spring:message code="editchartform.alias"/>",
      "editchartform.aliasSecondary":"<spring:message code="editchartform.aliasSecondary"/>",
      "editchartform.rate":"<spring:message code="editchartform.rate"/>",
      "editchartform.inverse":"<spring:message code="editchartform.inverse"/>",
      "editchartform.axisIndexes":"<spring:message code="editchartform.axisIndexes"/>",
      "editchartform.remove":"<spring:message code="editchartform.remove"/>",
      "editchartform.dublicate":"<spring:message code="editchartform.dublicate"/>",
      "editchartform.add":"<spring:message code="editchartform.add"/>",
      "editchartform.Yaxes":"<spring:message code="editchartform.Yaxes"/>",
      "editchartform.Xaxes":"<spring:message code="editchartform.Xaxes"/>",
      "editchartform.show":"<spring:message code="editchartform.show"/>",
      "editchartform.text":"<spring:message code="editchartform.text"/>",
      "editchartform.position":"<spring:message code="editchartform.position"/>",
      "editchartform.splitNumber":"<spring:message code="editchartform.splitNumber"/>",
      "editchartform.Ycolor":"<spring:message code="editchartform.Ycolor"/>",
      "editchartform.Xcolor":"<spring:message code="editchartform.Xcolor"/>",
      "editchartform.Y-Min":"<spring:message code="editchartform.Y-Min"/>",
      "editchartform.Y-Max":"<spring:message code="editchartform.Y-Max"/>",
      "editchartform.fontSizeLabel":"<spring:message code="editchartform.fontSizeLabel"/>",
      "editchartform.unit":"<spring:message code="editchartform.unit"/>",
      "editchartform.scale":"<spring:message code="editchartform.scale"/>",
      "editchartform.time":"<spring:message code="editchartform.time"/>",
      "editchartform.series":"<spring:message code="editchartform.series"/>",
      "editchartform.value":"<spring:message code="editchartform.value"/>",
      "":"<spring:message code=""/>",
      "":"<spring:message code=""/>",
      "":"<spring:message code=""/>",
      "":"<spring:message code=""/>",
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