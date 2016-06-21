<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="cp" value="${pageContext.request.servletContext.contextPath}" scope="request" />

<!DOCTYPE html>
<html lang="en"> 
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Meta, title, CSS, favicons, etc. -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Oddeye </title>

        <!-- Bootstrap -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap/dist/css/bootstrap.min.css" />    
        <!-- Font Awesome -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/font-awesome/css/font-awesome.min.css" />        
        <!-- iCheck -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/iCheck/skins/flat/green.css" />        
        <!-- bootstrap-progressbar -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css" />            
        <!-- Select2 -->
        <link href="${cp}/resources/select2/dist/css/select2.min.css" rel="stylesheet">        
        <!-- jVectorMap -->
        <link href="${cp}/resources/css/maps/jquery-jvectormap-2.0.3.css" rel="stylesheet"/>
        <!-- Custom Theme Style -->
        <link rel="stylesheet" type="text/css" href="${cp}/resources/build/css/custom.min.css" />        
    </head>

    <body class="login">
        <jsp:include page="${body}.jsp" />               

        <!-- jQuery -->
        <script src="${cp}/resources/jquery/dist/jquery.min.js"></script>
        <!-- Bootstrap -->
        <script src="${cp}/resources/bootstrap/dist/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="${cp}/resources/fastclick/lib/fastclick.js"></script>
        <!-- NProgress -->
        <script src="${cp}/resources/nprogress/nprogress.js"></script>
        <!-- Chart.js -->
        <script src="${cp}/resources/Chart.js/dist/Chart.min.js"></script>
        <!-- gauge.js -->
        <script src="${cp}/resources/gauge.js/dist/gauge.min.js"></script>
        <!-- bootstrap-progressbar -->
        <script src="${cp}/resources/bootstrap-progressbar/bootstrap-progressbar.min.js"></script>
        <!-- iCheck -->
        <script src="${cp}/resources/iCheck/icheck.min.js"></script>
        <!-- Skycons -->
        <script src="${cp}/resources/skycons/skycons.js"></script>
        <!-- Flot -->
        <script src="${cp}/resources/Flot/jquery.flot.js"></script>
        <script src="${cp}/resources/Flot/jquery.flot.pie.js"></script>
        <script src="${cp}/resources/Flot/jquery.flot.time.js"></script>
        <script src="${cp}/resources/Flot/jquery.flot.stack.js"></script>
        <script src="${cp}/resources/Flot/jquery.flot.resize.js"></script>
        <!-- Flot plugins -->
        <script src="${cp}/resources/js/flot/jquery.flot.orderBars.js"></script>
        <script src="${cp}/resources/js/flot/date.js"></script>
        <script src="${cp}/resources/js/flot/jquery.flot.spline.js"></script>
        <script src="${cp}/resources/js/flot/curvedLines.js"></script>
        <!-- jVectorMap -->
        <script src="${cp}/resources/js/maps/jquery-jvectormap-2.0.3.min.js"></script>
        <!-- bootstrap-daterangepicker -->
        <script src="${cp}/resources/js/moment/moment.min.js"></script>
        <script src="${cp}/resources/js/datepicker/daterangepicker.js"></script>

        <!-- Custom Theme Scripts -->
        <script src="${cp}/resources/build/js/custom.min.js"></script>

        <jsp:include page="${body}js.jsp" />
    </body>
</html>