<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                <%--<c:set var="group_item" value="host" />--%>   
                <div class="col-md-2 col-sm-3 col-xs-12 profile_left">
                    <h3>Filter</h3>
                    <form class="form-horizontal form-label-left">
                        <div class="form-group">
                            <label class="col-md-12 col-sm-12 col-xs-12">Group by</label>
                            <div class="col-md-12 col-sm-12 col-xs-12">
                                <select class="form-control" name="group_item">
                                    <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                        <option <c:if test="${group_item == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-12 col-sm-12 col-xs-12">Show Tag</label>
                            <div class="col-md-12 col-sm-12 col-xs-12">
                                <select class="form-control" name="ident_tag" id="ident_tag">
                                    <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                        <option <c:if test="${ident_tag == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>


                        <div class="form-group">
                            <label class="col-md-12 col-sm-12 col-xs-12">Level</label>
                            <div class="col-md-12 col-sm-12 col-xs-12">
                                <select class="form-control" name="level" id="level">                                    
                                    <c:forEach items="${curentuser.getAlertLevels()}" var="level">   
                                        <option <c:if test="${level_item == level.key}"> selected="true" </c:if>  value="${level.key}"> ${curentuser.getAlertLevels().getName(level.key)} </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>                                                                                       

<!--                        <div class="form-group">                        
                            <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                <button class="btn btn-success" type="button" value="Default">Set as Default</button>
                                <button class="btn btn-primary" type="submit" value="Submit">Submit</button>
                            </div>
                        </div>                         -->
                    </form>
                </div>
                <div class="col-md-10 col-sm-9 col-xs-12 profile_left">
                    <div class="x_content" style="display: block;">
                        <!-- start List -->
                        <table class="table metrictable">
                            <thead>
                                <tr>
                                    <!--<th>#</th>-->
                                    <th>Metric Name</th>
                                    <th>${ident_tag} </th>
<!--                                    <th>Value</th>
                                    <th>Weight</th>
                                    <th>Deviation %</th>                                    -->
                                    <!--<th>Action</th>-->
                                    <th>Level</th>
                                    <th>Message</th>
                                    <th>Start Time</th>
                                    <th>Change Time</th>
                                </tr>
                            </thead>
                            <tbody>
<!--                                    <tr>
                                        <th scope="row"></th>                                            
                                        <td></td>
                                        <td></td>
                                        <td class="value"></td>
                                        <td class="weight"></td>
                                        <td class="persent"></td>
                                        <td class="persent"></td>
                                        <td class="persent"></td>
                                        <td class="level"></td>
                                        <td class="time"></td>
                                    </tr>-->
                            </tbody>
                        </table>
                        <!-- end of List -->


                    </div>
                </div>                        

            </div>
        </div>
    </div>
</div>

<!-- /page content -->
