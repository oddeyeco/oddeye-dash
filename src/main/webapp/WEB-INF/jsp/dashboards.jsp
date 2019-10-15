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
          <div class="col-lg-8">
              <div class="card shadow mb-2 mb-md-4">
                  <h5 class="card-header">
                      <spring:message code="dashboards.myDashboards"/> (${activeuser.getDushList().size()})
                      <a class="btn btn-outline-success btn-xs float-right" href="<spring:url value="/dashboard/new" htmlEscape="true"/>"><spring:message code="dashboards.newDashboard"/></a>                            
                  </h5>                           
                  <div class="card-body">
                      <ul class="row gotodash p-1 p-sm-2 depthShadowLightHover">                            
                          <c:forEach items="${activeuser.getDushListasObject()}" var="Dush" varStatus="loop">                                
                              <li class=" col-6 col-sm-6 col-md-4 col-lg-4">
                                  <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" title="${Dush.key}" class="gotodash text-truncate">
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
              <div class="card shadow mb-2 mb-md-4">
                  <h5 class="card-header">
                      <spring:message code="dashboards.statistic"/>
                      <a id="Get_Agent" class="btn btn-outline-success btn-xs float-right ml-2" href="<spring:url value="https://github.com/oddeyeco/"  htmlEscape="true"/>" target="_blank"><spring:message code="dashboards.getAgent"/></a>
                      <a id="Agent_Guide" class="btn btn-outline-success btn-xs float-right" href="<spring:url value="https://www.oddeye.co/documentation/puypuy/puypuy/" htmlEscape="true"/>" target="_blank"><spring:message code="dashboards.guideAgent"/></a>
                  </h5>
                  <div class="card-body metricstat">
                      <c:import url="metricinfo.jsp"/>                                  
                  </div>
              </div>     
          </div>        
          <div class="col-lg-4">
              <c:if test="${not empty whitelabel}" >                           
                  <c:if test="${whitelabel.userpayment}" >                    
                      <c:import url="balacepart.jsp" />
                  </c:if>                      
              </c:if>          
              <c:if test="${empty whitelabel}" >                   
                  <c:import url="balacepart.jsp" />
              </c:if>                       
              <div class="card shadow mb-4">
                  <h5 class="card-header">
                      <spring:message code="dashboards.availableTemplates"/>                                 
                  </h5>
                  <div class="card-body">
                      <ul class="row list-unstyled gotodash depthShadowLightHover">
                          <c:forEach items="${recomend}" var="Dush" varStatus="loop">                                
                              <li class="col-xl-12">
                                  <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash"> <span> 
                                          <i class="fa fas fa-info-circle" data-toggle="tooltip" data-html="true" data-placement="left" title="" data-delay='{"hide":"1000"}' data-original-title="${fn:escapeXml(Dush.getDescription())} <div> Metrics-${Dush.getUsednames().size()}<br>Tag Filters-${Dush.getUsedtags().size()}</div>"></i>

                                          ${Dush.getName()}</span>
                                      <span class="float-right"><fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/></span>                                    
                                  </a> 
                              </li>                                
                          </c:forEach>
                      </ul>                  
                  </div>
                  <h5 class="card-header">
                      <spring:message code="dashboards.myTemplates"/>           
                  </h5>
                  <div class="card-body"> 
                      <ul class="row list-unstyled gotodash depthShadowLightHover"> 
                          <c:forEach items="${mylasttemplates}" var="Dush" varStatus="loop">                                
                              <li class="col-12">
                                  <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash">                                    
                                      <c:if test="${Dush.isRecomended()}">
                                          <i class="fa fa-check-circle green"></i>
                                      </c:if>                                      
                                      <c:if test="${!Dush.isRecomended()}">
                                          <i class="fa fa-dot-circle-o blue"></i>
                                      </c:if>                                         
                                      <span>${Dush.getName()}</span>
                                      <span class="float-right"> <fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/></span>                                    
                                  </a> 
                              </li>                                
                          </c:forEach> 
                      </ul> 
                  </div>  
              </div>
          </div>
      </div>                                              
