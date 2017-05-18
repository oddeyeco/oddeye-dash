<%@ page pageEncoding="UTF-8" %>
<div class="hidden" id="rowtemplate">
    <div class="raw widgetraw x_content">
        <div class="btn-group rawButton">
            <!--<a type="button" class="btn btn-danger">Actions</a>-->
            <a type="button" class="btn btn-danger dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                <span class="caret"></span>
                <span class="sr-only">Toggle Dropdown</span>
            </a>
            <ul class="dropdown-menu" role="menu">
                <li><a href="javascript:void(0)" class="addchart">Add chart widget</a>
                <li class="divider"></li>
                <li><a href="javascript:void(0)" class="showrowjson">Show JSON</a>
                <li class="divider"></li>                
                <li><a href="javascript:void(0)" class="deleterow">Delete</a>    
                </li>
            </ul>
        </div>  
        <div class="rowcontent raw">
        </div>        
    </div>
</div>  

<div class="hidden" id="charttemplate">
    <div class="col-lg-12 chartsection" size="12">
        <div>            
            <div class="controls text-center">
                <div class="echart_time pull-left"></div>
                <div class="btn-group  btn-group-xs">
                    <a class="btn btn-default view" type="button">View</a>
                    <a class="btn btn-default editchart" type="button">Edit</a>
                    <a class="btn btn-default dublicate" type="button">Duplicate</a>               
                    <a class="btn btn-default csv" type="button">asCsv</a>
                    <a class="btn btn-default plus" type="button"><i class="fa fa-plus"></i></a>
                    <a class="btn btn-default minus" type="button"><i class="fa fa-minus"></i></a>
                    <a class="btn btn-default deletewidget" type="button"><i class="fa fa-trash"></i></a>
                </div> 
            </div>             
            <div class="echart_line" style="height:300px;"></div>                   
        </div>

    </div>   
</div>  


<div class="x_panel dash_main">
    <div class="filter">

        <div class="form-group-custom pull-left form-horizontal">
            <label class="control-label control-label-top" for="global-down-sample">Down sample 
            </label>
            <input id="global-down-sample" name="global-down-sample" class="form-control query_input" type="text">
            <label class="control-label control-label-top" for="global-down-sample-ag">Aggregator: 
            </label>        
            <select id="global-down-sample-ag" name="global-down-sample-ag" class="form-control query_input">
                <option label="avg" value="avg">avg</option>
                <option label="count" value="count">count</option>
                <option label="dev" value="dev">dev</option>
                <option label="ep50r3" value="ep50r3">ep50r3</option>
                <option label="ep50r7" value="ep50r7">ep50r7</option>
                <option label="ep75r3" value="ep75r3">ep75r3</option>
                <option label="ep75r7" value="ep75r7">ep75r7</option>
                <option label="ep90r3" value="ep90r3">ep90r3</option>
                <option label="ep90r7" value="ep90r7">ep90r7</option>
                <option label="ep95r3" value="ep95r3">ep95r3</option>
                <option label="ep95r7" value="ep95r7">ep95r7</option>
                <option label="ep999r3" value="ep999r3">ep999r3</option>
                <option label="ep999r7" value="ep999r7">ep999r7</option>
                <option label="ep99r3" value="ep99r3">ep99r3</option>
                <option label="ep99r7" value="ep99r7">ep99r7</option>
                <option label="first" value="first">first</option>
                <option label="last" value="last">last</option>
                <option label="max" value="max">max</option>
                <option label="mimmax" value="mimmax">mimmax</option>
                <option label="mimmin" value="mimmin">mimmin</option>
                <option label="min" value="min">min</option>
                <option label="mult" value="mult">mult</option>
                <option label="none" value="none">none</option>
                <option label="p50" value="p50">p50</option>
                <option label="p75" value="p75">p75</option>
                <option label="p90" value="p90">p90</option>
                <option label="p95" value="p95">p95</option>
                <option label="p99" value="p99">p99</option>
                <option label="p999" value="p999">p999</option>
                <option label="sum" value="sum">sum</option>
                <option label="zimsum" value="zimsum">zimsum</option>
            </select>        

            <label class="control-label control-label-top" for="global-downsampling-switsh">
                Disable downsampling
            </label>
            <div class="checkbox" style="display: inline-block">
                <input type="checkbox" class="js-switch-general" chart_prop_key="" id="global-downsampling-switsh" name="global-downsampling-switsh" /> 
            </div>        
        </div>          


        <div id="refresh" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">                        
            <i class="glyphicon glyphicon-refresh"></i>
        </div>
        <div id="refresh_wrap" class="pull-right" >
            <select id="refreshtime" name="refreshtime" class="select2-hidden-accessible" style="width: 150px">
                <option value="" selected>Refresh Off</option>
                <option value="5000">Refresh every 5s</option>
                <option value="10000">Refresh every 10s</option>
                <option value="30000">Refresh every 30s</option>
                <option value="60000">Refresh every 1m</option>
                <option value="300000">Refresh every 5m</option>
                <option value="900000">Refresh every 15m</option>
                <option value="1800000">Refresh every 30m</option>
                <option value="3600000">Refresh every 1h</option>
                <option value="7200000">Refresh every 2h</option>
                <option value="86400000">Refresh every 1d</option>                
            </select>            
        </div>

        <div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
            <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
            <span></span> <b class="caret"></b>
        </div>     
    </div>  
