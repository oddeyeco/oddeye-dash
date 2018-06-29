<%-- 
    Document   : pageerror
    Created on : Mar 2, 2017, 12:29:36 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>    

<div class="x_panel">
    <h1><spring:message code="pageerror.notExist.h1"/></h1>    
    <h2 class="alert alert-danger alert-dismissible fade in " role="alert">    
        "${body}" <spring:message code="pageerror.notExist.h2"/></h2>    
</div>
