<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<link href="${cp}/resources/datatablesBS4/css/dataTables.bootstrap4.min.css?v=${version}" rel="stylesheet">


<div class="row">
    <div class="col-12">
        <div class="card shadow">
            <h5 class="card-header">
                <spring:message code="adminlist.listOf.h2"/> ${modelname}
            </h5>
            <div class="card-body" id="dashcontent">
                <a href="<c:url value="/${path}/new/"/>" class="btn btn-outline-info btn-sm float-right"><i class="fa fa-navicon"></i> <spring:message code="adminlist.new"/> </a>
                <table id="datatable-responsive" class="table table-sm table-striped table-bordered dt-responsive table-responsive nowrap" cellspacing="0" width="100%">
                    <thead>                
                        <tr>
                            <c:forEach items="${configMap}" var="config">   
                                <th id="th_${config.getKey()}" <c:if test="${not empty config.getValue().displayclass}">class="${config.getValue().displayclass}"</c:if> > 
                                    <spring:message code="${config.getValue().title}"/>
                                </th>
                            </c:forEach>                    
                        </tr>              
                    </thead>
                    <tbody>
                        <c:forEach items="${modellist}" var="model">   
                            <tr>
                                <c:forEach items="${configMap}" var="config">   
                                    <td>

                                        <c:choose>
                                            <c:when test="${config.getValue().type == 'actions'}">                                        
                                                <c:choose>
                                                    <c:when test="${config.getValue().path == 'edit'}">
                                                        <sec:authorize access="hasRole('EDIT')">
                                                            <a href="<c:url value="/${path}/edit/${model.getId()}"/>" class="btn btn-outline-info btn-sm" value="${model.getId()}"><i class="fa fas fa-pencil-alt"></i> <spring:message code="edit"/> </a>
                                                        </sec:authorize>
                                                    </c:when>                                                    
                                                    <c:when test="${config.getValue().path == 'alowswitch'}">
                                                        <sec:authorize access="hasRole('ROLE_CAN_SWICH')">
                                                            <c:if test="${model[config.getValue().path]}">
                                                                <a href="<c:url value="/${path}/switch/${model.getId()}"/>" class="btn btn-outline-info btn-sm" value="${model.getId()}"><i class="fa fas fa-pencil-alt"></i> <spring:message code="adminlist.switch"/> </a>    
                                                            </c:if>
                                                        </sec:authorize>
                                                    </c:when>
                                                    <c:otherwise>
                                                    </c:otherwise>                                                    
                                                </c:choose>
                                            </c:when>   

                                            <c:when test="${config.getValue().type == 'String'}">
                                                ${model[config.getValue().path] }
                                            </c:when>                                            
                                            <c:when test="${config.getValue().type == 'Double'}">      
                                                <c:if test="${curentuser.getBalance()!=null}">
                                                    <c:if test="${model[config.getValue().path]<Double.MAX_VALUE}">
                                                        <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="4" value=" ${model[config.getValue().path] }" />
                                                    </c:if>
                                                    <c:if test="${model[config.getValue().path]==Double.MAX_VALUE}">
                                                        <span class="infin"> 0000000000</span>
                                                    </c:if>                                                        
                                                </c:if>
                                            </c:when>                                                         
                                            <c:when test="${config.getValue().type == 'Enum'}">                                        
                                                ${model[config.getValue().path]}
                                            </c:when>  

                                            <c:when test="${config.getValue().type == 'Object'}">                                                                                
                                                ${model[config.getValue().path][config.getValue().display]}
                                            </c:when>  

                                            <c:when test="${config.getValue().type == 'Date'}">    
                                                <fmt:formatDate value="${model[config.getValue().path]}" pattern="YYYY/MM/dd HH:mm:ss"/>                                        
                                            </c:when>                                            
                                            <c:when test="${config.getValue().type == 'Collection'}">                                                                                
                                                <c:forEach items="${model[config.getValue().path] }" var="item">                                               
                                                    <span class="badge badge-success">${config.getValue().items[item]}</span><br>
                                                </c:forEach>                                                                                                            
                                            </c:when>  
                                            <c:when test="${config.getValue().type == 'cookies'}">                                                                                
                                                <c:forEach items="${model[config.getValue().path] }" var="item"> 
                                                    <c:if test = "${fn:contains(item.name, 'mf_')==false}">
                                                        <c:set var="urlString">${item.value}</c:set>  
                                                        <c:set var="urlString">${fn:replace(urlString,'%3A',':')}</c:set>
                                                        <c:set var="urlString">${fn:replace(urlString,'%3D','=')}</c:set>
                                                        <c:set var="urlString">${fn:replace(urlString,'%3F','?')}</c:set>
                                                        <c:set var="urlString">${fn:replace(urlString,'%26','&')}</c:set>                                            
                                                        <c:set var="urlString">${fn:replace(urlString,'%2F','/')}</c:set>                                            
                                                        <span class="badge badge-success">${item.name}=${urlString}</span><br>
                                                    </c:if>

                                                </c:forEach>                                                                                                            
                                            </c:when>                                             
                                            <c:when test="${config.getValue().type == 'List'}">                                                                                
                                                <c:forEach items="${model[config.getValue().path] }" var="item">                                               
                                                    <span class="badge badge-success">${item}</span><br>
                                                </c:forEach>                                                                                                            
                                            </c:when>                                                                                                

                                            <c:when test="${config.getValue().type == 'userstatus'}">    
                                                <c:if test="${model.getListenerContainer().isRunning()}">
                                                    <span class="badge badge-success"><spring:message code="adminlist.looksMonitoring"/> ${model.getSotokenlist().size()}</span><br>
                                                </c:if>   

                                                <c:forEach items="${model.getPagelist() }" var="item">   
                                                    <span class="badge badge-success">${item.getValue()}</span><br>
                                                </c:forEach>                                                 
                                            </c:when>                                                                                                                                            
                                            <c:otherwise>
                                                <c:if test="${model[config.getValue().path]!=null}">
                                                    ${model[config.getValue().path] }
                                                </c:if>                                        

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
    </div>
