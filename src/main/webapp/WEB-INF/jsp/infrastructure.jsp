<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12 ">
        <div class="x_panel">               
            <div class="row">
                <div class="col-md-2 col-sm-3 col-xs-12 profile_left">
                    <h4 ><b><spring:message code="filter"/></b> <i class="action fa fa-chevron-up hidefilter"></i> </h4>
                </div>
                <div class="col-md-10 col-sm-9 col-xs-12 profile_right">

                </div>
            </div>            

            <div class="col-md-2 col-sm-3 col-xs-12 profile_left">                                
                <form class="form-horizontal form-label-left form-filter profile_left-form">
                    <div class="form-group">
                        <label class="col-md-12 col-sm-12 col-xs-12"><spring:message code="infrastructure.forMetric"/></label>
                        <div class="col-lg-12 col-sm-12 col-xs-12">
                            <input class="form-control autocomplete-append-metric filter-input" type="text" name="metric_input" id="metric_input" tagkey="metric" value="">
                            <div class="autocomplete-container-metric" style="position: relative; float: left; width: 400px; margin: 0px;"></div>
                        </div>    
                        <label class="col-md-12 col-sm-12 col-xs-12"><spring:message code="tags"/></label>
                        <div id="tagsconteger" style="clear: both">                            
                            <c:forEach items="${taglist}" var="tagitem">   
                                <div class="form-group tag-grop draggable" style="display: none">
                                    <label class=" col-lg-12 col-sm-12 col-xs-12">
                                        ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}
                                        <input <c:if test="${true == tagitem.value}"> checked="true" </c:if>  type="checkbox" class="js-switch-small filter-switch" id="check_${tagitem.key}" name="check_${tagitem.key}" value="${tagitem.key}"/> 
                                        </label>
                                        <div class="col-lg-12 col-sm-12 col-xs-12">
                                        <c:set value="${tagitem.key}_input" var="inputname" />
                                        <spring:message code="infrastructure.valueFilter" var="ph"/>
                                        <input class="form-control autocomplete-append filter-input" type="text" name="${tagitem.key}_input" id="${tagitem.key}_input" tagkey="${tagitem.key}" value="${filter.get(inputname).getAsString()}" placeholder="${ph}">
                                        <div class="autocomplete-container_${tagitem.key}" style="position: relative; float: left; width: 400px; margin: 0px;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="form-group">                        
                        <div class="row text-right">
                            <div class="col-md-6  col-xs-12 text-left">
                                <button class="btn btn-success" type="button" value="Default" id="Save"><spring:message code="save"/></button>        
                            </div>
                            <div class="col-md-6  col-xs-12">
                                <button class=" btn btn-primary" type="button" value="Default" id="Show"><spring:message code="display"/></button>        
                            </div>
                        </div>
                    </div>                        
                </form>                        
            </div>
            <div class="col-md-10 col-sm-9 col-xs-12 profile_right-table">
                <div class="x_panel">
                    <div id="echart_line" ></div>
                </div>                 
            </div>                                    
        </div>
    </div>
</div>