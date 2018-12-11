<%-- 
    Document   : whitelablejs
    Created on : Nov 6, 2018, 1:45:11 PM
    Author     : vahan
--%>
<script>
    $(document).ready(function () {
        var path= cp+$("input.fullfileName").attr("value");
        console.log(path);
        $("input.form-info").each(function () {
//            console.log($(this).attr("infotype"));
//            if ($(this).attr("infotype")==="image/*")
//            {
//                console.log("fsdfsdfsd");
//            }
            switch ($(this).attr("infotype")) {
                case "image/*":    
                    console.log("VALOD");
                    $(this).before('<img src="'+path+$(this).attr("value")+'" height="80px" alt="'+$(this).attr("value")+'">')
                    break;
                case ".css":  // if (x === 'value2')                    
                    $(this).before('<a href="'+path+$(this).attr("value")+'">'+$(this).attr("value")+'</a>')
                    break;
            }
        });
    });

</script>
