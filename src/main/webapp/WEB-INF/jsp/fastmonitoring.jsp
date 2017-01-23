<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" type="text/css" href="${cp}/resources//switchery/dist/switchery.min.css" />        
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
                    <form class="form-horizontal form-label-left form-filter">
                        <div class="form-group">
                            <label class="col-md-12 col-sm-12 col-xs-12">By Tag</label>
                            <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                <div class="form-group">
                                    <label class=" col-lg-12 col-sm-12 col-xs-12">
                                        ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}
                                        <input type="checkbox" class="js-switch-small filter-switch" id="check_${tagitem.key}" name="check_${tagitem.key}" value="${tagitem.key}"/> 
                                    </label>
                                    <div class="col-lg-12 col-sm-12 col-xs-12">
                                        <input class="form-control autocomplete-append filter-input" type="text" name="${tagitem.key}_input" id="${tagitem.key}_input" tagkey="${tagitem.key}" value="">
                                        <div class="autocomplete-container_${tagitem.key}" style="position: relative; float: left; width: 400px; margin: 0px;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="form-group">
                            <label class="col-md-12 col-sm-12 col-xs-12">Level</label>
                            <div class="col-md-12 col-sm-12 col-xs-12">
                                <c:forEach items="${curentuser.getAlertLevels()}" var="level">   
                                    <div class="col-lg-6">
                                        <label>
                                            <input type="checkbox" class="js-switch-small" id="check_level_${level.key}" name="check_level_${level.key}" /> ${curentuser.getAlertLevels().getName(level.key)}
                                        </label>
                                    </div>                                
                                </c:forEach>
                            </div>
                        </div>                                                                                       
                        <div class="form-group">                        
                            <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                <button class="btn btn-success" type="button" value="Default" id="Default">Set as Default</button>
                                <!--<button class="btn btn-primary" type="button" value="Submit" id="Save As">Save As</button>-->
                            </div>
                        </div>  
                    </form>
                </div>
                <div class="col-md-10 col-sm-9 col-xs-12 profile_left">
                    <div class="x_content" style="display: block;">
                        <!-- start List -->
                        <table class="table metrictable jambo_table bulk_action">
                            <thead>
                                <tr>
                                    <!--<th>#</th>-->
                                    <th>
                                        <input type="checkbox" id="check-all" class="flat">
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-success btn-sm">Action</button>
                                            <button type="button" class="btn btn-success btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                                <span class="caret"></span>
                                                <span class="sr-only">Toggle Dropdown</span>
                                            </button>
                                            <ul class="dropdown-menu" role="menu">
                                                <li><a href="#">Show Chart</a>
                                                </li>
                                                <li class="divider"></li>
                                                <li><a href="#" id="Clear_reg">Clear Regression</a>
                                                </li>
                                            </ul>
                                        </div>                                        
                                    </th>
                                    <th>Metric Name</th>
                                    <th id="ident_tag_head">
                                        <select class="form-control" name="ident_tag" id="ident_tag">
                                            <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                                                <option <c:if test="${ident_tag == tagitem.key}"> selected="true" </c:if> value="${tagitem.key}" > ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))} (${tagitem.value.size()}) </option>
                                            </c:forEach>
                                        </select>
                                    </th>
                                    <th>Level</th>
                                    <th>Message</th>
                                    <th>Time</th>                                    
                                </tr>
                            </thead>
                            <tbody>

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
