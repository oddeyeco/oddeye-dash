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
        <h2 class="col-md-3">Edit Chart</h2>              
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
        <div class="x_content edit-form">
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
                <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in" id="tab_general" aria-labelledby="general-tab">                        
                        <form class="form-horizontal form-label-left edit-title">
                            <!--                            <span id="title_title" style="display: inline-block; max-width: 100%; margin-bottom: 5px; font-weight: bold;">Title</span>
                                                        <div class="form-group">
                                                            <div class="checkbox">
                                                                <label for="title_show" class="control-label col-md-1" >
                                                                    Show
                                                                </label>
                                                                <div class="">
                                                                    <label>
                                                                        <input type="checkbox" class="js-switch-small" checked ="checked " chart_prop_key="show" id="title_show" name="title_show" /> 
                                                                    </label>
                                                                </div>                                        
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="title_text" class="control-label col-md-1" >
                                                                Text
                                                            </label>
                                                            <div class="col-md-3">
                                                                <input chart_prop_key="text" id="title_text" name="title_text" type="text" class="title_input col-md-5 col-xs-12" >
                                                            </div>
                                                            <label for="title_link" class="col-md-1" style="margin-top: 6px;">
                                                                Link
                                                            </label>
                                                            <div class="col-md-3">
                                                                <input chart_prop_key="link" id="title_link" name="title_link" type="text" class="title_input col-md-5 col-xs-12" >
                                                            </div>
                                                            <label for="title_target" class="col-md-1" style="margin-top: 6px;" >
                                                                Target
                                                            </label>
                                                            <div class="col-md-3">                                    
                                                                <select id="title_target" chart_prop_key="target" name="title_target" class=" title_select form-control col-md-5 col-xs-12">
                                                                    <option selected></option>
                                                                    <option value="self">Self</option>
                                                                    <option value="blank">Blank</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="title_subtext" class="control-label col-md-1" >
                                                                Subtext
                                                            </label>                                
                                                            <div class="col-md-3">
                                                                <input chart_prop_key="subtext" id="title_subtext" name="title_subtext" type="text" class="title_input col-md-5 col-xs-12" >
                                                            </div>
                                                            <label for="title_sublink" class="control-label col-md-1" >
                                                                Sublink
                                                            </label>
                                                            <div class="col-md-3">
                                                                <input chart_prop_key="sublink" id="title_sublink" name="title_sublink" type="text" class="title_input col-md-5 col-xs-12" >
                                                            </div>
                                                            <label for="title_subtarget" class="control-label col-md-1" >
                                                                Subtarget
                                                            </label>
                                                            <div class="col-md-3">
                                                                <select id="title_subtarget" chart_prop_key="subtarget" name="title_subtarget" class="title_select form-control col-md-5 col-xs-12">
                                                                    <option selected></option>
                                                                    <option value="self">Self</option>
                                                                    <option value="blank">Blank</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="form-group">
                                                            <label for="title_x_position" class="control-label col-md-2" style="text-align: left; margin-left: -16px;">
                                                                X Position
                                                            </label>
                                                            <div class="col-md-3">
                                                                <select id="title_x_position" chart_prop_key="x" name="title_x_position" class="title_select form-control col-md-3 col-xs-9 select_edit" style="margin-right: 116px;">
                                                                    <option selected value=""></option>
                                                                    <option value="center">Center</option>
                                                                    <option value="left">Left</option>
                                                                    <option value="right">Right</option>
                                                                </select>
                                                            </div> 
                                                            <label class="control-label col-md-1" style="white-space: nowrap; margin-left: -145px !important;">
                                                                OR
                                                            </label>
                                                            <div class="col-md-3">
                                                                <input id="title_x_position_text" chart_prop_key="x" name="title_x_position_text" type="number" class="form-control col-md-3 col-xs-3" style="width: 50%; margin-left: -100px;" >
                                                            </div>
                                                            <label class="control-label col-md-1" style="white-space: nowrap;     margin-left: -210px;">
                                                                px
                                                            </label>
                                                            <label for="title_y_position" class="control-label col-md-2" style="text-align: left; margin-left: -155px;" >
                                                                Y Position
                                                            </label>  
                                                            <div class="col-md-3">
                                                                <select id="title_y_position" chart_prop_key="y" name="title_y_position" class="title_select form-control col-md-3 col-xs-9 select_edit" style="margin-right: 160px;">
                                                                    <option selected value=""></option>
                                                                    <option value="center">Center</option>
                                                                    <option value="top">Top</option>
                                                                    <option value="bottom">Bottom</option>
                                                                </select>
                                                            </div>  
                                                            <label class="control-label col-md-1" style="white-space: nowrap; margin-left: -185px !important;">
                                                                OR
                                                            </label>
                                                            <div class="col-md-3">
                                                                <input id="title_y_position_text" chart_prop_key="y" name="title_y_position_text" type="number" class="form-control col-md-3 col-xs-3" style="width: 50%; margin-left: 464px; margin-top: -34px;">
                                                            </div>
                                                            <label class="control-label col-md-1" style="white-space: nowrap; margin-left: 525px; margin-top: -34px;">
                                                                px
                                                            </label>
                                                        </div>                          
                                                        <div class="form-group">
                                                            <label for="title_background_color" class="control-label col-md-3" style="    text-align: left; margin-left: -16px;">
                                                                Background Color
                                                            </label>
                                                            <div class="col-md-3" style="margin-left: -50px; width: 240px;"">
                                                                <div class="input-group cl_picer" >                            
                                                                    <input id="title_background_color" chart_prop_key="backgroundColor" name="title_background_color" type="text" value="" class="form-control" >
                                                                    <span class="input-group-addon"><i></i></span>
                                                                </div>                                
                                                            </div> 
                                                            <label for="title_item_gap" class="control-label col-md-2" >
                                                                Item Gap
                                                            </label>
                                                            <div class="col-md-3">
                                                                <input id="title_item_gap" chart_prop_key="itemGap" name="title_item_gap" type="number" value="" class="form-control col-md-5 col-xs-12" >
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="border_color" class="control-label col-md-2" style="text-align: left; margin-left: -10px;" >
                                                                Border
                                                            </label>
                                                            <label for="title_border_width" class="control-label col-md-2"  style="text-align: left;  margin-left: -45px; width: 45px;" >
                                                                Color
                                                            </label>
                                                            <div class="col-md-3" style="width: 240px;">
                                                                <div class="input-group cl_picer">                            
                                                                    <input id="title_border_color" name="title_border_color" chart_prop_key="borderColor" type="text" value="" class="form-control" >
                                                                    <span class="input-group-addon"><i></i></span>
                                                                </div>                                
                                                            </div> 
                                                            <label for="title_border_width" class="control-label col-md-2" >
                                                                Width
                                                            </label>
                                                            <div class="col-md-2">
                                                                <input id="title_border_width" chart_prop_key="borderWidth" name="title_border_width" type="number" value="" class="title_input form-control col-md-2 col-xs-12" >
                                                            </div>
                                                        </div>-->

                            <div class="row">
                                <label for="title_text" class="title_block control-label col-md-3" >
                                    Info
                                </label>

                                <div class="checkbox">
                                    <div class="">
                                        <label>
                                            <input type="checkbox" class="js-switch-small" checked ="checked " chart_prop_key="show" id="title_show" name="title_show" /> 
                                        </label>
                                    </div>                                        
                                </div>
                            </div>
                            <div class="title_main_block" >
                                <div class="row">
                                    <label for="title_text" class="title_title_input" style="text-align: right;">
                                        Title
                                    </label>
                                    <input chart_prop_key="text" id="title_text" name="title_text" type="text" class="title_input" style="width: 473px;">
                                    <i class="dropdown_button fa fa-chevron-circle-down" id='button_title_subtitle' ></i>
                                    <div class='row'>
                                        <div id='title_subtitle' class='title_main_block' style="display: none;">
                                            <label for="title_link" class="title_title_input">
                                                Link
                                            </label>

                                            <input chart_prop_key="link" id="title_link" name="title_link" type="text" class="title_input">
                                            <label for="title_target" class="title_title_input">
                                                Target
                                            </label>                                 
                                            <select id="title_target" chart_prop_key="target" name="title_target" class=" title_select form-control ">
                                                <option selected></option>
                                                <option value="self">Self</option>
                                                <option value="blank">Blank</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <label for="title_subtext" class="title_title_input" >
                                        Description
                                    </label>
                                    <input chart_prop_key="subtext" id="title_subtext" name="title_subtext" type="text" class="title_input" style="width: 473px;">
                                    <i class="dropdown_button fa fa-chevron-circle-down" id='button_title_description' ></i>
                                    <div class='row'>
                                        <div id='title_subdescription' class='title_main_block' style="display: none;">
                                            <label for="title_sublink" class="title_title_input">
                                                Link
                                            </label>

                                            <input chart_prop_key="sublink" id="title_sublink" name="title_sublink" type="text" class="title_input">

                                            <label for="title_subtarget" class="title_title_input">
                                                Target
                                            </label>                                 
                                            <select id="title_subtarget" chart_prop_key="subtarget" name="title_subtarget" class=" title_select form-control ">
                                                <option selected></option>
                                                <option value="self">Self</option>
                                                <option value="blank">Blank</option>
                                            </select>
                                        </div>
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
                                    <div class="row">
                                        <label for="title_x_position" class="control-label col-md-2" style="margin-left: -40px; margin-right: 40px;">
                                            X
                                        </label>
                                        <div class="col-md-3">
                                            <select id="title_x_position" chart_prop_key="x" name="title_x_position" class="title_select form-control" style="margin-right: 88px; width: 100px;">
                                                <option selected value=""></option>
                                                <option value="center">Center</option>
                                                <option value="left">Left</option>
                                                <option value="right">Right</option>
                                            </select>
                                        </div> 
                                        <label class="control-label col-md-1" style="margin-left: -116px;">
                                            OR
                                        </label>
                                        <div class="col-md-3">
                                            <input id="title_x_position_text" chart_prop_key="x" name="title_x_position_text" type="number" class="title_input" style="margin-left: -74px; margin-bottom: 5px; width: 40px;">
                                        </div>
                                        <label class="control-label " style="margin-left: -180px;">
                                            px
                                        </label>
                                    </div>
                                    <div class="row">
                                        <label for="title_y_position" class="control-label col-md-2" style="margin-left: -40px; margin-right: 40px;">
                                            Y
                                        </label> 
                                        <div class="col-md-3">
                                            <select id="title_y_position" chart_prop_key="y" name="title_y_position" class="title_select form-control" style="margin-right: 88px; width: 100px;">
                                                <option selected value=""></option>
                                                <option value="center">Center</option>
                                                <option value="top">Top</option>
                                                <option value="bottom">Bottom</option>
                                            </select>
                                        </div>  
                                        <label class="control-label col-md-1" style="margin-left: -116px;">
                                            OR
                                        </label>
                                        <div class="col-md-3">
                                            <input id="title_y_position_text" chart_prop_key="y" name="title_y_position_text" type="number" class="title_input" style="margin-left: -74px; margin-bottom: 5px; width: 40px;">
                                        </div>
                                        <label class="control-label" style="margin-left: -344px;">
                                            px
                                        </label>
                                        <label for="title_item_gap" class="control-label col-md-3" style="margin-left: -245px;">
                                            Item Gap
                                        </label>
                                        <!--<div class="row">-->
                                            <div class="col-md-3">
                                                <input id="title_item_gap" chart_prop_key="itemGap" name="title_item_gap" type="number" value="" class="form-control col-md-5 col-xs-12" style="margin-left: -95px;  width: 62px;">
                                            </div>
                                        <!--</div>-->
                                    </div>

                                </div>
                                <div id="color_block" style="display: none;">
                                    <div class="row">
                                        <label for="title_background_color" class="control-label col-md-4" style="text-align: left !important;">
                                            Background
                                        </label>
                                        <div class="col-md-3" style="margin-left: -139px; width: 230px;"">
                                            <div class="input-group cl_picer" >                            
                                                <input id="title_background_color" chart_prop_key="backgroundColor" name="title_background_color" type="text" value="" class="form-control" >
                                                <span class="input-group-addon"><i></i></span>
                                            </div>                                
                                        </div> 
