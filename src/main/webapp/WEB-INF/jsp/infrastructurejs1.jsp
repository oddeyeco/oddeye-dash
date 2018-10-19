<%-- 
    Document   : testjs
    Created on : Apr 26, 2017, 12:06:56 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/echarts/dist/echarts-en.min.js?v=${version}"></script>
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
            values.sort(function (a, b) {
                return (a.tags[0] > b.tags[0]) ? 1 : ((a.tags[0] < b.tags[0]) ? -1 : 0);
            });
            for (var tindex in values[0].tags)
            {

                $("#" + tindex + "_input").parents(".tag-grop").fadeIn();
//                console.log($("#"+tindex+"_input").parents(".tag-grop").attr("class"));
            }


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
                        linkid++;
                        name = tagindexindex + "~" + values[dataindex].tags[tagindexindex];
//                        size = imgsizes[tagindexindex];
//                        symbol = img[tagindexindex];
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
                            "id": linkid,
                            "source": tagstree[index - 1] + '~' + values[dataindex].tags[tagstree[index - 1]],
                            "target": name,
                            name: null}
                        );
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
//                        {"id": "0", "name": "Myriel", "itemStyle": {"normal": {"color": "rgb(235,81,72)"}}, "symbolSize": 28.685715, "x": -266.82776, "y": 299.6904, "attributes": {"modularity_class": 0}}
                        datach.push({
//                            "x": Math.sin(x)*(index+1) ,
//                            "y": Math.cos(x)*(index+1),
                            "x": x * 20,
                            "y": index * 500,
                            "name": name,
                            "category": tagindexindex,
                            "itemStyle": null,
                            "symbolSize":(tagstree.length-index+1)*5,
                            "attributes": {
                                "modularity_class": 8
                            },
                            "value": values[dataindex].tags[tagindexindex],
                            "label": {
                                "normal": {
                                    "show": false
                                }
                            }

                        });
                    }
                }

            }
            datach.sort(function (a, b) {
                return compareStrings(a.category, b.category);
            });
//            console.log(log);
            $("#echart_line").css('height', '800px');
            echartLine = echarts.init(document.getElementById("echart_line"), 'oddeyelight');
