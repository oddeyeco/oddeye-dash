
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<link href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}" rel="stylesheet">

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

<div class="alert alert-danger alert-dismissible collapse " id="manyalert" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>                    
    <spring:message code="monitorings2.manyAlert"/>
</div> 

<div id="lostconnection" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">                
                <h4 class="modal-title"><spring:message code="monitorings2.modal.connectionLost"/></h4>
            </div>
            <div class="modal-body">
                <p><spring:message code="monitorings2.modal.refreshBrowser"/></p>
                <p class="text-warning"></p>
            </div>
        </div>
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
                <p><spring:message code="monitorings2.modal.confirmDelDashboard"/></p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-default" data-dismiss="modal"value="<spring:message code="close"/>">
                <input type="button" id="deletedashconfirm" class="btn btn-ok" value="<spring:message code="delete"/>">
            </div>
        </div>
    </div>
</div>  

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12 ">
        <div class="x_panel">
            <div id="query_form_content">
                <form class="form-options">
                    <fieldset id="filters" class="collapsible collapsed">                        
                        <legend><i class="action fa fas fa-chevron-down"></i><spring:message code="monitorings2.filters"/></legend>
                        <div class="filter-body">
                            <div class="filters row">
                                <div class="filter all_filter col-sm-4">
                                    <h4 class=""><spring:message code="monitorings2.filtersAll"/></h4>
                                    <div class="add-filter">
                                        <label for="all_filter" class="all_filter col-sm-4 text-right"><spring:message code="monitorings2.addFilter"/></label>
                                        <select class="add_filter_select col-sm-8" id="allfilter"><option value="">&nbsp;</option>
                                            <option value="info.name" fname="<spring:message code="metricName"/>" alias="metric"><spring:message code="metricName"/></option>
                                            <option value="level" fname="<spring:message code="level"/>" alias="level"><spring:message code="level"/></option>                                
                                            <optgroup label="<spring:message code="tags"/>">
                                                <c:forEach items="${list}" var="tagitem">   
                                                    <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                    <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                </c:forEach>                                
                                            </optgroup>
                                        </select>
                                    </div>
                                    <div class="defined_filter">
                                        <table class="filters-table">
                                        </table>                                    
                                    </div>    
                                </div>                            
                                <div class="filter ml_filter col-sm-4">
                                    <h4 class=""><spring:message code="monitorings2.filtersMachine"/></h4>
                                    <div class="add-filter">
                                        <label for="ml_filter" class="all_filter col-sm-4 text-right"><spring:message code="monitorings2.addFilter"/></label>
                                        <select class="add_filter_select col-sm-8" id="mlfilter"><option value="">&nbsp;</option>
                                            <option value="info.name" fname="<spring:message code="metricName"/>" alias="metric"><spring:message code="metricName"/></option>
                                            <option value="level" fname="<spring:message code="level"/>" alias="level"><spring:message code="level"/></option>                                
                                            <optgroup label="<spring:message code="tags"/>">
                                                <c:forEach items="${list}" var="tagitem">   
                                                    <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                    <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                </c:forEach>                                
                                            </optgroup>
                                        </select>
                                    </div>
                                    <div class="defined_filter">
                                        <table class="filters-table">
                                        </table>                                    
                                    </div>    
                                </div>
                                <div class="filter manual_filter col-sm-4">
                                    <h4 class=""><spring:message code="monitorings2.filtersManually"/></h4>
                                    <div class="add-filter">
                                        <label for="manual_filter" class="all_filter col-sm-4 text-right"><spring:message code="monitorings2.addFilter"/></label>
                                        <select class="add_filter_select col-sm-8" id="manualfilter"><option value="">&nbsp;</option>
                                            <option value="info.name" fname="<spring:message code="metricName"/>" alias="metric"><spring:message code="metricName"/></option>
                                            <option value="level" fname="<spring:message code="level"/>" alias="level"><spring:message code="level"/></option>                                
                                            <optgroup label="<spring:message code="tags"/>">
                                                <c:forEach items="${list}" var="tagitem">   
                                                    <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                    <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                </c:forEach>                                
                                            </optgroup>
                                        </select>
                                    </div>
                                    <div class="defined_filter">
                                        <table class="filters-table">
                                        </table> 
                                    </div>                                    
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="collapsible collapsed col-md-6 col-xs-12">
                        <legend> <i class="action fa fas fa-chevron-down"></i><spring:message code="monitorings2.options"/></legend>
                        <div class="filter-body">
                            <table class="options" style="width: 100%">
                                <tbody><tr>
                                        <td class="card-fields name">
                                            <label><spring:message code="monitorings2.displayFields"/> </label>
                                        </td>
                                        <td class="card-fields value">
                                            <select name="f_col[]" multiple="multiple" class="f_col"  style="width: 100%">
                                                <option value="actions" label="actions" key="actions"><spring:message code="monitorings2.displayFieldsActions"/>
                                                </option>
                                                <option value="level" label="Level" key="levelname" ><spring:message code="level"/>
                                                </option> 
                                                <option value="updatecounter"  key="updatecounter" label="Update Counter"><spring:message code="monitorings2.displayFieldsUpdateCounter"/>
                                                </option>                                                          
                                                <option value="updateinterval"  key="updateinterval" label="Update Interval"><spring:message code="monitorings2.displayFieldsUpdateInterval"/>
                                                </option>                                                                                                   
                                                <option value="info_name"  key="info.name" label="Metric name"><spring:message code="metricName"/>
                                                </option>                                                    
                                                <option value="Start_Time"  key="StartTime" label="Start Time"><spring:message code="startTime"/>
                                                </option> 
                                                <option value="Last_Time"  key="LastTime" label="Last Time"><spring:message code="lastTime"/>
                                                </option>   
                                                <option value="duration"  key="duration" label="Duration"><spring:message code="duration"/>
                                                </option>                                                                                                    
                                                <option value="info"  key="info" label="Info"><spring:message code="info"/>
                                                </option>                                                          
                                                <optgroup label="<spring:message code="tags"/>">
                                                    <c:forEach items="${list}" var="tagitem">   
                                                        <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>                                                        
                                                        <option value="info_tags_${tagitem.key}_value"
                                                                key="info.tags.${tagitem.key}.value" label="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                    </c:forEach>                                
                                                </optgroup>
                                                <option value="message" key="message" label="message"><spring:message code="monitorings2.displayFieldsMessage"/>
                                                </option>                                                                                               
                                            </select>                                                                                  
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                    <fieldset class="collapsible collapsed col-md-6 col-xs-12">
                        <legend> <i class="action fa fas fa-chevron-down"></i><spring:message code="monitorings2.externalNotifiers"/></legend>
                        <div class="filter-body">
                            <div class="add-notifier">
                                <label for="addNotifier" class="all_filter col-sm-4 text-right"><spring:message code="monitorings2.addNotifier"/></label>
                                <select class="add_notifier_select col-sm-8" id="addNotifier"><option value="">&nbsp;</option>
                                    <option value="email" fname="<spring:message code="monitorings2.addressEmail"/>"><spring:message code="monitorings2.addNotifierEmail"/></option>
                                    <option value="telegram"  fname="<spring:message code="monitorings2.chatIdTelegram"/>"><spring:message code="monitorings2.addNotifierTelegram"/></option>                                
                                </select>
                            </div>                            
                            <div class="defined_notifier">
                                <div class="notifiers-table row">
                                </div>                                    
                            </div>                             
                        </div>
                    </fieldset>
                </form>
            </div>            

            <div class="btn-toolbar" role="toolbar" aria-label="Toolbar with button groups">
                <div class="btn-group mr-2" role="group" aria-label="Apply group">
                    <button href="#" class="btn btn-xs btn-success" id="apply_filter"><spring:message code="apply"/></button>   
                </div>
                <div class="btn-group mr-2" role="group" aria-label="Save group">
                    <button href="#" class="btn btn-xs btn-primary" id="save_filter"><spring:message code="save"/></button>                
                    <button href="#" class="btn btn-xs btn-info" id="add_filter"><spring:message code="saveAs"/></button>
                    <input type="text" value="${nameoptions}" id="saveas_name" class="form-control">
                </div>
                <c:if test="${!empty nameoptions}">
                    <div class="btn-group pull-right" role="group" aria-label="Delete group">
                        <button href="#" class="btn btn-xs btn-danger" id="rem_filter"><spring:message code="deleteView"/></button>    
                    </div>
                </c:if>   
            </div>            

            <div class="buttons ">
                <div class="btn-group"></div>
            </div>
                
            <div class="row">
                <div class="col-md-10 col-sm-9 col-xs-12 profile_right">
                    <h4 class="summary">
                        <b><spring:message code="total"/></b><span class="Tablecount">0</span><b><spring:message code="monitorings2.machineLearned"/></b><span class="regcount">0</span><b><spring:message code="monitorings2.manuallyDefined"/></b><span class="Speccount">0 </span>
                    </h4>                 
                </div>
            </div>      

            <div class="selected-actions btn-group-vertical">              
                <button type="button" class="btn btn-secondary" id="Move_top"  data-toggle="tooltip" data-placement="left" title="<spring:message code="title.top"/>"><i class="fa fas fa-angle-double-up"></i></button>
                <button type="button" class="btn btn-secondary" id="Show_chart" data-toggle="tooltip" data-placement="left" title="<spring:message code="dash.show.chart"/>"><i class="fa fas fa-chart-area"></i></button>
                <button type="button" class="btn btn-secondary" id="Clear_reg"  data-toggle="tooltip" data-placement="left" title="<spring:message code="title.reduceSeverity"/>"><i class="fa far fa-bell-slash"></i></button>
                <button type="button" class="btn btn-secondary" id="Move_down"  data-toggle="tooltip" data-placement="left" title="<spring:message code="title.bottom"/>"><i class="fa fas fa-angle-double-down"></i></button>
                <span class="badge bg-green">0</span>
                <!--<button type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="left" title="Cleare Rules"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>-->
            </div>            

            <div class="col-md-10 col-sm-9 col-xs-12 profile_right-table">
                <!-- start List -->
                <ul class="monitorlist">
                    <li id="special">
                        <ul id="speciallist"></ul>
                    </li>
                    <li id="regular">
                        <ul id="regularlist"></ul>                            
                    </li>
                </ul>
            </div>             
        </div>
    </div>
