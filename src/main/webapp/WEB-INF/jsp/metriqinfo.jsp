<%-- 
    Document   : metriqinfo
    Created on : Dec 5, 2016, 2:38:33 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="page-title">
    <div class="title_left">
        <h3>Metriq Info </h3>
    </div>
</div>

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <div class="x_title">
                <h2>Metriq: ${metriq.getName()}, Tags: ${metriq.getTags()}</h2>
                <div class="clearfix"></div>

                <table class="table table-striped table-bordered dataTable no-footer metrictable" role="grid" aria-describedby="datatable-fixed-header_info">
                    <thead>
                        <tr>
                            <th>#</th>                            
                            <th>Value</th>
                            <th>Weight</th>
                            <th>Deviation %</th>
                            <th>Predict Deviation %</th>                            
                            <th>Level</th>
                            <th>Time</th>
                        </tr>
                    </thead>

                    <tbody>
                    <c:set value="1" var="loopindex" />
                    <c:forEach items="${ErrorList}" var="metric" varStatus="loop">
                        <th scope="row">${loop.index}</th>                        
                        <td class="value"><fmt:formatNumber type="number" maxFractionDigits="3" value="${metric.getValue()}" /></td>
                        <td class="weight">${metric.getWeight()}</td>
                        <td class="persent">${metric.getPersent_weight()}</td>
                        <td class="persent">${metric.getPersent_predict()}</td>                        
                        <td class="level_${curentuser.getAlertLevels().getErrorLevel(metric)}">${curentuser.getAlertLevels().getName(curentuser.getAlertLevels().getErrorLevel(metric))}</td>                        
                        <td class="time">${metric.getTimestamp()}</td>
                        <td class=""> ${metric.getTimestamp()-lasttime}</td>
                        
                        <c:set value="${metric.getTimestamp()}" var="lasttime" />
                        </tr>

                    </c:forEach>
                    </tbody>
                </table>                

            </div>
        </div>
    </div>
</div>

