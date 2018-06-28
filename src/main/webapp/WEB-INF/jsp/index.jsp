<%@page import="java.net.InetAddress"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor"  prefix="compress"%>
<compress:html removeIntertagSpaces="true" removeMultiSpaces="true"  compressCss="true" compressJavaScript="true">    
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>    
    <c:set var="version" value="0.2.16" scope="request"/>
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
            <c:if test="${!empty ogimage}">                        
                <c:set var="image" value="${ogimage}" scope="request" />
            </c:if>              
            <meta property="og:image" content="https://${pageContext.request.getHeader("X-OddEye-Host")}${cp}/assets/images/${image}" />   
            <title>${title}|oddeye.co</title>

            <!-- Bootstrap -->
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/bootstrap/bootstrap.css?v=${version}" />      
            <!-- Font Awesome -->
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/fa-solid.css?v=${version}" />
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/fa-regular.css?v=${version}" />
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/fontawesome.css?v=${version}" />
            <!-- iCheck -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/iCheck/skins/flat/green.css?v=${version}" />        
            <!-- bootstrap-progressbar -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css?v=${version}" />            
            <!-- Bootstrap Colorpicker -->
            <link href="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/css/bootstrap-colorpicker.min.css?v=${version}" rel="stylesheet" />
            <link href="${cp}/resources/cropper/dist/cropper.min.css?v=${version}" rel="stylesheet" /> 
            <!-- Select2 -->
            <link href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}" rel="stylesheet">
            <!-- Bootstrap bootstrap-daterangepicker -->
            <link href="${cp}/resources/bootstrap-daterangepicker/daterangepicker.css?v=${version}" rel="stylesheet"> 
            <!-- Jsoneditor -->
            <link href="${cp}/resources/jsoneditor/dist/jsoneditor.min.css?v=${version}" rel="stylesheet" type="text/css">
            <!-- Custom Theme Style -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/build/css/custom.min.css?v=${version}" />   
            <link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />
            <link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css?v=${version}" rel="stylesheet">     

            <link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />        
            <!--<link rel="stylesheet" type="text/css" href="${cp}/resources/css/site.css?v=${version}" />-->      
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/dash/maindash.css?v=${version}" />


        </head>

        <body class="<c:if test="${cookie['small'].value != 'true'}">nav-md</c:if> <c:if test="${cookie['small'].value == 'true'}">nav-sm</c:if>">
                <div class="container body">
                    <div class="main_container">
                        <div id="fix" class="col-md-3 left_col">
                            <div class="left_col scroll-view">
                                <div class="navbar nav_title" style="border: 0;">
                                        <a href="<c:url value="/"/>" >
                                    <img src="${cp}/assets/images/logowhite.png" alt="logo" width="65px" style="float: left">
                                    <span class="site_title" style="width: auto"><spring:message code="index.home"/></span> </a>
                            </div>
                            <div class="clearfix"></div>
                            <!-- menu profile quick info -->
                            <!--                            <div class="profile">
                                                            <div class="profile_info">                                    
                                                                <h2> <span>Welcome: </span> ${curentuser.getName()}&nbsp;${curentuser.getLastname()}</h2>                           
                                                            </div>
                                                        </div>-->
                            <!-- /menu profile quick info -->

                            <div class="clearfix"></div>

                            <!-- sidebar menu -->
                            <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
                                <div class="menu_section">
                                    <!--<h3>Navigation</h3>-->
                                    <ul class="nav side-menu">
                                        <li><a><i class="fa fas fa-info  "></i> <spring:message code="index.personal"/> <span class="fa fas fa-chevron-down"></span></a>
                                            <ul class="nav child_menu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>                                            
                                                <li><a href="<c:url value="/profile"/>"> <spring:message code="index.profile"/></a></li>
                                                <li><a href="<c:url value="/dashboard/"/>"><spring:message code="index.personaldashboards"/></a></li>
                                                <li><a href="<c:url value="/infrastructure/"/>"><spring:message code="index.infrastructure"/></a></li>
                                                <li><a href="https://www.oddeye.co/documentation/" target="_blank"><spring:message code="index.help"/></a></li>
                                            </ul>
                                        </li>
                                        <li><a><i class="fa far fa-bell"></i> <spring:message code="index.monitoring"/> <span class="fa fas fa-chevron-down"></span></a>
                                            <ul class="nav child_menu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>                                            
                                                <li><a href="<c:url value="/monitoring"/>"><spring:message code="index.realtime"/></a></li>
                                                    <c:forEach items="${curentuser.getOptionsListasObject()}" var="option">
                                                    <li class="text-nowrap">
                                                        <a href="<spring:url value="/monitoring/${option.key}/"  htmlEscape="true"/>" title="${Dush.key}">                                                         
                                                               
                                                            ${option.key}                                                             
                                                        </a>

                                                    </li>
                                                </c:forEach>                                                

                                                    <li><a href="<c:url value="/errorsanalysis"/>"><spring:message code="index.detailed"/></a></li>
                                            </ul>
                                        </li>                                        
                                        <li><a><i class="fa fas fa-desktop"></i> <spring:message code="index.DashboardsDushlist"/> (${curentuser.getDushList().size()}) <span class="fa fas fa-chevron-down"></span></a>
                                            <ul class="nav child_menu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>                                                                                        
                                                <li><a href="<c:url value="/dashboard/new"/>" id="newdush"><spring:message code="index.newDashboard"/></a></li>
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
                                            <li><a><i class="fa fa-edit"></i> Managment <span class="fa fas fa-chevron-down"></span></a>
                                                <ul class="nav child_menu" <c:if test="${cookie['small'].value == 'true'}">style="display: none"</c:if>>                                                                                        
                                                    <sec:authorize access="hasRole('USERMANAGER')">
                                                        <li><a href="<c:url value="/userslist"/>" >Users</a></li>
                                                        <li><a href="<c:url value="/cookreport"/>" >CookAREKY</a></li>
                                                        <li><a href="<c:url value="/paymentslist"/>" >Payments</a></li>
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
                                        <%--<sec:authorize access="hasRole('ROLE_CAN_SWICH')">
                                            <li><a><i class="fa fa-asterisk"></i> Administrations <span class="fa fas fa-chevron-down"></span></a>
                                                <ul class="nav child_menu">                                                                                        
                                                     <li><a href="<c:url value="/templatelist"/>" >Templates</a></li>                                         
                                                </ul>
                                            </li>
                                        </sec:authorize>--%>                                              
                                    </ul>
                                </div>
                            </div>
                            <!-- /sidebar menu -->
                        </div>
                    </div>
                    <!-- /menu footer buttons -->
                    <div class="sidebar-footer hidden-small">
                        <a href="<c:url value="/logout/" />" data-toggle="tooltip" data-placement="top" title="Logout" >
                            <span class="glyphicon glyphicon-off" aria-hidden="true"></span>
                        </a>
                        <a data-toggle="tooltip" data-placement="top" title="FullScreen" id="FullScreen">
                            <span class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span>
                        </a>
                        <a data-toggle="tooltip" data-placement="top" title="Settings" href="${cp}/profile/edit">
                            <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                        </a>                            
                        <a data-toggle="tooltip" data-placement="top" title="Monitoring" href="<c:url value="/monitoring"/>">
                            <span class="fa far fa-clock" aria-hidden="true"></span>
                        </a>                                                        
                        <!--                        <a data-toggle="tooltip" data-placement="top" title="Lock">
                                                    <span class="glyphicon glyphicon-eye-close" aria-hidden="true"></span>
                                                </a>-->
                    </div>
                    <!-- /menu footer buttons -->
                    <!-- top navigation -->
                    <div class="top_nav">
                        <div class="nav_menu">
                            <nav class="" role="navigation">
                                <div class="nav toggle">
                                    <a id="menu_toggle"><i class="fa fa-bars"></i></a>
                                </div>
                                <div class="nav nav-pagetitle">
                                    <h1 class="pagetitle">${htitle} </h1>
                                </div>
                                <ul class="nav navbar-nav navbar-right">
                                    <li class="">                                        
                                        <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                            <c:if test="${curentuser.getSwitchUser()==null}">
                                                ${curentuser.getEmail()}                                                                                                                                              
                                            </c:if>
                                            <c:if test="${curentuser.getSwitchUser()!=null}">
                                                <b><spring:message code="index.switchedto"/> ${curentuser.getSwitchUser().getEmail()}</b>
                                            </c:if>&nbsp;                                 
                                            <span class=" fa fas fa-angle-down"></span>
                                        </a>
                                        <ul class="dropdown-menu dropdown-usermenu pull-right">
                                            <li class="">     
                                                ${curentuser.reload()}
                                                <c:set var="balance" value="${curentuser.getBalance()}" />
                                                <c:if test="${balance>0}">
                                                    <a href="javascript:;" class="user-profile">
                                                        <spring:message code="balance"/>&nbsp;
                                                        <c:if test="${balance<Double.MAX_VALUE}">
                                                            <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${balance}" />
                                                        </c:if>
                                                        <c:if test="${balance==Double.MAX_VALUE}">
                                                            <span class="infin"> &infin;</span>
                                                        </c:if>                                                        
                                                    </a>
                                                </c:if>                                            
                                            </li>                                            
                                            <li>
                                                <a href="javascript:void(0);" class="cluser-profile" id="allowedit">
                                                    <c:if test="${curentuser.getAlowswitch()}">
                                                        <img src="${cp}/assets/images/allowedit.png" alt="Allow Edit" width="15px">
                                                    </c:if>                                                    
                                                    <spring:message code="index.allowedit"/>                                            
                                                </a>
                                            </li> 
                                            <c:if test="${curentuser.getSwitchUser()!=null}">
                                                <li><a href="<c:url value="/switchoff/"/>"><i class="fa fa-sign-out pull-right"></i> <spring:message code="index.switchoff"/></a></li>
                                                </c:if>
                                                <c:url value="/logout/" var="logoutUrl" />
                                                <li><a href="${logoutUrl}"><i class="fa fa-sign-out pull-right"></i> <spring:message code="Logout"/> </a></li>
                                        </ul>
                                    </li>
                                    <!--                                    <li role="presentation" class="dropdown">
                                                                            <a href="javascript:;" class="dropdown-toggle info-number" data-toggle="dropdown" aria-expanded="false">
                                                                                <i class="fa fa-envelope-o"></i>
                                                                                <span class="badge bg-green">6</span>
                                                                            </a>
                                                                            <ul id="menu1" class="dropdown-menu list-unstyled msg_list" role="menu">
                                                                                <li>
                                                                                    <a>                                                    
                                                                                        <span>
                                                                                            <span>John Smith</span>
                                                                                            <span class="time">3 mins ago</span>
                                                                                        </span>
                                                                                        <span class="message">
                                                                                            Film festivals used to be do-or-die moments for movie makers. They were where...
                                                                                        </span>
                                                                                    </a>
                                                                                </li>
                                                                                <li>
                                                                                    <a>                                                    
                                                                                        <span>
                                                                                            <span>John Smith</span>
                                                                                            <span class="time">3 mins ago</span>
                                                                                        </span>
                                                                                        <span class="message">
                                                                                            Film festivals used to be do-or-die moments for movie makers. They were where...
                                                                                        </span>
                                                                                    </a>
                                                                                </li>
                                                                                <li>
                                                                                    <a>                                                    
                                                                                        <span>
                                                                                            <span>John Smith</span>
                                                                                            <span class="time">3 mins ago</span>
                                                                                        </span>
                                                                                        <span class="message">
                                                                                            Film festivals used to be do-or-die moments for movie makers. They were where...
                                                                                        </span>
                                                                                    </a>
                                                                                </li>
                                                                                <li>
                                                                                    <a>                                                    
                                                                                        <span>
                                                                                            <span>John Smith</span>
                                                                                            <span class="time">3 mins ago</span>
                                                                                        </span>
                                                                                        <span class="message">
                                                                                            Film festivals used to be do-or-die moments for movie makers. They were where...
                                                                                        </span>
                                                                                    </a>
                                                                                </li>
                                                                                <li>
                                                                                    <div class="text-center">
                                                                                        <a>
                                                                                            <strong>See All Messges</strong>
                                                                                            <i class="fa fa-angle-right"></i>
                                                                                        </a>
                                                                                    </div>
                                                                                </li>
                                                                            </ul>
                                                                        </li>                                    -->
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <li class=""><a>
                                                <%
                                                    InetAddress ia = InetAddress.getLocalHost();
                                                    String node = ia.getHostName();
                                                    pageContext.setAttribute("node", node);
                                                %>          
                                                Server ${node}
                                            </a></li>
                                        </sec:authorize>
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
                                <spring:message code="index.alertnotactivate"/>
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
            <%--<c:if test="${activeuser.getFirstlogin()==true}">--%>
            <c:if test="${false==true}">
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
            <script src="<c:url value="/assets/dist/jquery.min.js?v=${version}"/>"></script>    

            <script src="${cp}/assets/dist/switchery.min.js?v=${version}"></script>

            <script src="${cp}/assets/dist/jquery-ui.custom.min.js?v=${version}"></script>                    
            <script src="${cp}/assets/dist/jquery.autocomplete.min.js?v=${version}"></script>        
            <script src="${cp}/assets/dist/jquery.spincrement.min.js?v=${version}"></script>        

            <!-- Bootstrap -->
            <script src="${cp}/resources/bootstrap/dist/js/bootstrap.min.js?v=${version}"></script>
            <!-- moment.js -->
            <script src="${cp}/resources/js/moment/moment.min.js?v=${version}"></script>        
            <!--bootstrap-progressbar--> 
            <script src="${cp}/resources/bootstrap-progressbar/bootstrap-progressbar.min.js?v=${version}"></script>
            <!--iCheck--> 
            <script src="${cp}/resources/iCheck/icheck.min.js?v=${version}"></script>
            <!-- Bootstrap Colorpicker -->
            <script src="${cp}/resources/mjolnic-bootstrap-colorpicker/dist/js/bootstrap-colorpicker.min.js?v=${version}"></script>
            <!-- Bootstrap bootstrap-daterangepicker -->
            <script src="${cp}/resources/bootstrap-daterangepicker/daterangepicker.js?v=${version}"></script>        
            <!-- Custom Theme Scripts -->
            <script src="${cp}/resources/build/js/custom.min.js?v=${version}"></script>
            <!-- Select2 -->
            <script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>

            <script src="${cp}/assets/dist/sockjs-1.1.1.min.js?v=${version}"></script> 
            <script src="${cp}/assets/js/stomp.min.js?v=${version}"></script>                        
            <script src="<c:url value="/assets/js/general.min.js?v=${version}"/>"></script>    
            <script src="${cp}/resources/js/global.js?v=${version}"></script>        

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
        </body>
    </html>
</compress:html>