<%-- 
    Document   : indexOE
    Created on : Apr 15, 2019, 6:16:20 PM
    Author     : tigran
--%>
<%@page import="java.net.InetAddress"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor"  prefix="compress"%>
<compress:html removeIntertagSpaces="true" removeMultiSpaces="true"  compressCss="true" compressJavaScript="true">    
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>    
    <%@ taglib prefix="udf" uri="https://app.oddeye.co/OddeyeCoconut/oddeyetaglib" %>
    <c:set var="version" value="0.2.16" scope="request"/>
    <c:set var="cp" value="${pageContext.request.servletContext.contextPath}" scope="request" />
    <c:set var="whitelabel" value="${whitelabel.getWhitelabelModel()}" scope="request"/>
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
            <c:if test="${!empty ogimage}">                        
                <c:set var="image" value="${ogimage}" scope="request" />
            </c:if>              
            <meta property="og:image" content="https://${pageContext.request.getHeader("X-OddEye-Host")}${cp}/assets/images/${image}" />   
            <title>${title}|oddeye.co</title>

            <!-- Bootstrap -->  
<!--            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/bootstrap/bootstrap.css?v=${version}" />-->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap/dist/bootstrap-4.3.1/css/bootstrap.min.css?v=${version}" />

            <!-- Font Awesome -->
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/solid.css?v=${version}" />
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/regular.css?v=${version}" />
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/fontawesome.css?v=${version}" />
            <!-- iCheck -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/iCheck/skins/flat/_all.css?v=${version}" />        
            <!-- bootstrap-progressbar -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css?v=${version}" />            
            <!-- Bootstrap Colorpicker -->
            <link href="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/css/bootstrap-colorpicker.min.css?v=${version}" rel="stylesheet" />
            <link href="${cp}/resources/cropper/dist/cropper.min.css?v=${version}" rel="stylesheet" /> 
            <!-- Select2 -->
<!--            <link href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}" rel="stylesheet">-->
            <!-- Bootstrap bootstrap-daterangepicker -->
            <link href="${cp}/resources/bootstrap-daterangepicker/daterangepicker.css?v=${version}" rel="stylesheet"> 
            <!-- Jsoneditor -->
            <link href="${cp}/resources/jsoneditor/dist/jsoneditor.min.css?v=${version}" rel="stylesheet" type="text/css">
            <!-- Custom Theme Style -->
<!--            <link rel="stylesheet" type="text/css" href="${cp}/resources/build/css/custom.min.css?v=${version}" />  -->
<!--            <link rel="stylesheet" type="text/css" href="../assets/css/customOE.css" />-->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />
            <link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css?v=${version}" rel="stylesheet">     

            <link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />      
            <!--<link rel="stylesheet" type="text/css" href="${cp}/resources/css/site.css?v=${version}" />-->      
            
            <c:if test="${empty curentuser.getTemplate()}" >
