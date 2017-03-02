<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>    
    <div class="container contactform center col-lg-4 col-md-8 col-xs-12">
        <h2 class="text-center">Create Account.</h2>        
        <form:form method="post" commandName="newUser" action="${cp}/signup/" modelAttribute="newUser" novalidate="true">            
            <c:if test="${not empty message}" >
                <div class="alert alert-danger alert-dismissible fade in" role="alert">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span>
                    </button>
                    ${message}
                </div>      
            </c:if>                


            <div class="form-group">
                <form:input path="email" cssClass="form-control" type="email" required="" placeholder="E-Mail *"/>                    
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="email" />


            </div>
            <div class="form-group">
                <form:input path="password" cssClass="form-control" type="password" required="" placeholder="Password *"/>
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="password" />
            </div>
            <div class="form-group">
                <form:input path="passwordsecond" cssClass="form-control" type="password" required="" placeholder="Re enter Password *"/>
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="passwordsecond"  />
            </div>                
            <div class="form-group">
                <form:input path="name" cssClass="form-control" required="" placeholder="First Name *"/>
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="name" />
            </div>
            <div class="form-group">
                <form:input path="lastname" cssClass="form-control" placeholder="Last Name"/>
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="lastname" />
            </div>                    
            <div class="form-group">
                <form:input path="company" cssClass="form-control" placeholder="Company name"/>
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="company" />
            </div>
            <div class="form-group">   
                <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="country" />                    
            </div>
            <div class="form-group">
                <form:input path="city" cssClass="form-control" placeholder="City"/>
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="city" />                    
            </div>
            <div class="form-group">
                <form:input path="region" cssClass="form-control" placeholder="Region"/>
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="region" />              
            </div>
            <div class="form-group">                    
                <form:select path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                        
                <form:errors element="div" class="alert alert-danger alert-dismissible fade in" role="alert" path="timezone" />
            </div>                
            <div class="form-group">                
                <button class="btn btn-primary btn-block" type="submit"><i class="fa fa-2x fa-sign-out"></i> Sine Up</button>
            </div>
            <div class="clearfix"></div>
            <div class="separator">
                <p class="change_link">Already a member?<a class="to_register" href="<c:url value="/login/" />"> Log in </a>
                </p>
            </div>
        </form:form>           
    </div>
</div>

