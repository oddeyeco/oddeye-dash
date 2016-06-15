<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <div class="login_wrapper">
        <div id="register" class="form-horizontal">
            <!--<form method="post" action="/" novalidate="">--> 
            <form:form method="post" commandName="newUser" modelAttribute="newUser" novalidate="true">
                <h1>Create Account</h1>
                <div class="form-group">
                    <form:input path="email" cssClass="form-control" type="email" required="" placeholder="E-Mail *"/>                    
                    <ul id="parsley-id-5" class="parsley-errors-list filled">
                        <li class="parsley-required"><form:errors path="email" /></li>
                    </ul>                    

                </div>
                <div class="form-group">
                    <form:input path="password" cssClass="form-control" type="password" required="" placeholder="Password *"/>
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        <li class="parsley-required"><form:errors path="password" /></li>
                    </ul> 
                </div>
                <div class="form-group">
                    <form:input path="passwordsecond" cssClass="form-control" type="password" required="" placeholder="Re enter Password *"/>
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        <li class="parsley-required"><form:errors path="passwordsecond"  /></li>
                    </ul> 
                </div>                
                <div class="form-group">
                    <form:input path="name" cssClass="form-control" required="" placeholder="First Name *"/>
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        
                        <li class="parsley-required"><form:errors path="name" /></li>
                    </ul> 
                </div>
                <div class="form-group">
                    <form:input path="lastname" cssClass="form-control" placeholder="Last Name"/>
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        
                        <li class="parsley-required"><form:errors path="lastname" /></li>
                    </ul> 
                </div>                    
                <div class="form-group">
                    <form:input path="company" cssClass="form-control" placeholder="Company name"/>
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        
                        <li class="parsley-required"><form:errors path="company" /></li>
                    </ul> 
                </div>
                <div class="form-group">   
                    <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        
                        <li class="parsley-required"><form:errors path="country" /></li>
                    </ul> 
                </div>
                <div class="form-group">
                    <form:input path="city" cssClass="form-control" placeholder="City"/>
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        
                        <li class="parsley-required"><form:errors path="city" /></li>
                        </ul> 

                        <!--<input type="text" class="form-control" placeholder="City"/>-->
                </div>
                <div class="form-group">
                    <form:input path="region" cssClass="form-control" placeholder="Region"/>
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        
                        <li class="parsley-required"><form:errors path="region" /></li>
                    </ul>                                      
                </div>
                <div class="form-group">                    
                    <form:select path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                        
                    <ul id="parsley-id-5" class="parsley-errors-list filled">                        
                        <li class="parsley-required"><form:errors path="timezone" /></li>
                    </ul> 
                </div>                
                <div class="form-group">
                    <input type="submit" class="btn btn-default submit" value="Submit"/>
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

