<%-- 
    Document   : dashboardsOE
    Created on : Apr 17, 2019, 5:07:47 PM
    Author     : tigran
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="row">
    <div class="col-md-8">
        <div class="x_panel">    
            <div class="x_title">
                <h2><spring:message code="dashboards.myDashboards"/> (${activeuser.getDushList().size()})</h2>
                <a class="btn btn-success btn-sm pull-right" href="<spring:url value="/dashboard/new" htmlEscape="true"/>" ><spring:message code="dashboards.newDashboard"/> </a>
                <div class="clearfix"></div>
            </div>

            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${activeuser.getDushListasObject()}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-4 col-xs-6">
                                <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" class="gotodash">
                                    <c:if test="${Dush.value.get(\"locked\")==true}">
                                        &nbsp; <i class="fa fas fa-lock"></i>
                                    </c:if>                                                               
                                    <c:if test="${Dush.value.get(\"locked\")!=true}">
                                        &nbsp; <i class="fa fas fa-lock-open"></i>
                                    </c:if>                                      
                                    ${Dush.getKey()}</a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                

        </div>    
        <div class="x_panel">    
            <div class="x_title">
                <div class="row">
                    <div class="col-md-6 col-xs-12 pull-left">
                        <h2><spring:message code="dashboards.statistic"/></h2>
                    </div>         
                    <div class="col-md-6 col-xs-12">
                        <a id="Get_Agent" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://github.com/oddeyeco/" htmlEscape="true" />" target="_blank" ><spring:message code="dashboards.getAgent"/></a>
                        <a id="Agent_Guide" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://www.oddeye.co/documentation/puypuy/puypuy/" htmlEscape="true"/>" target="_blank"><spring:message code="dashboards.guideAgent"/></a>
                    </div>
                </div>
                <div class="clearfix"></div>
            </div>
            <div class="x_content metricstat">
                <c:import url="metricinfo.jsp"/>
            </div>                
        </div>
    </div>
    <div class="col-md-4">
        <c:if test="${not empty whitelabel}" >                           
            <c:if test="${whitelabel.userpayment}" >                    
                <c:import url="balacepart.jsp" />
            </c:if>                      
        </c:if>          
        <c:if test="${empty whitelabel}" >                  
            <c:import url="balacepart.jsp" />
        </c:if>            

        <div class="x_panel">          
            <div class="x_title">
                <h2><spring:message code="dashboards.availableTemplates"/></h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${recomend}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash"> <span> 
                                        <i class="fa fas fa-info-circle" data-toggle="tooltip" data-html="true" data-placement="left" title="" data-delay='{"hide":"1000"}' data-original-title="${fn:escapeXml(Dush.getDescription())} <div> Metrics-${Dush.getUsednames().size()}<br>Tag Filters-${Dush.getUsedtags().size()}</div>"></i>

                                        ${Dush.getName()}</span>
                                    <span class="pull-right"><fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/></span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>             
            <div class="x_title">
                <h2><spring:message code="dashboards.myTemplates"/></h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash lastdash">
                        <c:forEach items="${mylasttemplates}" var="Dush" varStatus="loop">                                
                            <li class="col-xs-12 col-md-12 col-sm-6 col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash">                                    
                                    <c:if test="${Dush.isRecomended()}">
                                        <i class="fa fa-check-circle green"></i>
                                    </c:if>                                      
                                    <c:if test="${!Dush.isRecomended()}">
                                        <i class="fa fa-dot-circle-o blue"></i>
                                    </c:if>                                         
                                    <span>${Dush.getName()}</span>
                                    <span class="pull-right"> <fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/></span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                                     
        </div>         
    </div> 
