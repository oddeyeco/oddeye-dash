<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
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
                <div class="col-md-9 col-sm-9 col-xs-12 profile_left">
                    <div class="row tile_count">
                        <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                            <span class="count_top"><i class="fa fa-user"></i> Total Tags Type</span>
                            <div class="count">${curentuser.getMetricsMeta().getTagsList().size()}</div>
                            <!--<span class="count_bottom"><i class="green">4% </i> From last Week</span>-->
                        </div>                                                
                    </div>
                    <div class="row tile_count">
                        <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
                            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                                <span class="count_top"><i class="fa fa-user"></i> Total ${tagitem.key}</span>
                                <div class="count">${tagitem.value.size()}</div>
                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="${tagitem.key}">Show List </a></span>
                            </div>      

                        </c:forEach>
                    </div>
                    <div class="row list" style="position: relative; overflow: hidden " >
                        <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">     
                            <div class="item_list" style="position: relative; top: 0px; display: none" id="${tagitem.key}">
                                <table class="table table-striped projects">
                                    <thead>
                                        <tr>
                                            <th>Tag Name</th>
                                            <th>Metric Count</th>                                            
                                            <th class="text-right">Edit</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${tagitem.value}" var="tagitemvalue">                                        
                                            <tr>
                                                
                                                <td>
                                                    <a>${tagitemvalue} </a>
                                                </td>
                                                <td>#${curentuser.getMetricsMeta().getbyTag(tagitem.key, tagitemvalue).size()}</td>
                                                <td class="text-right">
                                                    <a href="javascript:void(0)" class="btn btn-primary btn-xs view" key="${tagitem.key}" value="${tagitemvalue}" idvalue="${fn:replace(tagitemvalue, '.', '_')}"><i class="fa fa-folder"></i> View </a>
                                                    <a href="javascript:void(0)" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i> Edit </a>
                                                    <a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetrics" key="${tagitem.key}" value="${tagitemvalue}"><i class="fa fa-trash-o"></i> Delete All</a>
                                                </td>
                                            </tr>                                        
                                            <tr class="metricinfo" id="${tagitem.key}_${fn:replace(tagitemvalue, '.', '_')}" style="display: none">
                                                <td colspan="3">
                                                    <table class="table table-striped projects">
                                                        <thead>
                                                            <tr>
                                                                <th>#</th>
                                                                <th>Metric name</th>
                                                                <th>Tags</th>
                                                                <th>Last Time</th>
                                                                <th>Edit</th>
                                                            </tr>
                                                        </thead>                                                
                                                        <tbody>
                                                            <tr>
                                                                <td>#</td>
                                                                <td>
                                                                    <a> [metricname]</a>
                                                                </td>
                                                                <td>
                                                                    <a> [tags]</a>
                                                                </td>
                                                                <td>
                                                                    <a>[lasttime]</a>
                                                                </td>                                                                
                                                                
                                                                <td class="text-nowrap">
                                                                    <a href="${cp}/metriq/[hash]" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i> View</a>
                                                                    <a href="javascript:void(0)" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i> Edit </a>
                                                                    <a href="javascript:void(0)" class="btn btn-danger btn-xs deletemetric" value="[hash]"><i class="fa fa-trash-o"></i> Delete </a>
                                                                </td>
                                                            </tr>                                                 
                                                        </tbody>
                                                    </table>                                                     

                                                </td>

                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>                                


                            </div>                             
                        </c:forEach>
                    </div>        


                </div>                        

            </div>
        </div>
    </div>
</div>

<!-- /page content -->
