<script src="${cp}/assets/js/socket/dist/sockjs-1.1.1.js"></script>    
<script src="${cp}/assets/js/socket/stomp.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>


<script>
    var stompClient = null;
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var uuid = "${curentuser.getId()}";
    var timeformat = "DD/MM HH:mm:ss";
    var errorlistJson = ${errorslist};

//    var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch-small'));
//
//    elems.forEach(function (html) {
//        var switchery = new Switchery(html, {size: 'small', color: '#26B99A'});
//        switchery.onchange = function () {
//            alert(changeCheckbox.checked);
//        };
//    });

    var elems = document.querySelectorAll('.js-switch-small');

    for (var i = 0; i < elems.length; i++) {
        var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        elems[i].onchange = function () {
            DrawErrorList(errorlistJson, $(".metrictable"));
        };
    }

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
            if (elems != null)
            {
                if (elems.checked)
                {
                    sort_array.push(errorjson);
                }
            }

        }

// Now sort it:
        sort_array.sort(function (a, b) {
            return compareStrings(a.info.name, b.info.name);
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
            if (typeof (errorjson.starttimes) != "undefined")
            {
//                console.log(errorjson.starttimes);
//                starttime = moment(errorjson.starttimes[errorjson.level] * 1).format(timeformat);
                    starttime = moment(errorjson.time * 1).format(timeformat);
            }

//            console.log(starttime);
            var arrowclass="fa-arrow-up"; 
            var color = "red";
            if (errorjson.action == 2)
            {
                arrowclass="fa-arrow-down"; 
                color = "green";
            }
            table.find("tbody").append('<tr id="' + errorjson.hash + '" level="' + errorjson.level + '">' +
//                                '<th scope="row" >' + errorjson.hash + '</th>' +
                    '<td><i class="fa '+arrowclass+'" style="color:'+color+'"></i> <a href="${cp}/chart/' + errorjson.hash + '">' + errorjson.info.name + '</a></td>' +
                    '<td>' + errorjson.info.tags[$("select#ident_tag").val()].value + '</td>' +
//                                '<td class="action">'+errorjson.action+'</td>' +
                    '<td class="level">' + errorjson.levelname + '</td>' +
                    '<td class="message">' + message + '</td>' +
                    '<td class="timech">' + starttime +'</td>' +                    
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

//        errorlistJson.sort(function (a, b) {
//            return compareStrings(a.name, b.name);
//        })

//        console.log(sort_array);
// Now process that object with it:
//        errorlistJson = {};
//        for (var i = 0; i < sort_array.length; i++) {
//            errorlistJson[sort_array[i].key] = sort_array[i].item;
//            console.log(sort_array[i].item.info.name);
//        }

        DrawErrorList(errorlistJson, $(".metrictable"));

//        $(".metrictable tbody tr").each(function () {
//            if ($(this).attr("level") < $("select#level").val())
//            {
//                $(this).fadeOut();
//            } else
//            {
//                $(this).fadeIn();
//            }
//        });


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

//                var message = "";
//                if (typeof (errorjson.message) != "undefined")
//                    message = errorjson.message;
//                if ($(".metrictable tbody tr#" + errorjson.hash).length == 0)
//                {
//                    var display = "none";
//                    if (errorjson.level >= $("select#level").val())
//                    {
//                        var display = "table-row";
//                    }
//                    $(".metrictable tbody").append('<tr style="display: ' + display + ';" id="' + errorjson.hash + '" level="' + errorjson.level + '">' +
////                                '<th scope="row" >' + errorjson.hash + '</th>' +
//                            '<td><a href="${cp}/chart/'+errorjson.hash+'">' + errorjson.info.name + '</a></td>' +
//                            '<td>' + errorjson.info.tags[$("select#ident_tag").val()].value + '</td>' +
////                                '<td class="action">'+errorjson.action+'</td>' +
//                            '<td class="level">' + errorjson.levelname + '</td>' +
//                            '<td class="message">' + message + '</td>' +
//                            '<td class="timest">' + moment(errorjson.starttimes[$("select#level").val()]).format(timeformat) + '</td>' +
//                            '<td class="timech">' + moment(errorjson.starttimes[errorjson.level]).format(timeformat) + '</td>' +
//                            '</tr>');
//
//                } else
//                {
//                    if (errorjson.action == -1)
//                    {
//                        $(".metrictable tbody tr#" + errorjson.hash).remove();
//                    }
//                    if (errorjson.level < $("select#level").val())
//                    {
//                        $(".metrictable tbody tr#" + errorjson.hash).fadeOut();
//                    }
//                    else
//                    {
//                        $(".metrictable tbody tr#" + errorjson.hash).fadeIn();
//                    }
//
//                    $(".metrictable tbody tr#" + errorjson.hash).attr("level", errorjson.level);
//                    $(".metrictable tbody tr#" + errorjson.hash + " td.level").html(errorjson.levelname);
//                    $(".metrictable tbody tr#" + errorjson.hash + " td.action").html(errorjson.action);
//                    $(".metrictable tbody tr#" + errorjson.hash + " td.timest").html(moment(errorjson.starttimes[$("select#level").val()]).format(timeformat));
//                    $(".metrictable tbody tr#" + errorjson.hash + " td.timech").html(moment(errorjson.starttimes[errorjson.level]).format(timeformat));
//                }
//                
            });
        });



        $('body').on("change", "#ident_tag", function () {
//            $("#ident_tag_head").html($("select#ident_tag").val());
            DrawErrorList(errorlistJson, $(".metrictable"));
        });

//        $('body').on("change", ".js-switch-small", function () {
//            alert($(this).attr("checked"))
////            DrawErrorList(errorlistJson, $(".metrictable"));
//        });
    });


</script>    