//            graph = {"nodes": [{"id": "0", "name": "Myriel", "itemStyle": {"normal": {"color": "rgb(235,81,72)"}}, "symbolSize": 28.685715, "x": -266.82776, "y": 299.6904, "attributes": {"modularity_class": 0}}, {"id": "1", "name": "Napoleon", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -418.08344, "y": 446.8853, "attributes": {"modularity_class": 0}}, {"id": "2", "name": "MlleBaptistine", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 9.485714, "x": -212.76357, "y": 245.29176, "attributes": {"modularity_class": 1}}, {"id": "3", "name": "MmeMagloire", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 9.485714, "x": -242.82404, "y": 235.26283, "attributes": {"modularity_class": 1}}, {"id": "4", "name": "CountessDeLo", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -379.30386, "y": 429.06424, "attributes": {"modularity_class": 0}}, {"id": "5", "name": "Geborand", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -417.26337, "y": 406.03506, "attributes": {"modularity_class": 0}}, {"id": "6", "name": "Champtercier", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -332.6012, "y": 485.16974, "attributes": {"modularity_class": 0}}, {"id": "7", "name": "Cravatte", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -382.69568, "y": 475.09113, "attributes": {"modularity_class": 0}}, {"id": "8", "name": "Count", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -320.384, "y": 387.17325, "attributes": {"modularity_class": 0}}, {"id": "9", "name": "OldMan", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -344.39832, "y": 451.16772, "attributes": {"modularity_class": 0}}, {"id": "10", "name": "Labarre", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -89.34107, "y": 234.56128, "attributes": {"modularity_class": 1}}, {"id": "11", "name": "Valjean", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 100, "x": -87.93029, "y": -6.8120565, "attributes": {"modularity_class": 1}}, {"id": "12", "name": "Marguerite", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": -339.77908, "y": -184.69139, "attributes": {"modularity_class": 1}}, {"id": "13", "name": "MmeDeR", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -194.31313, "y": 178.55301, "attributes": {"modularity_class": 1}}, {"id": "14", "name": "Isabeau", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -158.05168, "y": 201.99768, "attributes": {"modularity_class": 1}}, {"id": "15", "name": "Gervais", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -127.701546, "y": 242.55057, "attributes": {"modularity_class": 1}}, {"id": "16", "name": "Tholomyes", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 25.942856, "x": -385.2226, "y": -393.5572, "attributes": {"modularity_class": 2}}, {"id": "17", "name": "Listolier", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": -516.55884, "y": -393.98975, "attributes": {"modularity_class": 2}}, {"id": "18", "name": "Fameuil", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": -464.79382, "y": -493.57944, "attributes": {"modularity_class": 2}}, {"id": "19", "name": "Blacheville", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": -515.1624, "y": -456.9891, "attributes": {"modularity_class": 2}}, {"id": "20", "name": "Favourite", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": -408.12122, "y": -464.5048, "attributes": {"modularity_class": 2}}, {"id": "21", "name": "Dahlia", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": -456.44113, "y": -425.13303, "attributes": {"modularity_class": 2}}, {"id": "22", "name": "Zephine", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": -459.1107, "y": -362.5133, "attributes": {"modularity_class": 2}}, {"id": "23", "name": "Fantine", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 42.4, "x": -313.42786, "y": -289.44803, "attributes": {"modularity_class": 2}}, {"id": "24", "name": "MmeThenardier", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 31.428574, "x": 4.6313396, "y": -273.8517, "attributes": {"modularity_class": 7}}, {"id": "25", "name": "Thenardier", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 45.142853, "x": 82.80825, "y": -203.1144, "attributes": {"modularity_class": 7}}, {"id": "26", "name": "Cosette", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 31.428574, "x": 78.64646, "y": -31.512747, "attributes": {"modularity_class": 6}}, {"id": "27", "name": "Javert", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 47.88571, "x": -81.46074, "y": -204.20204, "attributes": {"modularity_class": 7}}, {"id": "28", "name": "Fauchelevent", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 12.228573, "x": -225.73984, "y": 82.41631, "attributes": {"modularity_class": 4}}, {"id": "29", "name": "Bamatabois", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 23.2, "x": -385.6842, "y": -20.206686, "attributes": {"modularity_class": 3}}, {"id": "30", "name": "Perpetue", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": -403.92447, "y": -197.69823, "attributes": {"modularity_class": 2}}, {"id": "31", "name": "Simplice", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 12.228573, "x": -281.4253, "y": -158.45137, "attributes": {"modularity_class": 2}}, {"id": "32", "name": "Scaufflaire", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -122.41348, "y": 210.37503, "attributes": {"modularity_class": 1}}, {"id": "33", "name": "Woman1", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": -234.6001, "y": -113.15067, "attributes": {"modularity_class": 1}}, {"id": "34", "name": "Judge", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 17.714287, "x": -387.84915, "y": 58.7059, "attributes": {"modularity_class": 3}}, {"id": "35", "name": "Champmathieu", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 17.714287, "x": -338.2307, "y": 87.48405, "attributes": {"modularity_class": 3}}, {"id": "36", "name": "Brevet", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 17.714287, "x": -453.26874, "y": 58.94648, "attributes": {"modularity_class": 3}}, {"id": "37", "name": "Chenildieu", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 17.714287, "x": -386.44904, "y": 140.05937, "attributes": {"modularity_class": 3}}, {"id": "38", "name": "Cochepaille", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 17.714287, "x": -446.7876, "y": 123.38005, "attributes": {"modularity_class": 3}}, {"id": "39", "name": "Pontmercy", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 9.485714, "x": 336.49738, "y": -269.55914, "attributes": {"modularity_class": 6}}, {"id": "40", "name": "Boulatruelle", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": 29.187843, "y": -460.13132, "attributes": {"modularity_class": 7}}, {"id": "41", "name": "Eponine", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 31.428574, "x": 238.36697, "y": -210.00926, "attributes": {"modularity_class": 7}}, {"id": "42", "name": "Anzelma", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 9.485714, "x": 189.69513, "y": -346.50662, "attributes": {"modularity_class": 7}}, {"id": "43", "name": "Woman2", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 9.485714, "x": -187.00418, "y": -145.02663, "attributes": {"modularity_class": 6}}, {"id": "44", "name": "MotherInnocent", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": -252.99521, "y": 129.87549, "attributes": {"modularity_class": 4}}, {"id": "45", "name": "Gribier", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": -296.07935, "y": 163.11964, "attributes": {"modularity_class": 4}}, {"id": "46", "name": "Jondrette", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": 550.3201, "y": 522.4031, "attributes": {"modularity_class": 5}}, {"id": "47", "name": "MmeBurgon", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": 488.13535, "y": 356.8573, "attributes": {"modularity_class": 5}}, {"id": "48", "name": "Gavroche", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 61.600006, "x": 387.89572, "y": 110.462326, "attributes": {"modularity_class": 8}}, {"id": "49", "name": "Gillenormand", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": 126.4831, "y": 68.10622, "attributes": {"modularity_class": 6}}, {"id": "50", "name": "Magnon", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": 127.07365, "y": -113.05923, "attributes": {"modularity_class": 6}}, {"id": "51", "name": "MlleGillenormand", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": 162.63559, "y": 117.6565, "attributes": {"modularity_class": 6}}, {"id": "52", "name": "MmePontmercy", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": 353.66415, "y": -205.89165, "attributes": {"modularity_class": 6}}, {"id": "53", "name": "MlleVaubois", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": 165.43939, "y": 339.7736, "attributes": {"modularity_class": 6}}, {"id": "54", "name": "LtGillenormand", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 12.228573, "x": 137.69348, "y": 196.1069, "attributes": {"modularity_class": 6}}, {"id": "55", "name": "Marius", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 53.37143, "x": 206.44687, "y": -13.805411, "attributes": {"modularity_class": 6}}, {"id": "56", "name": "BaronessT", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": 194.82993, "y": 224.78036, "attributes": {"modularity_class": 6}}, {"id": "57", "name": "Mabeuf", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 31.428574, "x": 597.6618, "y": 135.18481, "attributes": {"modularity_class": 8}}, {"id": "58", "name": "Enjolras", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 42.4, "x": 355.78366, "y": -74.882454, "attributes": {"modularity_class": 8}}, {"id": "59", "name": "Combeferre", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 31.428574, "x": 515.2961, "y": -46.167564, "attributes": {"modularity_class": 8}}, {"id": "60", "name": "Prouvaire", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 25.942856, "x": 614.29285, "y": -69.3104, "attributes": {"modularity_class": 8}}, {"id": "61", "name": "Feuilly", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 31.428574, "x": 550.1917, "y": -128.17537, "attributes": {"modularity_class": 8}}, {"id": "62", "name": "Courfeyrac", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 36.91429, "x": 436.17184, "y": -12.7286825, "attributes": {"modularity_class": 8}}, {"id": "63", "name": "Bahorel", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 34.17143, "x": 602.55225, "y": 16.421427, "attributes": {"modularity_class": 8}}, {"id": "64", "name": "Bossuet", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 36.91429, "x": 455.81955, "y": -115.45826, "attributes": {"modularity_class": 8}}, {"id": "65", "name": "Joly", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 34.17143, "x": 516.40784, "y": 47.242233, "attributes": {"modularity_class": 8}}, {"id": "66", "name": "Grantaire", "itemStyle": {"normal": {"color": "rgb(235,81,72)"}}, "symbolSize": 28.685715, "x": 646.4313, "y": -151.06331, "attributes": {"modularity_class": 8}}, {"id": "67", "name": "MotherPlutarch", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 4, "x": 668.9568, "y": 204.65488, "attributes": {"modularity_class": 8}}, {"id": "68", "name": "Gueulemer", "itemStyle": {"normal": {"color": "rgb(235,81,72)"}}, "symbolSize": 28.685715, "x": 78.4799, "y": -347.15146, "attributes": {"modularity_class": 7}}, {"id": "69", "name": "Babet", "itemStyle": {"normal": {"color": "rgb(235,81,72)"}}, "symbolSize": 28.685715, "x": 150.35959, "y": -298.50797, "attributes": {"modularity_class": 7}}, {"id": "70", "name": "Claquesous", "itemStyle": {"normal": {"color": "rgb(235,81,72)"}}, "symbolSize": 28.685715, "x": 137.3717, "y": -410.2809, "attributes": {"modularity_class": 7}}, {"id": "71", "name": "Montparnasse", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 25.942856, "x": 234.87747, "y": -400.85983, "attributes": {"modularity_class": 7}}, {"id": "72", "name": "Toussaint", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 9.485714, "x": 40.942253, "y": 113.78272, "attributes": {"modularity_class": 1}}, {"id": "73", "name": "Child1", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": 437.939, "y": 291.58234, "attributes": {"modularity_class": 8}}, {"id": "74", "name": "Child2", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 6.742859, "x": 466.04922, "y": 283.3606, "attributes": {"modularity_class": 8}}, {"id": "75", "name": "Brujon", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": 238.79364, "y": -314.06345, "attributes": {"modularity_class": 7}}, {"id": "76", "name": "MmeHucheloup", "itemStyle": {"normal": {"color": "rgb(236,81,72)"}}, "symbolSize": 20.457146, "x": 712.18353, "y": 4.8131495, "attributes": {"modularity_class": 8}}],
//                "links": [{"id": "0", "name": null, "source": "1", "target": "0", "lineStyle": {"normal": {}}}, {"id": "1", "name": null, "source": "2", "target": "0", "lineStyle": {"normal": {}}}, {"id": "2", "name": null, "source": "3", "target": "0", "lineStyle": {"normal": {}}}, {"id": "3", "name": null, "source": "3", "target": "2", "lineStyle": {"normal": {}}}, {"id": "4", "name": null, "source": "4", "target": "0", "lineStyle": {"normal": {}}}, {"id": "5", "name": null, "source": "5", "target": "0", "lineStyle": {"normal": {}}}, {"id": "6", "name": null, "source": "6", "target": "0", "lineStyle": {"normal": {}}}, {"id": "7", "name": null, "source": "7", "target": "0", "lineStyle": {"normal": {}}}, {"id": "8", "name": null, "source": "8", "target": "0", "lineStyle": {"normal": {}}}, {"id": "9", "name": null, "source": "9", "target": "0", "lineStyle": {"normal": {}}}, {"id": "13", "name": null, "source": "11", "target": "0", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "11", "target": "2", "lineStyle": {"normal": {}}}, {"id": "11", "name": null, "source": "11", "target": "3", "lineStyle": {"normal": {}}}, {"id": "10", "name": null, "source": "11", "target": "10", "lineStyle": {"normal": {}}}, {"id": "14", "name": null, "source": "12", "target": "11", "lineStyle": {"normal": {}}}, {"id": "15", "name": null, "source": "13", "target": "11", "lineStyle": {"normal": {}}}, {"id": "16", "name": null, "source": "14", "target": "11", "lineStyle": {"normal": {}}}, {"id": "17", "name": null, "source": "15", "target": "11", "lineStyle": {"normal": {}}}, {"id": "18", "name": null, "source": "17", "target": "16", "lineStyle": {"normal": {}}}, {"id": "19", "name": null, "source": "18", "target": "16", "lineStyle": {"normal": {}}}, {"id": "20", "name": null, "source": "18", "target": "17", "lineStyle": {"normal": {}}}, {"id": "21", "name": null, "source": "19", "target": "16", "lineStyle": {"normal": {}}}, {"id": "22", "name": null, "source": "19", "target": "17", "lineStyle": {"normal": {}}}, {"id": "23", "name": null, "source": "19", "target": "18", "lineStyle": {"normal": {}}}, {"id": "24", "name": null, "source": "20", "target": "16", "lineStyle": {"normal": {}}}, {"id": "25", "name": null, "source": "20", "target": "17", "lineStyle": {"normal": {}}}, {"id": "26", "name": null, "source": "20", "target": "18", "lineStyle": {"normal": {}}}, {"id": "27", "name": null, "source": "20", "target": "19", "lineStyle": {"normal": {}}}, {"id": "28", "name": null, "source": "21", "target": "16", "lineStyle": {"normal": {}}}, {"id": "29", "name": null, "source": "21", "target": "17", "lineStyle": {"normal": {}}}, {"id": "30", "name": null, "source": "21", "target": "18", "lineStyle": {"normal": {}}}, {"id": "31", "name": null, "source": "21", "target": "19", "lineStyle": {"normal": {}}}, {"id": "32", "name": null, "source": "21", "target": "20", "lineStyle": {"normal": {}}}, {"id": "33", "name": null, "source": "22", "target": "16", "lineStyle": {"normal": {}}}, {"id": "34", "name": null, "source": "22", "target": "17", "lineStyle": {"normal": {}}}, {"id": "35", "name": null, "source": "22", "target": "18", "lineStyle": {"normal": {}}}, {"id": "36", "name": null, "source": "22", "target": "19", "lineStyle": {"normal": {}}}, {"id": "37", "name": null, "source": "22", "target": "20", "lineStyle": {"normal": {}}}, {"id": "38", "name": null, "source": "22", "target": "21", "lineStyle": {"normal": {}}}, {"id": "47", "name": null, "source": "23", "target": "11", "lineStyle": {"normal": {}}}, {"id": "46", "name": null, "source": "23", "target": "12", "lineStyle": {"normal": {}}}, {"id": "39", "name": null, "source": "23", "target": "16", "lineStyle": {"normal": {}}}, {"id": "40", "name": null, "source": "23", "target": "17", "lineStyle": {"normal": {}}}, {"id": "41", "name": null, "source": "23", "target": "18", "lineStyle": {"normal": {}}}, {"id": "42", "name": null, "source": "23", "target": "19", "lineStyle": {"normal": {}}}, {"id": "43", "name": null, "source": "23", "target": "20", "lineStyle": {"normal": {}}}, {"id": "44", "name": null, "source": "23", "target": "21", "lineStyle": {"normal": {}}}, {"id": "45", "name": null, "source": "23", "target": "22", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "24", "target": "11", "lineStyle": {"normal": {}}}, {"id": "48", "name": null, "source": "24", "target": "23", "lineStyle": {"normal": {}}}, {"id": "52", "name": null, "source": "25", "target": "11", "lineStyle": {"normal": {}}}, {"id": "51", "name": null, "source": "25", "target": "23", "lineStyle": {"normal": {}}}, {"id": "50", "name": null, "source": "25", "target": "24", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "26", "target": "11", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "26", "target": "16", "lineStyle": {"normal": {}}}, {"id": "53", "name": null, "source": "26", "target": "24", "lineStyle": {"normal": {}}}, {"id": "56", "name": null, "source": "26", "target": "25", "lineStyle": {"normal": {}}}, {"id": "57", "name": null, "source": "27", "target": "11", "lineStyle": {"normal": {}}}, {"id": "58", "name": null, "source": "27", "target": "23", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "27", "target": "24", "lineStyle": {"normal": {}}}, {"id": "59", "name": null, "source": "27", "target": "25", "lineStyle": {"normal": {}}}, {"id": "61", "name": null, "source": "27", "target": "26", "lineStyle": {"normal": {}}}, {"id": "62", "name": null, "source": "28", "target": "11", "lineStyle": {"normal": {}}}, {"id": "63", "name": null, "source": "28", "target": "27", "lineStyle": {"normal": {}}}, {"id": "66", "name": null, "source": "29", "target": "11", "lineStyle": {"normal": {}}}, {"id": "64", "name": null, "source": "29", "target": "23", "lineStyle": {"normal": {}}}, {"id": "65", "name": null, "source": "29", "target": "27", "lineStyle": {"normal": {}}}, {"id": "67", "name": null, "source": "30", "target": "23", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "31", "target": "11", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "31", "target": "23", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "31", "target": "27", "lineStyle": {"normal": {}}}, {"id": "68", "name": null, "source": "31", "target": "30", "lineStyle": {"normal": {}}}, {"id": "72", "name": null, "source": "32", "target": "11", "lineStyle": {"normal": {}}}, {"id": "73", "name": null, "source": "33", "target": "11", "lineStyle": {"normal": {}}}, {"id": "74", "name": null, "source": "33", "target": "27", "lineStyle": {"normal": {}}}, {"id": "75", "name": null, "source": "34", "target": "11", "lineStyle": {"normal": {}}}, {"id": "76", "name": null, "source": "34", "target": "29", "lineStyle": {"normal": {}}}, {"id": "77", "name": null, "source": "35", "target": "11", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "35", "target": "29", "lineStyle": {"normal": {}}}, {"id": "78", "name": null, "source": "35", "target": "34", "lineStyle": {"normal": {}}}, {"id": "82", "name": null, "source": "36", "target": "11", "lineStyle": {"normal": {}}}, {"id": "83", "name": null, "source": "36", "target": "29", "lineStyle": {"normal": {}}}, {"id": "80", "name": null, "source": "36", "target": "34", "lineStyle": {"normal": {}}}, {"id": "81", "name": null, "source": "36", "target": "35", "lineStyle": {"normal": {}}}, {"id": "87", "name": null, "source": "37", "target": "11", "lineStyle": {"normal": {}}}, {"id": "88", "name": null, "source": "37", "target": "29", "lineStyle": {"normal": {}}}, {"id": "84", "name": null, "source": "37", "target": "34", "lineStyle": {"normal": {}}}, {"id": "85", "name": null, "source": "37", "target": "35", "lineStyle": {"normal": {}}}, {"id": "86", "name": null, "source": "37", "target": "36", "lineStyle": {"normal": {}}}, {"id": "93", "name": null, "source": "38", "target": "11", "lineStyle": {"normal": {}}}, {"id": "94", "name": null, "source": "38", "target": "29", "lineStyle": {"normal": {}}}, {"id": "89", "name": null, "source": "38", "target": "34", "lineStyle": {"normal": {}}}, {"id": "90", "name": null, "source": "38", "target": "35", "lineStyle": {"normal": {}}}, {"id": "91", "name": null, "source": "38", "target": "36", "lineStyle": {"normal": {}}}, {"id": "92", "name": null, "source": "38", "target": "37", "lineStyle": {"normal": {}}}, {"id": "95", "name": null, "source": "39", "target": "25", "lineStyle": {"normal": {}}}, {"id": "96", "name": null, "source": "40", "target": "25", "lineStyle": {"normal": {}}}, {"id": "97", "name": null, "source": "41", "target": "24", "lineStyle": {"normal": {}}}, {"id": "98", "name": null, "source": "41", "target": "25", "lineStyle": {"normal": {}}}, {"id": "101", "name": null, "source": "42", "target": "24", "lineStyle": {"normal": {}}}, {"id": "100", "name": null, "source": "42", "target": "25", "lineStyle": {"normal": {}}}, {"id": "99", "name": null, "source": "42", "target": "41", "lineStyle": {"normal": {}}}, {"id": "102", "name": null, "source": "43", "target": "11", "lineStyle": {"normal": {}}}, {"id": "103", "name": null, "source": "43", "target": "26", "lineStyle": {"normal": {}}}, {"id": "104", "name": null, "source": "43", "target": "27", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "44", "target": "11", "lineStyle": {"normal": {}}}, {"id": "105", "name": null, "source": "44", "target": "28", "lineStyle": {"normal": {}}}, {"id": "107", "name": null, "source": "45", "target": "28", "lineStyle": {"normal": {}}}, {"id": "108", "name": null, "source": "47", "target": "46", "lineStyle": {"normal": {}}}, {"id": "112", "name": null, "source": "48", "target": "11", "lineStyle": {"normal": {}}}, {"id": "110", "name": null, "source": "48", "target": "25", "lineStyle": {"normal": {}}}, {"id": "111", "name": null, "source": "48", "target": "27", "lineStyle": {"normal": {}}}, {"id": "109", "name": null, "source": "48", "target": "47", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "49", "target": "11", "lineStyle": {"normal": {}}}, {"id": "113", "name": null, "source": "49", "target": "26", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "50", "target": "24", "lineStyle": {"normal": {}}}, {"id": "115", "name": null, "source": "50", "target": "49", "lineStyle": {"normal": {}}}, {"id": "119", "name": null, "source": "51", "target": "11", "lineStyle": {"normal": {}}}, {"id": "118", "name": null, "source": "51", "target": "26", "lineStyle": {"normal": {}}}, {"id": "117", "name": null, "source": "51", "target": "49", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "52", "target": "39", "lineStyle": {"normal": {}}}, {"id": "120", "name": null, "source": "52", "target": "51", "lineStyle": {"normal": {}}}, {"id": "122", "name": null, "source": "53", "target": "51", "lineStyle": {"normal": {}}}, {"id": "125", "name": null, "source": "54", "target": "26", "lineStyle": {"normal": {}}}, {"id": "124", "name": null, "source": "54", "target": "49", "lineStyle": {"normal": {}}}, {"id": "123", "name": null, "source": "54", "target": "51", "lineStyle": {"normal": {}}}, {"id": "131", "name": null, "source": "55", "target": "11", "lineStyle": {"normal": {}}}, {"id": "132", "name": null, "source": "55", "target": "16", "lineStyle": {"normal": {}}}, {"id": "133", "name": null, "source": "55", "target": "25", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "55", "target": "26", "lineStyle": {"normal": {}}}, {"id": "128", "name": null, "source": "55", "target": "39", "lineStyle": {"normal": {}}}, {"id": "134", "name": null, "source": "55", "target": "41", "lineStyle": {"normal": {}}}, {"id": "135", "name": null, "source": "55", "target": "48", "lineStyle": {"normal": {}}}, {"id": "127", "name": null, "source": "55", "target": "49", "lineStyle": {"normal": {}}}, {"id": "126", "name": null, "source": "55", "target": "51", "lineStyle": {"normal": {}}}, {"id": "129", "name": null, "source": "55", "target": "54", "lineStyle": {"normal": {}}}, {"id": "136", "name": null, "source": "56", "target": "49", "lineStyle": {"normal": {}}}, {"id": "137", "name": null, "source": "56", "target": "55", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "57", "target": "41", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "57", "target": "48", "lineStyle": {"normal": {}}}, {"id": "138", "name": null, "source": "57", "target": "55", "lineStyle": {"normal": {}}}, {"id": "145", "name": null, "source": "58", "target": "11", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "58", "target": "27", "lineStyle": {"normal": {}}}, {"id": "142", "name": null, "source": "58", "target": "48", "lineStyle": {"normal": {}}}, {"id": "141", "name": null, "source": "58", "target": "55", "lineStyle": {"normal": {}}}, {"id": "144", "name": null, "source": "58", "target": "57", "lineStyle": {"normal": {}}}, {"id": "148", "name": null, "source": "59", "target": "48", "lineStyle": {"normal": {}}}, {"id": "147", "name": null, "source": "59", "target": "55", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "59", "target": "57", "lineStyle": {"normal": {}}}, {"id": "146", "name": null, "source": "59", "target": "58", "lineStyle": {"normal": {}}}, {"id": "150", "name": null, "source": "60", "target": "48", "lineStyle": {"normal": {}}}, {"id": "151", "name": null, "source": "60", "target": "58", "lineStyle": {"normal": {}}}, {"id": "152", "name": null, "source": "60", "target": "59", "lineStyle": {"normal": {}}}, {"id": "153", "name": null, "source": "61", "target": "48", "lineStyle": {"normal": {}}}, {"id": "158", "name": null, "source": "61", "target": "55", "lineStyle": {"normal": {}}}, {"id": "157", "name": null, "source": "61", "target": "57", "lineStyle": {"normal": {}}}, {"id": "154", "name": null, "source": "61", "target": "58", "lineStyle": {"normal": {}}}, {"id": "156", "name": null, "source": "61", "target": "59", "lineStyle": {"normal": {}}}, {"id": "155", "name": null, "source": "61", "target": "60", "lineStyle": {"normal": {}}}, {"id": "164", "name": null, "source": "62", "target": "41", "lineStyle": {"normal": {}}}, {"id": "162", "name": null, "source": "62", "target": "48", "lineStyle": {"normal": {}}}, {"id": "159", "name": null, "source": "62", "target": "55", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "62", "target": "57", "lineStyle": {"normal": {}}}, {"id": "160", "name": null, "source": "62", "target": "58", "lineStyle": {"normal": {}}}, {"id": "161", "name": null, "source": "62", "target": "59", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "62", "target": "60", "lineStyle": {"normal": {}}}, {"id": "165", "name": null, "source": "62", "target": "61", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "63", "target": "48", "lineStyle": {"normal": {}}}, {"id": "174", "name": null, "source": "63", "target": "55", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "63", "target": "57", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "63", "target": "58", "lineStyle": {"normal": {}}}, {"id": "167", "name": null, "source": "63", "target": "59", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "63", "target": "60", "lineStyle": {"normal": {}}}, {"id": "172", "name": null, "source": "63", "target": "61", "lineStyle": {"normal": {}}}, {"id": "169", "name": null, "source": "63", "target": "62", "lineStyle": {"normal": {}}}, {"id": "184", "name": null, "source": "64", "target": "11", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "64", "target": "48", "lineStyle": {"normal": {}}}, {"id": "175", "name": null, "source": "64", "target": "55", "lineStyle": {"normal": {}}}, {"id": "183", "name": null, "source": "64", "target": "57", "lineStyle": {"normal": {}}}, {"id": "179", "name": null, "source": "64", "target": "58", "lineStyle": {"normal": {}}}, {"id": "182", "name": null, "source": "64", "target": "59", "lineStyle": {"normal": {}}}, {"id": "181", "name": null, "source": "64", "target": "60", "lineStyle": {"normal": {}}}, {"id": "180", "name": null, "source": "64", "target": "61", "lineStyle": {"normal": {}}}, {"id": "176", "name": null, "source": "64", "target": "62", "lineStyle": {"normal": {}}}, {"id": "178", "name": null, "source": "64", "target": "63", "lineStyle": {"normal": {}}}, {"id": "187", "name": null, "source": "65", "target": "48", "lineStyle": {"normal": {}}}, {"id": "194", "name": null, "source": "65", "target": "55", "lineStyle": {"normal": {}}}, {"id": "193", "name": null, "source": "65", "target": "57", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "65", "target": "58", "lineStyle": {"normal": {}}}, {"id": "192", "name": null, "source": "65", "target": "59", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "65", "target": "60", "lineStyle": {"normal": {}}}, {"id": "190", "name": null, "source": "65", "target": "61", "lineStyle": {"normal": {}}}, {"id": "188", "name": null, "source": "65", "target": "62", "lineStyle": {"normal": {}}}, {"id": "185", "name": null, "source": "65", "target": "63", "lineStyle": {"normal": {}}}, {"id": "186", "name": null, "source": "65", "target": "64", "lineStyle": {"normal": {}}}, {"id": "200", "name": null, "source": "66", "target": "48", "lineStyle": {"normal": {}}}, {"id": "196", "name": null, "source": "66", "target": "58", "lineStyle": {"normal": {}}}, {"id": "197", "name": null, "source": "66", "target": "59", "lineStyle": {"normal": {}}}, {"id": "203", "name": null, "source": "66", "target": "60", "lineStyle": {"normal": {}}}, {"id": "202", "name": null, "source": "66", "target": "61", "lineStyle": {"normal": {}}}, {"id": "198", "name": null, "source": "66", "target": "62", "lineStyle": {"normal": {}}}, {"id": "201", "name": null, "source": "66", "target": "63", "lineStyle": {"normal": {}}}, {"id": "195", "name": null, "source": "66", "target": "64", "lineStyle": {"normal": {}}}, {"id": "199", "name": null, "source": "66", "target": "65", "lineStyle": {"normal": {}}}, {"id": "204", "name": null, "source": "67", "target": "57", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "68", "target": "11", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "68", "target": "24", "lineStyle": {"normal": {}}}, {"id": "205", "name": null, "source": "68", "target": "25", "lineStyle": {"normal": {}}}, {"id": "208", "name": null, "source": "68", "target": "27", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "68", "target": "41", "lineStyle": {"normal": {}}}, {"id": "209", "name": null, "source": "68", "target": "48", "lineStyle": {"normal": {}}}, {"id": "213", "name": null, "source": "69", "target": "11", "lineStyle": {"normal": {}}}, {"id": "214", "name": null, "source": "69", "target": "24", "lineStyle": {"normal": {}}}, {"id": "211", "name": null, "source": "69", "target": "25", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "69", "target": "27", "lineStyle": {"normal": {}}}, {"id": "217", "name": null, "source": "69", "target": "41", "lineStyle": {"normal": {}}}, {"id": "216", "name": null, "source": "69", "target": "48", "lineStyle": {"normal": {}}}, {"id": "212", "name": null, "source": "69", "target": "68", "lineStyle": {"normal": {}}}, {"id": "221", "name": null, "source": "70", "target": "11", "lineStyle": {"normal": {}}}, {"id": "222", "name": null, "source": "70", "target": "24", "lineStyle": {"normal": {}}}, {"id": "218", "name": null, "source": "70", "target": "25", "lineStyle": {"normal": {}}}, {"id": "223", "name": null, "source": "70", "target": "27", "lineStyle": {"normal": {}}}, {"id": "224", "name": null, "source": "70", "target": "41", "lineStyle": {"normal": {}}}, {"id": "225", "name": null, "source": "70", "target": "58", "lineStyle": {"normal": {}}}, {"id": "220", "name": null, "source": "70", "target": "68", "lineStyle": {"normal": {}}}, {"id": "219", "name": null, "source": "70", "target": "69", "lineStyle": {"normal": {}}}, {"id": "230", "name": null, "source": "71", "target": "11", "lineStyle": {"normal": {}}}, {"id": "233", "name": null, "source": "71", "target": "25", "lineStyle": {"normal": {}}}, {"id": "226", "name": null, "source": "71", "target": "27", "lineStyle": {"normal": {}}}, {"id": "232", "name": null, "source": "71", "target": "41", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "71", "target": "48", "lineStyle": {"normal": {}}}, {"id": "228", "name": null, "source": "71", "target": "68", "lineStyle": {"normal": {}}}, {"id": "227", "name": null, "source": "71", "target": "69", "lineStyle": {"normal": {}}}, {"id": "229", "name": null, "source": "71", "target": "70", "lineStyle": {"normal": {}}}, {"id": "236", "name": null, "source": "72", "target": "11", "lineStyle": {"normal": {}}}, {"id": "234", "name": null, "source": "72", "target": "26", "lineStyle": {"normal": {}}}, {"id": "235", "name": null, "source": "72", "target": "27", "lineStyle": {"normal": {}}}, {"id": "237", "name": null, "source": "73", "target": "48", "lineStyle": {"normal": {}}}, {"id": "238", "name": null, "source": "74", "target": "48", "lineStyle": {"normal": {}}}, {"id": "239", "name": null, "source": "74", "target": "73", "lineStyle": {"normal": {}}}, {"id": "242", "name": null, "source": "75", "target": "25", "lineStyle": {"normal": {}}}, {"id": "244", "name": null, "source": "75", "target": "41", "lineStyle": {"normal": {}}}, {"id": null, "name": null, "source": "75", "target": "48", "lineStyle": {"normal": {}}}, {"id": "241", "name": null, "source": "75", "target": "68", "lineStyle": {"normal": {}}}, {"id": "240", "name": null, "source": "75", "target": "69", "lineStyle": {"normal": {}}}, {"id": "245", "name": null, "source": "75", "target": "70", "lineStyle": {"normal": {}}}, {"id": "246", "name": null, "source": "75", "target": "71", "lineStyle": {"normal": {}}}, {"id": "252", "name": null, "source": "76", "target": "48", "lineStyle": {"normal": {}}}, {"id": "253", "name": null, "source": "76", "target": "58", "lineStyle": {"normal": {}}}, {"id": "251", "name": null, "source": "76", "target": "62", "lineStyle": {"normal": {}}}, {"id": "250", "name": null, "source": "76", "target": "63", "lineStyle": {"normal": {}}}, {"id": "247", "name": null, "source": "76", "target": "64", "lineStyle": {"normal": {}}}, {"id": "248", "name": null, "source": "76", "target": "65", "lineStyle": {"normal": {}}}, {"id": "249", "name": null, "source": "76", "target": "66", "lineStyle": {"normal": {}}}]};
//            for (var i = 0; i < 9; i++) {
//                categories[i] = {
//                    name: 'qq' + i
//                };
//            }
//            graph.nodes.forEach(function (node) {
//                node.itemStyle = null;
//                node.value = node.symbolSize;
//                node.symbolSize /= 1.5;
//                node.label = {
//                    normal: {
//                        show: node.symbolSize > 30
//                    }
//                };
//                node.category = node.attributes.modularity_class;
////                console.log(JSON.stringify(node));
//            });
            var option = {
                title: {
                    top: 'bottom',
                    left: 'right'
                },
                tooltip: {},
                legend: [{
                        // selectedMode: 'single',
                        data: categoriesch.map(function (a) {
                            return a.name;
                        })
                    }],
                animationDuration: 1500,
                animationEasingUpdate: 'quinticInOut',
                series: [
                    {
//                        color: [ '#ffb980', '#d87a80', '#b6a2de', '#8d98b3'],                        
                        name: 'Infrastructure',
                        type: 'graph',
                        layout: 'force',
                        force: {
//                            repulsion: 1,
//                            gravity: 0.1,
//                            edgeLength: 0,
//                            layoutAnimation:false,
                            initLayout: 'none',
                            repulsion: 5000,
                            gravity: 0.2
                        },
                        data: datach,
                        links: links,
                        categories: categoriesch,
//                        data: graph.nodes,
//                        links: graph.links,
//                        categories: categories,
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
//            console.log(graph.nodes[1]);
//            console.log(graph.links[1]);
//            console.log(datach[1]);
//            console.log(links[1]);
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