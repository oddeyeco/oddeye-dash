/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var test = false;

$(document).ready(function () {
    $("body").on("click", "input", function (event) {
        ga('send', 'event', 'click', $(this).prop("tagName") + " " + $(this).attr("href"));
    });

    $("body").on("click", "a", function (event) {
        ga('send', 'event', 'click', $(this).prop("tagName") + " " + $(this).attr("href"));
    });
});