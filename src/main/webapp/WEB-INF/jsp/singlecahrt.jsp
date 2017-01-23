<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="">
    <div class="row">
        <div class="col-md-12">
            <div class="x_title">
                <h1> ${metric.getDisplayName()}</h1>
            </div>
            <div class="x_panel">
                <div class="col-md-2 col-sm-2 col-xs-4">
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
                <div class="col-md-2 col-sm-2 col-xs-4">            
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


            </div>
            <div class="x_panel">
                <div class="x_title">
                    <h2><i class="fa fa-area-chart"></i> Chart </h2>        
                    <div class="filter">
                        <div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
                            <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
                            <span></span> <b class="caret"></b>
                        </div>
                    </div>                    
                    <div class="clearfix"></div>
                </div>                                                
                <div class="x_content">
                    <div id="echart_line" style="height:600px;"></div>
                </div> 
            </div>            


        </div>
    </div>
</div>

