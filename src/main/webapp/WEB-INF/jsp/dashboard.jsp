<%-- 
    Document   : dashboardOE
    Created on : Apr 17, 2019, 4:55:00 PM
    Author     : tigran
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!--<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}"/>-->
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
            <div class="chartTitleDiv depthShadowLightHover">
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
            <div class="echart_line row" style="height:300px;"></div>                   
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
                                <select class="form-control" id="global-down-sample-ag" name="global-down-sample-ag" data-width="100%"></select>            
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
                                        
                                        
             <nav>
  <div class="nav nav-tabs" id="nav-tab" role="tablist">
    <a class="nav-item nav-link" id="nav-general-tab" data-toggle="tab" href="#nav-general" role="tab" aria-controls="nav-general" aria-selected="true">General</a>
    <a class="nav-item nav-link active" id="nav-metrics-tab" data-toggle="tab" href="#nav-metrics" role="tab" aria-controls="nav-metrics" aria-selected="false">Metrics</a>
    <a class="nav-item nav-link" id="nav-axes-tab" data-toggle="tab" href="#nav-axes" role="tab" aria-controls="nav-axes" aria-selected="false">Axes</a>
    <a class="nav-item nav-link" id="nav-datazoom-tab" data-toggle="tab" href="#nav-datazoom" role="tab" aria-controls="nav-datazoom" aria-selected="true">Data Zoom</a>
    <a class="nav-item nav-link" id="nav-legend-tab" data-toggle="tab" href="#nav-legend" role="tab" aria-controls="nav-legend" aria-selected="false">Legend</a>
    <a class="nav-item nav-link" id="nav-display-tab" data-toggle="tab" href="#nav-display" role="tab" aria-controls="nav-display" aria-selected="false">Display</a>
    <a class="nav-item nav-link" id="nav-timerange-tab" data-toggle="tab" href="#nav-timerange" role="tab" aria-controls="nav-timerange" aria-selected="true">Time Range</a>
    <a class="nav-item nav-link" id="nav-json-tab" data-toggle="tab" href="#nav-json" role="tab" aria-controls="nav-json" aria-selected="false">Json</a>
  </div>
