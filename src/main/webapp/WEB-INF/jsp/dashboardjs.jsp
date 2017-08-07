<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script src="${cp}/resources/js/dash.js"></script>
<script src="${cp}/resources/js/editform.js"></script>
<script src="${cp}/resources/js/editchartform.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>
<script src="${cp}/resources/numbersjs/src/numbers.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/jsoneditor/dist/jsoneditor.min.js"></script>

<script>
    var gdd = ${dashInfo};
    var Edit_Form;
    var balanse = 0;
    <c:if test="${curentuser.getBalance()!=null}">
    balanse = ${curentuser.getBalance()};
    </c:if>

</script>