<%-- 
    Document   : dashboards
    Created on : Apr 12, 2017, 12:14:22 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="row">
    <div class="page-title"><div class="title_left"><h1>Dashboards</h1></div></div>
</div>
<div class="row">
    <div class="col-md-8">
        <div class="x_panel">    
            <div class="x_title">
                <h2>My Dashboards (${curentuser.getDushList().size()})</h2>
                <a class="btn btn-success btn-sm pull-right" href="<spring:url value="/dashboard/new"  htmlEscape="true"/>" >New Dashboard </a>
                <div class="clearfix"></div>
            </div>

            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${curentuser.getDushList()}" var="Dush" varStatus="loop">                                
                            <li class="col-md-6">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" class="gotodash">${Dush.getKey()}</a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                

        </div>    
        <div class="x_panel">    
            <div class="x_title">
                <h2>Statistic</h2>                
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div class="row tile_count">
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top"><i class="fa fa-list"></i> Total Metric Names</span>
                        <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" width="100%"></div>
                    </div>                                                
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top"><i class="fa fa-folder"></i> Total Tags Type</span>
                        <div class="count" id="tags"><img src="${cp}/assets/images/loading.gif" width="100%"></div>
                        <!--<span class="count_bottom"><i class="green">4% </i> From last Week</span>-->
                    </div>                                                
                </div>
                <div class="row tile_count" id="tagslist">                                        
                </div>
            </div>                
        </div>                 

    </div>    
    <div class="col-md-4">
        <div class="x_panel">          
            <div class="x_title">
                <h2>Recommended templates</h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${recomend}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash"> <span>${Dush.getName()}</span>
                                    <span class="pull-right"> <fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss"/> </span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>             
            <div class="x_title">
                <h2>Last templates</h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash lastdash">
                        <c:forEach items="${lasttemplates}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash">                                    
                                    <c:if test="${Dush.isRecomended()}">
                                        <i class="fa fa-check-circle green"></i>
                                    </c:if>                                      
                                    <c:if test="${!Dush.isRecomended()}">
                                        <i class="fa fa-dot-circle-o blue"></i>
                                    </c:if>                                         
                                    <span>${Dush.getName()}</span>
                                    <span class="pull-right"> <fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss"/> </span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                         

            <div class="x_title">
                <h2>My last templates</h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash lastdash">
                        <c:forEach items="${mylasttemplates}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash">                                    
                                    <c:if test="${Dush.isRecomended()}">
                                        <i class="fa fa-check-circle green"></i>
                                    </c:if>                                      
                                    <c:if test="${!Dush.isRecomended()}">
                                        <i class="fa fa-dot-circle-o blue"></i>
                                    </c:if>                                         
                                    <span>${Dush.getName()}</span>
                                    <span class="pull-right"> <fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss"/> </span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                                     

        </div>    
    </div> 
</div>

