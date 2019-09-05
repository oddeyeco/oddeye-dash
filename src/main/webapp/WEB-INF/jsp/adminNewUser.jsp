<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<div id="confirmError" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">
                    <spring:message code="confirmationFail"/>
                </h4>
            </div>
            <div class="modal-body">
                <p><spring:message code="sineup.confirmationNotExist"/></p>
                <p><spring:message code="sineup.signupOrCheck"/></p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-success " data-dismiss="modal" value="OK">
            </div>
        </div>
    </div>
</div>

<div id="main"></div>
<div class="container center sineup">    
    <!--<h2 class="text-center">Create Account.</h2>-->        
    <div class="row">
        <div class=" contactform col-lg-6 col-xs-12">               
            <form:form method="post" action="${cp}/user/new/" modelAttribute="newUser" novalidate="true" autocomplete="off">            
                <c:if test="${not empty message}" >
                    <div class="alert alert-danger alert-dismissible fadein" role="alert">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span>
                        </button>
                        ${message}
                    </div>      
                </c:if>                
                <div class="form-group">
                    <spring:message code="adminlist.firstName" var="ph"/>
                    <form:input path="name" cssClass="form-control" required="" placeholder="${ph} *" autocomplete="off"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="name" />
                </div>
                <div class="form-group">
                    <spring:message code="adminlist.lastName" var="ph"/>
                    <form:input path="name" cssClass="form-control" required="" placeholder="${ph} *" autocomplete="off"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="lastname" />
                </div>                
                <div class="form-group">
                    <spring:message code="adminlist.email" var="ph"/>
                    <form:input path="email" cssClass="form-control" type="email" required="" placeholder="${ph} *" autocomplete="off"/>                    
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="email" />
                </div>
                <div class="form-group">
                    <spring:message code="adminlist.password" var="ph"/>
                    <form:input path="password" cssClass="form-control" type="password" required="" placeholder="${ph} *" autocomplete="off"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="password" />
                </div>
                <div class="form-group">
                    <spring:message code="adminlist.reEnterPassword" var="ph"/>
                    <form:input path="passwordsecond" cssClass="form-control" type="password" required="" placeholder="${ph} *" autocomplete="off"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="passwordsecond"  />
                </div>                
                <div class="form-group">                    
                    <button class="btn btn-primary btn-block SineUp" type="submit"><spring:message code="createUser"/></button>
                </div>

                <div class="clearfix"></div>
            </form:form>           
        </div>
    </div>
</div>
