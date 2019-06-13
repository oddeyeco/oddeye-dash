<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}"/>        -->
<link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}"/>
 
<div class="row">
    <div class="col-12">
        <div class="card shadow">
            <h4 class="card-header">
                <spring:message code="profileedit.controlSecure.h2"/>
            </h4>
            
            <div class="card-body pr-0 pl-0" role="tabpanel" data-example-id="togglable-tabs">            
                <nav id="nav-customTab" class="nav nav-tabs pl-sm-5 pl-sm-2 p-0 customTab"  role="tablist">                        
                    <c:choose>                    
                        <c:when test="${(!empty result) && (tab == \"level-tab\")}">
                            <a class="nav-item nav-link disabled <c:if test="${tab == \"general-tab\"}">active</c:if>" id="nav-general-tab" data-toggle="tab" href="#nav-general" role="tab" aria-controls="nav-general" aria-selected="true"><spring:message code="profileedit.general"/></a>
                            <a class="nav-item nav-link <c:if test="${tab == \"level-tab\"}">active</c:if> ml-2" id="nav-levelsSettings-tab" data-toggle="tab" href="#nav-levelsSettings" role="tab" aria-controls="nav-levelsSettings" aria-selected="false"><spring:message code="profileedit.levelsSettings"/></a>
                            <a class="nav-item nav-link disabled <c:if test="${tab == \"pass-tab\"}">active</c:if> ml-2" id="nav-security-tab" data-toggle="tab" href="#nav-security" role="tab" aria-controls="nav-security" aria-selected="false"><spring:message code="profileedit.security"/></a>
                        </c:when>                        
                        <c:when test="${(!empty result) && (tab == \"pass-tab\")}">                        
                            <a class="nav-item nav-link disabled <c:if test="${tab == \"general-tab\"}">active</c:if>" id="nav-general-tab" data-toggle="tab" href="#nav-general" role="tab" aria-controls="nav-general" aria-selected="true"><spring:message code="profileedit.general"/></a>
                            <a class="nav-item nav-link disabled <c:if test="${tab == \"level-tab\"}">active</c:if> ml-2" id="nav-levelsSettings-tab" data-toggle="tab" href="#nav-levelsSettings" role="tab" aria-controls="nav-levelsSettings" aria-selected="false"><spring:message code="profileedit.levelsSettings"/></a>
                            <a class="nav-item nav-link <c:if test="${tab == \"pass-tab\"}">active</c:if> ml-2" id="nav-security-tab" data-toggle="tab" href="#nav-security" role="tab" aria-controls="nav-security" aria-selected="false"><spring:message code="profileedit.security"/></a>
                        </c:when>                            
                        <c:when test="${(!empty result) && (tab == \"general-tab\")}">
                            <a class="nav-item nav-link <c:if test="${tab == \"general-tab\"}">active</c:if>" id="nav-general-tab" data-toggle="tab" href="#nav-general" role="tab" aria-controls="nav-general" aria-selected="true"><spring:message code="profileedit.general"/></a>
                            <a class="nav-item nav-link disabled <c:if test="${tab == \"level-tab\"}">active</c:if> ml-2" id="nav-levelsSettings-tab" data-toggle="tab" href="#nav-levelsSettings" role="tab" aria-controls="nav-levelsSettings" aria-selected="false"><spring:message code="profileedit.levelsSettings"/></a>
                            <a class="nav-item nav-link disabled <c:if test="${tab == \"pass-tab\"}">active</c:if> ml-2" id="nav-security-tab" data-toggle="tab" href="#nav-security" role="tab" aria-controls="nav-security" aria-selected="false"><spring:message code="profileedit.security"/></a>
                        </c:when>                            
                        <c:otherwise>
                            <a class="nav-item nav-link <c:if test="${tab == \"general-tab\"}">active</c:if>" id="nav-general-tab" data-toggle="tab" href="#nav-general" role="tab" aria-controls="nav-general" aria-selected="true"><spring:message code="profileedit.general"/></a>                        
                            <a class="nav-item nav-link <c:if test="${tab == \"level-tab\"}">active</c:if> ml-2" id="nav-levelsSettings-tab" data-toggle="tab" href="#nav-levelsSettings" role="tab" aria-controls="nav-levelsSettings" aria-selected="false"><spring:message code="profileedit.levelsSettings"/></a>                        
                            <a class="nav-item nav-link <c:if test="${tab == \"pass-tab\"}">active</c:if> ml-2" id="nav-security-tab" data-toggle="tab" href="#nav-security" role="tab" aria-controls="nav-security" aria-selected="false"><spring:message code="profileedit.security"/></a>

                        </c:otherwise>                        
                    </c:choose>                                     
                </nav>

                <div id="nav-tabContent" class="tab-content pr-3 pl-3 pt-4">
                    <div class="tab-pane fade show <c:if test="${tab == \"general-tab\"}">active</c:if>" id="nav-general" role="tabpanel" aria-labelledby="nav-general-tab">
                        <form:form method="post" action="${cp}/profile/saveuser" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left" id="userdata">                            
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="name">
                                    <spring:message code="profileedit.firstName"/> <span class="required">*</span>
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.firstName" var="ph"/> 
                                    <form:input path="name" cssClass="form-control" required="" placeholder="${ph}"/>
                                    <form:errors path="name" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="lastname">
                                    <spring:message code="profileedit.lastName"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.lastName" var="ph"/> 
                                    <form:input path="lastname" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="lastname" />
                                </div>
                            </div>                    
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="company">
                                    <spring:message code="profileedit.companyName"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.companyName" var="ph"/>
                                    <form:input path="company" cssClass="form-control" placeholder="${ph} "/>
                                    <form:errors path="company" />
                                </div>
                            </div>
                            <div class="form-group row">   
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="country">
                                    <spring:message code="profileedit.country"/>
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <%-- <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1" />                                       
                                         <form:errors path="country" /> --%>                    
                                    <form:select path="country" items="${countryList}" cssClass="form-control"/>                                       
                                    <form:errors path="country" />                    
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="city">
                                    <spring:message code="profileedit.city"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.city" var="ph"/>    
                                    <form:input path="city" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="city" />                    
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="region">
                                    <spring:message code="profileedit.region"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.region" var="ph"/> 
                                    <form:input path="region" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="region" />              
                                </div>
                            </div>
                            <div class="form-group row">                    
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="timezone">
                                    <spring:message code="profileedit.timezone"/> <span class="required">*</span>
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <%-- <form:select path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                       
                                    <form:errors path="timezone" />--%> 
                                    <form:select path="timezone" items="${tzone}" cssClass="form-control"/>                                        
                                    <form:errors path="timezone" />
                                </div>
                            </div>    
                            <div class="form-group row">                    
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="template">
                                    <spring:message code="profileedit.template"/>
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <%--<form:select path="template" cssClass="form-control select2_tz" tabindex="-1">--%>
                                    <form:select path="template" cssClass="form-control">                                    
                                        <form:option value="default" ><spring:message code="profileedit.template.default"/></form:option>
                                        <form:option value="dark" ><spring:message code="profileedit.template.dark"/></form:option>
                                        <%--  <form:option value="dark2" ><spring:message code="profileedit.template.dark2"/></form:option> --%>
                                    </form:select>
                                    <form:errors path="template" />
                                </div>
                            </div>                                                             
                            <div class="form-group row">
                                <div class="col-lg-6 col-md-6 col-12 offset-lg-4"> 
                                    <button type="reset" class="btn btn-outline-primary mr-1"><spring:message code="cancel"/></button>
                                    <button type="submit" class="btn btn-outline-success"><spring:message code="save"/></button>
                                </div>
                            </div>
                        </form:form> 
                    </div>

                    <div class="tab-pane fade show <c:if test="${tab == \"level-tab\"}">active</c:if>" id="nav-levelsSettings" role="tabpanel" aria-labelledby="nav-levelsSettings-tab">                        
                        <form:form method="post" action="${cp}/profile/saveuserlevels" modelAttribute="newuserleveldata" novalidate="true" cssClass="form-horizontal form-label-left" id="newuserleveldata">                            
                            <div class="table-responsive">
                                <table class="data table table-striped no-margin">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th><spring:message code="profileedit.levelsSettings.name"/></th>
                                            <th><spring:message code="minValue"/></th>
                                            <th><spring:message code="minPercent"/></th>
                                            <th><spring:message code="minWeight"/></th>
                                            <th><spring:message code="minRecurrenceCount"/></th>
                                            <th><spring:message code="minPredictPercent"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${newuserdata.getAlertLevels()}" var="AlertLevel" varStatus="loopgrups">
                                            <tr>
                                                <td>${loopgrups.index+1}</td>
                                                <td><spring:message code="level_${AlertLevel.getKey()}"/>
                                                    <!--  ${newuserdata.getAlertLevels().getName(AlertLevel.getKey())} -->                                                                               
                                                </td>
                                                <c:forEach items="${AlertLevel.getValue()}" var="Value" >
                                                    <td>                                                
                                                        <form:input path="AlertLevels[${AlertLevel.getKey()}][${Value.getKey()}]" cssClass="form-control"/>
                                                        <form:errors path="AlertLevels[${AlertLevel.getKey()}][${Value.getKey()}]" />
                                                        <!--<input class="form-control" value="${Value.getValue()}" type="number" name="[${AlertLevel.getKey()}][${Value.getKey()}]">-->    
                                                    </td>
                                                </c:forEach>                                
                                            </tr>                    
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="form-group">
                                <div class="float-left">
                                    <button type="reset" class="btn btn-outline-primary mr-1"><spring:message code="cancel"/></button>
                                    <button type="submit" class="btn btn-outline-success"><spring:message code="save"/></button>
                                </div>
                            </div>                        

                        </form:form>
                    </div>

                    <div class="tab-pane fade show <c:if test="${tab == \"pass-tab\"}">active</c:if>" id="nav-security" role="tabpanel" aria-labelledby="nav-security-tab">                                                        
                        <form:form method="post" action="${cp}/profile/changepassword" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left" id="passwordform">
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="name">
                                    <spring:message code="profileedit.security.oldPassword"/>
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.security.oldPassword" var="ph"/>
                                    <form:input path="oldpassword" cssClass="form-control" required="" placeholder="${ph}" type="password"/>
                                    <form:errors path="oldpassword" />
                                </div>                              
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="name">
                                    <spring:message code="profileedit.security.newPassword"/>
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.security.newPassword" var="ph"/>
                                    <input id="password" name="password" class="form-control" placeholder="${ph}" type="password" value="">
                                    <form:errors path="password" />
                                </div>                               
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="name">
                                    <spring:message code="profileedit.security.reEnterNewPassword"/>
                                </label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <spring:message code="profileedit.security.reEnterNewPassword" var="ph"/>
                                    <form:input path="passwordsecond" cssClass="form-control" required="" placeholder="${ph}" type="password"/>
                                    <form:errors path="passwordsecond" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-lg-5 col-md-6 col-12 offset-lg-4">
                                    <button type="reset" class="btn btn-outline-primary mr-1"><spring:message code="cancel"/></button>
                                    <button type="submit" class="btn btn-outline-success"><spring:message code="savePassword"/></button>
                                </div>
                            </div>    
                        </form:form> 
                    </div>
                </div>
            </div>
        </div>
    </div>   
</div>                    




                        
                        
                        
                        
                        