</nav>
<div class="tab-content" id="nav-tabContent">
  <div class="tab-pane fade" id="nav-general" role="tabpanel" aria-labelledby="nav-general-tab"> General </div>
  <div class="tab-pane fade show active" id="nav-metrics" role="tabpanel" aria-labelledby="nav-metrics-tab"> Metrics </div>
  <div class="tab-pane fade" id="nav-axes" role="tabpanel" aria-labelledby="nav-axes-tab"> Axes </div>
  <div class="tab-pane fade" id="nav-datazoom" role="tabpanel" aria-labelledby="nav-datazoom-tab"> Data Zoom </div>
  <div class="tab-pane fade" id="nav-legend" role="tabpanel" aria-labelledby="nav-legend-tab"> Legend </div>
  <div class="tab-pane fade" id="nav-display" role="tabpanel" aria-labelledby="nav-display-tab"> Display  </div>
  <div class="tab-pane fade" id="nav-timerange" role="tabpanel" aria-labelledby="nav-timerange-tab"> Time Range </div>
  <div class="tab-pane fade" id="nav-json" role="tabpanel" aria-labelledby="nav-json-tab"> Json </div>
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
 
            
<!--            <div role="tabpanel" id="tabpanel"><ul id="formTab" class="nav nav-tabs bar_tabs" role="tablist">
                    <li role="presentation"><a href="#tab_general" id="general-tab" role="tab" data-toggle="tab">General</a></li>
                    <li role="presentation" class="active"><a href="#tab_metric" id="metrics-tab" role="tab" data-toggle="tab">Metrics</a></li>
                    <li role="presentation"><a href="#tab_axes" id="axes-tab" role="tab" data-toggle="tab">Axes</a></li>
                    <li role="presentation"><a href="#tab_data_zoom" id="data_zoom_tab" role="tab" data-toggle="tab">Data Zoom</a></li>
                    <li role="presentation"><a href="#tab_legend" id="legend-tab" role="tab" data-toggle="tab">Legend</a></li>
                    <li role="presentation"><a href="#tab_display" id="display-tab" role="tab" data-toggle="tab">Display</a></li>
                    <li role="presentation"><a href="#tab_time" id="time-tab" role="tab" data-toggle="tab">Time Range</a></li>
                    <li role="presentation"><a href="#tab_json" id="json-tab" role="tab" data-toggle="tab">Json</a></li></ul>
                    <div id="TabContent" class="tab-content">
                        <div role="tabpanel" class="tab-pane fade in" id="tab_general" aria-labelledby="general-tab">
                            <div class="row">
                                <form class="form-horizontal form-label-left pull-left" id="edit_chart_title">
                                    <div class="form_main_block">
                                        <h3><label class="control-label">Info</label></h3>
                                        <div class="form-group form-group-custom">
                                            <label class="control-label control-label-custom" for="title_text">Title</label>
                                            <input class="form-control title_input_large" id="title_text" type="text" prop_key="text" name="title_text" key_path="title.text">
                                            <label class="control-label control-label-custom2" for="title_font">Font Size</label>
                                            <input class="form-control title_input_large general_font" id="title_font" type="number" prop_key="text" name="title_font" key_path="title.style.fontSize">
                                            <i class="dropdown_button fa fa-chevron-circle-down" target="title_subtitle" id="button_title_subtitle"></i>
                                            <div class="form-group form-group-custom" id="title_subtitle" style="display: none;">
                                                <label class="control-label control-label-custom" for="title_link">Link</label>
                                                <input class="form-control title_input" id="title_link" type="text" prop_key="link" name="title_link" key_path="title.link">
                                                <label class="control-label control-label-custom2" for="title_target">Target</label>
                                                <select class="form-control title_select_gen select2-hidden-accessible" id="title_target" prop_key="target" name="title_target" key_path="title.target" tabindex="-1" aria-hidden="true">
                                                    <option value="">&nbsp;</option>
                                                    <option value="self">Self</option>
                                                    <option value="blank">Blank</option>
                                                </select>
                                                <span class="select2 select2-container select2-container--default" dir="ltr" style="width: 65px;">
                                                    <span class="selection">
                                                        <span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-title_target-container">
                                                            <span class="select2-selection__rendered" id="select2-title_target-container" title="&nbsp;">&nbsp;</span>
                                                            <span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span>
                                                        </span>
                                                    </span>
                                                    <span class="dropdown-wrapper" aria-hidden="true"></span>
                                                        
                                                </span>
                                            </div>
                                        </div>
                                        <div class="form-group form-group-custom">
                                            <label class="control-label control-label-custom" for="title_subtext">Description</label>
                                            <input class="form-control title_input_large" id="title_subtext" type="text" prop_key="subtext" name="title_subtext" key_path="title.subtext">
                                            <label class="control-label control-label-custom2" for="description_font">Font Size</label>
                                            <input class="form-control title_input_large general_font" id="description_font" type="number" prop_key="text" name="description_font" key_path="title.subtextStyle.fontSize">
                                            <i class="dropdown_button fa fa-chevron-circle-down" target="title_subdescription" id="button_title_description"></i>
                                            <div class="form-group form-group-custom" id="title_subdescription" style="display: none;">
                                                <label class="control-label control-label-custom" for="title_sublink">Link</label>
                                                <input class="form-control title_input" id="title_sublink" type="text" prop_key="sublink" name="title_sublink" key_path="title.sublink">
                                                <label class="control-label control-label-custom2" for="title_subtarget">Target</label>
                                                <select class="form-control title_select_gen select2-hidden-accessible" id="title_subtarget" prop_key="subtarget" name="title_subtarget" key_path="title.subtarget" tabindex="-1" aria-hidden="true">
                                                    <option value="">&nbsp;</option>
                                                    <option value="self">Self</option>
                                                    <option value="blank">Blank</option>
                                                </select>
                                                <span class="select2 select2-container select2-container--default" dir="ltr" style="width: 65px;">
                                                    <span class="selection">
                                                        <span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-title_subtarget-container">
                                                            <span class="select2-selection__rendered" id="select2-title_subtarget-container" title="&nbsp;">&nbsp;</span>
                                                            <span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span>
                                                        </span>
                                                    </span>
                                                    <span class="dropdown-wrapper" aria-hidden="true">
                                                        
                                                    </span>
                                                        
                                                </span>
                                            </div>
                                        </div>
                                        <div class="raw">
                                            <div id="buttons_div">
                                                <button class="btn btn-primary btn-xs button_title_adv" target="position_block" id="button_title_position" type="button">Positions<i class="fa fa-chevron-circle-down"></i></button>
                                                <button class="btn btn-primary btn-xs button_title_adv" target="color_block" id="button_title_color" type="button">Colors<i class="fa fa-chevron-circle-down"></i></button>
                                                <button class="btn btn-primary btn-xs button_title_adv" target="border_block" id="button_title_border" type="button">Border<i class="fa fa-chevron-circle-down"></i></button>
                                            </div>
                                        </div>
                                        <div id="position_block" style="display: none;">
                                            <div class="form-group form-group-custom">
                                                <label class="control-label control-label-custom" for="title_x_position">X</label>
                                                <select class="form-control title_select select2-hidden-accessible" id="title_x_position" prop_key="x" name="title_x_position" key_path="title.x" tabindex="-1" aria-hidden="true">
                                                    <option value="">&nbsp;</option>
                                                    <option value="center">Center</option>
                                                    <option value="left">Left</option>
                                                    <option value="right">Right</option>
                                                </select>
                                                <span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;">
                                                    <span class="selection">
                                                        <span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-title_x_position-container">
                                                            <span class="select2-selection__rendered" id="select2-title_x_position-container" title="&nbsp;">&nbsp;</span>
                                                            <span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span>
                                                        </span>
                                                    </span>
                                                    <span class="dropdown-wrapper" aria-hidden="true"></span>
                                                        
                                                </span>
                                                <label class="control-label control-label-custom3 control_label_or">OR</label>
                                                <input class="form-control title_input_small" id="title_x_position_text" type="number" prop_key="x" name="title_x_position_text" key_path="title.x">
                                                <label class="control-label control-label-custom3 control_label_custom3">px</label>
                                                <label class="control-label control-label_Y" for="title_y_position">Y</label>
                                                <select class="form-control title_select select2-hidden-accessible" id="title_y_position" prop_key="y" name="title_y_position" key_path="title.y" tabindex="-1" aria-hidden="true">
                                                    <option value="">&nbsp;</option>
                                                    <option value="center">Center</option>
                                                    <option value="top">Top</option>
                                                    <option value="bottom">Bottom</option>
                                                </select>
                                                <span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;">
                                                    <span class="selection">
                                                        <span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-title_y_position-container">
                                                            <span class="select2-selection__rendered" id="select2-title_y_position-container" title="&nbsp;">&nbsp;</span>
                                                            <span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span>
                                                        </span>
                                                    </span>
                                                    <span class="dropdown-wrapper" aria-hidden="true">
                                                        
                                                    </span>
                                                        
                                                </span>
                                                <label class="control-label control-label-custom3 control_label_or">OR</label>
                                                <input class="form-control title_input_small" id="title_y_position_text" type="number" prop_key="y" name="title_y_position_text" key_path="title.y">
                                                <label class="control-label control-label-custom3 control_label_custom3">px</label>
                                            </div>
                                        </div>
                                        <div id="color_block" style="display: none;">
                                            <div class="form-group form-group-custom" id="title_color">
                                                <label class="control-label control-label-custom" for="title_border_color">Border</label>
                                                <div class="titile_input_midle">
                                                    <div class="input-group cl_picer cl_picer_input colorpicker-element">
                                                        <input class="form-control" id="title_border_color" type="text" prop_key="borderColor" name="title_border_color" key_path="title.style.borderColor">
                                                        <span class="input-group-addon"><i></i></span>
                                                    </div>
                                                </div>
                                                <label class="control-label control-label-custom" for="title_background_color">Background</label>
                                                <div class="titile_input_midle">
                                                    <div class="input-group cl_picer cl_picer_input colorpicker-element">
                                                        <input class="form-control" id="title_background_color" type="text" prop_key="backgroundColor" name="title_background_color" key_path="title.style.backgroundColor">
                                                        <span class="input-group-addon"><i></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group form-group-custom">
                                                <label class="control-label control-label-custom" for="title_name_color">Title</label>
                                                <div class="titile_input_midle">
                                                    <div class="input-group cl_picer cl_picer_input colorpicker-element">
                                                        <input class="form-control" id="title_name_color" type="text" prop_key="TitleColor" name="title_name_color" key_path="title.style.color">
                                                        <span class="input-group-addon"><i></i></span>
                                                    </div>
                                                </div>
                                                <label class="control-label control-label-custom" for="title_description_color">Description</label>
                                                <div class="titile_input_midle"><div class="input-group cl_picer cl_picer_input colorpicker-element">
                                                        <input class="form-control" id="title_description_color" type="text" prop_key="descriptioncolor" name="title_description_color" key_path="title.subtextStyle.color">
                                                        <span class="input-group-addon"><i></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="border_block" style="display: none;">
                                            <div class="form-group form-group-custom">
                                                <label class="control-label control-label-custom" for="title_border_color">Color</label>
                                                <div class="titile_input_midle"><div class="input-group cl_picer cl_picer_input colorpicker-element">
                                                        <input class="form-control" id="title_border_color" type="text" prop_key="borderColor" name="title_border_color" key_path="title.style.borderColor">
                                                        <span class="input-group-addon"><i></i></span>
                                                    </div>
                                                </div>
                                                <label class="control-label control-label2" for="title_border_width">Width</label>
                                                <div class="titile_input_midle2">
                                                    <div class="input-group">
                                                        <input class="form-control titile_input_midle" id="title_border_width" type="number" prop_key="borderWidth" name="title_border_width" key_path="title.style.borderWidth">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <form class="form-horizontal form-label-left pull-left" id="edit_dimensions">
                                    <div class="form_main_block">
                                        <h3><label class="control-label">Dimensions</label></h3>
                                        <div class="form-group form-group-custom">
                                            <label class="control-label control-label-custom120" for="dimensions_span">Span</label>
                                            <select class="form-control dimensions_input select2-hidden-accessible" id="dimensions_span" prop_key="size" name="dimensions_span" key_path="size" tabindex="-1" aria-hidden="true">
                                                <option value="1">1</option>
                                                <option value="2">2</option>
                                                <option value="3">3</option>
                                                <option value="4">4</option>
                                                <option value="5">5</option>
                                                <option value="6">6</option>
                                                <option value="7">7</option>
                                                <option value="8">8</option>
                                                <option value="9">9</option>
                                                <option value="10">10</option>
                                                <option value="11">11</option>
                                                <option value="12">12</option>
                                            </select>
                                            <span class="select2 select2-container select2-container--default" dir="ltr" style="width: 100px;">
                                                <span class="selection">
                                                    <span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-dimensions_span-container">
                                                        <span class="select2-selection__rendered" id="select2-dimensions_span-container" title="12">12</span>
                                                        <span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span>
                                                    </span>
                                                </span>
                                                <span class="dropdown-wrapper" aria-hidden="true"></span>
                                                    
                                            </span>
                                        </div>
                                        <div class="form-group form-group-custom">
                                            <label class="control-label control-label-custom120" for="dimensions_height">Height</label>
                                            <input class="form-control dimensions_input" id="dimensions_height" type="text" prop_key="height" name="dimensions_height" key_path="height">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane fade in active" id="tab_metric" aria-labelledby="metrics-tab">
                            <div class="row">
                                <div class="forms" id="edit_q">
                                    <div class="form_main_block">
                                        <button class="btn btn-success Addq btn-xs" id="addq" key_path="q" value="">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane fade in" id="tab_axes" aria-labelledby="axes-tab">
                            <div class="row">
                                <div class="form_main_block pull-left" id="edit_y">
                                    <div class="form_main_block">
                                        <h3><label class="control-label">Y axes</label></h3>
                                        <div class="form_main_block" key_path="options.yAxis">
                                            <form class="form-horizontal form-label-left edit-axes" template_index="0" id="0_yaxes">
                                                <div class="form-group form-group-custom">
                                                    <label class="control-label control-label-custom-legend" for="axes_show_y">Show</label>
                                                    <input class="js-switch-small axes_show_y" template_index="0" id="0_axes_show_y" type="checkbox" prop_key="show" name="axes_show_y" key_path="show" checked="checked" data-switchery="true" style="display: none;">
                                                    <span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;">
                                                        <small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small>
                                                    </span>
                                                </div>
                                                <div class="form-group form-group-custom">
                                                    <label class="control-label control-label-custom-legend" for="axes_name_y">Text</label>
                                                    <input class="form-control axes_select" template_index="0" id="0_axes_name_y" type="text" prop_key="name" name="axes_name_y" key_path="name">
                                                </div>
                                                <div class="form-group form-group-custom">
                                                    <label class="control-label control-label-custom-legend" for="axes_position_y">Position</label>
                                                    <select class="form-control axes_select select2-hidden-accessible" template_index="0" id="0_axes_position_y" prop_key="position" name="axes_position_y" key_path="position" tabindex="-1" aria-hidden="true">
                                                        <option value="">&nbsp;</option>
                                                        <option value="left">Left</option>
                                                        <option value="right">Right</option>
                                                    </select>
                                                    <span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;">
                                                        <span class="selection">
                                                            <span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-0_axes_position_y-container">
                                                                <span class="select2-selection__rendered" id="select2-0_axes_position_y-container" title="&nbsp;">&nbsp;</span>
                                                                <span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span>
                                                            </span>
                                                        </span>
                                                        <span class="dropdown-wrapper" aria-hidden="true"></span>
                                                            
                                                    </span>
                                                </div>
                                                <div class="form-group form-group-custom">
                                                    <label class="control-label control-label-custom-legend" for="axes_splitNumber_y">Split Number</label>
                                                    <input class="form-control axes_select" template_index="0" id="0_splitNumber_y" type="number" prop_key="splitNumber" name="splitNumber_y" key_path="splitNumber">
                                                </div>
                                                <div class="form-group"><label class="control-label control-label-custom-legend" for="axes_color_y">Y color</label><div class="titile_input_midle axes_select"><div class="input-group cl_picer cl_picer_input hasdublicatepath colorpicker-element"><input class="form-control" template_index="0" id="0_ycolor" type="text" prop_key="ycolor" name="ycolor" key_path="axisLine.lineStyle.color"><span class="input-group-addon"><i></i></span></div></div></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="lable_size_y">Font Size Label</label><input class="form-control axes_select axis_input-size" template_index="0" id="0_label_size_y" type="number" prop_key="size_x" name="lable_size_y" key_path="axisLabel.fontSize"><label class="control-label control-label-custom-legend axis_lable-size" for="text_size_x">Text</label><input class="form-control axes_select axis_input-size" template_index="0" id="0_text_size_y" type="number" prop_key="text_size_y" name="text_size_y" key_path="nameTextStyle.fontSize"></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="axes_unit_y">Unit</label><select class="form-control axes_select select2-hidden-accessible" template_index="0" id="0_axes_unit_y" prop_key="unit" name="axes_unit_y" key_path="unit" tabindex="-1" aria-hidden="true"><optgroup label="None"><option value="">None</option><option value="format_metric">Short</option><option value="{value} %">Percent(0-100)</option><option value="format100">Percent(0.0-1.0)</option><option value="{value} %H">Humidity(%H)</option><option value="{value} ppm">PPM</option><option value="{value} dB">Decible</option><option value="formathexadecimal0">Hexadecimal(0x)</option><option value="formathexadecimal">Hexadecimal</option></optgroup><optgroup label="Currency"><option value="$ {value}">Dollars ($)</option><option value="£ {value}">Pounds (£)</option><option value="€ {value}">Euro (€)</option><option value="¥ {value}">Yen (¥)</option><option value="{value} руб.">Rubles (руб)</option></optgroup><optgroup label="Time"><option value="formathertz">Hertz (1/s)</option><option value="timens">Nanoseconds (ns)</option><option value="timemicros">microseconds (µs)</option><option value="timems">Milliseconds (ms)</option><option value="timesec">Seconds (s)</option><option value="timemin">Minutes (m)</option><option value="timeh">Hours (h)</option><option value="timed">Days d</option></optgroup><optgroup label="Data IEC"><option value="dataBit">Bits</option><option value="dataBytes">Bytes</option><option value="dataKiB">Kibibytes</option><option value="dataMiB">Mebibytes</option><option value="dataGiB">Gibibytes</option></optgroup><optgroup label="Data (Metric)"><option value="dataBitmetric">Bits</option><option value="dataBytesmetric">Bytes</option><option value="dataKiBmetric">Kilobytes</option><option value="dataMiBmetric">Megabytes</option><option value="dataGiBmetric">Gigabytes</option></optgroup><optgroup label="Data Rate"><option value="formatPpS">Packets/s</option><option value="formatbpS">Bits/s</option><option value="formatBpS">Bytes/s</option><option value="formatKbpS">Kilobits/s</option><option value="formatKBpS">Kilobytes/s</option><option value="formatMbpS">Megabits/s</option><option value="formatMBpS">Megabytes/s</option><option value="formatGBbpS">Gigabits/s</option><option value="formatGBpS">Gigabytes/s</option></optgroup><optgroup label="Throughput"><option value="formatops">Ops/sec (ops)</option><option value="formatrps">Reads/sec (rps)</option><option value="formatwps">Writes/sec (wps)</option><option value="formatiops">I/O Ops/sec (iops)</option><option value="formatopm">Ops/min (opm)</option><option value="formatrpm">Reads/min (rpm)</option><option value="formatwpm">Writes/min (wpm)</option></optgroup><optgroup label="Lenght"><option value="formatmm">Millimeter (mm)</option><option value="formatm">Meter (m)</option><option value="formatkm">Kilometer (km)</option><option value="{value} mi">Mile (mi)</option></optgroup><optgroup label="Velocity"><option value="{value} m/s">m/s</option><option value="{value} km/h">km/h</option><option value="{value} mph">mph</option><option value="{value} kn">knot</option></optgroup><optgroup label="Volume"><option value="formatmL">Millilitre</option><option value="formatL">Litre</option><option value="formatm3">Cubic Metre</option></optgroup><optgroup label="Energy"><option value="formatW">Watt (W)</option><option value="formatKW">Kilowatt (KW)</option><option value="formatVA">Volt-Ampere (VA)</option><option value="formatKVA">Kilovolt-Ampere (KVA)</option><option value="formatVAR">Volt-Ampere Reactive (VAR)</option><option value="formatVH">Watt-Hour (VH)</option><option value="formatKWH">Kilowatt-Hour (KWH)</option><option value="formatJ">Joule (J)</option><option value="formatEV">Electron-Volt (EV)</option><option value="formatA">Ampere (A)</option><option value="formatV">Volt (V)</option><option value="{value} dBm">Decibell-Milliwatt (DBM)</option></optgroup><optgroup label="Temperature"><option value="{value} °C">Celsius (°C)</option><option value="{value} °F">Farenheit (°F)</option><option value="{value} K">Kelvin (K)</option></optgroup><optgroup label="Pressure"><option value="{value} mbar">Millibars</option><option value="{value} hPa">Hectopascals</option><option value="{value} &quot;Hg">Inches of Mercury</option><option value="formatpsi">PSI</option></optgroup></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-0_axes_unit_y-container"><span class="select2-selection__rendered" id="select2-0_axes_unit_y-container" title="None">None</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="axes_min_y">Y-Min</label><input class="form-control title_input_small" template_index="0" id="0_axes_min_y" type="number" prop_key="min" name="axes_min_y" key_path="min"><label class="control-label control-label-custom-axes" for="axes_max_y">Y-Max</label><input class="form-control title_input_small" template_index="0" id="0_axes_max_y" type="number" prop_key="max" name="axes_max_y" key_path="max"></div><div class="btn btn-success dublicateq btn-xs" template_index="0" id="0_dublicateaxesy">Dublicate</div><div class="btn btn-danger removeq btn-xs" template_index="0" id="0_removeaxesy">Remove</div></form><button class="btn btn-success Addq btn-xs" id="addq" key_path="options.yAxis">Add</button></div></div></div><section class="form_main_block pull-left" id="edit_x"><div class="form_main_block"><h3><label class="control-label">X axes</label></h3><div class="form_main_block" key_path="options.xAxis"><form class="form-horizontal form-label-left edit-axes" template_index="0" id="0_xaxes"><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="axes_show_x">Show</label><input class="js-switch-small axes_show_x" template_index="0" id="0_axes_show_x" type="checkbox" prop_key="show" name="axes_show_x" key_path="show" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="axes_name_x">Text</label><input class="form-control axes_select" template_index="0" id="0_axes_name_x" type="text" prop_key="name" name="axes_name_x" key_path="name"></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="axes_position_x">Position</label><select class="form-control axes_select select2-hidden-accessible" template_index="0" id="0_axes_position_x" prop_key="position" name="axes_position_x" key_path="position" tabindex="-1" aria-hidden="true"><option value="">&nbsp;</option><option value="bottom">Bottom</option><option value="top">Top</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-0_axes_position_x-container"><span class="select2-selection__rendered" id="select2-0_axes_position_x-container" title="&nbsp;">&nbsp;</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="axes_splitNumber_x">Split Number</label><input class="form-control axes_select" template_index="0" id="0_splitNumber_x" type="number" prop_key="splitNumber" name="splitNumber_x" key_path="splitNumber"></div><div class="form-group"><label class="control-label control-label-custom-legend" for="axes_color_x">X color</label><div class="titile_input_midle axes_select"><div class="input-group cl_picer cl_picer_input hasdublicatepath colorpicker-element"><input class="form-control axes_select" template_index="0" id="0_xcolor" type="text" prop_key="xcolor" name="xcolor" key_path="axisLine.lineStyle.color"><span class="input-group-addon"><i></i></span></div></div></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="lable_size_x">Font Size Label</label><input class="form-control axes_select axis_input-size" template_index="0" id="0_label_size_x" type="number" prop_key="size_x" name="lable_size_x" key_path="axisLabel.fontSize"><label class="control-label control-label-custom-legend axis_lable-size" for="text_size_x">Text</label><input class="form-control axes_select axis_input-size" template_index="0" id="0_text_size_x" type="number" prop_key="text_size_x" name="text_size_x" key_path="nameTextStyle.fontSize"></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="axes_mode_x">Scale</label><select class="form-control axes_select select2-hidden-accessible" template_index="0" id="0_axes_mode_x" prop_key="type" name="axes_mode_x" key_path="type" tabindex="-1" aria-hidden="true"><option value="time">Time</option><option value="category">Series</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-0_axes_mode_x-container"><span class="select2-selection__rendered" id="select2-0_axes_mode_x-container" title="Time">Time</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom only-Series" style="display: none;"><label class="control-label control-label-custom-legend" for="axes_value_x">Value</label><select class="form-control axes_select select2-hidden-accessible" template_index="0" id="0_axes_value_x" prop_key="m_sample" name="axes_value_x" key_path="m_sample" tabindex="-1" aria-hidden="true"><option value="avg">Avg</option><option value="min">Min</option><option value="max">Max</option><option value="total">Total</option><option value="count">Count</option><option value="current">Current</option><option value="product">Product</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-0_axes_value_x-container"><span class="select2-selection__rendered" id="select2-0_axes_value_x-container"></span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="btn btn-success dublicateq btn-xs" template_index="0" id="0_dublicateaxesx">Dublicate</div><div class="btn btn-danger removeq btn-xs" template_index="0" id="0_removeaxesx">Remove</div></form><button class="btn btn-success Addq btn-xs" id="addq" key_path="options.xAxis">Add</button></div></div></section></div></div><div role="tabpanel" class="tab-pane fade in" id="tab_data_zoom" aria-labelledby="data_zoom_tab"> <div class="row"><div class="forms" id="edit_data_zoom"><div class="form_main_block"><div class="form_main_block" key_path="options.dataZoom"><form class="form-horizontal form-label-left edit-datazoom pull-left" template_index="0" id="0_data_zoom"><div class="form-group form-group-custom forslider" style="display: none;"><label class="control-label control-label-custom-legend" for="data_zoom_show">Show</label><input class="js-switch-small data_zoom_show" template_index="0" id="0_data_zoom_show" type="checkbox" prop_key="show" name="data_zoom_show" key_path="show" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span></div><div class="form-group form-group-custom forinside"><label class="control-label control-label-custom-legend" for="data_zoom_disabled">Disabled</label><input class="js-switch-small data_zoom_disabled" template_index="0" id="0_data_zoom_disabled" type="checkbox" prop_key="disabled" name="data_zoom_disabled" key_path="disabled" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="box-shadow: rgb(223, 223, 223) 0px 0px 0px 0px inset; border-color: rgb(223, 223, 223); background-color: rgb(255, 255, 255); transition: border 0.4s, box-shadow 0.4s;"><small style="left: 0px; transition: background-color 0.4s, left 0.2s;"></small></span></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="datazoom_start">Start %</label><input class="form-control title_input_small" template_index="0" id="0_datazoom_start" type="number" min="0" max="100" prop_key="start" name="datazoom_start" key_path="start"><label class="control-label control-label-custom-axes" for="datazoom_end">End %</label><input class="form-control title_input_small" template_index="0" id="0_datazoom_end" type="number" min="0" max="100" prop_key="end" name="datazoom_end" key_path="end"></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="datazoom_type">Type</label><select class="form-control query_input datazoom_type_width select2-hidden-accessible" template_index="0" id="0_datazoom_type" prop_key="type" name="datazoom_type" key_path="type" tabindex="-1" aria-hidden="true"><option value="slider">Scroll</option><option value="inside">Inner</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 200px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-0_datazoom_type-container"><span class="select2-selection__rendered" id="select2-0_datazoom_type-container" title="Inner">Inner</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="data_zoom_xAxisIndex">XaxisIndex</label><div template_index="0" id="0_data_zoom_xAxisIndex" type="choose_array" name="data_zoom_xAxisIndex" style="display:inline-block" key_path="xAxisIndex"><span>0<div class="icheckbox_flat-green checked" style="position: relative;"><input type="checkbox" index="0" class="flat" ,="" name="data_zoom_xAxisIndex[]" checked="true" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div></span></div></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="data_zoom_yAxisIndex">YaxisIndex</label><div template_index="0" id="0_data_zoom_yAxisIndex" type="choose_array" name="data_zoom_yAxisIndex" style="display:inline-block" key_path="yAxisIndex"><span>0<div class="icheckbox_flat-green" style="position: relative;"><input type="checkbox" index="0" class="flat" ,="" name="data_zoom_yAxisIndex[]" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div></span></div></div><div class="btn btn-success dublicateq btn-xs pull-right" template_index="0" id="0_dublicatedatazoom">Dublicate</div><div class="btn btn-danger removeq btn-xs pull-right" template_index="0" id="0_removedatazoom">Remove</div></form><button class="btn btn-success Addq btn-xs" id="addq" key_path="options.dataZoom">Add</button></div></div></div></div></div><div role="tabpanel" class="tab-pane fade in" id="tab_legend" aria-labelledby="legend-tab"> <div class="row"><div class="form-horizontal form-label-left edit-legend pull-left" id="edit_legend"><div class="form_main_block"><h3><label class="control-label">Legend</label><div class="checkbox" style="display: inline-block"><input type="checkbox" class="js-switch-small" prop_key="show" id="legend_show" name="legend_show" "="" key_path="options.legend.show" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span> </div></h3><div class="legendform"><div class="form_main_block pull-left"><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_orient">Orient</label><select class="form-control title_select select2-hidden-accessible" id="legend_orient" prop_key="orient" name="legend_orient" key_path="options.legend.orient" tabindex="-1" aria-hidden="true"><option value="horizontal">Horizontal</option><option value="vertical">Vertical</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-legend_orient-container"><span class="select2-selection__rendered" id="select2-legend_orient-container"></span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_select_mode">Select Mode</label><select class="form-control title_select select2-hidden-accessible" prop_key="selectedMode" name="legend_select_mode" key_path="options.legend.selectedMode" tabindex="-1" aria-hidden="true"><option value="single">Single</option><option value="multiple">Multiple</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-legend_select_mode-2c-container"><span class="select2-selection__rendered" id="select2-legend_select_mode-2c-container"></span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_background_color">Background</label><div class="color-button"><div class="input-group cl_picer cl_picer_noinput colorpicker-element"><input class="form-control" id="legend_background_color" type="text" prop_key="backgroundColor" name="legend_background_color" key_path="options.legend.backgroundColor"><span class="input-group-addon"><i></i></span></div></div></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_text_color">Text Color</label><div class="color-button"><div class="input-group cl_picer cl_picer_noinput colorpicker-element"><input class="form-control" id="legend_text_color" type="text" prop_key="color" name="legend_text_color" key_path="options.legend.textStyle.color"><span class="input-group-addon"><i></i></span></div></div></div></div><div class="form_main_block pull-left"><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_x_position">X</label><select class="form-control title_select select2-hidden-accessible" id="legend_x_position" prop_key="x" name="legend_x_position" key_path="options.legend.x" tabindex="-1" aria-hidden="true"><option value="">&nbsp;</option><option value="center">Center</option><option value="left">Left</option><option value="right">Right</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-legend_x_position-container"><span class="select2-selection__rendered" id="select2-legend_x_position-container" title="&nbsp;">&nbsp;</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span><label class="control-label control-label-custom-legend2">OR</label><input class="form-control title_input_small" id="legend_x_position_text" type="number" prop_key="x" name="legend_x_position_text" key_path="options.legend.x"><label class="control-label control-label-custom3 control_label_custom3">px</label></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_y_position">Y</label><select class="form-control title_select select2-hidden-accessible" id="legend_y_position" prop_key="y" name="legend_y_position" key_path="options.legend.y" tabindex="-1" aria-hidden="true"><option value="">&nbsp;</option><option value="center">Center</option><option value="top">Top</option><option value="bottom">Bottom</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-legend_y_position-container"><span class="select2-selection__rendered" id="select2-legend_y_position-container" title="&nbsp;">&nbsp;</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span><label class="control-label control-label-custom-legend2">OR</label><input class="form-control title_input_small" id="legend_y_position_text" type="number" prop_key="y" name="legend_y_position_text" key_path="options.legend.y"><label class="control-label control-label-custom3 control_label_custom3">px</label></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_shape_width">Shape Width</label><input class="form-control title_select" id="legend_shape_width" type="number" prop_key="itemWidth" name="legend_shape_width" key_path="options.legend.itemWidth"><label class="control-label control-label-custom-legend2" for="legend_shape_height">Height</label><input class="form-control title_input_small" id="legend_shape_height" type="number" prop_key="itemHeight" name="legend_shape_height" key_path="options.legend.itemHeight"><label class="control-label control-label-custom3 control_label_custom3">px</label></div><div class="form-group form-group-custom"><label class="control-label control-label-custom-legend" for="legend_border_color">Border Color</label><div class="color-button"><div class="input-group cl_picer cl_picer_noinput colorpicker-element"><input class="form-control" id="legend_border_color" type="text" prop_key="borderColor" name="legend_border_color" key_path="options.legend.borderColor"><span class="input-group-addon"><i></i></span></div></div><label class="control-label control-label-custom-legend3" for="legend_border_width">Width</label><input class="form-control title_input_small" id="legend_border_width" type="number" prop_key="borderWidth" name="legend_border_width" key_path="options.legend.borderWidth"><label class="control-label control-label-custom3 control_label_custom3">px</label></div></div></div></div></div></div></div><div role="tabpanel" class="tab-pane fade in" id="tab_display" aria-labelledby="display-tab"> <div class="row"><div class="forms" id="edit_display"><div class="form_main_block"><div class="form-horizontal form-label-left edit-display pull-left"><div class="form_main_block pull-left"><div class="form-group form-group-custom"><label class="control-label control-label-custom" for="display_charttype">Type</label><select class="form-control title_input_small select2-hidden-accessible" id="display_charttype" prop_key="type" name="display_charttype" key_path="type" tabindex="-1" aria-hidden="true"><option value="line">Lines</option><option value="bar">Bars</option><option value="pie">Pie</option><option value="gauge">Gauge</option><option value="funnel">Funnel</option><option value="treemap">Treemap</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 74px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-display_charttype-container"><span class="select2-selection__rendered" id="select2-display_charttype-container" title="Lines">Lines</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span><label class="control-label control-label-custom120" for="backgroundColor">Color</label><div class="color-button"><div class="input-group cl_picer cl_picer_noinput colorpicker-element"><input class="form-control" id="backgroundColor" type="text" prop_key="backgroundColor" name="backgroundColor" key_path="options.backgroundColor"><span class="input-group-addon"><i></i></span></div></div></div><div class="form-group form-group-custom"><label class="control-label control-label-custom" for="display_animation">Animation</label><div class="checkbox" style="display: inline-block"><input class="js-switch-small" id="display_animation" type="checkbox" prop_key="animation" name="display_animation" key_path="options.animation" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span></div><label class="control-label control-label-custom155" for="display_containLabel">Contains label</label><div class="checkbox" style="display: inline-block"><input class="js-switch-small" id="display_containLabel" type="checkbox" prop_key="containLabel" name="display_containLabel" key_path="options.grid.containLabel" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span></div></div><div class="form-group form-group-custom"><label class="control-label control-label-custom" for="padding_left">Left</label><input class="form-control title_input_small" id="padding_left" type="text" prop_key="x" placeholder="auto" name="padding_left" key_path="options.grid.x"><label class="control-label control-label-custom120" for="padding_top">Top</label><input class="form-control title_input_small" id="padding_top" type="text" prop_key="y" placeholder="auto" name="padding_top" key_path="options.grid.y"></div><div class="form-group form-group-custom"><label class="control-label control-label-custom" for="padding_right">Right</label><input class="form-control title_input_small" id="padding_right" type="text" prop_key="x2" placeholder="auto" name="padding_right" key_path="options.grid.x2"><label class="control-label control-label-custom120" for="padding_bottom">Bottom</label><input class="form-control title_input_small" id="padding_bottom" type="text" prop_key="y2" placeholder="auto" name="padding_bottom" key_path="options.grid.y2"></div><div class="form-group form-group-custom"><label class="control-label control-label-custom" for="padding_width">Width</label><input class="form-control title_input_small" id="padding_width" type="text" prop_key="width" placeholder="auto" name="padding_width" key_path="options.grid.width"><label class="control-label control-label-custom120" for="padding_height">Height</label><input class="form-control title_input_small" id="padding_height" type="text" prop_key="height" placeholder="auto" name="padding_height" key_path="options.grid.height"></div></div><div class="form_main_block pull-left custominputs"><h4 class="form-group typeline typebars"><label class="control-label">Options</label></h4><div class="form-group form-group-custom typeline"><label class="control-label control-label-custom" for="display_points">Points</label><select class="form-control title_select select2-hidden-accessible" id="display_points" prop_key="points" name="display_points" key_path="points" tabindex="-1" aria-hidden="true"><option value="none">None</option><option value="circle">Circle</option><option value="rectangle">Rectangle</option><option value="triangle">Triangle</option><option value="diamond">Diamond</option><option value="emptyCircle">Empty Circle</option><option value="emptyRectangle">Empty Rectang</option><option value="emptyTriangle">Empty Triangl</option><option value="emptyDiamond">Empty Diamond</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-display_points-container"><span class="select2-selection__rendered" id="select2-display_points-container" title="None">None</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom typeline"><label class="control-label control-label-custom" for="display_fillArea">Fill Area</label><select class="form-control title_select select2-hidden-accessible" id="display_fillArea" prop_key="fill" name="display_fillArea" key_path="fill" tabindex="-1" aria-hidden="true"><option value="none">None</option><option value="0.1">1</option><option value="0.2">2</option><option value="0.3">3</option><option value="0.4">4</option><option value="0.5">5</option><option value="0.6">6</option><option value="0.7">7</option><option value="0.8">8</option><option value="0.9">9</option><option value="1.0">10</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-display_fillArea-container"><span class="select2-selection__rendered" id="select2-display_fillArea-container" title="None">None</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom typeline"><label class="control-label control-label-custom" for="display_steped">Staircase</label><select class="form-control title_select select2-hidden-accessible" id="step" prop_key="step" name="display_steped" key_path="step" tabindex="-1" aria-hidden="true"><option value="">None</option><option value="start">Start</option><option value="middle">Middle</option><option value="end">End</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 90px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-step-container"><span class="select2-selection__rendered" id="select2-step-container" title="None">None</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom typeline typebars"><label class="control-label control-label-custom" for="display_stacked">Stacked</label><div class="checkbox" style="display: inline-block"><input class="js-switch-small" id="display_stacked" type="checkbox" prop_key="stacked" name="display_stacked" key_path="stacked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="box-shadow: rgb(223, 223, 223) 0px 0px 0px 0px inset; border-color: rgb(223, 223, 223); background-color: rgb(255, 255, 255); transition: border 0.4s, box-shadow 0.4s;"><small style="left: 0px; transition: background-color 0.4s, left 0.2s;"></small></span></div></div><div class="form-group form-group-custom typeline"><label class="control-label control-label-custom" for="display_smooth">Smooth</label><div class="checkbox" style="display: inline-block"><input class="js-switch-small" id="display_smooth" type="checkbox" prop_key="smooth" name="display_smooth" key_path="smooth" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span></div></div></div><div class="form_main_block pull-left custominputs" id="axes_select"><h4 class="form-group typeline typebars typemap typepie typefunnel"><label class="control-label">Labels</label></h4><div class="form-group form-group-custom typeline typebars typemap"><label class="control-label control-label-custom120" for="display_label_pos">Position</label><select class="form-control axes_select select2-hidden-accessible" id="display_label_pos" prop_key="label.position" name="display_label_pos" key_path="label.position" tabindex="-1" aria-hidden="true"><option value="top">Top</option><option value="left">Left</option><option value="right">Right</option><option value="bottom">Bottom</option><option value="inside">Inside</option><option value="insideLeft">Inside Left</option><option value="insideRight">Inside Right</option><option value="insideTop">Inside Top</option><option value="insideBottom">Inside Bottom</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-display_label_pos-container"><span class="select2-selection__rendered" id="select2-display_label_pos-container" title="Inside">Inside</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom typefunnel" style="display: none;"><label class="control-label control-label-custom120" for="display_label_pos">Position</label><select class="form-control axes_select select2-hidden-accessible" id="display_label_pos" prop_key="label.position" name="display_label_pos" key_path="label.position" tabindex="-1" aria-hidden="true"><option value="left">Left</option><option value="right">Right</option><option value="inside">Inside</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-display_label_pos-container"><span class="select2-selection__rendered" id="select2-display_label_pos-container"></span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom typepie" style="display: none;"><label class="control-label control-label-custom120" for="display_label_pos">Position</label><select class="form-control axes_select select2-hidden-accessible" id="display_label_pos" prop_key="label.position" name="display_label_pos" key_path="label.position" tabindex="-1" aria-hidden="true"><option value="outside">Outside</option><option value="inner">Inside</option><option value="center">Center</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-display_label_pos-container"><span class="select2-selection__rendered" id="select2-display_label_pos-container" title="Outside">Outside</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div><div class="form-group form-group-custom typepie" style="display: none;"><label class="control-label control-label-custom120" for="display_label_parts">Format <i class="fa fas fa-info-circle" data-toggle="tooltip" data-placement="top" title="" data-original-title="{a1},{a2},{value},{p}-Will be replaced by actual Alias, Secondary Alias and Value "></i></label><input class="form-control axes_select query_input display_label_parts" id="display_label_parts" type="text" prop_key="parts" name="display_label_parts" key_path="label.parts"></div><div class="form-group form-group-custom typemap typefunnel typeline typebars"><label class="control-label control-label-custom120" for="display_label_parts">Format <i class="fa fas fa-info-circle" data-toggle="tooltip" data-placement="top" title="" data-original-title="{a1},{a2},{value}-Will be replaced by actual Alias, Secondary Alias and Value "></i></label><input class="form-control axes_select query_input display_label_parts" id="display_label_parts" type="text" prop_key="parts" name="display_label_parts" key_path="label.parts"></div><div class="form-group form-group-custom typeline typebars"><label class="control-label control-label-custom120" for="display_label">Show</label><div class="checkbox" style="display: inline-block"><input class="js-switch-small" id="display_label" type="checkbox" prop_key="label.show" name="display_label" key_path="label.show" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="box-shadow: rgb(223, 223, 223) 0px 0px 0px 0px inset; border-color: rgb(223, 223, 223); background-color: rgb(255, 255, 255); transition: border 0.4s, box-shadow 0.4s;"><small style="left: 0px; transition: background-color 0.4s, left 0.2s;"></small></span></div></div><div class="form-group form-group-custom typepie typefunnel typemap" style="display: none;"><label class="control-label control-label-custom120" for="display_label_2">Show</label><div class="checkbox" style="display: inline-block"><input class="js-switch-small" id="display_label_2" type="checkbox" prop_key="label.show" name="display_label_2" key_path="label.show" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span></div></div></div><div class="form_main_block pull-left custominputs"><h4 class="form-group typeline"><label class="control-label">Tooltip</label></h4><div class="form-group form-group-custom typeline"><label class="control-label control-label-custom120" for="display_trig">Trigger On</label><select class="form-control axes_select select2-hidden-accessible" id="display_trig" prop_key="triggerOn" name="display_trig" key_path="options.tooltip.triggerOn" tabindex="-1" aria-hidden="true"><option value="mousemove">Move</option><option value="click">Click</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 196px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-display_trig-container"><span class="select2-selection__rendered" id="select2-display_trig-container" title="Move">Move</span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div></div><div class="form_main_block pull-left custominputs" id="axes_select"><h4 class="form-group typegauge" style="display: none;"><label class="control-label">Detail</label></h4><label class="control-label control-label-custom120 typegauge" for="detailColor" style="display: none;">Color</label><div class="titile_input_midle typegauge" style="display: none;"><div class="input-group cl_picer cl_picer_input colorpicker-element"><input class="form-control" id="detailColor" type="text" prop_key="backgroundColor" name="detailColor" key_path="detail.color"><span class="input-group-addon"><i></i></span></div></div><div class="form-group form-group-custom typegauge" style="display: none;"><label class="control-label control-label-custom120" for="display_label_gauge">Show</label><div class="checkbox" style="display: inline-block"><input class="js-switch-small" id="display_label_gauge" type="checkbox" prop_key="label.show" name="display_label_gauge" key_path="label.show" checked="checked" data-switchery="true" style="display: none;"><span class="switchery switchery-small" style="background-color: rgb(38, 185, 154); border-color: rgb(38, 185, 154); box-shadow: rgb(38, 185, 154) 0px 0px 0px 0px inset; transition: border 0.4s, box-shadow 0.4s, background-color 1.2s;"><small style="left: 22px; background-color: rgb(255, 255, 255); transition: background-color 0.4s, left 0.2s;"></small></span></div></div></div></div></div></div></div></div><div role="tabpanel" class="tab-pane fade in" id="tab_time" aria-labelledby="time-tab"> <div class="row"><form class="form-horizontal form-label-left edit-times pull-left" id="edit_time"><div class="form_main_block"><div class="form-group form-group-custom filter"><label class="control-label pull-left" for="padding_height">Times</label><div class="pull-left" id="reportrange_private" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc"><i class="glyphicon glyphicon-calendar fa fa-calendar"></i><span></span><b class="caret"></b></div><div class="pull-left" id="refresh_wrap_private"><select id="refreshtime_private" name="refreshtime" style="width: 150px" key_path="times.intervall" tabindex="-1" class="select2-hidden-accessible" aria-hidden="true"><option value="General">Refresh General</option><option value="off">Refresh Off</option><option value="5000">Refresh every 5s  </option><option value="10000">Refresh every 10s</option><option value="30000">Refresh every 30s</option><option value="60000">Refresh every 1m</option><option value="300000">Refresh every 5m</option><option value="900000">Refresh every 15m</option><option value="1800000">Refresh every 30m</option><option value="3600000">Refresh every 1h</option><option value="7200000">Refresh every 2h</option><option value="86400000">Refresh every 1d</option></select><span class="select2 select2-container select2-container--default" dir="ltr" style="width: 150px;"><span class="selection"><span class="select2-selection select2-selection--single" role="combobox" aria-haspopup="true" aria-expanded="false" tabindex="0" aria-labelledby="select2-refreshtime_private-container"><span class="select2-selection__rendered" id="select2-refreshtime_private-container"></span><span class="select2-selection__arrow" role="presentation"><b role="presentation"></b></span></span></span><span class="dropdown-wrapper" aria-hidden="true"></span></span></div></div></div></form></div></div><div role="tabpanel" class="tab-pane fade in" id="tab_json" aria-labelledby="json-tab"> <div class="row"><form class="edit-ljson" id="edit_json"><div class="form_main_block"><h3><label class="control-label">Json Editor</label></h3><div id="jsoneditor"><div class="jsoneditor jsoneditor-mode-code"><div class="jsoneditor-menu"><button type="button" class="jsoneditor-format" title="Format JSON data, with proper indentation and line feeds (Ctrl+\)"></button><button type="button" class="jsoneditor-compact" title="Compact JSON data, remove all whitespaces (Ctrl+Shift+\)"></button><div class="jsoneditor-modes" style="position: relative;"><button type="button" class="jsoneditor-modes jsoneditor-separator" title="Switch editor mode">Code ▾</button></div><a href="http://ace.ajax.org" target="_blank" class="jsoneditor-poweredBy">powered by ace</a></div><div class="jsoneditor-outer"><div class=" ace_editor ace-jsoneditor" style="height: 100%; width: 100%; font-size: 13px;"><textarea class="ace_text-input" wrap="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="opacity: 0;"></textarea><div class="ace_gutter"><div class="ace_layer ace_gutter-layer ace_folding-enabled"></div><div class="ace_gutter-active-line"></div></div><div class="ace_scroller"><div class="ace_content"><div class="ace_layer ace_print-margin-layer"><div class="ace_print-margin" style="left: 4px; visibility: hidden;"></div></div><div class="ace_layer ace_marker-layer"></div><div class="ace_layer ace_text-layer" style="padding: 0px 4px;"></div><div class="ace_layer ace_marker-layer"></div><div class="ace_layer ace_cursor-layer ace_hidden-cursors"><div class="ace_cursor"></div></div></div></div><div class="ace_scrollbar ace_scrollbar-v" style="display: none; width: 20px;"><div class="ace_scrollbar-inner" style="width: 20px;"></div></div><div class="ace_scrollbar ace_scrollbar-h" style="display: none; height: 20px;"><div class="ace_scrollbar-inner" style="height: 20px;"></div></div><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: hidden;"><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: visible;"></div><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: visible;">XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</div></div></div></div></div></div><div class="col-md-12 col-sm-12 col-xs-12 text-right"><button class="btn btn-primary" id="jsonReset" type="button">Reset</button><button class="btn btn-primary" id="jsonApply" type="button">Apply</button></div></div></form></div></div></div>
            </div>      -->

            
</div>             
