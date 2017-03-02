<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="cp" value="${pageContext.request.servletContext.contextPath}" scope="request" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>${title} | oddeye.co </title>
        <link rel="shortcut icon" href="${cp}/assets/images/logo.png" type="image/x-icon">
        <link rel="icon" href="${cp}/assets/images/logo.png" type="image/x-icon">
        
        <!-- Bootstrap core CSS -->
        <link rel="stylesheet" href="<c:url value="/assets/bootstrap4/css/bootstrap.min.css"/>" />
        <link rel="stylesheet" href="<c:url value="/assets/css/general.css"/>" />

    </head>

    <body>        
        <!--<header class="">-->
        <div >
            <header class="container">
            <nav class="navbar navbar-light navbar-toggleable-sm">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#containermenu" aria-controls="containermenu" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="containerlogo">
                    <a class="navbar-brand" href="${cp}#home"><img src="${cp}/assets/images/logo.png" alt="logo"></a>
                </div>
                <div class="collapse navbar-collapse justify-content-md-end" id="containermenu">                    
                    <ul class="navbar-nav">              
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/"/>">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/about/"/>">About</a></li>                                
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/pricing/"/>">Pricing</a></li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/documentation/"/>">Documentation</a></li>   
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/faq/"/>">FAQ</a></li>   
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/contact/"/>">Contact</a></li>   
                            <c:if test = "${isAuthentication == false }">
                            <li class="nav-item"><a class="btn btn-success" style="white-space: nowrap;margin:0px 5px" href="<c:url value="/signup/"/>">Start free</a></li>   
                            <li class="nav-item"><a class="btn btn-primary" style="white-space: nowrap;margin:0px 5px" href="<c:url value="/login/"/>">Login</a></li>   
                            </c:if>   
                            <c:if test="${isAuthentication}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="dropdown05" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span>${curentuser.getEmail()}</span></a>
                                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdown05">
                                    <a class="dropdown-item" href="<c:url value="/profile"/>"> Profile</a>
                                    <a class="dropdown-item" href="<c:url value="/dashboard/new"/>">New Dashboard</a>
                                    <a class="dropdown-item" href="javascript:;">Help</a>
                                    <c:url value="/logout/" var="logoutUrl" />
                                    <a class="dropdown-item"href="${logoutUrl}"><i class="fa fa-sign-out pull-right"></i> Log Out</a>
                                </div>
                            </li>
                        </c:if>    

                    </ul>
                </div>
            </nav>                            
    </header>    
    <main>            
        <c:catch var="e">
            <c:import url="PublicPages/${body}.jsp" />
        </c:catch>
        <c:if test="${!empty e}">
            ${body} <c:import url="errors/pageerror.jsp" />
        </c:if>             
    </main>
    <footer>

    </footer>
</div>
    <script src="<c:url value="/assets/js/jquery-3.1.1.min.js"/>"></script>    
    <script src="<c:url value="/assets/js/tether.min.js"/>"></script>        
    <script src="<c:url value="/assets/bootstrap4/js/bootstrap.min.js"/>"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <!--<script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>-->                            
    
    <script src="<c:url value="/assets/js/general.js"/>"></script>        
    <c:catch var="e">
        <c:import url="PublicPages/${jspart}.jsp" />
    </c:catch>
</body>

</html>