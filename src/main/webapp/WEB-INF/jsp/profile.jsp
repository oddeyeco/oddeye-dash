<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <div class="x_title">
                <h2 class="text-justify"><spring:message code="profile.userID"/> ${activeuser.getId().toString()} </h2>
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
                    <h3>${activeuser.getName()} ${activeuser.getLastname()}</h3>

                    <ul class="list-unstyled user_data">
                        <li><i class="fa fa-map-marker user-profile-icon"></i> ${activeuser.getCountry()} ${activeuser.getRegion()} ${activeuser.getCity()} 
                        </li>

                        <li>
                            <i class="fa fa-suitcase  user-profile-icon"></i>  ${activeuser.getCompany()}
                        </li>

                        <li class="m-top-xs">
                            <i class="glyphicon glyphicon-time user-profile-icon"></i>
                            ${activeuser.getTimezone()}
                        </li>
                    </ul>
                            <a class="btn btn-success" href="${cp}/profile/edit"><i class="fa fa-edit m-right-xs"></i><spring:message code="profile.editProfile"/></a>
                    <br />                    
                </div>        
                <div class="col-sm-9 col-xs-12 profile_left metricstat">                    
                    <c:import url="metricinfo.jsp" />
<!--                    <div id="listtablediv" class="table-responsive">
                        <table id="listtable" class="table projects">

                        </table>                    
                    </div>-->
                </div>   
            </div>
        </div>
    </div>
</div>

<!-- /page content -->