</div>

<div class="x_panel fulldash" style="display: none">
    <div class="x_title dash_action">
        <h2 class="col-md-3" ><input type="text" name="name" id="name" value="${dashname}"></h2>        
        <div class="pull-right"> 
            <div class="btn-toolbar"> 

                <div class="btn-group">
                    <a class="btn btn-default" type="button" id="showasjson">Show as JSON</a>
                </div>
                <div class="btn-group">

                    <a class="btn btn-primary" type="button" id="addrow">Add Row</a>
                </div>
                <!--            <div class="btn-group">
                
                                <a class="btn btn-primary savedash" type="button">Save</a>
                            </div>-->
                <div class="btn-group">
                    <button type="button" class="btn btn-primary savedash">Save</button>
                    <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        <span class="caret"></span>
                        <span class="sr-only"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a class="savedashasTemplate">Save As Template </a>
                        </li>
                    </ul>
                </div>            

                <div class="btn-group">
                    <a class="btn btn-danger deletedash" type="button">Delete </a>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
    </div>        
    <div class="x_content" id="dashcontent">        

    </div>
</div>
<jsp:include page="queryForm.jsp" />
<div class="x_panel editchartpanel" style="display: none">
    <div class="x_title dash_action">
        <h1 class="col-md-3">Edit Chart</h1>              
        <div class="pull-right">
            <a class="btn btn-primary savedash" type="button">Save </a>
            <a class="btn btn-primary backtodush" type="button">Back to Dash </a>
        </div>
        <div class="clearfix"></div>
    </div>
    
    <div class="x_content" id="dashcontent"> 
    </div>
    <div class="x_content" id="singlewidget">      
        <div class="echart_line_single" id="echart_line_single" style="height:600px;"></div>                   
    </div>   

    <div class="x_content edit-form">
        <div class="pull-right tabcontrol">  
            <label class="control-label" >
                JSON Manual Edit:
            </label>
            <div class="checkbox" style="display: inline-block">
                <input type="checkbox" class="js-switch-small"  chart_prop_key="manual" id="manual" name="manual" /> 
            </div>            
            <!--<a class="btn btn-success savetemplate" type="button">Save as Template </a>-->
        </div>
        <div class="" role="tabpanel" data-example-id="togglable-tabs">
            <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">
                <li role="presentation" class="active"><a href="#tab_general" id="general-tab" role="tab" data-toggle="tab" aria-expanded="true">General</a>
                </li>
                <li role="presentation" class=""><a href="#tab_metrics" role="tab" id="metrics-tab" data-toggle="tab" aria-expanded="false">Metrics</a>
                </li>
                <li role="presentation" class=""><a href="#tab_axes" role="tab" id="axes-tab" data-toggle="tab" aria-expanded="false">Axes</a>
                </li>
                <li role="presentation" class=""><a href="#tab_legend" role="tab" id="legend-tab" data-toggle="tab" aria-expanded="false">Legend</a>
                </li>                
                <li role="presentation" class=""><a href="#tab_display" role="tab" id="display-tab" data-toggle="tab" aria-expanded="false">Display</a>
                </li>                                
                <li role="presentation" class=""><a href="#tab_times" role="tab" id="time-tab" data-toggle="tab" aria-expanded="false">Time Range</a>
                </li>                                                
                <li role="presentation" class=""><a href="#tab_json" role="tab" id="json-tab" data-toggle="tab" aria-expanded="false">Json</a>
                </li>                
            </ul>
            <div id="myTabContent" class="tab-content" >                
                <div role="tabpanel" class="tab-pane fade active in" id="tab_general" aria-labelledby="general-tab">                        
                    <div class="row">
                        <form class="form-horizontal form-label-left edit-title pull-left" >                            
                            <div class="form_main_block " >
                                <h3>
                                    <label class="control-label" >
                                        Info
                                    </label>
                                    <div class="checkbox" style="display: inline-block">
                                        <input type="checkbox" class="js-switch-small" checked ="checked " chart_prop_key="show" id="title_show" name="title_show" /> 
                                    </div>
                                </h3>
                                <div class="form-group form-group-custom">
                                    <label for="title_text" class="control-label control-label-custom">
                                        Title
                                    </label>
                                    <input chart_prop_key="text" id="title_text" name="title_text" type="text" class="form-control title_input_large">
                                    <i class="dropdown_button fa fa-chevron-circle-down" id='button_title_subtitle' ></i>

                                    <div id='title_subtitle' class='form-group form-group-custom' style="display: none;">
                                        <label for="title_link" class="control-label control-label-custom" >
                                            Link
                                        </label>
                                        <input chart_prop_key="link" id="title_link" name="title_link" type="text" class="form-control title_input" >
                                        <label for="title_target" class="control-label control-label-custom2" >
                                            Target
                                        </label>                                 
                                        <select id="title_target" chart_prop_key="target" name="title_target" class="form-control title_select">
                                            <option selected>&nbsp;</option>
                                            <option value="self">Self</option>
                                            <option value="blank">Blank</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group form-group-custom">
                                    <label for="title_subtext" class="control-label control-label-custom"  >
                                        Description
                                    </label>
                                    <input chart_prop_key="subtext" id="title_subtext" name="title_subtext" type="text" class="form-control title_input_large">
                                    <i class="dropdown_button fa fa-chevron-circle-down" id='button_title_description' ></i>
                                    <div id='title_subdescription' class='form-group form-group-custom' style="display: none;">
                                        <label for="title_sublink" class="control-label control-label-custom">
                                            Link
                                        </label>
                                        <input chart_prop_key="sublink" id="title_sublink" name="title_sublink" type="text" class="form-control title_input">
                                        <label for="title_subtarget" class="control-label control-label-custom2">
                                            Target
                                        </label>                                 
                                        <select id="title_subtarget" chart_prop_key="subtarget" name="title_subtarget" class="form-control title_select">
                                            <option selected>&nbsp;</option>
                                            <option value="self">Self</option>
                                            <option value="blank">Blank</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div id="buttons_div">
                                        <button type="button" id="button_title_position" class="btn btn-primary btn-xs">Positions <i class="fa fa-chevron-circle-down"></i></button>
                                        <button type="button" id="button_title_color" class="btn btn-primary btn-xs">Colors <i class="fa fa-chevron-circle-down"></i></button>
                                        <button type="button" id="button_title_border" class="btn btn-primary btn-xs">Border <i class="fa fa-chevron-circle-down"></i></button>
                                    </div>
                                </div>
                                <div id="position_block" style="display: none;">
                                    <div class="form-group form-group-custom">
                                        <label for="title_x_position" class="control-label control-label-custom" >
                                            X
                                        </label>
                                        <select id="title_x_position" chart_prop_key="x" name="title_x_position" class="form-control title_select" >
                                            <option selected value="">&nbsp;</option>
                                            <option value="center">Center</option>
                                            <option value="left">Left</option>
                                            <option value="right">Right</option>
                                        </select>
                                        <label class="control-label control-label-custom3 control_label_or" >
                                            OR
                                        </label>
                                        <input id="title_x_position_text" chart_prop_key="x" name="title_x_position_text" type="number" class="form-control title_input_small" >
                                        <label class="control-label control-label-custom3" >
                                            px
                                        </label>
                                        <label for="title_y_position" class="control-label control-label_Y" >
                                            Y
                                        </label> 
                                        <select id="title_y_position" chart_prop_key="y" name="title_y_position" class="form-control title_select" >
                                            <option selected value="">&nbsp;</option>
                                            <option value="center">Center</option>
                                            <option value="top">Top</option>
                                            <option value="bottom">Bottom</option>
                                        </select>
                                        <label class="control-label control-label-custom3 control_label_or" >
                                            OR
                                        </label>

                                        <input id="title_y_position_text" chart_prop_key="y" name="title_y_position_text" type="number" class="form-control title_input_small" >
                                        <label class="control-label control-label-custom3" >
                                            px
                                        </label>
                                    </div>

                                </div>
                                <div id="color_block" style="display: none;">
                                    <div class="form-group form-group-custom">
                                        <label for="title_border_color" class="control-label control-label-custom" >
                                            Border
                                        </label>    
                                        <div class="titile_input_midle">                                                                                                     
                                            <div class="input-group cl_picer cl_picer_input">                            
                                                <input id="title_border_color" name="title_border_color" chart_prop_key="borderColor" type="text" value="" class="form-control" >
                                                <span class="input-group-addon"><i></i></span>
                                            </div>                                
                                        </div>    
                                        <label for="title_background_color" class="control-label control-label-custom" >
                                            Background
                                        </label>
                                        <div class="titile_input_midle">
                                            <div class="input-group cl_picer cl_picer_input" >                            
                                                <input id="title_background_color" chart_prop_key="backgroundColor" name="title_background_color" type="text" value="" class="form-control" >
                                                <span class="input-group-addon"><i></i></span>
                                            </div>                                
                                        </div> 
                                    </div>
                                </div>
                                <div id="border_block" style="display: none;">
                                    <label for="title_border_color" class="control-label control-label-custom">
                                        Color
                                    </label>
                                    <div class="titile_input_midle">                                                                                                     
                                        <div class="input-group cl_picer cl_picer_input">                            
                                            <input id="title_border_color" name="title_border_color" chart_prop_key="borderColor" type="text" value="" class="form-control" >
                                            <span class="input-group-addon"><i></i></span>
                                        </div>                                
                                    </div>                              

                                    <label for="title_border_width" class="control-label control-label2">
                                        Width
                                    </label>
                                    <div class="titile_input_midle2">
                                        <div class="input-group" >   
                                            <input id="title_border_width" chart_prop_key="borderWidth" name="title_border_width" type="number" value="" class="form-control titile_input_midle">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <form class="form-horizontal form-label-left edit-dimensions pull-left">
                            <div id="form_main_block" class="form_main_block">
                                <h3><label class="control-label" >
                                        Dimensions
                                    </label></h3>

                                <div class="form-group form-group-custom">
                                    <label for="dimensions_span" class="control-label control-label-custom">
                                        Span
                                    </label>

                                    <select id="dimensions_span" chart_prop_key="y" name="dimensions_span" class="form-control dimensions_input" >
                                        <option value=1>1</option>
                                        <option value=2>2</option>
                                        <option value=3>3</option>
                                        <option value=4>4</option>
                                        <option value=5>5</option>
                                        <option value=6>6</option>
                                        <option value=7>7</option>
                                        <option value=8>8</option>
                                        <option value=9>9</option>
                                        <option value=10>10</option>
                                        <option value=11>11</option>
                                        <option value=12>12</option>
                                    </select>

                                </div>
                                <div class="form-group form-group-custom">
                                    <label for="dimensions_height" class="control-label control-label-custom">
                                        Height
                                    </label>
                                    <input id="dimensions_height" name="dimensions_height" type="text" class="form-control dimensions_input">
                                </div>
                                <div class="form-group form-group-custom">
                                    <label for="dimensions_transparent" class="control-label control-label-custom">
                                        Transparent
                                    </label>
                                    <div class="checkbox" style="display: inline-block">
                                        <input type="checkbox" class="js-switch-small" checked ="checked " id="dimensions_transparent" name="dimensions_transparent" /> 
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_metrics" aria-labelledby="metrics-tab">
                    <div id="forms">
                    </div>        
                    <button class="btn btn-success Addq btn-xs">Add</button>                    
                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_axes" aria-labelledby="axes-tab">
                    <div class="row">
                        <form class="form-horizontal form-label-left edit-axes pull-left">                                   
                            <div class="form_main_block  pull-left">                                
                                <h3><label class="control-label" >
                                        Left Y
                                    </label>
                                    <div class="checkbox" style="display: inline-block">
                                        <input chart_prop_key="show" axes="yAxis" axes="yAxis" index="0" type="checkbox" class="js-switch-small" checked ="checked " id="left_axes_show" name="left_axes_show" /> 
                                    </div>
                                </h3>

                                <div class="">
                                    <div class="form-group form-group-custom">
                                        <label for="display_datazoomY" class="control-label control-label-custom-legend" >
                                            Data zoom Y
                                        </label>                                 
                                        <div class="checkbox" style="display: inline-block">
                                            <input chart_prop_key="dataZoomY" type="checkbox" axes="xAxis" index="0" class="js-switch-small" checked ="checked" id="display_datazoomY" name="display_datazoomY" /> 
                                        </div>
                                    </div>                                     

                                    <div class="form-group form-group-custom">
                                        <label for="axes_unit_left_y" class="control-label control-label-custom-legend" >
                                            Unit
                                        </label>                                 
                                        <select id="axes_unit_left_y" axes="yAxis" index="0" name="axes_unit_left_y" chart_prop_key="unit" class="select2_group form-control axes_select ">                                                
                                            <optgroup label="None">
                                                <option value= "none" >None</option>
                                                <option value= "format_metric" >Short</option>
                                                <option value="{value} %">Percent(0-100)</option>
                                                <option value= "format100">Percent(0.0-1.0)</option>
                                                <option value="{value} %H">Humidity(%H)</option>
                                                <option value="{value} ppm">PPM</option>
                                                <option value="{value} dB">Decible</option>
                                                <option value = "formathexadecimal0">Hexadecimal(0x)</option>
                                                <option value = "formathexadecimal">Hexadecimal</option>
                                            </optgroup>                                                
                                            <optgroup label="Currency">
                                                <option value="$ {value}">Dollars ($)</option>
                                                <option value="£ {value}">Pounds (£)</option>
                                                <option value="€ {value}">Euro (€)</option>
                                                <option value="¥ {value}">Yen (¥)</option>
                                                <option value="₽ {value}">Rubles (₽)</option>
                                            </optgroup>                                
                                            <optgroup label="Time">
                                                <option value = "formathertz">Hertz (1/s)</option>
                                                <option value="timens">Nanoseconds (ns)</option>
                                                <option value="timemicros">microseconds (µs)</option>
                                                <option value="timems">Milliseconds (ms)</option>
                                                <option value="timesec">Seconds (s)</option>
                                                <option value="timemin">Minutes (m)</option>
                                                <option value="timeh">Hours (h)</option>
                                                <option value="timed">Days d</option>
                                                <!--                                                    <option value="{value} ms">Duration (ms)</option>
                                                                                                    <option value="{value} s">Duration (s)</option>-->
                                            </optgroup>                                                                                                                                
                                            <optgroup label="Data IEC">
                                                <option value="dataBit">Bits</option>
                                                <option value="dataBytes">Bytes</option>
                                                <option value="dataKiB">Kibibytes</option>
                                                <option value="dataMiB">Mebibytes</option>
                                                <option value="dataGiB">Gibibytes</option>
                                            </optgroup>
                                            <optgroup label="Data (Metric)">
                                                <option value="dataBitmetric">Bits</option>
                                                <option value="dataBytesmetric">Bytes</option>
                                                <option value="dataKiBmetric">Kilobytes</option>
                                                <option value="dataMiBmetric">Megabytes</option>
                                                <option value="dataGiBmetric">Gigabytes</option>                                                   
                                            </optgroup>
                                            <optgroup label="Data Rate">
                                                <option value="formatPpS">Packets/s</option>
                                                <option value="formatbpS">Bits/s</option>
                                                <option value="formatBpS">Bytes/s</option>
                                                <option value="formatKbpS">Kilobits/s</option>
                                                <option value="formatKBpS">Kilobytes/s</option>
                                                <option value="formatMbpS">Megabits/s</option>
                                                <option value="formatMBpS">Megabytes/s</option>
                                                <option value="formatGBbpS">Gigabits/s</option>
                                                <option value="formatGBpS">Gigabytes/s</option>

                                            </optgroup>
                                            <optgroup label="Throughput">
                                                <option value="formatops">Ops/sec (ops)</option>
                                                <option value="formatrps">Reads/sec (rps)</option>
                                                <option value="formatwps">Writes/sec (wps)</option>
                                                <option value="formatiops">I/O Ops/sec (iops)</option>
                                                <option value="formatopm">Ops/min (opm)</option>
                                                <option value="formatrpm">Reads/min (rpm)</option>
                                                <option value="formatwpm">Writes/min (wpm)</option>
                                            </optgroup>                                                                                                
                                            <optgroup label="Lenght">
                                                <option value="formatmm">Millimeter (mm)</option>
                                                <option value="formatm">Meter (m)</option>
                                                <option value="formatkm">Kilometer (km)</option>
                                                <option value="{value} mi">Mile (mi)</option>
                                            </optgroup>
                                            <optgroup label="Velocity">
                                                <option value="{value} m/s">m/s</option>
                                                <option value="{value} km/h">km/h</option>
                                                <option value="{value} km/h">mtf</option>
                                                <option value="{value} knot">knot</option>
                                            </optgroup>
                                            <optgroup label="Volume">
                                                <option value="formatmL">Millilitre</option>
                                                <option value="formatL">Litre</option>
                                                <option value="formatm3">Cubic Metre</option>
                                            </optgroup>                                                
                                            <optgroup label="Energy">
                                                <option value="formatW">Watt (W)</option>
                                                <option value="formatKW">Kilowatt (KW)</option>
                                                <option value="formatVA">Volt-Ampere (VA)</option>
                                                <option value="formatKVA">Kilovolt-Ampere (KVA)</option>
                                                <option value="formatVAR">Volt-Ampere Reactive (VAR)</option>
                                                <option value="formatVH">Watt-Hour (VH)</option>
                                                <option value="formatKWH">Kilowatt-Hour (KWH)</option>
                                                <option value="formatJ">Joule (J)</option>
                                                <option value="formatEV">Electron-Volt (EV)</option>
                                                <option value="formatA">Ampere (A)</option>
                                                <option value="formatV">Volt (V)</option>
                                                <option value="{value} dBm">Decibell-Milliwatt (DBM)</option>
                                            </optgroup>
                                            <optgroup label="Temperature">
                                                <option value="{value} °C">Celsius (°C)</option>
                                                <option value="{value} °F">Farenheit (°F)</option>
                                                <option value="{value} K">Kelvin (K)</option>
                                            </optgroup>
                                            <optgroup label="Pressure">
                                                <option value="{value} mbar">Millibars</option>
                                                <option value="{value} hPa">Hectopascals</option>
                                                <option value='{value} "Hg'>Inches of Mercury</option>
                                                <option value="formatpsi">PSI</option>
                                            </optgroup>
                                        </select>
                                    </div>
                                    <!--                                        <div class="form-group form-group-custom">
                                                                                <label for="axes_scale_left_y" class="control-label control-label-custom-legend" >
                                                                                    Scale
                                                                                </label>                                 
                                                                                <select id="axes_scale_left_y" name="axes_scale_left_y" chart_prop_key="leftScale" class="select2_group form-control axes_select ">
                                                                                    <option value="{value}" selected>Linear</option>
                                                                                    <option value="{value}">Log (base 2)</option>
                                                                                    <option value="{value}">Log (base 10)</option>
                                                                                    <option value="{value}">Log (base 32)</option>
                                                                                    <option value="{value}">Log (base 1024)</option>
                                                                                </select>
                                                                            </div>-->
                                    <div class="form-group form-group-custom">
                                        <label for="axes_min_left_y" class="control-label control-label-custom-legend" >
                                            Y-Min
                                        </label>
                                        <input id="axes_min_left_y" name="axes_min_left_y" axes="yAxis" index="0" chart_prop_key="min" type="number" placeholder="auto" class="form-control title_input_small" >
                                        <label for="axes_max_left_y" class="control-label control-label-custom-axes" >
                                            Y-Max
                                        </label>
                                        <input id="axes_max_left_y" name="axes_max_left_y" axes="yAxis" index="0" chart_prop_key="max" type="number" placeholder="auto" class="form-control title_input_small" >
                                    </div>
                                    <div class="form-group form-group-custom">
                                        <label for="axes_label_left_y" class="control-label control-label-custom-legend" >
                                            Label
                                        </label>
                                        <input id="axes_label_left_y" name="axes_label_left_y" axes="yAxis" index="0" chart_prop_key="name" type="text" class="form-control axes_select" >
                                    </div>
                                </div>
                            </div>                                                        
                            <div class="form_main_block  pull-left">     
                                <div class="form-group form-group-custom">
                                    <div class="form_main_block">                                
                                        <h3><label class="control-label" >
                                                X-Axis
                                            </label>
                                            <div class="checkbox" style="display: inline-block">
                                                <input chart_prop_key="show" axes="xAxis" index="0" type="checkbox" class="js-switch-small" checked ="checked " id="x_axes_show" name="x_axes_show" /> 
                                            </div>
                                        </h3>

                                    </div>
                                    <div class="form-group form-group-custom">
                                        <label for="display_datazoomX" class="control-label control-label-custom-legend" >
                                            Data zoom X
                                        </label>                                 
                                        <div class="checkbox" style="display: inline-block">
                                            <input chart_prop_key="dataZoomX" type="checkbox" class="js-switch-small" axes="xAxis" index="0" checked ="checked" id="display_datazoomX" name="display_datazoomX" /> 
                                        </div>
                                    </div>                                      

                                    <div class="form-group form-group-custom">
                                        <label for="axes_mode_x" class="control-label control-label-custom-legend" >
                                            Scale
                                        </label>                                 
                                        <select id="axes_mode_x" name="axes_mode_x" chart_prop_key="type" axes="xAxis" index="0" class="form-control axes_select ">
                                            <option value="time">Time</option>
                                            <option value="category">Series</option>
                                        </select>
                                    </div>
                                    <div class="form-group form-group-custom only-Series">    
                                        <label for="axes_value_x" class="control-label control-label-custom-legend" >
                                            Value
                                        </label>                                 
                                        <select id="axes_value_x" name="axes_value_x" axes="xAxis" index="0" chart_prop_key="m_sample" class="form-control axes_select ">
                                            <option value="avg" selected>Avg</option>
                                            <option value="min">Min</option>
                                            <option value="max">Max</option>
                                            <option value="total">Total</option>
                                            <option value="count">Count</option>
                                            <option value="current">Current</option>
                                            <option value="product">Product</option>

                                        </select>
                                    </div>
                                    <!--                                        <div class="form-group form-group-custom only-Series">    
                                                                                <label for="axes_value_x" class="control-label control-label-custom-legend" >
                                                                                    Tags
                                                                                </label>                                 
                                                                                <select id="axes_tags_x" name="axes_tags_x" axes="xAxis" index="0" chart_prop_key="m_tags" class="form-control axes_select ">
                                                                                    <option value="nan" selected>NaN</option>
                                                                                    TODO FILL by data tags
                                                                                </select>
                                                                            </div>                                        -->
                                </div>
                            </div>
                            <!--                                <form class="form-horizontal form-label-left edit-legend pull-left">   -->                                
                        </form>
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_legend" aria-labelledby="legend-tab">
                    <div class="row">
                        <form class="form-horizontal form-label-left edit-legend pull-left">   
                            <div class="form_main_block">                                
                                <h3><label class="control-label" >
                                        Legend
                                    </label>
                                    <div class="checkbox" style="display: inline-block">
                                        <input chart_prop_key="show" type="checkbox" class="js-switch-small" checked ="checked " id="legend_show" name="legend_show" /> 
                                    </div>
                                </h3>
                            </div>
                            <div class="form_main_block pull-left">
                                <div class="form-group form-group-custom">
                                    <label for="legend_orient" class="control-label control-label-custom-legend" >
                                        Orient
                                    </label>                                 
                                    <select id="legend_orient" name="legend_orient" chart_prop_key="orient" class="form-control title_select ">
                                        <option value="horizontal" selected>Horizontal</option>
                                        <option value="vertical">Vertical</option>
                                    </select>
                                </div>
                                <div class="form-group form-group-custom">
                                    <label for="legend_select_mode" class="control-label control-label-custom-legend" >
                                        Select Mode
                                    </label> 
                                    <select id="legend_select_mode" name="legend_select_mode" chart_prop_key="selectedMode" class="form-control title_select " >
                                        <option value="single">Single</option>
                                        <option value="multiple" selected>Multiple</option>
                                    </select>
                                </div>                                    
                                <div class="form-group form-group-custom">
                                    <label for="legend_background_color" class="control-label control-label-custom-legend" >
                                        Background
                                    </label>
                                    <div class="color-button">
                                        <div class="input-group cl_picer cl_picer_noinput" >                            
                                            <input id="legend_background_color" name="legend_background_color" chart_prop_key="backgroundColor" type="text" value="" class="form-control" >
                                            <span class="input-group-addon"><i></i></span>
                                        </div>                                
                                    </div> 
                                </div>                                    
                            </div>
                            <div class="form_main_block pull-left">                                    
                                <div class="form-group form-group-custom">
                                    <label for="legend_x_position" class="control-label control-label-custom-legend2" >
                                        X
                                    </label>
                                    <select id="legend_x_position" name="legend_x_position" chart_prop_key="x" class="form-control title_select" >
                                        <option selected value="">&nbsp;</option>
                                        <option value="center">Center</option>
                                        <option value="left">Left</option>
                                        <option value="right">Right</option>
                                    </select>
                                    <label class="control-label control-label-custom-legend2" >
                                        OR
                                    </label>
                                    <input id="legend_x_position_text" name="legend_x_position_text" chart_prop_key="x" type="number" class="form-control title_input_small" >
                                    <label class="control-label control-label-custom3" >
                                        px
                                    </label>                                        
                                </div>
                                <div class="form-group form-group-custom">
                                    <label for="legend_y_position" class="control-label control-label-custom-legend2" >
                                        Y
                                    </label> 
                                    <select id="legend_y_position" name="legend_y_position" chart_prop_key="y" class="form-control title_select" >
                                        <option selected value="">&nbsp;</option>
                                        <option value="center">Center</option>
                                        <option value="top">Top</option>
                                        <option value="bottom">Bottom</option>
                                    </select>
                                    <label class="control-label control-label-custom-legend2" >
                                        OR
                                    </label>
                                    <input id="legend_y_position_text" name="legend_y_position_text" chart_prop_key="y" type="number" class="form-control title_input_small" >
                                    <label class="control-label control-label-custom3" >
                                        px
                                    </label>
                                </div>
                                <div class="form-group form-group-custom">
                                    <label for="legend_shape_width" class="control-label control-label-custom-legend2">
                                        Shape Width
                                    </label>

                                    <input id="legend_shape_width" chart_prop_key="itemWidth" name="legend_shape_width" type="number" value="" class="form-control title_select">

                                    <label for="legend_shape_height" class="control-label control-label-custom-legend2">
                                        Height
                                    </label>   
                                    <input id="legend_shape_height" chart_prop_key="itemHeight" name="legend_shape_height" type="number" value="" class="form-control title_input_small">
                                    <label class="control-label label-border-width-px" >
                                        px
                                    </label>
                                </div>                                    
                                <div class="form-group form-group-custom">
                                    <label for="legend_border_color" class="control-label control-label-custom-legend2" >
                                        Border
                                    </label>                                                                                     
                                    <div class="color-button">                                                                                                     
                                        <div class="input-group cl_picer cl_picer_noinput">                            
                                            <input id="legend_border_color" name="legend_border_color" chart_prop_key="borderColor" type="text" value="" class="form-control" >
                                            <span class="input-group-addon"><i></i></span>
                                        </div>                                
                                    </div>                                   
                                    <label for="legend_border_width" class="control-label control-label-custom-legend3">
                                        Width
                                    </label>

                                    <input id="legend_border_width" chart_prop_key="borderWidth" name="legend_border_width" type="number" value="" class="form-control title_input_small">
                                    <label class="control-label label-border-width-px" >
                                        px
                                    </label>
                                </div>                                    
                            </div>
                        </form>                        
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_display" aria-labelledby="desplay-tab">
                    <div class="row">
                        <form class="form-horizontal form-label-left edit-display pull-left">   
                            <div class="form_main_block pull-left">
                                <div class="form-group form-group-custom">
                                    <label for="display_animation" class="control-label control-label-custom" >
                                        Animation
                                    </label>                                 
                                    <div class="checkbox" style="display: inline-block">
                                        <input chart_prop_key="animation" type="checkbox" class="js-switch-small" checked ="checked" id="display_animation" name="display_animation" /> 
                                    </div>
                                </div>    
                                <div class="form-group form-group-custom">
                                    <label for="display_datazoom" class="control-label control-label-custom" >
                                        Data zoom
                                    </label>                                 
                                    <div class="checkbox" style="display: inline-block">
                                        <input chart_prop_key="dataZoom" type="checkbox" class="js-switch-small" checked ="checked" id="display_datazoom" name="display_datazoom" /> 
                                    </div>
                                </div>                                                                                                                                                                                                                                                        
                                <div class="form-group form-group-custom">
                                    <label for="display_stacked" class="control-label control-label-custom" >
                                        Stacked
                                    </label>                                 
                                    <div class="checkbox" style="display: inline-block">
                                        <input chart_prop_key="stacked" type="checkbox" class="js-switch-small" checked ="checked" id="display_stacked" name="display_stacked" /> 
                                    </div>
                                </div>                                                                                                                                                                               
                            </div>    
                            <div class="form_main_block pull-left">
                                <div class="form-group form-group-custom">
                                    <label for="display_charttype" class="control-label control-label-custom" >
                                        Chart Type
                                    </label>                                 
                                    <select id="display_charttype" chart_prop_key="type" name="display_charttype" class="form-control title_select">
                                        <option value="line" selected>Lines</option>
                                        <option value="bar">Bars</option>
                                        <!--<option value="k">Candlestick</option>-->
                                        <option value="pie">Pie</option>
                                        <!--<option value="radar">Radar</option>-->
                                        <!--<option value="chord">chord</option>-->
                                        <!--<option value="force">force</option>-->
                                        <!--<option value="map">Map</option>-->
                                        <!--<option value="heatmap">Heatmap</option>-->
                                        <option value="gauge">Gauge</option>
                                        <option value="funnel">Funnel</option>
                                        <!--<option value="eventRiver">event River</option>-->
                                        <option value="treemap">Treemap</option>
                                        <!--<option value="tree">tree</option>-->
                                        <!--<option value="venn">venn</option>-->
                                    </select>
                                </div>      

                                <div class="form-group form-group-custom">
                                    <label for="display_points" class="control-label control-label-custom" >
                                        Points
                                    </label>                                 

                                    <select id="display_points" chart_prop_key="points" name="display_points" class="form-control title_select">
                                        <option value="none">None</option>
                                        <option value="circle" selected>Circle</option>
                                        <option value="rectangle">Rectangle</option>
                                        <option value="triangle">Triangle</option>
                                        <option value="diamond">Diamond</option>                                                
                                        <option value="emptyCircle">Empty Circle</option>
                                        <option value="emptyRectangle">Empty Rectangle</option>
                                        <option value="emptyTriangle">Empty Triangle</option>
                                        <option value="emptyDiamond">Empty Diamond</option>
                                    </select>                                            
                                </div>                                      
                                <div class="form-group form-group-custom">
                                    <label for="display_fillArea" class="control-label control-label-custom" >
                                        Fill Area
                                    </label>          
                                    <select id="display_fillArea" chart_prop_key="fill" name="display_fillArea" class="form-control title_select">
                                        <option value="none" selected>None</option>
                                        <option value="0.1" >1</option>
                                        <option value="0.2" >2</option>
                                        <option value="0.3" >3</option>
                                        <option value="0.4" >4</option>
                                        <option value="0.5" >5</option>
                                        <option value="0.6" >6</option>
                                        <option value="0.7" >7</option>
                                        <option value="0.8" >8</option>
                                        <option value="0.9" >9</option>
                                        <option value="1" >10</option>
                                    </select>                                    
                                </div>   
                                <div class="form-group form-group-custom">
                                    <label for="display_steped" class="control-label control-label-custom" >
                                        Staircase
                                    </label>          
                                    <select id="display_steped" chart_prop_key="step" name="display_steped" class="form-control title_select">
                                        <option value="" selected>None</option>
                                        <option value="start" >start</option>
                                        <option value="middle" >middle</option>
                                        <option value="end" >end</option>
                                    </select>                                    
                                </div>                                

                            </div>   
                            <div class="form_main_block pull-left grid">
                                <div class="form-group form-group-custom">
                                    <label for="padding_left" class="control-label control-label-custom">
                                        Left
                                    </label>
                                    <input placeholder="auto" id="padding_left" chart_prop_key="x" name="padding_left"  value="" class="form-control title_input_small">
                                </div>
                                <div class="form-group form-group-custom">
                                    <label for="padding_top" class="control-label control-label-custom">
                                        Top
                                    </label>
                                    <input placeholder="auto" id="padding_top" chart_prop_key="y" name="padding_top"  value="" class="form-control title_input_small">
                                </div>                                    
                                <div class="form-group form-group-custom">
                                    <label for="padding_right" class="control-label control-label-custom">
                                        Right
                                    </label>
                                    <input placeholder="auto" id="padding_right" chart_prop_key="x2" name="padding_right"  value="" class="form-control title_input_small">
                                </div>                                                                        
                                <div class="form-group form-group-custom">
                                    <label for="padding_bottom" class="control-label control-label-custom">
                                        Bottom
                                    </label>
                                    <input placeholder="auto" id="padding_bottom" chart_prop_key="y2" name="padding_bottom" value="" class="form-control title_input_small">
                                </div>            
                            </div>            
                            <div class="form_main_block pull-left grid">
                                <div class="form-group form-group-custom">
                                    <label for="padding_width" class="control-label control-label-custom">
                                        Width
                                    </label>
                                    <input placeholder="auto" id="padding_width" chart_prop_key="width" name="padding_width"  value="" class="form-control title_input_small">
                                </div>                                                                                                                                                
                                <div class="form-group form-group-custom">
                                    <label for="padding_height" class="control-label control-label-custom">
                                        Height
                                    </label>
                                    <input placeholder="auto" id="padding_height" chart_prop_key="height" name="padding_height" value="" class="form-control title_input_small">
                                </div>                                    
                            </div>
                        </form>                        
                    </div>                        
                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_times" aria-labelledby="times-tab">
                    <div class="row">
                        <form class="form-horizontal form-label-left edit-times pull-left">   
                            <div class="form_main_block pull-left">
                                <label class="control-label" >
                                    Times
                                </label>                        
                                <div class="filter">
                                    <div id="reportrange_private" class="pull-left" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
                                        <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
                                        <span></span> <b class="caret"></b>
                                    </div>                              
                                    <div id="refresh_wrap_private" class="pull-left">
                                        <select id="refreshtime_private" name="refreshtime" class="select2-hidden-accessible" style="width: 150px">                                            
                                            <option value="General" selected>Refresh general</option>
                                            <option value="5000">Refresh every 5s</option>
                                            <option value="10000">Refresh every 10s</option>
                                            <option value="30000">Refresh every 30s</option>
                                            <option value="60000">Refresh every 1m</option>
                                            <option value="300000">Refresh every 5m</option>
                                            <option value="900000">Refresh every 15m</option>
                                            <option value="1800000">Refresh every 30m</option>
                                            <option value="3600000">Refresh every 1h</option>
                                            <option value="7200000">Refresh every 2h</option>
                                            <option value="86400000">Refresh every 1d</option>                
                                        </select>            
                                    </div>   
                                </div>  
                            </div>
                        </form>
                    </div>                        
                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_json" aria-labelledby="json-tab">
                    <div class="row">
                        <form class="edit-ljson">
                            <h3><label class="control-label" >Json Editor</label></h3>
                            <div id="jsoneditor"></div>
                            <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                <button class="btn btn-primary" type="button" value="Default" id="jsonReset">Reset</button>        
                                <button class="btn btn-success" type="button" value="Default" id="jsonApply">Apply</button>                                        
                            </div>

                        </form>                        
                    </div>
                </div> 

            </div>
        </div>
    </div>    
</div>    

<div id="deleteConfirm" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Do you want to delete this dashboard?</p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" id="deletedashconfirm" class="btn btn-ok">Delete</button>
            </div>
        </div>
    </div>
</div>                
<div id="showjson" class="modal  fade">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Json Editor</h4>
            </div>
            <div class="modal-body">
                <div id="dasheditor"></div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" id="applyrowjson" class="btn btn-ok">Apply</button>
            </div>
        </div>
    </div>
</div> 