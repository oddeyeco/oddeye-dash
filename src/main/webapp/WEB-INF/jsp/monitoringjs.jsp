<script>
    var headerName = "${_csrf.headerName}";
    var token = "${_csrf.token}";
    var sotoken = ${_sotoken};
    var uuid = "${curentuser.getId()}";
    var filterJson = ${curentuser.getDefaultFilter()};
</script> 
<script src="${cp}/assets/js/socket/dist/sockjs-1.1.1.js"></script> 
<script src="${cp}/assets/js/socket/stomp.js"></script>
<script src="${cp}/resources/switchery/dist/switchery.min.js"></script>
<script src="${cp}/resources/devbridge-autocomplete/dist/jquery.autocomplete.min.js"></script>
<script src="${cp}/resources/js/chartsfuncs.js"></script>
<script src="${cp}/resources/js/monitoring.js"></script>
<script src="${cp}/resources/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="${cp}/resources/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>

<script>
    var datatable;

    function Jsontoraw(json)
    {
        this.json = json;
        this.hash = json.hash;        
        this.index = 0;
        this.class = "level_" + json.level;
        var html;
        if (json.isspec === 0)
        {
            html = '<input type="checkbox" class="rawflat"><div class="fa-div"> <a href="' + cp + '/chart/' + json.hash + '" target="_blank"><i class="fa fa-area-chart"></i></a></div>';
        } else
        {
            html = '<i class="fa fa-bell" style="color:red; font-size: 18px;"></i>';
        }
        this.type = html;
        this.level = "<div>" + json.levelname + "</div>";
        this.name = json.info.name;
        this.showtags = json.info.tags[$("select#ident_tag").val()].value;
        var message = "";
        if (json.isspec === 1)
        {
            message = json.message;
        } else
        {
            var val = 0;
            var count = 0;
            for (var key in json.values)
            {
                val = val + json.values[key].value;
                count++;
            }
            val = val / count;
            if (val > 1000)
            {
                val = format_metric(json.values[key].value);
            } else
            {
                val = val.toFixed(2);
            }
//            message = message + "<span class='pull-left' >" + val + "</span>";
            message = message + val;
        }

        this.info = message;
        this.lasttime = "";
        if (typeof (json.time) !== "undefined")
        {
            this.lasttime = moment(json.time * 1).format(timeformatsmall);
            this.lastTS = json.time * 1;
        }
        this.starttime = moment(json.starttimes[json.level] * 1).format(timeformat);
//        this.lasttime = "lasttime";

    }
    $(document).ready(function () {
        datatable = $('#monitoring').DataTable({
            "order": [[0, "asc"], [3, "asc"], [2, "asc"], [6, "asc"]],
            "displayLength": 25,
            columns: [
                {data: 'type', className: 'icons', "aria-label": 'type'},
                {data: 'level', className: 'level'},
                {data: 'name', className: 'name'},
                {data: 'showtags', className: 'showtags'},
                {data: 'info', className: 'message'},
                {data: 'starttime', className: 'starttime'},
                {data: 'lasttime', className: 'lasttime'}
            ],
            "drawCallback": function (settings) {
                var api = this.api();
                var rows = api.rows({page: 'current'}).nodes();               
                $(rows).find("input.rawflat").iCheck({
                    checkboxClass: 'icheckbox_flat-green',
                    radioClass: 'iradio_flat-green'
                });
            },
            "rowCallback": function (row, data, index) {
                $(row).addClass(data.class);
                $(row).attr('id', data.hash);
            }
        });
    }
    );
</script>

