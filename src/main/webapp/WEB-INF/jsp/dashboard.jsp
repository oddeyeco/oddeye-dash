<link rel="stylesheet" type="text/css" href="${cp}/resources//switchery/dist/switchery.min.css" />        

<div class="hidden" id="rowtemplate">
    <div class="raw widgetraw">
        <div class="x_content">            
            <div class="btn-group">
                <a type="button" class="btn btn-danger">Actions</a>
                <a type="button" class="btn btn-danger dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                    <span class="caret"></span>
                    <span class="sr-only">Toggle Dropdown</span>
                </a>
                <ul class="dropdown-menu" role="menu">
                    <li><a href="#" class="addchart">Add Line Chart</a>
                    <li class="divider"></li>
                    <li><a href="#" class="deleterow">Delete</a>    
                    </li>
                    <!--                    <li><a href="#">Another action</a>
                                        </li>
                                        <li><a href="#">Something else here</a>
                                        </li>
                                        <li class="divider"></li>
                                        <li><a href="#">Separated link</a>
                                        </li>-->
                </ul>
            </div>  
            <div class="x_content rowcontent raw">

            </div>        
        </div>
    </div>
</div>  

<div class="hidden" id="charttemplate">
    <div class="col-lg-12 chartsection" size="12">
        <div>
            <div class="echart_line" id="echart_line" style="height:300px;"></div>                   
        </div>
        <div class="controls text-center">
            <div class="btn-group  btn-group-sm">
                <a class="btn btn-default view" type="button">View</a>
                <a class="btn btn-default editchart" type="button">Edit</a>
                <a class="btn btn-default dublicate" type="button">Duplicate</a>               
                <a class="btn btn-default plus" type="button"><i class="fa fa-plus"></i></a>
                <a class="btn btn-default minus" type="button"><i class="fa fa-minus"></i></a>
                <a class="btn btn-default deletewidget" type="button"><i class="fa fa-trash"></i></a>
            </div> 
        </div>                            
    </div>   
</div>  


<div class="x_panel">
    <div class="filter">
        <div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
            <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
            <span>December 30, 2014 - January 28, 2015</span> <b class="caret"></b>
        </div>
    </div>  
</div>

<div class="x_panel fulldash">
    <div class="x_title">
        <h2 class="col-md-3" ><input type="text" name="name" id="name" value="${dashname}"></h2>        
        <div class="pull-right">            
            <a class="btn btn-primary" type="button" id="addrow">Add Row</a>
            <a class="btn btn-primary savedash" type="button">Save </a>
            <a class="btn btn-danger deletedash" type="button">Delete </a>
        </div>
        <div class="clearfix"></div>
    </div>        
    <div class="x_content" id="dashcontent">        

    </div>
</div>

