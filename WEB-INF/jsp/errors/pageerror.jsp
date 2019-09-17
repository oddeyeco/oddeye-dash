<%-- 
    Document   : pageerror
    Created on : Mar 2, 2017, 12:29:36 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>    

<div class="x_panel">
    <h1><spring:message code="pageerror.h1"/></h1>    
    <h2 class="alert alert-danger alert-dismissible fade in " role="alert">    
        <spring:message code="pageerror.h2" arguments="${title},${body}"/> </h2>    
</div>
