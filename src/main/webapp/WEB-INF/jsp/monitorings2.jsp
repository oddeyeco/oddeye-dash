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
                            <table class="options" style="width: 100%">
                                <tbody><tr>
                                        <td>
                                            <label>Display fields </label>
                                        </td>
                                        <td class="card-fields value">
                                            <select name="f_col[]" multiple="multiple" class="f_col"  style="width: 100%">
                                                <option value="level" label="Level" key="levelname" disabled="disabled">Level
                                                </option> 

                                                <option value="actions" selected="selected" label="actions" key="actions">Actions
                                                </option>
                                                <option value="Start_Time" selected="selected" key="StartTime" label="Start Time">Start Time
                                                </option> 
                                                <option value="Last_Time" selected="selected" key="LastTime" label="Last Time">Last Time
                                                </option>                                                                                                   
                                                <option value="info_name" selected="selected" key="info.name" label="Metric name">Metric Name
                                                </option>    
                                                <optgroup label="Tags">
                                                    <c:forEach items="${list}" var="tagitem">   
                                                        <c:set var="text" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"/>                                                        
                                                        <option value="info_tags_${tagitem.key}_value" selected="selected" <c:if test="${ident_tag == tagitem.key}"> selected="selected" </c:if>
                                                                key="info.tags.${tagitem.key}.value" label="${text}"> ${text} (${tagitem.value.size()}) </option>
                                                    </c:forEach>                                
                                                </optgroup>
                                                <option value="info" selected="selected" key="info" label="Info">Info
                                                </option>                                                 

                                            </select>                                                                                  

                                        </td>
                                    </tr>
                                    <!--                                    <tr>
                                                                            <td>
                                                                                <label> Tags Columns </label>                                            
                                                                            </td>
                                                                            <td class="card-fields">
                                    <c:forEach items="${list}" var="tagitem">   
                                        <label class="floating">
                                            <input type="checkbox" name="f_tags[]" key="${tagitem.key}" id="f_tags_${tagitem.key}" value="${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}"<c:if test="${ident_tag == tagitem.key}"> selected="selected" </c:if> >${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()})
                                            </label> 
                                    </c:forEach>                                        
                                </td>
                            </tr>                                -->
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
            <style>
                .monitorlist,
                .monitorlist *
                {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                }

                .monitorlist li
                {
                    list-style: none;                    
                }
                .monitorlist li ul
                {
                    display: flex;
                    flex-direction: row;
                    align-items: stretch;
                    flex-wrap: wrap;
                }
                .monitorlist li ul#regularlist
                {
                    border: double 6px transparent;
                    border-top: double 6px #d5d5d5;   
                }                
                
                .monitorlist li ul li
                {
                    flex: 1; 
                    list-style: none;
                    /*float: left;*/
                    padding: 5px;
                    border: solid 1px #d5d5d5;                    
                    border-radius: 5px;

                    margin: 3px;
                    word-wrap: break-word;
                    text-align: left;
                    white-space: nowrap;
                    cursor: pointer;
                    position: relative;      
                    -webkit-box-shadow: 2px 2px 2px 0px rgba(138,138,138,1);
                    -moz-box-shadow: 2px 2px 2px 0px rgba(138,138,138,1);
                    box-shadow: 2px 2px 2px 0px rgba(138,138,138,1);          
                }  
/*                .monitorlist li ul li.spec
                {
                    -webkit-box-shadow: 10px 10px 5px 0px rgba(138,138,138,1);
                    -moz-box-shadow: 10px 10px 5px 0px rgba(138,138,138,1);
                    box-shadow: 10px 10px 5px 0px rgba(138,138,138,1);                    
                }*/
                /*                .monitorlist li ul li div
                                {
                                    white-space: nowrap;                    
                                }*/
                .inline
                {
                    display: inline-block;
                    margin: 0 0 0 5px;
                }
                .info.name
                {
                    border: 1px solid #d5d5d5;
                    padding: 5px;
                    margin-bottom: 5px;
                    text-align: center;
                    border-radius: 5px;
                    background-color: #e4e4e4;  
                    clear: both;
                }
                #speciallist .info.name
                {
                    border-color: #73879C;
                    background-color: #73879C;  
                    color: #e4e4e4;  
                }
                .message
                {
                    white-space: initial;
                    font-style: italic;
                    border-top: 1px solid #d5d5d5;
                    padding-top: 5px;
                    margin-top: 5px;                        

                }
                .valueinfo
                {
                    position: absolute;
                    top: 0px;
                    right: 10px;
                    font-size: 20px;                 
                }
            </style>
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
