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
            <header class="container" style="text-align: center">         
                <a href="${cp}/"><img src="${cp}/assets/images/logo.png" alt="logo"></a>                
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