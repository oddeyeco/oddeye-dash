<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<link rel="stylesheet" type="text/css" href="${cp}/resources/select2/dist/css/select2.min.css" />        

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
                <li role="presentation" class=""><a href="#tab_content3" role="tab" id="profile-tab2" data-toggle="tab" aria-expanded="false">Add funds</a>
                </li>
            </ul>
            <div id="myTabContent" class="tab-content">
                <div role="tabpanel" class="tab-pane fade active in" id="tab_content1" aria-labelledby="home-tab">
                    <div class="x_content">
                        <br>
                        <form:form method="post" modelAttribute="curentuser" novalidate="true" cssClass="form-horizontal form-label-left">                            
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
                                    <button type="submit" class="btn btn-primary">Cancel</button>
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
                                <th>Project Name</th>
                                <th>Client Company</th>
                                <th class="hidden-phone">Hours Spent</th>
                                <th>Contribution</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>New Company Takeover Review</td>
                                <td>Deveint Inc</td>
                                <td class="hidden-phone">18</td>
                                <td class="vertical-align-mid">
                                    <div class="progress">
                                        <div class="progress-bar progress-bar-success" data-transitiongoal="35" style="width: 35%;" aria-valuenow="35"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>New Partner Contracts Consultanci</td>
                                <td>Deveint Inc</td>
                                <td class="hidden-phone">13</td>
                                <td class="vertical-align-mid">
                                    <div class="progress">
                                        <div class="progress-bar progress-bar-danger" data-transitiongoal="15" style="width: 15%;" aria-valuenow="15"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Partners and Inverstors report</td>
                                <td>Deveint Inc</td>
                                <td class="hidden-phone">30</td>
                                <td class="vertical-align-mid">
                                    <div class="progress">
                                        <div class="progress-bar progress-bar-success" data-transitiongoal="45" style="width: 45%;" aria-valuenow="45"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td>New Company Takeover Review</td>
                                <td>Deveint Inc</td>
                                <td class="hidden-phone">28</td>
                                <td class="vertical-align-mid">
                                    <div class="progress">
                                        <div class="progress-bar progress-bar-success" data-transitiongoal="75" style="width: 75%;" aria-valuenow="75"></div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- end user projects -->

                </div>
                <div role="tabpanel" class="tab-pane fade" id="tab_content3" aria-labelledby="profile-tab">
                    <p>xxFood truck fixie locavore, accusamus mcsweeney's marfa nulla single-origin coffee squid. Exercitation +1 labore velit, blog sartorial PBR leggings next level wes anderson artisan four loko farm-to-table craft beer twee. Qui
                        photo booth letterpress, commodo enim craft beer mlkshk </p>
                </div>
            </div>
        </div>
    </div>
</div>