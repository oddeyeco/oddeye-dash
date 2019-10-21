<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>    

<div class="x_panel">
<h1><spring:message code="404.error.h1"/></h1>    
<h2 class="alert alert-danger alert-dismissible fade show " role="alert">    
${exception.getMessage()}</h2>    
</div>
