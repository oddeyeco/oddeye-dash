<script src="${cp}/resources/select2/dist/js/select2.full.min.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>
<script src="${cp}/resources/devbridge-autocomplete/dist/jquery.autocomplete.min.js"></script>

<script>
    var filterJson = ${curentuser.getDefaultFilter()};

    $(document).ready(function () {
        $(".select2_country").select2({
            placeholder: "Select a Country",
            allowClear: true
        });
        $(".select2_tz").select2({});

        var elems = document.querySelectorAll('.js-switch-small');

        for (var i = 0; i < elems.length; i++) {
            if (typeof (filterJson[elems[i].id]) != "undefined")
                if (filterJson[elems[i].id] != "")
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
        $(".filter-input").each(function () {
            $(this).val(filterJson[$(this).attr("name")]);

        });

    });
</script>