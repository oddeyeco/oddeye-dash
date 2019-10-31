<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
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
                <input   type="button" class="btn btn-sm btn-success " data-dismiss="modal" value="OK">
            </div>
        </div>
    </div>
</div>

<div id="main"></div>
<div class="container center sineup">    
    <!--<h2 class="text-center">Create Account.</h2>-->        
    <div class="row">
        <div class="col-lg-4 col-xs-12 text-right">            
            <c:if test="${empty whitelabel}" >
                <a href="https://www.oddeye.co/" ><img src="${cp}/assets/images/logowhite.png" alt="logo" width="250px"></a>                
                </c:if>                        
            <c:if test="${not empty whitelabel}" >
                <a href="https://${whitelabel.url}/" ><img src="${cp}${whitelabel.getFullfileName()}${whitelabel.logofilename}" alt="logo" width="250px"></a>                                
            </c:if>                
            <div> 
                <spring:message code="sineup.demoInfo"/>
            </div>
        </div>    
        <div class=" contactform col-lg-6 col-xs-12">               
            <form:form method="post" action="${cp}/signup/" modelAttribute="newUser" novalidate="true">            
                <c:if test="${not empty message}" >
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span>
                        </button>
                        ${message}
                    </div>      
                </c:if>                


                <div class="form-group">
                    <spring:message code="adminlist.email" var="ph"/>
                    <form:input path="email" cssClass="form-control" type="email" required="" placeholder="${ph} *"/>                    
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="email" />
                </div>
                <div class="form-group">
                    <spring:message code="adminlist.password" var="ph"/>
                    <form:input path="password" cssClass="form-control" type="password" required="" placeholder="${ph} *"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="password" />
                </div>
                <div class="form-group">
                    <spring:message code="adminlist.reEnterPassword" var="ph"/>
                    <form:input path="passwordsecond" cssClass="form-control" type="password" required="" placeholder="${ph} *"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="passwordsecond"  />
                </div>                
                <div class="form-group">
                    <spring:message code="adminlist.firstName" var="ph"/>
                    <form:input path="name" cssClass="form-control" required="" placeholder="${ph} *"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="name" />
                </div>
                <div class="form-group">
                    <form:hidden path="lastname" cssClass="form-control" placeholder="Last Name"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="lastname" />
                </div>                    
                <div class="form-group">
                    <form:hidden path="company" cssClass="form-control" placeholder="Company name"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="company" />
                </div>
                <div class="form-group">
                    <form:hidden path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="country" />                    
                </div>
                <div class="form-group">
                    <form:hidden path="city" cssClass="form-control" placeholder="City" />
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="city" />                    
                </div>
                <div class="form-group">
                    <form:hidden path="region" cssClass="form-control" placeholder="Region"/>
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="region" />              
                </div>
                <div class="form-group">                    
                    <form:hidden path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                        
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="timezone" />
                </div>
                <c:if test="${dashProp.captchaOn eq 'true'}" >
                <div class="form-group">                    
                    <form:errors element="div" class="alert alert-danger alert-dismissible fade show" role="alert" path="recaptcha" />
                    <div id="recaptcha" data-sitekey="${dashProp.captchaSiteKey}"></div>                
                    <button class="btn btn-sm btn-primary btn-block SineUp" type="submit"><spring:message code="signUp"/></button>
                </div>
                </c:if>
                <c:if test="${dashProp.captchaOn ne 'true'}" >
                <div class="form-group">                    
                    <button class="btn btn-primary btn-block SineUp" type="submit"><spring:message code="signUp"/></button>
                </div>
                </c:if>

                <div class="clearfix"></div>
                <div class="separator">
                    <p class="change_link"><spring:message code="sineup.member"/><a class="btn btn-sm btn-href" href="<c:url value="/login/" />" > <spring:message code="login"/> </a>
                    </p>
                </div>                    
            </form:form>           
        </div>
    </div>
</div>
