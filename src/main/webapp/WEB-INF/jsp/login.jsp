<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <div class="login_wrapper">
        <div class="animate form login_form">
            <section class="login_content">
                <c:url value="/login" var="loginUrl"/>
                <form action="${loginUrl}" method="post">             
                    <h1>Login Form</h1>
                    <c:if test="${param.error != null}">
                        <p>
                            Invalid username and password.
                        </p>
                    </c:if>              
                    <div>
                        <input id="username" name="username" type="text" class="form-control" placeholder="Username" required="" />
                    </div>
                    <div>
                        <input id="password" name="password" type="password" class="form-control" placeholder="Password" required="" />
                    </div>
                    <div>                        
                        <button class="btn btn-default submit" type="submit" class="btn">Log in</button>
                        <!--<a class="reset_pass" href="#">Lost your password?</a>-->
                    </div>
                    <input type="hidden"                
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}"/>
                    <div class="clearfix"></div>

                    <div class="separator">
                        <p class="change_link">New to site?
                            <a href="#signup" class="to_register"> Create Account </a>
                        </p>

                        <div class="clearfix"></div>
                        <br />
                    </div>
                </form>
            </section>
        </div>
    </div>
</div>

