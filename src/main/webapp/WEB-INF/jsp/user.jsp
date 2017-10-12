<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- 
    Document   : user
    Created on : May 11, 2017, 2:21:00 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="x_panel">
    <div class="col-sm-9 col-xs-12 profile_left">
        <div class="row tile_count">
            <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                <span class="count_top"><i class="fa fa-list"></i> Metric Names</span>
                <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" height='50px' ></div>                   
            </div>                                                
            <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                <span class="count_top"><i class="fa fa-folder"></i> Total Tags</span>
                <div class="count" id="tags"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                <span class="count_bottom">&nbsp;</span>
            </div>                                                
            <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                <span class="count_top"><i class="fa fa-folder"></i> Metrics</span>
                <div class="count" id="count"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                <span class="count_bottom">&nbsp;</span>
            </div>                                                          
            <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                <span class="count_top"><i class="fa fa-folder"></i> Unique tags </span>
                <div class="count" id="uniqtagscount"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                <span class="count_bottom">&nbsp;</span>
            </div>            
        </div>
        <div class="row tile_count" id="tagslist">

        </div>
        <div id="listtablediv" class="raw">
            <div class="col-md-4">
                <h3>Consumption by days</h3>
                <ul class="list-group">
                    <c:forEach items="${model.getConsumptionList().getConsumptionListDaily()}" var="Consumption" varStatus="loop" end="10">
                        <li class="list-group-item <c:if test="${loop.first}">disabled</c:if>"> <fmt:formatDate type="both" pattern="YY/MM/dd" value="${Consumption.getValue().getTime().getTime()}" timeZone="${curentuserl.getTimezone()}"/> ${curentuserl.getTimezone()} <span class="badge"><fmt:formatNumber type="number" pattern = "0.0000" maxFractionDigits="4" value=" ${Consumption.getValue().getAmount()}" /> $</span><span class="badge"> ${Consumption.getValue().getCount()}</span></li>    
                    </c:forEach>                          
                </ul>                          
            </div><div class="col-md-4">
                <h3>Consumption List by Houre</h3>
                <ul class="list-group">
                    <c:forEach items="${model.getConsumptionList().getConsumptionListHoure()}" var="Consumption" varStatus="loop" end="10">
                        <li class="list-group-item <c:if test="${loop.first}">disabled</c:if>"> <fmt:formatDate type="both" pattern="HH:mm YY/MM/dd" value="${Consumption.getValue().getTime().getTime()}" timeZone="${curentuserl.getTimezone()}"/> ${curentuserl.getTimezone()} <span class="badge"><fmt:formatNumber type="number" pattern = "0.0000" maxFractionDigits="4" value=" ${Consumption.getValue().getAmount()}" /> $</span><span class="badge">${Consumption.getValue().getCount()}</span></li>    
                    </c:forEach>                          
                </ul>                    
            </div><div class="col-md-4">
                <h3>Consumption List 10 min</h3>
                <ul class="list-group">
                    <c:forEach items="${model.getConsumptionList()}" var="Consumption" varStatus="loop" end="10">
                        <li class="list-group-item <c:if test="${loop.first}">disabled</c:if>"><fmt:formatDate type="both" pattern="HH:mm YY/MM/dd" value="${Consumption.getValue().getTime().getTime()}" timeZone="${curentuserl.getTimezone()}"/> ${curentuserl.getTimezone()} <span class="badge"><fmt:formatNumber type="number" pattern = "0.0000" maxFractionDigits="4" value=" ${Consumption.getValue().getAmount()}" /> $</span><span class="badge"> ${Consumption.getValue().getCount()}</span></li>    
                    </c:forEach>                          
                </ul>
            </div>
        </div>
    </div>
</div>