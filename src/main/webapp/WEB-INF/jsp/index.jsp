<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Oddeye Dashboard! | </title>

        <!-- Bootstrap -->
        <link rel="stylesheet" type="text/css" href="${cp}/assets/css/bootstrap/bootstrap.css" />      
        <!-- Font Awesome -->
        <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/font-awesome.css" />
        <!-- iCheck -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/iCheck/skins/flat/green.css" />        
        <!-- bootstrap-progressbar -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css" />            
        <!-- jVectorMap -->
        <link href="${cp}/resources/css/maps/jquery-jvectormap-2.0.3.css" rel="stylesheet"/>

        <!-- Bootstrap Colorpicker -->
        <link href="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/css/bootstrap-colorpicker.min.css" rel="stylesheet" />
        <link href="${cp}/resources/cropper/dist/cropper.min.css" rel="stylesheet" /> 
        <!-- Select2 -->
        <link href="${cp}/resources/select2/dist/css/select2.min.css" rel="stylesheet">
        <!-- Custom Theme Style -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/build/css/custom.min.css" />        
        <link rel="stylesheet" type="text/css" href="${cp}/resources/css/site.css" />        


    </head>

    <body class="nav-md">
        <div class="container body">
            <div class="main_container">
                <div class="col-md-3 left_col">
                    <div class="left_col scroll-view">
                        <div class="navbar nav_title" style="border: 0;">
                            <a href="<c:url value="/"/>" class="site_title"><i class="fa fa-paw"></i> <span>Oddeye Dashboard!</span></a>
                        </div>

                        <div class="clearfix"></div>

                        <!-- menu profile quick info -->
                        <div class="profile">
                            <div class="profile_pic">
                                <img src="${cp}/resources/images/img.jpg" alt="..." class="img-circle profile_img">
                            </div>
                            <div class="profile_info">
                                <span>Welcome,</span>
                                <h2>${curentuser.getName()} ${curentuser.getLastname()}</h2>
                            </div>
                        </div>
                        <!-- /menu profile quick info -->

                        <br />

                        <!-- sidebar menu -->
                        <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
                            <div class="menu_section">
                                <h3>General</h3>
                                <ul class="nav side-menu">
                                    <li><a><i class="fa fa-home"></i> General <span class="fa fa-chevron-down"></span></a>
                                        <ul class="nav child_menu">                                            
                                            <li><a href="<c:url value="/fastmonitor"/>">Monitor</a></li>
                                            <li><a href="<c:url value="/monitoring"/>">Advanced Monitoring</a></li>
<!--                                            <li><a href="<c:url value="/hosts"/>">Hosts</a></li>
                                            <li><a href="<c:url value="/metrics"/>">Metrics</a></li>-->
                                            <!--<li><a href="<c:url value="/dashboard3/"/>">Dashboard3</a></li>-->
                                        </ul>
                                    </li>
                                    <li><a><i class="fa fa-desktop"></i> Dashboards <span class="fa fa-chevron-down"></span></a>
                                        <ul class="nav child_menu">                                                                                        
                                            <li><a href="<c:url value="/dashboard/new"/>" id="newdush">New Dashboard</a></li>
                                                <c:forEach items="${curentuser.getDushList()}" var="Dush">
                                                <li><a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" id="newdush">${Dush.key}</a></li>
                                                </c:forEach>

                                        </ul>
                                    </li>
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
                                        <img src="${cp}/resources/images/img.jpg" alt="">${curentuser.getEmail()}
                                        <span class=" fa fa-angle-down"></span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-usermenu pull-right">
                                        <li><a href="<c:url value="/profile"/>"> Profile</a></li>
                                        <li>
                                            <a href="<c:url value="/dashboard/new"/>">
                                                <span>New Dashboard</span>
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
                    <jsp:include page="${body}.jsp" />
                </div>

                <!-- /page content -->

                <!-- footer content -->
                <footer>
                    <div class="pull-right">
                        Gentelella - Bootstrap Admin Template by <a href="https://colorlib.com">Colorlib</a>
                    </div>
                    <div class="clearfix"></div>
                </footer>
                <!-- /footer content -->
            </div>
        </div>

        <!-- jQuery -->
        <script src="${cp}/resources/jquery/dist/jquery.min.js"></script>
        <!-- Bootstrap -->
        <script src="${cp}/resources/bootstrap/dist/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="${cp}/resources/fastclick/lib/fastclick.js"></script>
        <!-- NProgress -->
        <script src="${cp}/resources/nprogress/nprogress.js"></script>
        <!-- Chart.js -->
        <script src="${cp}/resources/js/moment/moment.min.js"></script>
        <script src="${cp}/resources/Chart.js/dist/Chart.min.js"></script>
        <!-- gauge.js -->
        <script src="${cp}/resources/gauge.js/dist/gauge.min.js"></script>
        <!-- bootstrap-progressbar -->
        <script src="${cp}/resources/bootstrap-progressbar/bootstrap-progressbar.min.js"></script>
        <!-- iCheck -->
        <script src="${cp}/resources/iCheck/icheck.min.js"></script>
        <!-- Skycons -->
        <script src="${cp}/resources/skycons/skycons.js"></script>
        <!-- bootstrap-daterangepicker -->       
        <script src="${cp}/resources/js/datepicker/daterangepicker.js"></script>
        <!-- Bootstrap Colorpicker -->
        <script src="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/js/bootstrap-colorpicker.min.js"></script>
        <!-- Custom Theme Scripts -->
        <!-- Cropper -->
        <script src="${cp}/resources/cropper/dist/cropper.min.js"></script>        
        <script src="${cp}/resources/build/js/custom.min.js"></script>
        <!-- Select2 -->
        <script src="${cp}/resources//select2/dist/js/select2.full.min.js"></script>

        <script src="${cp}/resources/js/global.js"></script>

        <jsp:include page="${jspart}.jsp" />
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