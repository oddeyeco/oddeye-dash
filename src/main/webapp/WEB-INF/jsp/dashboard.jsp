<%-- 
    Document   : dashboardOE
    Created on : Apr 17, 2019, 4:55:00 PM
    Author     : tigran
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}"/>
<div id="saveModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-sm">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header custom-modal-header"><h4 class="modal-title">
                    <spring:message code="dashboard.Modal.successfullySaved"/></h4>
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">&times;</span>
                </button>
                
            </div>
        </div>
    </div>
</div>
<div id="lockConfirm" class="modal fade" tabindex="-1">
    <div class="modal-dialog ">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><spring:message code="confirmation"/></h4>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    <span aria-hidden="true">&times;</span>
                </button>                
            </div>
            <div class="modal-body">
                <p><spring:message code="dashboard.Modal.needsSavedDashboard"/></p>
                <p class="text-warning"><spring:message code="dashboard.Modal.confirmSaveDashboard"/></p>
            </div>
            <div class="modal-footer">
                <input  type="button" class="btn btn-outline-secondary" data-dismiss="modal" value="<spring:message code="no"/>">
                <input id="savelock" type="button" class="btn btn-outline-success nowrap" data-dismiss="modal" value="<spring:message code="yes"/>">
            </div>
        </div>
    </div>
</div> 
<div class="d-none" id="rowtemplate">
    <div class="raw widgetraw">
        <div class="card-header raw-controls p-1">
            <div class="btn-group  btn-group-sm float-left">
                <button class="btn btn-outline-dark colapserow" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.collapse"/>' type="button">
                    <i class="fa fa-minus"></i>
                </button>
            </div>              
            <div class="item_title float-left pt-1">
                <div class="title_text">
                    <span></span> 
                    <i class="change_title_row fa fas fa-pencil-alt"></i>
                </div>              
                <div class="title_input">
                    <input class="enter_title_row" type="text" name="row" value="">
                    <i class="savetitlerow fa fa-check"></i>
                </div>
            </div>
            <div class="float-right">
                <div class="btn-group blockCounterHeatmapChartJsonDelete float-right">
                    <div class="btn-group btn-group-sm" role="group">
                        <button class="btn btn-outline-dark addstatus" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addStatusWidget"/>'>
                            <i class="fas fa-sort-amount-up"></i>
                        </button>
                        <button class="btn btn-outline-dark addcounter" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addCounterWidget"/>'>
                            <i class="fa fa-code"></i>
                        </button>
                        <button class="btn btn-outline-dark addheatmap" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addHeatmapWidget"/>'>
                            <i class="fa fa-map"></i>
                        </button>
                        <button class="btn btn-outline-dark addchart" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.addChartWidget"/>'>
                            <i class="fa fas fa-chart-line"></i>
                        </button>
                    </div>
                    <div class="btn-group btn-group-sm" role="group">
                        <button class="btn btn-outline-dark showJsonRow" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.viewRowJSON"/>'>
                            <i class="fa fa-edit"></i>
                        </button>               
                        <button class="btn btn-outline-dark deleterow" type="button" data-toggle="tooltip" data-placement="top" title='<spring:message code="dashboard.title.deleteRow"/>'>
                            <i class="fa fa-trash"></i>
                        </button>
                    </div> 
                </div>  
            </div>        
            <div class="clearfix"></div>
        </div>
        <div class="card-body rowcontent row raw p-1"></div>  
        <div class="clearfix"></div>
    </div>
