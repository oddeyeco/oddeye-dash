<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<div id="main"></div>
<div id="confirmTrue" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><spring:message code="login.Confirmationsucceed"/></h4>
            </div>
            <div class="modal-body">
                <spring:message code="login.Confirmationsucceedbody"/>
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
                <h4 class="modal-title"><spring:message code="login.Confirmationfail"/></h4>
            </div>
            <div class="modal-body">
                <spring:message code="login.Confirmationfailbody"/>
            </div>
            <div class="modal-footer">
                <input   type="button" class="btn btn-success " data-dismiss="modal"value="OK">
            </div>
        </div>
    </div>
</div>

<div class="container center logincontener" >    
    <div>
        <div class="col-sm-6 col-xs-12 logo">
            <div class="progress-wrap">
                <div class="progress">
                    <div class="progress-bar progress-bar-striped active" role="progressbar"
                         aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%">
                        <spring:message code="loading"/>
                    </div>
                </div>            
            </div>            
            <a href="https://www.oddeye.co/" ><img src="${cp}/assets/images/logowhite.png" alt="logo" width="250px"></a>                
        </div>    
        <div class=" contactform col-sm-6 col-xs-12 login"> 
            <form action="<c:url value="/login/"/>" method="post" class="form-horizontal" id="loginform">                
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger" role="alert">
                        <spring:message code="login.fail"/>                        
                    </div>                                  
                </c:if>              
                <div class="form-group">        
                    <input type="email" class="form-control" id="username" name="username" aria-describedby="emailHelp" placeholder="<spring:message code="login.entermail"/>" required="">                
                    <!--<small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>-->
                </div>
                <div class="form-group">                
                    <input type="password" class="form-control" id="password" name="password" placeholder="<spring:message code="login.password"/>" required="">
                </div>
                <div class="form-group">                
                    <input type="checkbox" name="remember-me" class="flat" id="remember-me"/><label for="remember-me" class="remember-me"><spring:message code="login.rememberme"/></label>
                </div>  
                <div class="form-group">  
                    <input type="hidden"                
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}"/>                           
                    <button class="btn btn-primary btn-block" type="submit"><spring:message code="login"/></button>
                    <c:if test="${param.error != null}">                        
                        <!--<a href="<c:url value="/preset"/>" class="btn btn-warning btn-block">Reset password</a>-->
                    </c:if>                      
                    <div class="pull-left"><spring:message code="login.isnew"/><a href="<c:url value="/signup/"/>" class="btn btn-href btn-sm"><spring:message code="createaccount"/></a>

                    </div>              
                </div>              
            </form>

        </div>
    </div>
</div>