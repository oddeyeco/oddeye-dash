/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global moment */

var merticdivator = 1000;

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
    'Last 7 day': "7d-ago"
};

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
//TODO DZRTEL
var tmpday = "";
var format_date = function (value) {
    date = moment(value);
    if (tmpday !== date.format("YY/MM/DD"))
    {
        tmpday = date.format("YY/MM/DD");
        return (date.format("HH:mm:ss") + "\n" + date.format("YY/MM/DD"));
    } else
    {
        return (date.format("HH:mm:ss"));
    }
};
var dataBit = function (params) {
    var val = paramtoval(params);
    return (format_data(val)) + "b";
};

var dataBytes = function (params) {
    var val = paramtoval(params);
    return (format_data(val)) + "B";
};

var dataKiB = function (params) {
    var val = paramtoval(params);
    return (dataBytes(val * Math.pow(1024, 1)));
};

var dataMiB = function (params) {
    var val = paramtoval(params);
    return (dataBytes(val * Math.pow(1024, 2)));
};
var dataGiB = function (params) {
    var val = paramtoval(params);
    return (dataBytes(val * Math.pow(1024, 3)));
};

var format_data = function (params) {
    var divatior = 1024;
    var val = paramtoval(params);
    var level = Math.floor(Math.log(val) / Math.log(divatior));
    if (level > 0)
    {
        val = (val / Math.pow(divatior, level));
    }
    switch (level)
    {
        case 1:
        {
            metric = " Ki";
            break;
        }
        case 2:
        {
            metric = " Mi";
            break;
        }
        case 3:
        {
            metric = " Gi";
            break;
        }
        case 4:
        {
            metric = " Ti";
            break;
        }
        case 5:
        {
            metric = " Pi";
            break;
        }
        case 6:
        {
            metric = " Ei";

            break;
        }
        case 7:
        {
            metric = " Zi";
            break;
        }
        case 8:
        {
            metric = " Yi";
            break;
        }
        default:
        {
            metric = "";
            break;
        }
    }
    return val.toFixed(2) + "" + metric;
};

var format100 = function (params) {
    var val = paramtoval(params);
    return val * 100 + " %";
};

var formathexadecimal0 = function (params) {
    var val = paramtoval(params);
    return "0x" + val.toString(16).toUpperCase();
};

var formathexadecimal = function (params) {
    var val = paramtoval(params);
    return val.toString(16).toUpperCase();
};


var formathertz = function (params) {
    return format_metric(params) + "Hz";
};
var timens = function (params) {
    var val = paramtoval(params);
    var divatior = 1000;
    var metric = "ns";
    if (val < 0)
    {
        val = 0;
    }
    if (val > divatior + 1)
    {
        val = val / 1000;
        metric = "µs";
    }

    if (val > divatior + 1)
    {
        val = val / 1000;
        metric = "ms";
    }

    if (val > divatior + 1)
    {
        return format_time(moment.duration(val));
    }

    return val + " " + metric;
};



var timemicros = function (params) {
    var val = paramtoval(params);
    var divatior = 1000;
    var metric = "µs";
    if (val < 0)
    {
        val = 0;
    }
    if (val > divatior + 1)
    {
        val = val / 1000;
        metric = "ms";
    }

    if (val > divatior + 1)
    {
        return format_time(moment.duration(val));
    }

    return val + " " + metric;
};

var timems = function (params) {
    var val = paramtoval(params);
    var divatior = 1000;
    var metric = "ms";
    if (val < 0)
    {
        val = 0;
    }
    if (val > divatior + 1)
    {
        return format_time(moment.duration(val));
    }

    return val + " " + metric;
};

var timesec = function (params) {
    var val = paramtoval(params);
    return format_time(moment.duration(val * 1000));
};

var timemin = function (params) {
    var val = paramtoval(params);
    return format_time(moment.duration(val * 1000 * 60));
};

