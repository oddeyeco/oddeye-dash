<script src="${cp}/assets/js/socket/dist/sockjs-1.1.1.js"></script>    
<script src="${cp}/assets/js/socket/stomp.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>
<script src="${cp}/resources/devbridge-autocomplete/dist/jquery.autocomplete.min.js"></script>

<script>
    var stompClient = null;
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var uuid = "${curentuser.getId()}";
    var timeformat = "DD/MM HH:mm:ss";
    var errorlistJson = ${errorslist};
    var filterJson = ${curentuser.getDefaultFilter()};
    var cp = "${cp}";

    function compareStrings(a, b) {
        // Assuming you want case-insensitive comparison
        a = a.toLowerCase();
        b = b.toLowerCase();
        return (a < b) ? -1 : (a > b) ? 1 : 0;
    }

    function DrawErrorList(listJson, table, level)
    {
//        console.log(Object.keys(listJson).length);
        $("select").attr('disabled', true);
        table.find("tbody").html("");

        var sort_array = [];
        for (var key in listJson) {
            var errorjson = listJson[key];
            var elems = document.getElementById("check_level_" + errorjson.level);
            filtred = true;
            if (elems != null)
            {
                if (elems.checked)
                {
                    filterelems = document.querySelectorAll('.filter-switch');
                    for (var i = 0; i < filterelems.length; i++) {
                        if (filterelems[i].checked)
                        {
                            var filter = $("#" + filterelems[i].value + "_input").val();
                            regex = new RegExp(filter, 'i');
                            filtred = regex.test(errorjson.info.tags[filterelems[i].value].value);
                            if (!filtred)
                            {
                                break;
                            }
                        }
                    }
                    ;
                    if (filtred)
                    {
                        sort_array.push(errorjson);
                    }
                }
            }

        }

// Now sort it:
        sort_array.sort(function (a, b) {
            return compareStrings(a.info.tags[$("select#ident_tag").val()].value, b.info.tags[$("select#ident_tag").val()].value);
        })


        for (key in sort_array)
        {
            var errorjson = sort_array[key];
//            console.log(errorjson);
            var message = "";
            if (typeof (errorjson.message) != "undefined")
            {
                message = errorjson.message;
            }
            var starttime = "";
            if (typeof (errorjson.time) != "undefined")
            {
                starttime = moment(errorjson.time * 1).format(timeformat);
            }


            var arrowclass = "fa-arrow-up";
            var color = "red";
            if (errorjson.action == 2)
            {
                arrowclass = "fa-arrow-down";
                color = "green";
            }
            table.find("tbody").append('<tr id="' + errorjson.hash + '" level="' + errorjson.level + '">' +
                    '<td><i class="fa ' + arrowclass + '" style="color:' + color + '"></i> <a href="${cp}/chart/' + errorjson.hash + '">' + errorjson.info.name + '</a></td>' +
                    '<td>' + errorjson.info.tags[$("select#ident_tag").val()].value + '</td>' +
                    '<td class="level">' + errorjson.levelname + '</td>' +
                    '<td class="message">' + message + '</td>' +
                    '<td class="timech">' + starttime + '</td>' +
                    '</tr>');
        }
        $("select").attr('disabled', false);
    }

    $(document).ready(function () {
        $(".timech").each(function () {
            val = $(this).html();
            time = moment(parseFloat(val));
            $(this).html(time.format(timeformat));
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
        var elems = document.querySelectorAll('.js-switch-small');

        for (var i = 0; i < elems.length; i++) {
            if (typeof (filterJson[elems[i].id]) != "undefined")
                if (filterJson[elems[i].id] != "")
                {
                    $(elems[i]).trigger('click');
                }
            var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
            elems[i].onchange = function () {
                DrawErrorList(errorlistJson, $(".metrictable"));
            };
        }
        
        $(".filter-input").each(function (){
            $(this).val(filterJson[$(this).attr("name")]);
//            console.log($(this).attr("name"));
        });
        
//        console.log(filterJson);

        DrawErrorList(errorlistJson, $(".metrictable"));

        var socket = new SockJS('${cp}/subscribe');
        stompClient = Stomp.over(socket);
        stompClient.debug = null;
        var headers = {};
        headers[headerName] = token;
        stompClient.connect(headers, function (frame) {
            stompClient.subscribe('/user/' + uuid + '/errors', function (error) {
                var errorjson = JSON.parse(error.body);
                errorlistJson[errorjson.hash] = errorjson;
                DrawErrorList(errorlistJson, $(".metrictable"));
//                console.log(errorjson);

            });
        });



        $('body').on("change", "#ident_tag", function () {
            DrawErrorList(errorlistJson, $(".metrictable"));
        });


        $('body').on("click", "#Default", function () {
//            console.log("valod");
            var formData = $("form.form-filter").serializeArray();
            filterJson = {};
            jQuery.each(formData, function (i, field) {
                if (field.value != "")
                {
                    filterJson[field.name] = field.value;
                }

            });
            var sendData = {};
            sendData.filter = JSON.stringify(filterJson);
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            url = cp + "/savefilter";
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
