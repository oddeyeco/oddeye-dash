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

//$(document).ready(function () {
//    $SIDEBAR_MENU.find('li.active-sm ul').show();
//    $SIDEBAR_MENU.find('li.active-sm').addClass('active').removeClass('active-sm');
//    $BODY.toggleClass('nav-md nav-sm');
//});


//setContentHeight();