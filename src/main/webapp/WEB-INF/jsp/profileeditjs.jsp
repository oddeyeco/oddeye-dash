<script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>
<script>
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    $(document).ready(function () {                
        $(".select2_country").select2({
            placeholder: "Select a Country",
            allowClear: true
        });
        $(".select2_tz").select2({});
    });
</script>