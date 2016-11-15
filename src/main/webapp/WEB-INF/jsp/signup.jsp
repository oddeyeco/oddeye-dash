<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="contact" class="spacer">    
    <div class="container contactform center">
        <div class="row wowload fadeInLeftBig">
            <!--<form method="post" action="/" novalidate="">--> 
            <form:form method="post" commandName="newUser" modelAttribute="newUser" novalidate="true">
                <h1>Create Account</h1>
                <div class="form-group">
                    <form:input path="email" cssClass="form-control" type="email" required="" placeholder="E-Mail *"/>                    
                    <form:errors path="email" />
                </div>
                <div class="form-group">
                    <form:input path="password" cssClass="form-control" type="password" required="" placeholder="Password *"/>
                    <form:errors path="password" />
                </div>
                <div class="form-group">
                    <form:input path="passwordsecond" cssClass="form-control" type="password" required="" placeholder="Re enter Password *"/>
                    <form:errors path="passwordsecond"  />
                </div>                
                <div class="form-group">
                    <form:input path="name" cssClass="form-control" required="" placeholder="First Name *"/>
                    <form:errors path="name" />
                </div>
                <div class="form-group">
                    <form:input path="lastname" cssClass="form-control" placeholder="Last Name"/>
                    <form:errors path="lastname" />
                </div>                    
                <div class="form-group">
                    <form:input path="company" cssClass="form-control" placeholder="Company name"/>
                    <form:errors path="company" />
                </div>
                <div class="form-group">   
                    <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                    <form:errors path="country" />                    
                </div>
                <div class="form-group">
                    <form:input path="city" cssClass="form-control" placeholder="City"/>
                    <form:errors path="city" />                    
                </div>
                <div class="form-group">
                    <form:input path="region" cssClass="form-control" placeholder="Region"/>
                    <form:errors path="region" />              
                </div>
                <div class="form-group">                    
                    <form:select path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                        
                    <form:errors path="timezone" />
                </div>                
                <div class="form-group">
                    <!--<input type="submit" class="btn btn-default submit" value="Submit"/>-->
                    <button class="btn btn-primary" type="submit"><i class="fa fa-2x fa-sign-out"></i> Sine Up</button>
                </div>
                <div class="clearfix"></div>

                <div class="separator">
                    <p class="change_link">Already a member ?
                        <c:url value="/login/" var="loginUrl" />
                        <a class="to_register" href="${loginUrl}"> Log in </a>
                    </p>
                </div>
            </form:form>           
        </div>
    </div>
</div>