<!--                <link rel="stylesheet" type="text/css" href="${cp}/assets/css/dash/maindash.css?v=${version}" />-->
                <link rel="stylesheet" type="text/css" href="${cp}/assets/css/styleOE.css?v=${version}" />
            </c:if>                        

            <c:if test="${not empty curentuser.getTemplate()}" >
                <link rel="stylesheet" type="text/css" href="${cp}/assets/css/dash/maindash.css?v=${version}" />        
                <link rel="stylesheet" type="text/css" href="${cp}/assets/css/styleOE.css?v=${version}" />        
                <c:choose>
                    <c:when test="${curentuser.getTemplate() == 'dark'}">                                        
                        <link rel="stylesheet" type="text/css" href="${cp}/assets/css/dash/dark_theme.css?v=${version}" />                   
                    </c:when>
                    <c:when test="${curentuser.getTemplate() == 'dark2'}">                                        
                        <link rel="stylesheet" type="text/css" href="${cp}/assets/css/dash/dark_theme2.css?v=${version}" />
                    </c:when>                        
                    <c:otherwise>                      
                    </c:otherwise>                                                    
                </c:choose>
            </c:if>            

            <c:if test="${not empty whitelabel}" >                
                <link rel="stylesheet" href="<c:url value="${whitelabel.getFullfileName()}${whitelabel.cssfilename}?v=${version}"/>" />
            </c:if> 

        </head>

        <body class="<c:if test="${cookie['small'].value != 'true'}">nav-md</c:if> <c:if test="${cookie['small'].value == 'true'}">nav-sm</c:if>">
                <div class="wrapper">
                    <!-- Sidebar  -->
                    <nav id="sidebar">
                        <div class="sidebar-header text-center">
                                <a class="navbar-brand mr-0" href="<c:url value='/'/>">
                            <c:if test="${empty whitelabel}" >
                                <img src="${cp}/assets/images/logowhite.png" alt="logo" width="65px" style="float: left">
                            </c:if>                        
                            <c:if test="${not empty whitelabel}" >
                                <img src="${cp}${whitelabel.getFullfileName()}${whitelabel.logofilename}" alt="logo" width="65px" style="float: left">                
                            </c:if> 
                        </a>
                    </div>                    
                    <!-- sidebar Menu -->
                    <div id="sidebar-menu">                       
                        <!--                    <ul class="list-unstyled components">
                            <li>                    
                                <a href="#personalMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                                    <i class="fa fas fa-info  ml-2"></i><spring:message code="index.personal"/> 
                                </a>
    
                                <ul class="collapse list-unstyled" id="personalMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                                    <li>
                                        <a href="<c:url value="/profile"/>"> <spring:message code="index.personal.profile"/></a>
                                    </li>
                                    <li>
                                        <a href="<c:url value="/dashboard/"/>"><span><spring:message code="index.personal.summary"/></span></a>
                                    </li>
                                    <li>
                                        <a href="<c:url value="/infrastructure/"/>"><spring:message code="index.personal.infrastructure"/></a>
                                    </li>
                                    <li>
                                        <a href="https://www.oddeye.co/documentation/" target="_blank"><spring:message code="index.personal.help"/></a>
                                    </li>
                                </ul>
                            </li>                    
                            <li>                    
                                <a href="#monitoringMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                                    <i class="fa far fa-bell"></i><spring:message code="index.monitoring"/>
                                </a>
    
                                <ul class="collapse list-unstyled" id="monitoringMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                                    <li>
                                        <a href="<c:url value="/monitoring"/>"><spring:message code="index.monitoring.realTime"/></a>
                                    </li>
                        <c:forEach items="${curentuser.getOptionsListasObject()}" var="option">
                        <li>
                            <a href="<spring:url value="/monitoring/${option.key}/"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                            ${option.key}                                                             
                        </a>
                    </li>
                        </c:forEach>
                        <li>
                            <a href="<c:url value="/errorsanalysis"/>"><spring:message code="index.monitoring.detailed"/></a>
                        </li>
                    </ul>
                </li>
                <li>                    
                    <a href="#dashboardsMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                        <i class="fa fas fa-desktop"></i><spring:message code="index.dashboardsDushList"/> (${curentuser.getDushList().size()})
                    </a>

                    <ul class="collapse list-unstyled" id="dashboardsMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                        <li><a href="<c:url value="/dashboard/new"/>"><spring:message code="dashboards.newDashboard"/></a></li>
                        <c:forEach items="${curentuser.getDushListasObject()}" var="Dush">
                        <li class="text-nowrap">
                            <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                            <c:if test="${Dush.value.get(\"locked\")==true}">
                                &nbsp; <i  type="button" class="fa fas fa-lock"></i>
                            </c:if>                                                               
                            <c:if test="${Dush.value.get(\"locked\")!=true}">
                                &nbsp; <i  type="button" class="fa fas fa-lock-open"></i>
                            </c:if>                                                                  
                            ${Dush.key}                                                             
                        </a>
                    </li>
                        </c:forEach>
                    </ul>
                </li>
                        <sec:authorize access="hasRole('ADMIN')">
                            <li>                    
                                <a href="#managementMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                                    <i class="fa fa-edit"></i><spring:message code="index.managment"/>
                                </a>

                                <ul class="collapse list-unstyled" id="managementMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                            <sec:authorize access="hasRole('USERMANAGER')">
                                <li><a href="<c:url value="/userslist"/>" ><spring:message code="index.managment.users"/></a></li>
                                <li><a href="<c:url value="/cookreport"/>" ><spring:message code="index.managment.cookAREKY"/></a></li>
                                <li><a href="<c:url value="/paymentslist"/>" ><spring:message code="index.managment.payments"/></a></li>
                                <li><a href="<c:url value="/whitelable/list"/>" ><spring:message code="index.managment.whitelabels"/></a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('CONTENTMANAGER')">
                            <li><a href="<c:url value="/pages"/>" ><spring:message code="index.managment.content"/></a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('USERMANAGER')">
                            <li><a href="<c:url value="/templatelist"/>" ><spring:message code="index.managment.templates"/></a></li>
                            </sec:authorize> 
                        </ul>
                    </li> 
                        </sec:authorize>
                    </ul>-->
                        <!--                                    <div class="accordion" id="sidebarMenu">
                                                                <div class="card">
                                                                    <div class="card-header" id="headPersonal">                                                
                                                                            <a href="#personalMenu" class="dropdown-toggle" data-toggle="collapse" data-target="#collapsePersonal" aria-expanded="true" aria-controls="collapsePersonal">
                                                                            <i class="fa fas fa-info  ml-2"></i><spring:message code="index.personal"/> 
                                                                            </a>                                                
                                                                    </div>
                                                                    <div id="collapsePersonal" class="collapse" aria-labelledby="headPersonal" data-parent="#sidebarMenu">
                                                                        <div class="card-body">
                                                                            <ul class="list-unstyled child_menu" id="personalMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                                                                                <li>
                                                                                    <a href="<c:url value="/profile"/>"> <spring:message code="index.personal.profile"/></a>
                                                                                </li>
                                                                                <li>
                                                                                    <a href="<c:url value="/dashboard/"/>"><spring:message code="index.personal.summary"/></a>
                                                                                </li>
                                                                                <li>
                                                                                    <a href="<c:url value="/infrastructure/"/>"><spring:message code="index.personal.infrastructure"/></a>
                                                                                </li>
                                                                                <li>
                                                                                    <a href="https://www.oddeye.co/documentation/" target="_blank"><spring:message code="index.personal.help"/></a>
                                                                                </li>
                                                                            </ul>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="card">
                                                                    <div class="card-header" id="headMonitoring">                                                
                                                                            <a href="#monitoringMenu" class="collapsed dropdown-toggle" data-toggle="collapse" data-target="#collapseMonitoring" aria-expanded="false" aria-controls="collapseMonitoring">
                                                                                <i class="fa far fa-bell"></i><spring:message code="index.monitoring"/>
                                                                            </a>                                                
                                                                    </div>
                                                                    <div id="collapseMonitoring" class="collapse" aria-labelledby="headMonitoring" data-parent="#sidebarMenu">
                                                                        <div class="card-body">
                                                                            <ul class="list-unstyled child_menu" id="monitoringMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                                                                                <li>
                                                                                    <a href="<c:url value="/monitoring"/>"><spring:message code="index.monitoring.realTime"/></a>
                                                                                </li>
                        <c:forEach items="${curentuser.getOptionsListasObject()}" var="option">
                         <li>
                            <a href="<spring:url value="/monitoring/${option.key}/"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                            ${option.key}                                                             
                        </a>
                    </li>
                        </c:forEach>
                        <li>
                            <a href="<c:url value="/errorsanalysis"/>"><spring:message code="index.monitoring.detailed"/></a>
                        </li>
                    </ul>            
                </div>
            </div>
        </div>
        <div class="card">
            <div class="card-header" id="headDashboards">                                                
                    <a href="#dashboardsMenu" class="collapsed dropdown-toggle" data-toggle="collapse" data-target="#collapseDashboards" aria-expanded="false" aria-controls="collapseDashboards">
                        <i class="fa fas fa-desktop"></i><spring:message code="index.dashboardsDushList"/> (${curentuser.getDushList().size()})
                    </a>                                                
            </div>
            <div id="collapseDashboards" class="collapse" aria-labelledby="headDashboards" data-parent="#sidebarMenu">
                <div class="card-body">
                    <ul class="list-unstyled child_menu" id="dashboardsMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                        <li><a href="<c:url value="/dashboard/new"/>"><spring:message code="dashboards.newDashboard"/></a></li>
                        <c:forEach items="${curentuser.getDushListasObject()}" var="Dush">
                        <li class="text-nowrap">
                            <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                            <c:if test="${Dush.value.get(\"locked\")==true}">
                                &nbsp; <i  type="button" class="fa fas fa-lock"></i>
                            </c:if>                                                               
                            <c:if test="${Dush.value.get(\"locked\")!=true}">
                                &nbsp; <i  type="button" class="fa fas fa-lock-open"></i>
                            </c:if>                                                                  
                            ${Dush.key}                                                             
                        </a>
                    </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
                        <sec:authorize access="hasRole('ADMIN')">                    
                        <div class="card">
                            <div class="card-header" id="headManagment">                                                
                                    <a href="#managementMenu" class="collapsed dropdown-toggle" data-toggle="collapse" data-target="#collapseManagment" aria-expanded="false" aria-controls="collapseManagment">
                                        <i class="fa fa-edit"></i><spring:message code="index.managment"/>
                                    </a>                                                
                            </div>
                            <div id="collapseManagment" class="collapse" aria-labelledby="headManagment" data-parent="#sidebarMenu">
                                <div class="card-body">
                                    <ul class="list-unstyled child_menu" id="managementMenu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>
                            <sec:authorize access="hasRole('USERMANAGER')">
                                <li><a href="<c:url value="/userslist"/>" ><spring:message code="index.managment.users"/></a></li>
                                <li><a href="<c:url value="/cookreport"/>" ><spring:message code="index.managment.cookAREKY"/></a></li>
                                <li><a href="<c:url value="/paymentslist"/>" ><spring:message code="index.managment.payments"/></a></li>
                                <li><a href="<c:url value="/whitelable/list"/>" ><spring:message code="index.managment.whitelabels"/></a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('CONTENTMANAGER')">
                                <li><a href="<c:url value="/pages"/>" ><spring:message code="index.managment.content"/></a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('USERMANAGER')">
                                <li><a href="<c:url value="/templatelist"/>" ><spring:message code="index.managment.templates"/></a></li>
                            </sec:authorize> 
                        </ul>
                    </div>
                </div>
            </div>
                        </sec:authorize>            
                    </div>-->
                        <ul id="sidebarMenu" class="accordion list-unstyled">
                            <li class="card">
                                <div class="card-header" id="headPersonal">                                                
                                    <a href="#personalMenu" class="dropdown-toggle" data-toggle="collapse" data-target="#collapsePersonal" aria-expanded="false" aria-controls="collapsePersonal">
                                        <i class="fa fas fa-info  ml-2"></i><spring:message code="index.personal"/> 
                                    </a>                                                
                                </div>
                                <div id="collapsePersonal" class="collapse depthShadowDark" aria-labelledby="headPersonal" data-parent="#sidebarMenu">
                                    <div class="card-body">
                                        <ul class="list-unstyled child_menu" id="personalMenu">
                                                <li>
                                                    <a href="<c:url value="/profile"/>"> <spring:message code="index.personal.profile"/></a>
                                            </li>
                                            <li>
                                                <a href="<c:url value="/dashboard/"/>"><spring:message code="index.personal.summary"/></a>
                                            </li>
                                            <li>
                                                <a href="<c:url value="/infrastructure/"/>"><spring:message code="index.personal.infrastructure"/></a>
                                            </li>
                                            <li>
                                                <a href="https://www.oddeye.co/documentation/" target="_blank"><spring:message code="index.personal.help"/></a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </li>
                            <li class="card">
                                <div class="card-header" id="headMonitoring">                                                
                                    <a href="#monitoringMenu" class="collapsed dropdown-toggle" data-toggle="collapse" data-target="#collapseMonitoring" aria-expanded="false" aria-controls="collapseMonitoring">
                                        <i class="fa far fa-bell"></i><spring:message code="index.monitoring"/>
                                    </a>                                                
                                </div>
                                <div id="collapseMonitoring" class="collapse depthShadowDark" aria-labelledby="headMonitoring" data-parent="#sidebarMenu">
                                    <div class="card-body">
                                        <ul class="list-unstyled child_menu" id="monitoringMenu">
                                                <li>
                                                    <a href="<c:url value="/monitoring"/>"><spring:message code="index.monitoring.realTime"/></a>
                                            </li>
                                            <c:forEach items="${curentuser.getOptionsListasObject()}" var="option">
                                                <li>
                                                    <a href="<spring:url value="/monitoring/${option.key}/"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                                                        ${option.key}                                                             
                                                    </a>
                                                </li>
                                            </c:forEach>
                                            <li>
                                                <a href="<c:url value="/errorsanalysis"/>"><spring:message code="index.monitoring.detailed"/></a>
                                            </li>
                                        </ul>            
                                    </div>
                                </div>
                            </li>
                            <li class="card">
                                <div class="card-header" id="headDashboards">                                                
                                    <a href="#dashboardsMenu" class="collapsed dropdown-toggle" data-toggle="collapse" data-target="#collapseDashboards" aria-expanded="false" aria-controls="collapseDashboards">
                                        <i class="fa fas fa-desktop"></i><spring:message code="index.dashboardsDushList"/> (${curentuser.getDushList().size()})
                                    </a>                                                
                                </div>
                                <div id="collapseDashboards" class="collapse depthShadowDark" aria-labelledby="headDashboards" data-parent="#sidebarMenu">
                                    <div class="card-body">
                                        <ul class="list-unstyled child_menu" id="dashboardsMenu">
                                            <li><a href="<c:url value="/dashboard/new"/>"><spring:message code="dashboards.newDashboard"/></a></li>
                                                <c:forEach items="${curentuser.getDushListasObject()}" var="Dush">
                                                <li class="text-nowrap">
                                                    <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                                                        <c:if test="${Dush.value.get(\"locked\")==true}">
                                                            &nbsp; <i class="fa fas fa-lock"></i>
                                                        </c:if>                                                               
                                                        <c:if test="${Dush.value.get(\"locked\")!=true}">
                                                            &nbsp; <i class="fa fas fa-lock-open"></i>
                                                        </c:if>                                                                  
                                                        ${Dush.key}                                                             
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </li>
                            <sec:authorize access="hasRole('ADMIN')">                    
                                <li class="card">
                                    <div class="card-header" id="headManagment">                                                
                                        <a href="#managementMenu" class="collapsed dropdown-toggle" data-toggle="collapse" data-target="#collapseManagment" aria-expanded="false" aria-controls="collapseManagment">
                                            <i class="fa fa-edit"></i><spring:message code="index.managment"/>
                                        </a>                                                
                                    </div>
                                    <div id="collapseManagment" class="collapse depthShadowDark" aria-labelledby="headManagment" data-parent="#sidebarMenu">
                                        <div class="card-body">
                                            <ul class="list-unstyled child_menu" id="managementMenu">
                                                <sec:authorize access="hasRole('USERMANAGER')">
                                                    <li><a href="<c:url value="/userslist"/>" ><spring:message code="index.managment.users"/></a></li>
                                                    <li><a href="<c:url value="/cookreport"/>" ><spring:message code="index.managment.cookAREKY"/></a></li>
                                                    <li><a href="<c:url value="/paymentslist"/>" ><spring:message code="index.managment.payments"/></a></li>
                                                    <li><a href="<c:url value="/whitelable/list"/>" ><spring:message code="index.managment.whitelabels"/></a></li>
                                                    </sec:authorize>
                                                    <sec:authorize access="hasRole('CONTENTMANAGER')">
                                                    <li><a href="<c:url value="/pages"/>" ><spring:message code="index.managment.content"/></a></li>
                                                    </sec:authorize>
                                                    <sec:authorize access="hasRole('USERMANAGER')">
                                                    <li><a href="<c:url value="/templatelist"/>" ><spring:message code="index.managment.templates"/></a></li>
                                                    </sec:authorize> 
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                            </sec:authorize>            
                        </ul>
                        <ul id="sidebarSmallMenu" class="list-unstyled">
                            <li>                
                                <div class="dropdown dropright">
                                    <a class="btn btn-outline-dark dropdown-toggle" href="#" role="button" id="menuPersonal" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa fas fa-info "></i>  
                                        <spring:message code="index.personal"/>
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="menuPersonal">
                                        <a class="dropdown-item" href="<c:url value="/profile"/>"><spring:message code="index.personal.profile"/></a>
                                        <a class="dropdown-item" href="<c:url value="/dashboard/"/>"><spring:message code="index.personal.summary"/></a>
                                        <a class="dropdown-item" href="<c:url value="/infrastructure/"/>"><spring:message code="index.personal.infrastructure"/></a>
                                        <a class="dropdown-item" href="https://www.oddeye.co/documentation/" target="_blank"><spring:message code="index.personal.help"/></a>
                                    </div>
                                </div>
                            </li>
                            <li>                
                                <div class="dropdown dropright">
                                    <a class="btn btn-outline-dark dropdown-toggle" href="#" role="button" id="menuMonitoring" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa far fa-bell"></i>
                                        <spring:message code="index.monitoring"/>
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="menuMonitoring">
                                        <a class="dropdown-item" href="<c:url value="/monitoring"/>"><spring:message code="index.monitoring.realTime"/></a>
                                        <c:forEach items="${curentuser.getOptionsListasObject()}" var="option">
                                            <a href="<spring:url value="/monitoring/${option.key}/" htmlEscape="true"/>" title="${Dush.key}">                                                         
                                                ${option.key}                                                             
                                            </a>
                                        </c:forEach>
                                        <a class="dropdown-item" href="<c:url value="/errorsanalysis"/>"><spring:message code="index.monitoring.detailed"/></a>
                                    </div>
                                </div>
                            </li>
                            <li>                
                                <div class="dropdown dropright">
                                    <a class="btn btn-outline-dark dropdown-toggle" href="#" role="button" id="menuDash" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa fas fa-desktop"></i>
                                        <spring:message code="index.dashboardsDushList"/>
                                        <span class="d-block">[ ${curentuser.getDushList().size()} ]</span>
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="menuDash">
                                        <a class="dropdown-item" href="<c:url value="/dashboard/new"/>"><spring:message code="dashboards.newDashboard"/></a>
                                        <c:forEach items="${curentuser.getDushListasObject()}" var="Dush">
                                            <a class="dropdown-item" href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                                                <c:if test="${Dush.value.get(\"locked\")==true}">
                                                    <i class="fa fas fa-lock"></i>
                                                </c:if>                                                               
                                                <c:if test="${Dush.value.get(\"locked\")!=true}">
                                                    <i class="fa fas fa-lock-open"></i>
                                                </c:if>                                                                  
                                                ${Dush.key}                                                             
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </li>
                            <sec:authorize access="hasRole('ADMIN')">
                                <li>                
                                    <div class="dropdown dropright">
                                        <a class="btn btn-outline-dark dropdown-toggle" href="#" role="button" id="menuManagement" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <i class="fa fa-edit"></i>
                                            <spring:message code="index.managment"/> 
                                        </a>
                                        <div class="dropdown-menu" aria-labelledby="menuManagement">
                                            <sec:authorize access="hasRole('USERMANAGER')">
                                                <a class="dropdown-item" href="<c:url value="/userslist"/>"><spring:message code="index.managment.users"/></a>
                                                <a class="dropdown-item" href="<c:url value="/cookreport"/>"><spring:message code="index.managment.cookAREKY"/></a>
                                                <a class="dropdown-item" href="<c:url value="/paymentslist"/>"><spring:message code="index.managment.payments"/></a>
                                                <a class="dropdown-item" href="<c:url value="/whitelable/list"/>"><spring:message code="index.managment.whitelabels"/></a>
                                            </sec:authorize>
                                            <sec:authorize access="hasRole('CONTENTMANAGER')">
                                                <a class="dropdown-item" href="<c:url value="/pages"/>"><spring:message code="index.managment.content"/></a>
                                            </sec:authorize>
                                            <sec:authorize access="hasRole('USERMANAGER')">
                                                <a class="dropdown-item" href="<c:url value="/templatelist"/>"><spring:message code="index.managment.templates"/></a>
                                            </sec:authorize>
                                        </div>
                                    </div>
                                </li> 
                            </sec:authorize>
                        </ul>                        
                    </div>
                    

                    <!--                sidebar active          -->

                   

                    <!-- sidebar-footer buttons -->

                    <div class="sidebar-footer hidden-small">
                        <a href="<c:url value="/logout/"/>" data-toggle="tooltip" data-placement="top" title='<spring:message code="logout"/>' data-original-title='<spring:message code="logout"/>'>
                            <span class="fas fa-power-off" aria-hidden="true"></span>
                        </a>
                        <a href="" data-toggle="tooltip" data-placement="top" title='<spring:message code="fullScreen"/>' data-original-title='<spring:message code="fullScreen"/>' id="FullScreen">
                            <span class="fas fa-arrows-alt" aria-hidden="true"></span>
                        </a>
                        <a href="${cp}/profile/edit" data-toggle="tooltip" data-placement="top" title='<spring:message code="settings"/>' data-original-title='<spring:message code="settings"/>'>
                            <span class="fas fa-cog" aria-hidden="true"></span>
                        </a>
                        <a  href="<c:url value="/monitoring"/>" data-toggle="tooltip" data-placement="top" title='<spring:message code="index.monitoring"/>' data-original-title='<spring:message code="index.monitoring"/>'>
                            <span class="fas fa-clock" aria-hidden="true"></span>
                        </a>
                    </div>
                </nav>
                <!-- ======================== Page Content =========================  -->        
                <div id="content">
                    <nav class="navbar navbar-expand-sm shadow navbar-light bg-light">
                        <div class="container-fluid">
                            <button type="button" id="menu_toggle" class="btn btn-outline-dark">
                                <i class="fas fa-indent"></i>
                                <b class="pagetitle"> ${htitle} </b>
                            </button>
                            <div class="collapse navbar-collapse" id="navbarNavDropdown">
                                <ul class="nav navbar-nav ml-auto">
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <li class="nav-item">
                                            <a class="nav-link">
                                                <%
                                                    InetAddress ia = InetAddress.getLocalHost();
                                                    String node = ia.getHostName();
                                                    pageContext.setAttribute("node", node);
                                                %>          
                                                Server ${node}
                                            </a>
                                        </li>    
                                    </sec:authorize>
                                    <li class="nav-item">
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-outline-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">                                                                                     
                                                <c:if test="${curentuser.getSwitchUser()==null}">
                                                    ${curentuser.getEmail()}
                                                </c:if>
                                                <c:if test="${curentuser.getSwitchUser()!=null}">
                                                    <b class="pagetitle"><spring:message code="index.switchedTo"/>&nbsp;${curentuser.getSwitchUser().getEmail()}</b>
                                                </c:if>&nbsp;
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-right">
                                                <li>
                                                    ${curentuser.reload()}
                                                    <c:set var="balance" value="${curentuser.getBalance()}" />
                                                    <c:if test="${balance>0}">
                                                        <a href="javascript:;" class="dropdown-item">
                                                            <spring:message code="balance"/>&nbsp;
                                                            <c:if test="${balance<Double.MAX_VALUE}">
                                                                <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${balance}" />
                                                            </c:if>
                                                            <c:if test="${balance==Double.MAX_VALUE}">
                                                                <span class="infin"> &infin; </span>
                                                            </c:if>                                                        
                                                        </a>
                                                    </c:if>
                                                </li>    
                                                <li>    
                                                    <a href="javascript:void(0);" class="dropdown-item" id="allowedit">
                                                        <c:if test="${curentuser.getAlowswitch()}">
                                                            <img src="${cp}/assets/images/allowedit.png" alt="Allow Edit" width="15px">
                                                        </c:if>                                                    
                                                        <spring:message code="index.allowEdit"/>                                            
                                                    </a>
                                                </li>     
                                                <c:if test="${curentuser.getSwitchUser()!=null}"> 
                                                    <li>        
                                                        <a href="<c:url value="/switchoff/"/>" class="dropdown-item"><i class="fa fa-sign-out pull-right"></i>
                                                            <spring:message code="index.switchOff"/>
                                                        </a> 
                                                    </li> 
                                                </c:if>                                                
                                                <c:url value="/logout/" var="logoutUrl"/> 
                                                <li> 
                                                    <a href="${logoutUrl}" class="dropdown-item"><i class="fa fa-sign-out pull-right"></i>
                                                        <spring:message code="logout"/>
                                                    </a> 
                                                </li> 
                                            </ul>
                                        </div>
                                    </li>                                    
                                </ul>
                            </div>
                        </div>
                    </nav>
                    <!-- ========================== Right_Col ========================  -->
                    <!-- page content -->
                    <div class="right_col" role="main">

                        <c:if test="${!curentuser.getActive()}">
                            <div class="clearfix"></div>
                            <div class="alert alert-danger alert-dismissible fade in " role="alert">
                                <spring:message code="index.alertNotActivate"/>
                            </div>
                        </c:if>                                         
                        <c:if test="${curentuser.getMetricsMeta().size()==0}">
                            <div class="clearfix"></div>
                            <div class="alert alert-danger alert-dismissible fade in " role="alert">                                
                                <spring:message code="index.installAgent"/>
                            </div>
                        </c:if>                            
                        <c:catch var="e">
                            <c:import url="${body}.jsp" />
                        </c:catch>
                        <c:if test="${!empty e}">                            
                            <c:import url="errors/pageerror.jsp" />
                        </c:if>
                            <!--                    
                                    <div class="row">
                                                            <div class="col-12 col-xl-8 col-lg-8 order-1">
                                                                <div class="card shadow mb-4">
                                                                    <h4 class="card-header">
                                                                        My Dashboards (11)
                                                                        <a class="btn btn-outline-success btn-sm float-right" href="#">New Dashboard</a>                            
                                                                    </h4>                           
                                                                    <div class="card-body">
                                                                        <ul class="row gotodash">
                                                                            <li class=" col-6 col-sm-6 col-lg-4">
                                                                                <a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock-open"></i> DashboardStorm</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4">
                                                                                <a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock-open"></i> Full Oddeye</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4">
                                                                                <a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock"></i> Funny</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4"><a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock"></i> JSON Editor</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4"><a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock-open"></i> Mesos Dash</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4"><a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock"></i> Pi3 temperature</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4"><a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock"></i> System Demo</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4"><a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock"></i> System Mini</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4"><a href="#" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock-open"></i> Thread Dash</a>
                                                                            </li>
                                                                            <li class=" col-6 col-sm-6 col-lg-4"><a href="dash.html" class="gotodash"> &nbsp;
                                                                                    <i class="fa fas fa-lock-open"></i> Charts </a>
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-12 col-xl-8 col-lg-8 order-3">
                                                                <div class="card shadow mb-4">
                                                                    <h4 class="card-header">
                                                                        Statistic
                                                                        <a id="Get_Agent" class="btn btn-outline-success btn-sm float-right ml-2" href="https://github.com/oddeyeco/" target="_blank">Get Agent</a>
                                                                        <a id="Agent_Guide" class="btn btn-outline-success btn-sm float-right" href="https://www.oddeye.co/documentation/puypuy/puypuy/" target="_blank">Agent Guide</a>
                                                                    </h4>
                                                                    <div class="card-body">
                                                                        <div class="x_content metricstat">
                                                                            <h2><span class="count_top"><i class="fa fa-folder"></i> Total Metrics</span> (<span class="count" id="count">2544</span>) </h2>
                                                                            <div class="row justify-content-md-center justify-content-lg-start tile_count">
                                                                                <div class="col-xl-2 col-md-4 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-list"></i> Metric Names</span>
                                                                                    <div class="count" id="metrics">318</div>
                                                                                    <span class="count_bottom">
                                                                                        <a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="_name">Show List</a>
                                                                                    </span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-4 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-folder"></i> Metric Types</span>
                                                                                    <div class="count" id="typecount">5</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="_type">Show List</a></span>
                                                                                </div>
                                                                            </div>
                                    
                                                                            <h2>
                                                                                <span class="count_top"><i class="fa fa-folder"></i> Total Tags </span> (<span class="count" id="tags">9</span>)
                                                                            </h2>
                                                                            <div class="row justify-content-md-center justify-content-lg-start tile_count" id="tagslist">
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "cluster" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">1</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="cluster">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "device" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">17</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="device">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "group" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">7</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="group">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "host" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">21</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="host">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "location" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">1</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="location">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "name" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">17</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="name">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "topology" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">1</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="topology">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "type" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">15</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="type">Show List</a></span>
                                                                                </div>
                                                                                <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                                                    <span class="count_top"><i class="fa fa-th-list"></i> Tag "webapp" count</span>
                                                                                    <div class="count spincrement" style="opacity: 1;">1</div>
                                                                                    <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="webapp">Show List</a></span>
                                                                                </div>
                                                                            </div>
                                    //            =================================================            MODALLS             ===========================================               
                                                                                                                <div id="modall1" class="modal fadeInLeft" role="dialog">
                                                                                                                    <div class="modal-dialog modal-lg">
                                                                                                                        <div class="modal-content">
                                                                                                                            <div class="modal-header">
                                                                                                                                <button type="button" class="close" data-dismiss="modal">×</button>
                                                                                                                                <h4 class="modal-title">Modal Header</h4>
                                                                                                                            </div>
                                                                                                                            <div class="modal-body"></div>
                                                                                                                            <div class="modal-footer">
                                                                                                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </div>
                                                                                                                </div>
                                                                                                                <div id="modall2" class="modal fade" role="dialog">
                                                                                                                    <div class="modal-dialog modal-90">
                                                                                                                        <div class="modal-content">
                                                                                                                            <div class="modal-header">
                                                                                                                                <button type="button" class="close" data-dismiss="modal">×</button>
                                                                                                                                <h4 class="modal-title">Modal Header</h4>
                                                                                                                            </div>
                                                                                                                            <div class="modal-body">
                                                                                                                                <p>Some text in the modal.</p>
                                                                                                                            </div>
                                                                                                                            <div class="modal-footer">
                                                                                                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </div>
                                                                                                                </div>
                                    //                                    ===================    Modal1   ===================
                                                                            <div class="modal fade bd-example-modal-lg" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                                                <div class="modal-dialog modal-lg" role="document">
                                                                                    <div class="modal-content">
                                                                                        <div class="modal-header">                                                    
                                                                                            <h4 class="modal-title" id="exampleModalLabel">Tag "core" list</h4> 
                                                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                                                <span aria-hidden="true">&times;</span>
                                                                                            </button>                                                    
                                                                                        </div>
                                    
                                                                                        <div class="modal-body">
                                                                                            <div id="listtablediv" class="table-responsive">
                                                                                                <div id="listtable_wrapper" class="dataTables_wrapper form-inline dt-bootstrap no-footer">
                                                                                                    <div class="row">
                                                                                                        <div class="col-sm-6">
                                                                                                            <div class="dataTables_length" id="listtable_length">
                                                                                                                <label>Show <select name="listtable_length" aria-controls="listtable" class="form-control input-sm">
                                                                                                                        <option value="10">10</option>
                                                                                                                        <option value="25">25</option>
                                                                                                                        <option value="50">50</option>
                                                                                                                        <option value="100">100</option>
                                                                                                                    </select>entries</label>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                        <div class="col-sm-6">
                                                                                                            <div id="listtable_filter" class="dataTables_filter">
                                                                                                                <label>Search:<input type="search" class="form-control input-sm" placeholder="" aria-controls="listtable"></label>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <div class="row">
                                                                                                        <div class="col-sm-12">
                                                                                                            <table id="listtable" class="table table-striped dt-responsive nowrap dataTable no-footer" cellspacing="0" width="100%" role="grid" aria-describedby="listtable_info" style="width: 100%;">
                                                                                                                <thead>
                                                                                                                    <tr role="row">
                                                                                                                        <th class="sorting_disabled" rowspan="1" colspan="1" aria-label=" " style="width: 72px;">
                                                                                                                            <div class="icheckbox_flat-blue" style="position: relative;">
                                                                                                                                <input type="checkbox" class="rawflat checkall" name="table_records" style="position: absolute; opacity: 0;">
                                                                                                                                <ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins>
                                                                                                                            </div>
                                                                                                                        </th>
                                                                                                                        <th class="sorting_asc" tabindex="0" aria-controls="listtable" rowspan="1" colspan="1" aria-sort="ascending" aria-label="Name: activate to sort column descending" style="width: 141px;">Name</th>
                                                                                                                        <th class="sorting" tabindex="0" aria-controls="listtable" rowspan="1" colspan="1" aria-label="Count: activate to sort column ascending" style="width: 146px;">Count</th>
                                                                                                                        <th class="sorting_disabled" rowspan="1" colspan="1" aria-label=" Delete selected" style="width: 399px;">
                                                                                                                            <a href="#" class="deletemetriclistgroup btn btn-danger btn-xs pull-right">
                                                                                                                                <i class="fa far fa-trash-alt-o"></i> Delete selected</a></th>
                                                                                                                    </tr> 
                                                                                                                </thead>
                                                                                                                <tbody>
                                                                                                                    <tr id="parent_all" data-tt-id="all" key="core" value="all" role="row" class="odd">
                                                                                                                        <td>
                                                                                                                            <div class="icheckbox_flat-blue" style="position: relative;">
                                                                                                                                <input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;">
                                                                                                                                <ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins>
                                                                                                                            </div>
                                                                                                                        </td>
                                                                                                                        <td class="sorting_1">all</td>
                                                                                                                        <td class="count"> 16</td>
                                                                                                                        <td class="action text-right">
                                                                                                                            <a href="javascript:void(0)" class="btn btn-primary btn-xs showtagsl2" data-toggle="modal" data-target="#exampleModal2" title_text="List of metrics with tag &quot;{0}&quot; is &quot;{1}&quot;" key="core" value="all">
                                                                                                                                <i class="fa fa-list"></i> Show List</a>
                                                                                                                            <a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetrics" key="core" value="all"><i class="fa far fa-trash-alt-o"></i> Delete</a>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                    <tr id="parent_core0" data-tt-id="core0" key="core" value="core0" role="row" class="even">
                                                                                                                        <td>
                                                                                                                            <div class="icheckbox_flat-blue" style="position: relative;">
                                                                                                                                <input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;">
                                                                                                                                <ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins>
                                                                                                                            </div>
                                                                                                                        </td>
                                                                                                                        <td class="sorting_1">core0</td>
                                                                                                                        <td class="count"> 16</td>
                                                                                                                        <td class="action text-right">
                                                                                                                            <a href="javascript:void(0)" class="btn btn-primary btn-xs showtagsl2" data-toggle="modal" data-target="#exampleModal2" title_text="List of metrics with tag &quot;{0}&quot; is &quot;{1}&quot;" key="core" value="core0">
                                                                                                                                <i class="fa fa-list"></i> Show List</a>
                                                                                                                            <a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetrics" key="core" value="core0">
                                                                                                                                <i class="fa far fa-trash-alt-o"></i> Delete</a>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                    <tr id="parent_core1" data-tt-id="core1" key="core" value="core1" role="row" class="odd">
                                                                                                                        <td>
                                                                                                                            <div class="icheckbox_flat-blue" style="position: relative;">
                                                                                                                                <input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;">
                                                                                                                                <ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins>
                                                                                                                            </div>
                                                                                                                        </td>
                                                                                                                        <td class="sorting_1">core1</td><td class="count"> 16</td>
                                                                                                                        <td class="action text-right">
                                                                                                                            <a href="javascript:void(0)" class="btn btn-primary btn-xs showtagsl2" data-toggle="modal" data-target="#exampleModal2" title_text="List of metrics with tag &quot;{0}&quot; is &quot;{1}&quot;" key="core" value="core1">
                                                                                                                                <i class="fa fa-list"></i> Show List</a>
                                                                                                                            <a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetrics" key="core" value="core1">
                                                                                                                                <i class="fa far fa-trash-alt-o"></i> Delete</a>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </tbody>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <div class="row">
                                                                                                        <div class="col-sm-5">
                                                                                                            <div class="dataTables_info" id="listtable_info" role="status" aria-live="polite">Showing 1 to 3 of 3 entries</div>                                                                        
                                                                                                        </div>
                                                                                                        <div class="col-sm-7">
                                                                                                            <div class="dataTables_paginate paging_simple_numbers" id="listtable_paginate">
                                                                                                                <ul class="pagination">
                                                                                                                    <li class="paginate_button previous disabled" id="listtable_previous">
                                                                                                                        <a href="#" aria-controls="listtable" data-dt-idx="0" tabindex="0">Previous</a>
                                                                                                                    </li>
                                                                                                                    <li class="paginate_button active">
                                                                                                                        <a href="#" aria-controls="listtable" data-dt-idx="1" tabindex="0">1</a>
                                                                                                                    </li>
                                                                                                                    <li class="paginate_button next disabled" id="listtable_next">
                                                                                                                        <a href="#" aria-controls="listtable" data-dt-idx="2" tabindex="0">Next</a>
                                                                                                                    </li>
                                                                                                                </ul>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="modal-footer">
                                                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                   Modal2   
                                                                            <div class="modal fade bd-example-modal-xl" id="exampleModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel2" aria-hidden="true">
                                                                                <div class="modal-dialog modal-xl" role="document">
                                                                                    <div class="modal-content">
                                                                                        <div class="modal-header">
                                    
                                                                                            <h4 class="modal-title" id="exampleModalLabel2">Tag "core" list</h4> 
                                                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                                                <span aria-hidden="true">&times;</span>
                                                                                            </button>
                                    
                                                                                        </div>
                                    
                                                                                        <div class="modal-body">
                                                                                            <div id="listtablediv" class="table-responsive">
                                                                                                <div id="listtable2_wrapper" class="dataTables_wrapper form-inline dt-bootstrap no-footer">
                                                                                                    <div class="row">
                                                                                                        <div class="col-sm-6">
                                                                                                            <div class="dataTables_length" id="listtable2_length"><label>Show <select name="listtable2_length" aria-controls="listtable2" class="form-control input-sm"><option value="10">10</option><option value="25">25</option><option value="50">50</option><option value="100">100</option></select> entries</label></div></div><div class="col-sm-6"><div id="listtable2_filter" class="dataTables_filter"><label>Search:<input type="search" class="form-control input-sm" placeholder="" aria-controls="listtable2"></label></div></div></div><div class="row"><div class="col-sm-12"><table id="listtable2" class="table table-striped dt-responsive nowrap dataTable no-footer" cellspacing="0" width="100%" role="grid" aria-describedby="listtable2_info" style="width: 100%;"><thead><tr role="row"><th class="sorting_disabled" rowspan="1" colspan="1" aria-label=" Toggle DropdownShow ChartClear Regression" style="width: 0px;"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat checkall" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div> <div class="btn-group"><button type="button" class="btn btn-success btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span><span class="sr-only">Toggle Dropdown</span></button><ul class="dropdown-menu" role="menu"><li><a href="#" class="Show_chart">Show Chart</a></li><li class="divider"></li><li><a href="#" class="Clear_reg">Clear Regression</a></li></ul></div></th><th class="sorting_asc" tabindex="0" aria-controls="listtable2" rowspan="1" colspan="1" aria-sort="ascending" aria-label="Name: activate to sort column descending" style="width: 0px;">Name</th><th class="sorting" tabindex="0" aria-controls="listtable2" rowspan="1" colspan="1" aria-label="Tags: activate to sort column ascending" style="width: 0px;">Tags</th><th class="sorting" tabindex="0" aria-controls="listtable2" rowspan="1" colspan="1" aria-label="Type: activate to sort column ascending" style="width: 0px;">Type</th><th class="sorting" tabindex="0" aria-controls="listtable2" rowspan="1" colspan="1" aria-label="First time: activate to sort column ascending" style="width: 0px;">First time</th><th class="sorting" tabindex="0" aria-controls="listtable2" rowspan="1" colspan="1" aria-label="Last Time: activate to sort column ascending" style="width: 0px;">Last Time</th><th class="sorting" tabindex="0" aria-controls="listtable2" rowspan="1" colspan="1" aria-label="Alive Days: activate to sort column ascending" style="width: 0px;">Alive Days</th><th class="sorting" tabindex="0" aria-controls="listtable2" rowspan="1" colspan="1" aria-label="Silence Days: activate to sort column ascending" style="width: 0px;">Silence Days</th><th class="sorting_disabled" rowspan="1" colspan="1" aria-label=" Delete selected" style="width: 0px;"><a href="#" class="deletemetricgroup btn btn-danger btn-xs pull-right"><i class="fa far fa-trash-alt-o"></i> Delete selected</a></th></tr> </thead><tbody><tr class="metricinfo odd" id="828068fbe2849ba6dd9e58885a0fca2ae46549f09c2125224e72b50cf7ddf012" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/828068fbe2849ba6dd9e58885a0fca2ae46549f09c2125224e72b50cf7ddf012" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/828068fbe2849ba6dd9e58885a0fca2ae46549f09c2125224e72b50cf7ddf012" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/828068fbe2849ba6dd9e58885a0fca2ae46549f09c2125224e72b50cf7ddf012">cpu_idle</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2019-03-15 16:51:23</td><td class="text-nowrap">2019-03-15 16:51:22</td> <td class="text-nowrap">0</td><td class="text-nowrap">0</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="828068fbe2849ba6dd9e58885a0fca2ae46549f09c2125224e72b50cf7ddf012"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="828068fbe2849ba6dd9e58885a0fca2ae46549f09c2125224e72b50cf7ddf012"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo even" id="e15640251cc23a597de1664c5f69edae07007d0c6016495f058d4023e32590bd" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/e15640251cc23a597de1664c5f69edae07007d0c6016495f058d4023e32590bd" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/e15640251cc23a597de1664c5f69edae07007d0c6016495f058d4023e32590bd" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/e15640251cc23a597de1664c5f69edae07007d0c6016495f058d4023e32590bd">cpu_idle</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran.office.loc"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2018-08-31 15:36:54</td><td class="text-nowrap">2019-02-22 19:15:12</td> <td class="text-nowrap">175</td><td class="text-nowrap">20</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="e15640251cc23a597de1664c5f69edae07007d0c6016495f058d4023e32590bd"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="e15640251cc23a597de1664c5f69edae07007d0c6016495f058d4023e32590bd"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo odd" id="6898ac53181ab4324732edb5eab9134e8d8297169976b3ffe89ca30687cba0e1" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/6898ac53181ab4324732edb5eab9134e8d8297169976b3ffe89ca30687cba0e1" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/6898ac53181ab4324732edb5eab9134e8d8297169976b3ffe89ca30687cba0e1" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/6898ac53181ab4324732edb5eab9134e8d8297169976b3ffe89ca30687cba0e1">cpu_iowait</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2019-03-15 16:51:23</td><td class="text-nowrap">2019-03-15 16:51:22</td> <td class="text-nowrap">0</td><td class="text-nowrap">0</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="6898ac53181ab4324732edb5eab9134e8d8297169976b3ffe89ca30687cba0e1"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="6898ac53181ab4324732edb5eab9134e8d8297169976b3ffe89ca30687cba0e1"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo even" id="e25632af4cc5b5b2b6ac8136df6be01eba6a6ee4202f2364d067fac650682b10" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/e25632af4cc5b5b2b6ac8136df6be01eba6a6ee4202f2364d067fac650682b10" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/e25632af4cc5b5b2b6ac8136df6be01eba6a6ee4202f2364d067fac650682b10" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/e25632af4cc5b5b2b6ac8136df6be01eba6a6ee4202f2364d067fac650682b10">cpu_iowait</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran.office.loc"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2018-08-31 15:36:54</td><td class="text-nowrap">2019-02-22 19:15:12</td> <td class="text-nowrap">175</td><td class="text-nowrap">20</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="e25632af4cc5b5b2b6ac8136df6be01eba6a6ee4202f2364d067fac650682b10"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="e25632af4cc5b5b2b6ac8136df6be01eba6a6ee4202f2364d067fac650682b10"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo odd" id="839c3c4daa2509a778afb20b50c4a8921284f1fd6c0e6aacd69debebb3161b22" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/839c3c4daa2509a778afb20b50c4a8921284f1fd6c0e6aacd69debebb3161b22" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/839c3c4daa2509a778afb20b50c4a8921284f1fd6c0e6aacd69debebb3161b22" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/839c3c4daa2509a778afb20b50c4a8921284f1fd6c0e6aacd69debebb3161b22">cpu_irq</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2019-03-15 16:51:23</td><td class="text-nowrap">2019-03-15 16:51:22</td> <td class="text-nowrap">0</td><td class="text-nowrap">0</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="839c3c4daa2509a778afb20b50c4a8921284f1fd6c0e6aacd69debebb3161b22"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="839c3c4daa2509a778afb20b50c4a8921284f1fd6c0e6aacd69debebb3161b22"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo even" id="f2854d2dcef1003eef98168761661aae1aec7c594b75b6ffe6ec5019a4926fa2" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/f2854d2dcef1003eef98168761661aae1aec7c594b75b6ffe6ec5019a4926fa2" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/f2854d2dcef1003eef98168761661aae1aec7c594b75b6ffe6ec5019a4926fa2" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/f2854d2dcef1003eef98168761661aae1aec7c594b75b6ffe6ec5019a4926fa2">cpu_irq</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran.office.loc"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2018-08-31 15:36:54</td><td class="text-nowrap">2019-02-22 19:15:12</td> <td class="text-nowrap">175</td><td class="text-nowrap">20</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="f2854d2dcef1003eef98168761661aae1aec7c594b75b6ffe6ec5019a4926fa2"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="f2854d2dcef1003eef98168761661aae1aec7c594b75b6ffe6ec5019a4926fa2"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo odd" id="06d0f1efc3166c5ce6d4642c90d348020655b942455ee5107fd4d63469e6d760" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/06d0f1efc3166c5ce6d4642c90d348020655b942455ee5107fd4d63469e6d760" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/06d0f1efc3166c5ce6d4642c90d348020655b942455ee5107fd4d63469e6d760" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/06d0f1efc3166c5ce6d4642c90d348020655b942455ee5107fd4d63469e6d760">cpu_load</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran"</div><div>location:"office"</div><div>type:"None"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2019-03-15 16:51:23</td><td class="text-nowrap">2019-03-15 16:51:22</td> <td class="text-nowrap">0</td><td class="text-nowrap">0</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="06d0f1efc3166c5ce6d4642c90d348020655b942455ee5107fd4d63469e6d760"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="06d0f1efc3166c5ce6d4642c90d348020655b942455ee5107fd4d63469e6d760"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo even" id="614fdb4f4dd387a3023b84e265e7810389255d2e46a290c86218134eda457a30" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/614fdb4f4dd387a3023b84e265e7810389255d2e46a290c86218134eda457a30" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/614fdb4f4dd387a3023b84e265e7810389255d2e46a290c86218134eda457a30" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/614fdb4f4dd387a3023b84e265e7810389255d2e46a290c86218134eda457a30">cpu_load</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran.office.loc"</div><div>location:"office"</div><div>type:"None"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2018-08-31 15:36:54</td><td class="text-nowrap">2019-02-22 19:15:12</td> <td class="text-nowrap">175</td><td class="text-nowrap">20</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="614fdb4f4dd387a3023b84e265e7810389255d2e46a290c86218134eda457a30"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="614fdb4f4dd387a3023b84e265e7810389255d2e46a290c86218134eda457a30"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo odd" id="362fc920ea02f8a4de0f810ff9d463d446d68eecb33226ddc1d107f72780ad12" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/362fc920ea02f8a4de0f810ff9d463d446d68eecb33226ddc1d107f72780ad12" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/362fc920ea02f8a4de0f810ff9d463d446d68eecb33226ddc1d107f72780ad12" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/362fc920ea02f8a4de0f810ff9d463d446d68eecb33226ddc1d107f72780ad12">cpu_nice</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2019-03-15 16:51:23</td><td class="text-nowrap">2019-03-15 16:51:22</td> <td class="text-nowrap">0</td><td class="text-nowrap">0</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="362fc920ea02f8a4de0f810ff9d463d446d68eecb33226ddc1d107f72780ad12"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="362fc920ea02f8a4de0f810ff9d463d446d68eecb33226ddc1d107f72780ad12"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr><tr class="metricinfo even" id="0f33ad9b165332f61e041ad004aac120c9a8ce185eba098fd79e69fffaf5b24e" role="row"><td class="icons text-nowrap"><div class="icheckbox_flat-blue" style="position: relative;"><input type="checkbox" class="rawflat" name="table_records" style="position: absolute; opacity: 0;"><ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins></div><a href="/OddeyeCoconut/chart/0f33ad9b165332f61e041ad004aac120c9a8ce185eba098fd79e69fffaf5b24e" target="_blank"><i class="fa fas fa-chart-area" style="font-size: 18px;"></i></a><a href="/OddeyeCoconut/history/0f33ad9b165332f61e041ad004aac120c9a8ce185eba098fd79e69fffaf5b24e" target="_blank"><i class="fa fa-history" style="font-size: 18px;"></i></a></td><td class="sorting_1"><a href="/OddeyeCoconut/metriq/0f33ad9b165332f61e041ad004aac120c9a8ce185eba098fd79e69fffaf5b24e">cpu_nice</a></td><td class="tags"><div>cluster:"tigran"</div><div>core:"all"</div><div>group:"office"</div><div>host:"tigran.office.loc"</div><div>location:"office"</div><div>type:"base"</div> </td><td class="text-nowrap">"None"</td><td class="text-nowrap">2018-08-31 15:36:54</td><td class="text-nowrap">2019-02-22 19:15:12</td> <td class="text-nowrap">175</td><td class="text-nowrap">20</td><td class="text-nowrap text-right"><a href="javascript:void(0)" class="btn btn-primary btn-xs clreg" value="0f33ad9b165332f61e041ad004aac120c9a8ce185eba098fd79e69fffaf5b24e"> Clear Regression </a><a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="0f33ad9b165332f61e041ad004aac120c9a8ce185eba098fd79e69fffaf5b24e"><i class="fa far fa-trash-alt-o"></i> Delete </a></td></tr></tbody> </table></div></div><div class="row"><div class="col-sm-5"><div class="dataTables_info" id="listtable2_info" role="status" aria-live="polite">Showing 1 to 10 of 16 entries</div></div><div class="col-sm-7"><div class="dataTables_paginate paging_simple_numbers" id="listtable2_paginate"><ul class="pagination"><li class="paginate_button previous disabled" id="listtable2_previous"><a href="#" aria-controls="listtable2" data-dt-idx="0" tabindex="0">Previous</a></li><li class="paginate_button active"><a href="#" aria-controls="listtable2" data-dt-idx="1" tabindex="0">1</a></li><li class="paginate_button "><a href="#" aria-controls="listtable2" data-dt-idx="2" tabindex="0">2</a></li><li class="paginate_button next" id="listtable2_next"><a href="#" aria-controls="listtable2" data-dt-idx="3" tabindex="0">Next</a></li></ul></div></div></div></div></div>
                                                                                        </div>
                                                                                        <div class="modal-footer">
                                                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                    //                ==================================        /MODALLS        =================================================     
                                                                        </div>
                                                                    </div>
                                                                </div>                          
                                                            </div>
                                    
                                                            <div class="col-12 col-xl-4 col-lg-4 order-2">
                                                                <div class="card shadow mb-4">
                                                                    <h4 class="card-header">
                                                                        Balance                                                            
                                                                    </h4>
                                                                    <div class="card-body">                                
                                                                        <div class="row">
                                                                            <div class="col-xl-6 col-lg-12 col-md-6 col-sm-6 col-12">
                                                                                <h4 class="count_top">Available</h4>
                                                                                <div class="count"> 49461.52 </div>                                            
                                                                            </div>
                                                                            <div class="col-xl-6 col-lg-12 col-md-6 col-sm-6 col-12">
                                                                                <h4 class="count_top">Burn rate</h4>
                                                                                <div class="count_bottom clearfix">
                                                                                    <span class="float-left">Today </span>
                                                                                    <div class=" float-right"> 9.60 </div>                                                
                                                                                </div>
                                                                                <div class="count_bottom clearfix">
                                                                                    <span class="float-left">Yesterday </span>
                                                                                    <div class=" float-right"> 16.85 </div>                                                
                                                                                </div>
                                                                                <div class="count_bottom clearfix">
                                                                                    <span class="float-left">This month</span>
                                                                                    <div class=" float-right" id="thismonth"> 346.50 </div>                                                
                                                                                </div>
                                                                                <div class="count_bottom clearfix">
                                                                                    <span class="float-left">Previous month</span>
                                                                                    <div class=" float-right" id="prevmonth"> 539.66 </div>                                                
                                                                                </div>                                            
                                                                            </div>
                                                                            <div class="clearfix">                                        
                                                                            </div>
                                                                            <div class="col-sm-12 moreunits">
                                                                                <h4>Get more</h4>
                                                                                <div class="clearfix">                                            
                                                                                </div>
                                                                                <div class="float-left col-xl-6 col-lg-12 col-sm-6 od">
                                                                                    <label for="amount"> Pay </label>
                                                                                    <input id="oddeyeAmmount" type="number" name="amount" value="1" step="1"> USD<br>
                                                                                </div>
                                                                                <div class="float-right col-xl-6 col-lg-12 col-sm-6 pp">
                                                                                    <form action="https://www.paypal.com/cgi-bin/websc" method="post">
                                                                                        <input type="hidden" name="cmd" value="_xclick">
                                                                                        <input type="hidden" name="business" value="ara@oddeye.co">
                                                                                        <input id="paypalItemName" type="hidden" name="item_name" value="Oddeye Points demodemo@oddeye.co" text="OddEye units demodemo@oddeye.co">
                                                                                        <input id="paypalAmmount" type="hidden" name="amount" value="25.00">
                                                                                        <input type="hidden" name="custom" value="b46898ea-8eb2-4281-bd2c-93c37ba0d8ea">
                                                                                        <input type="hidden" name="no_shipping" value="1">
                                                                                        <input type="hidden" name="return" value="http://app.oddeye.co/OddeyeCoconut/dashboard/">
                                                                                        <input type="hidden" name="notify_url" value="http://app.oddeye.co/OddeyeCoconut/paypal/ipn/">
                                                                                        <input type="hidden" name="image_url" value="https://app.oddeye.co/OddeyeCoconut/assets/images/email/logo_100px.png">
                                                                                        <input type="hidden" name="currency_code" value="USD">
                                                                                        <input type="hidden" name="bn" value="PP-BuyNowBF">
                                                                                        <input type="image" src="https://www.paypal.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
                                                                                    </form>
                                                                                </div>
                                                                            </div>
                                                                        </div>                                
                                                                    </div>
                                                                </div>
                                                            </div>
                                    
                                                            <div class="col-12 col-xl-4 col-lg-4 order-4">                        
                                                                <div class="card shadow mb-4">
                                                                    <h4 class="card-header">
                                                                        Your payments                                                       
                                                                    </h4>
                                                                    <div class="card-body"> 
                                                                        <ul class="row list-unstyled">
                                                                            <li class="col-12">
                                                                                <span class="float-left"> 12/20/2018 21:58:18 AMT </span>
                                                                                <span class="float-right"> 50000.0 $ </span>
                                                                            </li>
                                                                            <li class="col-12">
                                                                                <span class="float-left"> 01/17/2018 09:44:52 AMT </span>
                                                                                <span class="float-right"> 1.0 $ </span>
                                                                            </li>
                                                                            <li class="col-12">
                                                                                <span class="float-left"> 12/28/2017 13:29:45 AMT </span>
                                                                                <span class="float-right"> 10.5 $ </span>
                                                                            </li>      
                                                                        </ul> 
                                                                    </div>                                
                                                                </div>
                                                                <div class="card shadow mb-4">
                                                                    <h4 class="card-header">
                                                                        Available templates                                 
                                                                    </h4>
                                                                    <div class="card-body"> 
                                                                        <ul class="row list-unstyled">
                                                                            <li class="col-12">
                                                                                <a href="#" class="">
                                                                                    <span>
                                                                                        <i class="fa fas fa-info-circle"
                                                                                           data-toggle="tooltip"
                                                                                           data-html="true"
                                                                                           data-placement="left"
                                                                                           title=""
                                                                                           data-delay="{&quot;hide&quot;:&quot;1000&quot;}"
                                                                                           data-original-title="<div>Metrics-21<br>Tag Filters-1</div>">                                                            
                                                                                        </i>System (up to 2 servers recommended)
                                                                                    </span>
                                                                                    <span class="float-right">12/28/2017 18:54:12 AMT</span>
                                                                                </a>
                                                                            </li>
                                                                            <li class="col-12">
                                                                                <a href="#" class="">
                                                                                    <span>
                                                                                        <i class="fa fas fa-info-circle"
                                                                                           data-toggle="tooltip"
                                                                                           data-html="true"
                                                                                           data-placement="left"
                                                                                           title=""
                                                                                           data-delay="{&quot;hide&quot;:&quot;1000&quot;}"
                                                                                           data-original-title=" <div> Metrics-22<br>Tag Filters-2</div>">                                                               
                                                                                        </i> System Small 1 Host
                                                                                    </span>
                                                                                    <span class="float-right">02/14/2018 09:23:24 AMT</span>
                                                                                </a>
                                                                            </li>
                                                                            <li class="col-12">
                                                                                <a href="#" class="">
                                                                                    <span>
                                                                                        <i class="fa fas fa-info-circle"
                                                                                           data-toggle="tooltip"
                                                                                           data-html="true"
                                                                                           data-placement="left"
                                                                                           title=""
                                                                                           data-delay="{&quot;hide&quot;:&quot;1000&quot;}"
                                                                                           data-original-title="<div> Metrics-4<br>Tag Filters-0</div>">                                                               
                                                                                        </i> Template NginX
                                                                                    </span>
                                                                                    <span class="float-right">12/29/2017 10:47:11 AMT</span>
                                                                                </a>
                                                                            </li>
                                                                        </ul> 
                                                                    </div> 
                                                                    <h4 class="card-header">
                                                                        My templates                               
                                                                    </h4>
                                                                    <div class="card-body"> 
                                                                        <ul class="row list-unstyled gotodash">                                      
                                                                            <li class="col-12">
                                                                                <a href="#" class="gotodash">
                                                                                    <span>
                                                                                        System (2 servers)
                                                                                    </span>
                                                                                    <span class="float-right">12/29/2017 10:47:11 AMT</span>
                                                                                </a>
                                                                            </li>
                                                                            <li class="col-12">
                                                                                <a href="#" class="gotodash">
                                                                                    <span>
                                                                                        Dashboard Storm
                                                                                    </span>
                                                                                    <span class="float-right">12/28/2017 18:54:12 AMT</span>
                                                                                </a>
                                                                            </li>
                                                                            <li class="col-12">
                                                                                <a href="#" class="gotodash">
                                                                                    <span>
                                                                                        Dash_12
                                                                                    </span>
                                                                                    <span class="float-right">02/14/2018 09:23:24 AMT</span>
                                                                                </a>
                                                                            </li>                                           
                                                                        </ul> 
                                                                    </div>  
                                                                </div>
                                                            </div>
                                    </div>
                            -->
                    </div>
                </div>                                                                                           
            </div>

            <%--<c:if test="${activeuser.getFirstlogin()==true}">--%>
            <%--<c:if test="${false==true}">
                <div id="welcomemessage" class="modal  fade" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title">Welcome to OddEye smart monitoring and data analitic system</h4>
                            </div>
                            <div class="modal-body">
                                <p>  Для начала работы мы с радостью предоставляем вам 50 OddEye Coin -ов (в дальнейшем OC ). Чтобы продолжить   нужно установить агент OddEye для этого можно скачать и запустить агент для linux или windows или воспользоваться API и отправлять данные из любой удобной вам среды.</p>
                                <p>Подробнее можно узнать по ссылкам</p>
                                <ul>
                                    <li><a href="#">скачать Агент linux</a> </li>
                                    <li><a href="#">скачать Агент windows</a></li>
                                    <li><a href="#">описание  API</a></li>
                                    <li><a href="#">как установить Агент linux</a></li>
                                    <li><a href="#">как установить Агент windows</a></li>
                                    <li><a href="#">Калькулятор стоимости </a></li>
                                    <li><a href="#">Основная страница</a></li>
                                    <li><a href="#">Настройка мониторинга</a></li>
                                    <li><a href="#">Создание графиков </a>  </li>
                                </ul>
                            </div>
                            <div class="modal-footer">
                                <input   type="button" class="btn btn-default" data-dismiss="modal" value="Close">                                
                            </div>
                        </div>
                    </div>
                </div>                        
            </c:if>--%>

            <c:if test="${empty curentuser.getTemplate()}" >
                <script src="${cp}/resources/js/themes/templatevars.js?v=${version}"></script>
            </c:if>                        

            <c:if test="${not empty curentuser.getTemplate()}" >                
                <c:choose>
                    <c:when test="${curentuser.getTemplate() == 'dark'}">                                        
                        <script src="${cp}/resources/js/themes/dark_templatevars.js?v=${version}"></script>
                    </c:when>
                    <c:when test="${curentuser.getTemplate() == 'dark2'}">                                        
                        <script src="${cp}/resources/js/themes/dark2_templatevars.js?v=${version}"></script>
                    </c:when>                        
                    <c:otherwise>                      
                        <script src="${cp}/resources/js/themes/templatevars.js?v=${version}"></script>
                    </c:otherwise>                                                    
                </c:choose>
            </c:if>             
   
            <script>
                var headerName = "${_csrf.headerName}";
                var token = "${_csrf.token}";
                var cp = "${cp}";
                var uuid = "${curentuser.getId()}";
                var Firstlogin = false;
                <c:if test="${not empty curentuser}">
                Firstlogin = ${curentuser.getFirstlogin()};
                </c:if>

            </script>                                         
            <!-- jQuery -->
