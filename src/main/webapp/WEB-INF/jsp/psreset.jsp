<%-- 
    Document   : psreset
    Created on : May 29, 2019, 16:34:00
    Author     : sasha
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
        <div class="col-lg-4 col-xs-12 text-right">            
            <div> 
                <spring:message code="psreset.welcome"/>
            </div>
        </div>    
        <div class=" contactform col-lg-6 col-xs-12">               
            <form:form method="post" action="${cp}/pschange" modelAttribute="passwordResetInfo" novalidate="true">            
                <c:if test="${not empty message}" >
                    <div class="alert alert-danger alert-dismissible fadein" role="alert">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">?</span>
                        </button>
                        ${message}
                    </div>      
                </c:if>                

                <div class="form-group">
                    <spring:message code="adminlist.email" var="ph"/>
                    <form:label path="email" cssClass="form-control">${passwordResetInfo.email}</form:label>                    
                </div>
                <div class="form-group">
                    <spring:message code="adminlist.password" var="ph"/>
                    <form:input path="password" cssClass="form-control" type="password" required="" placeholder="${ph} *"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="password" />
                </div>
                <div class="form-group">
                    <spring:message code="adminlist.reEnterPassword" var="ph"/>
                    <form:input path="passwordRepeat" cssClass="form-control" type="password" required="" placeholder="${ph} *"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="passwordRepeat"  />
                </div>
                <div class="form-group">
                    <form:hidden path="resetToken" placeholder="Reset Token"/>
                </div>           
                <div class="form-group">
                    <form:hidden path="email" placeholder="Email"/>
                </div>           
                <div class="form-group">
                    <form:hidden path="userName" placeholder="User Name"/>
                </div>           
                
                
                <c:if test="${dashProp.captchaOn eq 'true'}" >
                <div class="form-group">                    
                    <form:errors element="div" class="alert alert-danger alert-dismissible fadein" role="alert" path="recaptcha" />
                    <div id="recaptcha" data-sitekey="${dashProp.captchaSiteKey}"></div>                
                    <button class="btn btn-primary btn-block SineUp" type="submit"><spring:message code="savePassword"/></button>
                </div>
                </c:if>
                <c:if test="${dashProp.captchaOn ne 'true'}" >
                <div class="form-group">                    
                    <button class="btn btn-primary btn-block SineUp" type="submit"><spring:message code="savePassword"/></button>
                </div>
                </c:if>

                <div class="clearfix"></div>
                <div class="separator">
                    <p class="change_link"><spring:message code="sineup.member"/><a class="btn btn-href btn-sm" href="<c:url value="/login/" />" > <spring:message code="login"/> </a>
                    </p>
                </div>                    
            </form:form>           
        </div>
    </div>
</div>
