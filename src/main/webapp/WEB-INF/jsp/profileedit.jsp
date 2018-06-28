<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css?v=${version}" />        
<link rel="stylesheet" type="text/css" href="${cp}/resources/switchery/dist/switchery.min.css?v=${version}" />

<div class="col-md-12 col-sm-12 col-xs-12">
    <div class="x_panel">
        <div class="x_title">
            <spring:message code="profileedit.controlSecure.h2"/>
            <div class="clearfix"></div>
        </div>    
        <div class="" role="tabpanel" data-example-id="togglable-tabs">
            <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">
                                                
                <li role="presentation" class="<c:if test="${tab == \"general-tab\"}">active</c:if>  "><a href="#general_content" id="general-tab" role="tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.general"/></a>
                </li>
                <li role="presentation" class="<c:if test="${tab == \"level-tab\"}">active</c:if>  "><a href="#level_content" role="tab" id="level-tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.levelsSettings"/></a>
                </li>
<!--                <li role="presentation" class="<c:if test="${tab == \"notifier-tab\"}">active</c:if>"><a href="#notifier_content" role="tab" id="notifier-tab" data-toggle="tab" aria-expanded="false">Notifier</a>
                </li>-->
                <li role="presentation" class="<c:if test="${tab == \"pass-tab\"}">active</c:if>"><a href="#tab_pass" role="tab" id="profile-tab" data-toggle="tab" aria-expanded="false"><spring:message code="profileedit.security"/></a>
                </li>

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
                                    <form:input path="name" cssClass="form-control" required="" placeholder="First Name *"/>
                                    <form:errors path="name" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="lastname"><spring:message code="profileedit.lastName"/> <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <form:input path="lastname" cssClass="form-control" placeholder="Last Name"/>
                                    <form:errors path="lastname" />
                                </div>
                            </div>                    
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="company"><spring:message code="profileedit.companyName"/> <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <form:input path="company" cssClass="form-control" placeholder="Company name"/>
                                    <form:errors path="company" />
                                </div>
                            </div>
                            <div class="form-group">   
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="country"><spring:message code="profileedit.country"/> <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                                    <form:errors path="country" />                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="city"><spring:message code="profileedit.city"/> <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:input path="city" cssClass="form-control" placeholder="City"/>
                                    <form:errors path="city" />                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="region"><spring:message code="profileedit.region"/> 
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:input path="region" cssClass="form-control" placeholder="Region"/>
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
                                <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                                    <button type="reset" class="btn btn-primary"><spring:message code="cancel"/></button>
                                    <button type="submit" class="btn btn-success"><spring:message code="submit"/></button>
                                </div>
                            </div>

                            <div class="clearfix"></div>
                        </form:form>                                                
                    </div>                

                </div>
                <div role="tabpanel" class="tab-pane fade in <c:if test="${tab == \"level-tab\"}">active</c:if> " id="level_content" aria-labelledby="level_content">

                    <!-- start user projects -->
                    <form:form method="post" action="${cp}/profile/saveuserlevels" modelAttribute="newuserleveldata" novalidate="true" cssClass="form-horizontal form-label-left">                            
<!--                    <form name="levelssetings" id="levelssetings" enctype="multipart/form-data">-->
                        <table class="data table table-striped no-margin">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th><spring:message code="profileedit.levelsSettings.name"/></th>
                                    <th><spring:message code="profileedit.levelsSettings.minValue"/></th>
                                    <th><spring:message code="profileedit.levelsSettings.minPercent"/></th>
                                    <th><spring:message code="profileedit.levelsSettings.minWeight"/></th>
                                    <th><spring:message code="profileedit.levelsSettings.minRecurrenceCount"/></th>
                                    <th><spring:message code="profileedit.levelsSettings.minPredictPercent"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${newuserdata.getAlertLevels()}" var="AlertLevel" varStatus="loopgrups">
                                    <tr>
                                        <td>${loopgrups.index+1}</td>
                                        <td>${newuserdata.getAlertLevels().getName(AlertLevel.getKey())}                                                                               
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
                        <div class="form-group">
                            <div class="pull-right">
                                <button type="reset" class="btn btn-primary"><spring:message code="cancel"/></button>
                                <button type="submit" class="btn btn-success"><spring:message code="submit"/></button>
                            </div>
                        </div>                        
                    
                    </form:form>
                    <!-- end user projects -->

                </div>
<!--                <div role="tabpanel" class="tab-pane fade in <c:if test="${tab == \"notifier-tab\"}">active</c:if>" id="notifier_content" aria-labelledby="notifier_content">
                    <div class="col-md-4 col-sm-4 col-xs-12">
                        <form class="form-horizontal form-label-left form-filter" name="send_email" id="email_note">
                            <div class="x_title">                            
                                <h5>For Email <input type="checkbox" class="js-switch-small" id="send_email" name="send_email" /> </h5><input class="form-control filter-input" type="text" name="email_input" id="email_input" value=""></div>                            
                                    <jsp:include page="filterform.jsp" />  
                            <div class="form-group">                        
                                <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                    <button class="btn btn-success savefilter" type="button">Save</button>                                            
                                </div>
                            </div>                        
                        </form>
                    </div>
                    <div class="col-md-4 col-sm-4 col-xs-12">
                        <form class="form-horizontal form-label-left form-filter" name="send_telegram" id="telegram_note">
                            <div class="x_title">
                                <h5>For Telegram <input type="checkbox" class="js-switch-small" id="send_telegram" name="send_telegram" /> </h5><input class="form-control filter-input" type="text" name="telegram_input" id="telegram_input" value=""></div>
                                    <jsp:include page="filterform.jsp" />  
                            <div class="form-group">                        
                                <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                    <button class="btn btn-success savefilter" type="button" >Save</button>        
                                </div>
                            </div>                        
                        </form>
                    </div>                            
                </div>-->
                <div role="tabpanel" class="tab-pane fade in <c:if test="${tab == \"pass-tab\"}">active</c:if>" id="tab_pass" aria-labelledby="pass-tab">
                    <div class="x_content">                                        
                        <form:form method="post" action="${cp}/profile/changepassword" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left" id="passwordform">
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name"><spring:message code="profileedit.security.oldPassword"/></label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <form:input path="oldpassword" cssClass="form-control" required="" placeholder="Old Password" type="password"/>
                                    <form:errors path="oldpassword" />
                                </div>                              
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name"><spring:message code="profileedit.security.newPassword"/></label>
                                <div class="col-md-8 col-sm-8 col-xs-12">                                    
                                    <input id="password" name="password" class="form-control" placeholder="New Password" type="password" value="">
                                    <form:errors path="password" />
                                </div>                               
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name"><spring:message code="profileedit.security.reEnterNewPassword"/></label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <form:input path="passwordsecond" cssClass="form-control" required="" placeholder="Re enter New Password" type="password"/>
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