<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
                  
<div class="row">
    <div class="col-12">
        <div class="card shadow">
            <h4 class="card-header">
                    <spring:message code="singlechart.chartFor.h1" arguments="${cp},${metric.sha256Code()},${metric.getDisplayName()},${metric.getTypeName()}"/>
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
                                                    <span class="name"> ${Tag.getKey()}: </span>
                                                    <span class="value text-success"> &#8194; ${Tag.getValue()}</span>
                                                </li>
                                            </c:if>    
                                        </c:forEach>
                                    </ul>
                                </div>
                                
                                    <div class="col-6">
                                        <ul class="font16">                                                 
                                            <li>
                                                <span class="name"><spring:message code="regression.correlationCoefficient"/>: </span>                            
                                                <span class="value text-success">&#8194;
                                                    <c:choose>
                                                        <c:when test="${metric.getRegression().getR() == Double.NaN}">
                                                            ${metric.getRegression().getR()}
                                                            <br/>
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${metric.getRegression().getR()}" />
                                                            <br/>
                                                        </c:otherwise>
                                                    </c:choose>                                
                                                </span>                            
                                            </li>
                                            <li>
                                                <span class="name"><spring:message code="regression.slope"/>: </span>
                                                <span class="value text-success">&#8194;                                        
                                                    <c:choose>
                                                        <c:when test="${metric.getRegression().getSlope() == Double.NaN}">
                                                            ${metric.getRegression().getSlope()}
                                                            <br/>
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${metric.getRegression().getSlope()}" />
                                                            <br/>                                                
                                                        </c:otherwise>
                                                    </c:choose>                                                                
                                                </span>                                                                       
                                            </li> 
                                            <li>
                                                <span class="name"><spring:message code="regression.rSquare"/>: </span>
                                                <span class="value text-success">&#8194;
                                                    <c:choose>
                                                        <c:when test="${metric.getRegression().getRSquare() == Double.NaN}">
                                                            ${metric.getRegression().getRSquare()}
                                                            <br/>
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="5" value=" ${metric.getRegression().getRSquare()}" />
                                                            <br/>
                                                        </c:otherwise>
                                                    </c:choose>                                
                                                </span>
                                            </li>
                                            <li>
                                                <span class="name"><spring:message code="regression.counts"/>: </span>
                                                <span class="value text-success">&#8194;${metric.getRegression().getN()}</span>
                                            </li>
                                        </ul>
                                    </div>
                                
                            </div>
                        </div>
                    </div>                        
                </div>
                    <div class="col-12 p-0 mt-3">
                        <div class="card shadow">
                            <div class="card-header">
                                <h6 class="card-title float-left">
                                    <i class="fa fas fa-chart-area"></i> <spring:message code="chart.h2"/></h2>  
                                </h6>
                                <div class="float-right filter">
                                    <div id="reportrange" class="rounded-top dropdown-toggle reportrange" >
                                        <i class="fa fa-calendar pr-1"></i>
                                        <span></span>
                                    </div>
                                </div>
                            </div>                            
                            <div class="card-body table-responsive">
                                <div id="echart_line" style="height:600px;"></div>
                            </div>                        
                        </div>
                    </div>        
            </div> 
        </div>  
    </div>   
</div> 

