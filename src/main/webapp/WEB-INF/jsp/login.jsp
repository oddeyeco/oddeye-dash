<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="contact" class="spacer">    
    <div class="container contactform center">
        <h2 class="text-center  wowload fadeInUp">Login Form.</h2>

        <div class="row wowload fadeInLeftBig">      
            <c:url value="/login" var="loginUrl"/>
            <c:url value="/signup/" var="sineupUrl"/>
            <form action="${loginUrl}" method="post">
                <div class="col-sm-6 col-sm-offset-3 col-xs-12">   
                    <c:if test="${param.error != null}">
                        <p class="text-center">
                            Invalid username and password.
                        </p>
                    </c:if>                  
                    <input id="username" name="username" type="text" class="form-control" placeholder="Username" required="" />
                    <input id="password" name="password" type="password" class="form-control" placeholder="Password" required="" />                
                    <button class="btn btn-primary" type="submit"><i class="fa fa-2x fa-sign-in"></i> Log in </button>
                    <input type="hidden"                
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}"/>
                    <div class="clearfix"></div>                    
                    <div class="separator">
                        <p class="change_link">New to site?
                            <a href="${sineupUrl}" class="to_register"> Create Account </a>
                        </p>
                        <div class="clearfix"></div>
                        <br />
                    </div>

                </div>
            </form>             
        </div>
    </div>
</div>
