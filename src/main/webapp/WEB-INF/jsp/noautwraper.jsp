<%-- 
    Document   : noautwraper
    Created on : Dec 7, 2017, 1:06:52 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <c:catch var="e">
        <c:import url="${body}.jsp" />
    </c:catch>
    <c:if test="${!empty e}">
        ${body} <c:import url="errors/pageerror.jsp" />
    </c:if>  
</div>    
