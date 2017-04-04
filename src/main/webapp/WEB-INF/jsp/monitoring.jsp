<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" type="text/css" href="${cp}/resources//switchery/dist/switchery.min.css" />
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">

<div class="page-title">
    <div class="title_left">
        <h2>Real Time monitor (UUID = ${curentuser.getId().toString()})</h2>
    </div>
</div>

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12 ">
        <div class="x_panel">                                     
            <div class="col-md-2 col-sm-3 col-xs-12 profile_left">
                <h3>Filter</h3>
                <form class="form-horizontal form-label-left form-filter">
                    <jsp:include page="filterform.jsp" />  
                    <div class="form-group">                        
                        <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                            <button class="btn btn-success" type="button" value="Default" id="Default">Set as Default</button>        
                        </div>
                    </div>                        
                </form>                    
                <div class="alert alert-danger alert-dismissible collapse " id="manyalert" role="alert">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>                    
                    Vatem ape. mard Exi.
                </div>                    
            </div>
            <div class="col-md-10 col-sm-9 col-xs-12 profile_left">
                <div class="x_content" style="display: block;">
                    <!-- start List -->
                    <table id="monitoring" class="table metrictable table-striped bulk_action">
                        <thead>
                            <tr>
                                <!--<th>#</th>-->
                                <th aria-label="Type" style="width: 20px">
                                    <input type="checkbox" id="check-all" class="flat">
                                    <div class="btn-group">
                                        <!--<button type="button" class="btn btn-success btn-sm">Action</button>-->
                                        <button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                            <span class="caret"></span>
                                            <span class="sr-only">Toggle Dropdown</span>
                                        </button>
                                        <ul class="dropdown-menu" role="menu">
                                            <li><a href="#" id="Show_chart">Show Chart</a>
                                            </li>
                                            <li class="divider"></li>
                                            <li><a href="#" id="Clear_reg">Clear Regression</a>
                                            </li>
                                        </ul>
                                    </div>                                        
                                </th>
                                <th>Level</th>
                                <th>Metric Name</th>
                                <th id="ident_tag_head">
                                    <select class="table-form-control" name="ident_tag" id="ident_tag">
                                        <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                            <option <c:if test="${ident_tag == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                        </c:forEach>
                                    </select>
                                </th>                                    
                                <th style="width: 300px" >Info</th>
                                <th>Start Time</th>
                                <th>Last Time</th>                                    
                            </tr>
                        </thead>                            
                    </table>
                    <%--                         
                                            <table class="table metrictable table-striped bulk_action">
                                                <thead>
                                                    <tr>
                                                        <!--<th>#</th>-->
                                                        <th>
                                                            <input type="checkbox" id="check-all" class="flat">
                                                            <div class="btn-group">
                                                                <!--<button type="button" class="btn btn-success btn-sm">Action</button>-->
                                                                <button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                                                    <span class="caret"></span>
                                                                    <span class="sr-only">Toggle Dropdown</span>
                                                                </button>
                                                                <ul class="dropdown-menu" role="menu">
                                                                    <li><a href="#" id="Show_chart">Show Chart</a>
                                                                    </li>
                                                                    <li class="divider"></li>
                                                                    <li><a href="#" id="Clear_reg">Clear Regression</a>
                                                                    </li>
                                                                </ul>
                                                            </div>                                        
                                                        </th>
                                                        <th>Level</th>
                                                        <th>Metric Name</th>
                                                        <th id="ident_tag_head">
                                                            <select class="table-form-control" name="ident_tag" id="ident_tag">
                                                                <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                                                    <option <c:if test="${ident_tag == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                                                </c:forEach>
                                                            </select>
                                                        </th>                                    
                                                        <th>Info</th>
                                                        <th>Start Time</th>
                                                        <th>Last Time</th>                                    
                                                    </tr>
                                                </thead>
                                                <tbody>

                            </tbody>
                        </table>
                    --%> 
                    <!-- end of List -->                        
                </div>
            </div>                                    
        </div>
    </div>
</div>

<!-- /page content -->
