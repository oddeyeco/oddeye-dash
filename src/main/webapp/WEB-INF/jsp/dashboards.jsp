<%-- 
    Document   : dashboards
    Created on : Apr 12, 2017, 12:14:22 PM
    Author     : vahan
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
                <a class="btn btn-success btn-sm pull-right" href="<spring:url value="/dashboard/new"  htmlEscape="true"/>" ><spring:message code="dashboards.newDashboard"/> </a>
                <div class="clearfix"></div>
            </div>

            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${activeuser.getDushListasObject()}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-4 col-xs-6">
                                <!--<input type="checkbox" class="flat">-->
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
                        <a id="Get_Agent" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://github.com/oddeyeco/"  htmlEscape="true" />" target="_blank" ><spring:message code="dashboards.getAgent"/></a>
                        <a id="Agent_Guide" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://www.oddeye.co/documentation/puypuy/puypuy/"  htmlEscape="true"/>" target="_blank"><spring:message code="dashboards.guideAgent"/></a>
                    </div>
                </div>
                <div class="clearfix"></div>
            </div>
            <div class="x_content metricstat">
                <c:import url="metricinfo.jsp" />
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

