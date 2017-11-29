<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons/js/dataTables.buttons.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons-bs/js/buttons.bootstrap.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.flash.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.html5.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-buttons/js/buttons.print.min.js?v=${version}"></script>
<script src="${cp}/resources/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js?v=${version}"></script>

<script>
    $('#datatable-responsive').DataTable({
          "pageLength": 25
        });
        
        $(".select2_multiple").select2({
          allowClear: true
        });        
</script>    