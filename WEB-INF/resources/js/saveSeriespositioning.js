/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var radius = (100 / Object.keys(tmp_series_1).length);

if (radius < 25)
{
    radius = 25;
}

var rows = Math.floor((Object.keys(tmp_series_1).length / 4)) + 1;

var wr = radius * chart._dom.getBoundingClientRect().width / 100;
var hr = radius * chart._dom.getBoundingClientRect().height / 100;



index = 1;
var row = 0;

if (index > 4)
{
    index = 1;
    row++;
}
//******************gauge***********************

var tmpradius = radius;
if (hr < wr)
{
    var tmpradius = radius + radius / 2;
}
if (tmpradius > 100)
    tmpradius = 95;
if (!widget.manual)
{
    series.radius = tmpradius - 3 + "%";
    if (hr < wr)
    {
        series.center = [index * radius - radius / 2 + '%', (row * tmpradius) + tmpradius / 2 + "%"];
    } else
    {
        series.center = [index * radius - radius / 2 + '%', wr * row + wr / 2];
    }
}
//******************pie***********************


if (!widget.manual)
{
    series.radius = radius - 3 + "%";

    if (Object.keys(tmp_series_1).length === 1)
    {

    } else
    {
        if (hr < wr)
        {
            series.center = [index * radius - radius / 2 + '%', ((row + 1) * radius) + "%"];
        } else
        {
            series.center = [index * radius - radius / 2 + '%', wr * row + wr / 2];
        }
    }
}
//******************funnel***********************
delete series.axisLine;
delete series.max;
delete series.min;
delete series.radius;
delete series.center;

if (row !== 1)
{
    if (!series.sort)
    {
        series.sort = 'ascending';
    }

}

if (!widget.manual)
{
    series.width = radius - 5 + "%";
    series.height = 100 / rows - 5 + "%";
    series.x = index * radius - radius + '%';
    series.y = (row * 50 + 2.5) + "%";

}