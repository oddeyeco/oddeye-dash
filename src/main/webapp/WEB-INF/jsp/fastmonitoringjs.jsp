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
    var array_regular = [];
    var array_spec = [];

    function findeByhash(element, array) {
        for (var i = 0; i < array.length; i++) {
            if (array[i].hash === element.hash) {
                return i;
            }
        }
        return -1;
    }

    function reDrawErrorList(listJson, table, errorjson)
    {
        var elems = document.getElementById("check_level_" + errorjson.level);
        filtred = false;
        if (elems != null)
        {
            if (elems.checked)
            {
                filtred = true;
                filterelems = document.querySelectorAll('.filter-switch');
                for (var i = 0; i < filterelems.length; i++) {
                    if (filterelems[i].checked)
                    {
                        var filter = $("#" + filterelems[i].value + "_input").val();
                        regex = new RegExp(filter, 'i');
                        
                            if (filterelems[i].value == "metric")
                            {
                                filtred = regex.test(errorjson.info.name);
                            } else
                            {                                
                                filtred = regex.test(errorjson.info.tags[filterelems[i].value].value);
                            }                        
                        
                        
                        if (!filtred)
                        {
                            break;
                        }
                    }
                }
                ;
            }
        }
        if (errorjson.isspec == 0)
        {
            var index = findeByhash(errorjson, array_regular);
            if (filtred)
            {
                if (index == -1)
                {
                    array_regular.push(errorjson);
                    array_regular.sort(function (a, b) {
                        return compareStrings(a.info.tags[$("select#ident_tag").val()].value, b.info.tags[$("select#ident_tag").val()].value);
                    });

                    var index2 = findeByhash(errorjson, array_regular);
//                    console.log(errorjson.levelname+" "+index2+" "+array_regular.length);
//                    console.log(errorjson.info.tags.host)
//                    console.log(array_regular[index2 + 1].info.tags.host);
                    if (index2 < array_regular.length - 1)
                    {
                        drawRaw(array_regular[index2], table, array_regular[index2 + 1].hash);
                    } else
                    {
                        drawRaw(array_regular[index2], table);
                    }
                } else
                {
                    array_regular[index] = errorjson;
                    drawRaw(array_regular[index], table, array_regular[index].hash, true);
                }
            } else
            {
                if (index != -1)
                {
                    array_regular[index] = errorjson;
                    table.find("tbody tr#" + errorjson.hash).fadeOut(400, function () {
                        table.find("tbody tr#" + errorjson.hash).remove();
                        array_regular.splice(index, 1);
                    });
                }
            }
        } else
        {
            var index = findeByhash(errorjson, array_spec);
            if (filtred)
            {
//                console.log(errorjson.info.name);
                if (index == -1)
                {
                    array_spec.push(errorjson);
                    array_spec.sort(function (a, b) {
                        return compareStrings(a.info.tags[$("select#ident_tag").val()].value, b.info.tags[$("select#ident_tag").val()].value);
                    });
                    var index2 = findeByhash(errorjson, array_spec);
                    if (index2 < array_spec.length - 1)
                    {
                        drawRaw(array_spec[index2], table, array_spec[index2 + 1].hash);
                    } else
                    {
                        if (array_spec.length == 0)
                        {
                            drawRaw(array_spec[index2], table, 0);
                        } else
                        {
                            drawRaw(array_spec[index2], table, array_spec[array_spec.length - 1].hash);
                        }

                    }
                } else
                {
                    array_spec[index] = errorjson;
                    drawRaw(array_spec[index], table, array_spec[index].hash, true);
                }
            } else
            {
                if (index != -1)
                {
//                    console.log("spec Rem Row" + index);
                    array_spec[index] = errorjson;
                    table.find("tbody tr#" + errorjson.hash).fadeOut(400, function () {
                        table.find("tbody tr#" + errorjson.hash).remove();
                        array_spec.splice(index, 1);
                    });
                }
            }
        }

    }

    function DrawErrorList(listJson, table)
    {
//        console.log(Object.keys(listJson).length);
        $("select").attr('disabled', true);
        table.find("tbody").html("");
        array_regular = [];
        array_spec = [];
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
                            
                            if (filterelems[i].value == "metric")
                            {
                                filtred = regex.test(errorjson.info.name);
                            } else
                            {
                                filtred = regex.test(errorjson.info.tags[filterelems[i].value].value);
                            }

                            if (!filtred)
                            {
                                break;
                            }
                        }
                    }
                    ;
                    if (filtred)
                    {
                        if (errorjson.isspec == 0)
                        {
                            array_regular.push(errorjson);
                        } else
                        {
                            array_spec.push(errorjson);
                        }
                    }
                }
            }

        }

