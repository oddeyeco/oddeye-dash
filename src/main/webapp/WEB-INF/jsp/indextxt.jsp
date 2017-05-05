<%@page contentType="text" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor"  prefix="compress"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:catch var="e">
    <c:import url="PublicPages/${body}.jsp" />
</c:catch>
<c:if test="${!empty e}">
    ${body} <c:import url="errors/pageerror.jsp" />
</c:if>             