<!--           <script src="<c:url value="/assets/dist/jquery.min.js?v=${version}"/>"></script>  -->
<!--           <script src="<c:url value="/assets/dist/jquery-3.3.1.min.js?v=${version}"/>"></script> -->
            <script src="<c:url value="/resources/bootstrap/dist/bootstrap-4.3.1/js/jquery-3.3.1.min.js?v=${version}"/>"></script>

            <script src="${cp}/assets/dist/switchery.min.js?v=${version}"></script>
            <script src="${cp}/assets/dist/jquery-ui.custom.min.js?v=${version}"></script>
            <script src="${cp}/assets/dist/jquery.autocomplete.min.js?v=${version}"></script>        
            <script src="${cp}/assets/dist/jquery.spincrement.min.js?v=${version}"></script>                    

            <!-- Popper -->
            <script src="${cp}/resources/bootstrap/dist/bootstrap-4.3.1/js/popper.min.js?v=${version}"></script>

            <!-- Bootstrap -->           
<!--            <script src="${cp}/resources/bootstrap/dist/js/bootstrap.min.js?v=${version}"></script>  -->
            <script src="${cp}/resources/bootstrap/dist/bootstrap-4.3.1/js/bootstrap.min.js?v=${version}"></script>

            <!-- moment.js -->            
            <script src="${cp}/resources/js/moment/moment.min.js?v=${version}"></script>
            <c:if test="${not empty pageContext.response.locale}" >
                <c:if test="${udf:fileExists('/resources/js/moment/locale/' += pageContext.response.locale.language += '.js')}">
                    <script src="${cp}/resources/js/moment/locale/${pageContext.response.locale.language}.js?v=${version}"></script>
                </c:if>                                
            </c:if>            

            <!--bootstrap-progressbar--> 
            <script src="${cp}/resources/bootstrap-progressbar/bootstrap-progressbar.min.js?v=${version}"></script>
            <!--iCheck--> 
            <script src="${cp}/resources/iCheck/icheck.min.js?v=${version}"></script>
            <!-- Bootstrap Colorpicker -->
            <script src="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/js/bootstrap-colorpicker.min.js?v=${version}"></script>
            <!-- Bootstrap bootstrap-daterangepicker -->
            <script src="${cp}/resources/bootstrap-daterangepicker/daterangepicker.js?v=${version}"></script>        
            <!-- Custom Theme Scripts -->
