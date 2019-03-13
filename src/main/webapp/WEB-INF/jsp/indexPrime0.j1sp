<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="cp" value="${pageContext.request.servletContext.contextPath}" scope="request" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <title>OddEye Monitoring System </title>

        <!-- Google fonts -->
        <link href='//fonts.googleapis.com/css?family=Roboto:400,300,700' rel='stylesheet' type="text/css">

        <!-- Bootstrap -->
        <link rel="stylesheet" type="text/css" href="${cp}/assets/css/bootstrap/bootstrap.css?v=${version}" />    
        <!-- Font Awesome -->
        <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/font-awesome.css?v=${version}" />        

        <!-- animate.css -->
        <link rel="stylesheet" href="${cp}/resources/assets/animate/animate.css?v=${version}" />
        <link rel="stylesheet" href="${cp}/resources/assets/animate/set.css?v=${version}" />

        <!-- gallery -->
        <link rel="stylesheet" href="${cp}/resources/assets/gallery/blueimp-gallery.min.css?v=${version}">

        <!-- favicon -->
        <link rel="shortcut icon" href="${cp}/resources/images/favicon.ico" type="image/x-icon">
        <link rel="icon" href="${cp}/resources/images/favicon.ico" type="image/x-icon">


        <link rel="stylesheet" href="${cp}/resources/assets/style.css?v=${version}">      


        <link rel="stylesheet" href="${cp}/assets/css/main.css?v=${version}">    
    </head>

    <body>
        <div class="topbar animated fadeInLeftBig"></div>

        <!-- Header Starts -->
        <div class="navbar-wrapper">
            <div class="container">

                <div class="navbar navbar-default navbar-fixed-top" role="navigation" id="top-nav">
                    <div class="container">
                        <div class="navbar-header">
                            <!-- Logo Starts -->
                            <a class="navbar-brand" href="${cp}#home"><img src="${cp}/resources/images/logo.png" alt="logo"></a>
                            <!-- #Logo Ends -->


                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
                                <span class="sr-only">Toggle navigation</span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>

                        </div>


                        <!-- Nav Starts -->
                        <div class="navbar-collapse  collapse">
                            <c:if test="${isAuthentication}">
                                <ul class="nav navbar-nav navbar-right">
                                    <li class="">
                                        <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                            ${curentuser.getEmail()}
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
                            </c:if>                              


                            <ul class="nav navbar-nav navbar-right scroll">
                                <li class="active"><a href="${cp}#home">Home</a></li>
                                <li ><a href="${cp}#about">About</a></li>                                
                                <li ><a href="${cp}#partners">Partners</a></li>
                                <li ><a href="${cp}#contact">Contact</a></li>                 
                            </ul>                            
                        </div>
                        <!-- #Nav Ends -->
                    </div>


                </div>

            </div>
        </div>
        <!-- #Header Starts -->

        <jsp:include page="${body}.jsp" />

        <!-- Footer Starts -->
        <div class="footer text-center spacer">
            <p class="wowload flipInX"><a href="#"><i class="fa fa-facebook fa-2x"></i></a> <a href="#"><i class="fa fa-dribbble fa-2x"></i></a> <a href="#"><i class="fa fa-twitter fa-2x"></i></a> <a href="#"><i class="fa fa-linkedin fa-2x"></i></a> </p>
            Copyright 2016 OddEye. All rights reserved.
        </div>
        <!-- # Footer Ends -->
        <a href="#home" class="gototop "><i class="fa fa-angle-up  fa-3x"></i></a>





        <!-- The Bootstrap Image Gallery lightbox, should be a child element of the document body -->
        <div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls">
            <!-- The container for the modal slides -->
            <div class="slides"></div>
            <!-- Controls for the borderless lightbox -->
            <h3 class="title">title</h3>
            <a class="prev">‹</a>
            <a class="next">›</a>
            <a class="close">×</a>
            <!-- The modal dialog, which will be used to wrap the lightbox content -->    
        </div>



        <!-- jquery -->
        <script src="${cp}/resources/assets/jquery.js?v=${version}"></script>

        <!-- wow script -->
        <script src="${cp}/resources/assets/wow/wow.min.js?v=${version}"></script>


        <!-- boostrap -->
        <script src="${cp}/resources/assets/bootstrap/js/bootstrap.js?v=${version}" type="text/javascript" ></script>

        <!-- jquery mobile -->
        <script src="${cp}/resources/assets/mobile/touchSwipe.min.js?v=${version}"></script>
        <script src="${cp}/resources/assets/respond/respond.js?v=${version}"></script>

        <!-- gallery -->
        <script src="${cp}/resources/assets/gallery/jquery.blueimp-gallery.min.js?v=${version}"></script>

        <!-- custom script -->
        <script src="${cp}/resources/assets/script.js?v=${version}"></script>

    </body>
</html>