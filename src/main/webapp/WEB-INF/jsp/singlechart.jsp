<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="">
    <div class="row">
        <div class="col-xs-12">
            <div class="x_title">
                <h1><spring:message code="singlechart.chartFor.h1" arguments="${cp},${metric.hashCode()},${metric.getDisplayName()},${metric.getTypeName()}"/></h1>
            </div>
            <div class="x_panel">
                <div class="col-md-3 col-sm-6 col-xs-12">
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
                <div class="col-md-3 col-sm-6 col-xs-12">        
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
                                <span class="name"><spring:message code="regression.rSquare"/></span>
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


            </div>
            <div class="x_panel">
                <div class="x_title">
                    <h2><i class="fa fas fa-chart-area"></i> <spring:message code="chart.h2"/></h2>        
                    <div class="filter">
                        <div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
                            <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
                            <span></span> <b class="caret"></b>
                        </div>
                    </div>                    
                    <div class="clearfix"></div>
                </div>                                                
                <div class="x_content table-responsive">
                    <div id="echart_line" style="height:600px;"></div>
                </div> 
            </div>            


        </div>
    </div>
</div>