</div>
</div>

<!-- /page content -->

<!--==================================================================================================================================-->
<!--<div class="row"> 
    <div class="col-lg-12 col-md-12 col-sm-12 col-12">
        <div class="card shadow">
            <div class="card-body row">
                <div class="col-lg-12 col-md-12 col-sm-12 col-12"> 

                    <div class="card shadow">
                        <h4 class="card-header p-1">
                            <button type="button" id="collapseFilters" class="btn btn-outline-dark markBtn">
                                <i class="fas fa-outdent fa-rotate-90"></i><b class="pagetitle"><spring:message code="monitorings2.addFilter"/></b>
                            </button>
                        </h4>                                
                        <div class="card-body markBody p-0" id="filters">
                            <form class="form-options">                                
                                <fieldset class="">                                                        
                                    <div class="filter-body">
                                        <div class="filters row">
                                            <div class="filter all_filter col-12 col-lg-4 pr-lg-0">  
                                                <div class="card shadow">
                                                    <h4 class="card-header  text-center p-0 bg-light">
                                                        <button type="button" id="collapseAll_msg" class="btn btn-outline-dark markBtn p-1">
                                                            <i class="fas fa-rotate-90 fa-indent"></i>
                                                            <b class="pagetitle"><spring:message code="monitorings2.filtersAll"/></b>
                                                        </button>
                                                    </h4> 
                                                    <div class="card-body markBody" id="All_msg" style="display: block;">
                                                        <div class="add-filter">
                                                            <div class="form-row">
                                                                <div class="form-group form-group-inline col-2 mb-2">                                                                           
                                                                    <label for="all_filter" class="all_filter"><spring:message code="monitorings2.addFilter"/></label> 
                                                                </div>
                                                                <div class="form-group col-8">                                                           
                                                                    <select class="add_filter_select form-control form-control-sm" id="allfilter">                                                                            
                                                                        <option value="">&nbsp;</option>
                                                                        <option value="info.name" fname="<spring:message code="metricName"/>" alias="metric"><spring:message code="metricName"/></option>
                                                                        <option value="level" fname="<spring:message code="level"/>" alias="level"><spring:message code="level"/></option>                                
                                                                        <optgroup label="<spring:message code="tags"/>">
                                                                            <c:forEach items="${list}" var="tagitem">   
                                                                                <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                                                <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                                            </c:forEach>                                
                                                                        </optgroup>
                                                                    </select>
                                                                </div> 
                                                            </div>  
                                                        </div>
                                                        
                                                        <div class="defined_filter">
                                                            <table class="filters-table"></table>
                                                            <div class="form-row">
                                                                <div class="form-group form-group-inline col-3">                                                                           
                                                                    <label class="mr-2 mb-0" for="valueLevel">Level</label>                                                                             
                                                                    <select class="form-control form-control-sm" id="valueLevel">                                                                            
                                                                        <option value="">is</option>
                                                                        <option value="">is not</option>                                                                       
                                                                    </select>
                                                                </div>
                                                                <div class="form-group col-7">                                                           
                                                                    <select class=" form-control form-control-sm js-example-placeholder-multiple js-example-multiple" id="" multiple="multiple" style="width: 100%;">
                                                                        <option title="<span class='badge badge-info'>Any</span>" value="0">Any</option>
                                                                        <option title="<span class='badge badge-info'>Low</span>" value="1">Low</option>
                                                                        <option title="<span class='badge badge-info'>Guarded</span>" value="2">Guarded</option>
                                                                        <option title="<span class='badge badge-info'>Elevated</span>" value="3" selected="selected">Elevated</option>
                                                                        <option title="<span class='badge badge-info'>High</span>" value="4" selected="selected">High</option>
                                                                        <option title="<span class='badge badge-info'>Severe</span>" value="5" selected="selected">Severe</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="filter machine_filter col-12 col-lg-4 p-lg-0">
                                                <div class="card shadow">
                                                    <h4 class="card-header  text-center p-0 bg-light">
                                                        <button type="button" id="collapseMachine_msg" class="btn btn-outline-dark markBtn p-1">
                                                            <i class="fas fa-rotate-90 fa-indent"></i>
                                                            <b class="pagetitle"><spring:message code="monitorings2.filtersMachine"/></b>
                                                        </button>
                                                    </h4> 
                                                    <div class="card-body markBody" id="Machine_msg" style="display: block;">
                                                        <div class="form-row">
                                                            <div class="form-group form-group-inline col-2 mb-2">                                                                           
                                                                <label for="all_filter" class="all_filter"><spring:message code="monitorings2.addFilter"/></label> 
                                                            </div>
                                                            <div class="form-group col-8">                                                           
                                                                <select class="add_filter_select form-control form-control-sm" id="mlfilter">                                                                            
                                                                    <option value="">&nbsp;</option>
                                                                    <option value="info.name" fname="<spring:message code="metricName"/>" alias="metric"><spring:message code="metricName"/></option>
                                                                    <option value="level" fname="<spring:message code="level"/>" alias="level"><spring:message code="level"/></option>                                
                                                                    <optgroup label="<spring:message code="tags"/>">
                                                                        <c:forEach items="${list}" var="tagitem">   
                                                                            <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                                            <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                                        </c:forEach>                                
                                                                    </optgroup>
                                                                </select>
                                                            </div> 
                                                        </div>
                                                        <div class="defined_filter">
                                                            <table class="filters-table"></table>
                                                            <div class="form-row">
                                                                <div class="form-group form-group-inline col-3">                                                                           
                                                                    <label class="mr-2 mb-0" for="valueLevel">Level</label>                                                                             
                                                                    <select class="form-control form-control-sm" id="valueLevel">                                                                            
                                                                        <option value="">is</option>
                                                                        <option value="">is not</option>                                                                       
                                                                    </select>
                                                                </div>
                                                                <div class="form-group col-7">                                                           
                                                                    <select class=" form-control form-control-sm js-example-placeholder-multiple js-example-multiple" id="" multiple="multiple" style="width: 100%;">
                                                                        <option title="<span class='badge badge-info'>Any</span>" value="0">Any</option>
                                                                        <option title="<span class='badge badge-info'>Low</span>" value="1">Low</option>
                                                                        <option title="<span class='badge badge-info'>Guarded</span>" value="2">Guarded</option>
                                                                        <option title="<span class='badge badge-info'>Elevated</span>" value="3" selected="selected">Elevated</option>
                                                                        <option title="<span class='badge badge-info'>High</span>" value="4" selected="selected">High</option>
                                                                        <option title="<span class='badge badge-info'>Severe</span>" value="5" selected="selected">Severe</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>

                                            </div>

                                            <div class="filter manual_filter col-12 col-lg-4 pl-lg-0">                                                                              

                                                <div class="card shadow">
                                                    <h4 class="card-header  text-center p-0 bg-light">
                                                        <button type="button" id="collapseManual_msg" class="btn btn-outline-dark markBtn p-1">
                                                            <i class="fas fa-rotate-90 fa-indent"></i>
                                                            <b class="pagetitle"><spring:message code="monitorings2.filtersManually"/></b>
                                                        </button>
                                                    </h4> 
                                                    <div class="card-body markBody" id="Manual_msg" style="display: block;">
                                                        <div class="form-row">
                                                            <div class="form-group form-group-inline col-2 mb-2">                                                                           
                                                                <label for="all_filter" class="all_filter"><spring:message code="monitorings2.addFilter"/></label> 
                                                            </div>
                                                            <div class="form-group col-8">                                                           
                                                                <select class="add_filter_select form-control form-control-sm" id="manualfilter">                                                                            
                                                                    <option value="">&nbsp;</option>
                                                                    <option value="info.name" fname="<spring:message code="metricName"/>" alias="metric"><spring:message code="metricName"/></option>
                                                                    <option value="level" fname="<spring:message code="level"/>" alias="level"><spring:message code="level"/></option>                                
                                                                    <optgroup label="<spring:message code="tags"/>">
                                                                        <c:forEach items="${list}" var="tagitem">   
                                                                            <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                                            <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                                        </c:forEach>                                
                                                                    </optgroup>
                                                                </select>
                                                            </div> 
                                                        </div>
                                                        <div class="defined_filter">
                                                            <table class="filters-table"></table>
                                                            <div class="form-row">
                                                                <div class="form-group form-group-inline col-3">                                                                           
                                                                    <label class="mr-2 mb-0" for="valueLevel">Level</label>                                                                             
                                                                    <select class="form-control form-control-sm" id="">                                                                            
                                                                        <option value="">is</option>
                                                                        <option value="">is not</option>                                                                       
                                                                    </select>
                                                                </div>
                                                                <div class="form-group col-7">                                                           
                                                                    <select class=" form-control form-control-sm js-example-placeholder-multiple js-example-multiple" id="" multiple="multiple" style="width: 100%;">
                                                                        <option title="<span class='badge badge-info'>Any</span>" value="0">Any</option>
                                                                        <option title="<span class='badge badge-info'>Low</span>" value="1">Low</option>
                                                                        <option title="<span class='badge badge-info'>Guarded</span>" value="2">Guarded</option>
                                                                        <option title="<span class='badge badge-info'>Elevated</span>" value="3" selected="selected">Elevated</option>
                                                                        <option title="<span class='badge badge-info'>High</span>" value="4" selected="selected">High</option>
                                                                        <option title="<span class='badge badge-info'>Severe</span>" value="5" selected="selected">Severe</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </fieldset>

                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 col-12 pr-lg-0">
                    <div class="card shadow">
                        <h4 class="card-header p-1">
                            <button type="button" id="collapseOptions" class="btn btn-outline-dark markBtn">
                                <i class="fas fa-outdent fa-rotate-90"></i><b class="pagetitle"><spring:message code="monitorings2.options"/></b>
                            </button>
                        </h4> 
                        <div class="card-body markBody minHeight180" id="options">
                            <div class="form-row">
                                <div class="form-group form-group-inline col-2 align-items-start card-fields name">                                                                           
                                    <label class="mr-2 mb-0"><spring:message code="monitorings2.displayFields"/></label> 
                                </div>
                                <div class="card-fields value col-10">                                                           
                                    <div class="form-group">                                                           
                                        <select class="f_col form-control form-control-sm js-example-multiple" id="exampleFormControlSelect2" name="f_col[]" data-width="fit" data-multiple-separator=' ' multiple>                                                                
                                            <option value="actions" label="actions" key="actions"><spring:message code="monitorings2.displayFieldsActions"/></option>
                                                <option value="level" label="Level" key="levelname" ><spring:message code="level"/></option> 
                                                <option value="updatecounter"  key="updatecounter" label="Update Counter"><spring:message code="monitorings2.displayFieldsUpdateCounter"/></option>                                                          
                                                <option value="updateinterval"  key="updateinterval" label="Update Interval"><spring:message code="monitorings2.displayFieldsUpdateInterval"/></option>                                                                                                   
                                                <option value="info_name"  key="info.name" label="Metric name"><spring:message code="metricName"/></option>                                                    
                                                <option value="Start_Time"  key="StartTime" label="Start Time"><spring:message code="startTime"/></option> 
                                                <option value="Last_Time"  key="LastTime" label="Last Time"><spring:message code="lastTime"/></option>   
                                                <option value="duration"  key="duration" label="Duration"><spring:message code="duration"/></option>                                                                                                    
                                                <option value="info"  key="info" label="Info"><spring:message code="info"/></option>                                                          
                                                <optgroup label="<spring:message code="tags"/>">
                                                    <c:forEach items="${list}" var="tagitem">   
                                                        <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>                                                        
                                                        <option value="info_tags_${tagitem.key}_value" key="info.tags.${tagitem.key}.value" label="Tag:${text}"> Tag:${text} (${tagitem.value.size()}) </option>
                                                    </c:forEach>                                
                                                </optgroup>
                                                <option value="message" key="message" label="message"><spring:message code="monitorings2.displayFieldsMessage"/></option>  
                                        </select>
                                    </div>
                                </div>
                            </div>
