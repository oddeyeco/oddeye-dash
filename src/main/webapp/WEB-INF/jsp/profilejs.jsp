<!-- morris.js -->
<script src="${cp}/resources/raphael/raphael.min.js"></script>
<script src="${cp}/resources/morris.js/morris.min.js"></script>
<script>
    $(function () {
        Morris.Bar({
            element: 'graph_bar',
            data: [
                {"period": "10", "Hours worked": 80},
                {"period": "20", "Hours worked": 125},
                {"period": "30", "Hours worked": 176},
                {"period": "40", "Hours worked": 224},
                {"period": "50", "Hours worked": 265},
                {"period": "60", "Hours worked": 314},
                {"period": "70", "Hours worked": 347},
                {"period": "80", "Hours worked": 287},
                {"period": "90", "Hours worked": 240},
                {"period": "100", "Hours worked": 211}
            ],
            xkey: 'period',
            hideHover: 'auto',
            barColors: ['#26B99A', '#34495E', '#ACADAC', '#3498DB'],
            ykeys: ['Hours worked', 'sorned'],
            labels: ['Hours worked', 'SORN'],
            xLabelAngle: 60,
            resize: true
        });

        $MENU_TOGGLE.on('click', function () {
            $(window).resize();
        });
    });
</script>
