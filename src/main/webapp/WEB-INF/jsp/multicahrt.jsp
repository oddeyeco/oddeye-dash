<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="">
    <div class="row">
        <div class="col-md-12">
            <div class="x_title">
                <h1> Multi Chart</h1>
            </div>
            <div class="x_panel">
                <div class="x_title">
                    <h2><i class="fa fa-area-chart"></i> Chart </h2>        
                    <div class="filter">
                        <div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
                            <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
                            <span></span> <b class="caret"></b>
                        </div>
                    </div>                    
                    <div class="clearfix"></div>
                </div>                                                
                <div class="x_content col-md-12">
                    <div id="echart_line" class="echart_line_single" style="height:600px;"></div>
                </div> 
            </div>            


        </div>
    </div>
</div>

