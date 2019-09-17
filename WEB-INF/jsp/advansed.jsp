<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css?v=${version}" rel="stylesheet">

<div class="row">
    <div class="col-12">
        <div class="card shadow">
            <h4 class="card-header">
                <spring:message code="advansed.detailedEvents" arguments="${Error.getName()}"/> <fmt:formatDate timeZone="${curentuser.getTimezone()}" value="${Error.getDate()}" pattern="Y/M/d HH:mm:ss" /> ${curentuser.getTimezone()}
            </h4>
            <div class="card-body row advansed">
                <div class="col-6">
                    <div class="card row shadow">
                        <div class="col-12">
                            <div class="card-header row">                               
                                <h6 class="card-title">
                                    <spring:message code="advansed.metricInfo" arguments="${Error.getName()}"/>
                                </h6>
                            </div>
                            <div class="card-header row">
                                <div class="col-4">
                                    <h6 class="card-title">
                                        <i class="fa fa-asterisk"></i> <spring:message code="tags"/> 
                                    </h6> 
                                </div>
                                <div class="col-4">
                                    <h6 class="card-title">
                                        <i class="fa fas fa-info"></i> <spring:message code="info"/>
                                    </h6>
                                </div> 
                                <div class="col-4">
                                    <h6 class="card-title">
                                        <i class="fa fas fa-chart-line"></i> <spring:message code="regression.h2"/>
                                        <button class="btn btn-outline-warning float-right btn-sm noMargin" type="button" value="Default" id="Clear_reg"><spring:message code="clear"/></button>
                                    </h6>
                                </div> 
                            </div>
                            <div class="card-body row p-1">
                                <div class="col-4">
                                    <ul class="font16">
                                        <c:forEach items="${Error.getTags()}" var="Tag" varStatus="loop">
                                            <c:if test="${Tag.getKey() != \"UUID\"}">
                                                <li>
                                                    <span class="name"> ${Tag.getKey()}:&#8194; </span>
                                                    <span class="value text-success"> ${Tag.getValue()}</span>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <div class="col-4">
                                    <ul class="font16">
                                        <li>
                                            <span class="name"> <spring:message code="errorsanalysis.value"/>:&#8194; </span>
                                            <span class="value text-success"> <fmt:formatNumber type="number" maxFractionDigits="3" value="${Error.getValue()}" /></span>
                                        </li>
                                        <li>
                                            <span class="name"> <spring:message code="errorsanalysis.weight"/>:&#8194; </span>
                                            <span class="value text-success"> ${Error.getWeight()}</span>
                                        </li>
                                        <li>
                                            <span class="name"> <spring:message code="errorsanalysis.deviation"/>:&#8194; </span>
                                            <span class="value text-success"> 
                                                <c:choose>
                                                    <c:when test="${Error.getPersent_weight() == Double.NaN}">
                                                        NaN                                    
                                                    </c:when>  
                                                    <c:otherwise>
                                                        <fmt:formatNumber type="number" maxFractionDigits="3" value="${Error.getPersent_weight()}" />                                     
                                                    </c:otherwise>  
                                                </c:choose>
                                            </span>
                                        </li>
                                        <li>
                                            <span class="name"> <spring:message code="errorsanalysis.time"/>:&#8194; </span>
                                            <span class="value text-success"><fmt:formatDate timeZone="${curentuser.getTimezone()}" value="${Error.getDate()}" pattern="HH:mm Y/M/d" /> ${curentuser.getTimezone()}</span>
                                        </li> 
                                    </ul>
                                </div>
                                <div class="col-4">
                                        <ul class="font16">                                                 
                                            <li>
                                                <span class="name"> <spring:message code="regression.predictDeviation"/>:&#8194; </span>
                                                <span class="value text-success">
                                                    <c:choose>
                                                        <c:when test="${Error.getRegression().predict(Error.getTimestamp()) == Double.NaN}">
                                                            ${Error.getRegression().predict(Error.getTimestamp())}
                                                            <br />
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${Error.getRegression().predict(Error.getTimestamp())}" />
                                                            <br />
                                                        </c:otherwise>
                                                    </c:choose>                                
                                                    <%--<fmt:formatNumber type="number" maxFractionDigits="3" value="${Error.getRegression().predict(Error.getTimestamp()*1000)}" />--%>  
                                                </span>
                                            </li>                                                  
                                            <li>
                                                <span class="name"> <spring:message code="regression.correlationCoefficient"/>:&#8194; </span>                            
                                                <span class="value text-success">
                                                    <c:choose>
                                                        <c:when test="${Error.getRegression().getR() == Double.NaN}">
                                                            ${Error.getRegression().getR()}
                                                            <br />
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${Error.getRegression().getR()}" />
                                                            <br />
                                                        </c:otherwise>
                                                    </c:choose>                                
                                                </span>                            
                                            </li>
                                            <li>
                                                <span class="name"> <spring:message code="regression.slope"/>:&#8194; </span>
                                                <span class="value text-success">                                        
                                                    <c:choose>
                                                        <c:when test="${Error.getRegression().getSlope() == Double.NaN}">
                                                            ${Error.getRegression().getSlope()}
                                                            <br />
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${Error.getRegression().getSlope()}" />
                                                            <br />                                                
                                                        </c:otherwise>
                                                    </c:choose>                                                                
                                                </span> 
                                            </li>                         

                                            <li>
                                                <span class="name"> <spring:message code="regression.rSquare"/>:&#8194; </span>
                                                <span class="value text-success">
                                                    <c:choose>
                                                        <c:when test="${Error.getRegression().getRSquare() == Double.NaN}">
                                                            ${Error.getRegression().getRSquare()}
                                                            <br />
                                                        </c:when>    
                                                        <c:otherwise>
                                                            <fmt:formatNumber type="number" maxFractionDigits="5" value=" ${Error.getRegression().getRSquare()}" />
                                                            <br />
                                                        </c:otherwise>
                                                    </c:choose>                                
                                                </span>
                                            </li>
                                            <li>
                                                <span class="name"> <spring:message code="regression.counts"/>:&#8194; </span>
                                                <span class="value text-success">${Error.getRegression().getN()}</span>
                                            </li>
                                        </ul>
                                    </div>
                                
                            </div>
                        </div> 
                        <div class="card-footer depthShadowLightHover p-2">                           
                           <div class="col"> 
                               <h6 class="card-title m-0">
                                   <i class="fas fa-redo-alt"></i> <spring:message code="advansed.recurrenceWeight"/>
                               </h6>
                            </div> 
                            <div class="card-body row justify-content-md-center justify-content-lg-start tile_count p-1">
                                    <div class="col tile_stats_count">
                                        <span class="count_top"><i class="fa far fa-clock"></i>
                                            <spring:message code="advansed.currentMinute1"/>
                                        </span>
                                        <div class="count spincrement"> ${Error.getRecurrence1m()} </div>
                                        <span class="count_bottom">
                                            <span class=" <c:choose><c:when test="${Error.getRecurrence1m() > Error.getRecurrenceLast1m()}">badge badge-danger</c:when><c:otherwise>badge badge-success</c:otherwise></c:choose>"> ${Error.getRecurrenceLast1m()} </span>
                                            <spring:message code="advansed.previousMinute1"/>
                                        </span>
                                    </div>
                                    <div class="col tile_stats_count">
                                        <span class="count_top"><i class="fa far fa-clock"></i>
                                            <spring:message code="advansed.currentMinute10"/></span>
                                        <div class="count spincrement">${Error.getRecurrence10m()}</div>
                                        <span class="count_bottom">
                                            <span class=" <c:choose><c:when test="${Error.getRecurrence10m() > Error.getRecurrenceLast10m()}">badge badge-danger</c:when><c:otherwise>badge badge-success</c:otherwise></c:choose>"> ${Error.getRecurrenceLast10m()} </span>
                                            <spring:message code="advansed.previousMinute10"/>
                                        </span>
                                    </div>
                                    <div class="col tile_stats_count">
                                        <span class="count_top"><i class="fa far fa-clock"></i>
                                            <spring:message code="advansed.currentMinute20"/></span>
                                        <div class="count spincrement">${Error.getRecurrence20m()}</div>
                                        <span class="count_bottom">
                                            <span class=" <c:choose><c:when test="${Error.getRecurrence20m() > Error.getRecurrenceLast20m()}">badge badge-danger</c:when><c:otherwise>badge badge-success</c:otherwise></c:choose>"> ${Error.getRecurrenceLast20m()} </span>
                                            <spring:message code="advansed.previousMinute20"/>
                                        </span>
                                    </div>
                                    <div class="col tile_stats_count">
                                        <span class="count_top"><i class="fa far fa-clock"></i>
                                            <spring:message code="advansed.currentMinute30"/></span>
                                        <div class="count spincrement">${Error.getRecurrence30m()}</div>
                                        <span class="count_bottom">
                                            <span class=" <c:choose><c:when test="${Error.getRecurrence30m() > Error.getRecurrenceLast30m()}">badge badge-danger</c:when><c:otherwise>badge badge-success</c:otherwise></c:choose>"> ${Error.getRecurrenceLast30m()} </span>
                                            <spring:message code="advansed.previousMinute30"/>
                                        </span>
                                    </div>                        
                            </div>
                        </div>
                    </div>                        
                </div>
                <div class="col-md-6 col-lg-6 col-12">
                    <div class="card shadow">
                        <div class="card-header">
                            <h6 class="card-title">
                                <spring:message code="advansed.metricRules.h2" arguments="${Error.getName()}"/>  
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
                                    <td><fmt:formatDate type="both" pattern="H:00 Y/M/d" value="${rule.getValue().getTime().getTime()}" timeZone="${curentuser.getTimezone()}" /> ${curentuser.getTimezone()}</td>                                
                                    <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getAvg()}"/> </td>
                                    <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getDev()}"/> </td>
                                    <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getMin()}"/> </td>
                                    <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${rule.getValue().getMax()}"/> </td>                                
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                    </div>
                </div> 
                    <div class="col-12 pl-0 mt-3">
                        <div class="card shadow">
                            <div class="card-header">
                                <h6 class="card-title">
                                    <spring:message code="metriginfo.graphicAnalysis.h2"/>   
                                </h6>
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
