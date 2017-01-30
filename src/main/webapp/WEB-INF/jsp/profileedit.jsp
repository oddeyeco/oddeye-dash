<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css" />        
<link rel="stylesheet" type="text/css" href="${cp}/resources//switchery/dist/switchery.min.css" />

<div class="col-md-12 col-sm-12 col-xs-12">
    <div class="x_panel">
        <div class="x_title">
            <h2>Edit Your Profile </h2>
            <div class="clearfix"></div>
        </div>    
        <div class="" role="tabpanel" data-example-id="togglable-tabs">
            <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">
                <li role="presentation" class="active"><a href="#tab_content1" id="home-tab" role="tab" data-toggle="tab" aria-expanded="true">General</a>
                </li>
                <li role="presentation" class=""><a href="#tab_content2" role="tab" id="profile-tab" data-toggle="tab" aria-expanded="false">Levels Settings</a>
                </li>
                <li role="presentation" class=""><a href="#tab_content3" role="tab" id="profile-tab2" data-toggle="tab" aria-expanded="false">Notifier</a>
                </li>
                <li role="presentation" class=""><a href="#tab_content4" role="tab" id="profile-tab" data-toggle="tab" aria-expanded="false">Security</a>
                </li>

            </ul>
            <div id="myTabContent" class="tab-content">
                <div role="tabpanel" class="tab-pane fade active in" id="tab_content1" aria-labelledby="home-tab">
                    <div class="x_content">
                        <br>                        
                        <form:form method="post" action="${cp}/profile/saveuser" commandName="newuserdata" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left">                            
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">First Name <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <form:input path="name" cssClass="form-control" required="" placeholder="First Name *"/>
                                    <form:errors path="name" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="lastname">Last Name <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <form:input path="lastname" cssClass="form-control" placeholder="Last Name"/>
                                    <form:errors path="lastname" />
                                </div>
                            </div>                    
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="company">Company Name <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <form:input path="company" cssClass="form-control" placeholder="Company name"/>
                                    <form:errors path="company" />
                                </div>
                            </div>
                            <div class="form-group">   
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="country">Country <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:select path="country" items="${countryList}" cssClass="form-control select2_country" tabindex="-1"/>                                        
                                    <form:errors path="country" />                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="city">City <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:input path="city" cssClass="form-control" placeholder="City"/>
                                    <form:errors path="city" />                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="region">Region 
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:input path="region" cssClass="form-control" placeholder="Region"/>
                                    <form:errors path="region" />              
                                </div>
                            </div>
                            <div class="form-group">                    
                                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="timezone">Timezone <span class="required">*</span>
                                </label>
                                <div class="col-md-6 col-sm-6 col-xs-12">

                                    <form:select path="timezone" items="${tzone}" cssClass="form-control select2_tz" tabindex="-1"/>                                        
                                    <form:errors path="timezone" />
                                </div>
                            </div>                
                            <div class="form-group">
                                <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                                    <button type="reset" class="btn btn-primary">Cancel</button>
                                    <button type="submit" class="btn btn-success">Submit</button>
                                </div>
                            </div>

                            <div class="clearfix"></div>
                        </form:form>                                                
                    </div>                

                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_content2" aria-labelledby="profile-tab">

                    <!-- start user projects -->
                    <table class="data table table-striped no-margin">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Min Value</th>
                                <th>Min Percent</th>
                                <th>Min Weight</th>
                                <th>Min Recurrence Count</th>
                                <th>Min Predict Percent</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${newuserdata.getAlertLevels()}" var="AlertLevel" varStatus="loopgrups">
                                <tr>
                                    <td>${loopgrups.index+1}</td>
                                    <td>${newuserdata.getAlertLevels().getName(AlertLevel.getKey())}</td>
                                    <c:forEach items="${AlertLevel.getValue()}" var="Value" >
                                        <td><input class="form-control" value="${Value.getValue()}" type="number">    </td>
                                        </c:forEach>                                
                                </tr>                    
                            </c:forEach>
                        </tbody>
                    </table>
                    <!-- end user projects -->

                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_content3" aria-labelledby="profile-tab">
                    <div class="col-md-4 col-sm-4 col-xs-12">
                        <div class="x_title">
                            <h5>For Email <input type="checkbox" class="js-switch-small" id="send_email" name="send_email" /> </h5></div>
                            <form class="form-horizontal form-label-left form-filter" name="email_note">
                            <jsp:include page="filterform.jsp" />  
                            <div class="form-group">                        
                                <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                    <button class="btn btn-success" type="button" value="Default" id="Default">Use It</button>        
                                </div>
                            </div>                        
                        </form>
                    </div>
                    <div class="col-md-4 col-sm-4 col-xs-12">
                        <div class="x_title">
                            <h5>For Telegram <input type="checkbox" class="js-switch-small" id="send_telegram" name="send_telegram" /> </h5></div>
                            <form class="form-horizontal form-label-left form-filter" name="email_note">
                            <jsp:include page="filterform.jsp" />  
                            <div class="form-group">                        
                                <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                    <button class="btn btn-success" type="button" value="Default" id="Default">Use It</button>        
                                </div>
                            </div>                        
                        </form>
                    </div>                            
                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_content4" aria-labelledby="profile-tab">
                    <div class="x_content">                                        
                        <form:form method="post" action="${cp}/profile/chagelogin" commandName="newuserdata" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left">
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name">Chage Email (Login)</label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <form:input path="email" cssClass="form-control" required="" placeholder="email"/>
                                    <form:errors path="email" />
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">
                                    <button type="reset" class="btn btn-primary">Cancel</button>
                                    <button type="submit" class="btn btn-success">Submit</button>
                                </div>                                
                            </div>
                        </form:form>
                    </div>

                    <div class="x_content">                                        
                        <form:form method="post" action="${cp}/profile/chagepassword" commandName="newuserdata" modelAttribute="newuserdata" novalidate="true" cssClass="form-horizontal form-label-left">
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name">Old Password</label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <form:input path="oldpassword" cssClass="form-control" required="" placeholder="Old Password" type="password"/>
                                    <form:errors path="oldpassword" />
                                </div>                              
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name">New Password</label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <form:input path="password" cssClass="form-control" required="" placeholder="New Password" type="password"/>
                                    <form:errors path="password" />
                                </div>                               
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2 col-sm-2 col-xs-12" for="name">Re enter New Password</label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <form:input path="passwordsecond" cssClass="form-control" required="" placeholder="Re enter New Password" type="password"/>
                                    <form:errors path="passwordsecond" />
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">
                                    <button type="reset" class="btn btn-primary">Cancel</button>
                                    <button type="submit" class="btn btn-success">Save Password</button>
                                </div>                                
                            </div>
                        </form:form>
                    </div>                     

                </div>

            </div>
        </div>
    </div>
</div>