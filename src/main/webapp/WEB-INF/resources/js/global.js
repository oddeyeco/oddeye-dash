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
