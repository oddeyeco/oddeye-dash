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
                            <form class="form-horizontal form-label-left edit-title pull-left" style="background-color: pink;">                            
                                <div class="title_main_block " >
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
                                    <!--<div class="row">-->
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
                                            <label for="title_target" class="control-label control-label-custom control-label-custom2" >
                                                Target
                                            </label>                                 
                                            <select id="title_target" chart_prop_key="target" name="title_target" class="form-control title_select">
                                                <option selected></option>
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

                                            <label for="title_subtarget" class="control-label control-label-custom control-label-custom2">
                                                Target
                                            </label>                                 
                                            <select id="title_subtarget" chart_prop_key="subtarget" name="title_subtarget" class="form-control title_select">
                                                <option selected></option>
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
                                                <option selected value=""></option>
                                                <option value="center">Center</option>
                                                <option value="left">Left</option>
                                                <option value="right">Right</option>
                                            </select>

                                            <label class="control-label control-label-custom3" >
                                                OR
                                            </label>
                                            <input id="title_x_position_text" chart_prop_key="x" name="title_x_position_text" type="number" class="form-control title_input_small" >
                                            <label class="control-label control-label-custom3" >
                                                px
                                            </label>
                                            <!--                                    </div>
                                                                                <div class="row">-->
                                            <label for="title_y_position" class="control-label control-label_Y" >
                                                Y
                                            </label> 

                                            <select id="title_y_position" chart_prop_key="y" name="title_y_position" class="form-control title_select" >
                                                <option selected value=""></option>
                                                <option value="center">Center</option>
                                                <option value="top">Top</option>
                                                <option value="bottom">Bottom</option>
                                            </select>

                                            <label class="control-label control-label-custom3" >
                                                OR
                                            </label>
                                            <!--<div class="col-md-1" >-->
                                            <input id="title_y_position_text" chart_prop_key="y" name="title_y_position_text" type="number" class="form-control title_input_small" >
                                            <!--</div>-->
                                            <label class="control-label control-label-custom3" >
                                                px
                                            </label>
                                            <!--                                        <label for="title_item_gap" class="control-label col-md-3" style="margin-left: -245px;">
                                                                                        Item Gap
                                                                                    </label>
                                                                                    <div class="row">
                                                                                        <div class="col-md-3">
                                                                                            <input id="title_item_gap" chart_prop_key="itemGap" name="title_item_gap" type="number" value="" class="form-control col-md-5 col-xs-12" style="margin-left: -95px;  width: 62px;">
                                                                                        </div>-->
                                            <!--</div>-->
                                        </div>

                                    </div>
                                    <div id="color_block" style="display: none;">
                                        <div class="form-group form-group-custom">
                                            <label for="title_border_color" class="control-label control-label-custom" >
                                                Border
                                            </label>    

                                            <div class="titile_input_midle">                                                                                                     
                                                <div class="input-group cl_picer">                            
                                                    <input id="title_border_color" name="title_border_color" chart_prop_key="borderColor" type="text" value="" class="form-control" >
                                                    <span class="input-group-addon"><i></i></span>
                                                </div>                                
                                            </div>    


                                            <label for="title_background_color" class="control-label control-label-custom" >
                                                Background
                                            </label>
                                            <div class="titile_input_midle">
                                                <div class="input-group cl_picer" >                            
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
                                            <div class="input-group cl_picer" >                            
                                                <input id="title_border_color" chart_prop_key="borderColor" name="title_border_color" type="text" value="" class="form-control" >
                                                <span class="input-group-addon"><i></i></span>
                                            </div>                                
                                        </div> 
                                        <label for="title_border_width" class="control-label control-label2">
                                            Width
                                        </label>
                                        <div class="titile_input_midle2">
                                            <div class="input-group" >   
                                                <input id="title_border_width" chart_prop_key="borderWidth" name="title_border_width" type="number" value="" class="form-control">
                                            </div>
                                        </div>
                                        <label class="control-label control-label-custom3" >
                                            px
                                        </label>
                                    </div>
                                </div>
                            </form>
                            <form class="form-horizontal form-label-left edit-dimensions pull-left">
                                <div id="toggles_main_block" style="background-color: yellow;">
                                    <div class="row">
                                        <label for="title_text" class="title_block control-label col-md-3" >
                                            Dimensions
                                        </label>
                                    </div>
                                    <div class="form-group form-group-custom">
                                        <label for="title_toggle_span" class="control-label col-md-6" style="width: 105px;">
                                            Span
                                        </label>
                                        <div >
                                            <select id="dimensions_span" chart_prop_key="y" name="dimensions_span" class="toggles_select title_select form-control col-md-6" >
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
                                    </div>
                                    <div class="form-group form-group-custom">
                                        <label for="title_toggle_height" class="control-label col-md-2" style="width: 105px;">
                                            Height
                                        </label>
                                        <input id="dimensions_height" name="dimensions_height" type="text" class="toggles_height_input form-control">
                                    </div>
                                    <div class="form-group form-group-custom">
                                        <label for="dimensions_transparent" class="control-label col-md-3" style="width: 105px;">
                                            Transparent
                                        </label>
                                        <div class="checkbox">
                                            <div class="">
                                                <label>
                                                    <input type="checkbox" class="js-switch-small" checked ="checked " id="dimensions_transparent" name="dimensions_transparent" /> 
                                                </label>
                                            </div>                                        
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