<div class="x_panel editchartpanel" style="display: none">
    <div class="x_title">
        <h1 class="col-md-3">Edit Chart</h1>              
        <div class="pull-right">
            <!--<a class="btn btn-primary" type="button">Save </a>-->
            <a class="btn btn-primary backtodush" type="button">Back to Dash </a>
        </div>
        <div class="clearfix"></div>
        <div class="x_content" id="dashcontent"> 
        </div>
        <div class="x_content" id="singlewidget">      
            <div class="echart_line_single" id="echart_line_single" style="height:600px;"></div>                   
        </div>    
        <div class="x_content edit-form" style="overflow: hidden">
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
                    <li role="presentation" class=""><a href="#tab_desplay" role="tab" id="desplay-tab" data-toggle="tab" aria-expanded="false">Display</a>
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
                        <form class="form-horizontal form-label-left edit-query">
                            <div class="form-group">
                                <label class="control-label col-md-3" for="tags">Tags 
                                </label>
                                <div class="col-md-7">
                                    <input id="tags" name="tags" class="form-control col-md-7 col-xs-12" type="text" value="host=cassa001*">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3" for="metrics">Metrics 
                                </label>
                                <div class="col-md-7">
                                    <input id="metrics" name="metrics" class="form-control col-md-7 col-xs-12" type="text" value="cpu_user">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3" for="metrics">Aggregator 
                                </label>
                                <div class="col-md-7">
                                    <input id="aggregator" name="aggregator" class="form-control col-md-7 col-xs-12" type="text" value="avg">
                                </div>
                            </div>                            

                            <div class="form-group">
                                <label class="control-label col-md-3" for="down-sample">Down sample 
                                </label>
                                <div class="col-md-7">
                                    <input id="down-sample" name="down-sample" class="form-control col-md-7 col-xs-12" type="text">
                                </div>
                            </div>                        
                        </form>                    
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
                                            <label for="axes_unit_left_y" class="control-label control-label-custom-legend" >
                                                Unit
                                            </label>                                 
                                            <select id="axes_unit_left_y" axes="yAxis" index="0" name="axes_unit_left_y" chart_prop_key="formatter" class="select2_group form-control axes_select ">                                                
                                                <optgroup label="None">
                                                    <option value="">None</option>
                                                    <option value="{value}">Short</option>
                                                    <option value="{value} %">Percent(0-100)</option>
                                                    <option value="{value}*100 %">Percent(0.0-1.0)</option>
                                                    <option value="{value} %H">Humidity(%H)</option>
                                                    <option value="{value} ppm">PPM</option>
                                                    <option value="{value} dB">Decible</option>
                                                    <option value="0x{value}">Hexadecimal(0x)</option>
                                                    <option value="{value}">Hexadecimal</option>
                                                </optgroup>                                                
                                                <optgroup label="Currency">
                                                    <option value="$ {value}">Dollars</option>
                                                    <option value="{value} £">Pounds</option>
                                                    <option value="{value} ?">Euro</option>
                                                    <option value="{value} ¥">Yen</option>
                                                    <option value="{value} ?">Rubles</option>
                                                </optgroup>                                
                                                <optgroup label="Time">
                                                    <option value="{value} hz">Hertz (1/s)</option>
                                                    <option value="{value} ns">Nanoseconds (ns)</option>
                                                    <option value="{value} ms">Milliseconds (ms)</option>
                                                    <option value="{value} s">Seconds (s)</option>
                                                    <option value="{value} m">Minutes (m)</option>
                                                    <option value="{value} h">Hours (h)</option>
                                                    <option value="{value} d">Days d</option>
                                                    <option value="{value} ms">Duration (ms)</option>
                                                    <option value="{value} s">Duration (s)</option>
                                                </optgroup>                                                                                                                                
                                                <optgroup label="Data IEC">
                                                    <option value="{value} Bit">Bits</option>
                                                    <option value="{value} B">Bytes</option>
                                                    <option value="{value} KiB">Kibibytes</option>
                                                    <option value="{value} MiB">Mebibytes</option>
                                                    <option value="{value} GiB">Gibibytes</option>
                                                </optgroup>
                                                <optgroup label="Data (Metric)">
                                                    <option value="{value} Bit">Bits</option>
                                                    <option value="{value} B">Bytes</option>
                                                    <option value="{value} KB">Kilobytes</option>
                                                    <option value="{value} MB">Megabytes</option>
                                                    <option value="{value} GB">Gigabytes</option>
                                                </optgroup>
                                                <optgroup label="Data Rate">
                                                    <option value="{value} PpS">Packets/s</option>
                                                    <option value="{value} bpS">Bits/s</option>
                                                    <option value="{value} BpS">Bytes/s</option>
                                                    <option value="{value} KbpS">Kilobits/s</option>
                                                    <option value="{value} KBpS">Kilobytes/s</option>
                                                    <option value="{value} MbpS">Megabits/s</option>
                                                    <option value="{value} MBpS">Megabytes/s</option>
                                                    <option value="{value} GBpS">Gigabytes/s</option>
                                                    <option value="{value} BbpS">Gigabits/s</option>
                                                </optgroup>
                                                <optgroup label="Throughput">
                                                    <option value="{value} ops">Ops/sec (ops)</option>
                                                    <option value="{value} rps">Reads/sec (rps)</option>
                                                    <option value="{value} wps">Writes/sec (wps)</option>
                                                    <option value="{value} iops">I/O Ops/sec (iops)</option>
                                                    <option value="{value} opm">Ops/min (opm)</option>
                                                    <option value="{value} rpm">Reads/min (rpm)</option>
                                                    <option value="{value} wpm">Writes/min (wpm)</option>
                                                </optgroup>
                                                <optgroup label="Lenght">
                                                    <option value="{value} mm">Millimeter (mm)</option>
                                                    <option value="{value} m">Meter (m)</option>
                                                    <option value="{value} km">Kilometer (km)</option>
                                                    <option value="{value} mi">Mile (mi)</option>
                                                </optgroup>
                                                <optgroup label="Energy">
                                                    <option value="{value} W">Watt (W)</option>
                                                    <option value="{value} KW">Kilowatt (KW)</option>
                                                    <option value="{value} KVA">Volt-Ampere (VA)</option>
                                                    <option value="{value} KVA">Kilovolt-Ampere (KVA)</option>
                                                    <option value="{value} VAR">Volt-Ampere Reactive (VAR)</option>
                                                    <option value="{value} VH">Watt-Hour (VH)</option>
                                                    <option value="{value} KWH">Kilowatt-Hour (KWH)</option>
                                                    <option value="{value} J">Joule (J)</option>
                                                    <option value="{value} EV">Electron-Volt (EV)</option>
                                                    <option value="{value} A">Ampere (A)</option>
                                                    <option value="{value} V">Volt (V)</option>
                                                    <option value="{value} DBM">Decibell-Milliwatt (DBM)</option>
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
                                                    <option value="{value} psi">PSI</option>
                                                </optgroup>
                                                <optgroup Label="Velocity">
                                                    <option value="{value} m/s">m/s</option>
                                                    <option value="{value} km/h">km/h</option>
                                                    <option value="{value} km/h">mtf</option>
                                                    <option value="{value} knot">knot</option>
                                                </optgroup>
                                                <optgroup label="Volume">
                                                    <option value="{value} mL">Millilitre</option>
                                                    <option value="{value} L">Litre</option>
                                                    <option value="{value} m3">Cubic Metre</option>
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
                                                    Right Y
                                                </label>
                                                <div class="checkbox" style="display: inline-block">
                                                    <input chart_prop_key="show" type="checkbox"  axes="yAxis" index="1" class="js-switch-small" checked ="checked " id="right_axes_show" name="right_axes_show" /> 
                                                </div>
                                            </h3>
                                        </div>
                                        <div class="">
                                            <div class="form-group form-group-custom">
                                                <label for="axes_unit_right_y" class="control-label control-label-custom-legend" >
                                                    Unit
                                                </label>                                 
                                                <select id="axes_unit_right_y" name="axes_unit_right_y" axes="yAxis" index="1" chart_prop_key="formatter" class="select2_group form-control axes_select ">                                                
                                                    <optgroup label="None">
                                                        <option value="">None</option>
                                                        <option value="{value}">Short</option>
                                                        <option value="{value} %">Percent(0-100)</option>
                                                        <option value="{value}*100 %">Percent(0.0-1.0)</option>
                                                        <option value="{value} %H">Humidity(%H)</option>
                                                        <option value="{value} ppm">PPM</option>
                                                        <option value="{value} dB">Decible</option>
                                                        <option value="0x{value}">Hexadecimal(0x)</option>
                                                        <option value="{value}">Hexadecimal</option>
                                                    </optgroup>                                                
                                                    <optgroup label="Currency">
                                                        <option value="$ {value}">Dollars</option>
                                                        <option value="{value} £">Pounds</option>
                                                        <option value="{value} ?">Euro</option>
                                                        <option value="{value} ¥">Yen</option>
                                                        <option value="{value} ?">Rubles</option>
                                                    </optgroup>                                
                                                    <optgroup label="Time">
                                                        <option value="{value} hz">Hertz (1/s)</option>
                                                        <option value="{value} ns">Nanoseconds (ns)</option>
                                                        <option value="{value} ms">Milliseconds (ms)</option>
                                                        <option value="{value} s">Seconds (s)</option>
                                                        <option value="{value} m">Minutes (m)</option>
                                                        <option value="{value} h">Hours (h)</option>
                                                        <option value="{value} d">Days d</option>
                                                        <option value="{value} ms">Duration (ms)</option>
                                                        <option value="{value} s">Duration (s)</option>
                                                    </optgroup>                                                                                                                                
                                                    <optgroup label="Data IEC">
                                                        <option value="{value} Bit">Bits</option>
                                                        <option value="{value} B">Bytes</option>
                                                        <option value="{value} KiB">Kibibytes</option>
                                                        <option value="{value} MiB">Mebibytes</option>
                                                        <option value="{value} GiB">Gibibytes</option>
                                                    </optgroup>
                                                    <optgroup label="Data (Metric)">
                                                        <option value="{value} Bit">Bits</option>
                                                        <option value="{value} B">Bytes</option>
                                                        <option value="{value} KB">Kilobytes</option>
                                                        <option value="{value} MB">Megabytes</option>
                                                        <option value="{value} GB">Gigabytes</option>
                                                    </optgroup>
                                                    <optgroup label="Data Rate">
                                                        <option value="{value} PpS">Packets/s</option>
                                                        <option value="{value} bpS">Bits/s</option>
                                                        <option value="{value} BpS">Bytes/s</option>
                                                        <option value="{value} KbpS">Kilobits/s</option>
                                                        <option value="{value} KBpS">Kilobytes/s</option>
                                                        <option value="{value} MbpS">Megabits/s</option>
                                                        <option value="{value} MBpS">Megabytes/s</option>
                                                        <option value="{value} GBpS">Gigabytes/s</option>
                                                        <option value="{value} BbpS">Gigabits/s</option>
                                                    </optgroup>
                                                    <optgroup label="Throughput">
                                                        <option value="{value} ops">Ops/sec (ops)</option>
                                                        <option value="{value} rps">Reads/sec (rps)</option>
                                                        <option value="{value} wps">Writes/sec (wps)</option>
                                                        <option value="{value} iops">I/O Ops/sec (iops)</option>
                                                        <option value="{value} opm">Ops/min (opm)</option>
                                                        <option value="{value} rpm">Reads/min (rpm)</option>
                                                        <option value="{value} wpm">Writes/min (wpm)</option>
                                                    </optgroup>
                                                    <optgroup label="Lenght">
                                                        <option value="{value} mm">Millimeter (mm)</option>
                                                        <option value="{value} m">Meter (m)</option>
                                                        <option value="{value} km">Kilometer (km)</option>
                                                        <option value="{value} mi">Mile (mi)</option>
                                                    </optgroup>
                                                    <optgroup label="Energy">
                                                        <option value="{value} W">Watt (W)</option>
                                                        <option value="{value} KW">Kilowatt (KW)</option>
                                                        <option value="{value} KVA">Volt-Ampere (VA)</option>
                                                        <option value="{value} KVA">Kilovolt-Ampere (KVA)</option>
                                                        <option value="{value} VAR">Volt-Ampere Reactive (VAR)</option>
                                                        <option value="{value} VH">Watt-Hour (VH)</option>
                                                        <option value="{value} KWH">Kilowatt-Hour (KWH)</option>
                                                        <option value="{value} J">Joule (J)</option>
                                                        <option value="{value} EV">Electron-Volt (EV)</option>
                                                        <option value="{value} A">Ampere (A)</option>
                                                        <option value="{value} V">Volt (V)</option>
                                                        <option value="{value} DBM">Decibell-Milliwatt (DBM)</option>
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
                                                        <option value="{value} psi">PSI</option>
                                                    </optgroup>
                                                    <optgroup Label="Velocity">
                                                        <option value="{value} m/s">m/s</option>
                                                        <option value="{value} km/h">km/h</option>
                                                        <option value="{value} km/h">mtf</option>
                                                        <option value="{value} knot">knot</option>
                                                    </optgroup>
                                                    <optgroup label="Volume">
                                                        <option value="{value} mL">Millilitre</option>
                                                        <option value="{value} L">Litre</option>
                                                        <option value="{value} m3">Cubic Metre</option>
                                                    </optgroup>
                                                </select>
                                            </div>                                            
                                            <div class="form-group form-group-custom">
                                                <label for="axes_min_right_y" class="control-label control-label-custom-legend" >
                                                    Y-Min
                                                </label>
                                                <input id="axes_min_left_y" name="axes_min_right_y" axes="yAxis" index="1" chart_prop_key="min" type="number" placeholder="auto" class="form-control title_input_small" >
                                                <label for="axes_max_left_y" class="control-label control-label-custom-axes" >
                                                    Y-Max
                                                </label>
                                                <input id="axes_max_left_y" name="axes_max_left_y" axes="yAxis" index="1" chart_prop_key="max" type="number" placeholder="auto" class="form-control title_input_small" >
                                            </div>
                                            <div class="form-group form-group-custom">
                                                <label for="axes_label_right_y" class="control-label control-label-custom-legend" >
                                                    Label
                                                </label>
                                                <input id="axes_label_right_y" name="axes_label_right_y" axes="yAxis" index="1" chart_prop_key="name" type="text" class="form-control axes_select" >
                                            </div>
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
                                            </select>
                                        </div>
                                        <div class="form-group form-group-custom only-Series">    
                                            <label for="axes_value_x" class="control-label control-label-custom-legend" >
                                                Tags
                                            </label>                                 
                                            <select id="axes_tags_x" name="axes_tags_x" axes="xAxis" index="0" chart_prop_key="m_tags" class="form-control axes_select ">
                                                <option value="nan" selected>NaN</option>
                                                <!--TODO FILL by data tags-->
                                            </select>
                                        </div>                                        
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
                                <!--</div>-->
                                <!--</div>-->
                            </form>                        
                        </div>
                    </div>
                    <div role="tabpanel" class="tab-pane fade" id="tab_desplay" aria-labelledby="desplay-tab">
                        dododo
                    </div>
                </div>
            </div>

        </div>    
    </div>
</div>    
