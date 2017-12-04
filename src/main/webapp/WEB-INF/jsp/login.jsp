<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="main"></div>
<div id="confirmTrue" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation succeed</h4>
            </div>
            <div class="modal-body">
                <p>Your email address has been successfully confirmed.</p>
                <p>Please use your credentials to login.</p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-success " data-dismiss="modal"value="OK">
            </div>
        </div>
    </div>
</div>

<div id="confirmFalse" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation failed</h4>
            </div>
            <div class="modal-body">
                <p>Your email address has already been confirmed.</p>
                <p>Please use your credentials to login.</p>
                <p class="text-warning"></p>
            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-success " data-dismiss="modal"value="OK">
            </div>
        </div>
    </div>
</div>

<div class="container center logincontener" >    
    <div class="row">
        <div class="col-sm-6 col-xs-12 logo">
            <div class="progress-wrap">
                <div class="progress">
                    <div class="progress-bar progress-bar-striped active" role="progressbar"
                         aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%">
                        Loading...
                    </div>
                </div>            
            </div>            
            <a href="https://www.oddeye.co/" ><img src="${cp}/assets/images/logowhite.png" alt="logo" width="250px"></a>                
        </div>    
        <div class=" contactform col-sm-6 col-xs-12 login"> 
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
                    <button class="btn btn-primary btn-block" type="submit"><i class="fa fa-2x fa-sign-in"></i> Log in </button>
                    <div class="pull-left">New to site?<a href="<c:url value="/signup/"/>" class="btn btn-href btn-sm"> Create Account </a>                
                    </div>              
                </div>              
            </form>

        </div>
    </div>
</div>