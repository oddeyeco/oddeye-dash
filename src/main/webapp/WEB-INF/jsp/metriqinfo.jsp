<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="co.oddeye.core.OddeeyMetricTypesEnum" %>

<div class="row">
    <div class="col-12">
        <div class="card shadow">
            <h4 class="card-header">
                <spring:message code="metriginfo.metric.h1" arguments="${cp},${metric.sha256Code()},${metric.getName()}"/><fmt:formatDate type="both" pattern="HH:00 Y/MM/dd" value="${Date}" timeZone="${curentuser.getTimezone()}"/> ${curentuser.getTimezone()}
            </h4>
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
                        <div class="card-footer p-2">
                            <h6 class="card-title m-0">
                                <spring:message code="metriginfo.timeLine.h2"/>
                            </h6>
                            <div class="card-body timelinecontener p-0">
                                <ul class="horizontaltimeline" id="horizontaltimeline">
                                    <c:forEach var="i" begin="0" end="8" step="1" >
                                        <jsp:useBean id="dateValue" class="java.util.Date"/>
                                        <jsp:setProperty name="dateValue" property="time" value="${(Date.getTime()+(3600000*(i-4) ))}"/>
                                        <a href="${cp}/metriq/${metric.sha256Code()}/<fmt:formatNumber type="number" groupingUsed="FALSE" maxFractionDigits="0" value="${dateValue.getTime()/1000}" />">
                                            <li class="li complete">
                                                <div class="timestamp">                                    
                                                    <span class="date">${i-4}</span>
                                                </div>
                                                <div class="status"> 
                                                    <h5><fmt:formatDate value="${dateValue}" pattern="HH:mm" timeZone="${curentuser.getTimezone()}"/></h5>
                                                </div>
                                            </li>
                                        </a>
                                    </c:forEach>   
                                </ul> 
                            </div>

                        </div>
                    </div>                        
                </div>
                <c:if test="${metric.getType()!=OddeeyMetricTypesEnum.SPECIAL}">          
                    <div class="col-6">
                        <div class="card shadow">
                                <div class="card-header">
                                    <h6 class="card-title">
                                      <spring:message code="metriginfo.metric.h2" arguments="${metric.getName()}"/>    
                                    </h6> 
                                </div>
                                <div class="card-body table-responsive p-2">                                
                                    <table class="table table-striped table-bordered dataTable no-footer metrictable" role="grid" aria-describedby="datatable-fixed-header_info">
                                        <thead>
                                            <tr>                                                        
                                                <th><spring:message code="metriginfo.date"/></th>
                                                <th><spring:message code="metriginfo.average"/></th>
                                                <th><spring:message code="metriginfo.deviation"/></th>
                                                <th><spring:message code="metriginfo.minimum"/></th>
                                                <th><spring:message code="metriginfo.maximum"/></th>
                                            </tr>
                                        </thead>                        
                                        <c:forEach items="${Rules}" var="rule" varStatus="loop">                            
                                            <tr>                                
                                                <td class="time" value ="<fmt:formatDate timeZone="UTC" type="both" pattern="Y/M/d" value="${rule.getValue().getTime().getTime()}"/>"><fmt:formatDate timeZone="${curentuser.getTimezone()}" type="both" pattern="HH:00 Y/MM/dd" value="${rule.getValue().getTime().getTime()}"/> ${curentuser.getTimezone()} </td>                                
                                                <td value ="${rule.getValue().getAvg()}"><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getAvg()}"/> </td>
                                                <td value ="${rule.getValue().getDev()}"><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getDev()}"/> </td>
                                                <td value ="${rule.getValue().getMin()}"><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getMin()}"/> </td>
                                                <td value ="${rule.getValue().getMax()}"><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getMax()}"/> </td>                                
                                            </tr>
                                        </c:forEach>
                                    </table>
                                </div>
                        </div>
                    </div> 
                </c:if>
                <c:if test="${metric.getType()!=OddeeyMetricTypesEnum.SPECIAL}">
                    <div class="col-12 pl-0 mt-3">
                        <div class="card shadow">
                            <div class="card-header">
                                <h6 class="card-title">
                                    <spring:message code="metriginfo.graphicAnalysis.h2"/>   
                                </h6>
                            </div>                            
                            <div class="card-body table-responsive">
                                <!-- <canvas id="lineChart"></canvas> -->
                                <div id="echart_line" style="height:600px;"></div>
                            </div>                        
                        </div>
                    </div>
                </c:if>         
            </div> 
        </div>  
    </div>   
</div> 
