<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="page-title">
    <div class="title_left">
        <h3>User Profile </h3>
    </div>
</div>

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <div class="x_title">
                <h2>User (UUID = ${curentuser.getId().toString()})</h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div class="col-md-3 col-sm-3 col-xs-12 profile_left">
                    <div class="profile_img">
                        <div id="crop-avatar">
                            <!-- Current avatar -->
                            <img class="img-responsive avatar-view" src="images/picture.jpg" alt="Avatar" title="Change the avatar">
                        </div>
                    </div>
                    <h3>${curentuser.getName()} ${curentuser.getLastname()}</h3>

                    <ul class="list-unstyled user_data">
                        <li><i class="fa fa-map-marker user-profile-icon"></i> ${curentuser.getCountry()} ${curentuser.getRegion()} ${curentuser.getCity()} 
                        </li>

                        <li>
                            <i class="fa fa-suitcase  user-profile-icon"></i>  ${curentuser.getCompany()}
                        </li>

                        <li class="m-top-xs">
                            <i class="glyphicon glyphicon-time user-profile-icon"></i>
                            ${curentuser.getTimezone()}
                        </li>
                    </ul>

                    <a class="btn btn-success"><i class="fa fa-edit m-right-xs"></i>Edit Profile</a>
                    <br />

                </div>
                <div class="col-md-9 col-sm-9 col-xs-12">

                    <div class="profile_title">
                        <div class="col-md-6">
                            <h2>User Available tags</h2>
                        </div>
                    </div>
                    <div class="x_content">
                        <table id="datatable-fixed-header" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>
                                        Tag Type
                                    </th> 
                                    <th>
                                        Tag Value
                                    </th>        
                                    <th>
                                        Metric count
                                    </th>        

                                </tr>    
                            </thead>
                            <tbody>
                                <c:forEach items="${curentuser.getTags()}" var="tagsgroup">
                                    <c:forEach items="${tagsgroup.value}" var="tagitem">
                                        <tr>
                                            <td>
                                                ${tagsgroup.key} 
                                            </td>
                                            <td>
                                                ${tagitem.key}
                                            </td>                                    
                                            <td>
                                                ${tagitem.value.getDatakeys().size()}
                                            </td>                                                                        
                                        </tr>                                
                                    </c:forEach>                            
                                </c:forEach> 
                            </tbody>       
                        </table>                                    
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- /page content -->
