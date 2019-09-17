
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!--<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js?v=${version}"></script>-->
<!-- DataTables bootstrap4 -->
    <script src="${cp}/resources/dataTablesBS4/js/jquery.dataTables.min.js?v=${version}"></script> 
    <script src="${cp}/resources/dataTablesBS4/js/dataTables.bootstrap4.min.js?v=${version}"></script> 
                
<script src="${cp}/resources/datatables.net-buttons/js/dataTables.buttons.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons-bs/js/buttons.bootstrap.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.flash.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.html5.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.print.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js?v=${version}"></script>

<script>
     var locale = {
        "dataTable.processing":"<spring:message code="dataTable.processing" javaScriptEscape="true"/>",
        "dataTable.search":"<spring:message code="dataTable.search" javaScriptEscape="true"/>",
        "dataTable.lengthMenu":"<spring:message code="dataTable.lengthMenu" javaScriptEscape="true"/>",
        "dataTable.info":"<spring:message code="dataTable.info" javaScriptEscape="true"/>",
        "dataTable.infoEmpty":"<spring:message code="dataTable.infoEmpty" javaScriptEscape="true"/>",
        "dataTable.infoFiltered":"<spring:message code="dataTable.infoFiltered" javaScriptEscape="true"/>",
        "dataTable.infoPostFix":"<spring:message code="dataTable.infoPostFix" javaScriptEscape="true"/>",
        "dataTable.loadingRecords":"<spring:message code="dataTable.loadingRecords" javaScriptEscape="true"/>",
        "dataTable.zeroRecords":"<spring:message code="dataTable.zeroRecords" javaScriptEscape="true"/>",
        "dataTable.emptyTable":"<spring:message code="dataTable.emptyTable" javaScriptEscape="true"/>",
        "dataTable.paginate.first":"<spring:message code="dataTable.paginate.first" javaScriptEscape="true"/>",
        "dataTable.paginate.previous":"<spring:message code="dataTable.paginate.previous" javaScriptEscape="true"/>",
        "dataTable.paginate.next":"<spring:message code="dataTable.paginate.next" javaScriptEscape="true"/>",
        "dataTable.paginate.last":"<spring:message code="dataTable.paginate.last" javaScriptEscape="true"/>",
        "dataTable.aria.sortAscending":"<spring:message code="dataTable.aria.sortAscending" javaScriptEscape="true"/>",
        "dataTable.aria.sortDescending":"<spring:message code="dataTable.aria.sortDescending" javaScriptEscape="true"/>"
    };
    $(document).ready(function () { 
        
        lang = {"processing": locale["dataTable.processing"],
        "search": locale["dataTable.search"],
        "lengthMenu": locale["dataTable.lengthMenu"],
        "info": locale["dataTable.info"],
        "infoEmpty": locale["dataTable.infoEmpty"],
        "infoFiltered": locale["dataTable.infoFiltered"],
        "infoPostFix": locale["dataTable.infoPostFix"],
        "loadingRecords": locale["dataTable.loadingRecords"],
        "zeroRecords": locale["dataTable.zeroRecords"],
        "emptyTable": locale["dataTable.emptyTable"],
        "paginate": {
            "first": locale["dataTable.paginate.first"],
            "previous": locale["dataTable.paginate.previous"],
            "next": locale["dataTable.paginate.next"],
            "last": locale["dataTable.paginate.last"]
        },
        "aria": {
            "sortAscending": locale["dataTable.aria.sortAscending"],
            "sortDescending": locale["dataTable.aria.sortDescending"]
        }
    };
        var order = [];
        $(".orderdesc").each(function () {
            order.push([$(this).index(), "desc"]);
        });

        $('#datatable-responsive').DataTable({
            "language" : lang,
            "pageLength": 25,
            "order": order
        });

        $(".select2").select2({});

        $(".select2_multiple").select2({
            allowClear: true,
            columns: [
                {"type": "string"},
                {"type": "string"},
                {"type": "numeric"}
            ]
        });  
    });    
    
                      
</script>    