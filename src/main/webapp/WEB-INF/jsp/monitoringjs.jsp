<script>
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var uuid = "${curentuser.getId()}";
    var filterJson = ${curentuser.getDefaultFilter()};
</script> 
<script src="${cp}/assets/js/socket/dist/sockjs-1.1.1.js"></script> 
<script src="${cp}/assets/js/socket/stomp.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>
<script src="${cp}/resources/devbridge-autocomplete/dist/jquery.autocomplete.min.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script src="${cp}/resources/js/monitoring.js"></script>

