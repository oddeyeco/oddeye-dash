<%-- 
    Document   : signupjs
    Created on : May 2, 2017, 11:31:16 AM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script>
    $(document).ready(function () {
        $(".select2_country").select2({
            placeholder: "Select a Country",
            allowClear: true
        });
        $(".select2_tz").select2({
            placeholder: "Select a TimeZone",
            allowClear: true
        });
    }
    );
</script>