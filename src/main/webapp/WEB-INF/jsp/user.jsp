<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%-- 
    Document   : user
    Created on : May 11, 2017, 2:21:00 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="card shadow">    
    <div class="card-body">  
    <div class="profile_left">
        <div class="row tile_count mb-2 rounded-0">
            <div class="col-lg-2 col-sm-4 col-6 mr-1 tile_stats_count">
                <span class="count_top"><i class="fa fa-list"></i> <spring:message code="metricNames"/></span>
                <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" height='50px' ></div>                   
            </div>                                                
            <div class="col-lg-2 col-sm-4 col-6 mr-1 tile_stats_count">
                <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="totalTags"/></span>
                <div class="count" id="tags"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                <span class="count_bottom">&nbsp;</span>
            </div>                                                
            <div class="col-lg-2 col-sm-4 col-6 mr-1 tile_stats_count">
                <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="metrics"/></span>
                <div class="count" id="count"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                <span class="count_bottom">&nbsp;</span>
            </div>                                                          
            <div class="col-lg-2 col-sm-4 col-6 mr-1 tile_stats_count">
                <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="user.uniqueTags"/></span>
                <div class="count" id="uniqtagscount"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                <span class="count_bottom">&nbsp;</span>
            </div>            
        </div>
        <div class="row tile_count rounded-0" id="tagslist"></div>
        
        <div id="listtablediv" class="row raw">
            <div class="col-lg-3 depthShadowLightHover">
                <h3><spring:message code="user.consumptionMonth"/></h3>
                <ul class="list-group">
                    <c:forEach items="${model.getConsumptionList().getConsumptionListMonth()}" var="Consumption" varStatus="loop" end="10">
                        <li class="list-group-item p-2 <c:if test="${loop.first}">disabled</c:if>">
                            <div class="float-left">
                                <fmt:formatDate type="both" pattern="YYYY/MM z" value="${Consumption.getValue().getTime().getTime()}" timeZone="${curentuser.getTimezone()}"/>
                            </div>
                            <div class="float-right">
                            <span class="badge badge-secondary mr-1">
                                <fmt:formatNumber type="number" pattern = "0.0000" maxFractionDigits="4" value=" ${Consumption.getValue().getAmount()}" /> $
                            </span>
                            <span class="badge badge-secondary">
                                ${Consumption.getValue().getCount()}
                            </span>
                            </div>
                            
                        </li>    
                    </c:forEach>                          
                </ul>                          
            </div>
            <div class="col-lg-3 depthShadowLightHover">
                <h3><spring:message code="user.consumptionDays"/></h3>
                <ul class="list-group">
                    <c:forEach items="${model.getConsumptionList().getConsumptionListDaily()}" var="Consumption" varStatus="loop" end="10">
                        <li class="list-group-item p-2 <c:if test="${loop.first}">disabled</c:if>">
                            <div class="float-left">
                                <fmt:formatDate type="both" pattern="YY/MM/dd zz" value="${Consumption.getValue().getTime().getTime()}" timeZone="${curentuser.getTimezone()}"/>
                            </div>
                            <div class="float-right">
                            <span class="badge badge-secondary mr-1">
                                <fmt:formatNumber type="number" pattern = "0.0000" maxFractionDigits="4" value=" ${Consumption.getValue().getAmount()}" /> $
                            </span>
                            <span class="badge badge-secondary">
                                ${Consumption.getValue().getCount()}
                            </span>
                            </div>
                            
                        </li>    
                    </c:forEach>                          
                </ul>                          
            </div>
            <div class="col-lg-3 depthShadowLightHover">
                <h3><spring:message code="user.consumptionHoure"/></h3>
                <ul class="list-group">
                    <c:forEach items="${model.getConsumptionList().getConsumptionListHoure()}" var="Consumption" varStatus="loop" end="10">
                        <li class="list-group-item p-2 <c:if test="${loop.first}">disabled</c:if>">
                            <div class="float-left">
                                <fmt:formatDate type="both" pattern="HH:mm YY/MM/dd z" value="${Consumption.getValue().getTime().getTime()}" timeZone="${curentuser.getTimezone()}"/>
                            </div>
                            <div class="float-right">
                            <span class="badge badge-secondary mr-1">
                                <fmt:formatNumber type="number" pattern = "0.0000" maxFractionDigits="4" value=" ${Consumption.getValue().getAmount()}" /> $
                            </span>
                            <span class="badge badge-secondary">
                                ${Consumption.getValue().getCount()}
                            </span> 
                            </div>
                                                   
                        </li>    
                    </c:forEach>                          
                </ul>                    
            </div><div class="col-lg-3 depthShadowLightHover">
                <h3><spring:message code="user.consumption10min"/></h3>
                <ul class="list-group">
                    <c:forEach items="${model.getConsumptionList()}" var="Consumption" varStatus="loop" end="10">
                        <li class="list-group-item p-2 <c:if test="${loop.first}">disabled</c:if>">
                            <div class="float-left">
                                <fmt:formatDate type="both" pattern="HH:mm YY/MM/dd z" value="${Consumption.getValue().getTime().getTime()}" timeZone="${curentuser.getTimezone()}"/>
                            </div>
                            <div class="float-right">
                            <span class="badge badge-secondary mr-1">
                                <fmt:formatNumber type="number" pattern = "0.0000" maxFractionDigits="4" value=" ${Consumption.getValue().getAmount()}" /> $
                            </span>
                            <span class="badge badge-secondary">
                                ${Consumption.getValue().getCount()}
                            </span>
                            </div>
                            
                        </li>    
                    </c:forEach>                          
                </ul>
            </div>
        </div>
    </div>
</div>
</div>