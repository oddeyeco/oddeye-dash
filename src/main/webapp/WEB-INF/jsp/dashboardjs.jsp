<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>
<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>
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
    <c:if test="${curentuser.getBalance()!=null}">
    balanse = ${curentuser.getBalance()};
    </c:if>
</script>