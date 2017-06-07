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
            <label class="control-label control-label-top" for="global-down-sample-ag">Aggregator
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