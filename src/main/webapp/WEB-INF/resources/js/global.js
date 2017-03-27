/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function compareStrings(a, b) {
    // Assuming you want case-insensitive comparison
    a = a.toLowerCase();
    b = b.toLowerCase();
    return (a < b) ? -1 : (a > b) ? 1 : 0;
}

function compareMetric(a, b, tagident) {
    var _aname = a.info.name.toLowerCase();
    var _bname = b.info.name.toLowerCase();
    var _atag = a.info.tags[tagident].value.toLowerCase();
    var _btag = b.info.tags[tagident].value.toLowerCase();
    var _atime = a.time;
    var _btime = b.time;
//    return ((_aname < _bname) && (_atag < _btag) && (_atime < _btime)) ? -1 : ((_aname > _bname) && (_atag > _btag) && (_atime > _btime)) ? 1 : 0;
//    if (_atag == _btag)
//    {
//        console.log;
//    }
    return ((_atag < _btag)) ? -1 : ((_atag > _btag)) ? 1 : (((_aname < _bname)) ? -1 : ((_aname > _bname)) ? 1 : 0);
}

function exportToCsv(filename, rows) {
    var processRow = function (row) {
        var finalVal = '';
        for (var j = 0; j < row.length; j++) {
            var innerValue = row[j] === null ? '' : row[j].toString();
            if (row[j] instanceof Date) {
                innerValue = row[j].toLocaleString();
            }
            ;
            var result = innerValue.replace(/"/g, '""');
            if (result.search(/("|,|\n)/g) >= 0)
                result = '"' + result + '"';
            if (j > 0)
                finalVal += ',';
            finalVal += result;
        }
        return finalVal + '\n';
    };

    var csvFile = '';
    for (var i = 0; i < rows.length; i++) {
        csvFile += processRow(rows[i]);
    }

    var blob = new Blob([csvFile], {type: 'text/csv;charset=utf-8;'});
    if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, filename);
    } else {
        var link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
            // Browsers that support HTML5 download attribute
            var url = URL.createObjectURL(blob);
            link.setAttribute("href", url);
            link.setAttribute("download", filename);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }
}