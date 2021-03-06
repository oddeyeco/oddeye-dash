<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="co.oddeye.core.OddeeyMetricTypesEnum" %>
<div class="">
    <div class="row">

        <div class="x_title">            
            <h1><spring:message code="metriginfo.metric.h1" arguments="${cp},${metric.sha256Code()},${metric.getName()}"/> <fmt:formatDate type="both" pattern="HH:00 Y/MM/dd" value="${Date}" timeZone="${curentuser.getTimezone()}"/> ${curentuser.getTimezone()}</h1>
        </div>
        <div class="col-lg-6 col-md-12 col-sm-12">
            <div class="x_panel">
                <div class="col-sm-6 col-xs-12">
                    <div class="x_content "> 
                        <div class="x_title">
                            <h2><i class="fa fa-asterisk"></i> <spring:message code="tags"/></h2>                                         
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

                <c:if test="${metric.getType()!=OddeeyMetricTypesEnum.SPECIAL}">
                    <div class="col-sm-6 col-xs-12">            
                        <div class="x_content "> 
                            <div class="x_title">
                                <h2><i class="fa fas fa-chart-line"></i> <spring:message code="regression.h2"/></h2>     
                                <button class="btn btn-warning pull-right btn-sm noMargin" type="button" value="Default" id="Clear_reg"><spring:message code="clear"/></button>    
                                <div class="clearfix"></div>
                            </div>                
                            <ul class="">                                                 
                                <li>
                                    <span class="name"><spring:message code="regression.correlationCoefficient"/> </span>                            
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
                                    <span class="name"><spring:message code="regression.slope"/> </span>
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
                                    <span class="name"><spring:message code="regression.rSquare"/> </span>
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
                                    <span class="name"><spring:message code="regression.counts"/> </span>
                                    <span class="value text-success">${metric.getRegression().getN()}</span>
                                </li>
                            </ul>   
                        </div>
                    </div> 
                </c:if>
                <div class="x_content timelinecontener"> 
                    <div class="x_title">
                        <h2><spring:message code="metriginfo.timeLine.h2"/></h2>  
                        <div class="clearfix"></div>
                    </div>                        
                    <ul class="horizontaltimeline" id="horizontaltimeline">
                        <c:forEach var="i" begin="0" end="8" step="1" >
                            <jsp:useBean id="dateValue" class="java.util.Date"/>
                            <jsp:setProperty name="dateValue" property="time" value="${(Date.getTime()+(3600000*(i-4) ))}"/>
                            <a href="${cp}/metriq/${metric.sha256Code()}/<fmt:formatNumber type="number" groupingUsed="FALSE" maxFractionDigits="0" value="${dateValue.getTime()/1000}" />"><li class="li complete">
                                    <div class="timestamp">                                    
                                        <span class="date">${i-4}</span>
                                    </div>
                                    <div class="status"> 
                                        <h4><fmt:formatDate value="${dateValue}" pattern="HH:mm" timeZone="${curentuser.getTimezone()}"/></h4>
                                    </div>
                                </li>
                            </a>
                        </c:forEach>   
                    </ul>
                </div>                
            </div>    




        </div>
        <c:if test="${metric.getType()!=OddeeyMetricTypesEnum.SPECIAL}">
            <div class="col-lg-6 col-md-12 col-sm-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><spring:message code="metriginfo.metric.h2" arguments="${metric.getName()}"/> </h2>
                        <div class="clearfix"></div>               
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12">     
                        <div class="x_content table-responsive">                
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
            </div>   
        </c:if>
    </div>
    <c:if test="${metric.getType()!=OddeeyMetricTypesEnum.SPECIAL}">
        <div class="row">
            <div class="col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><spring:message code="metriginfo.graphicAnalysis.h2"/></h2>
                        <div class="clearfix"></div>                
                    </div>
                    <div class="x_content table-responsive">
                        <!--<canvas id="lineChart"></canvas>-->
                        <div id="echart_line" style="height:600px;"></div>
                    </div>                    
                </div>
            </div>
        </div>     
    </c:if>
</div>

