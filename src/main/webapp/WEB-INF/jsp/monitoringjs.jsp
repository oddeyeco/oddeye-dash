<script>
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var sotoken = ${_sotoken};
    var uuid = "${curentuser.getId()}";
    var filterJson = ${curentuser.getDefaultFilter()};
    var cp = "${cp}";
</script> 
<script src="${cp}/assets/dist/sockjs-1.1.1.min.js"></script> 
<script src="${cp}/assets/js/stomp.min.js"></script>
<script src="${cp}/assets/js/chartsfuncs.min.js"></script>
<script src="${cp}/assets/js/monitoring.min.js"></script>

