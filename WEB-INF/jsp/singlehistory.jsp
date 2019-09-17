<%-- 
    Document   : singlehistory
    Created on : May 23, 2017, 11:53:58 AM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="co.oddeye.core.OddeeyMetricTypesEnum" %>

<div class="row">
    <div class="col-12">
        <div class="card shadow">
            <div class="card-header">
                <h4 class="card-title float-left">
                    <span class="badge badge-dark text-success align-top shadow"><a href="${cp}/metriq/${metric.sha256Code()}"> ${metric.getDisplayName()} :</a></span> ${metric.getTypeName()}               
                </h4>
                <div id="reportrange" class="float-right pull-right dropdown-toggle rounded-top border-secondary reportrange" >
                    <i class="fa fa-calendar p-1"></i>
                    <span><fmt:formatDate type="both" pattern="dd/MM/YYYY" value="${date}" timeZone="${curentuser.getTimezone()}"/></span>                 
                </div>
            </div>
            <div class="card-body row metriqs">
                <div class="col-6">
                    <div class="card row shadow">
                        <div class="col-12">

                            <div class="card-header row">
                                <div class="col-6">
                                    <h6 class="card-title">
                                        <i class="fa fa-asterisk"></i> <spring:message code="tags"/> 
                                    </h6> 
                                </div>
                                <div class="col-6">
                                    <h6 class="card-title">
                                        <i class="fa fas fa-chart-line"></i> <spring:message code="regression.h2"/>
                                        <button class="btn btn-outline-warning float-right btn-sm noMargin" type="button" value="Default" id="Clear_reg"><spring:message code="clear"/></button>
                                    </h6>
                                </div> 
                            </div>
                            <div class="card-body row p-1">
                                <div class="col-6">
                                    <ul class="font16">
                                        <c:forEach items="${metric.getTags()}" var="Tag" varStatus="loop">
                                            <c:if test="${Tag.getKey() != \"UUID\"}">
                                                <li>
                                                    <span class="name"> ${Tag.getKey()}:&#8194; </span>
                                                    <span class="value text-success"> ${Tag.getValue()}</span>
                                                </li>
                                            </c:if>    
                                        </c:forEach>
                                    </ul>
                                </div>
                                <c:if test="${metric.getType()!=OddeeyMetricTypesEnum.SPECIAL}">
                                    <div class="col-6">
                                        <ul class="font16">                                                 
                                            <li>
                                                <span class="name"><spring:message code="regression.correlationCoefficient"/>:&#8194; </span>                            
                                                <span class="value text-success">
                                                    <c:choose>
                                                        <c:when test="${metric.getRegression().getR() == Double.NaN}">
                                                            ${metric.getRegression().getR()}
                                                            <br />
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${metric.getRegression().getR()}" />
                                                            <br />
                                                        </c:otherwise>
                                                    </c:choose>                                
                                                </span>                            
                                            </li>
                                            <li>
                                                <span class="name"><spring:message code="regression.slope"/>:&#8194; </span>
                                                <span class="value text-success">                                        
                                                    <c:choose>
                                                        <c:when test="${metric.getRegression().getSlope() == Double.NaN}">
                                                            ${metric.getRegression().getSlope()}
                                                            <br />
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${metric.getRegression().getSlope()}" />
                                                            <br />                                                
                                                        </c:otherwise>
                                                    </c:choose>                                                                
                                                </span>                                                                       
                                            </li> 
                                            <li>
                                                <span class="name"><spring:message code="regression.rSquare"/>:&#8194; </span>
                                                <span class="value text-success">
                                                    <c:choose>
                                                        <c:when test="${metric.getRegression().getRSquare() == Double.NaN}">
                                                            ${metric.getRegression().getRSquare()}
                                                            <br />
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="5" value=" ${metric.getRegression().getRSquare()}" />
                                                            <br />
                                                        </c:otherwise>
                                                    </c:choose>                                
                                                </span>
                                            </li>
                                            <li>
                                                <span class="name"><spring:message code="regression.counts"/>:&#8194; </span>
                                                <span class="value text-success">${metric.getRegression().getN()}</span>
                                            </li>
                                        </ul>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>                        
                </div>

                <div class="col-6">
                    <div class="card shadow">                                
                        <div class="card-body p-2">                                
                            <div id="echart_line" class="echart_line_single" style="height: 200px"></div>
                        </div>
                    </div>
                </div>
                <div class="col-12  profile_right pl-0 mt-3">
                    <div class="card shadow">                                                        
                        <div class="card-body table-responsive" style="display: block;">
                            <!-- start List -->
                            <table id="datatable" class="table metrictable table-striped bulk_action">
                                <thead>
                                    <tr>
                                        <!--<th>#</th>-->
                                        <th><spring:message code="singlehistory.state"/></th>
                                        <th><spring:message code="level"/></th>
                                        <th><spring:message code="info"/></th>                                
                                        <th><spring:message code="lastTime"/></th>     
                                        <th><spring:message code="duration"/></th>                                     
                                        <th><spring:message code="startTime"/></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                                    <jsp:useBean id="dateValue" class="java.util.Date"/>       
                                    <c:set value="${dateValue.getTime()}" var="lasttime"/>
                                    <c:forEach items="${list}" var="listitem" varStatus="loop">   
                                        <tr class="level_${listitem.getLevel()}" level="${listitem.getLevel()}" time="${listitem.getTime()}">
                                            <td style="width: 1%" >
                                                <c:set value="" var="arrowclass"/>
                                                <c:set value="red" var="color"/>
                                                <c:if test="${listitem.getState()==2}">
                                                    <c:set value="fas fa-long-arrow-alt-down" var="arrowclass"/>
                                                    <c:set value="green" var="color"/>
                                                </c:if>
                                                <c:if test="${listitem.getState()==3||listitem.getState()==0}">
                                                    <c:set value="fas fa-long-arrow-alt-up" var="arrowclass"/>
                                                    <c:set value="red" var="color"/>
                                                </c:if>                                        
                                                <i class="action fa ${arrowclass}" style="color:${color};"></i>
                                            </td>                                    
                                            <td class="level" style="width: 1%" >
                                                <div>                                                    
                                                    <c:if test="${listitem.getLevel()>-1}">
                                                        <spring:message code="level_${listitem.getLevel()}"/>
                                                    </c:if>
                                                    <c:if test="${listitem.getLevel()==-1}">
                                                        <spring:message code="singlehistory.ok"/>
                                                    </c:if>                                                    
                                                </div>
                                            </td>
                                            <td class="message" value="${listitem.getMessage()}">
                                                <c:if test="${metric.getType()>OddeeyMetricTypesEnum.SPECIAL}">                                            
                                                    <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${listitem.getStartvalue()}" />
                                                </c:if>

                                            </td>                                    
                                            <jsp:setProperty name="dateValue" property="time" value="${listitem.getTime()}"/>
                                            <td class="time" value ="${listitem.getTime()}">                                        
                                                <fmt:formatDate type="both" pattern="MM/dd H:mm:ss" value="${dateValue}" timeZone="${curentuser.getTimezone()}"/>
                                            </td>   
                                            <td class="timeinterval" value ="${lasttime-listitem.getTime()}">                                                                                
                                            </td>                                       
                                            <c:set value="${listitem.getTime()}" var="lasttime"/>                                        
                                            <td class="time" value ="">
                                                <c:if test="${listitem.getLevel()>=0}">
                                                    <c:if test="${not empty listitem.getStarttimes()[listitem.getLevel()]}">
                                                        <jsp:setProperty name="dateValue" property="time" value="${listitem.getStarttimes()[listitem.getLevel()]}"/>
                                                        <fmt:formatDate type="both" pattern="MM/dd hh:mm:ss" value="${dateValue}" timeZone="${curentuser.getTimezone()}"/>                                            
                                                    </c:if>
                                                </c:if>
                                            </td>       
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <!-- end of List -->                      
                        </div>                        
                    </div>
                </div>        
            </div> 
        </div>  
    </div>   
</div> 