<!--                                    </div>
                                    <div class="row">-->
                                        <label for="title_border_color" class="control-label col-md-2" style="text-align: right !important; margin-left: -55px;">
                                            Border
                                        </label>
                                        <div class="col-md-3" style="margin-left: -12px; width: 230px;">
                                            <div class="input-group cl_picer">                            
                                                <input id="title_border_color" name="title_border_color" chart_prop_key="borderColor" type="text" value="" class="form-control" >
                                                <span class="input-group-addon"><i></i></span>
                                            </div>                                
                                        </div> 
                                    </div>
                                </div>
                                <div id="border_block" style="display: none;">
                                    <div class="row">
                                        <label for="title_border_width" class="control-label col-md-2" style="text-align: right !important; margin-left: -22px; margin-right: -12px;">
                                            Width
                                        </label>
                                        <div class="col-md-1">
                                            <input id="title_border_width" chart_prop_key="borderWidth" name="title_border_width" type="number" value="" class="title_input form-control col-md-1 col-xs-12" style="width: 70px; margin-left: 8px">
                                        </div>
                                    
                                        <label for="title_border_color" class="control-label col-md-2" style="text-align: right !important; margin-left: -12px;">
                                            Color
                                        </label>
                                        <div class="col-md-3" style="width: 230px; margin-left: -10px">
                                            <div class="input-group cl_picer">                            
                                                <input id="title_border_color" name="title_border_color" chart_prop_key="borderColor" type="text" value="" class="form-control" >
                                                <span class="input-group-addon"><i></i></span>
                                            </div>                                
                                        </div> 
                                    </div>
                                </div>
                            </div>
                        </form>
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
                        dododo
                    </div>
                    <div role="tabpanel" class="tab-pane fade" id="tab_legend" aria-labelledby="legend-tab">
                        dododo
                    </div>
                    <div role="tabpanel" class="tab-pane fade" id="tab_desplay" aria-labelledby="desplay-tab">
                        dododo
                    </div>
                </div>
            </div>

        </div>    
    </div>
</div>        