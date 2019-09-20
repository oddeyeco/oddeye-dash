<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12">                    
                        <div class="card shadow">                    
                            <h5 class="card-header text-justify">
                                <spring:message code="profile.userID"/> ${activeuser.getId().toString()}
                            </h5>                   
                            <div class="card-body">
                                <div class="row">    
                                    <div class="col-lg-3 col-md-3 col-12 profile_left">
                                        <div class="profile_img">
                                            <div id="crop-avatar"></div>
                                        </div>
                                        <h6>${activeuser.getName()} ${activeuser.getLastname()}</h6>
                                        <ul class="list-unstyled user_data">
                                            <li class="pt-2">
                                                <i class="fa fa-map-marker user-profile-icon"></i>
                                                ${activeuser.getCountry()} ${activeuser.getRegion()} ${activeuser.getCity()} 
                                            </li>
                                            <li class="pt-2">
                                                <i class="fas fa-clock user-profile-icon"></i>
                                                ${activeuser.getTimezone()}
                                            </li>
                                            <li class="pt-2">
                                                <i class="fa fa-suitcase user-profile-icon"></i>
                                                ${activeuser.getCompany()}
                                            </li>                                            
                                        </ul>
                                        <a class="btn btn-outline-success btn-sm" href="${cp}/profile/edit">
                                            <i class="fa fa-edit"></i>
                                            <spring:message code="profile.editProfile"/>
                                        </a>
                                        <br>
                                    </div>                                
                                    <div class="col-lg-9 col-md-9 col-12 profile_left metricstat">
                                         <c:import url="metricinfo.jsp" />
                                    </div>                                                      
                                </div>
                            </div>
                        </div>
                    </div>
                </div>           