</div>  
<div class="d-none" id="charttemplate">
    <div class="col-lg-12 chartsection" size="12">
        <div class="inner col-12">
            <div class="chartTitleDiv depthShadowChartsection">
                <div class="chartDesc wrap">
                    <div class="borderRadius">
                        <span class="chartSubIcon" style="display: none">
                            <i class="fa fas fa-info "></i>
                        </span>
                    </div>
                        <a href="#" class="chartSubText hoverShow"></a>
                </div>
                <div class="chartTime wrap">
                    <div class="borderRadius"><span class="echart_time_icon"><i class="fa far fa-clock"></i></i></span></div>
                    <span class="echart_time hoverShow"></span>
                </div>
                <div class="chartTitle btn-group">
                    <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <h3></h3>
                    </button>
                    
                    <ul class="dropdown-menu px-1 shadow">
                        <li class="dolock hide-single">
                            <div class="btn-group resize" role="group">
                                <button class="btn btn-outline-dark plus col-6" type="button" data-toggle="tooltip" data-placement="left" title="Span +"><i class="fa fa-search-plus"></i></button>
                                <button class="btn btn-outline-dark minus col-6" type="button" data-toggle="tooltip" data-placement="right" title="Span -"><i class="fa fa-search-minus"></i></button>                                
                            </div>
                        </li>
                        <li class="hide-singleview">
                            <a class="viewchart" data-toggle="tooltip" data-placement="top" title="View"><i class="fa fa-eye"></i><spring:message code="dashboard.chart.view"/></a>
                        </li>                        
                        <li class="dolock hide-singleedit">
                            <a class="editchart" data-toggle="tooltip" data-placement="top" title="Edit"><i class="fa fas fa-edit"></i><spring:message code="edit"/></a>
                        </li>
                        <li class="dolock">
                            <a class="dublicate hide-single" data-toggle="tooltip" data-placement="top" title="Dublicate"><i class="fa far fa-copy"></i><spring:message code="dashboard.chart.duplicate"/></a>
                        </li>                        
                        <li class="dropdown-submenu">
                            <a class="more" tabindex="-1" href="#"><i class="fa fa-cube"></i><spring:message code="dashboard.chart.saveAs"/><i class="fa fa-caret-right float-right"></i></a>
                            <ul class="dropdown-menu shadow">
                                <li>
                                    <a class="csv" data-toggle="tooltip" data-placement="top" title="Save as csv"><i class="fa fa-th-list"></i> <spring:message code="dashboard.chart.saveAs.csv"/></a>
                                </li>
                                <li>
                                    <a class="jsonsave" data-toggle="tooltip" data-placement="top" title="Save as json"><span class="jsonIcon">{:}</span> <spring:message code="dashboard.chart.saveAs.json"/></a>
                                </li>
                                <li>
                                    <a class="imagesave" data-toggle="tooltip" data-placement="top" title="Save as Image"><i class="fa far fa-image"></i> <spring:message code="dashboard.chart.saveAs.image"/></a>
                                </li>
                            </ul>
                        </li>
                        <li><hr class="border-danger my-1"></li>                        
                        <li class="dolock hide-single">
                            <a class="deletewidget" data-toggle="tooltip" data-placement="top" title="Delete chart"><i class="fa fa-trash"></i><spring:message code="dashboard.chart.remove"/></a>
                        </li>
                    </ul> 
                </div>
                    
            </div>          
            <div class="echart_line overflow-hidden" style="height:300px;"></div>                   
        </div>
    </div>   
</div>
                            
