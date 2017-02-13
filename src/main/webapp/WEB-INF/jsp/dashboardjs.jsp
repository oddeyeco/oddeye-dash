<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="${cp}/resources/echarts/dist/echarts.min.js"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script src="${cp}/resources/js/dash.js"></script>
<script src="${cp}/resources/js/editchartform.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>
<script src="${cp}/resources/numbersjs/src/numbers.min.js"></script>


<script>
    var dashJSONvar = ${dashInfo};
    var chartForm;

    $("#addrow").on("click", function () {
        dashJSONvar[Object.keys(dashJSONvar).length] = {widgets: {}};
        redrawAllJSON(dashJSONvar);
    });

    $('body').on("click", ".deleterow", function () {
        var rowindex = $(this).parents(".widgetraw").first().attr("index");
        delete dashJSONvar[rowindex];
        redrawAllJSON(dashJSONvar);
    });

    $('body').on("click", ".minus", function () {
        var rowindex = $(this).parents(".widgetraw").first().attr("index");
        var widgetindex = $(this).parents(".chartsection").first().attr("index");
        if (dashJSONvar[rowindex]["widgets"][widgetindex].size > 1)
        {
            dashJSONvar[rowindex]["widgets"][widgetindex].size = dashJSONvar[rowindex]["widgets"][widgetindex].size - 1;
        }
        redrawAllJSON(dashJSONvar);
    });

    $('body').on("click", ".plus", function () {

        var rowindex = $(this).parents(".widgetraw").first().attr("index");
        var widgetindex = $(this).parents(".chartsection").first().attr("index");
        if (dashJSONvar[rowindex]["widgets"][widgetindex].size < 12)
        {
            dashJSONvar[rowindex]["widgets"][widgetindex].size = dashJSONvar[rowindex]["widgets"][widgetindex].size + 1;
        }
        redrawAllJSON(dashJSONvar);
    });

    $('body').on("click", ".deletewidget", function () {
        var rowindex = $(this).parents(".widgetraw").first().attr("index");
        var widgetindex = $(this).parents(".chartsection").first().attr("index");
        delete dashJSONvar[rowindex]["widgets"][widgetindex];
        itemcount = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
        if (itemcount < 4)
        {
            size = Math.round(12 / itemcount);
        } else
        {
            size = 3;
        }

        for (key in dashJSONvar[rowindex]["widgets"])
        {
            dashJSONvar[rowindex]["widgets"][key].size = size;
        }
        redrawAllJSON(dashJSONvar);
    });

    $('body').on("click", ".dublicate", function () {

        var rowindex = $(this).parents(".widgetraw").first().attr("index");
        var curentwidgetindex = $(this).parents(".chartsection").first().attr("index");
        var widgetindex = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
//        dashJSONvar[rowindex]["widgets"][curentwidgetindex].tmpoptions = dashJSONvar[rowindex]["widgets"][curentwidgetindex].echartLine.getOption();
        delete  dashJSONvar[rowindex]["widgets"][curentwidgetindex].echartLine;
        dashJSONvar[rowindex]["widgets"][widgetindex] = clone_obg(dashJSONvar[rowindex]["widgets"][curentwidgetindex]);

//        console.log(dashJSONvar);
        redrawAllJSON(dashJSONvar);
    });

    $('body').on("click", ".addchart", function () {
        var rowindex = $(this).parents(".widgetraw").first().attr("index");
        var widgetindex = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
        dashJSONvar[rowindex]["widgets"][widgetindex] = {type: "linechart"};
        //        $(this).parents(".x_content").first().find(".rowcontent").append($("#charttemplate").html());

        itemcount = Object.keys(dashJSONvar[rowindex]["widgets"]).length;
        if (itemcount < 4)
        {
            size = Math.round(12 / itemcount);
        } else
        {
            size = 3;
        }

        for (key in dashJSONvar[rowindex]["widgets"])
        {
            dashJSONvar[rowindex]["widgets"][key].size = size;
        }
        redrawAllJSON(dashJSONvar);

    });

    $('body').on("click", ".deletedash", function () {
        url = "${cp}/dashboard/delete";
        senddata = {};
        senddata.name = $("#name").val();
        var header = $("meta[name='_csrf_header']").attr("content");
        var token = $("meta[name='_csrf']").attr("content");
        $.ajax({
            url: url,
            data: senddata,
            dataType: 'json',
            type: 'POST',
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);
            },
            success: function (data) {
                if (data.sucsses)
                {
                    window.location = "${cp}/profile";
                }
                ;
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status + ": " + thrownError);
            }
        });

    });

    $('body').on("click", ".savedash", function () {
        url = "${cp}/dashboard/save";
        to_senddata = {};
        senddata = {};
        if (Object.keys(dashJSONvar).length > 0)
        {
            for (rowindex in dashJSONvar)
            {
                for (widgetindex in dashJSONvar[rowindex]["widgets"])
                {
//                    dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions = dashJSONvar[rowindex]["widgets"][widgetindex].echartLine.getOption();
                    delete dashJSONvar[rowindex]["widgets"][widgetindex].echartLine;
                    for (var k in dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions.series) {
                        dashJSONvar[rowindex]["widgets"][widgetindex].tmpoptions.series[k].data = [];
                    }
                }
            }

            senddata.info = JSON.stringify(dashJSONvar);
            senddata.name = $("#name").val();
//            console.log(senddata);
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            $.ajax({
                url: url,
                data: senddata,
                dataType: 'json',
                type: 'POST',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(header, token);
                },
                success: function (data) {
                    if (data.sucsses)
                    {
                        window.location = "${cp}/dashboard/" + senddata.name;
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status + ": " + thrownError);
                }
            });
        }
    });

    var single_rowindex = 0;
    var single_widgetindex = 0;

    $('body').on("click", ".editchart", function () {
        single_rowindex = $(this).parents(".widgetraw").first().attr("index");
        single_widgetindex = $(this).parents(".chartsection").first().attr("index");
        window.history.pushState({}, "", "?widget=" + single_widgetindex + "&row=" + single_rowindex + "&action=edit");
        showsingleChart(single_rowindex, single_widgetindex, dashJSONvar);
        if ($('#axes_mode_x').val() === 'category') {
            $('.only-Series').show();
        } else {
            $('.only-Series').hide();
        }
        $(".editchartpanel select").select2({minimumResultsForSearch: 15});
        $(".select2_group").select2({dropdownCssClass: "menu-select"});
        
    });

    $('body').on("click", ".view", function () {
        single_rowindex = $(this).parents(".widgetraw").first().attr("index");
        single_widgetindex = $(this).parents(".chartsection").first().attr("index");
        window.history.pushState({}, "", "?widget=" + single_widgetindex + "&row=" + single_rowindex + "&action=view");
        showsingleChart(single_rowindex, single_widgetindex, dashJSONvar, true);
    });

    $('body').on("click", ".backtodush", function () {
        $(".editchartpanel").hide();
        $(".fulldash").show();
        window.history.pushState({}, "", window.location.pathname);
        redrawAllJSON(dashJSONvar);
    });

    $('body').on("blur", ".edit-form input", function () {
        chartForm.chage($(this));
    })

    $('body').on("change", ".edit-form select", function () {
        chartForm.chage($(this));
    })

    $('body').on("change", ".edit-form select#axes_mode_x", function () {
        if ($(this).val() === 'category') {
            $('.only-Series').fadeIn();
        } else {
            $('.only-Series').fadeOut();

        }
    })


    $(document).ready(function () {
        $('#reportrange span').html("Last 5 minutes");
        $('#reportrange').daterangepicker(PicerOptionSet1, cb);

        var elems = document.querySelectorAll('.js-switch-small');

        for (var i = 0; i < elems.length; i++) {
            var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
            elems[i].onchange = function () {
                if (chartForm != null)
                {
                    chartForm.chage($(this));
                }
            };
        }

        $('.cl_picer_input').colorpicker().on('hidePicker', function () {
            chartForm.chage($(this).find("input"));
        });
        $('.cl_picer_noinput').colorpicker({format: 'rgba'}).on('hidePicker', function () {
//            $('#colordiv').css('background-color', $('.color').colorpicker('getValue'));
            chartForm.chage($(this).find("input"));
        });


        $('#button_title_subtitle').on('click', function () {
            $('#title_subtitle').fadeToggle(500, function () {
                if ($('#title_subtitle').css('display') == 'block')
                {
                    $('#button_title_subtitle').removeClass("fa-chevron-circle-down");
                    $('#button_title_subtitle').addClass("fa-chevron-circle-up");
                } else
                {
                    $('#button_title_subtitle').removeClass("fa-chevron-circle-up");
                    $('#button_title_subtitle').addClass("fa-chevron-circle-down");

                }
            });


        })

        $('#button_title_description').on('click', function () {
            $('#title_subdescription').fadeToggle(500, function () {
                if ($('#title_subdescription').css('display') == 'block')
                {
                    $('#button_title_description').removeClass("fa-chevron-circle-down");
                    $('#button_title_description').addClass("fa-chevron-circle-up");
                } else
                {
                    $('#button_title_description').removeClass("fa-chevron-circle-up");
                    $('#button_title_description').addClass("fa-chevron-circle-down");

                }
            });


        })

        $('#button_title_position').on('click', function () {
            $('#position_block').fadeToggle(500, function () {
                if ($('#position_block').css('display') == 'block')
                {
                    $('#button_title_position i').removeClass("fa-chevron-circle-down");
                    $('#button_title_position i').addClass("fa-chevron-circle-up");
                } else
                {
                    $('#button_title_position i').removeClass("fa-chevron-circle-up");
                    $('#button_title_position i').addClass("fa-chevron-circle-down");

                }
            });


        })

        $('#button_title_color').on('click', function () {
            $('#color_block').fadeToggle(500, function () {
                if ($('#color_block').css('display') == 'block')
                {
                    $('#button_title_color i').removeClass("fa-chevron-circle-down");
                    $('#button_title_color i').addClass("fa-chevron-circle-up");
                } else
                {
                    $('#button_title_color i').removeClass("fa-chevron-circle-up");
                    $('#button_title_color i').addClass("fa-chevron-circle-down");

                }
            });


        })

        $('#button_title_border').on('click', function () {
            $('#border_block').fadeToggle(500, function () {
                if ($('#border_block').css('display') == 'block')
                {
                    $('#button_title_border i').removeClass("fa-chevron-circle-down");
                    $('#button_title_border i').addClass("fa-chevron-circle-up");
                } else
                {
                    $('#button_title_border i').removeClass("fa-chevron-circle-up");
                    $('#button_title_border i').addClass("fa-chevron-circle-down");

                }
            });


        })




        var request_W_index = getParameterByName("widget");
        var request_R_index = getParameterByName("row");

        if ((request_W_index == null) && (request_R_index == null))
        {
            window.history.pushState({}, "", window.location.pathname);
            redrawAllJSON(dashJSONvar);
        } else
        {
            var NoOpt = false;
            if (typeof (dashJSONvar[request_R_index]) === "undefined")
            {
                NoOpt = true;
            }

            if (!NoOpt)
            {
                if (typeof (dashJSONvar[request_R_index]["widgets"][request_W_index]) === "undefined")
                {
                    NoOpt = true;
                }
            }

            if (NoOpt)
            {
                window.history.pushState({}, "", window.location.pathname);
                redrawAllJSON(dashJSONvar);
            } else
            {
                var action = getParameterByName("action");
                showsingleChart(request_R_index, request_W_index, dashJSONvar, action !== "edit");
                if ($('#axes_mode_x').val() === 'category') {
                    $('.only-Series').show();
                } else {
                    $('.only-Series').hide();
                }
                
                $(".editchartpanel select").select2({minimumResultsForSearch: 15});
                $(".select2_group").select2({dropdownCssClass: "menu-select"});
                


//                showsingleChart(request_R_index, request_W_index, dashJSONvar);
            }
        }
        ;

    })
</script>