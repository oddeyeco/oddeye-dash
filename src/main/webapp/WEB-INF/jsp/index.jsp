<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor"  prefix="compress"%>
<compress:html removeIntertagSpaces="true" removeMultiSpaces="true"  compressCss="true" compressJavaScript="true">
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>    
    <c:set var="cp" value="${pageContext.request.servletContext.contextPath}" scope="request" />
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <sec:csrfMetaTags/>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <!-- Meta, title, CSS, favicons, etc. -->
            <link rel="shortcut icon" href="${cp}/assets/images/logo.png" type="image/x-icon">
            <link rel="icon" href="${cp}/assets/images/logo.png" type="image/x-icon">

            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">

            <title>${title}|oddeye.co</title>

            <!-- Bootstrap -->
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/bootstrap/bootstrap.css" />      
            <!-- Font Awesome -->
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/font-awesome.css" />
            <!-- iCheck -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/iCheck/skins/flat/green.css" />        
            <!-- bootstrap-progressbar -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css" />            
            <!-- Bootstrap Colorpicker -->
            <link href="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/css/bootstrap-colorpicker.min.css" rel="stylesheet" />
            <link href="${cp}/resources/cropper/dist/cropper.min.css" rel="stylesheet" /> 
            <!-- Select2 -->
            <link href="${cp}/resources/select2/dist/css/select2.min.css" rel="stylesheet">
            <!-- Bootstrap bootstrap-daterangepicker -->
            <link href="${cp}/resources/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet"> 
            <!-- Jsoneditor -->
            <link href="${cp}/resources/jsoneditor/dist/jsoneditor.min.css" rel="stylesheet" type="text/css">
            <!-- Custom Theme Style -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/build/css/custom.min.css" />   
            <link rel="stylesheet" type="text/css" href="${cp}/resources//switchery/dist/switchery.min.css" />
            <link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">     

            <link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css" />        
            <!--<link rel="stylesheet" type="text/css" href="${cp}/resources/css/site.css" />-->      
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/dash/maindash.css" />


        </head>

        <body class="nav-md">
            <div class="container body">
                <div class="main_container">
                    <div class="col-md-3 left_col">
                        <div class="left_col scroll-view">
                            <div class="navbar nav_title" style="border: 0;">
                                <a href="<c:url value="/"/>" >
                                    <img src="${cp}/assets/images/logowhite.png" alt="logo" width="65px" style="float: left">
                                    <span class="site_title" style="width: auto">Home</span> </a>
                            </div>
                            <div class="clearfix"></div>
                            <!-- menu profile quick info -->
                            <div class="profile">
                                <!--                            <div class="profile_pic">
                                                                <img src="" alt="..." class="img-circle profile_img">
                                                            </div>-->
                                <div class="profile_info">
                                    <span>Welcome,</span>
                                    <h2>${curentuser.getName()} ${curentuser.getLastname()}</h2>                           
                                </div>
                            </div>
                            <!-- /menu profile quick info -->

                            <div class="clearfix"></div>

                            <!-- sidebar menu -->
                            <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
                                <div class="menu_section">
                                    <h3>Navigation</h3>
                                    <ul class="nav side-menu">
                                        <li><a><i class="fa fa-home"></i> General <span class="fa fa-chevron-down"></span></a>
                                            <ul class="nav child_menu">                                            
                                                <li><a href="<c:url value="/monitoring"/>">Monitor</a></li>
                                                <li><a href="<c:url value="/errorsanalysis"/>">Advanced Monitoring</a></li>
                                            </ul>
                                        </li>
                                        <li><a><i class="fa fa-desktop"></i> Dashboards <span class="fa fa-chevron-down"></span></a>
                                            <ul class="nav child_menu">                                                                                        
                                                <li><a href="<c:url value="/dashboard/new"/>" id="newdush">New Dashboard</a></li>
                                                    <c:forEach items="${curentuser.getDushList()}" var="Dush">
                                                    <li><a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>">${Dush.key}</a></li>
                                                    </c:forEach>

                                            </ul>
                                        </li>
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <li><a><i class="fa fa-edit"></i> Managment <span class="fa fa-chevron-down"></span></a>
                                                <ul class="nav child_menu">                                                                                        
                                                    <sec:authorize access="hasRole('USERMANAGER')">
                                                        <li><a href="<c:url value="/userslist"/>" >Users</a></li>
                                                        </sec:authorize>
                                                        <sec:authorize access="hasRole('CONTENTMANAGER')">
                                                        <li><a href="<c:url value="/pages"/>" >Content</a></li>
                                                        </sec:authorize>
                                                        <sec:authorize access="hasRole('USERMANAGER')">
                                                        <li><a href="<c:url value="/templatelist"/>" >Templates</a></li>
                                                        </sec:authorize>                                                        
                                                </ul>
                                            </li>
                                        </sec:authorize>                                         
                                    </ul>
                                </div>
                            </div>
                            <!-- /sidebar menu -->

                            <!-- /menu footer buttons -->
                            <div class="sidebar-footer hidden-small">
                                <a data-toggle="tooltip" data-placement="top" title="Settings">
                                    <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                </a>
                                <a data-toggle="tooltip" data-placement="top" title="FullScreen">
                                    <span class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span>
                                </a>
                                <a data-toggle="tooltip" data-placement="top" title="Lock">
                                    <span class="glyphicon glyphicon-eye-close" aria-hidden="true"></span>
                                </a>
                                <a data-toggle="tooltip" data-placement="top" title="Logout">
                                    <span class="glyphicon glyphicon-off" aria-hidden="true"></span>
                                </a>
                            </div>
                            <!-- /menu footer buttons -->
                        </div>
                    </div>

                    <!-- top navigation -->
                    <div class="top_nav">
                        <div class="nav_menu">
                            <nav class="" role="navigation">
                                <div class="nav toggle">
                                    <a id="menu_toggle"><i class="fa fa-bars"></i></a>
                                </div>

                                <ul class="nav navbar-nav navbar-right">
                                    <li class="">
                                        <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                            <!--<img src="${cp}/resources/images/img.jpg" alt="">-->${curentuser.getEmail()}
                                            <span class=" fa fa-angle-down"></span>
                                        </a>
                                        <ul class="dropdown-menu dropdown-usermenu pull-right">
                                            <li><a href="<c:url value="/profile"/>"> Profile</a></li>
                                            <li>
                                                <a href="<c:url value="/dashboard/"/>">
                                                    <span>Dashboards</span>
                                                </a>
                                            </li>
                                            <li><a href="javascript:;">Help</a></li>
                                                <c:url value="/logout/" var="logoutUrl" />

                                            <li><a href="${logoutUrl}"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
                                        </ul>
                                    </li>                                
                                </ul>
                            </nav>
                        </div>
                    </div>
                    <!-- /top navigation -->

                    <!-- page content -->
                    <div class="right_col" role="main">                    
                        <c:if test="${!curentuser.getActive()}">
                            <div class="clearfix"></div>
                            <div class="alert alert-danger alert-dismissible fade in " role="alert">
                                You are not activate.
                            </div>
                        </c:if>                                         
                        <c:catch var="e">
                            <c:import url="${body}.jsp" />
                        </c:catch>
                        <c:if test="${!empty e}">                            
                            <c:import url="errors/pageerror.jsp" />
                        </c:if>                    
                    </div>

                    <!-- /page content -->

                    <!-- footer content -->
                    <footer>
                        <div class="clearfix"></div>
                    </footer>
                    <!-- /footer content -->
                </div>
            </div>

            <!-- jQuery -->
            <script src="<c:url value="/assets/dist/jquery.min.js"/>"></script>    

            <script src="${cp}/assets/dist/switchery.min.js"></script>
            <script src="${cp}/assets/dist/jquery.autocomplete.min.js"></script>        
            <script src="${cp}/assets/dist/jquery.spincrement.min.js"></script>        

            <!-- Bootstrap -->
            <script src="${cp}/resources/bootstrap/dist/js/bootstrap.min.js"></script>
            <!-- moment.js -->
            <script src="${cp}/resources/js/moment/moment.min.js"></script>        
            <!--bootstrap-progressbar--> 
            <script src="${cp}/resources/bootstrap-progressbar/bootstrap-progressbar.min.js"></script>
            <!--iCheck--> 
            <script src="${cp}/resources/iCheck/icheck.min.js"></script>
            <!-- Bootstrap Colorpicker -->
            <script src="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/js/bootstrap-colorpicker.min.js"></script>
            <!-- Bootstrap bootstrap-daterangepicker -->
            <script src="${cp}/resources/bootstrap-daterangepicker/daterangepicker.js"></script>        
            <!-- Custom Theme Scripts -->
            <script src="${cp}/resources/build/js/custom.min.js"></script>
            <!-- Select2 -->
            <script src="${cp}/resources/select2/dist/js/select2.full.min.js"></script>

            <script src="${cp}/resources/js/global.js"></script>        

            <c:catch var="e">
                <c:import url="${jspart}.jsp" />
            </c:catch>
            <c:if test="${not empty path}">
                <c:catch var="e">
                    <c:import url="${path}js.jsp" />
                </c:catch>                        
            </c:if>
            <script>
                $(function () {
                    $MENU_TOGGLE.on('click', function () {
                        $(window).resize();
                    });
                });
                var cp = "${cp}";
            </script>
        </body>
    </html>
</compress:html>