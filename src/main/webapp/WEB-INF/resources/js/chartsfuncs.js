/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var merticdivator = 1000;
var bytedivator = 1024;

var pickerstart;
var pickerend;
var pickerlabel = "Last 5 minutes";

var rangeslabels = {
    'Last 5 minutes': "5m-ago",
    'Last 15 minutes': "15m-ago",
    'Last 30 minutes': "30m-ago",
    'Last 1 hour': "1h-ago",
    'Last 3 hour': "3h-ago",
    'Last 6 hour': "6h-ago",
    'Last 12 hour': "12h-ago",
    'Last 1 day': "24h-ago",
    'Last 7 day': "7d-ago",
}

var PicerOptionSet1 = {
    startDate: moment().subtract(5, 'minute'),
    endDate: moment(),
    minDate: moment().subtract(1, 'year'),
    maxDate: moment().add(1, 'days'),
    dateLimit: {
        days: 60
    },
    showDropdowns: true,
    showWeekNumbers: true,
    timePicker: true,
    timePickerIncrement: 15,
    timePicker12Hour: true,
    ranges: {
        'Last 5 minutes': [moment().subtract(5, 'minute'), moment()],
        'Last 15 minutes': [moment().subtract(15, 'minute'), moment()],
        'Last 30 minutes': [moment().subtract(30, 'minute'), moment()],
        'Last 1 hour': [moment().subtract(1, 'hour'), moment()],
        'Last 3 hour': [moment().subtract(3, 'hour'), moment()],
        'Last 6 hour': [moment().subtract(6, 'hour'), moment()],
        'Last 12 hour': [moment().subtract(12, 'hour'), moment()],
        'Last 1 day': [moment().subtract(24, 'hour'), moment()],
        'Last 7 day': [moment().subtract(7, 'day'), moment()]
    },
    opens: 'left',
    buttonClasses: ['btn btn-default'],
    applyClass: 'btn-small btn-primary',
    cancelClass: 'btn-small',
    format: 'MM/DD/YYYY H:m:s',
    separator: ' to ',
    locale: {
        applyLabel: 'Submit',
        cancelLabel: 'Clear',
        fromLabel: 'From',
        toLabel: 'To',
        customRangeLabel: 'Custom',
        daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        firstDay: 1
    }
};

var cb = function (start, end, label) {
    pickerstart = start;
    pickerend = end;
    pickerlabel = label;

    if (pickerlabel === "Custom")
    {
        $('#reportrange span').html(start.format('MM/DD/YYYY H:m:s') + ' - ' + end.format('MM/DD/YYYY H:m:s'));
    } else
    {
        $('#reportrange span').html(pickerlabel);
    }
};


var format_func = function (params) {
    divatior = bytedivator;
    if (isNaN(params))
    {
        if (isNaN(params.value))
        {
            val = 0;
        } else
        {
            val = params.value;
        }
    } else
    {
        val = params;
    }
    metric = "";
    if (val > divatior - 1)
    {
        metric = "K";
        val = val / divatior;
    }
    if (val > divatior - 1)
    {
        metric = "M";
        val = val / divatior;
    }
    if (val > divatior - 1)
    {
        metric = "G";
        val = val / divatior;
    }
    return val.toFixed(2) + "" + metric;
};

function clone_obg(obj) {
    if (obj === null || typeof (obj) !== 'object' || 'isActiveClone' in obj)
        return obj;

    if (obj instanceof Date)
        var temp = new obj.constructor(); //or new Date(obj);
    else
        var temp = obj.constructor();

    for (var key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
            obj['isActiveClone'] = null;
            temp[key] = clone_obg(obj[key]);
            delete obj['isActiveClone'];
        }
    }

    return temp;
}


