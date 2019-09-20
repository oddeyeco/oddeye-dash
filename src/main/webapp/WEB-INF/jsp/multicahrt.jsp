<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="row">
    <div class="col-12">
        <div class="card shadow">
            <div class="card-header">
                <h5 class="float-left m-0">
                    <spring:message code="multichart.multiChart.h1"/>           
                </h5>                               
            </div>
            <div class="card-body row multichart"> 
                <div class="col-12 p-0">
                    <div class="card shadow">
                        <div class="card-header">
                            <h6 class="float-left">
                                <i class="fa fas fa-chart-area"></i> <spring:message code="chart.h2"/>               
                            </h6>
                            <div class="filter">
                                <div id="reportrange" class="float-right dropdown-toggle rounded-top border-secondary reportrange" >
                                    <i class="fa fa-calendar p-1"></i>
                                    <span></span>                 
                                </div>
                            </div>
                        </div>                            
                        <div class="card-body row">
                            <div class="col-12">
                                <div id="echart_line" class="echart_line_single" style="height:600px;"></div>
                            </div>
                        </div>                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>