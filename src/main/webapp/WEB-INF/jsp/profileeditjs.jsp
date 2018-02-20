<script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>
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

        $(".form-filter .js-switch-small").each(function () {            
            var json = {};
            if ($(this).parents(".form-filter").attr("id") === "email_note")
            {
                json = emailfilterJson;
            }
            if ($(this).parents(".form-filter").attr("id") === "telegram_note")
            {
                json = telegramfilterJson;
            }
            if (typeof (json[$(this).attr("name")]) !== "undefined")
            {
                if (json[$(this).attr("name")] !== "")
                {
                    if (!$(this).checked)
                        $(this).trigger('click');
                } else
                {
                    if ($(this).checked)
                        $(this).trigger('click');

                }
            }            
            
            var switchery = new Switchery($(this).get(0), {size: 'small', color: '#26B99A'});
        })
        $("#telegram_note .filter-input").each(function () {
            $(this).val(telegramfilterJson[$(this).attr("name")]);
        });

        $('.autocomplete-append-metric').each(function () {
            var input = $(this);
            var uri = cp + "/getfiltredmetricsnames?all=true&filter=" + encodeURIComponent("^(.*)$");
            $.getJSON(uri, null, function (data) {
                input.autocomplete({
                    lookup: data.data,
                    minChars: 0
                });
            })
        });

        $('.autocomplete-append').each(function () {
            var input = $(this);
            var uri = cp + "/gettagvalue?key=" + input.attr("tagkey") + "&filter=" + encodeURIComponent("^(.*)$");
            $.getJSON(uri, null, function (data) {
                input.autocomplete({
                    lookup: Object.keys(data.data),
                    minChars: 0
                });
            })
        });

        $("#email_note .filter-input").each(function () {
            $(this).val(emailfilterJson[$(this).attr("name")]);
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