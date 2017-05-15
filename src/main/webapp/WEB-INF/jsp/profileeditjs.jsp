<script src="${cp}/resources/select2/dist/js/select2.full.min.js"></script>
<script>
    var emailfilterJson = ${activeuser.getEmailFilter()};
    var telegramfilterJson = ${activeuser.getTelegramFilter()};

    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";


    $(document).ready(function () {
        $(".select2_country").select2({
            placeholder: "Select a Country",
            allowClear: true
        });
        $(".select2_tz").select2({});
        
//        console.log(emailfilterJson);
        var elems = document.querySelectorAll('#email_note .js-switch-small');
        for (var i = 0; i < elems.length; i++) {
            if (typeof (emailfilterJson[elems[i].id]) != "undefined")
                if (emailfilterJson[elems[i].id] != "")
                {
                    if (!elems[i].checked)
                        $(elems[i]).trigger('click');
                } else
                {
                    if (elems[i].checked)
                        $(elems[i]).trigger('click');

                }
            var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        }
        
        $('.autocomplete-append-metric').each(function () {
            var input = $(this);
            var uri = cp + "/getfiltredmetricsnames?filter=^(.*)$";
            $.getJSON(uri, null, function (data) {
                input.autocomplete({
                    lookup: data.data,
                    appendTo: '.autocomplete-container-metric'
                });
            })
        });

        $('.autocomplete-append').each(function () {
            var input = $(this);
            var uri = cp + "/gettagvalue?key=" + input.attr("tagkey") + "&filter=^(.*)$";
            $.getJSON(uri, null, function (data) {
                input.autocomplete({
                    lookup: data.data,
                    appendTo: '.autocomplete-container_' + input.attr("tagkey")
                });
            })
        });        

        $("#email_note .filter-input").each(function () {
            $(this).val(emailfilterJson[$(this).attr("name")]);
        });

        var elems = document.querySelectorAll('#telegram_note .js-switch-small');
        for (var i = 0; i < elems.length; i++) {
            if (typeof (telegramfilterJson[elems[i].id]) != "undefined")
                if (telegramfilterJson[elems[i].id] != "")
                {
                    if (!elems[i].checked)
                        $(elems[i]).trigger('click');
                } else
                {
                    if (elems[i].checked)
                        $(elems[i]).trigger('click');

                }
            var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        }

        $("#telegram_note .filter-input").each(function () {
            $(this).val(telegramfilterJson[$(this).attr("name")]);
        });


        $('body').on("click", ".savefilter", function () {
            var name = "oddeye_base_" + $(this).parents("form").attr("name");
            var formData = $(this).parents("form").serializeArray();
            filterJson = {};
            jQuery.each(formData, function (i, field) {
                if (field.value != "")
                {
                    filterJson[field.name] = field.value;
                }

            });
            var sendData = {};
//            console.log(filterJson);
            sendData.filter = JSON.stringify(filterJson);
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            url = cp + "/savefilter/" + name;
//            console.log(url);
            $.ajax({
                dataType: 'json',
                type: 'POST',
                url: url,
                data: sendData,
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(header, token);
                }
            }).done(function (msg) {
                if (msg.sucsses)
                {
                    alert("Data Saved ");
                } else
                {
                    alert("Request failed");
                }
            }).fail(function (jqXHR, textStatus) {
                alert("Request failed");
            });
        }
        );

    });
</script>