</div>

    






<!--<div class="x_panel">
    <div class="x_title">
        <h2 class="col-md-3" ><spring:message code="adminlist.listOf.h2"/> ${modelname}</h2>        
        <div class="clearfix"></div>
    </div>        
    <div class="x_content" id="dashcontent">     
        <a href="<c:url value="/${path}/new/"/>" class="btn btn-outline-info btn-sm float-right"><i class="fa fa-navicon"></i> <spring:message code="adminlist.new"/> </a>
        <table id="datatable-responsive" class="table table-sm table-striped table-bordered dt-responsive table-responsive nowrap" cellspacing="0" width="100%">
            <thead>                
                <tr>
                    <c:forEach items="${configMap}" var="config">   
                        <th id="th_${config.getKey()}" <c:if test="${not empty config.getValue().displayclass}">class="${config.getValue().displayclass}"</c:if> > 
                            <spring:message code="${config.getValue().title}"/>
                        </th>
                        </c:forEach>                    
                </tr>              
            </thead>
            <tbody>
                <c:forEach items="${modellist}" var="model">   
                    <tr>
                        <c:forEach items="${configMap}" var="config">   
                            <td>

                                <c:choose>
                                    <c:when test="${config.getValue().type == 'actions'}">                                        
                                        <c:choose>
                                            <c:when test="${config.getValue().path == 'edit'}">
                                                <sec:authorize access="hasRole('EDIT')">
                                                    <a href="<c:url value="/${path}/edit/${model.getId()}"/>" class="btn btn-outline-info btn-sm" value="${model.getId()}"><i class="fa fas fa-pencil-alt"></i> <spring:message code="edit"/> </a>
                                                </sec:authorize>
                                            </c:when>                                                    
                                            <c:when test="${config.getValue().path == 'alowswitch'}">
                                                <sec:authorize access="hasRole('ROLE_CAN_SWICH')">
                                                    <c:if test="${model[config.getValue().path]}">
                                                        <a href="<c:url value="/${path}/switch/${model.getId()}"/>" class="btn btn-outline-info btn-sm" value="${model.getId()}"><i class="fa fas fa-pencil-alt"></i> <spring:message code="adminlist.switch"/> </a>    
                                                    </c:if>
                                                </sec:authorize>
                                            </c:when>
                                            <c:otherwise>
                                            </c:otherwise>                                                    
                                        </c:choose>
                                    </c:when>   

                                    <c:when test="${config.getValue().type == 'String'}">
                                        ${model[config.getValue().path] }
                                    </c:when>                                            
                                    <c:when test="${config.getValue().type == 'Double'}">      
                                        <c:if test="${curentuser.getBalance()!=null}">
                                            <c:if test="${model[config.getValue().path]<Double.MAX_VALUE}">
                                                <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="4" value=" ${model[config.getValue().path] }" />
                                            </c:if>
                                            <c:if test="${model[config.getValue().path]==Double.MAX_VALUE}">
                                                <span class="infin"> 0000000000</span>
                                            </c:if>                                                        
                                        </c:if>
                                    </c:when>                                                         
                                    <c:when test="${config.getValue().type == 'Enum'}">                                        
                                        ${model[config.getValue().path]}
                                    </c:when>  

                                    <c:when test="${config.getValue().type == 'Object'}">                                                                                
                                        ${model[config.getValue().path][config.getValue().display]}
                                    </c:when>  

                                    <c:when test="${config.getValue().type == 'Date'}">    
                                        <fmt:formatDate value="${model[config.getValue().path]}" pattern="YYYY/MM/dd HH:mm:ss"/>                                        
                                    </c:when>                                            
                                    <c:when test="${config.getValue().type == 'Collection'}">                                                                                
                                        <c:forEach items="${model[config.getValue().path] }" var="item">                                               
                                            <span class="badge badge-success">${config.getValue().items[item]}</span><br>
                                        </c:forEach>                                                                                                            
                                    </c:when>  
                                    <c:when test="${config.getValue().type == 'cookies'}">                                                                                
                                        <c:forEach items="${model[config.getValue().path] }" var="item"> 
                                            <c:if test = "${fn:contains(item.name, 'mf_')==false}">
                                                <c:set var="urlString">${item.value}</c:set>  
                                                <c:set var="urlString">${fn:replace(urlString,'%3A',':')}</c:set>
                                                <c:set var="urlString">${fn:replace(urlString,'%3D','=')}</c:set>
                                                <c:set var="urlString">${fn:replace(urlString,'%3F','?')}</c:set>
                                                <c:set var="urlString">${fn:replace(urlString,'%26','&')}</c:set>                                            
                                                <c:set var="urlString">${fn:replace(urlString,'%2F','/')}</c:set>                                            
                                                <span class="badge badge-success">${item.name}=${urlString}</span><br>
                                            </c:if>

                                        </c:forEach>                                                                                                            
                                    </c:when>                                             
                                    <c:when test="${config.getValue().type == 'List'}">                                                                                
                                        <c:forEach items="${model[config.getValue().path] }" var="item">                                               
                                            <span class="badge badge-success">${item}</span><br>
                                        </c:forEach>                                                                                                            
                                    </c:when>                                                                                                

                                    <c:when test="${config.getValue().type == 'userstatus'}">    
                                        <c:if test="${model.getListenerContainer().isRunning()}">
                                            <span class="badge badge-success"><spring:message code="adminlist.looksMonitoring"/> ${model.getSotokenlist().size()}</span><br>
                                        </c:if>   

                                        <c:forEach items="${model.getPagelist() }" var="item">   
                                            <span class="badge badge-success">${item.getValue()}</span><br>
                                        </c:forEach>                                                 
                                    </c:when>                                                                                                                                            
                                    <c:otherwise>
                                        <c:if test="${model[config.getValue().path]!=null}">
                                            ${model[config.getValue().path] }
                                        </c:if>                                        

                                    </c:otherwise>
                                </c:choose>                                        
                            </td>

                        </c:forEach>                        
                    </tr>
                </c:forEach>                
            </tbody>
        </table>                
    </div>
</div>-->

