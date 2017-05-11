<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
                <h2>User (UUID = ${curentuser.getId().toString()}) </h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div class="col-md-3 col-sm-3 col-xs-12 profile_left">
                    <div class="profile_img">
                        <div id="crop-avatar">
                            <!-- Current avatar -->
                            <!--<img class="img-responsive avatar-view" src="images/picture.jpg" alt="Avatar" title="Change the avatar">-->
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

                    <a class="btn btn-success" href="${cp}/profile/edit"><i class="fa fa-edit m-right-xs"></i>Edit Profile</a>
                    <br />

                </div>        
                <div class="col-sm-9 col-xs-12 profile_left">
                    <div class="row tile_count">
                        <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                            <span class="count_top"><i class="fa fa-list"></i> Total Metric Names</span>
                            <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" height='50px' ></div>       
                            <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="name">Show List</a></span>
                        </div>                                                
                        <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                            <span class="count_top"><i class="fa fa-folder"></i> Total Tags Type</span>
                            <div class="count" id="tags"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                            <span class="count_bottom">&nbsp;</span>
                        </div>                                                
                        <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                            <span class="count_top"><i class="fa fa-folder"></i> Total Metrics</span>
                            <div class="count" id="count"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
                            <span class="count_bottom">&nbsp;</span>
                        </div>                                                          
                    </div>
                    <div class="row tile_count" id="tagslist">
                        <%--<c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">
                            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                                <span class="count_top"><i class="fa fa-th-list"></i> Total ${tagitem.key}</span>
                                <div class="count">${tagitem.value.size()}</div>
                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="${tagitem.key}">Show List </a></span>
                            </div>      

                        </c:forEach>--%>   
                    </div>
                    <div id="listtablediv">
                        <table id="listtable" class="table projects">

                        </table>                    
                    </div>
                </div>   
            </div>
        </div>
    </div>
</div>

<!-- /page content -->