<fieldset class="">
    <div class="filter-body">
        <table class="options" style="width: 100%">
            <tbody><tr>
                    <td class="card-fields name">
                        <label><spring:message code="monitorings2.displayFields"/> </label>
                    </td>
                    <td class="card-fields value">
                        <select name="f_col[]" multiple="multiple" class="f_col"  style="width: 100%">
                            <option value="actions" label="actions" key="actions"><spring:message code="monitorings2.displayFieldsActions"/></option>
                            <option value="level" label="Level" key="levelname" ><spring:message code="level"/></option> 
                            <option value="updatecounter"  key="updatecounter" label="Update Counter"><spring:message code="monitorings2.displayFieldsUpdateCounter"/></option>                                                          
                            <option value="updateinterval"  key="updateinterval" label="Update Interval"><spring:message code="monitorings2.displayFieldsUpdateInterval"/></option>                                                                                                   
                            <option value="info_name"  key="info.name" label="Metric name"><spring:message code="metricName"/></option>                                                    
                            <option value="Start_Time"  key="StartTime" label="Start Time"><spring:message code="startTime"/></option> 
                            <option value="Last_Time"  key="LastTime" label="Last Time"><spring:message code="lastTime"/></option>   
                            <option value="duration"  key="duration" label="Duration"><spring:message code="duration"/></option>                                                                                                    
                            <option value="info"  key="info" label="Info"><spring:message code="info"/></option>                                                          
                            <optgroup label="<spring:message code="tags"/>">
                                <c:forEach items="${list}" var="tagitem">   
                                    <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>                                                        
                                    <option value="info_tags_${tagitem.key}_value" key="info.tags.${tagitem.key}.value" label="Tag:${text}">Tag:${text} (${tagitem.value.size()})</option>
                                </c:forEach>                                
                            </optgroup>
                            <option value="message" key="message" label="message"><spring:message code="monitorings2.displayFieldsMessage"/></option> 
                        </select>  
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</fieldset>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-12 pl-lg-0">    
                    <div class="card shadow">
                        <h4 class="card-header p-1">
                            <button type="button" id="collapseNotifiers" class="btn btn-outline-dark markBtn">
                                <i class="fas fa-outdent fa-rotate-90"></i>
                                <b class="pagetitle"><spring:message code="monitorings2.externalNotifiers"/></b>
                            </button>
                        </h4> 
                        <div class="card-body markBody minHeight180" id="notifiers">
                            <div class="form-row">
                                <div class="form-group form-group-inline col-2 card-fields name">                                                                           
                                    <label for="addNotifier" class="mr-2 mb-0"><spring:message code="monitorings2.addNotifier"/></label> 
                                </div>
                                <div class="card-fields value col-10">                                                           
                                    <div class="form-group">                                                           
                                        <select id="addNotifier" class=" form-control form-control-sm">
                                            <option value="">&nbsp;</option>
                                            <option value="email" fname="<spring:message code="monitorings2.addressEmail"/>"><spring:message code="monitorings2.addNotifierEmail"/></option>
                                            <option value="telegram"  fname="<spring:message code="monitorings2.chatIdTelegram"/>"><spring:message code="monitorings2.addNotifierTelegram"/></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="defined_notifier">
                                <div class="notifiers-table row"></div>                                    
                            </div>             
                        </div>
                    </div> 
                </div>  
                <div class="col-lg-12 col-md-12 col-sm-12 col-12">
                    <div class="card shadow w-100 mb-2">
                        <div class="card-header p-1"> 
                            <form class="form-inline">                                
                                <button href="#" class="btn btn-sm btn-outline-success mr-2" id="apply_filter"><spring:message code="apply"/></button> 
                                <button href="#" class="btn btn-sm btn-outline-primary" id="save_filter"><spring:message code="save"/></button> 
                                <button href="#" class="btn btn-sm btn-outline-info mr-2" id="add_filter"><spring:message code="saveAs"/></button>
                                <input type="text" value="${nameoptions}" id="saveas_name" class="form-control">
                            <c:if test="${!empty nameoptions}">                                
                                <button href="#" class="btn btn-sm btn-xs btn-outline-danger ml-2" id="rem_filter"><spring:message code="deleteView"/></button>
                            </c:if>    
                            </form>                            
                            
                        </div>                                             
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 profile_right">
                        <h4 class="summary">
                            <b><spring:message code="total"/></b><span class="Tablecount">0</span>
                            <b><spring:message code="monitorings2.machineLearned"/></b><span class="regcount">0</span>
                            <b><spring:message code="monitorings2.manuallyDefined"/></b><span class="Speccount">0 </span>
                        </h4>
                    </div>
                </div>
                        
                <div class="selected-actions btn-group-vertical">              
                    <button type="button" class="btn btn-secondary" id="Move_top"  data-toggle="tooltip" data-placement="left" title="<spring:message code="title.top"/>"><i class="fa fas fa-angle-double-up"></i></button>
                    <button type="button" class="btn btn-secondary" id="Show_chart" data-toggle="tooltip" data-placement="left" title="<spring:message code="dash.show.chart"/>"><i class="fa fas fa-chart-area"></i></button>
                    <button type="button" class="btn btn-secondary" id="Clear_reg"  data-toggle="tooltip" data-placement="left" title="<spring:message code="title.reduceSeverity"/>"><i class="fa far fa-bell-slash"></i></button>
                    <button type="button" class="btn btn-secondary" id="Move_down"  data-toggle="tooltip" data-placement="left" title="<spring:message code="title.bottom"/>"><i class="fa fas fa-angle-double-down"></i></button>
                    <span class="badge bg-green">0</span>                
                </div>
                <div class="col-12 profile_right-table" style="width: 100%;">
                    <ul class="monitorlist">                                            
                        <li id="special">
                            <ul id="speciallist"></ul>
                        </li>
                        <li id="regular">
                            <ul id="regularlist"></ul>                            
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>   -->