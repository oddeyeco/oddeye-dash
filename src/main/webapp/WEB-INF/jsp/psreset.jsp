<%-- 
    Document   : psreset
    Created on : May 29, 2019, 22:27:20
    Author     : sasha
--%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="main"></div>
<div class="container center sineup" style="padding-top: 100px;">    
    <h2 class="text-center"><spring:message code="signupconfirm.thankYou.h2"/></h2>        
    <div class="row">
        <div class="col-lg-4 col-xs-12 text-right">
            <a href="${cp}/">
                <c:if test="${empty whitelabel}" >
                    <a href="https://www.oddeye.co/" ><img src="${cp}/assets/images/logowhite.png" alt="logo" width="250px"></a>                
                </c:if>                        
                <c:if test="${not empty whitelabel}" >
                    <a href="https://${whitelabel.url}/" ><img src="${cp}${whitelabel.getFullfileName()}${whitelabel.logofilename}" alt="logo" width="250px"></a>                                
                </c:if>                

            </a>                            
            <div>
                <spring:message code="sineup.demoInfo"/>
            </div>
        </div>    
        <div class="col-lg-4 col-xs-12 text-right">
            <spring:message code="signupconfirm.thankYouForRegistering"/>
        </div>              
    </div>
</div>
