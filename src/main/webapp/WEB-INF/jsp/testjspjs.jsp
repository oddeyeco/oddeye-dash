<%-- 
    Document   : testjspjs
    Created on : Apr 3, 2017, 1:32:34 PM
    Author     : vahan
--%><%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.flash.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.html5.min.js"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.print.min.js"></script>
<script src="${cp}/resources/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>

<script>
    var dataSet = [
        {
            "name": "Tiger Nixon",
            "position": "System Architect",
            "salary": "$3,120",
            "start_date": "2011/04/25",
            "office": "Edinburgh",
            "extn": "5421"
        },
        {
            "name": "Garrett Winters",
            "position": "Director",
            "salary": "$5,300",
            "start_date": "2011/07/25",
            "office": "Edinburgh",
            "extn": "8422"
        }
    ];

    $(document).ready(function () {
        $('#example').DataTable({
            data: dataSet,
            columns: [
                {data: 'name',title :"sssss", class:'type'},
                {data: 'position'},
                {data: 'salary'},
                {data: 'office'}
            ]
        });
    });
</script>