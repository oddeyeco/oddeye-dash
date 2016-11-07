<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
<div class="page-title">
    <div class="title_left">
        <h3>User Profile </h3>
    </div>
</div>

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <div class="x_title">
                <h2>Real Time monitor (UUID = ${curentuser.getId().toString()})</h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content"> 
                <c:set var="group_item" value="host" />
                <form class="form-horizontal form-label-left">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Select Group Option</label>
                        <div class="col-md-9 col-sm-9 col-xs-12">
                            <select class="form-control">
                                <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                    <option <c:if test="${group_item == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </form>

                <div class="col-md-12 col-sm-12 col-xs-12 profile_left">
                    <div class="x_content" style="display: block;">

                        <!-- start accordion -->
                        <div class="accordion" id="accordion1" role="tablist" aria-multiselectable="true">

                            <c:set var="MetricsMeta" value="${ErrorsDao.getLast(curentuser)}" />                            
                            <c:forEach items="${MetricsMeta.getTagsList().get(group_item)}" var="showgroup" varStatus="loopgrups">   
                                <c:set var="showgroup_rp" value="${fn:replace(showgroup, '.', '_')}" />

                                <div class="panel">
                                    <a class="panel-heading collapsed" role="tab" id="heading${showgroup_rp}" data-toggle="collapse" data-parent="#accordion1" href="#collapse_${showgroup_rp}" aria-expanded="false" aria-controls="collapseOne">
                                        <h4 class="panel-title">#${loopgrups.index+1} ${group_item} ${showgroup} ${MetricsMeta.getbyTag(group_item,showgroup).size()}</h4>
                                    </a>

                                    <div id="collapse_${showgroup_rp}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading${showgroup_rp}" aria-expanded="false" style="height: 0px;">
                                        <div class="panel-body">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Metric Name</th>
                                                        <th>Level</th>
                                                        <th>Time</th>
                                                    </tr>
                                                </thead>


                                                <c:forEach items="${MetricsMeta.getbyTag(group_item,showgroup)}" var="metric" varStatus="loop">

                                                    <c:set value="${metric.getValue() < 0 ? -metric.getValue():metric.getValue()}" var="val" />
                                                    <c:if test="${val > 0}"> 
                                                        <tr name="${metric.getName()}" class="metricrow" filter="${metric.getFullFilter()}">
                                                            <th scope="row">${loop.index+1}</th>
                                                            <td>${metric.getName()}</td>
                                                            <td>                                                               
                                                                <div class="progress ${metric.getValue() < 0 ? "right":""}" style="margin-bottom: 0px">                                                                    
                                                                    <div class="progress-bar<c:choose>
                                                                             <c:when test="${metric.getValuePersent() < 50}">
                                                                                 progress-bar-info
                                                                             </c:when>    
                                                                             <c:when test="${metric.getValuePersent() < 80}">
                                                                                 progress-bar-warning
                                                                             </c:when>                                                                             
                                                                             <c:otherwise>
                                                                                 progress-bar-danger
                                                                             </c:otherwise>
                                                                         </c:choose>                                                                         

                                                                         " value="${val}" data-transitiongoal="${metric.getValuePersent()}" aria-valuenow="${metric.getValuePersent()}" style="width: 100%;">${metric.getValue()}</div>
                                                                </div></td>
                                                            <td class="time">${metric.getTimestamp()}</td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>

                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>                            
                        </div>
                        <!-- end of accordion -->


                    </div>
                </div>                        

            </div>
        </div>
    </div>
</div>

<!-- /page content -->
