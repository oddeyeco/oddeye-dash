<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor"  prefix="compress"%>
<compress:html removeIntertagSpaces="true" removeMultiSpaces="true"  compressCss="true" compressJavaScript="true">
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <c:set var="cp" value="${pageContext.request.servletContext.contextPath}" scope="request" />
    <c:set var="version" value="0.2.11" scope="request"/>
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <meta name="description" content="">
            <meta name="author" content="">
            <meta property="og:image" content="https://${pageContext.request.getHeader("X-OddEye-Host")}${cp}/assets/images/oddeyeog.png" />            
            <title>${title} | oddeye.co </title>
            <link rel="shortcut icon" href="${cp}/assets/images/logo.png" type="image/x-icon">
            <link rel="icon" href="${cp}/assets/images/logo.png" type="image/x-icon">
            <!-- Select2 -->
            <link href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}" rel="stylesheet">        
            <!-- Bootstrap -->
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/bootstrap/bootstrap.css?v=${version}" />      
            <!-- bootstrap-progressbar -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css?v=${version}" />            
            <!-- iCheck -->
            <link rel="stylesheet" type="text/css" href="${cp}/resources/iCheck/skins/flat/green.css?v=${version}" />                              
            <link rel="stylesheet" href="<c:url value="/assets/css/main.css?v=${version}"/>" />


        </head>

        <body>        
            <!--<header class="">-->
            <div>
                <header class="container" style="text-align: center">                       
                    <!--<a href="${cp}/"><img src="${cp}/assets/images/logo.png" alt="logo"></a>-->                
                </header>    
                <main>  
                    <c:if test="${!empty wraper}">                        
                        <c:import url="${wraper}.jsp" />
                    </c:if>             
                    <c:if test="${empty wraper}">
                        <c:catch var="e">
                            <c:import url="${body}.jsp" />
                        </c:catch>
                        <c:if test="${!empty e}">
                            ${body} <c:import url="errors/pageerror.jsp" />
                        </c:if>             
                    </c:if>
                </main>
                <footer>

                </footer>
            </div>
            <script src="<c:url value="/assets/dist/jquery.min.js?v=${version}"/>"></script>    
            <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js?v=${version}" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
            <script src="${cp}/resources/bootstrap/dist/js/bootstrap.min.js?v=${version}"></script>
            <!-- Select2 -->
            <script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>

            <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
            <!--<script src="../../assets/js/ie10-viewport-bug-workaround.js?v=${version}"></script>-->                            
            <!--iCheck--> 
            <script src="${cp}/resources/iCheck/icheck.min.js?v=${version}"></script>
            <script src="<c:url value="/assets/js/general.min.js?v=${version}"/>"></script>    
            <script src="<c:url value="/assets/js/public.min.js?v=${version}"/>"></script>    
            <!-- moment.js -->
            <script src="${cp}/resources/js/moment/moment.min.js?v=${version}"></script>                    
            <script src="${cp}/resources/js/moment/moment-timezone-with-data.min.js?v=${version}"></script>        
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
                setTimeout("ga('send', 'event', '10 seconds', 'read')", 10000);
            </script>               

            <c:catch var="e">
                <c:import url="${jspart}.jsp" />
            </c:catch>
        </body>

    </html>
</compress:html>