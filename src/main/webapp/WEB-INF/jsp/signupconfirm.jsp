<%-- 
    Document   : signupconfirm
    Created on : Jun 26, 2017, 1:27:28 PM
    Author     : vahan
--%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<div id="main"></div>
<div class="container center sineup" style="padding-top: 100px;">    
    <h2 class="text-center"><spring:message code="signupconfirm.thankYou.h2"/></h2>        
    <div class="row">
        <div class="col-lg-4 col-xs-12 text-right">
            <a href="${cp}/"><img src="${cp}/assets/images/logowhite.png" alt="logo" width="250px"></a>                            
            <div>
               <spring:message code="sineup.demoInfo"/>
            </div>
        </div>    
        <div class="col-lg-4 col-xs-12 text-right">
            <spring:message code="signupconfirm.thankYouForRegistering"/>
        </div>              
    </div>
</div>