// Now sort it:
        array_regular.sort(function (a, b) {
            return compareStrings(a.info.tags[$("select#ident_tag").val()].value, b.info.tags[$("select#ident_tag").val()].value);
        })


        for (key in array_spec)
        {
            drawRaw(array_spec[key], table);
        }

        for (key in array_regular)
        {
            drawRaw(array_regular[key], table);
        }

        table.find('tbody input.rawflat').iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });
        $("select").attr('disabled', false);


    }

    function drawRaw(errorjson, table, index = null, update = false) {
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
//            console.log(errorjson.isspec);
        if (!update)
        {
            html = "";
            html = html + '<tr id="' + errorjson.hash + '" level="' + errorjson.level + '">';
            if (errorjson.isspec == 0)
            {
                //<input type="checkbox" class="flat" name="table_records">
                html = html + '<td class="icons"><input type="checkbox" class="rawflat" name="table_records"><i class="action fa ' + arrowclass + '" style="color:' + color + '; font-size: 18px;"></i> <a href="${cp}/chart/' + errorjson.hash + '" target="_blank"><i class="fa fa-area-chart" style="font-size: 18px;"></i></a></td>';
            } else
            {
//                console.log(errorjson.isspec+" "+errorjson.info.name);
                html = html + '<td><i class="fa fa-bell" style="color:red; font-size: 18px;"></i></td>';
            }

            html = html + '<td>' + errorjson.info.name + '</td>';

            html = html + '<td>' + errorjson.info.tags[$("select#ident_tag").val()].value + '</td>';
            html = html + '<td class="level">' + errorjson.levelname + '</td>';
            html = html + '<td class="message">' + message + '</td>';
            html = html + '<td class="timech">' + starttime + '</td>';
            html = html + '</tr>'
            if (index == null)
            {
                table.find("tbody").append(html);
            } else
            {
                if (index == 0)
                {
                    table.find("tbody tr").first().before(html)
                } else
                {
                    table.find("tbody tr#" + index).before(html)
                }

            }
            table.find("tbody tr#" + errorjson.hash + " input.rawflat").iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        } else
        {

            table.find("tbody tr#" + index + " .level").html(errorjson.levelname);
            table.find("tbody tr#" + index + " .timech").html(starttime);
            table.find("tbody tr#" + index + " .message").html(message);
            table.find("tbody tr#" + index + " .icons i.action").attr("class", "action fa " + arrowclass);
            table.find("tbody tr#" + index + " .icons i.action").css("color", color);
        }
        ;
    }
    $(document).ready(function () {
        $(".timech").each(function () {
            val = $(this).html();
            time = moment(parseFloat(val));
            $(this).html(time.format(timeformat));
        });

        $('.autocomplete-append-metric').each(function () {
            var input = $(this);
            console.log(input.attr("id"));
//            input.autocomplete({
//                lookup: ["sssss", "wwwww", "sssswwws"],
//                appendTo: '.autocomplete-container-metric'
//            });
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
            elems[i].onchange = function () {
                DrawErrorList(errorlistJson, $(".metrictable"));
            };
        }
        $("body").on("blur", ".filter-input", function () {
            DrawErrorList(errorlistJson, $(".metrictable"))
        })
        $(".filter-input").each(function () {
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
                if (errorjson.level == -1)
                {
//                   console.log(errorlistJson[errorjson.hash]);
                    delete errorlistJson[errorjson.hash];
//                   console.log(errorlistJson[errorjson.hash]);
                } else
                {
                    errorlistJson[errorjson.hash] = errorjson;
                }
                reDrawErrorList(errorlistJson, $(".metrictable"), errorjson);

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

// Bulk Actions

        $('body').on("click", "#Clear_reg", function () {

            $(".bulk_action tbody input[name='table_records']:checked").each(function () {

                var sendData = {};
                sendData.hash = $(this).parents("tr").attr("id");
                var header = $("meta[name='_csrf_header']").attr("content");
                var token = $("meta[name='_csrf']").attr("content");
                url = cp + "/resetregression";
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
                        console.log("Message Sended ");
                    } else
                    {
                        console.log("Request failed");
                    }
                }).fail(function (jqXHR, textStatus) {
                    console.log("Request failed");
                });
            });

        });
        $('body').on("click", "#Show_chart", function () {
            hashes = "";
            if ($(".bulk_action tbody input[name='table_records']:checked").length == 1)
            {
                hashes = "/" + $(".bulk_action tbody input[name='table_records']:checked").first().parents("tr").attr("id")
            } else
            {
                hashes = "?hashes="
                $(".bulk_action tbody input[name='table_records']:checked").each(function () {
                    hashes = hashes + $(this).parents("tr").attr("id") + ";";
                })
            }
            var win = window.open(cp + "/chart" + hashes, '_blank');
            win.focus();
        });


    });
</script>    
