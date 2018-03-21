<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css?v=${version}" rel="stylesheet">
<div class="page-title">
    <div class="title_right">
        <h3>Event by "${Error.getName()} at <fmt:formatDate timeZone="${curentuser.getTimezone()}" value="${Error.getDate()}" pattern="Y/M/d HH:mm:ss" /> ${curentuser.getTimezone()}" detail</h3>
    </div>
</div>

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <div class="x_panel">
            <div class="x_title">
                <h2>Metric: ${Error.getName()} Info</h2>
                <div class="clearfix"></div>               
            </div>
            <div class="col-md-4 col-sm-4 col-xs-6">            
                <div class="x_content "> 
                    <div class="x_title">
                        <h2><i class="fa fa-asterisk"></i> Tags</h2>                                         
                        <div class="clearfix"></div>
                    </div>                
                    <ul class="">
                        <c:forEach items="${Error.getTags()}" var="Tag" varStatus="loop">
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
            <div class="col-md-4 col-sm-4 col-xs-6">            
                <div class="x_content "> 
                    <div class="x_title">
                        <h2><i class="fa fa-weibo"></i> Info</h2>                                         
                        <div class="clearfix"></div>
                    </div>                
                    <ul class="">
                        <li>
                            <span class="name"> Value </span>
                            <span class="value text-success"> <fmt:formatNumber type="number" maxFractionDigits="3" value="${Error.getValue()}" /></span>
                        </li>
                        <li>
                            <span class="name"> Weight </span>
                            <span class="value text-success"> ${Error.getWeight()}</span>
                        </li>
                        <li>
                            <span class="name"> Deviation % </span>
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
                            <span class="name"> Time </span>
                            <span class="value text-success"><fmt:formatDate timeZone="${curentuser.getTimezone()}" value="${Error.getDate()}" pattern="HH:mm Y/M/d" /> ${curentuser.getTimezone()}</span>
                        </li>                                           
                    </ul>                

                </div>
            </div> 
            <div class="col-md-4 col-sm-4 col-xs-6">            
                <div class="x_content "> 
                    <div class="x_title">
                        <h2><i class="fa fa-line-chart"></i> Regression</h2>     
                        <button class="btn btn-warning pull-right btn-sm noMargin" type="button" value="Default" id="Clear_reg">Clear</button>    
                        <div class="clearfix"></div>
                    </div>                
                    <ul class="">
                        <li>
                            <span class="name"> Predict </span>
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
                            <span class="name">Correlation Coefficient </span>                            
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
                            <span class="name">Slope </span>
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
                            <span class="name">RSquare</span>
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
                            <span class="name">Counts </span>
                            <span class="value text-success">${Error.getRegression().getN()}</span>
                        </li>
                    </ul>   



                </div>
            </div>                         


            <div class="x_title">
                <h2><i class="fa fa-repeat"></i> Recurrence by Weight</h2>                                         
                <div class="clearfix"></div>
            </div>
            <div class="row tile_count">
                <div class="col-md-3 col-sm-6 col-xs-12 tile_stats_count">
                    <span class="count_top"><i class="fa fa-clock-o"></i> Current 1 minute</span>
                    <div class="count spincrement">${Error.getRecurrence1m()} </div>
                    <span class="count_bottom"><i class=" <c:choose><c:when test="${Error.getRecurrence1m() > Error.getRecurrenceLast1m()}">red</c:when><c:otherwise>green</c:otherwise></c:choose>">${Error.getRecurrenceLast1m()} </i> Previous minute</span>
                        </div>
                        <div class="col-md-3 col-sm-6 col-xs-12 tile_stats_count">
                            <span class="count_top"><i class="fa fa-clock-o"></i> Current 10 minutes</span>
                                <div class="count spincrement">${Error.getRecurrence10m()}</div>
                    <span class="count_bottom"><i class=" <c:choose><c:when test="${Error.getRecurrence10m() > Error.getRecurrenceLast10m()}">red</c:when><c:otherwise>green</c:otherwise></c:choose>">${Error.getRecurrenceLast10m()} </i> Previous 10 minutes</span>
                        </div>
                        <div class="col-md-3 col-sm-6 col-xs-12 tile_stats_count">
                            <span class="count_top"><i class="fa fa-clock-o"></i> Current 20 minutes </span>
                                <div class="count green">${Error.getRecurrence20m()}</div>
                    <span class="count_bottom"><i class=" <c:choose><c:when test="${Error.getRecurrence20m() > Error.getRecurrenceLast20m()}">red</c:when><c:otherwise>green</c:otherwise></c:choose>">${Error.getRecurrenceLast20m()} </i> Previous 20 minutes</span>
                        </div>
                        <div class="col-md-3 col-sm-6 col-xs-12 tile_stats_count">
                            <span class="count_top"><i class="fa fa-clock-o"></i>Current 30 minutes</span>
                                <div class="count spincrement">${Error.getRecurrence30m()}</div>
                    <span class="count_bottom"><i class="<c:choose><c:when test="${Error.getRecurrence30m() > Error.getRecurrenceLast30m()}">red</c:when><c:otherwise>green</c:otherwise></c:choose>">${Error.getRecurrenceLast30m()} </i> Previous 30 minutes </span>
                        </div>
                    </div>                        

                </div>
            </div>

            <div class="col-md-6 col-sm-6 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                            <h2>Metric: ${Error.getName()} Rules</h2>
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
    </div>     
</div>
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