<div class="row">
    <div class="col-12 ">
        <div class="card fulldash shadow" style="display: none">
            <div class="card-header dash_header">
                <div class="item_title float-left pt-2" >
                    <div class="title_text">
                        <span>${dashname}</span>
                        <i class="change_title fa fas fa-pencil-alt"></i>
                    </div>
                    <div class="title_input">
                        <input class="enter_title" type="text" name="name" id="name" value="${dashname}">
                        <i class="savetitle fa fa-check"></i>
                    </div>
                </div>        
                <div class="float-right">                   
                    <div class="btn-group blockSaveJsonRowDelete">                
                        <div class="btn-group" role="group">
                            <button class="btn btn-outline-dark savedash" type="button" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.saveDash"/>">
                                <i class="fa far fa-save"></i>
                            </button>
                            <button id="btnSaveAsTemplate" class="btn btn-outline-dark dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
                                <span class="caret"></span>
                                <span class="sr-only"></span>
                            </button>
                            <div class="dropdown-menu" aria-labelledby="btnSaveAsTemplate">
                                <a class="dropdown-item savedashasTemplate"><spring:message code="dashboard.saveAsTemplate"/></a>
                            </div>
                        </div>
                        <div class="btn-group" role="group">
                            <button class="btn btn-outline-dark" id="showasjson" type="button" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.viewDashJSON"/>">
                                <i class="fa fa-edit"></i>
                            </button>
                            <button class="btn btn-outline-dark" id="addrow" type="button" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.addRow"/>">
                                <i class="fa fa-layer-group"></i>
                            </button>
                            <button class="btn btn-outline-dark" id="deletedash" type="button" type="button" data-toggle="tooltip" data-placement="top" title="<spring:message code="dashboard.title.deleteDashboard"/>">
                                <i class="fa fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>                 
            </div>                                        
            <div id="maximize" class="btn btnlock reflock float-right"  data-toggle="tooltip"  data-placement="bottom" title='Show Filter'>                        
                <i class="fa fa fa-eye"></i>
            </div>

            <div class="card-body" id="dash_main">  
                <div  id="filter" class="filter form form-row raw">
                    <div class="col-6">
                        <div class="blockDownsampleAggregatorEnabled form-inline">
                            <div class="mr-2">
                                <label class="col-form-label text-nowrap down-sample-label" for="global-down-sample"><spring:message code="dashboard.downSample"/></label> 
                            </div>
                            <div class="mr-2">
                                <input class="form-control  query_input" id="global-down-sample" name="global-down-sample" type="text">  
                            </div>
                            <div class="mr-2">
                                <label class="col-form-label" for="global-down-sample-ag"><spring:message code="dashboard.agregator"/></label>          
                            </div>
                            <div class="mr-2">
                                <div class="select2wraper global-down-sample-ag-wraper">
                                    <select class="form-control" id="global-down-sample-ag" name="global-down-sample-ag" data-width="100%"></select>      
                                </div>                                      
                            </div>
                            <div class="mr-2">
                                <label class="col-form-label" id="downsampling_label" for="global-downsampling-switsh"> <spring:message code="dashboard.enabled"/></label>            
                            </div>                        
                            <div class="checkbox">                
                                <input class="js-switch-general" type="checkbox" style="display: none" chart_prop_key="" id="global-downsampling-switsh" name="global-downsampling-switsh"/> 
                            </div>  
                        </div>    
                    </div>
                    <div class="col-6">
                        <div class="row float-right"> 
                            <div class="col-12">
                                <div class="blockTimeRefreshLock form-row float-right">
                                    <div id="reportrange" class="reportrange" data-toggle="tooltip"  title="<spring:message code="dashboard.title.quickRanges"/>" data-placement="bottom" >
                                        <i class="fa fa-calendar"></i>
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
                                    <div id="refresh" class="reflock" data-toggle="tooltip"  title="<spring:message code="dashboard.title.refresh"/>" data-placement="bottom" >                        
                                        <i class="fas fa-sync"></i>
                                    </div>                                    
                                    <div id="btnlock" class="btnlock reflock"  data-toggle="tooltip"  data-placement="bottom">                        
                                        <i class="fa fas fa-lock" ></i>
                                    </div>
                                    <div id="minimize" class="btnlock reflock"  data-toggle="tooltip"  data-placement="bottom" title="<spring:message code="dash.title.hideFilter"/>">                        
                                        <i class="fa fa fa-eye-slash" ></i>
                                    </div>    
                                </div>  
                            </div>

                        </div>                
                    </div>    
                </div> 
            </div>
            <div class="card shadow" id="dashcontent"></div>                     
        </div>                                      
</div>
            
<div id="deleteConfirm" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><spring:message code="confirmation"/></h4>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p><spring:message code="dashboard.Modal.confirmDelDashboard"/></p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <input type="button" id="deletedashconfirm" class="btn btn-ok" value="<spring:message code="delete"/>">
                <input   type="button" class="btn btn-outline-secondary" data-dismiss="modal" value="<spring:message code="close"/>">                
            </div>
        </div>
    </div>
</div>                
<div id="showjson" class="modal  fade" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><spring:message code="dashboard.Modal.jsonEditor"/></h4>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>                
            </div>
            <div class="modal-body">
                <div id="dasheditor"></div>
            </div>
            <div class="modal-footer">
                <input type="button" id="applyrowjson" class="btn btn-ok btn-outline-success" value="<spring:message code="apply"/>">
                <input   type="button" class="btn btn-outline-secondary" data-dismiss="modal"value="<spring:message code="close"/>">                
            </div>
        </div>
    </div>
</div> 
           
</div>             
