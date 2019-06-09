<%-- 
    Document   : [srecoveryconfirm
    Created on : Jun 4, 2019, 1:21:30 PM
    Author     : sasha
--%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="main"></div>
<div class="container center sineup" style="padding-top: 100px;">    
    <h2 class="text-center"><spring:message code="psrecovery.thankYou.h2"/></h2>        
    <div class="row">
        <div class="col-lg-4 col-xs-12 text-right">
            <a href="${cp}/">
                    <a href="https://www.oddeye.co/" ><img src="${cp}/assets/images/logowhite.png" alt="logo" width="250px"></a>                
            </a>                            
            <div>
                <spring:message code="sineup.demoInfo"/>
            </div>
        </div>    
        <div class="col-lg-4 col-xs-12 text-right">
            <spring:message code="psrecoveryconfirm.mailHasBeenSent"/>
        </div>              
    </div>
</div>
