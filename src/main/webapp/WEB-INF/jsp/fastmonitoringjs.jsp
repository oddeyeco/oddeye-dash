<script src="${cp}/assets/js/socket/dist/sockjs-1.1.1.js"></script>    
<script src="${cp}/assets/js/socket/stomp.js"></script>

<script>
    var stompClient = null;
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var uuid = "${curentuser.getId()}";
    var timeformat = "DD/MM HH:mm:ss";

    $(document).ready(function () {
        $(".timech").each(function () {
            val = $(this).html();
            time = moment(parseFloat(val));
            $(this).html(time.format(timeformat));
        });

        $(".metrictable tbody tr").each(function () {
            if ($(this).attr("level") < $("select#level").val())
            {
                $(this).fadeOut();
            } else
            {
                $(this).fadeIn();
            }
        });


        var socket = new SockJS('${cp}/subscribe');
        stompClient = Stomp.over(socket);
        stompClient.debug = null;
        var headers = {};
        headers[headerName] = token;
        stompClient.connect(headers, function (frame) {
//            console.log('Connected: ' + frame);
            stompClient.subscribe('/user/' + uuid + '/errors', function (error) {
                var errorjson = JSON.parse(error.body);
//                console.log(errorjson);
//                console.log($("select#level").val());
                var message = "";
                if (typeof (errorjson.message) != "undefined")
                    message = errorjson.message;
                if ($(".metrictable tbody tr#" + errorjson.hash).length == 0)
                {
                    var display = "none";
                    if (errorjson.level >= $("select#level").val())
                    {
                        var display = "table-row";
                    }
                    $(".metrictable tbody").append('<tr style="display: ' + display + ';" id="' + errorjson.hash + '" level="' + errorjson.level + '">' +
//                                '<th scope="row" >' + errorjson.hash + '</th>' +
                            '<td><a href="${cp}/chart/'+errorjson.hash+'">' + errorjson.info.name + '</a></td>' +
                            '<td>' + errorjson.info.tags[$("select#ident_tag").val()].value + '</td>' +
//                                '<td class="action">'+errorjson.action+'</td>' +
                            '<td class="level">' + errorjson.levelname + '</td>' +
                            '<td class="message">' + message + '</td>' +
                            '<td class="timest">' + moment(errorjson.starttimes[$("select#level").val()]).format(timeformat) + '</td>' +
                            '<td class="timech">' + moment(errorjson.starttimes[errorjson.level]).format(timeformat) + '</td>' +
                            '</tr>');

                } else
                {
                    if (errorjson.action == -1)
                    {
                        $(".metrictable tbody tr#" + errorjson.hash).remove();
                    }
                    if (errorjson.level < $("select#level").val())
                    {
                        $(".metrictable tbody tr#" + errorjson.hash).fadeOut();
                    }
                    else
                    {
                        $(".metrictable tbody tr#" + errorjson.hash).fadeIn();
                    }

                    $(".metrictable tbody tr#" + errorjson.hash).attr("level", errorjson.level);
                    $(".metrictable tbody tr#" + errorjson.hash + " td.level").html(errorjson.levelname);
                    $(".metrictable tbody tr#" + errorjson.hash + " td.action").html(errorjson.action);
                    $(".metrictable tbody tr#" + errorjson.hash + " td.timest").html(moment(errorjson.starttimes[$("select#level").val()]).format(timeformat));
                    $(".metrictable tbody tr#" + errorjson.hash + " td.timech").html(moment(errorjson.starttimes[errorjson.level]).format(timeformat));
                }
                //                    showGreeting(JSON.parse(greeting.body).content);
            });
        });

        $('body').on("change", "#level", function () {
            $(".metrictable tbody tr").each(function () {
                if ($(this).attr("level") < $("select#level").val())
                {
                    $(this).fadeOut();
                } else
                {
                    $(this).fadeIn();
                }
            });
        });
    });


</script>    
