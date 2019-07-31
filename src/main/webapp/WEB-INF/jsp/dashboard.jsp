<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div id="saveModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-sm">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header custom-modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title"><spring:message code="dashboard.Modal.successfullySaved"/> </h4>
            </div>
        </div>
    </div>
</div>
<div id="lockConfirm" class="modal fade" tabindex="-1">
    <div class="modal-dialog ">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><spring:message code="confirmation"/></h4>
            </div>
            <div class="modal-body">
                <p><spring:message code="dashboard.Modal.needsSavedDashboard"/></p>
                <p class="text-warning"><spring:message code="dashboard.Modal.confirmSaveDashboard"/></p>
            </div>
            <div class="modal-footer">
                <input  type="button" class="btn btn-default" data-dismiss="modal" value="<spring:message code="no"/>">
                <input id="savelock" type="button" class="btn btn-success nowrap" data-dismiss="modal" value="<spring:message code="yes"/>">
            </div>
        </div>
    </div>
</div>  

<div class="hidden" id="rowtemplate">
    <div class="raw widgetraw">
        <div class="raw-controls text-right">   
            <div class="btn-group  btn-group-xs pull-left">
                <a class="btn btn-default colapserow btn-default-dash" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.collapse"/>' type="button"><i class="fa fa-minus"></i></a>
            </div>              
            <div class="pull-left item_title " >
                <div class="title_text">
                    <span></span> 
                    <i class="change_title_row fa fas fa-pencil-alt"></i>
                </div>              
                <div class="title_input">
                    <input class="enter_title_row" type="text" name="row" value="" >
                    <i class="savetitlerow fa fa-check"></i>
                </div>
            </div>  
            <div class="btn-group  btn-group-xs">
                <a class="btn btn-default addcounter btn-default-dash" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addCounterWidget"/>' ><i class="fa fa-code"></i></a>
                <a class="btn btn-default addstatus btn-default-dash" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addStatusWidget"/>' ><i class="far fa-thumbs-up"></i></a>
                <a class="btn btn-default addheatmap btn-default-dash" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addHeatmapWidget"/>' ><i class="fa fa-map"></i></a>
                <a class="btn btn-default addchart btn-default-dash" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addChartWidget"/>' ><i class="fa fas fa-chart-line"></i></a>
            </div>
            <div class="btn-group  btn-group-xs">
                <a class="btn btn-default showrowjson btn-default-dash" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.viewRowJSON"/>' ><i class="fa fa-edit"></i></a>
                <!--<a class="btn btn-default colapserow btn-default-dash" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.collapse"/>' type="button"><i class="fa fa-chevron-up"></i></a>-->
                <a class="btn btn-default deleterow btn-default-dash" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.deleteRow"/>' ><i class="fa fa-trash"></i></a>
            </div>  
            <div class="clearfix"></div>
        </div>
        <div class="rowcontent raw">
        </div>  
        <div class="clearfix"></div>
    </div>
