<%-- 
    Document   : user
    Created on : May 11, 2017, 2:21:00 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="x_panel">
    <div class="col-sm-9 col-xs-12 profile_left">
        <div class="row tile_count">
            <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                <span class="count_top"><i class="fa fa-list"></i> Total Metric Names</span>
                <div class="count" id="metrics"><img src="${cp}/assets/images/loading.gif" height='50px' ></div>                   
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
            <div class="col-lg-2 col-sm-4 col-xs-6 tile_stats_count">
                <span class="count_top"><i class="fa fa-folder"></i> unique tags </span>
                <div class="count" id="uniqtagscount"><img src="${cp}/assets/images/loading.gif" height='50px'></div>
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