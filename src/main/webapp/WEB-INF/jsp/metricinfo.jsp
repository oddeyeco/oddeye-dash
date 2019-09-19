<%-- 
    Document   : metricinfoOE
    Created on : Apr 17, 2019, 6:21:25 PM
    Author     : tigran
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
 
<h6>
    <span class="count_top"><i class="fa fa-folder"></i>&#8195;<spring:message code="metricinfo.totalMetrics"/></span>
    (<span class="count" id="count"><img src="${cp}/assets/images/loading.gif" height='50px'></span>)
</h6>
<div class="row justify-content-md-center justify-content-lg-start tile_count rounded-0 depthShadowLightHover">
    <div class="col-xl-2 col-md-4 col-sm-5 tile_stats_count">
        <span class="count_top"><i class="fa fa-list"></i>&#160;<spring:message code="metricNames"/></span>
        <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
        <span class="count_bottom">
                <a href="javascript:void(0)" class="green showtags" value="_name" data-toggle="modal" data-target="#exampleModal" value="_name"><spring:message code="metricinfo.showList"/></a>
        </span>
    </div>
    <div class="col-xl-2 col-md-4 col-sm-5 tile_stats_count">
        <span class="count_top"><i class="fa fa-folder"></i>&#160;<spring:message code="metricinfo.metricTypes"/></span>
        <div class="count" id="typecount"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
        <span class="count_bottom">
               <a href="javascript:void(0)" class="green showtags" value="_type" data-toggle="modal" data-target="#exampleModal" value="_type"><spring:message code="metricinfo.showList"/></a> 
        </span>
    </div>
</div>
<h6>
    <span class="count_top"><i class="fa fa-folder"></i>&#8195;<spring:message code="totalTags"/></span>
    (<span class="count" id="tags"><img src="${cp}/assets/images/loading.gif" height='50px'></span>)
</h6>
<!-- // generation from "metricinfo.js" -->
<div class="row justify-content-md-center justify-content-lg-start tile_count depthShadowLightHover" id="tagslist"></div> 

<!--//Vex
http://joaopereirawd.github.io/animatedModal.js/-->
<div id="modall1" class="modal fadeInLeft" role="dialog">
    <div class="modal-dialog modal-lg">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">Modal Header</h6>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>                
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-outline-secondary" data-dismiss="modal">
                    <spring:message code="close"/>
                </button>
            </div>
        </div>

    </div>
</div>

<div id="modall2" class="modal fade" role="dialog">
    <div class="modal-dialog modal-90">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">Modal Header</h6>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Some text in the modal.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-outline-secondary" data-dismiss="modal">
                    <spring:message code="close"/>
                </button>
            </div>
        </div>

    </div>
</div>