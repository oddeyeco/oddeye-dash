<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container center" style="padding-top: 100px;position: absolute; left: 25%; top: 25%;">    
    <div class="row">
        <div class="col-lg-4 col-xs-12 text-right">
            <a href="${cp}/" ><img src="${cp}/assets/images/logo.png" alt="logo" width="250px"></a>                
        </div>    
        <div class=" contactform col-lg-6 col-xs-12">        
            <form action="<c:url value="/login/"/>" method="post">
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger" role="alert">
                        <strong>Oh!</strong> Invalid username and password.
                    </div>                
                </c:if>              
                <div class="form-group">                
                    <input type="email" class="form-control" id="username" name="username" aria-describedby="emailHelp" placeholder="Enter email" required="">                
                    <!--<small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>-->
                </div>
                <div class="form-group">                
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required="">
                </div>
                <input type="hidden"                
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}"/>                           
                <button class="btn btn-primary btn-block" type="submit"><i class="fa fa-2x fa-sign-in"></i> Log in </button>
                <div class="pull-left">New to site?<a href="<c:url value="/signup/"/>" class="to_register"> Create Account </a>                
                </div>              
            </form>

        </div>
    </div>
</div>