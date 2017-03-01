<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">

<div class="x_panel">
    <div class="x_title">
        <h2 class="col-md-3" >List of ${modelname}</h2>        
        <div class="clearfix"></div>
    </div>        
    <div class="x_content" id="dashcontent">     
        <a href="<c:url value="/${path}/new/"/>" class="btn btn-info btn-sm pull-right"><i class="fa fa-navicon"></i> New </a>
        <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
            <thead>                
                <tr>
                    <c:forEach items="${configMap}" var="config">   
                        <th>  ${config.getValue().title}</th>
                        </c:forEach>                    
                </tr>              
            </thead>
            <tbody>
                <c:forEach items="${modellist}" var="model">   
                    <tr>
                        <c:forEach items="${configMap}" var="config">   
                            <td>
                                <c:choose>
                                    <c:when test="${config.getValue().type == \"actions\"}">
                                        <sec:authorize access="hasRole('EDIT')">
                                            <a href="<c:url value="/${path}/edit/${model.id}"/>" class="btn btn-info btn-xs" value="${model.id}"><i class="fa fa-pencil"></i> Edit </a>
                                        </sec:authorize>
                                    </c:when>    
                                    <c:when test="${config.getValue().type == 'String'}">
                                        ${model[config.getValue().path] }
                                    </c:when>                                                

                                    <c:when test="${config.getValue().type == 'Collection'}">                                        
                                        <c:forEach items="${model[config.getValue().path] }" var="item">   
                                            <span class="label label-success">${config.getValue().items[item]}</span><br>
                                        </c:forEach>                                                                
                                    </c:when>                                                                                                
                                    <c:otherwise>
                                    </c:otherwise>
                                </c:choose>                                        
                            </td>

                        </c:forEach>                        
                    </tr>
                </c:forEach>                
            </tbody>
        </table>                
    </div>
</div>

