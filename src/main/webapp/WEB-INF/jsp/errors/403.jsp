<%-- 
    Document   : 404
    Created on : Feb 27, 2017, 9:44:04 AM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>    

<div class="x_panel">
    <h1><spring:message code="403.error.h1"/></h1>  
    <a href="<c:url value="/"/>">Home</a>
</div>
