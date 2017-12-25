<%-- 
    Document   : noautwraper
    Created on : Dec 7, 2017, 1:06:52 PM
    Author     : vahan
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<nav class="navbar navbar-oddeye navbar-inverse  navbar-fixed-top"  role="navigation" >

    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="calc-logo navbar-brand" href="https://www.oddeye.co/"><img src="/OddeyeCoconut/assets/images/logowhite.png" alt="logo" width="65px" style="float: left"></a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav">

                <li><a   href="https://www.oddeye.co/"><span class="glyphicon glyphicon-home" aria-hidden="true"></span> Home</a></li>
                <li><a href="https://www.oddeye.co/documentation/"> <span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> About</a></li>
<!--                <li class="dropdown">
                    <a href="index.html" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"> 
                        <span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span> Documentation <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="https://www.oddeye.co/documentation/barlus/">Api</a></li>
                        <li><a href="https://www.oddeye.co/documentation/app/account/">App</a></li>
                        <li><a href="https://www.oddeye.co/documentation/puypuy/puypuy/">Agent</a></li>
                        <li><a href="contactus.html#">SQl</a></li>
                        <li role="separator" class="divider"></li>
                        <li class="dropdown-header">PHP</li>
                        <li><a href="contactus.html#">MySQl</a></li>

                    </ul>
                </li>-->
                <!--<li><a href="#"><span class="fa fa-envelope-o"></span> Contact</a></li>-->
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a data-toggle="modal" data-target="#loginModal"><span class="glyphicon glyphicon-log-in"></span> login</a></li>
                <li><a class="calc-button  " href="https://app.oddeye.co/OddeyeCoconut/signup/" >Try Now Free!</a></li>
            </ul>

        </div>
    </div>
</nav>

<div id="loginModal" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content modal_margin">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"> &times;</button>
                <h4>Login</h4>
            </div>
            <div class="modal-body modal_margin ">
                <form action="<c:url value="/login/"/>" method="post" class="form-horizontal" id="loginform">                
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
                    <div class="form-group">                
                        <input type="checkbox" name="remember-me" class="flat" id="remember-me"/><label for="remember-me" class="remember-me"> Remember Me</label>
                    </div>  
                    <div class="form-group">  
                        <input type="hidden"                
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}"/>    

                        <button class="btn btn-primary btn-block" type="submit"> Log in </button>
                        <!--<div class="pull-left">New to site?<a href="<c:url value="/signup/"/>" class="btn btn-href btn-sm"> Create Account </a>-->                
                    </div>              
            </div>              
            </form>
        </div>

    </div>
</div>
</div>



<div>
    <c:catch var="e">
        <c:import url="${body}.jsp" />
    </c:catch>
    <c:if test="${!empty e}">
        ${body} <c:import url="errors/pageerror.jsp" />
    </c:if>  
</div> 
