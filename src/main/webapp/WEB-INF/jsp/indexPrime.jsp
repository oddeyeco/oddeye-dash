<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor"  prefix="compress"%>
<compress:html removeIntertagSpaces="true" removeMultiSpaces="true"  compressCss="true" compressJavaScript="true">
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <c:set var="cp" value="${pageContext.request.servletContext.contextPath}" scope="request" />
    <c:set var="version" value="0.2.16" scope="request"/>
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <meta name="description" content="">
            <meta name="author" content="">
            <c:set var="image" value="oddeyeog.png" scope="request" />
            <c:if test="${!empty ogimage}">                        
                <c:set var="image" value="${ogimage}" scope="request" />
            </c:if>              
            <meta property="og:image" content="https://${pageContext.request.getHeader("X-OddEye-Host")}${cp}/assets/images/${image}" />            
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
            <link rel="stylesheet" type="text/css" href="${cp}/resources/build/css/custom.min.css?v=${version}" />
            <link rel="stylesheet" href="<c:url value="/assets/css/main.css?v=${version}"/>" />
            <!-- font-awesome -->
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/solid.css?v=${version}" />
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/regular.css?v=${version}" />            
            <link rel="stylesheet" type="text/css" href="${cp}/assets/css/font-awesome/fontawesome.css?v=${version}" />
        </head>

        <body>        
            <!--            <div>  
                            <main>  -->
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
            <!--                </main>
                            <footer>
            
                            </footer>
                        </div>-->
            <script>
                var cp = "${cp}";
            </script>
            <script src="<c:url value="/assets/dist/jquery.min.js?v=${version}"/>"></script>    
            <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js?v=${version}" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
            <script src="${cp}/resources/bootstrap/dist/js/bootstrap.min.js?v=${version}"></script>
            <!-- Select2 -->
            <script src="${cp}/resources/select2/dist/js/select2.full.min.js?v=${version}"></script>

            <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
            <!--<script src="../../assets/js/ie10-viewport-bug-workaround.js?v=${version}"></script>-->                            
            <!--iCheck--> 
            <script src="${cp}/resources/iCheck/icheck.min.js?v=${version}"></script>
            <!--<script src="${cp}/resources/js/general.js?v=${version}"></script>-->
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
            <c:catch var="e">                
                <c:if test="${!empty wraper}">                        
                    <c:import url="${wraper}js.jsp" />
                </c:if>             
                <c:catch var="e">
                    <c:import url="${jspart}.jsp" />
                </c:catch>           

            </c:catch>
        </body>

    </html>
</compress:html>
