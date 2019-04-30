<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}" />        
<link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />

<div class="col-md-12 col-sm-12 col-xs-12">
    <div class="x_panel">
        <div class="x_title">
            <h2><spring:message code="profileedit.controlSecure.h2"/></h2>
            <div class="clearfix"></div>
        </div> 
            
        <div class="" role="tabpanel" data-example-id="togglable-tabs">            
            <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">    
                <c:choose>                    
                    <c:when test="${(!empty result) && (tab == \"level-tab\")}">
                        <li role="presentation" class="disabled <c:if test="${tab == \"general-tab\"}">active</c:if>  ">
                            <a id="general-tab" role="tab" aria-expanded="false"><spring:message code="profileedit.general"/></a>
                        </li>
                        <li role="presentation" class="<c:if test="${tab == \"level-tab\"}">active</c:if>  ">
                            <a href="#level_content" role="tab" id="level-tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.levelsSettings"/></a>
                        </li>
                        <li role="presentation" class="disabled <c:if test="${tab == \"pass-tab\"}">active</c:if>">
                            <a role="tab" id="profile-tab" aria-expanded="false"><spring:message code="profileedit.security"/></a>
                        </li>
                    </c:when>                        
                    <c:when test="${(!empty result) && (tab == \"pass-tab\")}">
                        <li role="presentation" class="disabled <c:if test="${tab == \"general-tab\"}">active</c:if>  ">
                            <a  id="general-tab" aria-expanded="false"><spring:message code="profileedit.general"/></a>
                        </li>
                        <li role="presentation" class="disabled <c:if test="${tab == \"level-tab\"}">active</c:if>  ">
                            <a  role="tab" id="level-tab" aria-expanded="false"><spring:message code="profileedit.levelsSettings"/></a>
                        </li>
                        <li role="presentation" class="<c:if test="${tab == \"pass-tab\"}">active</c:if>">
                            <a href="#tab_pass" role="tab" id="profile-tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.security"/></a>
                        </li>
                    </c:when>                            
                    <c:when test="${(!empty result) && (tab == \"general-tab\")}">
                        <li role="presentation" class="<c:if test="${tab == \"general-tab\"}">active</c:if>  ">
                            <a href="#general_content" id="general-tab" role="tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.general"/></a>
                        </li>
                        <li role="presentation" class="disabled <c:if test="${tab == \"level-tab\"}">active</c:if>  ">
                            <a role="tab" id="level-tab" aria-expanded="false"><spring:message code="profileedit.levelsSettings"/></a>
                        </li>
                        <li role="presentation" class="disabled <c:if test="${tab == \"pass-tab\"}">active</c:if>">
                            <a role="tab" id="profile-tab" aria-expanded="false"><spring:message code="profileedit.security"/></a>
                        </li>
                    </c:when>                            
                    <c:otherwise>
                        <li role="presentation" class="<c:if test="${tab == \"general-tab\"}">active</c:if>  ">
                            <a href="#general_content" id="general-tab" role="tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.general"/></a>
                        </li>
                        <li role="presentation" class="<c:if test="${tab == \"level-tab\"}">active</c:if>  ">
                            <a href="#level_content" role="tab" id="level-tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.levelsSettings"/></a>
                        </li>
                        <li role="presentation" class="<c:if test="${tab == \"pass-tab\"}">active</c:if>">
                            <a href="#tab_pass" role="tab" id="profile-tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.security"/></a>
                        </li>
                    </c:otherwise>                        
                </c:choose>                
            </ul>
            <div id="myTabContent" class="tab-content">
                <div role="tabpanel" class="tab-pane fade in <c:if test="${tab == \"general-tab\"}">active</c:if> " id="general_content" aria-labelledby="general_content">
                        <div class="x_content">
                            <br>                        
                        <form:form method="post" action="${cp}/profile/saveuser" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left" id="userdata">                            
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name"><spring:message code="profileedit.firstName"/> <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <spring:message code="profileedit.firstName" var="ph"/> 
                                    <form:input path="name" cssClass="form-control" required="" placeholder="${ph}"/>
                                    <form:errors path="name" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="lastname"><spring:message code="profileedit.lastName"/> 
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <spring:message code="profileedit.lastName" var="ph"/> 
                                    <form:input path="lastname" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="lastname" />
                                </div>
                            </div>                    
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="company"><spring:message code="profileedit.companyName"/> 
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <spring:message code="profileedit.companyName" var="ph"/>
                                    <form:input path="company" cssClass="form-control" placeholder="${ph} "/>
                                    <form:errors path="company" />
                                </div>
                            </div>
                            <div class="form-group">   
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="country"><spring:message code="profileedit.country"/>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                                    <form:errors path="country" />                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="city"><spring:message code="profileedit.city"/> 
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <spring:message code="profileedit.city" var="ph"/>    
                                    <form:input path="city" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="city" />                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="region"><spring:message code="profileedit.region"/> 
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <spring:message code="profileedit.region" var="ph"/> 
                                    <form:input path="region" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="region" />              
                                </div>
                            </div>
                            <div class="form-group">                    
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="timezone"><spring:message code="profileedit.timezone"/> <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:select path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                        
                                    <form:errors path="timezone" />
                                </div>
                            </div>    
                            <div class="form-group">                    
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="template"><spring:message code="profileedit.template"/>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:select path="template" cssClass="form-control select2_tz" tabindex="-1">
                                        <form:option value="default" ><spring:message code="profileedit.template.default"/></form:option>
                                        <form:option value="dark" ><spring:message code="profileedit.template.dark"/></form:option>
                                        <%--  <form:option value="dark2" ><spring:message code="profileedit.template.dark2"/></form:option> --%>
                                    </form:select>
                                    <form:errors path="template" />
                                </div>
                            </div>                                                             
                            <div class="form-group">
                                <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                                    <button type="reset" class="btn btn-primary"><spring:message code="cancel"/></button>
                                    <button type="submit" class="btn btn-success"><spring:message code="save"/></button>
                                </div>
                            </div>

                            <div class="clearfix"></div>
                        </form:form>                                                
                    </div>                
                </div>
                <div role="tabpanel" class="tab-pane fade in <c:if test="${tab == \"level-tab\"}">active</c:if> " id="level_content" aria-labelledby="level_content">
                    <form:form method="post" action="${cp}/profile/saveuserlevels" modelAttribute="newuserleveldata" novalidate="true" cssClass="form-horizontal form-label-left">                            
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
                            <div class="pull-right">
                                <button type="reset" class="btn btn-primary"><spring:message code="cancel"/></button>
                                <button type="submit" class="btn btn-success"><spring:message code="save"/></button>
                            </div>
                        </div>                        

                    </form:form>                    
                </div>
                <div role="tabpanel" class="tab-pane fade in <c:if test="${tab == \"pass-tab\"}">active</c:if>" id="tab_pass" aria-labelledby="pass-tab">
                        <div class="x_content">                                        
                        <form:form method="post" action="${cp}/profile/changepassword" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left" id="passwordform">
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name"><spring:message code="profileedit.security.oldPassword"/></label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <spring:message code="profileedit.security.oldPassword" var="ph"/>
                                    <form:input path="oldpassword" cssClass="form-control" required="" placeholder="${ph}" type="password"/>
                                    <form:errors path="oldpassword" />
                                </div>                              
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name"><spring:message code="profileedit.security.newPassword"/></label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <spring:message code="profileedit.security.newPassword" var="ph"/>
                                    <input id="password" name="password" class="form-control" placeholder="${ph}" type="password" value="">
                                    <form:errors path="password" />
                                </div>                               
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name"><spring:message code="profileedit.security.reEnterNewPassword"/></label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <spring:message code="profileedit.security.reEnterNewPassword" var="ph"/>
                                    <form:input path="passwordsecond" cssClass="form-control" required="" placeholder="${ph}" type="password"/>
                                    <form:errors path="passwordsecond" />
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">
                                    <button type="reset" class="btn btn-primary"><spring:message code="cancel"/></button>
                                    <button type="submit" class="btn btn-success"><spring:message code="savePassword"/></button>
                                </div>                                
                            </div>
                        </form:form>
                    </div>  
                </div>
            </div>
                        
        </div>
    </div>
</div>
                        <!--====================================================================================================-->
                        
<div class="col-lg-12 col-md-12 col-12 mb-4">
    <div class="card edit shadow">
        <h4 class="card-header">
            <spring:message code="profileedit.controlSecure.h2"/>
        </h4> 
        
        <div class="card-body pr-0 pl-0">            
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
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="name">
                                    <spring:message code="profileedit.firstName"/> <span class="required">*</span>
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <spring:message code="profileedit.firstName" var="ph"/> 
                                    <form:input path="name" cssClass="form-control" required="" placeholder="${ph}"/>
                                    <form:errors path="name" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="lastname">
                                    <spring:message code="profileedit.lastName"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <spring:message code="profileedit.lastName" var="ph"/> 
                                    <form:input path="lastname" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="lastname" />
                                </div>
                            </div>                    
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="company">
                                    <spring:message code="profileedit.companyName"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <spring:message code="profileedit.companyName" var="ph"/>
                                    <form:input path="company" cssClass="form-control" placeholder="${ph} "/>
                                    <form:errors path="company" />
                                </div>
                            </div>
                            <div class="form-group row">   
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="country">
                                    <spring:message code="profileedit.country"/>
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                                    <form:errors path="country" />                    
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="city">
                                    <spring:message code="profileedit.city"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <spring:message code="profileedit.city" var="ph"/>    
                                    <form:input path="city" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="city" />                    
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="region">
                                    <spring:message code="profileedit.region"/> 
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <spring:message code="profileedit.region" var="ph"/> 
                                    <form:input path="region" cssClass="form-control" placeholder="${ph}"/>
                                    <form:errors path="region" />              
                                </div>
                            </div>
                            <div class="form-group row">                    
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="timezone">
                                    <spring:message code="profileedit.timezone"/> <span class="required">*</span>
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <form:select path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                        
                                    <form:errors path="timezone" />
                                </div>
                            </div>    
                            <div class="form-group row">                    
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="template">
                                    <spring:message code="profileedit.template"/>
                                </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <form:select path="template" cssClass="form-control select2_tz" tabindex="-1">
                                        <form:option value="default" ><spring:message code="profileedit.template.default"/></form:option>
                                        <form:option value="dark" ><spring:message code="profileedit.template.dark"/></form:option>
                                        <%--  <form:option value="dark2" ><spring:message code="profileedit.template.dark2"/></form:option> --%>
                                    </form:select>
                                    <form:errors path="template" />
                                </div>
                            </div>                                                             
                            <div class="form-group row">
                                <div class="col-lg-6 col-md-6 col-12 offset-lg-4">                                    
                                    <a class="btn btn-outline-primary" href="#" role="button" type="reset"><spring:message code="cancel"/></a>
                                    <a class="btn btn-outline-success" href="#" role="button" type="submit"><spring:message code="save"/></a>
                                </div>
                            </div>
                        </form:form>
                        
                        
<!--                        <form id="userdata" class="" action="/OddeyeCoconut/profile/saveuser" method="post">
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="name">First Name <span class="required">*</span></label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <input id="name" name="name" class="form-control" placeholder="First Name" type="text" value="Demos">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="lastname">Last Name </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <input id="lastname" name="lastname" class="form-control" placeholder="Last Name" type="text" value="Demographos">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="company">Company Name </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <input id="company" name="company" class="form-control" placeholder="Company Name " type="text" value="oddeye.co">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="country">Country </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <select id="country" name="country" class="form-control select2_country select2-hidden-accessible" tabindex="-1" aria-hidden="true">
                                        <option value=""></option>
                                        <option value="AD">Andorra</option><option value="AE">United Arab Emirates</option>
                                        <option value="AF">Afghanistan</option><option value="AG">Antigua and Barbuda</option>
                                        <option value="AI">Anguilla</option><option value="AL">Albania</option>
                                        <option value="AM" selected="selected">Armenia</option><option value="AN">Netherlands Antilles</option>
                                        <option value="AO">Angola</option><option value="AQ">Antarctica</option>
                                        <option value="AR">Argentina</option><option value="AS">American Samoa</option>
                                        <option value="AT">Austria</option><option value="AU">Australia</option>
                                        <option value="AW">Aruba</option><option value="AX">Åland Islands</option>
                                        <option value="AZ">Azerbaijan</option><option value="BA">Bosnia and Herzegovina</option>
                                        <option value="BB">Barbados</option><option value="BD">Bangladesh</option>
                                        <option value="BE">Belgium</option><option value="BF">Burkina Faso</option>
                                        <option value="BG">Bulgaria</option><option value="BH">Bahrain</option>
                                        <option value="BI">Burundi</option><option value="BJ">Benin</option>
                                        <option value="BL">Saint Barthélemy</option><option value="BM">Bermuda</option>
                                        <option value="BN">Brunei</option><option value="BO">Bolivia</option>
                                        <option value="BQ">Bonaire, Sint Eustatius and Saba</option><option value="BR">Brazil</option>
                                        <option value="BS">Bahamas</option><option value="BT">Bhutan</option>
                                        <option value="BV">Bouvet Island</option><option value="BW">Botswana</option>
                                        <option value="BY">Belarus</option><option value="BZ">Belize</option>
                                        <option value="CA">Canada</option><option value="CC">Cocos Islands</option>
                                        <option value="CD">The Democratic Republic Of Congo</option><option value="CF">Central African Republic</option>
                                        <option value="CG">Congo</option><option value="CH">Switzerland</option>
                                        <option value="CI">Côte d'Ivoire</option><option value="CK">Cook Islands</option>
                                        <option value="CL">Chile</option><option value="CM">Cameroon</option>
                                        <option value="CN">China</option><option value="CO">Colombia</option>
                                        <option value="CR">Costa Rica</option><option value="CU">Cuba</option>
                                        <option value="CV">Cape Verde</option><option value="CW">Curaçao</option>
                                        <option value="CX">Christmas Island</option><option value="CY">Cyprus</option>
                                        <option value="CZ">Czech Republic</option><option value="DE">Germany</option>
                                        <option value="DJ">Djibouti</option><option value="DK">Denmark</option>
                                        <option value="DM">Dominica</option><option value="DO">Dominican Republic</option>
                                        <option value="DZ">Algeria</option><option value="EC">Ecuador</option>
                                        <option value="EE">Estonia</option><option value="EG">Egypt</option>
                                        <option value="EH">Western Sahara</option><option value="ER">Eritrea</option>
                                        <option value="ES">Spain</option><option value="ET">Ethiopia</option>
                                        <option value="FI">Finland</option><option value="FJ">Fiji</option>
                                        <option value="FK">Falkland Islands</option><option value="FM">Micronesia</option>
                                        <option value="FO">Faroe Islands</option><option value="FR">France</option>
                                        <option value="GA">Gabon</option><option value="GB">United Kingdom</option>
                                        <option value="GD">Grenada</option><option value="GE">Georgia</option>
                                        <option value="GF">French Guiana</option><option value="GG">Guernsey</option>
                                        <option value="GH">Ghana</option><option value="GI">Gibraltar</option>
                                        <option value="GL">Greenland</option><option value="GM">Gambia</option>
                                        <option value="GN">Guinea</option><option value="GP">Guadeloupe</option>
                                        <option value="GQ">Equatorial Guinea</option><option value="GR">Greece</option>
                                        <option value="GS">South Georgia And The South Sandwich Islands</option><option value="GT">Guatemala</option>
                                        <option value="GU">Guam</option><option value="GW">Guinea-Bissau</option>
                                        <option value="GY">Guyana</option><option value="HK">Hong Kong</option>
                                        <option value="HM">Heard Island And McDonald Islands</option><option value="HN">Honduras</option>
                                        <option value="HR">Croatia</option><option value="HT">Haiti</option>
                                        <option value="HU">Hungary</option><option value="ID">Indonesia</option>
                                        <option value="IE">Ireland</option><option value="IL">Israel</option>
                                        <option value="IM">Isle Of Man</option><option value="IN">India</option>
                                        <option value="IO">British Indian Ocean Territory</option><option value="IQ">Iraq</option>
                                        <option value="IR">Iran</option><option value="IS">Iceland</option>
                                        <option value="IT">Italy</option><option value="JE">Jersey</option>
                                        <option value="JM">Jamaica</option><option value="JO">Jordan</option>
                                        <option value="JP">Japan</option><option value="KE">Kenya</option>
                                        <option value="KG">Kyrgyzstan</option><option value="KH">Cambodia</option>
                                        <option value="KI">Kiribati</option><option value="KM">Comoros</option>
                                        <option value="KN">Saint Kitts And Nevis</option><option value="KP">North Korea</option>
                                        <option value="KR">South Korea</option><option value="KW">Kuwait</option>
                                        <option value="KY">Cayman Islands</option><option value="KZ">Kazakhstan</option>
                                        <option value="LA">Laos</option><option value="LB">Lebanon</option>
                                        <option value="LC">Saint Lucia</option><option value="LI">Liechtenstein</option>
                                        <option value="LK">Sri Lanka</option><option value="LR">Liberia</option>
                                        <option value="LS">Lesotho</option><option value="LT">Lithuania</option>
                                        <option value="LU">Luxembourg</option><option value="LV">Latvia</option>
                                        <option value="LY">Libya</option><option value="MA">Morocco</option>
                                        <option value="MC">Monaco</option><option value="MD">Moldova</option>
                                        <option value="ME">Montenegro</option><option value="MF">Saint Martin</option>
                                        <option value="MG">Madagascar</option><option value="MH">Marshall Islands</option>
                                        <option value="MK">Macedonia</option><option value="ML">Mali</option>
                                        <option value="MM">Myanmar</option><option value="MN">Mongolia</option>
                                        <option value="MO">Macao</option><option value="MP">Northern Mariana Islands</option>
                                        <option value="MQ">Martinique</option><option value="MR">Mauritania</option>
                                        <option value="MS">Montserrat</option><option value="MT">Malta</option>
                                        <option value="MU">Mauritius</option><option value="MV">Maldives</option>
                                        <option value="MW">Malawi</option><option value="MX">Mexico</option>
                                        <option value="MY">Malaysia</option><option value="MZ">Mozambique</option>
                                        <option value="NA">Namibia</option><option value="NC">New Caledonia</option>
                                        <option value="NE">Niger</option><option value="NF">Norfolk Island</option>
                                        <option value="NG">Nigeria</option><option value="NI">Nicaragua</option>
                                        <option value="NL">Netherlands</option><option value="NO">Norway</option>
                                        <option value="NP">Nepal</option><option value="NR">Nauru</option>
                                        <option value="NU">Niue</option><option value="NZ">New Zealand</option>
                                        <option value="OM">Oman</option><option value="PA">Panama</option>
                                        <option value="PE">Peru</option><option value="PF">French Polynesia</option>
                                        <option value="PG">Papua New Guinea</option><option value="PH">Philippines</option>
                                        <option value="PK">Pakistan</option><option value="PL">Poland</option>
                                        <option value="PM">Saint Pierre And Miquelon</option><option value="PN">Pitcairn</option>
                                        <option value="PR">Puerto Rico</option><option value="PS">Palestine</option>
                                        <option value="PT">Portugal</option><option value="PW">Palau</option>
                                        <option value="PY">Paraguay</option><option value="QA">Qatar</option>
                                        <option value="RE">Reunion</option><option value="RO">Romania</option>
                                        <option value="RS">Serbia</option><option value="RU">Russia</option>
                                        <option value="RW">Rwanda</option><option value="SA">Saudi Arabia</option>
                                        <option value="SB">Solomon Islands</option><option value="SC">Seychelles</option>
                                        <option value="SD">Sudan</option><option value="SE">Sweden</option>
                                        <option value="SG">Singapore</option><option value="SH">Saint Helena</option>
                                        <option value="SI">Slovenia</option><option value="SJ">Svalbard And Jan Mayen</option>
                                        <option value="SK">Slovakia</option><option value="SL">Sierra Leone</option>
                                        <option value="SM">San Marino</option><option value="SN">Senegal</option>
                                        <option value="SO">Somalia</option><option value="SR">Suriname</option>
                                        <option value="SS">South Sudan</option><option value="ST">Sao Tome And Principe</option>
                                        <option value="SV">El Salvador</option><option value="SX">Sint Maarten (Dutch part)</option>
                                        <option value="SY">Syria</option><option value="SZ">Swaziland</option>
                                        <option value="TC">Turks And Caicos Islands</option><option value="TD">Chad</option>
                                        <option value="TF">French Southern Territories</option><option value="TG">Togo</option>
                                        <option value="TH">Thailand</option><option value="TJ">Tajikistan</option>
                                        <option value="TK">Tokelau</option><option value="TL">Timor-Leste</option>
                                        <option value="TM">Turkmenistan</option><option value="TN">Tunisia</option>
                                        <option value="TO">Tonga</option><option value="TR">Turkey</option>
                                        <option value="TT">Trinidad and Tobago</option><option value="TV">Tuvalu</option>
                                        <option value="TW">Taiwan</option><option value="TZ">Tanzania</option>
                                        <option value="UA">Ukraine</option><option value="UG">Uganda</option>
                                        <option value="UM">United States Minor Outlying Islands</option><option value="US">United States</option>
                                        <option value="UY">Uruguay</option><option value="UZ">Uzbekistan</option>
                                        <option value="VA">Vatican</option><option value="VC">Saint Vincent And The Grenadines</option>
                                        <option value="VE">Venezuela</option><option value="VG">British Virgin Islands</option>
                                        <option value="VI">U.S. Virgin Islands</option><option value="VN">Vietnam</option>
                                        <option value="VU">Vanuatu</option><option value="WF">Wallis And Futuna</option>
                                        <option value="WS">Samoa</option><option value="YE">Yemen</option>
                                        <option value="YT">Mayotte</option><option value="ZA">South Africa</option>
                                        <option value="ZM">Zambia</option><option value="ZW">Zimbabwe</option>
                                    </select>                                    
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="city">City </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <input id="city" name="city" class="form-control" placeholder="City" type="text" value="Yerevan">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="region">Region </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <input id="region" name="region" class="form-control" placeholder="Region" type="text" value="">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="timezone">Time zone <span class="required">*</span></label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <select id="timezone" name="timezone" class="form-control select2_tz select2-hidden-accessible" tabindex="-1" aria-hidden="true">
                                        <option value=""></option>
                                        <option value="Africa/Abidjan">Africa/Abidjan(UTC+0)</option><option value="Africa/Accra">Africa/Accra(UTC+0)</option>
                                        <option value="Africa/Addis_Ababa">Africa/Addis_Ababa(UTC+3)</option><option value="Africa/Algiers">Africa/Algiers(UTC+1)</option>
                                        <option value="Africa/Asmara">Africa/Asmara(UTC+3)</option><option value="Africa/Asmera">Africa/Asmera(UTC+3)</option>
                                        <option value="Africa/Bamako">Africa/Bamako(UTC+0)</option><option value="Africa/Bangui">Africa/Bangui(UTC+1)</option>
                                        <option value="Africa/Banjul">Africa/Banjul(UTC+0)</option><option value="Africa/Bissau">Africa/Bissau(UTC+0)</option>                                                                                
                                        <option value="Africa/Lusaka">Africa/Lusaka(UTC+2)</option><option value="Africa/Malabo">Africa/Malabo(UTC+1)</option>
                                        <option value="Africa/Maputo">Africa/Maputo(UTC+2)</option><option value="Africa/Maseru">Africa/Maseru(UTC+2)</option>
                                        <option value="Africa/Mbabane">Africa/Mbabane(UTC+2)</option><option value="Africa/Mogadishu">Africa/Mogadishu(UTC+3)</option>
                                        <option value="Africa/Monrovia">Africa/Monrovia(UTC+0)</option><option value="Africa/Nairobi">Africa/Nairobi(UTC+3)</option>
                                        <option value="Africa/Ndjamena">Africa/Ndjamena(UTC+1)</option><option value="Africa/Niamey">Africa/Niamey(UTC+1)</option>
                                        <option value="Africa/Nouakchott">Africa/Nouakchott(UTC+0)</option><option value="Africa/Ouagadougou">Africa/Ouagadougou(UTC+0)</option>
                                        <option value="Africa/Porto-Novo">Africa/Porto-Novo(UTC+1)</option><option value="Africa/Sao_Tome">Africa/Sao_Tome(UTC+0)</option>
                                        <option value="Africa/Timbuktu">Africa/Timbuktu(UTC+0)</option><option value="Africa/Tripoli">Africa/Tripoli(UTC+2)</option>
                                        <option value="Africa/Tunis">Africa/Tunis(UTC+1)</option><option value="Africa/Windhoek">Africa/Windhoek(UTC+2)</option>
                                        <option value="America/Adak">America/Adak(UTC-10)</option><option value="America/Anchorage">America/Anchorage(UTC-9)</option>
                                        <option value="America/Anguilla">America/Anguilla(UTC-4)</option><option value="America/Antigua">America/Antigua(UTC-4)</option>
                                        <option value="America/Argentina/Buenos_Aires">America/Argentina/Buenos_Aires(UTC-3)</option><option value="America/Aruba">America/Aruba(UTC-4)</option>                                                                       
                                        <option value="America/Atikokan">America/Atikokan(UTC-5)</option><option value="America/Atka">America/Atka(UTC-10)</option>
                                        <option value="America/Bahia">America/Bahia(UTC-3)</option><option value="America/Bahia_Banderas">America/Bahia_Banderas(UTC-6)</option>
                                        <option value="America/Barbados">America/Barbados(UTC-4)</option><option value="America/Belem">America/Belem(UTC-3)</option>
                                        <option value="America/Belize">America/Belize(UTC-6)</option><option value="America/Blanc-Sablon">America/Blanc-Sablon(UTC-4)</option>
                                        <option value="America/Boa_Vista">America/Boa_Vista(UTC-4)</option><option value="America/Bogota">America/Bogota(UTC-5)</option>
                                        <option value="America/Boise">America/Boise(UTC-7)</option><option value="America/Buenos_Aires">America/Buenos_Aires(UTC-3)</option>
                                        <option value="America/Cambridge_Bay">America/Cambridge_Bay(UTC-7)</option><option value="America/Campo_Grande">America/Campo_Grande(UTC-4)</option>
                                        <option value="America/Cancun">America/Cancun(UTC-5)</option><option value="America/Caracas">America/Caracas(UTC-4)</option>
                                        <option value="America/Catamarca">America/Catamarca(UTC-3)</option><option value="America/Cayenne">America/Cayenne(UTC-3)</option>
                                        <option value="America/Cayman">America/Cayman(UTC-5)</option><option value="America/Chicago">America/Chicago(UTC-6)</option>
                                        <option value="America/Chihuahua">America/Chihuahua(UTC-7)</option><option value="America/Coral_Harbour">America/Coral_Harbour(UTC-5)</option>
                                        <option value="America/Cordoba">America/Cordoba(UTC-3)</option><option value="America/Costa_Rica">America/Costa_Rica(UTC-6)</option>
                                        <option value="Pacific/Yap">Pacific/Yap(UTC+10)</option><option value="Poland">Poland(UTC+1)</option><option value="Portugal">Portugal(UTC+0)</option>
                                        <option value="ROK">ROK(UTC+9)</option><option value="Singapore">Singapore(UTC+8)</option><option value="SystemV/AST4">SystemV/AST4(UTC-4)</option>
                                        <option value="SystemV/AST4ADT">SystemV/AST4ADT(UTC-4)</option><option value="SystemV/CST6">SystemV/CST6(UTC-6)</option>
                                        <option value="SystemV/CST6CDT">SystemV/CST6CDT(UTC-6)</option><option value="SystemV/EST5">SystemV/EST5(UTC-5)</option>
                                        <option value="SystemV/EST5EDT">SystemV/EST5EDT(UTC-5)</option><option value="SystemV/HST10">SystemV/HST10(UTC-10)</option>
                                        <option value="SystemV/MST7">SystemV/MST7(UTC-7)</option><option value="SystemV/MST7MDT">SystemV/MST7MDT(UTC-7)</option>
                                        <option value="SystemV/PST8">SystemV/PST8(UTC-8)</option><option value="SystemV/PST8PDT">SystemV/PST8PDT(UTC-8)</option>
                                        <option value="SystemV/YST9">SystemV/YST9(UTC-9)</option><option value="SystemV/YST9YDT">SystemV/YST9YDT(UTC-9)</option>
                                        <option value="Turkey">Turkey(UTC+3)</option><option value="UCT">UCT(UTC+0)</option><option value="US/Alaska">US/Alaska(UTC-9)</option>
                                        <option value="US/Aleutian">US/Aleutian(UTC-10)</option><option value="US/Arizona">US/Arizona(UTC-7)</option>
                                        <option value="US/Central">US/Central(UTC-6)</option><option value="US/East-Indiana">US/East-Indiana(UTC-5)</option>
                                        <option value="US/Eastern">US/Eastern(UTC-5)</option><option value="US/Hawaii">US/Hawaii(UTC-10)</option>
                                        <option value="US/Indiana-Starke">US/Indiana-Starke(UTC-6)</option><option value="US/Michigan">US/Michigan(UTC-5)</option>
                                        <option value="US/Mountain">US/Mountain(UTC-7)</option><option value="US/Pacific">US/Pacific(UTC-8)</option>
                                        <option value="US/Pacific-New">US/Pacific-New(UTC-8)</option><option value="US/Samoa">US/Samoa(UTC-11)</option>
                                        <option value="UTC">UTC(UTC+0)</option><option value="Universal">Universal(UTC+0)</option><option value="W-SU">W-SU(UTC+3)</option>
                                        <option value="WET">WET(UTC+0)</option><option value="Zulu">Zulu(UTC+0)</option><option value="EST">EST(UTC-5)</option>
                                        <option value="HST">HST(UTC-10)</option><option value="MST">MST(UTC-7)</option><option value="ACT">ACT(UTC+9)</option>
                                        <option value="AET">AET(UTC+11)</option><option value="AGT">AGT(UTC-3)</option><option value="ART">ART(UTC+2)</option>
                                        <option value="AST">AST(UTC-9)</option><option value="BET">BET(UTC-3)</option><option value="BST">BST(UTC+6)</option>
                                        <option value="CAT">CAT(UTC+2)</option><option value="CNT">CNT(UTC-3)</option><option value="CST">CST(UTC-6)</option>
                                        <option value="CTT">CTT(UTC+8)</option><option value="EAT">EAT(UTC+3)</option><option value="ECT">ECT(UTC+1)</option>
                                        <option value="IET">IET(UTC-5)</option><option value="IST">IST(UTC+5)</option><option value="JST">JST(UTC+9)</option>
                                        <option value="MIT">MIT(UTC+14)</option><option value="NET">NET(UTC+4)</option><option value="NST">NST(UTC+13)</option>
                                        <option value="PLT">PLT(UTC+5)</option><option value="PNT">PNT(UTC-7)</option><option value="PRT">PRT(UTC-4)</option>
                                        <option value="PST">PST(UTC-8)</option><option value="SST">SST(UTC+11)</option><option value="VST">VST(UTC+7)</option>
                                    </select>

                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-4 text-md-right text-center text-muted" for="template">Template </label>
                                <div class="col-lg-5 col-md-6 col-8">
                                    <select id="template" name="template" class="form-control select2_tz select2-hidden-accessible" tabindex="-1" aria-hidden="true">
                                        <option value="default" selected="selected">Light(default)</option>
                                        <option value="dark">Dark(holo)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-lg-6 col-md-6 col-12 offset-lg-4">                                                        
                                    <a class="btn btn-outline-primary" href=""> Cancel </a>
                                    <a class="btn btn-outline-success" href=""> Save </a>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                            <div>
                                <input type="hidden" name="_csrf" value="f46c2b5d-15f6-4991-8b0f-1c0555a40ac3">
                            </div>
                        </form>-->
                        
                    </div>
                    <!--                ------------------------------------------------------------------------------------------------------------                     --> 
                    <div class="tab-pane fade" id="nav-levelsSettings" role="tabpanel" aria-labelledby="nav-levelsSettings-tab">
                        <form id="newuserleveldata" class="" action="/OddeyeCoconut/profile/saveuserlevels" method="post">
                            <div class="table-responsive">
                                <table class="data table table-striped no-margin">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Name</th>
                                            <th>Min Value</th>
                                            <th>Min Percent</th>
                                            <th>Min Weight</th>
                                            <th>Min Recurrence Count</th>
                                            <th>Deviation From Prediction</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td>Any </td>
                                            <td><input id="AlertLevels00" name="AlertLevels[0][0]" class="form-control" type="text" value="1.0"></td>
                                            <td><input id="AlertLevels01" name="AlertLevels[0][1]" class="form-control" type="text" value="10.0"></td>
                                            <td><input id="AlertLevels02" name="AlertLevels[0][2]" class="form-control" type="text" value="1.0"></td>
                                            <td><input id="AlertLevels03" name="AlertLevels[0][3]" class="form-control" type="text" value="5.0"></td>
                                            <td><input id="AlertLevels04" name="AlertLevels[0][4]" class="form-control" type="text" value="10.0"></td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td>Low </td>
                                            <td><input id="AlertLevels10" name="AlertLevels[1][0]" class="form-control" type="text" value="1.0"></td>
                                            <td><input id="AlertLevels11" name="AlertLevels[1][1]" class="form-control" type="text" value="20.0"></td>
                                            <td><input id="AlertLevels12" name="AlertLevels[1][2]" class="form-control" type="text" value="8.0"></td>
                                            <td><input id="AlertLevels13" name="AlertLevels[1][3]" class="form-control" type="text" value="5.0"></td>
                                            <td><input id="AlertLevels14" name="AlertLevels[1][4]" class="form-control" type="text" value="20.0"></td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td>Guarded </td>
                                            <td><input id="AlertLevels20" name="AlertLevels[2][0]" class="form-control" type="text" value="1.0"></td>
                                            <td><input id="AlertLevels21" name="AlertLevels[2][1]" class="form-control" type="text" value="40.0"></td>
                                            <td><input id="AlertLevels22" name="AlertLevels[2][2]" class="form-control" type="text" value="10.0"></td>
                                            <td><input id="AlertLevels23" name="AlertLevels[2][3]" class="form-control" type="text" value="5.0"></td>
                                            <td><input id="AlertLevels24" name="AlertLevels[2][4]" class="form-control" type="text" value="50.0"></td>
                                        </tr>
                                        <tr>
                                            <td>4</td>
                                            <td>Elevated </td>
                                            <td><input id="AlertLevels30" name="AlertLevels[3][0]" class="form-control" type="text" value="1.0"></td>
                                            <td><input id="AlertLevels31" name="AlertLevels[3][1]" class="form-control" type="text" value="60.0"></td>
                                            <td><input id="AlertLevels32" name="AlertLevels[3][2]" class="form-control" type="text" value="14.0"></td>
                                            <td><input id="AlertLevels33" name="AlertLevels[3][3]" class="form-control" type="text" value="5.0"></td>
                                            <td><input id="AlertLevels34" name="AlertLevels[3][4]" class="form-control" type="text" value="60.0"></td>
                                        </tr>
                                        <tr>
                                            <td>5</td>
                                            <td>High </td>
                                            <td><input id="AlertLevels40" name="AlertLevels[4][0]" class="form-control" type="text" value="1.0"></td>
                                            <td><input id="AlertLevels41" name="AlertLevels[4][1]" class="form-control" type="text" value="70.0"></td>
                                            <td><input id="AlertLevels42" name="AlertLevels[4][2]" class="form-control" type="text" value="15.0"></td>
                                            <td><input id="AlertLevels43" name="AlertLevels[4][3]" class="form-control" type="text" value="6.0"></td>
                                            <td><input id="AlertLevels44" name="AlertLevels[4][4]" class="form-control" type="text" value="70.0"></td>
                                        </tr>
                                        <tr>
                                            <td>6</td>
                                            <td>Severe </td>
                                            <td><input id="AlertLevels50" name="AlertLevels[5][0]" class="form-control" type="text" value="1.0"></td>
                                            <td><input id="AlertLevels51" name="AlertLevels[5][1]" class="form-control" type="text" value="80.0"></td>
                                            <td><input id="AlertLevels52" name="AlertLevels[5][2]" class="form-control" type="text" value="16.0"></td>
                                            <td><input id="AlertLevels53" name="AlertLevels[5][3]" class="form-control" type="text" value="8.0"></td>
                                            <td><input id="AlertLevels54" name="AlertLevels[5][4]" class="form-control" type="text" value="80.0"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="form-group">
                                <div class="float-left">
                                    <a class="btn btn-outline-primary" href=""> Cancel </a>
                                    <a class="btn btn-outline-success" href=""> Save </a>
                                </div>
                            </div>
                            <div>
                                <input type="hidden" name="_csrf" value="f46c2b5d-15f6-4991-8b0f-1c0555a40ac3">
                            </div>
                        </form>
                    </div>
                    <!--                ------------------------------------------------------------------------------------------------------------                     --> 
                    <div class="tab-pane fade" id="nav-security" role="tabpanel" aria-labelledby="nav-security-tab">
                        <form id="passwordform" class="" novalidate="true" action="/OddeyeCoconut/profile/changepassword" method="post">
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="name">Old Password</label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <input id="oldpassword" name="oldpassword" class="form-control" placeholder="Old Password" type="password" value="">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="name">New Password</label>
                                <div class="col-lg-5 col-md-6 col-12"><input id="password" name="password" class="form-control" placeholder="New Password" type="password" value="">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-form-label col-lg-4 col-md-4 col-12 text-md-right text-center text-muted" for="name">Re enter New Password</label>
                                <div class="col-lg-5 col-md-6 col-12">
                                    <input id="passwordsecond" name="passwordsecond" class="form-control" placeholder="Re enter New Password" type="password" value="">
                                </div>
                                <!--                                                    <div class="col-lg-2 col-md-2 col-12">
                                                                                        <button type="reset" class="btn btn-primary">Cancel</button>
                                                                                        <button type="submit" class="btn btn-success">Save Password</button>
                                                                                    </div>-->

                            </div>
                            <div class="form-group row">
                                <div class="col-lg-5 col-md-6 col-12 offset-lg-4">
                                    <a class="btn btn-outline-primary" href=""> Cancel </a>
                                    <a class="btn btn-outline-success" href=""> Save </a>
                                </div>
                            </div>
                            <div>
                                <input type="hidden" name="_csrf" value="f46c2b5d-15f6-4991-8b0f-1c0555a40ac3">
                            </div>
                        </form>
                    </div>

                </div>
<!--            </div>                               -->
        </div>
    </div>
</div>

               




                        
                        
                        
                        
                        