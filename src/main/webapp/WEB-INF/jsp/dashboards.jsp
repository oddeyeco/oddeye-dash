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
    <div class="page-title"><div class="title_left"><h1>Dashboards</h1></div></div>
</div>
<div class="row">
    <div class="col-md-8">
        <div class="x_panel">    
            <div class="x_title">
                <h2>My Dashboards (${activeuser.getDushList().size()})</h2>
                <a class="btn btn-success btn-sm pull-right" href="<spring:url value="/dashboard/new"  htmlEscape="true"/>" >New Dashboard </a>
                <div class="clearfix"></div>
            </div>

            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${activeuser.getDushListasObject()}" var="Dush" varStatus="loop">                                
                            <li class="col-md-6">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" class="gotodash">
                                    <c:if test="${Dush.value.get(\"locked\")==true}">
                                        &nbsp; <i class="fa fa-lock"></i>
                                    </c:if>                                                               
                                    <c:if test="${Dush.value.get(\"locked\")!=true}">
                                        &nbsp; <i class="fa fa-unlock"></i>
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
                <h2>Statistic</h2>         
                <a id="Get_Agent" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://github.com/oddeyeco/"  htmlEscape="true" />" target="_blank" >Get Agent</a>
                <a id="Agent_Guide" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://www.oddeye.co/documentation/puypuy/puypuy/"  htmlEscape="true"/>" target="_blank">Agent Guide</a>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div class="row tile_count">

                    <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top"><i class="fa fa-list"></i> Metric Names</span>
                        <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" width="100%"></div>
                    </div>                                                
                    <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top"><i class="fa fa-folder"></i> Total Tags</span>
                        <div class="count" id="tags"><img src="${cp}/assets/images/loading.gif" width="100%"></div>
                        <!--<span class="count_bottom"><i class="green">4% </i> From last Week</span>-->
                    </div>         
                    <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top"><i class="fa fa-folder"></i> Total Metrics</span>
                        <div class="count" id="count"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                        <span class="count_bottom">&nbsp;</span>
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
                <h2>Available templates</h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${recomend}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash"> <span> 
                                        <i class="fa fa-info-circle" data-toggle="tooltip" data-html="true" data-placement="left" title="" data-delay='{"hide":"1000"}' data-original-title="${fn:escapeXml(Dush.getDescription())} <div> Metrics-${Dush.getUsednames().size()}<br>Tag Filters-${Dush.getUsedtags().size()}</div>"></i>
                                        
                                        ${Dush.getName()}</span>
                                    <span class="pull-right"><fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/></span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>             
            <div class="x_title">
                <h2>My templates</h2>
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