var timeh = function (params) {
    var val = paramtoval(params);
    return format_time(moment.duration(val * 1000 * 60 * 60));
};

var timed = function (params) {
    var val = paramtoval(params);
    return format_time(moment.duration(val * 1000 * 60 * 60 * 24));
};




var format_time = function (time, base = "s") {
    var val = time.asSeconds();
    if (val < 0)
    {
        val = 0;
    }
    var metric = base;
    var isday = false;
    if (val > 60)
    {
        val = time.asMinutes();
        metric = "min";
    }

    if (val > 60)
    {
        val = time.asHours();
        metric = "h";
    }
    //TODO FOX week konvert
    if (val > 24)
    {
        val = time.asDays();
        metric = "day";
        var isday = true;
    }
    if (isday)
    {
        if (val > 7)
        {
            val = time.asWeeks();
            metric = "week";
        }
        if (val > 31)
        {
            val = time.asMonths();
            metric = "month";
        }

        if (val > 12)
        {
            val = time.asYears();
            metric = "year";
        }
    }
    return val.toFixed(1) + " " + metric;
};

var dataBitmetric = function (params) {
    var val = paramtoval(params);
    return (format_metric(val)) + "b";
};

var dataBytesmetric = function (params) {
    var val = paramtoval(params);
    return (format_metric(val)) + "B";
};

var dataKiBmetric = function (params) {
    var val = paramtoval(params);
    return (dataBytesmetric(val * Math.pow(1000, 1)));
};

var dataMiBmetric = function (params) {
    var val = paramtoval(params);
    return (dataBytesmetric(val * Math.pow(1000, 2)));
};

var dataGiBmetric = function (params) {
    var val = paramtoval(params);
    return (dataBytesmetric(val * Math.pow(1000, 3)));
};

var formatPpS = function (params) {
    var val = paramtoval(params);
    return (format_metric(val)) + "PpS";
};

var formatbpS = function (params) {
    var val = paramtoval(params);
    return (format_metric(val)) + "bpS";
};
var formatBpS = function (params) {
    var val = paramtoval(params);
    return (format_metric(val)) + "BpS";
};
var formatKbpS = function (params) {
    var val = paramtoval(params);
    return (formatbpS(val * Math.pow(1000, 1)));
};
var formatMbpS = function (params) {
    var val = paramtoval(params);
    return (formatbpS(val * Math.pow(1000, 2)));
};
var formatGBbpS = function (params) {
    var val = paramtoval(params);
    return (formatbpS(val * Math.pow(1000, 3)));
};

var formatKBpS = function (params) {
    var val = paramtoval(params);
    return (formatBpS(val * Math.pow(1000, 1)));
};
var formatMBpS = function (params) {
    var val = paramtoval(params);
    return (formatBpS(val * Math.pow(1000, 2)));
};
var formatGBpS = function (params) {
    var val = paramtoval(params);
    return (formatBpS(val * Math.pow(1000, 3)));
};

var formatops = function (params) {
    return (format_metric(params)) + " ops";
};
var formatrps = function (params) {
    return (format_metric(params)) + " rps";
};
var formatwps = function (params) {
    return (format_metric(params)) + " wsp";
};
var formatiops = function (params) {
    return (format_metric(params)) + " iops";
};
var formatopm = function (params) {
    return (format_metric(params)) + " opm";
};
var formatrpm = function (params) {
    return (format_metric(params)) + " rpm";
};
var formatwpm = function (params) {
    return (format_metric(params)) + " wpm";
};

var formatm = function (params) {
    return (format_metric(params)) + "m";
};

var formatkm = function (params) {
    return (format_metric(paramtoval(params) * 1000)) + "m";
};

var formatmm = function (params) {
    return (format_metric(paramtoval(params) * Math.pow(10, -3))) + "m";
};
var formatmL = function (params) {
    return (formatL(paramtoval(params) * Math.pow(10, -1)));
};
var formatL = function (params) {
    return (format_metric(params, "v")) + "L";
};

