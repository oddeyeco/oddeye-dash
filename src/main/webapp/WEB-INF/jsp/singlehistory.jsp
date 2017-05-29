<%-- 
    Document   : singlehistory
    Created on : May 23, 2017, 11:53:58 AM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12 ">
        <div class="x_title">
            <div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
                <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
                <span><fmt:formatDate type="both" pattern="dd/MM/YYYY" value="${date}"/></span> <b class="caret"></b>
            </div>
            <h1><a href="${cp}/metriq/${metric.hashCode()}"> ${metric.getDisplayName()} </a>: ${metric.getTypeName()}</h1>

        </div>
        <div class="col-md-6 col-sm-12 col-xs-12 ">
            <div class="x_panel"  style="height: 182px">
                <div class="col-xs-6 col-md-6">
                    <div class="x_content "> 
                        <div class="x_title">
                            <h2><i class="fa fa-asterisk"></i> Tags</h2>                                         
                            <div class="clearfix"></div>
                        </div>                
                        <ul class="">
                            <c:forEach items="${metric.getTags()}" var="Tag" varStatus="loop">
                                <c:if test="${Tag.getKey() != \"UUID\"}">
                                    <li>
                                        <span class="name"> ${Tag.getKey()}: </span>
                                        <span class="value text-success"> ${Tag.getValue()}</span>
                                    </li>
                                </c:if>    
                            </c:forEach>
                        </ul>                
                    </div>                    
                </div>
                <c:if test="${metric.getType()!=0}">
                    <div class="col-xs-6 col-md-6 ">            
                        <div class="x_content "> 
                            <div class="x_title">
                                <h2><i class="fa fa-line-chart"></i> Regression</h2>     
                                <button class="btn btn-warning pull-right btn-sm noMargin" type="button" value="Default" id="Clear_reg">Clear</button>    
                                <div class="clearfix"></div>
                            </div>                
                            <ul class="">                                                 
                                <li>
                                    <span class="name">Correlation Coefficient </span>                            
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
                                    <span class="name">Slope </span>
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
                                    <span class="name">RSquare</span>
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
                                    <span class="name">Counts </span>
                                    <span class="value text-success">${metric.getRegression().getN()}</span>
                                </li>
                            </ul>   
                        </div>
                    </div>       
                </c:if>
            </div>     
        </div>
        <div class="col-md-6 col-sm-12 col-xs-12 ">
            <div class="x_panel">
                <div id="echart_line" class="echart_line_single" style="height: 160px"></div>
            </div>

        </div>
        <div class="col-md-12 col-sm-12 col-xs-12 profile_right">
            <div class="x_panel">                                     
                <div class="x_content" style="display: block;">
                    <!-- start List -->
                    <table id="datatable" class="table metrictable table-striped bulk_action">
                        <thead>
                            <tr>
                                <!--<th>#</th>-->
                                <th>State</th>
                                <th>Level</th>
                                <th>Info</th>                                
                                <th>Last Time</th>     
                                <th>Duration</th>                                     
                                <th>Start Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                            <jsp:useBean id="dateValue" class="java.util.Date"/>       
                            <c:set value="${dateValue.getTime()}" var="lasttime"/>
                            <c:forEach items="${list}" var="listitem" varStatus="loop">   
                                <tr class="level_${listitem.getLevel()}" level="${listitem.getLevel()}" time="${listitem.getTime()}">
                                    <td>
                                        <c:set value="" var="arrowclass"/>
                                        <c:set value="red" var="color"/>
                                        <c:if test="${listitem.getState()==2}">
                                            <c:set value="fa-long-arrow-down" var="arrowclass"/>
                                            <c:set value="green" var="color"/>
                                        </c:if>
                                        <c:if test="${listitem.getState()==3||listitem.getState()==0}">
                                            <c:set value="fa-long-arrow-up" var="arrowclass"/>
                                            <c:set value="red" var="color"/>
                                        </c:if>                                        
                                        <i class="action fa ${arrowclass}" style="color:${color};"></i>
                                    </td>                                    
                                    <td class="level" >
                                        <div>
                                            <c:if test="${listitem.getLevel()>-1}">
                                                ${listitem.getLevelName()}
                                            </c:if>
                                            <c:if test="${listitem.getLevel()==-1}">
                                                OK
                                            </c:if>

                                        </div>
                                    </td>
                                    <td class="message" value="${listitem.getMessage()}">
                                        <c:if test="${metric.getType()>0}">                                            
                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${listitem.getStartvalue()}" />
                                        </c:if>

                                    </td>                                    
                                    <jsp:setProperty name="dateValue" property="time" value="${listitem.getTime()}"/>
                                    <td class="time" value ="">
                                        <fmt:formatDate type="both" pattern="HH:mm:ss" value="${dateValue}"/>                                                                                                                            
                                    </td>   
                                    <td class="timeinterval" value ="${lasttime-listitem.getTime()}">                                                                                
                                    </td>                                       
                                    <c:set value="${listitem.getTime()}" var="lasttime"/>                                        
                                    <td class="time" value ="">
                                        <c:if test="${listitem.getLevel()>=0}">
                                            <c:if test="${not empty listitem.getStarttimes()[listitem.getLevel()]}">
                                                <jsp:setProperty name="dateValue" property="time" value="${listitem.getStarttimes()[listitem.getLevel()]}"/>
                                                <fmt:formatDate type="both" pattern="MM/dd HH:mm:ss" value="${dateValue}"/>                                            
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
