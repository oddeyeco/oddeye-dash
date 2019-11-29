<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}"/>
<%-- 

    Document   : adminedit
    Created on : Feb 23, 2017, 9:31:26 AM
    Author     : vahan
--%>
<div class="card mb-3 shadow">    
<div class="card-body">    
    <form:form method="post" action="${cp}/${path}/edit/${model.id}" modelAttribute="model" novalidate="true" cssClass="form-horizontal form-label-left">                            
    <form:hidden path="id" />                            
    <c:forEach items="${configMap}" var="config">

        <c:choose>
            <c:when test="${config.getValue().type == 'actions'}">
                <div class="form-group row justify-content-center">
                    <div class="col-md-6 col-sm-6 col-12">                        
                        <sec:authorize access="hasRole('EDIT')">
                            <button type="submit" class="btn btn-sm btn-outline-success mr-1" name="act" value="Save"><spring:message code="save"/></button>
                        </sec:authorize>
                        <sec:authorize access="hasRole('DELETE')">
                            <button type="submit" class="btn btn-sm btn-outline-danger mr-1" name="act" value="Delete"><spring:message code="delete"/></button>
                        </sec:authorize>
                        <button type="reset" class="btn btn-sm btn-outline-primary mr-1" name="cancel"><spring:message code="cancel"/></button>    
                    </div>
                </div>                
            </c:when>    
            <c:when test="${config.getValue().type == 'String'}">
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="${config.getValue().path}">
                        <spring:message code="${config.getValue().title}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12">
                        <spring:message code="${config.getValue().title}" var="placeholderTitle"/>
                        <form:input path="${config.getValue().path}" cssClass="form-control" placeholder="${placeholderTitle}"/><%--${config.getValue().title}--%>                         
                        <form:errors path="${config.getValue().path}" />
                    </div>
                </div>  
            </c:when>                
            <c:when test="${config.getValue().type == 'Select'}">
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="${config.getValue().path}">
                        <spring:message code="${config.getValue().title}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12">
                        <spring:message code="${config.getValue().title}" var="placeholderTitle"/>
                        <form:select path="${config.getValue().path}" items="${config.getValue().items}" cssClass="form-control" tabindex="-1" placeholder="${placeholderTitle}"/><%--${config.getValue().title}--%>  
                        <form:errors path="${config.getValue().path}" />
                    </div>
                </div>  
            </c:when>    
            <c:when test="${config.getValue().type == 'MultiSelect'}">
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="${config.getValue().path}">
                        <spring:message code="${config.getValue().title}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12">
                        <spring:message code="${config.getValue().title}" var="placeholderTitle"/>
                        <form:select path="${config.getValue().path}" items="${config.getValue().items}" cssClass="form-control select2_multiple" tabindex="-1" placeholder= "${placeholderTitle}"/><%--"${config.getValue().title}"--%>
                        <%--<form:input path="${config.getValue().path}" cssClass="form-control" placeholder="${config.getValue().title} "/>--%>
                        <form:errors path="${config.getValue().path}" />
                    </div>
                </div>                                                                                                                           
            </c:when>                         
            <c:when test="${config.getValue().type == 'password'}">
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="${config.getValue().path}"><%--${config.getValue().title}--%>
                        <spring:message code="${config.getValue().title}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12"> 
                        <spring:message code="${config.getValue().title}" var="placeholderTitle"/>
                        <input id="password" name="password" class="form-control"  type="password" value="" placeholder= "${placeholderTitle}"><%--"${config.getValue().title}"--%>
                        <form:errors path="${config.getValue().path}" />
                    </div>
                </div>  
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="passwordsecond"><%--${config.getValue().retitle}--%>
                        <spring:message code="${config.getValue().retitle}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12">
                        <spring:message code="${config.getValue().retitle}" var="placeholderTitle"/>
                        <form:input path="passwordsecond" type="password" cssClass="form-control" placeholder="${placeholderTitle} "/>  <%--${config.getValue().retitle}--%>                          
                        <form:errors path="passwordsecond" />
                    </div>
                </div>                         
            </c:when>           
            <c:when test="${config.getValue().type == 'boolean'}">
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="${config.getValue().path}">
                        <spring:message code="${config.getValue().title}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12">
                        <spring:message code="${config.getValue().title}" var="placeholderTitle"/>                         
                        <form:checkbox path="${config.getValue().path}" cssClass="" placeholder="${placeholderTitle} "/><%--${config.getValue().title}--%>                           
                        <form:errors path="${config.getValue().path}" />
                    </div>
                </div>  
            </c:when>                
            <c:when test="${config.getValue().type == 'Text'}">
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="${config.getValue().path}">
                        <spring:message code="${config.getValue().title}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12">
                        <spring:message code="${config.getValue().title}" var="placeholderTitle"/>
                        <form:textarea path="${config.getValue().path}" cssClass="form-control" placeholder="${placeholderTitle}" rows="${config.getValue().rows}"/>
                        <form:errors path="${config.getValue().path}" />
                    </div>
                </div>  
            </c:when>  
            <c:when test="${config.getValue().type == 'float'}">
                <div class="form-group row">
                    <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="${config.getValue().path}"><%--${config.getValue().title}--%>
                        <spring:message code="${config.getValue().title}"/>
                        <c:if test="${config.getValue().required == true}"> 
                            <span class="required">*</span>
                        </c:if>
                    </label>
                    <div class="col-lg-5 col-md-6 col-12">
                        <spring:message code="${config.getValue().title}" var="placeholderTitle"/>
                        <form:input path="${config.getValue().path}" type="number" cssClass="form-control" placeholder="${placeholderTitle}"/> <%--${config.getValue().title}--%>                            
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
</div>
<c:catch var="e">
    <c:import url="${path}.jsp" />
</c:catch>

