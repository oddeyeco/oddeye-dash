<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
<div class="page-title">
    <div class="title_left">
        <h3>Alert Information </h3>
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
            <div class="col-md-6 col-sm-6 col-xs-6">            
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
            <div class="col-md-6 col-sm-6 col-xs-6">            
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
                            <span class="value text-success"> ${Error.getPersent_weight()}</span>
                        </li>
                        <li>
                            <span class="name"> Time </span>
                            <span class="value text-success">${Error.getTimestamp()} </span>
                        </li>                                           
                    </ul>                

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
                                <td><fmt:formatDate type="both" pattern="H:00 Y/M/d" value="${rule.getValue().getTime().getTime()}"/> </td>                                
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
                ${chartdata.size()}

            </div>
            <div class="x_content">
                <canvas id="lineChart"></canvas>
            </div>                    
        </div>
    </div>
</div>                