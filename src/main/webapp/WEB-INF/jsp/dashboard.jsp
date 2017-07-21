<%@ page pageEncoding="UTF-8" %>
<div class="hidden" id="rowtemplate">
    <div class="raw widgetraw">
        <div class="pull-left row_title" >
            <div class="title_text_row">
                <span></span> 
                <i class="change_title_row fa fa-pencil"></i>
            </div>              
            <div class="title_input_row">
                <input class="enter_title_row" type="text" name="row" value="" >
                <i class="savetitlerow fa fa-check"></i>
            </div>
        </div>  
        <div class="raw-controls text-right">
            <div class="btn-group  btn-group-xs">
                <a class="btn btn-default addchart" type="button" data-toggle="tooltip" data-placement="top" title="Add chart widget"><i class="fa fa-line-chart"></i></a>
                <a class="btn btn-default showrowjson" type="button" data-toggle="tooltip" data-placement="top" title="View row as JSON" ><i class="fa fa-edit"></i></a>
                <a class="btn btn-default colapserow" data-toggle="tooltip" data-placement="top" title="Collapse" type="button"><i class="fa fa-chevron-up"></i></a>
                <a class="btn btn-danger deleterow" type="button" data-toggle="tooltip" data-placement="top" title="Delete row"><i class="fa fa-times"></i></a>
            </div>  
        </div>
        <div class="rowcontent raw">
        </div>  
        <div class="clearfix"></div>
    </div>
</div>  

<div class="hidden" id="charttemplate">
    <div class="col-lg-12 chartsection" size="12">
        <div class="inner col-xs-12">            
            <div class="controls text-right">
                <div class="echart_time pull-left"></div>
                <div class="btn-group  btn-group-xs">
                    <a class="btn btn-default viewchart" type="button" data-toggle="tooltip" data-placement="top" title="View">View</a>
                    <a class="btn btn-default editchart" type="button" data-toggle="tooltip" data-placement="top" title="Edit">Edit</a>
                    <a class="btn btn-default dublicate" type="button" data-toggle="tooltip" data-placement="top" title="Dublicate">Duplicate</a>               
                    <a class="btn btn-default csv" type="button" data-toggle="tooltip" data-placement="top" title="Save as csv">asCsv</a>
                    <a class="btn btn-default plus" type="button" data-toggle="tooltip" data-placement="top" title="Span +"><i class="fa fa-search-plus"></i></a>
                    <a class="btn btn-default minus" type="button" data-toggle="tooltip" data-placement="top" title="Span -"><i class="fa fa-search-minus"></i></a>
                    <a class="btn btn-default deletewidget" type="button" data-toggle="tooltip" data-placement="top" title="Delete chart"><i class="fa fa-times"></i></a>
                </div> 
            </div>             
            <div class="echart_line" style="height:300px;"></div>                   
        </div>

    </div>   
</div>  

<div class="x_panel fulldash" style="display: none">
    <div class="dash_header">
        <div class="pull-left dash_title" ><div class="title_text"><span>${dashname}</span> <i class="change_title fa fa-pencil"></i></div>  <div class="title_input"><input class="enter_title" type="text" name="name" id="name" value="${dashname}"> <i class="savetitle fa fa-check"></i></div></div>        
        <div class="pull-right"> 
            <div class="btn-group"> 
                <div class="btn-group btn-group-xs">
                    <button type="button" class="btn btn-default savedash" data-toggle="tooltip" data-placement="top" title="Save Dash"><i class="fa fa-floppy-o"></i></button>
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        <span class="caret"></span>
                        <span class="sr-only"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a class="savedashasTemplate">Save As Template </a>
                        </li>
                    </ul>
                </div>                  

                <div class="btn-group btn-group-xs">
                    <a class="btn btn-default" type="button" id="showasjson" data-toggle="tooltip" data-placement="top" title="View dash as JSON"><i class="fa fa-edit"></i></a>
                </div>
                <div class="btn-group btn-group-xs">
                    <a class="btn btn-default" type="button" id="addrow" data-toggle="tooltip" data-placement="top" title="Add raw"><i class="fa fa-plus"></i></a>
                </div>         
                <div class="btn-group btn-group-xs">
                    <a class="btn btn-danger deletedash" type="button" data-toggle="tooltip" data-placement="top" title="Delete Dashboard"><i class="fa fa-times"></i></a>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>        
    </div>        

    <div id="dash_main">
        <div class="filter">
            <div class="form-group-custom pull-left form-horizontal">
                <label class="control-label control-label-top" for="global-down-sample">Down sample 
                </label>
                <input id="global-down-sample" name="global-down-sample" class="form-control query_input" type="text">
                <label class="control-label control-label-top" for="global-down-sample-ag">Aggregator
                </label>        
                <select id="global-down-sample-ag" name="global-down-sample-ag" class="form-control query_input">
                </select>        
                <label class="control-label control-label-top" for="global-downsampling-switsh">
                    Enable downsampling
                </label>
                <div class="checkbox" style="display: inline-block">
                    <input type="checkbox" style="display: none" class="js-switch-general" chart_prop_key="" id="global-downsampling-switsh" name="global-downsampling-switsh" /> 
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
    <div class="x_content" id="dashcontent">        
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