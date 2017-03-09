
<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script src="${cp}/resources/devbridge-autocomplete/dist/jquery.autocomplete.min.js"></script>
<script src="${cp}/resources/js/dash.js"></script>
<script src="${cp}/resources/js/editchartform.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>
<script src="${cp}/resources/numbersjs/src/numbers.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/jsoneditor/dist/jsoneditor.min.js"></script>

<script>
    var dashJSONvar = ${dashInfo};
    var chartForm;

    var container = document.getElementById("jsoneditor");
    var options = {modes :['form','tree','code'],mode:'code' };
    var editor = new JSONEditor(container, options);
//
//    var json = {
//        "Array": [1, 2, 3],
//        "Boolean": true,
//        "Null": null,
//        "Number": 123,
//        "Object": {"a": "b", "c": "d"},
//        "String": "Hello World"
//    };
//    editor.set(json);

    // get json
//    var json = editor.get();
</script>