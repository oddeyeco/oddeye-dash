<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="">
    <div class="row">

        <div class="x_title">
            <h1> ${metric.getDisplayName()} : ${metric.getTypeName()} </h1>
        </div>
        <div class="col-sm-6 col-xs-12">
            <div class="x_panel">
                <div class="col-sm-4 col-xs-6">
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
                    <div class="col-sm-4 col-xs-6">            
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
                                    <span class="name">SSE</span>
                                    <span class="value text-success">
                                        <c:choose>
                                            <c:when test="${metric.getRegression().getSumSquaredErrors() == Double.NaN}">
                                                ${metric.getRegression().getSumSquaredErrors()}
                                                <br />
                                            </c:when>    
                                            <c:otherwise>
                                                <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${metric.getRegression().getSumSquaredErrors()}" />
                                                <br />
                                            </c:otherwise>
                                        </c:choose>                                                                
                                    </span>
                                </li>                         

                                <li>
                                    <span class="name">Significance</span>
                                    <span class="value text-success">
                                        <c:choose>
                                            <c:when test="${metric.getRegression().getSignificance() == Double.NaN}">
                                                ${metric.getRegression().getSignificance()}
                                                <br />
                                            </c:when>    
                                            <c:otherwise>
                                                <fmt:formatNumber type="number" maxFractionDigits="3" value=" ${metric.getRegression().getSignificance()}" />
                                                <br />
                                            </c:otherwise>
                                        </c:choose>                                
                                    </span>
                                </li>
                                <li>
                                    <span class="name">Counts</span>
                                    <span class="value text-success">${metric.getRegression().getN()}</span>
                                </li>
                            </ul>   
                        </div>
                    </div> 
                </c:if>
            </div>         
        </div>

        <c:if test="${metric.getType()!=0}">
            <div class="col-sm-6 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2>Metric: ${metric.getName()} Rules</h2>
                        <div class="clearfix"></div>               
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12">     
                        <div class="x_content ">                
                            <table class="table table-striped table-bordered dataTable no-footer metrictable" role="grid" aria-describedby="datatable-fixed-header_info">
                                <thead>
                                    <tr>                                                        
                                        <th>Date</th>
                                        <th>Average</th>
                                        <th>Deviation</th>
                                        <th>Minimum</th>
                                        <th>Maximum</th>
                                    </tr>
                                </thead>                        
                                <c:forEach items="${Rules}" var="rule" varStatus="loop">                            
                                    <tr>                                
                                        <td class="time" value ="<fmt:formatDate type="both" pattern="Y/M/d" value="${rule.getValue().getTime().getTime()}"/>"><fmt:formatDate type="both" pattern="HH:00 Y/M/d" value="${rule.getValue().getTime().getTime()}"/> </td>                                
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
    <c:if test="${metric.getType()!=0}">
        <div class="row">
            <div class="col-md-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2>Graphic Analysis</h2>
                        <div class="clearfix"></div>                
                    </div>
                    <div class="x_content">
                        <!--<canvas id="lineChart"></canvas>-->
                        <div id="echart_line" style="height:600px;"></div>
                    </div>                    
                </div>
            </div>
        </div>     
    </c:if>
</div>

