<%-- 
    Document   : testjs
    Created on : Apr 26, 2017, 12:06:56 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>-->
<script src="${cp}/assets/js/echarts.min.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<!--<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>-->
<script src="${cp}/assets/js/chartsfuncs.min.js?v=${version}"></script>
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
                    minChars: 0
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
                    lookup: Object.keys(data.data),
                    minChars: 0
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
                $(this).fadeIn();
                var val = "*";
                if ($(this).find("input.filter-input").val() !== "")
                {
                    val = $(this).find("input.filter-input").val();
                }
                tags = tags + $(this).find("input.filter-input").attr('tagkey') + "=" + val + ";";
                tagstree.push($(this).find("input.filter-input").attr('tagkey'));
            } else
            {
                $(this).fadeOut();
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
            var linkid = 0;
            var values = Object.values(data.chartsdata);
            var maxvalue = 0;
            var minvalue = Infinity;
            values.sort(function (a, b) {
                return (a.tags[0] > b.tags[0]) ? 1 : ((a.tags[0] < b.tags[0]) ? -1 : 0);
            });
            if (values[0])
            {
                for (var tindex in values[0].tags)
                {
                    $("#" + tindex + "_input").parents(".tag-grop").fadeIn();
                }
            }

            var graphtree = {id: 0, data: {}};
            var id = 1;
            for (var dataindex in values)
            {
//                var chdata = [];
//                for (var ind in values[dataindex].data) {
//                    chdata.push(values[dataindex].data[ind][1]);                    
//                }
                for (var tagindexindex in tagstree)
                {

                    if (categories.indexOf(tagindexindex) === -1)
                    {
                        categories.push(tagstree[tagindexindex]);
                        categoriesch.push({name: tagstree[tagindexindex]});
                    }

                    var tag = values[dataindex].tags[tagstree[tagindexindex]];
                    var obj = graphtree;
                    var prent = graphtree;
                    for (var i = 0; i <= tagindexindex; i++) {
                        if (i > 0)
                        {
                            prent = prent.data[values[dataindex].tags[tagstree[i - 1]]];
                        }
                        obj = obj.data[values[dataindex].tags[tagstree[i]]];
                    }
                    if (!obj)
                    {
                        prent.data[tag] = {id: id, value: values[dataindex].data[values[dataindex].data.length - 1][1],name:values[dataindex].tags[tagstree[tagindexindex]], data: {}};
                        obj=prent.data[tag];
                        links.push({
                            emphasis: {
                                label: {
                                    show: false
                                }
                            },
                            "label": {
                                position: 'left',
                                "show": false
                            },
                            "id": prent.id + "-" + id,
                            "source": prent.id + "",
                            "target": id + "",
                            name: prent.id + "-" + id}
                        );
//                        datach.push({
//                            "x": id * 20,
//                            "y": tagindexindex * 500,
//                            "id": id + "",
//                            "name": tagstree[tagindexindex],
//                            "category": tagstree[tagindexindex],
//                            "itemStyle": null,
//                            "symbolSize": (tagstree.length - tagindexindex + 1) * 5,
//                            "attributes": {
//                                "modularity_class": 8
//                            },
////                            "value": values[dataindex].tags[tagstree[tagindexindex]],
//                            "value": values[dataindex].data[values[dataindex].data.length - 1][1],
//                            "label": {
//                                "normal": {
//                                    "show": false
//                                }
//                            }
//
//                        });
                        id++;

                    } else
                    {
                        obj.value = obj.value + values[dataindex].data[values[dataindex].data.length - 1][1];
                    }                    
                    maxvalue=Math.max(maxvalue,obj.value);
                    if (obj.value>0)
                    {
                        minvalue=Math.min(minvalue,obj.value);
//                        console.log("mmm"+minvalue);
                    }
                    
                }
            }
            function eachtree(item, level)
            {
//                console.log("***********" + level);
//                console.log(item);
                for (var gindex in item.data)
                {
                    if (Object.keys(item.data[gindex].data).length > 0)
                    {
                        eachtree(item.data[gindex], level + 1);
                    }                    
                    datach.push({
                        "x": item.data[gindex].id * 20,
                        "y": level * 500,
                        "id": item.data[gindex].id + "",
                        "name": item.data[gindex].name,
                        "category": tagstree[level],
                        "itemStyle": null,
                        "symbolSize": Math.max(item.data[gindex].value*50/maxvalue,5) ,
                        "attributes": {
                            "modularity_class": 8
                        },
//                            "value": values[dataindex].tags[tagstree[tagindexindex]],
                        "value": format_metric_big(item.data[gindex].value) ,
                        "label": {
                            "normal": {
                                "show": false
                            }
                        }

                    });

                }


            }
            ;
            eachtree(graphtree, 0);
//            console.log(graphtree);
//            links.push({
//                emphasis: {
//                    label: {
//                        show: false
//                    }
//                },
//                "label": {
//                    position: 'left',
//                    "show": false
//                },
//                "id": "0",
//                "source": "1",
//                "target": "2",
//                name: "test"}
//            );

            datach.sort(function (a, b) {
                return compareStrings(a.category, b.category);
            });
            $("#echart_line").css('height', '800px');
            echartLine = echarts.init(document.getElementById("echart_line"), 'oddeyelight');
            var option = {
                title: {
                    top: 'bottom',
                    left: 'right'
                },
                tooltip: {},
                legend: [{
                        data: categoriesch.map(function (a) {
                            return a.name;
                        })
                    }],
                animationDuration: 1500,
                animationEasingUpdate: 'quinticInOut',
                series: [
                    {
                        name: 'Infrastructure',
                        type: 'graph',
                        layout: 'force',
                        force: {
                            initLayout: 'none',
                            repulsion: 5000,
                            gravity: 0.2
                        },
                        data: datach,
                        links: links,
                        categories: categoriesch,
                        focusNodeAdjacency: true,
                        roam: true,
                        itemStyle: {
                            normal: {
                                borderColor: '#fff',
                                borderWidth: 1,
                                shadowBlur: 10,
                                shadowColor: 'rgba(0, 0, 0, 0.3)'
                            }
                        },
                        label: {
                            position: 'right',
                            formatter: '{b}'
                        },
                        lineStyle: {
                            color: 'source',
                            curveness: 0.3
                        },
                        emphasis: {
                            lineStyle: {
                                width: 10
                            }
                        }
                    }
                ]};
            echartLine.setOption(option);
        });
    }
    ;

</script>