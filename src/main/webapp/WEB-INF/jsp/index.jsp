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
            <link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />
            <!-- DataTables bootstrap4 -->
            <link href="${cp}/resources/dataTablesBS4/css/dataTables.bootstrap4.min.css?v=${version}" rel="stylesheet"> 
            <link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />          
            
            <c:if test="${empty curentuser.getTemplate()}" >
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
                    <nav id="sidebar" class="active">                                   
                    <!-- sidebar Menu -->
                    <div id="sidebar-menu">
                        <ul id="sidebarMenu" class="accordion list-unstyled"<c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>                            
                            <li class="card">
                                <div class="card-header" id="">                                                
                                   <a class="mr-0 p-0" href="<c:url value='/'/>">
                                    <c:if test="${empty whitelabel}" >
                                        <span><img id="logo_sm" src="${cp}/assets/images/logoOE.png" alt="logo" width="60px"></span>
                                        <span class="align-middle ml-1">Home</span>
                                    </c:if>                        
                                    <c:if test="${not empty whitelabel}" >
                                        <span><img src="${cp}${whitelabel.getFullfileName()}${whitelabel.logofilename}" alt="logo" width="65px" style="float: left"></span>                
                                        <span>Home</span>                
                                    </c:if> 
                                    </a>  
                                </div>
                            </li>
                            <li class="card">
                                <div class="card-header" id="headProfile">                                                
                                    <a  href="<c:url value="/profile/edit"/>" class="">
                                        <i class="fas fa-cog ml-1"></i><spring:message code="index.personal.profile"/> 
                                    </a>                                                
                                </div>
                            </li>
                            <li class="card">
                                <div class="card-header" id="headInfrastructure">                                                
                                    <a  href="<c:url value="/infrastructure/"/>" class="">
                                        <i class="fas fa-code-branch ml-1"></i><spring:message code="index.personal.infrastructure"/> 
                                    </a>                                                
                                </div>
                            </li>
                            <li class="card">
                                <div class="card-header" id="headMonitoring">                                                
                                    <a href="#monitoringMenu" class="collapsed dropdown-toggle" data-toggle="collapse" data-target="#collapseMonitoring" aria-expanded="false" aria-controls="collapseMonitoring">
                                        <i class="fas fa-bullhorn ml-1"></i><spring:message code="index.monitoring"/>
                                    </a>                                                
                                </div>
                                <div id="collapseMonitoring" class="collapse depthShadowDarkHover" aria-labelledby="headMonitoring" data-parent="#sidebarMenu">
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
                                        <i class="fas fa-chart-bar ml-1"></i><spring:message code="index.dashboardsDushList"/>[${curentuser.getDushList().size()}]
                                    </a>                                                
                                </div>
                                <div id="collapseDashboards" class="collapse depthShadowDarkHover" aria-labelledby="headDashboards" data-parent="#sidebarMenu">
                                    <div class="card-body">
                                        <ul class="list-unstyled child_menu" id="dashboardsMenu">
                                            <li><a href="<c:url value="/dashboard/new"/>"><spring:message code="dashboards.newDashboard"/></a></li>
                                                <c:forEach items="${curentuser.getDushListasObject()}" var="Dush">
                                                <li class="text-wrap">
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
                                            <i class="fa fa-edit ml-1"></i><spring:message code="index.managment"/>
                                        </a>                                                
                                    </div>
                                    <div id="collapseManagment" class="collapse depthShadowDarkHover" aria-labelledby="headManagment" data-parent="#sidebarMenu">
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
                        <ul id="sidebarSmallMenu" class="list-unstyled"<c:if test="${cookie['small'].value != 'true'}">style="display: none"</c:if>>
                            <li>                
                                <div class="dropdown"> 
                                    <a class="btn btn-outline-dark mr-0 p-0" href="<c:url value='/'/>">
                                    <c:if test="${empty whitelabel}" >
                                        <img id="logo_sm" src="${cp}/assets/images/logoOE.png" alt="logo" width="65px">
                                        <span class="d-block">Home</span>
                                    </c:if>                        
                                    <c:if test="${not empty whitelabel}" >
                                        <span><img src="${cp}${whitelabel.getFullfileName()}${whitelabel.logofilename}" alt="logo" width="65px" style="float: left"></span>                
                                    </c:if> 
                                    </a>             
                                </div>
                            </li>
                            <li>                
                                <div class="dropdown">
                                    <a class="btn btn-outline-dark" href="<c:url value="/profile/edit"/>" role="button" id="menuProfile">
                                        <i class="fas fa-cogs"></i>  
                                        <span><spring:message code="index.personal.profile"/></span>
                                    </a>                                    
                                </div>
                            </li>
                            <li>                
                                <div class="dropdown">
                                    <a class="btn btn-outline-dark" href="<c:url value="/infrastructure/"/>" role="button" id="menuInfrastructure">
                                        <i class="fas fa-code-branch"></i>
                                        <span><spring:message code="index.personal.infrastructure"/></span>
                                    </a>                                    
                                </div>
                            </li> 
                            <li>                
                                <div class="dropdown dropright">
                                    <a class="btn btn-outline-dark dropdown-toggle" href="#" role="button" id="menuMonitoring" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fas fa-bullhorn"></i>
                                        <span><spring:message code="index.monitoring"/></span>
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
                                        <i class="fas fa-chart-bar"></i>
                                        <span><spring:message code="index.dashboardsDushList"/></span>
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
                                            <span><spring:message code="index.managment"/></span>
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
                <div id="content" class="active">
                    <nav class="navbar navbar-expand-sm navbar-light bg-light shadow">
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
                                                <%--<c:if test="${curentuser.getSwitchUser()==null}">
                                                    ${curentuser.getEmail()}
                                                </c:if>
                                                <c:if test="${curentuser.getSwitchUser()!=null}">--%>
                                                    <b class="pagetitle"><spring:message code="index.switchedTo"/>&nbsp;${curentuser.getEmail()}</b>
                                                <%--</c:if>--%>&nbsp;
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
                                                <%--<c:if test="${curentuser.getSwitchUser()!=null}">--%>
                                                    <li>        
                                                        <a href="<c:url value="/switchoff/"/>" class="dropdown-item"><i class="fa fa-sign-out pull-right"></i>
                                                            <spring:message code="index.switchOff"/>
                                                        </a> 
                                                    </li> 
                                                <%--</c:if>--%>                                              
                                                <%--<c:url value="/logout/" var="logoutUrl"/>--%> 
