<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%-- 
    Document   : adminedit
    Created on : Feb 23, 2017, 9:31:26 AM
    Author     : vahan
--%>
<div class="x_panel">    
    <form:form method="post" action="${cp}/${path}/edit/${model.id}" modelAttribute="model" novalidate="true" cssClass="form-horizontal form-label-left">                            
        <form:hidden path="id" />                            
        <c:forEach items="${configMap}" var="config">  
            <c:choose>
                <c:when test="${config.getValue().type == 'actions'}">
                    <div class="form-group">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                            <button type="reset" class="btn btn-primary" name="cancel">Cancel</button>
                            <sec:authorize access="hasRole('EDIT')">
                                <button type="submit" class="btn btn-success" name="act" value="Save">Save</button>
                            </sec:authorize>
                            <sec:authorize access="hasRole('DELETE')">
                                <button type="submit" class="btn btn-danger" name="act" value="Delete">Delete</button>
                            </sec:authorize>
                        </div>
                    </div>                
                </c:when>    
                <c:when test="${config.getValue().type == 'String'}">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="${config.getValue().path}">${config.getValue().title} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <form:input path="${config.getValue().path}" cssClass="form-control" placeholder="${config.getValue().title} "/>                            
                            <form:errors path="${config.getValue().path}" />
                        </div>
                    </div>  
                </c:when>                                                
                <c:when test="${config.getValue().type == 'Select'}">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="${config.getValue().path}">${config.getValue().title} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                            
                            <form:select path="${config.getValue().path}" items="${config.getValue().items}" cssClass="form-control select2" tabindex="-1" placeholder="${config.getValue().title}"/>
                            <form:errors path="${config.getValue().path}" />
                        </div>
                    </div>  
                </c:when>    
                <c:when test="${config.getValue().type == 'MultiSelect'}">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="${config.getValue().path}">${config.getValue().title} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                            
                            <form:select path="${config.getValue().path}" items="${config.getValue().items}" cssClass="form-control select2_multiple" tabindex="-1" placeholder="${config.getValue().title}"/>
                            <%--<form:input path="${config.getValue().path}" cssClass="form-control" placeholder="${config.getValue().title} "/>--%>
                            <form:errors path="${config.getValue().path}" />
                        </div>
                    </div>  
                </c:when>                         
                <c:when test="${config.getValue().type == 'password'}">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="${config.getValue().path}">${config.getValue().title} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">          
                            <input id="password" name="password" class="form-control" placeholder="${config.getValue().title} " type="password" value="">
                            <form:errors path="${config.getValue().path}" />
                        </div>
                    </div>  
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="passwordsecond">${config.getValue().retitle} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                                                        
                            <form:input path="passwordsecond" type="password" cssClass="form-control" placeholder="${config.getValue().retitle} "/>                            
                            <form:errors path="passwordsecond" />
                        </div>
                    </div>                         
                </c:when>           
                <c:when test="${config.getValue().type == 'boolean'}">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="${config.getValue().path}">${config.getValue().title} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <form:checkbox path="${config.getValue().path}" cssClass="form-control" placeholder="${config.getValue().title} "/>
                            <form:errors path="${config.getValue().path}" />
                        </div>
                    </div>  
                </c:when>                
                <c:when test="${config.getValue().type == 'Text'}">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="${config.getValue().path}">${config.getValue().title} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <form:textarea path="${config.getValue().path}" cssClass="form-control" placeholder="${config.getValue().title}" rows="${config.getValue().rows}"/>
                            <form:errors path="${config.getValue().path}" />
                        </div>
                    </div>  
                </c:when>  
                <c:when test="${config.getValue().type == 'float'}">
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="${config.getValue().path}">${config.getValue().title} 
                            <c:if test="${config.getValue().required == true}"> 
                                <span class="required">*</span>
                            </c:if>
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <form:input path="${config.getValue().path}" type="number" cssClass="form-control" placeholder="${config.getValue().retitle} "/>                            
                            <form:errors path="${config.getValue().path}" />
                        </div>
                    </div>  
                </c:when>                
                <c:otherwise>

                </c:otherwise>
            </c:choose> 

        </c:forEach>         
    </form:form>                                                
</div>
<c:catch var="e">
    <c:import url="${path}.jsp" />
</c:catch>

