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
                    <fieldset class="collapsible collapsed">
                        <legend> <i class="action fa fa-chevron-down"></i>Options</legend>
                        <div class="filter-body">
                            <table class="options">
                                <tbody><tr>
                                        <td>
                                            <label> Columns </label>
                                        </td>
                                        <td class="card-fields">
                                            <label class="floating">
                                                <input type="checkbox" name="f_col[]" id="f_col_actions" value="actions" checked="checked">Actions
                                            </label> 
                                            <label class="floating">
                                                <input type="checkbox" name="f_col[]" id="f_col_level" value="Level" checked="checked">Level
                                            </label> 
                                            <label class="floating">
                                                <input type="checkbox" name="f_col[]" id="f_col_name" value="Metric name" checked="checked">Metric Name
                                            </label> 
                                            <label class="floating">
                                                <input type="checkbox" name="f_col[]" id="f_col_tags" value="tags" checked="checked">Tags
                                            </label> 

                                            <label class="floating">
                                                <input type="checkbox" name="f_col[]" id="f_col_info" value="Info" checked="checked">Info
                                            </label> 
                                            <label class="floating">
                                                <input type="checkbox" name="f_col[]" id="f_col_sttime" value="Start Time" checked="checked">Start Time
                                            </label> 
                                            <label class="floating">
                                                <input type="checkbox" name="f_col[]" id="f_col_lasttime" value="Last Time" checked="checked">Last Time
                                            </label>                                         

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label> Tags Columns </label>                                            
                                        </td>
                                        <td class="card-fields">
                                            <c:forEach items="${list}" var="tagitem">   
                                                <label class="floating">
                                                    <input type="checkbox" name="f_tags[]" key="${tagitem.key}" id="f_tags_${tagitem.key}" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"<c:if test="${ident_tag == tagitem.key}"> checked="checked" </c:if> >${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()})
                                                    </label> 
                                            </c:forEach>                                        
                                        </td>
                                    </tr>                                
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </form>
            </div>            
            <p class="buttons">
                <a href="#" class="btn btn-xs btn-success" id="apply_filter">Apply</a>
                <a href="#" class="btn btn-xs btn-primary" id="cleare_filter">Reset to default</a>
                <a href="#" class="btn btn-xs btn-primary" id="save_filter">Set as default</a>
            </p>
            <div class="row">
                <div class="col-md-10 col-sm-9 col-xs-12 profile_right">
                    <h4 class="summary">
                        <b>Total:</b><span class="Tablecount">0</span><b>Machine Learned:</b><span class="regcount">0</span><b>Manually Defined:</b><span class="Speccount">0 </span>
                    </h4>                 
                </div>
            </div>
            <div class="col-md-10 col-sm-9 col-xs-12 profile_right-table">

                <div class="x_content table-responsive" style="display: block;">
                    <!-- start List -->
                    <table class="table metrictable table-striped bulk_action">
                        <thead>
                            <tr>
                                <!--<th>#</th>-->
                                <th class="actions">
                                    <input type="checkbox" id="check-all" class="flat">
                                    <div class="btn-group">                                        
                                        <button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                            <span class="caret"></span>
                                            <span class="sr-only">Toggle Dropdown</span>
                                        </button>
                                        <ul class="dropdown-menu" role="menu">
                                            <li><a href="#" id="Show_chart">Show Chart</a>
                                            </li>
                                            <li class="divider"></li>
                                            <li><a href="#" id="Clear_reg">Clear Regression</a>
                                            </li>
                                        </ul>
                                    </div>                                        
                                </th>
                                <th>Level</th>
                                <th>Metric Name</th>
                                <th id="ident_tag_head">
                                    <select class="table-form-control" name="ident_tag" id="ident_tag">
                                        <c:forEach items="${list}" var="tagitem">   
                                            <option <c:if test="${ident_tag == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                        </c:forEach>
                                    </select>
                                </th>                                    
                                <th>Info</th>
                                <th>Start Time</th>
                                <th>Last Time</th>                                    
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="wait"><td colspan="7">Please wait...</td></tr>
                        </tbody>
                    </table>
                    <!-- end of List -->                        
                </div>
            </div>         
        </div>
    </div>
</div>
</div>

<!-- /page content -->
