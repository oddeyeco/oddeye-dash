<%-- 
    Document   : noautwraper
    Created on : Dec 7, 2017, 1:06:52 PM
    Author     : vahan
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container body">
    <div class="main_container">
        <div id="fix" class="col-md-3 left_col">
            <div class="left_col scroll-view">
                <div class="navbar nav_title" style="border: 0;">
                    <a href="<c:url value="/"/>" >
                        <img src="${cp}/assets/images/logowhite.png" alt="logo" width="65px" style="float: left">
                        <span class="site_title" style="width: auto">Home</span> </a>
                </div>
                <div class="clearfix"></div>
                <!-- sidebar menu -->
                <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
                    <div class="menu_section">
                        <!--<h3>Navigation</h3>-->
                        <ul class="nav side-menu">
                            <li><a  href="https://www.oddeye.co/"><i class="fa fa-home" aria-hidden="true"></i>Home</a></li>
                            <li><a href="https://www.oddeye.co/documentation/"><i class="fa fa-info-circle" aria-hidden="true"></i>About</a></li>
                        </ul>
                    </div>
                </div>
                <!-- /sidebar menu -->
            </div>
        </div>
        <!-- top navigation -->
        <div class="top_nav">
            <div class="nav_menu">
                <nav class="nav" role="navigation">
                    <!--                    <div class="nav toggle">
                                            <a id="menu_toggle"><i class="fa fa-bars"></i></a>
                                        </div>-->

                    <ul class="nav navbar-nav navbar-right">
                        
                        <li><a class="try-now" href="${cp}/signup/" >Try Now Free!</a></li>
                        <li><a data-toggle="modal" data-target="#loginModal">Login</a></li>
                    </ul>                    
                </nav>
            </div>
        </div>
        <!-- /top navigation -->

        <!-- page content -->
        <div class="right_col" role="main">                                                              
            <c:catch var="e">
                <c:import url="${body}.jsp" />
            </c:catch>
            <c:if test="${!empty e}">                            
                <c:import url="errors/pageerror.jsp" />
            </c:if>                    
        </div>
    </div>
</div>

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
                        <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
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
                        <div class="pull-left">New to site?<a href="<c:url value="/signup/"/>" class="btn btn-href btn-sm"> Create Account </a>                
                        </div>              
                    </div>              
                </form>
            </div>

        </div>
    </div>
</div>