<!--                                                <li> 
                                                    <a href="${logoutUrl}" class="dropdown-item"><i class="fa fa-sign-out pull-right"></i>
                                                        <spring:message code="logout"/>
                                                    </a> 
                                                </li> -->
                                            </ul>
                                        </div>
                                    </li>
                                    <li>
                                        <a href="https://www.oddeye.co/documentation/" class="btn btn-outline-dark ml-1" role="button" target="_blank" data-toggle="tooltip" data-original-title="Documentation" id="navInfo">
                                            <i class="fa fas fa-info "></i>  
                                            <span></span>
                                        </a>  
                                    </li>
                                </ul>
                            </div>
                            <a href="<c:url value="/logout/"/>" class="btn btn-outline-dark ml-1" data-toggle="tooltip" data-placement="bottom" data-original-title='<spring:message code="logout"/>' id="navLogout">
                                <span class="fas fa-power-off" aria-hidden="true"></span>
                            </a>                
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
                    </div>
                </div>                                                                                           
            </div>
         
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
            <script src="<c:url value="/resources/bootstrap/dist/bootstrap-4.3.1/js/jquery-3.3.1.min.js?v=${version}"/>"></script>           
            <script src="${cp}/assets/dist/switchery.min.js?v=${version}"></script>
            <script src="${cp}/assets/dist/jquery-ui.custom.min.js?v=${version}"></script>
            <script src="${cp}/assets/dist/jquery.autocomplete.min.js?v=${version}"></script>        
            <script src="${cp}/assets/dist/jquery.spincrement.min.js?v=${version}"></script> 
            <!-- Popper -->
            <script src="${cp}/resources/bootstrap/dist/bootstrap-4.3.1/js/popper.min.js?v=${version}"></script>
            <!-- Bootstrap -->           
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
            <!-- Select2 -->          
            <script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>

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
            <!-- DataTables bootstrap4 -->
            <script src="${cp}/resources/dataTablesBS4/js/jquery.dataTables.min.js?v=${version}"></script>
            <script src="${cp}/resources/dataTablesBS4/js/dataTables.bootstrap4.min.js?v=${version}"></script> 
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
    