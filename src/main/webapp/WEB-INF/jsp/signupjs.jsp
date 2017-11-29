<%-- 
    Document   : signupjs
    Created on : Jun 13, 2016, 4:58:19 PM
    Author     : vahan
--%>
<script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>

<script>
    $(document).ready(function () {
        $(".select2_country").select2({
            placeholder: "Select country",
            allowClear: true
        });
        $(".select2_tz").select2({
            placeholder: "Select Time Zone",
            allowClear: true
        });        
    });
</script>