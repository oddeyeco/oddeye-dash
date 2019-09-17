<%-- 
    Document   : infrastructure
    Created on : May 2, 2019, 12:47:37 PM
    Author     : tigran
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
                                                              
    <div class="row">                
        <div class="col-lg-12 col-md-12 col-sm-12 col-12">                
            <div class="card shadow">
                <div class="card-header">
                    <button type="button" id="filterCollapse" class="btn btn-outline-dark hidefilter">
                        <i class="fas fa-indent fa-rotate-90"></i><b class="pagetitle"><spring:message code="filter"/></b>
                    </button>
                </div>
                <div class="card-body row">
                    <div class="col-lg-2 col-md-3 col-12 profile_left d-flex flex-column">

                        <div class="mb-auto">
                            <form class="form-group row form-label-left form-filter profile_left-form" style="display: block;">
                                <div class="form-group">
                                    <label class="col-form-label"><spring:message code="infrastructure.forMetric"/></label>
                                    <div class="col-12">
                                        <input class="form-control autocomplete-append-metric filter-input" type="text" name="metric_input" id="metric_input" tagkey="metric" value="" autocomplete="off">
                                        <div class="autocomplete-container-metric" style="position: relative; float: left; width: 400px; margin: 0px;"></div>                                                    
                                    </div>
                                    <label class="col-form-label"><spring:message code="tags"/></label>
                                    <div id="tagsconteger" style="clear: both" class="scrollTagsContant ui-sortable depthShadowLightHover">                                        
                                        <c:forEach items="${taglist}" var="tagitem">                                  
                                            <div class="form-group tag-grop draggable draggableHint" style="display: none">
                                                <label class="col-lg-12 col-md-12 col-12">
                                                    ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}
                                                    <input <c:if test="${true == tagitem.value}"> checked="true" </c:if>  type="checkbox" class="js-switch-small filter-switch" id="check_${tagitem.key}" name="check_${tagitem.key}" value="${tagitem.key}"/> 
                                                    <i class="fas fa-arrows-alt-v float-right pt-1"></i>
                                                </label>
                                                    <div class="col-lg-12 col-md-12 col-12 p-0">
                                                    <c:set value="${tagitem.key}_input" var="inputname" />
                                                    <spring:message code="infrastructure.valueFilter" var="ph"/>
                                                    <input class="form-control autocomplete-append filter-input" type="text" name="${tagitem.key}_input" id="${tagitem.key}_input" tagkey="${tagitem.key}" value="${filter.get(inputname).getAsString()}" placeholder="${ph}">
                                                    <div class="autocomplete-container_${tagitem.key}" style="position: relative; float: left; width: 400px; margin: 0px;"></div>
                                                </div>
                                            </div>
                                        </c:forEach>                                                                              
                                    </div>                                                
                                </div>                                    
                            </form>                        
                        </div>                                
                        <div class="row profile_btn">
                            <div class="col-auto mr-auto p-0">                                
                                <button class="btn btn-outline-success" type="button" value="Default" id="Save"><spring:message code="save"/></button>
                            </div>                                                         
                            <div class="col-auto p-0 text-right">
                                <button class=" btn btn-outline-primary" type="button" value="Default" id="Show"><spring:message code="display"/></button>
                            </div> 
                        </div>                                
                    </div>
                    <div class="col-lg-10 col-md-9 col-12 profile_right-table">        
                        <div class="x_panel depthShadowDark">
                            <div id="echart_line"></div>
                        </div> 
                    </div>
                </div>
            </div>
        </div>
    </div>                                      