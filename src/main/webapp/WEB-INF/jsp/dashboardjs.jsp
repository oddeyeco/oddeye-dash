<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>-->
<script src="${cp}/assets/js/echarts.min.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
<script src="${cp}/resources/js/dash.js?v=${version}"></script>
<script src="${cp}/resources/js/editform.js?v=${version}"></script>

<sec:authorize access="hasRole('ADMIN')">
<script src="${cp}/resources/js/editchartform.js?v=${version}"></script>
</sec:authorize>
<sec:authorize access="not hasRole('ADMIN')">
<script src="${cp}/resources/js/editchartform_old.js?v=${version}"></script>
</sec:authorize>

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
        "save": "<spring:message code="save"/>",
        "dash.backToDash": "<spring:message code="dash.backToDash"/>",

        "dash.edit.chart": "<spring:message code="dash.edit.chart"/>",
        "dash.edit.counter": "<spring:message code="dash.edit.counter"/>",
        "dash.edit.table": "<spring:message code="dash.edit.table"/>",
        "dash.edit.heatmap": "<spring:message code="dash.edit.heatmap"/>",
        
        "dash.show.chart": "<spring:message code="dash.show.chart"/>",
        "dash.show.counter": "<spring:message code="dash.show.counter"/>",
        "dash.show.table": "<spring:message code="dash.show.table"/>",

        "dash.title.lockDashboard": "<spring:message code="dash.title.lockDashboard"/>",
        "dash.title.unlockDashboard": "<spring:message code="dash.title.unlockDashboard"/>",
        "dash.row": "<spring:message code="dash.row"/>",
        "dash.title.expand": "<spring:message code="dash.title.expand"/>",
        "dash.modal.confirmDelRow": "<spring:message code="dash.modal.confirmDelRow" javaScriptEscape="true"/>",
        "dash.modal.confirmDelChart": "<spring:message code="dash.modal.confirmDelChart" javaScriptEscape="true"/>",
        "dash.modal.confirmDelCounter": "<spring:message code="dash.modal.confirmDelCounter" javaScriptEscape="true"/>",
        "dash.modal.confirmDelDashboard": "<spring:message code="dash.modal.confirmDelDashboard"/>",
        "dash.errorSavingData": "<spring:message code="dash.errorSavingData"/>",

        "datetime.lastminute": "<spring:message code="datetime.lastminute"/>",
        "datetime.lasthoures": "<spring:message code="datetime.lasthoures"/>",
        "datetime.lasthoures2": "<spring:message code="datetime.lasthoures2"/>",
        "datetime.lastdays": "<spring:message code="datetime.lastdays"/>",
        "datetime.lastdays2": "<spring:message code="datetime.lastdays2"/>",
        "datetime.lastonehoure": "<spring:message code="datetime.lastonehoure"/>",
        "datetime.lastoneday": "<spring:message code="datetime.lastoneday"/>",
        "datetime.general": "<spring:message code="datetime.general"/>",

        "editform.jsonManualEdit": "<spring:message code="editform.jsonManualEdit"/>",
        "editform.self": "<spring:message code="editform.self"/>",
        "editform.blank": "<spring:message code="editform.blank"/>",
        "editform.dimensions": "<spring:message code="editform.dimensions"/>",
        "editform.span": "<spring:message code="editform.span"/>",
        "editform.height": "<spring:message code="editform.height"/>",
        "editform.disabled": "<spring:message code="editform.disabled"/>",
        "editform.aggregator": "<spring:message code="editform.aggregator"/>",
        "editform.alias": "<spring:message code="editform.alias"/>",
        "editform.aliasSecondary": "<spring:message code="editform.aliasSecondary"/>",
        "editform.alias.text": "<spring:message code="editform.alias.text"/>",
        "editform.aliasSecondary.text": "<spring:message code="editform.aliasSecondary.text"/>",
        "editform.downSample": "<spring:message code="editform.downSample"/>",
        "editform.disableDownsampling": "<spring:message code="editform.disableDownsampling"/>",
        "editform.rate": "<spring:message code="editform.rate"/>",
        "editform.times": "<spring:message code="editform.times"/>",
        "editform.refreshGeneral": "<spring:message code="editform.refreshGeneral"/>",
        "editform.refreshOff": "<spring:message code="editform.refreshOff"/>",
        "editform.refresh5s": "<spring:message code="editform.refresh5s"/>",
        "editform.refresh10s": "<spring:message code="editform.refresh10s"/>",
        "editform.refresh30s": "<spring:message code="editform.refresh30s"/>",
        "editform.refresh1m": "<spring:message code="editform.refresh1m"/>",
        "editform.refresh5m": "<spring:message code="editform.refresh5m"/>",
        "editform.refresh15m": "<spring:message code="editform.refresh15m"/>",
        "editform.refresh30m": "<spring:message code="editform.refresh30m"/>",
        "editform.refresh1h": "<spring:message code="editform.refresh1h"/>",
        "editform.refresh2h": "<spring:message code="editform.refresh2h"/>",
        "editform.refresh1d": "<spring:message code="editform.refresh1d"/>",
        "editform.jsonEditor": "<spring:message code="editform.jsonEditor"/>",
        "editform.code": "<spring:message code="editform.code"/>",
        "editform.form": "<spring:message code="editform.form"/>",
        "editform.tree": "<spring:message code="editform.tree"/>",
        "editform.currency": "<spring:message code="editform.currency"/>",
        "editform.dataIEC": "<spring:message code="editform.dataIEC"/>",
        "editform.dataMetric": "<spring:message code="editform.dataMetric"/>",
        "editform.dataRate": "<spring:message code="editform.dataRate"/>",
        "editform.throughput": "<spring:message code="editform.throughput"/>",
        "editform.lenght": "<spring:message code="editform.lenght"/>",
        "editform.velocity": "<spring:message code="editform.velocity"/>",
        "editform.volume": "<spring:message code="editform.volume"/>",
        "editform.energy": "<spring:message code="editform.energy"/>",
        "editform.temperature": "<spring:message code="editform.temperature"/>",
        "editform.pressure": "<spring:message code="editform.pressure"/>",
        "editform.title.mergeSimilarQueries": "<spring:message code="editform.title.mergeSimilarQueries"/>",

        "info": "<spring:message code="info"/>",
        "title": "<spring:message code="title"/>",
        "metrics": "<spring:message code="metrics"/>",
        "display": "<spring:message code="display"/>",
        "tags": "<spring:message code="tags"/>",
        "reset": "<spring:message code="reset"/>",
        "apply": "<spring:message code="apply"/>",

        "editchartform.general": "<spring:message code="editchartform.general"/>",
        "editchartform.axes": "<spring:message code="editchartform.axes"/>",
        "editchartform.dataZoom": "<spring:message code="editchartform.dataZoom"/>",
        "editchartform.legend": "<spring:message code="editchartform.legend"/>",
        "editchartform.timeRange": "<spring:message code="editchartform.timeRange"/>",
        "editchartform.json": "<spring:message code="editchartform.json"/>",
        "editchartform.description": "<spring:message code="editchartform.description"/>",
        "editchartform.link": "<spring:message code="editchartform.link"/>",
        "editchartform.target": "<spring:message code="editchartform.target"/>",
        "editchartform.fontSize": "<spring:message code="editchartform.fontSize"/>",
        "editchartform.positions": "<spring:message code="editchartform.positions"/>",
        "editchartform.colors": "<spring:message code="editchartform.colors"/>",
        "editchartform.color": "<spring:message code="editchartform.color"/>",
        "editchartform.detail": "<spring:message code="editchartform.detail"/>",
        
        "editchartform.border": "<spring:message code="editchartform.border"/>",
        "editchartform.OR": "<spring:message code="editchartform.OR"/>",
        "editchartform.background": "<spring:message code="editchartform.background"/>",
        "editchartform.width": "<spring:message code="editchartform.width"/>",
        "editchartform.center": "<spring:message code="editchartform.center"/>",
        "editchartform.left": "<spring:message code="editchartform.left"/>",
        "editchartform.right": "<spring:message code="editchartform.right"/>",
        "editchartform.top": "<spring:message code="editchartform.top"/>",
        "editchartform.bottom": "<spring:message code="editchartform.bottom"/>",
        "editchartform.inverse": "<spring:message code="editchartform.inverse"/>",
        "editchartform.axesIndexes": "<spring:message code="editchartform.axesIndexes"/>",
        "editchartform.remove": "<spring:message code="editchartform.remove"/>",
        "editchartform.dublicate": "<spring:message code="editchartform.dublicate"/>",
        "editchartform.add": "<spring:message code="editchartform.add"/>",
        "editchartform.Yaxes": "<spring:message code="editchartform.Yaxes"/>",
        "editchartform.Xaxes": "<spring:message code="editchartform.Xaxes"/>",
        "editchartform.show": "<spring:message code="editchartform.show"/>",
        "editchartform.text": "<spring:message code="editchartform.text"/>",
        "editchartform.position": "<spring:message code="editchartform.position"/>",
        "editchartform.splitNumber": "<spring:message code="editchartform.splitNumber"/>",
        "editchartform.Ycolor": "<spring:message code="editchartform.Ycolor"/>",
        "editchartform.Xcolor": "<spring:message code="editchartform.Xcolor"/>",
        "editchartform.Y-Min": "<spring:message code="editchartform.Y-Min"/>",
        "editchartform.Y-Max": "<spring:message code="editchartform.Y-Max"/>",
        "editchartform.fontSizeLabel": "<spring:message code="editchartform.fontSizeLabel"/>",
        "editchartform.unit": "<spring:message code="editchartform.unit"/>",
        "editchartform.scale": "<spring:message code="editchartform.scale"/>",
        "editchartform.time": "<spring:message code="editchartform.time"/>",
        "editchartform.series": "<spring:message code="editchartform.series"/>",
        "editchartform.value": "<spring:message code="editchartform.value"/>",
        "editchartform.start": "<spring:message code="editchartform.start"/>",
        "editchartform.end": "<spring:message code="editchartform.end"/>",
        "editchartform.type": "<spring:message code="editchartform.type"/>",
        "editchartform.inside": "<spring:message code="editchartform.inside"/>",
        "editchartform.slider": "<spring:message code="editchartform.slider"/>",
        "editchartform.XaxisIndex": "<spring:message code="editchartform.XaxisIndex"/>",
        "editchartform.YaxisIndex": "<spring:message code="editchartform.YaxisIndex"/>",
        "editchartform.orient": "<spring:message code="editchartform.orient"/>",
        "editchartform.horizontal": "<spring:message code="editchartform.horizontal"/>",
        "editchartform.vertical": "<spring:message code="editchartform.vertical"/>",
        "editchartform.selectMode": "<spring:message code="editchartform.selectMode"/>",
        "editchartform.single": "<spring:message code="editchartform.single"/>",
        "editchartform.multiple": "<spring:message code="editchartform.multiple"/>",
        "editchartform.shapeWidth": "<spring:message code="editchartform.shapeWidth"/>",
        "editchartform.borderColor": "<spring:message code="editchartform.borderColor"/>",
        "editchartform.textColor": "<spring:message code="editchartform.textColor"/>",
        "editchartform.animation": "<spring:message code="editchartform.animation"/>",
        "editchartform.containsLabel": "<spring:message code="editchartform.containsLabel"/>",
        "editchartform.points": "<spring:message code="editchartform.points"/>",
        "editchartform.fillArea": "<spring:message code="editchartform.fillArea"/>",
        "editchartform.staircase": "<spring:message code="editchartform.staircase"/>",
        "editchartform.labelPosition": "<spring:message code="editchartform.labelPosition"/>",
        "editchartform.labelFormat": "<spring:message code="editchartform.labelFormat"/>",
        "editchartform.labelFormat.text": "<spring:message code="editchartform.labelFormat.text"/>",
        "editchartform.labelFormat.text2": "<spring:message code="editchartform.labelFormat.text2"/>",
        "editchartform.labelShow": "<spring:message code="editchartform.labelShow"/>",
        "editchartform.stacked": "<spring:message code="editchartform.stacked"/>",
        "editchartform.smooth": "<spring:message code="editchartform.smooth"/>",
        "editchartform.middle": "<spring:message code="editchartform.middle"/>",
        "editchartform.lines": "<spring:message code="editchartform.lines"/>",
        "editchartform.bars": "<spring:message code="editchartform.bars"/>",
        "editchartform.pie": "<spring:message code="editchartform.pie"/>",
        "editchartform.gauge": "<spring:message code="editchartform.gauge"/>",
        "editchartform.funnel": "<spring:message code="editchartform.funnel"/>",
        "editchartform.treemap": "<spring:message code="editchartform.treemap"/>",
        "editchartform.circle": "<spring:message code="editchartform.circle"/>",
        "editchartform.rectangle": "<spring:message code="editchartform.rectangle"/>",
        "editchartform.triangle": "<spring:message code="editchartform.triangle"/>",
        "editchartform.diamond": "<spring:message code="editchartform.diamond"/>",
        "editchartform.emptyCircle": "<spring:message code="editchartform.emptyCircle"/>",
        "editchartform.emptyRectang": "<spring:message code="editchartform.emptyRectang"/>",
        "editchartform.emptyTriangl": "<spring:message code="editchartform.emptyTriangl"/>",
        "editchartform.emptyDiamond": "<spring:message code="editchartform.emptyDiamond"/>",
        "editchartform.insideLeft": "<spring:message code="editchartform.insideLeft"/>",
        "editchartform.insideRight": "<spring:message code="editchartform.insideRight"/>",
        "editchartform.insideTop": "<spring:message code="editchartform.insideTop"/>",
        "editchartform.insideBottom": "<spring:message code="editchartform.insideBottom"/>",
        "editchartform.outside": "<spring:message code="editchartform.outside"/>",
        "editchartform.inner": "<spring:message code="editchartform.inner"/>",
        "editchartform.options": "<spring:message code="editchartform.options"/>",
        "editchartform.labels": "<spring:message code="editchartform.labels"/>",
        "editchartform.backgroundColors": "<spring:message code="editchartform.backgroundColors"/>",

        "editchartform.visualMaporient": "<spring:message code="editchartform.visualMaporient"/>",
        "editchartform.visualMapshow": "<spring:message code="editchartform.visualMapshow"/>",
        "editchartform.visualMapColorScheme": "<spring:message code="editchartform.visualMapColorScheme"/>",
        "editchartform.visualMapmin": "<spring:message code="editchartform.visualMapmin"/>",
        "editchartform.visualMapmax": "<spring:message code="editchartform.visualMapmax"/>",
        "editchartform.visualMapleft": "<spring:message code="editchartform.visualMapleft"/>",
        "editchartform.visualMaptop": "<spring:message code="editchartform.visualMaptop"/>",
        "editchartform.visualMapright": "<spring:message code="editchartform.visualMapright"/>",
        "editchartform.visualMapbottom": "<spring:message code="editchartform.visualMapbottom"/>",
        "editchartform.visualMapwidth": "<spring:message code="editchartform.visualMapwidth"/>",
        "editchartform.visualMapheight": "<spring:message code="editchartform.visualMapheight"/>",

        "countereditform.columnSpan": "<spring:message code="countereditform.columnSpan"/>",
        "countereditform.backgroundColors": "<spring:message code="countereditform.backgroundColors"/>",
        "countereditform.fontColors": "<spring:message code="countereditform.fontColors"/>",
        "countereditform.fontSize": "<spring:message code="countereditform.fontSize"/>",
        "countereditform.subtitle": "<spring:message code="countereditform.subtitle"/>",
        "countereditform.box": "<spring:message code="countereditform.box"/>",

        "dashboard.Modal.successfullySaved": "<spring:message code="dashboard.Modal.successfullySaved"/>"
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