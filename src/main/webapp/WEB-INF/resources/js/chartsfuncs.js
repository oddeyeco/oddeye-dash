/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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
//TODO DZRTEL
var tmpday = ""
var format_date = function (value) {
    date = moment(value);
    if (tmpday != date.format("YY/MM/DD"))
    {
        tmpday = date.format("YY/MM/DD");
        return (date.format("HH:mm:ss") + "\n" + date.format("YY/MM/DD"));
    } else
    {
        return (date.format("HH:mm:ss"));
    }


}
var dataBit = function (params) {
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
    return (format_data(val)) + "b";
}

var dataBytes = function (params) {
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
    return (format_data(val)) + "B";
}

var dataKiB = function (params) {
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
    return (dataBytes(val * Math.pow(1024, 1)));
}

var dataMiB = function (params) {
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
    return (dataBytes(val * Math.pow(1024, 2)));
}
var dataGiB = function (params) {
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
    return (dataBytes(val * Math.pow(1024, 3)));
}

var format_data = function (params) {
    divatior = 1024;
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

    var level = Math.floor(Math.log(val) / Math.log(divatior))
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
    return val * 100 + " %";
}

var formathexadecimal0 = function (params) {
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
    return "0x" + val.toString(16).toUpperCase();
}

var formathexadecimal = function (params) {
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
    return val.toString(16).toUpperCase();
}


var formathertz = function (params) {
    return format_metric(params) + "Hz";
}
var timens = function (params) {
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
    divatior = 1000;
    metric = "ns";
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
}



var timemicros = function (params) {
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
    divatior = 1000;
    metric = "µs";

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
}

var timems = function (params) {
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
    divatior = 1000;
    metric = "ms";

    if (val > divatior + 1)
    {
        return format_time(moment.duration(val));
    }

    return val + " " + metric;
}

var timesec = function (params) {
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
    return format_time(moment.duration(val * 1000));
}

var timemin = function (params) {
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
    return format_time(moment.duration(val * 1000 * 60));
}

var timeh = function (params) {
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
    return format_time(moment.duration(val * 1000 * 60 * 60));
}

var timed = function (params) {
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
    return format_time(moment.duration(val * 1000 * 60 * 60 * 24));
}




var format_time = function (time, base = "s") {
    val = time.asSeconds();
    metric = base;
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
    if (val > 24)
    {
        val = time.asDays();
        metric = "day";
    }

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

    return val.toFixed(1) + " " + metric;
}

var dataBitmetric = function (params) {
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
    return (format_metric(val)) + "b";
}

var dataBytesmetric = function (params) {
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
    return (format_metric(val)) + "B";
}

var dataKiBmetric = function (params) {
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
    return (dataBytesmetric(val * Math.pow(1000, 1)));
}

var dataMiBmetric = function (params) {
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
    return (dataBytesmetric(val * Math.pow(1000, 2)));
}
var dataGiBmetric = function (params) {
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
    return (dataBytesmetric(val * Math.pow(1000, 3)));
}


var format_metric = function (params) {
    divatior = 1000;
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
    metric = " ";
    if (val != 0)
    {
        var level = Math.floor(Math.log(val) / Math.log(divatior))
        if (level > 0)
        {
            val = (val / Math.pow(divatior, level));
        }
        switch (level)
        {
            case 1:
            {
                metric = " k";
                break;
            }
            case 2:
            {
                metric = " M";
                break;
            }
            case 3:
            {
                metric = " G";
                break;
            }
            case 4:
            {
                metric = " T";
                break;
            }
            case 5:
            {
                metric = " P";
                break;
            }
            case 6:
            {
                metric = " E";

                break;
            }
            case 7:
            {
                metric = " Z";
                break;
            }
            case 8:
            {
                metric = " Y";
                break;
            }
            default:
            {
                metric = "";
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
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
            obj['isActiveClone'] = null;
            temp[key] = clone_obg(obj[key]);
            delete obj['isActiveClone'];
        }
    }

    return temp;
}


