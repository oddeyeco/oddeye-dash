<%-- 
    Document   : metricinfoOE
    Created on : Apr 17, 2019, 6:21:25 PM
    Author     : tigran
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
 
<h2>
    <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="metricinfo.totalMetrics"/></span> 
    (<span class="count" id="count"><img src="${cp}/assets/images/loading.gif" height='50px'></span>)
</h2>
<div class="row tile_count">
    <div class="col-lg-2 col-md-4 col-xs-6 tile_stats_count">
    <div class="tile_stats_inside">
        <span class="count_top"><i class="fa fa-list"></i> <spring:message code="metricNames"/></span>
        <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" height='50px' ></div>       
        <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="_name"><spring:message code="metricinfo.showList"/></a></span>
    </div>                                                                                           
    </div>                                                                                           
    <div class="col-lg-2 col-md-4 col-xs-6 tile_stats_count">
    <div class="tile_stats_inside">
        <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="metricinfo.metricTypes"/></span>
        <div class="count" id="typecount"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
        <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" value="_type"><spring:message code="metricinfo.showList"/></a></span>
    </div>                                                          

    </div>                                                          
</div>

<h2>
    <span class="count_top"><i class="fa fa-folder"></i> <spring:message code="totalTags"/> </span> 
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
                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="close"/></button>
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
                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="close"/></button>
            </div>
        </div>

    </div>
</div>

<!----------------------------------------------------------------------  //////////////////////////////////////////////////  ----------------------------------------------------->
<!------------------------------  /////////////////////////////////////////  -------------------------------------------  ///////////////////////////////////////////////  -------->


<h2><span class="count_top"><i class="fa fa-folder"></i> Total Metrics</span> (<span class="count" id="count">2544</span>) </h2>
                                        <div class="row justify-content-md-center justify-content-lg-start tile_count">
                                            <div class="col-xl-2 col-md-4 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-list"></i> Metric Names</span>
                                                <div class="count" id="metrics">318</div>
                                                <span class="count_bottom">
                                                    <a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="_name">Show List</a>
                                                </span>
                                            </div>
                                            <div class="col-xl-2 col-md-4 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-folder"></i> Metric Types</span>
                                                <div class="count" id="typecount">5</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="_type">Show List</a></span>
                                            </div>
                                        </div>

                                        <h2>
                                            <span class="count_top"><i class="fa fa-folder"></i> Total Tags </span> (<span class="count" id="tags">9</span>)
                                        </h2>
                                        <div class="row justify-content-md-center justify-content-lg-start tile_count" id="tagslist">
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "cluster" count</span>
                                                <div class="count spincrement" style="opacity: 1;">1</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="cluster">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "device" count</span>
                                                <div class="count spincrement" style="opacity: 1;">17</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="device">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "group" count</span>
                                                <div class="count spincrement" style="opacity: 1;">7</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="group">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "host" count</span>
                                                <div class="count spincrement" style="opacity: 1;">21</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="host">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "location" count</span>
                                                <div class="count spincrement" style="opacity: 1;">1</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="location">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "name" count</span>
                                                <div class="count spincrement" style="opacity: 1;">17</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="name">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "topology" count</span>
                                                <div class="count spincrement" style="opacity: 1;">1</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="topology">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "type" count</span>
                                                <div class="count spincrement" style="opacity: 1;">15</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="type">Show List</a></span>
                                            </div>
                                            <div class="col-xl-2 col-md-3 col-sm-5 tile_stats_count">
                                                <span class="count_top"><i class="fa fa-th-list"></i> Tag "webapp" count</span>
                                                <div class="count spincrement" style="opacity: 1;">1</div>
                                                <span class="count_bottom"><a href="javascript:void(0)" class="green showtags" data-toggle="modal" data-target="#exampleModal" value="webapp">Show List</a></span>
                                            </div>
                                        </div> 