<!--            <script src="${cp}/resources/build/js/custom.min.js?v=${version}"></script>-->
<!--            <script src="${cp}/resources/build/js/customOE.js?v=${version}"></script>-->
            <!-- Select2 -->
<!--            <script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>-->
            <script src="${cp}/resources/select2/dist/js/select2.js?v=${version}"></script>

            <script src="${cp}/assets/dist/sockjs-1.1.1.min.js?v=${version}"></script> 
            <script src="${cp}/assets/js/stomp.min.js?v=${version}"></script>                        
            <script src="<c:url value="/assets/js/general.min.js?v=${version}"/>"></script>    
            <script src="${cp}/resources/js/global.js?v=${version}"></script>        
            <script src="${cp}/resources/js/scriptOE.js?v=${version}"></script>
            
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
            </script>
            <script>
                (function (i, s, o, g, r, a, m) {
                    i['GoogleAnalyticsObject'] = r;
                    i[r] = i[r] || function () {
                        (i[r].q = i[r].q || []).push(arguments)
                    }, i[r].l = 1 * new Date();
                    a = s.createElement(o),
                            m = s.getElementsByTagName(o)[0];
                    a.async = 1;
                    a.src = g;
                    m.parentNode.insertBefore(a, m)
                })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

                ga('create', 'UA-101325828-1', 'auto');
                ga('send', 'pageview');
                setTimeout(function () {
                    ga('send', 'event', '10 seconds', 'read');
                }, 10000);

                window._mfq = window._mfq || [];
                (function () {
                    var mf = document.createElement("script");
                    mf.type = "text/javascript";
                    mf.async = true;
                    mf.src = "//cdn.mouseflow.com/projects/56872595-6055-428f-99ba-9995277fc45c.js";

                    document.getElementsByTagName("head")[0].appendChild(mf);
                })();
            </script>            
            <!-- Facebook Pixel Code -->
            <script>
                !function (f, b, e, v, n, t, s)
                {
                    if (f.fbq)
                        return;
                    n = f.fbq = function () {
                        n.callMethod ?
                                n.callMethod.apply(n, arguments) : n.queue.push(arguments)
                    };
                    if (!f._fbq)
                        f._fbq = n;
                    n.push = n;
                    n.loaded = !0;
                    n.version = '2.0';
                    n.queue = [];
                    t = b.createElement(e);
                    t.async = !0;
                    t.src = v;
                    s = b.getElementsByTagName(e)[0];
                    s.parentNode.insertBefore(t, s)
                }(window, document, 'script',
                        'https://connect.facebook.net/en_US/fbevents.js');
                fbq('init', '174049216706269');
                fbq('track', 'PageView');
            </script>
            <noscript>
            <img height="1" width="1" 
                 src="https://www.facebook.com/tr?id=174049216706269&ev=PageView
                 &noscript=1"/>
            </noscript>
            <!-- End Facebook Pixel Code -->
            <c:if test="${not empty pageContext.response.locale}" >
                <script>
                    moment.locale('${pageContext.response.locale}');
                </script>
            </c:if>              

        </body>
    </html>
</compress:html>                                                    