</div>  
<div class="hidden" id="charttemplate">
    <div class="col-lg-12 chartsection" size="12">
        <div class="inner col-xs-12">
            <div class="chartTitleDiv">
                <div class="chartDesc wrap">
                    <div class="borderRadius"><span class="chartSubIcon" style="display: none"><i class="fa fas fa-info "></i></span></div>
                    <a href="#" class="chartSubText hoverShow"></a>
                </div>
                <div class="chartTime wrap">
                    <div class="borderRadius"><span class="echart_time_icon"><i class="fa far fa-clock"></i></i></span></div>
                    <span class="echart_time hoverShow"></span>
                </div>
                <div class="chartTitle btn-group">
                    <div data-toggle="dropdown" class="dropdown-toggle"><h3></h3><span class="fa fas fa-chevron-down"></span></div>
                    <ul class="dropdown-menu">
                        <li class="dolock hide-single" >
                            <div class="btn-group resize" role="group">
                                <span class="btn btn-default plus col-xs-6" type="button" data-toggle="tooltip" data-placement="left" title="Span +"><i class="fa fa-search-plus"></i></span>
                                <span class="btn btn-default minus col-xs-6" type="button" data-toggle="tooltip" data-placement="right" title="Span -"><i class="fa fa-search-minus"></i></span>                                
                            </div>
                        </li>
                        <li class="hide-singleview" ><a class="viewchart" data-toggle="tooltip" data-placement="top" title="View"><i class="fa fa-eye"></i><spring:message code="dashboard.chart.view"/></a></li>                        
                        <li class="dolock hide-singleedit"><a class="editchart" data-toggle="tooltip" data-placement="top" title="Edit"><i class="fa fas fa-edit"></i><spring:message code="edit"/></a></li>
                        <li class="dolock"><a class="dublicate hide-single" data-toggle="tooltip" data-placement="top" title="Dublicate"><i class="fa far fa-copy"></i><spring:message code="dashboard.chart.duplicate"/></a></li>                        
                        <li class="dropdown-submenu">
                            <a class="more" tabindex="-1" href="#"><i class="fa fa-cube"></i><spring:message code="dashboard.chart.saveAs"/> <i class="fa fa-caret-right"></i></a>
                            <ul class="dropdown-menu">
                                <li><a class="csv" data-toggle="tooltip" data-placement="top" title="Save as csv"><i class="fa fa-th-list"></i> <spring:message code="dashboard.chart.saveAs.csv"/></a></li>
                                <li><a class="jsonsave" data-toggle="tooltip" data-placement="top" title="Save as json"><span class="jsonIcon">{:}</span> <spring:message code="dashboard.chart.saveAs.json"/></a></li>
                                <li><a class="imagesave" data-toggle="tooltip" data-placement="top" title="Save as Image"><i class="fa far fa-image"></i> <spring:message code="dashboard.chart.saveAs.image"/></a></li>
                            </ul>
                        </li>
                        <li role="presentation" class="divider hide-single"></li>
                        <li class="dolock hide-single"><a class="deletewidget" data-toggle="tooltip" data-placement="top" title="Delete chart"><i class="fa fa-trash"></i><spring:message code="dashboard.chart.remove"/></a></li>
                    </ul> 
                </div>
            </div>          
            <div class="echart_line" style="height:300px;"></div>                   
        </div>
    </div>   
</div>  

