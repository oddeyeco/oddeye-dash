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
                        <form class="form-horizontal form-label-left edit-query">
                            <div class="form-group">
                                <div class="checkbox">
                                    <label for="show" class="control-label col-md-3" >
                                        Show
                                    </label>
                                    <div class="col-md-7">
                                        <input id="show" name="show" type="checkbox" class="flat" checked="checked">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="text" class="control-label col-md-3" >
                                    Text
                                </label>
                                <div class="col-md-7">
                                    <input id="text" name="text" type="text" class="form-control col-md-5 col-xs-12" >
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="link" class="control-label col-md-3" >
                                    Link
                                </label>
                                <div class="col-md-7">
                                    <input id="link" name="link" type="text" class="form-control col-md-5 col-xs-12" >
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="target" class="control-label col-md-3" >
                                    Target
                                </label>
                                <div class="col-md-3">                                    
                                    <select id="target" name="target" class="form-control col-md-5 col-xs-12">
                                        <option selected>  </option>
                                        <option>Self</option>
                                        <option>Blank</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="subtext" class="control-label col-md-3" >
                                    Subtext
                                </label>                                
                                <div class="col-md-7">
                                    <input id="subtext" name="subtext" type="text" class="form-control col-md-5 col-xs-12" >
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="sublink" class="control-label col-md-3" >
                                    Sublink
                                </label>
                                <div class="col-md-7">
                                    <input id="sublink" name="sublink" type="text" class="form-control col-md-5 col-xs-12" >
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="subtarget" class="control-label col-md-3" >
                                    Subtarget
                                </label>
                                <div class="col-md-3">
                                    <select id="subtarget" name="subtarget" class="form-control col-md-5 col-xs-12">
                                        <option selected>  </option>
                                        <option>Self</option>
                                        <option>Blank</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="x_position" class="control-label col-md-3" >
                                    X Position
                                </label>
                                <div class="col-md-3">
                                    <input id="x_position_text" name="x_position" type="number" class="form-control col-md-3 col-xs-3" >
                                </div>
                                <label class="control-label col-md-1" style="white-space: nowrap">
                                    px OR
                                </label>
                                <div class="col-md-3">
                                    <select id="x_position" name="x_position" class="form-control col-md-3 col-xs-9 select_edit">
                                        <option selected value=""></option>
                                        <option value="center">Center</option>
                                        <option >Left</option>
                                        <option>Right</option>
                                    </select>
                                </div>                                
                            </div>
                            <div class="form-group">
                                <label for="y_position" class="control-label col-md-3" >
                                    Y Position
                                </label>
                                <div class="col-md-3">
                                    <input id="y_position_text" name="y_position" type="number" class="form-control col-md-3 col-xs-3" >
                                </div>
                                <label class="control-label col-md-1" style="white-space: nowrap">
                                    px OR
                                </label>
                                <div class="col-md-3">
                                    <select id="x_position" name="x_position" class="form-control col-md-3 col-xs-9 select_edit">
                                        <option selected value=""></option>
                                        <option value="center">Center</option>
                                        <option >Left</option>
                                        <option>Right</option>
                                    </select>
                                </div>                                
                            </div>
                            <div class="form-group">
                                <label for="text_alaign" class="control-label col-md-3" >
                                    Text Alaign
                                </label>
                                <div class="col-md-3">                                    
                                    <select id="text_alaign" name="text_alaign" class="form-control col-md-5 col-xs-12">
                                        <option selected>  </option>
                                        <option>Center</option>
                                        <option>Left</option>
                                        <option>Right</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="background_color" class="control-label col-md-3" >
                                    Background Color
                                </label>
                                <div class="col-md-7">
                                    <div class="input-group cl_picer">                            
                                        <input id="background_color" name="background_color" type="text" value="" class="form-control" >
                                        <span class="input-group-addon"><i></i></span>
                                    </div>                                
                                </div>                                
                            </div>
                            <div class="form-group">
                                <label for="border_color" class="control-label col-md-3" >
                                    Border Color
                                </label>
                                <div class="col-md-7">
                                    <div class="input-group cl_picer">                            
                                        <input id="background_color" name="background_color" type="text" value="" class="form-control" >
                                        <span class="input-group-addon"><i></i></span>
                                    </div>                                
                                </div>   
                            </div>
                            <div class="form-group">
                                <label for="border_width" class="control-label col-md-3" >
                                    Border Width
                                </label>
                                <div class="col-md-7">
                                    <input id="border_width" name="border_width" type="number" value="" class="form-control col-md-5 col-xs-12" >
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="padding" class="control-label col-md-3" >
                                    Padding
                                </label>

                                <label for="left" class="noMargin control-label col-md-1">
                                    left
                                </label>

                                <div class="coordInput col-md-2" style="">
                                    <input id="left" name="left" type="number" value="" class="noMargin form-control col-md-1 col-xs-12" >                                    
                                </div>
                                <label for="right" class="noMargin control-label col-md-1" >
                                    right
                                </label>

                                <div class="coordInput col-md-2">
                                    <input id="right" name="right" type="number" value="" class="noMargin form-control col-md-1 col-xs-12" >                                    
                                </div>
                                <label for="top" class="noMargin control-label col-md-1" >
                                    top
                                </label>

                                <div class="coordInput col-md-2">
                                    <input id="top" name="top" type="number" value="" class="noMargin form-control col-md-1 col-xs-12" >                                    
                                </div>
                                <label for="bottom" class="noMargin control-label col-md-1" >
                                    bottom
                                </label>

                                <div class="coordInput col-md-2">
                                    <input id="bottom" name="bottom" type="number" value="" class="noMargin form-control col-md-1 col-xs-12" >                                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="item_gap" class="control-label col-md-3" >
                                    Item Gap
                                </label>
                                <div class="col-md-7">
                                    <input id="item_gap" name="item_gap" type="number" value="" class="form-control col-md-5 col-xs-12" >
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