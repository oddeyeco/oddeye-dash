<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!--<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css?v=${version}" rel="stylesheet">-->
<link href="${cp}/resources/dataTablesBS4/css/dataTables.bootstrap4.min.css?v=${version}" rel="stylesheet">

<div class="row"> 
    <div class="col-12">
        <div class="card shadow">
            <h5 class="card-header"><spring:message code="errorsanalysis.advancedAnalytic.h2"/></h5>
            <div class="card-body row">
                 <%--<c:set var="group_item" value="host" />--%> 
                <div class="col-lg-2 col-md-12 col-12 profile_left">
                    <h6><spring:message code="filter"/></h6>
                    <form class="form-row p-3 depthShadowLightHover">
                        <div class="form-group col-12 detailedFilter">
                            <label class="col-form-label"><spring:message code="errorsanalysis.group"/></label>
                            <div class="custom-select">
                            <select class="form-control" name="group_item">
                                <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                    <option <c:if test="${group_item == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                </c:forEach>
                            </select> 
                            </div>                            
                        </div>                        
                        <div class="form-group col-12 detailedFilter">
                            <label class="col-form-label"><spring:message code="errorsanalysis.showTag"/></label>
                            <div class="custom-select">
                            <select class="form-control" name="ident_tag">
                                <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                    <option <c:if test="${ident_tag == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                </c:forEach>
                            </select>
                            
                        </div>
                        </div>
                        <div class="form-group col-12 detailedFilter">
                            <label class="col-form-label"><spring:message code="level"/></label>
                            <div class="custom-select">
                            <select class="form-control" name="level" id="level">
                                <option <c:if test="${level_item == -1}"> selected="true" </c:if> value="-1" > <spring:message code="errorsanalysis.custom"/> </option> 
                                <c:forEach items="${curentuser.getAlertLevels()}" var="level">                                   
                                    <option <c:if test="${level_item == level.key}"> selected="true" </c:if>  value="${level.key}"><spring:message code="level_${level.key}"/> </option>
                                </c:forEach>                                 
                            </select>
                                
                        </div>
                        </div>
                        <div class="form-group col-12 customvalue detailedFilter" <c:if test="${level_item != -1}"> style="display: none"</c:if>>
                            <label class="col-form-label"><spring:message code="minValue"/></label>                          
                            <input class="form-control" value="${minValue}" name="minValue"></input>                           
                        </div>
                        <div class="form-group col-12 customvalue detailedFilter" <c:if test="${level_item != -1}"> style="display: none"</c:if>>
                            <label class="col-form-label"><spring:message code="minPercent"/></label>                            
                            <input class="form-control" value="${minPersent}" name="minPersent"></input>                         
                        </div>
                        <div class="form-group col-12 customvalue detailedFilter" <c:if test="${level_item != -1}"> style="display: none"</c:if>>
                            <label class="col-form-label"><spring:message code="minPredictPercent"/></label>                           
                            <input class="form-control" value="${minPredictPersent}" name="minPredictPersent"></input>                           
                        </div>
                        <div class="form-group col-12 customvalue detailedFilter" <c:if test="${level_item != -1}"> style="display: none"</c:if>>
                            <label class="col-form-label"><spring:message code="minWeight"/></label>                            
                            <input class="form-control" value="${minWeight}" name="minWeight"></input>                            
                        </div>
                        <div class="form-group col-12 customvalue detailedFilter" <c:if test="${level_item != -1}"> style="display: none"</c:if>>
                            <label class="col-form-label"><spring:message code="minRecurrenceCount"/></label>                           
                            <input class="form-control" value="${minRecurrenceCount}" name="minRecurrenceCount"></input>                            
                        </div>
                        <div class="form-group col-12 detailedFilter">
                            <label class="col-form-label"><spring:message code="errorsanalysis.custom.timeInterval"/></label>                           
                            <input class="form-control" value="${minRecurrenceTimeInterval}" name="minRecurrenceTimeInterval"></input>                           
                        </div> 
                        <div class="form-group col-12">                        
                        <div class="float-right mt-1">                                
                            <button class="btn btn-outline-primary" type="submit" value="Submit"><spring:message code="submit"/></button>
                        </div>
                    </div>
                    </form>
                    
                </div>
                <div class="col-lg-8 offset-lg-1 col-md-12 col-12 profile_left depthShadowLight">
                    <div class="x_content mt-3" style="display: block;">
                        <!--   start accordion -->
                        <div class="accordion" id="accordion1" role="tablist" aria-multiselectable="true">                            
                            <c:set var="MetricsMeta" value="${ErrorsDao.getLast(curentuser,minValue,minPersent,minWeight,minRecurrenceCount,minRecurrenceTimeInterval,minPredictPersent)}" />                            
                            <c:forEach items="${MetricsMeta.getTagsList().get(group_item)}" var="showgroupmap" varStatus="loopgrups">   
                                <c:set var="showgroup" value="${showgroupmap.getKey()}" />
                                <c:set var="showgroup_rp" value="${fn:replace(showgroup, '.', '_')}" />                                
                            <div class="card shadow mb-1">                                               
                                <a class="card-header panel-heading collapsed p-2" role="tab" id="heading${showgroup_rp}" data-toggle="collapse" data-parent="#accordion1" href="#collapse_${showgroup_rp}" aria-expanded="false" aria-controls="collapseOne">
                                    <div class="panel-title">
                                        <b>#${loopgrups.index+1} ${group_item} ${showgroup} ${MetricsMeta.getbyTag(group_item,showgroup).size()} of ${curentuser.getMetricsMeta().getbyTag(group_item,showgroup).size()}</b>
                                        <div class="progress">
                                             <c:set var="metricpercent" value="${MetricsMeta.getbyTag(group_item,showgroup).size()*100/curentuser.getMetricsMeta().getbyTag(group_item,showgroup).size()}" />
                                            <div class="progress-bar bg-info" data-transitiongoal="${metricpercent}" aria-valuenow="${metricpercent}" style="width: ${metricpercent}%;"></div>                                                                   
                                        </div>
                                    </div>
                                </a>                                                    
                                <div class="card-body panel-collapse collapse p-1" id="collapse_${showgroup_rp}" role="tabpanel" aria-labelledby="heading${showgroup_rp}" aria-expanded="true">                                                         
                                    <div class="panel-body table-responsive">
                                        <table class="table table-sm table-striped table-bordered metrictable" role="grid" aria-describedby="datatable-fixed-header_info">
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th><spring:message code="metricName"/></th>
                                                    <th>${ident_tag} </th>
                                                    <th><spring:message code="errorsanalysis.value"/></th>
                                                    <th><spring:message code="errorsanalysis.weight"/></th>
                                                    <th><spring:message code="errorsanalysis.deviation"/></th>
                                                    <th><spring:message code="errorsanalysis.predictDeviation"/></th>
                                                    <th><spring:message code="errorsanalysis.recurrence"/></th>
                                                    <th><spring:message code="level"/></th>
                                                    <th><spring:message code="errorsanalysis.time"/></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set value="1" var="loopindex" />
                                                <c:forEach items="${MetricsMeta.getbyTag(group_item,showgroup)}" var="metricentry" varStatus="loop">
                                                    <c:set var="metric" value="${metricentry.getValue()}" />
                                                    <c:set value="${metric.getValue() < 0 ? -metric.getValue():metric.getValue()}" var="val" />
                                                    <c:set value="${metric.getWeight() < 0 ? -metric.getWeight():metric.getWeight()}" var="weight" />
                                                    <c:set value="${metric.getPersent_weight() < 0 ? -metric.getPersent_weight():metric.getPersent_weight()}" var="persent" />

                                                    <tr name="${metric.getName()}" class="metricrow" filter="${metric.getFullFilter()}">
                                                        <th scope="row">${loopindex}</th>
                                                            <c:set value="${loopindex+1}" var="loopindex" />
                                                        <td><a href="${cp}/expanded/${metric.getKeyString()}/${metric.getTimestamp()}">${metric.getName()} </a></td>
                                                        <td>${metric.getTags().get(ident_tag).getValue()}                                                                                                                       
                                                        </td>
                                                        <td class="value"><fmt:formatNumber type="number" maxFractionDigits="3" value="${metric.getValue()}" /></td>
                                                        <td class="weight">${metric.getWeight()}</td>
                                                        <td class="persent">
                                                            <c:choose>
                                                                <c:when test="${metric.getPersent_weight() == Double.NaN}">
                                                                    NaN                                    
                                                                </c:when>  
                                                                <c:otherwise>
                                                                    <fmt:formatNumber type="number" maxFractionDigits="3" value="${metric.getPersent_weight()}" /> 
                                                                </c:otherwise>  
                                                            </c:choose>                                                                

                                                        </td>
                                                        <td class="persent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${metric.getPersent_predict()}" /></td>
                                                        <td class="persent">${metric.getRecurrenceTmp()}</td>
                                                        <td class="level_${curentuser.getAlertLevels().getErrorLevel(metric)}"><spring:message code="level_${curentuser.getAlertLevels().getErrorLevel(metric)}"/></td>
                                                        <td class="time">
                                                            <jsp:useBean id="dateValue" class="java.util.Date"/>
                                                            <jsp:setProperty name="dateValue" property="time" value="${metric.getTimestamp()*1000}"/>
                                                            <fmt:formatDate value="${dateValue}" pattern="MM/dd HH:mm:ss" timeZone="${curentuser.getTimezone()}"/> ${curentuser.getTimezone()}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>                                                   
                                </div>
                            </div>
                            </c:forEach>                                                                          
                        </div>
                        <!--  end of accordion  -->
                    </div>
                </div>

            </div>                            
        </div>                          
    </div>                        
</div>