<script>
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var sotoken = ${_sotoken};
    var uuid = "${curentuser.proxy().getId()}";
    var filterJson = ${curentuser.proxy().getDefaultFilter()};
    var cp = "${cp}";
</script> 
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
<script src="${cp}/assets/js/monitoring.min.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/monitoring.js?v=${version}"></script>-->