<div class="x_panel fulldash" style="display: none">

    <div class="dash_header">
        <div class="pull-left item_title" ><div class="title_text"><span>${dashname}</span> <i class="change_title fa fas fa-pencil-alt"></i></div>  <div class="title_input"><input class="enter_title" type="text" name="name" id="name" value="${dashname}"> <i class="savetitle fa fa-check"></i></div></div>        
        <div class="pull-right"> 
            <div class="btn-group"> 

                <div class="btn-group btn-group-xs">
                    <button type="button" class="btn btn-default savedash" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.saveDash"/>"><i class="fa far fa-save"></i></button>
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        <span class="caret"></span>
                        <span class="sr-only"></span>
                    </button>
                    <ul class="dropdown-menu minWidth140" role="menu">
                        <li><a class="savedashasTemplate text-center"><spring:message code="dashboard.saveAsTemplate"/></a>
                        </li>
                    </ul>
                </div>                  

                <div class="btn-group btn-group-xs">
                    <a class="btn btn-default btn-default-dash" type="button" id="showasjson" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.viewDashJSON"/>"><i class="fa fa-edit"></i></a>
                </div>
                <div class="btn-group btn-group-xs">
                    <a class="btn btn-default btn-default-dash" type="button" id="addrow" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.addRow"/>"><i class="fa fa-layer-group"></i></a>
                </div>         
                <div class="btn-group btn-group-xs">
                    <a class="btn btn-default deletedash btn-default-dash" type="button" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.deleteDashboard"/>"><i class="fa fa-trash"></i></a>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>        
    </div>        

    <div id="maximize" class="pull-right btnlock reflock"  data-toggle="tooltip"  data-placement="bottom" title='Show Filter'>                        
        <i class="fa fa fa-eye" ></i>
    </div>

    <div id="dash_main">
        <div id="filter" class="filter raw">
            <div class="pull-right smpadding">
                <div id="minimize" class="pull-right btnlock reflock"  data-toggle="tooltip"  data-placement="bottom" title="<spring:message code="dash.title.hideFilter"/>">                        
                    <i class="fa fa fa-eye-slash" ></i>
                </div>
                <div id="btnlock" class="pull-right btnlock reflock"  data-toggle="tooltip"  data-placement="bottom">                        
                    <i class="fa fas fa-lock" ></i>
                </div>
            </div>            
            <div class="form-group-custom pull-left form-horizontal filtermargin col-sm-6">
                <div class="large">
                    <label class="control-label control-label-top text-nowrap down-sample-label" for="global-down-sample"><spring:message code="dashboard.downSample"/>
                    </label>
                    <input id="global-down-sample" name="global-down-sample" class="form-control query_input" type="text">
                </div>
                <div class="large">
                    <label class="control-label control-label-top" for="global-down-sample-ag"><spring:message code="dashboard.agregator"/>
                    </label>        
                    <div class="select2wraper global-down-sample-ag-wraper">
                        <select id="global-down-sample-ag" name="global-down-sample-ag" class="form-control query_input" data-width="100%">                        
                        </select>        
                    </div>
                </div>
                <div class="small">
                    <label id="downsampling_label" class="control-label control-label-top" for="global-downsampling-switsh">
                        <spring:message code="dashboard.enabled"/>
                    </label>
                    <div class="checkbox" style="display: inline-block">
                        <input type="checkbox" style="display: none" class="js-switch-general" chart_prop_key="" id="global-downsampling-switsh" name="global-downsampling-switsh" /> 
                    </div>        
                </div>
            </div>          
            <div class="refresh-block">
                <div id="reportrange" class="reportrange" data-toggle="tooltip"  title="<spring:message code="dashboard.title.quickRanges"/>" data-placement="bottom" >
                    <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
                    <span></span> <b class="caret"></b>
                </div>                  
                <div id="refresh_wrap" class="">
                    <select id="refreshtime" name="refreshtime" class="form-control query_input" data-width="100%">
                        <option value="" selected><spring:message code="dashboard.refreshOff"/></option>
                        <option value="5000"><spring:message code="dashboard.refresh5s"/></option>
                        <option value="10000"><spring:message code="dashboard.refresh10s"/></option>
                        <option value="30000"><spring:message code="dashboard.refresh30s"/></option>
                        <option value="60000"><spring:message code="dashboard.refresh1m"/></option>
                        <option value="300000"><spring:message code="dashboard.refresh5m"/></option>
                        <option value="900000"><spring:message code="dashboard.refresh15m"/></option>
                        <option value="1800000"><spring:message code="dashboard.refresh30m"/></option>
                        <option value="3600000"><spring:message code="dashboard.refresh1h"/></option>
                        <option value="7200000"><spring:message code="dashboard.refresh2h"/></option>
                        <option value="86400000"><spring:message code="dashboard.refresh1d"/></option>                
                    </select>            
                </div>
                <div id="refresh" class="reflock"  data-toggle="tooltip"  title="<spring:message code="dashboard.title.refresh"/>" data-placement="bottom" >                        
                    <i class="glyphicon glyphicon-refresh"></i>
                </div>
            </div>

        </div>  
    </div>                
    <div class="x_content" id="dashcontent">        
    </div>
</div>
<div id="deleteConfirm" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><spring:message code="confirmation"/></h4>
            </div>
            <div class="modal-body">
                <p><spring:message code="dashboard.Modal.confirmDelDashboard"/></p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-default" data-dismiss="modal" value="<spring:message code="close"/>">
                <input type="button" id="deletedashconfirm" class="btn btn-ok" value="<spring:message code="delete"/>">
            </div>
        </div>
    </div>
</div>                
<div id="showjson" class="modal  fade" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><spring:message code="dashboard.Modal.jsonEditor"/></h4>
            </div>
            <div class="modal-body">
                <div id="dasheditor"></div>

            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-default" data-dismiss="modal"value="<spring:message code="close"/>">
                <input type="button" id="applyrowjson" class="btn btn-ok" value="<spring:message code="apply"/>">
            </div>
        </div>
    </div>
</div> 
