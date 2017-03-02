<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>    
    <div class="container contactform center col-lg-4 col-md-8 col-xs-12">
        <h2 class="text-center">Login.</h2>

        <form action="${loginUrl}" method="post">
            <c:if test="${param.error != null}">
                <div class="alert alert-danger" role="alert">
                    <strong>Oh!</strong> Invalid username and password.
                </div>                
            </c:if>              
            <div class="form-group">                
                <input type="email" class="form-control" id="username" aria-describedby="emailHelp" placeholder="Enter email" required="">                
                <!--<small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>-->
            </div>
            <div class="form-group">                
                <input type="password" class="form-control" id="password" placeholder="Password" required="">
            </div>
            <input type="hidden"                
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}"/>                           
            <button class="btn btn-primary btn-block" type="submit"><i class="fa fa-2x fa-sign-in"></i> Log in </button>
            <div class="pull-left">New to site?<a href="${sineupUrl}" class="to_register"> Create Account </a>                
            </div>              
        </form>

    </div>
</div>
