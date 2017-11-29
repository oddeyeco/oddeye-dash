<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="clearfix"></div>
<div class="page-title">
    <div class="title_text">
        <h2>Real Time monitor (UUID = ${curentuser.getId().toString()})</h2>
    </div>
</div>    
<div class="alert alert-danger alert-dismissible collapse " id="manyalert" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>                    
    Too many data points, please change display filter.
</div> 

<div id="lostconnection" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">                
                <h4 class="modal-title">Connection Lost</h4>
            </div>
            <div class="modal-body">
                <p>Websocket connection interrupted, please refresh your browser</p>
                <p class="text-warning"></p>
            </div>
        </div>
    </div>
</div>    

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12 ">
        <div class="x_panel">                                     
            <div class="row">
                <div class="col-md-2 col-sm-3 col-xs-12 profile_left">
                    <h4 ><b>Filter</b> <i class="action fa fa-chevron-up hidefilter"></i> </h4>
                </div>
                <div class="col-md-10 col-sm-9 col-xs-12 profile_right">
                    <h4 class="summary">
                        <b>Total:</b><span class="Tablecount">0</span><b>Machine Learned:</b><span class="regcount">0</span><b>Manually Defined:</b><span class="Speccount">0 </span>
                    </h4>                 
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 col-sm-3 col-xs-12 profile_left-form">
                    <form class="form-horizontal form-label-left form-filter">
                        <jsp:include page="filterform.jsp" />  
                        <div class="form-group">                        
                            <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                <button class="btn btn-success" type="button" value="Default" id="Default">Set as Default</button>        
                            </div>
                        </div>                        
                    </form>                        
                </div>
                <div class="col-md-10 col-sm-9 col-xs-12 profile_right-table">

                    <div class="x_content table-responsive" style="display: block;">
                        <!-- start List -->
                        <table class="table metrictable table-striped bulk_action">
                            <thead>
                                <tr>
                                    <!--<th>#</th>-->
                                    <th class="actions">
                                        <input type="checkbox" id="check-all" class="flat">
                                        <div class="btn-group">                                        
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
                                            <c:forEach items="${list}" var="tagitem">   
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
                                <tr class="wait"><td colspan="7">Wait connect response...</td></tr>
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
