<%-- 
    Document   : testjs
    Created on : Apr 26, 2017, 12:06:56 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/echarts/dist/echarts.min.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>

<script>
    var echartLine;
    var metric_input = '${metric_input}';
    $(document).ready(function () {
        $('body').on("click", "#Save", function () {
            var formData = $("form.form-filter").serializeArray();
            filterJson = {};
            jQuery.each(formData, function (i, field) {
                if (field.value !== "")
                {
                    filterJson[field.name] = field.value;
                }
            });
            var sendData = {};
            sendData.filter = JSON.stringify(filterJson);
            var header = $("meta[name='_csrf_header']").attr("content");
            var token = $("meta[name='_csrf']").attr("content");
            url = cp + "/savefilter/oddeye_base_infrastructure";
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


        var draging = false;
        $("#tagsconteger").sortable({
            cursor: "move"
        });

        $('.autocomplete-append-metric').each(function () {
            var input = $(this);
            var uri = cp + "/getfiltredmetricsnames?filter=" + encodeURIComponent("^(.*)$");
            input.autocomplete();

            $.getJSON(uri, null, function (data) {
                input.autocomplete({
                    lookup: data.data,
                    appendTo: '.autocomplete-container-metric'
                });
                if (metric_input === '')
                {
                    input.val(data.data[0]);
                } else
                {
                    input.val(metric_input);
                }

                drawstructure();

            });
        });
        $('.autocomplete-append').each(function () {
            var input = $(this);
            var uri = cp + "/gettagvalue?key=" + input.attr("tagkey") + "&filter=" + encodeURIComponent("^(.*)$");
            $.getJSON(uri, null, function (data) {
                input.autocomplete({
                    lookup: data.data,
                    appendTo: '.autocomplete-container_' + input.attr("tagkey")
                });
            });
        });


        var elems = document.querySelectorAll('.js-switch-small');
        for (var i = 0; i < elems.length; i++) {
            var switchery = new Switchery(elems[i], {size: 'small', color: '#26B99A'});
        }

        $("body").on("click", "#Show", function () {
            drawstructure();
        });

    });

    function drawstructure() {
        var tags = "";
        var tagstree = [];
        $('.tag-grop').each(function () {
            if ($(this).find("input.filter-switch").prop('checked'))
            {
                var val = "*";
                if ($(this).find("input.filter-input").val() !== "")
                {
                    val = $(this).find("input.filter-input").val();
                }
                tags = tags + $(this).find("input.filter-input").attr('tagkey') + "=" + val + ";";
                tagstree.push($(this).find("input.filter-input").attr('tagkey'));
            }
        });

        var url = cp + "/getdata?metrics=" + $("#metric_input").val() + ";&tags=" + tags + ";&aggregator=none&downsample=&startdate=5m-ago&enddate=now";
        $.getJSON(url, null, function (data) {
            var categories = [];
            var categoriesch = [];
            var datach = [];
            var datanames = [];
            var links = [];
            var x = 0;
            var y = 0;

            var values = Object.values(data.chartsdata);

            values.sort(function (a, b) {

                return (a.tags[0] > b.tags[0]) ? 1 : ((a.tags[0] < b.tags[0]) ? -1 : 0);

//                    return (b[prop] > a[prop]) ? 1 : ((b[prop] < a[prop]) ? -1 : 0);

            });

            for (var dataindex in values)
            {
                x++;
                for (var tagindexindex in values[dataindex].tags)
                {
                    var size;
                    var symbol;
                    var name = false;

                    var index = tagstree.indexOf(tagindexindex);
                    if (index !== -1)
                    {
                        name = tagindexindex + "~" + values[dataindex].tags[tagindexindex];
                        size = imgsizes[tagindexindex];
                        symbol = img[tagindexindex];
                        links.push({"source": tagstree[index - 1] + '~' + values[dataindex].tags[tagstree[index - 1]], "target": name});
                    }
                    if (name === false)
                    {
                        continue;
                    }

                    if (categories.indexOf(tagindexindex) === -1)
                    {
                        categories.push(tagindexindex);
                        categoriesch.push({name: tagindexindex});
                    }

                    var val;
                    for (var ind in values[dataindex].data) {
                        val = values[dataindex].data[ind][1];
                    }
                    if (datanames.indexOf(name) === -1)
                    {
                        datanames.push(name);
                        datach.push({
                            "x": x * 20,
                            "y": index * 500,
                            "name": name,
                            "symbolSize": size,
                            "category": tagindexindex,
                            "symbol": symbol,                            
                            "draggable": true

                        });
                    }
                }

            }
            datach.sort(function (a, b) {
                return compareStrings(a.category, b.category);
            });
            $("#echart_line").css('height', '800px');
            echartLine = echarts.init(document.getElementById("echart_line"), 'oddeyelight');

            var option = {
                tooltip: {},
                toolbox: {
                    feature: {
                        magicType: {show: false},
                        saveAsImage: {
                            show: true
                        }
                    }
                },
                legend: [{
                        selectedMode: 'false',
                        top: 20,
                        left: 20,
                        data: categories
                    }],
                grid: {
                    x: 0,
                    x2: 0,
                    y: 0,
                    y2: 0
                },
                animation: false,
                series: [
                    {
//                        color: [ '#ffb980', '#d87a80', '#b6a2de', '#8d98b3'],                        
                        name: 'Infrastructure',
                        type: 'graph',
                        layout: 'force',
                        force: {
                            initLayout: 'none',
                            repulsion: 2000,
                            gravity: 0.2
                        },
                        data: datach,
                        links: links,
                        categories: categoriesch,
                        focusNodeAdjacency: true,
                        roam: true,
                        label: {
                            normal: {
//                                show: true,
                                position: 'top',
                                formatter: function (param)
                                {
                                    var arr = param.name.split("~");
                                    return arr[arr.length - 1];
                                }
                            }
                        },
                        lineStyle: {
                            normal: {
                                type: "solid"
                            }
                        }
                    }


                ]};
            echartLine.setOption(option);
        });
    }
    ;


    var img = {
        cluster: "path://M201.443,419.32c0,0.193,0.159,0.353,0.353,0.353h108.41l0.353-58.402l-108.762-0.353L201.443,419.32z M159.48,50.713L50.709,50.361l-0.344,58.402c0,0.193,0.151,0.353,0.344,0.353h108.418L159.48,50.713z M453.25,50.713l-108.771-0.352l-0.344,58.402c0,0.193,0.151,0.353,0.344,0.353h108.418L453.25,50.713z M442.737,193.049c10.425,0,18.902-8.477,18.902-18.902v-14.672h19.951c12.137,0,22.016-9.879,22.016-22.016V22.016C503.607,9.879,493.727,0,481.591,0H315.786c-12.137,0-22.016,9.879-22.016,22.016v115.443c0,12.137,9.879,22.016,22.016,22.016h28.345v14.672c0,10.425,8.477,18.902,18.902,18.902h31.459v26.372c-11.742,3.055-20.933,12.246-23.989,23.988h-86.318c-3.752-14.445-16.787-25.18-32.382-25.18s-28.63,10.735-32.382,25.18h-86.318c-3.055-11.742-12.246-20.933-23.988-23.988v-26.372h31.459c10.425,0,18.902-8.477,18.902-18.902v-14.672h28.345c12.137,0,22.016-9.879,22.016-22.016V22.016C209.836,9.879,199.957,0,187.82,0H22.016C9.879,0,0,9.879,0,22.016v115.443c0,12.137,9.879,22.016,22.016,22.016h19.951v14.672c0,10.425,8.477,18.902,18.902,18.902h31.459v26.372c-11.742,3.055-20.933,12.246-23.988,23.988H8.393C3.76,243.41,0,247.162,0,251.803c0,4.642,3.76,8.393,8.393,8.393h59.946c3.752,14.437,16.787,25.18,32.382,25.18s28.63-10.744,32.382-25.18h86.318c3.055,11.742,12.246,20.933,23.988,23.988v26.372h-70.312c-12.137,0-22.016,9.879-22.016,22.016v115.443c0,12.137,9.879,22.016,22.016,22.016h19.951v14.672c0,10.425,8.477,18.902,18.902,18.902h79.704c10.425,0,18.902-8.477,18.902-18.902v-14.672h28.345c12.137,0,22.016-9.879,22.016-22.016V332.573c0-12.137-9.879-22.016-22.016-22.016h-78.705v-26.372c11.742-3.055,20.933-12.246,23.988-23.988h86.318c3.752,14.437,16.787,25.18,32.382,25.18s28.63-10.744,32.382-25.18h59.946c4.633,0,8.393-3.752,8.393-8.393c0-4.642-3.76-8.393-8.393-8.393h-59.946c-3.055-11.742-12.246-20.933-23.988-23.988v-26.372H442.737z M33.574,108.762V50.713c0-9.451,7.688-17.139,17.139-17.139h108.41c9.451,0,17.139,7.688,17.139,17.139v58.049c0,9.451-7.688,17.139-17.139,17.139H50.713C41.262,125.902,33.574,118.213,33.574,108.762z M60.869,176.262c-1.167,0-2.115-0.948-2.115-2.115v-14.672h83.934v14.672c0,1.167-0.948,2.115-2.115,2.115H60.869z M293.771,484.704c0,1.167-0.948,2.115-2.115,2.115h-79.704c-1.167,0-2.115-0.948-2.115-2.115v-14.672h83.934V484.704z M310.205,344.131c9.451,0,17.139,7.688,17.139,17.139v58.049c0,9.451-7.688,17.139-17.139,17.139h-108.41c-9.451,0-17.139-7.688-17.139-17.139v-58.049c0-9.451,7.688-17.139,17.139-17.139H310.205z M344.484,125.902c-9.451,0-17.139-7.688-17.139-17.139V50.713c0-9.451,7.688-17.139,17.139-17.139h108.41c9.451,0,17.139,7.688,17.139,17.139v58.049c0,9.451-7.688,17.139-17.139,17.139H344.484z M363.033,176.262c-1.167,0-2.115-0.948-2.115-2.115v-14.672h83.934v14.672c0,1.167-0.948,2.115-2.115,2.115H363.033z",
        group: "path://M43.534,43.22c-0.287,0.008-0.574,0.014-0.861,0.019c-0.055,0.001-0.11,0.002-0.166,0.003c-0.336,0.005-0.672,0.007-1.007,0.007c-0.336,0-0.673-0.003-1.01-0.007c-0.045-0.001-0.091-0.002-0.136-0.003c-0.298-0.005-0.595-0.011-0.893-0.02c-0.021,0-0.042-0.001-0.062-0.002C32.549,43.015,25.761,41.822,22,39.699v3.551v0.375V44v2.091c2.138,2.156,9.602,4.159,19.5,4.159c8.708,0,15.527-1.551,18.5-3.391V44v-0.375V43.25v-3.041c-3.887,1.802-10.103,2.82-16.373,3.008C43.596,43.218,43.565,43.219,43.534,43.22z M22,30.695v3.555v0.375V35v2.074c0.052,0.052,0.098,0.105,0.157,0.157c0.044,0.04,0.087,0.08,0.135,0.12C24.8,39.4,32.198,41.25,41.5,41.25c8.548,0,15.485-1.563,18.5-3.405V35v-0.375V34.25V31.2c-4.331,2-11.552,3.05-18.5,3.05C33.987,34.25,26.151,33.023,22,30.695z M22,48.699V53c0,0.15,0.036,0.294,0.1,0.422C23.147,57.742,32.312,60,41,60c8.672,0,17.816-2.249,18.895-6.553C59.962,53.313,60,53.161,60,53v-3.791c-4.326,2.006-11.54,3.041-18.5,3.041C33.971,52.25,26.146,51.04,22,48.699z M41,18.25c-8.69,0-17.89,2.302-18.904,6.584C22.037,24.962,22,25.1,22,25.25v0.375v2.449c2.153,2.155,9.779,4.176,19.5,4.176c8.548,0,15.485-1.563,18.5-3.405v-3.22V25.25c0-0.145-0.036-0.28-0.094-0.404C58.906,20.556,49.698,18.25,41,18.25z M55.392,0H4.608C2.067,0,0,2.067,0,4.608v11.783C0,17.365,0.314,18.26,0.835,19h24.016c3.974-1.805,9.935-2.75,15.693-2.75c5.758,0,11.718,0.946,15.692,2.75h2.928C59.686,18.26,60,17.365,60,16.392V4.608C60,2.067,57.933,0,55.392,0z M10.5,15C8.019,15,6,12.981,6,10.5S8.019,6,10.5,6S15,8.019,15,10.5S12.981,15,10.5,15z M34,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S34.552,10,34,10z M36,13c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S36.552,13,36,13z M38,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S38.552,10,38,10z M40,13c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S40.552,13,40,13z M42,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S42.552,10,42,10z M44,13c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S44.552,13,44,13z M46,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S46.552,10,46,10z M48,13c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S48.552,13,48,13z M50,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S50.552,10,50,10z M52,13c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S52.552,13,52,13z M20,38c0-0.156,0-3,0-3v-0.375V34.25v-3.555v-2.621v-2.449V25.25c0-0.15,0.037-0.288,0.096-0.416c0.365-1.541,1.801-2.821,3.881-3.834H0.835C0.314,21.74,0,22.635,0,23.608v11.783C0,36.365,0.314,37.26,0.835,38H20z M10.5,25c2.481,0,4.5,2.019,4.5,4.5S12.981,34,10.5,34S6,31.981,6,29.5S8.019,25,10.5,25z M22.718,56.569c-1.386-0.883-2.324-1.933-2.618-3.147C20.036,53.294,20,53.15,20,53v-4.301v-2.607V44v-0.375V43.25V40H0.835C0.314,40.74,0,41.635,0,42.608v11.783C0,56.937,2.063,59,4.608,59h17.469c0.011,0,0.021,0,0.032,0C23.376,58.982,23.786,57.249,22.718,56.569z M10.5,53C8.019,53,6,50.981,6,48.5S8.019,44,10.5,44s4.5,2.019,4.5,4.5S12.981,53,10.5,53z",
        location: "path://M51.594,3H2.406C1.079,3,0,4.079,0,5.406v11.188C0,16.733,0.014,16.868,0.037,17h53.926C53.986,16.868,54,16.733,54,16.594V5.406C54,4.079,52.921,3,51.594,3z M9,15c-2.206,0-4-1.794-4-4s1.794-4,4-4s4,1.794,4,4S11.206,15,9,15z M31,14c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S31.552,14,31,14z M33,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S33.552,10,33,10z M35,14c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S35.552,14,35,14z M37,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S37.552,10,37,10z M39,14c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S39.552,14,39,14z M41,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S41.552,10,41,10z M43,14c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S43.552,14,43,14z M45,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S45.552,10,45,10z M47,14c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S47.552,14,47,14z M49,10c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S49.552,10,49,10z M0.037,19C0.014,19.132,0,19.267,0,19.406v11.188C0,30.733,0.014,30.868,0.037,31h53.926C53.986,30.868,54,30.733,54,30.594V19.406c0-0.139-0.014-0.274-0.037-0.406H0.037z M9,29c-2.206,0-4-1.794-4-4s1.794-4,4-4s4,1.794,4,4S11.206,29,9,29z M31,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S31.552,28,31,28z M33,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S33.552,24,33,24z M35,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S35.552,28,35,28z M37,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S37.552,24,37,24z M39,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S39.552,28,39,28z M41,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S41.552,24,41,24z M43,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S43.552,28,43,28z M45,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S45.552,24,45,24z M47,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S47.552,28,47,28z M49,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S49.552,24,49,24z M0.037,33C0.014,33.132,0,33.267,0,33.406v11.188C0,45.921,1.079,47,2.406,47H3c0,2.206,1.794,4,4,4s4-1.794,4-4h32c0,2.206,1.794,4,4,4s4-1.794,4-4h0.594C52.921,47,54,45.921,54,44.594V33.406c0-0.139-0.014-0.274-0.037-0.406H0.037z M49,36c0.552,0,1,0.448,1,1s-0.448,1-1,1s-1-0.448-1-1S48.448,36,49,36z M47,40c0.552,0,1,0.448,1,1s-0.448,1-1,1s-1-0.448-1-1S46.448,40,47,40z M45,36c0.552,0,1,0.448,1,1s-0.448,1-1,1s-1-0.448-1-1S44.448,36,45,36z M7,49c-1.103,0-2-0.897-2-2h4C9,48.103,8.103,49,7,49z M9,43c-2.206,0-4-1.794-4-4s1.794-4,4-4s4,1.794,4,4S11.206,43,9,43z M31,42c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S31.552,42,31,42z M33,38c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S33.552,38,33,38z M35,42c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S35.552,42,35,42z M37,38c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S37.552,38,37,38z M39,42c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S39.552,42,39,42z M41,38c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S41.552,38,41,38z M42,41c0-0.552,0.448-1,1-1s1,0.448,1,1s-0.448,1-1,1S42,41.552,42,41z M47,49c-1.103,0-2-0.897-2-2h4C49,48.103,48.103,49,47,49z",
        host: "path://M0.037,19C0.014,19.132,0,19.267,0,19.406v11.188C0,30.733,0.014,30.868,0.037,31h53.926C53.986,30.868,54,30.733,54,30.594V19.406c0-0.139-0.014-0.274-0.037-0.406H0.037z M9,29c-2.206,0-4-1.794-4-4s1.794-4,4-4s4,1.794,4,4S11.206,29,9,29z M31,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S31.552,28,31,28z M33,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S33.552,24,33,24z M35,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S35.552,28,35,28z M37,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S37.552,24,37,24z M39,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S39.552,28,39,28z M41,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S41.552,24,41,24z M43,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S43.552,28,43,28z M45,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S45.552,24,45,24z M47,28c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S47.552,28,47,28z M49,24c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S49.552,24,49,24z"
    };

    var imgsizes = {
        cluster: [30, 30],
        group: [30, 30],
        location: [30, 30],
        host: [30, 7]
    };
</script>