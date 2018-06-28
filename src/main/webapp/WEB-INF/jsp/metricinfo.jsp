<%-- 
    Document   : metricinfo
    Created on : Jan 17, 2018, 10:40:59 AM
    Author     : vahan
--%>

<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/animate.css/3.2.0/animate.min.css">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 <%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
 
<h2>
    <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="metricinfo.totalMetrics"/></span> 
    (<span class="count" id="count"><img src="${cp}/assets/images/loading.gif" height='50px'></span>)
</h2>
<div class="row tile_count">
    <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
        <span class="count_top"><i class="fa fa-list"></i> <spring:message code="metricinfo.metricNames"/></span>
        <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" height='50px' ></div>       
        <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="_name"><spring:message code="metricinfo.showList"/></a></span>
    </div>                                                                                           
    <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
        <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="metricinfo.metricTypes"/></span>
        <div class="count" id="typecount"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
        <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="_type"><spring:message code="metricinfo.showList"/></a></span>
    </div>                                                          
</div>

<h2>
    <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="metricinfo.totalTags"/> </span> 
    (<span class="count" id="tags"><img src="${cp}/assets/images/loading.gif" height='50px'></span>)
</h2>
<div class="row tile_count" id="tagslist">
</div>
<!--//Vex
http://joaopereirawd.github.io/animatedModal.js/-->
<div id="modall1" class="modal fadeInLeft" role="dialog">
    <div class="modal-dialog modal-lg">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Modal Header</h4>
            </div>
            <div class="modal-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>

<div id="modall2" class="modal fade" role="dialog">
    <div class="modal-dialog modal-90">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Modal Header</h4>
            </div>
            <div class="modal-body">
                <p>Some text in the modal.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>