var formatm3 = function (params) {
    return (format_metric(params, "v")) + "m3";
};
var formatW = function (params) {
    return (format_metric(params)) + "W";
};
var formatKW = function (params) {
    return (formatW(paramtoval(params) * 1000));
};

var formatVA = function (params) {
    return (format_metric(params)) + "VA";
};
var formatKVA = function (params) {
    return (formatVA(paramtoval(params) * 1000));
};

var formatVAR = function (params) {
    return (format_metric(params)) + "var";
};

var formatVH = function (params) {
    return (format_metric(params)) + "Wh";
};

var formatKWH = function (params) {
    return (formatVH(paramtoval(params) * 1000));
};

var formatJ = function (params) {
    return (format_metric(params)) + "J";
};

var formatEV = function (params) {
    return (format_metric(params)) + "eV";
};

var formatA = function (params) {
    return (format_metric(params)) + "A";
};

var formatV = function (params) {
    return (format_metric(params)) + "V";
};

var formatpsi = function (params) {
    return (format_metric(params)) + "psi";
};

var format_metric = function (params, type = "m") {
    var divatior = 10;
    var val = paramtoval(params);
    var metric = " ";
    if (val !== 0)
    {
        var level = Math.floor(Math.log(val) / Math.log(divatior));
        if ((level > 1) || (level < 0))
        {            
//            if (type === "v")
//            {
//                level = level - 2;
//            }
        }
        
        
        if (level < -9)
        {
            val = (val / Math.pow(divatior, level));
            level = -9;
        }
        if (level > 26)
        {
            val = (val / Math.pow(divatior, level));
            level = 26;
        }
        switch (level)
        {
            case -1:
            {
                val = (val / Math.pow(divatior, level));
                metric = " d";
                break;
            }
            case -2:
            {
                val = (val / Math.pow(divatior, level));
                metric = " c";
                break;
            }
            case - 3:
            case - 4:
            case -5:
            {
                val = (val / Math.pow(divatior, -3));
                metric = " m";
                break;
            }
            case - 6:
            case - 7:
            case -8:
            {
                val = (val / Math.pow(divatior, -6));
                metric = " μ";
                break;
            }
            case -9:
            {
                val = (val / Math.pow(divatior, level));
                metric = " n";
                break;
            }           
            case 3:
            case 4:
            case 5:
            {
                val = (val / Math.pow(divatior, 3));
                metric = " k";
                break;
            }
            case 6:
            case 7:
            case 8:
            {
                val = (val / Math.pow(divatior, 6));
                metric = " M";
                break;
            }
            case 9:
            case 10:
            case 11:
            {
                val = (val / Math.pow(divatior, 9));
                metric = " G";
                break;
            }
            case 12:
            case 13:
            case 14:
            {
                val = (val / Math.pow(divatior, 12));
                metric = " T";
                break;
            }
            case 15:
            case 16:
            case 17:
            {
                val = (val / Math.pow(divatior, 15));
                metric = " P";
                break;
            }
            case 18:
            case 19:
            case 20:
            {
                val = (val / Math.pow(divatior, 18));
                metric = " E";
                break;
            }
            case 21:
            case 22:
            case 23:
            {
                val = (val / Math.pow(divatior, 21));
                metric = " Z";
                break;
            }
            case 24:
            case 25:
            case 26:
            {
                val = (val / Math.pow(divatior, 24));
                metric = " Y";
                break;
            }
            default:
            {
                val = (val / Math.pow(divatior, level));
                metric = " ";
                break;
            }
        }
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
        if (key == "echartLine")
        {
            continue;
        }
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
            obj['isActiveClone'] = null;
            temp[key] = clone_obg(obj[key]);
            delete obj['isActiveClone'];
        }
    }

    return temp;
}
;

function paramtoval(params)
{
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
    return val;
}
;