</div>
                
                // -------------------------- ////////// ---- ///////////// ------------------------- //
      // -------------------------- ////////// ---- ///////////// ---- ///////////// ------------------------- //
      
      <div class="row">
                        <div class="col-12 col-xl-8 col-lg-8 order-1">
                            <div class="card shadow mb-4">
                                <h4 class="card-header">
                                    <spring:message code="dashboards.myDashboards"/> (${activeuser.getDushList().size()})
                                    <a class="btn btn-outline-success btn-sm float-right" href="<spring:url value="/dashboard/new" htmlEscape="true"/>"><spring:message code="dashboards.newDashboard"/></a>                            
                                </h4>                           
                                <div class="card-body">
                                    <ul class="row gotodash">                            
                                        <c:forEach items="${activeuser.getDushListasObject()}" var="Dush" varStatus="loop">                                
                                            <li class=" col-6 col-sm-6 col-lg-4">
                                                <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" class="gotodash">
                                                    <c:if test="${Dush.value.get(\"locked\")==true}">
                                                        &nbsp; <i class="fa fas fa-lock"></i>
                                                    </c:if>                                                               
                                                    <c:if test="${Dush.value.get(\"locked\")!=true}">
                                                        &nbsp; <i class="fa fas fa-lock-open"></i>
                                                    </c:if>                                      
                                                    ${Dush.getKey()}
                                                </a> 
                                            </li>                                
                                        </c:forEach>               
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-8 col-lg-8 order-3">
                            <div class="card shadow mb-4">
                                <h4 class="card-header">
                                    <spring:message code="dashboards.statistic"/>
                                    <a id="Get_Agent" class="btn btn-outline-success btn-sm float-right ml-2" href="<spring:url value="https://github.com/oddeyeco/"  htmlEscape="true"/>" target="_blank"><spring:message code="dashboards.getAgent"/></a>
                                    <a id="Agent_Guide" class="btn btn-outline-success btn-sm float-right" href="<spring:url value="https://www.oddeye.co/documentation/puypuy/puypuy/" htmlEscape="true"/>" target="_blank"><spring:message code="dashboards.guideAgent"/></a>
                                </h4>
                                <div class="card-body metricstat">
                                    <c:import url="metricinfo.jsp"/>                                  
                                </div>
                            </div>                          
                        </div>                                        
                        <div class="col-12 col-xl-4 col-lg-4 order-2">
                            <c:if test="${not empty whitelabel}" >                           
                                <c:if test="${whitelabel.userpayment}" >                    
                                    <c:import url="balacepart.jsp" />
                                </c:if>                      
                            </c:if>          
                            <c:if test="${empty whitelabel}" >                   
                                <c:import url="balacepart.jsp" />
                            </c:if>
                        </div>

                            <div class="card shadow mb-4">
                                <h4 class="card-header">
                                    Available templates                                 
                                </h4>
                                <div class="card-body"> 
                                    <ul class="row list-unstyled">
                                        <li class="col-12">
                                            <a href="#" class="">
                                                <span>
                                                    <i class="fa fas fa-info-circle"
                                                       data-toggle="tooltip"
                                                       data-html="true"
                                                       data-placement="left"
                                                       title=""
                                                       data-delay="{&quot;hide&quot;:&quot;1000&quot;}"
                                                       data-original-title="<div>Metrics-21<br>Tag Filters-1</div>">                                                            
                                                    </i>System (up to 2 servers recommended)
                                                </span>
                                                <span class="float-right">12/28/2017 18:54:12 AMT</span>
                                            </a>
                                        </li>
                                        <li class="col-12">
                                            <a href="#" class="">
                                                <span>
                                                    <i class="fa fas fa-info-circle"
                                                       data-toggle="tooltip"
                                                       data-html="true"
                                                       data-placement="left"
                                                       title=""
                                                       data-delay="{&quot;hide&quot;:&quot;1000&quot;}"
                                                       data-original-title=" <div> Metrics-22<br>Tag Filters-2</div>">                                                               
                                                    </i> System Small 1 Host
                                                </span>
                                                <span class="float-right">02/14/2018 09:23:24 AMT</span>
                                            </a>
                                        </li>
                                        <li class="col-12">
                                            <a href="#" class="">
                                                <span>
                                                    <i class="fa fas fa-info-circle"
                                                       data-toggle="tooltip"
                                                       data-html="true"
                                                       data-placement="left"
                                                       title=""
                                                       data-delay="{&quot;hide&quot;:&quot;1000&quot;}"
                                                       data-original-title="<div> Metrics-4<br>Tag Filters-0</div>">                                                               
                                                    </i> Template NginX
                                                </span>
                                                <span class="float-right">12/29/2017 10:47:11 AMT</span>
                                            </a>
                                        </li>
                                    </ul> 
                                </div> 
                                <h4 class="card-header">
                                    My templates                               
                                </h4>
                                <div class="card-body"> 
                                    <ul class="row list-unstyled gotodash">                                      
                                        <li class="col-12">
                                            <a href="#" class="gotodash">
                                                <span>
                                                    System (2 servers)
                                                </span>
                                                <span class="float-right">12/29/2017 10:47:11 AMT</span>
                                            </a>
                                        </li>
                                        <li class="col-12">
                                            <a href="#" class="gotodash">
                                                <span>
                                                    Dashboard Storm
                                                </span>
                                                <span class="float-right">12/28/2017 18:54:12 AMT</span>
                                            </a>
                                        </li>
                                        <li class="col-12">
                                            <a href="#" class="gotodash">
                                                <span>
                                                    Dash_12
                                                </span>
                                                <span class="float-right">02/14/2018 09:23:24 AMT</span>
                                            </a>
                                        </li>                                           
                                    </ul> 
                                </div>  
                            </div>
                        </div>
                    </div>
                

