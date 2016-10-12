<div class="hidden" id="rowtemplate">
    <div class="raw">
        <div class="x_content">
            <div class="btn-group">
                <a type="button" class="btn btn-danger">Add widget To Row</a>
                <a type="button" class="btn btn-danger dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                    <span class="caret"></span>
                    <span class="sr-only">Toggle Dropdown</span>
                </a>
                <ul class="dropdown-menu" role="menu">
                    <li><a href="#" class="addchart">Chart</a>
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
            <canvas class="lineChart" ></canvas>                           
        </div>
        <div class="controls text-center">
            <div class="btn-group  btn-group-sm">
                <a class="btn btn-default" type="button">View</a>
                <a class="btn btn-default editchart" type="button">Edit</a>
                <a class="btn btn-default" type="button">Duplicate</a>
                <a class="btn btn-default plus" type="button"><i class="fa fa-plus"></i></a>
                <a class="btn btn-default minus" type="button"><i class="fa fa-minus"></i></a>
            </div> 
        </div>                            
    </div>   
</div>  


<div class="x_panel fulldash">
    <div class="x_title">
        <h2>New Dashboard</h2>
        <div class="clearfix"></div>
        <a class="btn btn-primary" type="button" id="addrow">Add Row</a>
        <a class="btn btn-primary" type="button">Save </a>
    </div>
    <div class="x_content" id="dashcontent">        
    </div>
</div>
<div class="x_panel editchartpanel" style="">
    <div class="x_title">
        <h2>Edit Chart</h2>
        <div class="clearfix"></div>        
        <a class="btn btn-primary" type="button">Save </a>
        <a class="btn btn-primary backtodush" type="button">Back to Dash </a>
    </div>
    <div class="x_content" id="singlewidget">        
    </div>    
    <div class="x_content">
        <div class="" role="tabpanel" data-example-id="togglable-tabs">
            <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">
                <li role="presentation" class=""><a href="#tab_general" id="general-tab" role="tab" data-toggle="tab" aria-expanded="false">General</a>
                </li>
                <li role="presentation" class="active"><a href="#tab_metrics" role="tab" id="metrics-tab" data-toggle="tab" aria-expanded="true">Metrics</a>
                </li>
                <li role="presentation" class=""><a href="#tab_axes" role="tab" id="axes-tab" data-toggle="tab" aria-expanded="false">Axes</a>
                </li>
                <li role="presentation" class=""><a href="#tab_legend" role="tab" id="legend-tab" data-toggle="tab" aria-expanded="false">Legend</a>
                </li>                
                <li role="presentation" class=""><a href="#tab_desplay" role="tab" id="desplay-tab" data-toggle="tab" aria-expanded="false">Display</a>
                </li>                                
            </ul>
            <div id="myTabContent" class="tab-content">
                <div role="tabpanel" class="tab-pane fade" id="tab_general" aria-labelledby="general-tab">
                    lolololo

                </div>
                <div role="tabpanel" class="tab-pane fade active in" id="tab_metrics" aria-labelledby="metrics-tab">
                    <form class="form-horizontal form-label-left">
                        <div class="form-group">
                            <label class="control-label col-md-3" for="first-name">Tags 
                            </label>
                            <div class="col-md-7">
                                <input id="first-name2" required="required" class="form-control col-md-7 col-xs-12" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-3" for="last-name">Metrics 
                            </label>
                            <div class="col-md-7">
                                <input id="last-name2" name="last-name" required="required" class="form-control col-md-7 col-xs-12" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-3" for="last-name">Down sample 
                            </label>
                            <div class="col-md-7">
                                <input id="last-name2" name="last-name" required="required" class="form-control col-md-7 col-xs-12" type="text">
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