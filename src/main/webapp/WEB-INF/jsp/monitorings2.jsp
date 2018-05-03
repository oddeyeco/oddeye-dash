<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="alert alert-danger alert-dismissible collapse " id="manyalert" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>                    
    Too many data points, please change display filter.
</div> 

<div id="lostconnection" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">                
                <h4 class="modal-title">Connection Lost</h4>
            </div>
            <div class="modal-body">
                <p>Websocket connection interrupted, please refresh your browser</p>
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
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Do you want to delete this dashboard?</p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-default" data-dismiss="modal"value="Close">
                <input type="button" id="deletedashconfirm" class="btn btn-ok" value="Delete">
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
                        <legend><i class="action fa fa-chevron-down"></i>Filters</legend>
                        <div class="filter-body">
                            <div class="filters row">
                                <div class="filter all_filter col-sm-4">
                                    <h4 class="">Filters for All messages</h4>
                                    <div class="add-filter">
                                        <label for="all_filter" class="all_filter col-sm-4 text-right">Add filter</label>
                                        <select class="add_filter_select col-sm-8" id="allfilter"><option value="">&nbsp;</option>
                                            <option value="info.name" fname="Metric Name" alias="metric">Metric Name</option>
                                            <option value="level" fname="Level" alias="level">Level</option>                                
                                            <optgroup label="Tags">
                                                <c:forEach items="${list}" var="tagitem">   
                                                    <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                    <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="${text}"> ${text} (${tagitem.value.size()}) </option>
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
                                    <h4 class="">Filters for Machine Learned messages</h4>
                                    <div class="add-filter">
                                        <label for="ml_filter" class="all_filter col-sm-4 text-right">Add filter</label>
                                        <select class="add_filter_select col-sm-8" id="mlfilter"><option value="">&nbsp;</option>
                                            <option value="info.name" fname="Metric Name" alias="metric">Metric Name</option>
                                            <option value="level" fname="Level" alias="level">Level</option>                                
                                            <optgroup label="Tags">
                                                <c:forEach items="${list}" var="tagitem">   
                                                    <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                    <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="${text}"> ${text} (${tagitem.value.size()}) </option>
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
                                    <h4 class="">Filters for Manually Defined messages</h4>
                                    <div class="add-filter">
                                        <label for="manual_filter" class="all_filter col-sm-4 text-right">Add filter</label>
                                        <select class="add_filter_select col-sm-8" id="manualfilter"><option value="">&nbsp;</option>
                                            <option value="info.name" fname="Metric Name" alias="metric">Metric Name</option>
                                            <option value="level" fname="Level" alias="level">Level</option>                                
                                            <optgroup label="Tags">
                                                <c:forEach items="${list}" var="tagitem">   
                                                    <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>
                                                    <option value="info.tags.${tagitem.key}.value" alias="${tagitem.key}" fname="${text}"> ${text} (${tagitem.value.size()}) </option>
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
                        <legend> <i class="action fa fa-chevron-down"></i>Options</legend>
                        <div class="filter-body">
                            <table class="options" style="width: 100%">
                                <tbody><tr>
                                        <td class="card-fields name">
                                            <label>Display fields </label>
                                        </td>
                                        <td class="card-fields value">
                                            <select name="f_col[]" multiple="multiple" class="f_col"  style="width: 100%">
                                                <option value="actions" label="actions" key="actions">Actions
                                                </option>

                                                <option value="level" label="Level" key="levelname" >Level
                                                </option> 
                                                <option value="updatecounter"  key="updatecounter" label="Update Counter">Update Counter
                                                </option>                                                          
                                                <option value="updateinterval"  key="updateinterval" label="Update Interval">Update Interval
                                                </option>                                                                                                   
                                                <option value="info_name"  key="info.name" label="Metric name">Metric Name
                                                </option>                                                    
                                                <option value="Start_Time"  key="StartTime" label="Start Time">Start Time
                                                </option> 
                                                <option value="Last_Time"  key="LastTime" label="Last Time">Last Time
                                                </option>   
                                                <option value="duration"  key="duration" label="Duration">Duration
                                                </option>                                                                                                    
                                                <option value="info"  key="info" label="Info">Info
                                                </option>                                                          
                                                <optgroup label="Tags">
                                                    <c:forEach items="${list}" var="tagitem">   
                                                        <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>                                                        
                                                        <option value="info_tags_${tagitem.key}_value"
                                                                key="info.tags.${tagitem.key}.value" label="${text}"> ${text} (${tagitem.value.size()}) </option>
                                                    </c:forEach>                                
                                                </optgroup>
                                                <option value="message" key="message" label="message">Message
                                                </option>                                                                                               


                                            </select>                                                                                  

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                    <fieldset class="collapsible collapsed col-md-6 col-xs-12">
                        <legend> <i class="action fa fa-chevron-down"></i>External notifiers</legend>
                        <div class="filter-body">
                            <div class="add-notifier">
                                <label for="addNotifier" class="all_filter col-sm-4 text-right">Add Notifier</label>
                                <select class="add_notifier_select col-sm-8" id="addNotifier"><option value="">&nbsp;</option>
                                    <option value="email" fname="E-mail address">E-mail</option>
                                    <option value="telegram"  fname="Telegram chat ID">Telegram</option>                                
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
                    <button href="#" class="btn btn-xs btn-success" id="apply_filter">Apply</button>   
                </div>
                <div class="btn-group mr-2" role="group" aria-label="Save group">
                    <button href="#" class="btn btn-xs btn-primary" id="save_filter">Save</button>                
                    <button href="#" class="btn btn-xs btn-info" id="add_filter">Save As</button>
                    <input type="text" value="${nameoptions}" id="saveas_name" class="form-control">
                </div>
                <c:if test="${!empty nameoptions}">
                    <div class="btn-group pull-right" role="group" aria-label="Delete group">
                        <button href="#" class="btn btn-xs btn-danger" id="rem_filter">Delete view</button>    
                    </div>                    

                </c:if>                


            </div>            

            <div class="buttons ">


                <div class="btn-group">

                </div>

            </div>
            <div class="row">
                <div class="col-md-10 col-sm-9 col-xs-12 profile_right">
                    <h4 class="summary">
                        <b>Total:</b><span class="Tablecount">0</span><b>Machine Learned:</b><span class="regcount">0</span><b>Manually Defined:</b><span class="Speccount">0 </span>
                    </h4>                 
                </div>
            </div>      

            <div class="selected-actions btn-group-vertical">              
                <button type="button" class="btn btn-secondary" id="Show_chart" data-toggle="tooltip" data-placement="left" title="Show Chart">
                    <i class="fa fa-area-chart"></i>                       
                </button>
                <button type="button" class="btn btn-secondary" id="Clear_reg"  data-toggle="tooltip" data-placement="left" title="It`s normal"><i class="fa fa-bell-slash"></i></button>
                <span class="badge bg-green">0</span>
                <!--<button type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="left" title="Cleare Rules"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>-->

            </div>            

            <div class="col-md-10 col-sm-9 col-xs-12 profile_right-table">
                <!-- start List -->
                <ul class="monitorlist">
                    <li id="special">
                        <ul id="speciallist">

                        </ul>
                    </li>
                    <li id="regular">
                        <ul id="regularlist">

                        </ul>                            
                    </li>
                </ul>
            </div>             
        </div>
    </div>
</div>
</div>

<!-- /page content -->
