<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="row">
    <div class="col-lg-10 col-md-9 col-xs-12" id="maincontener">
        <div class="x_panel calc">
            <div class="x_title">
                <h1>Configure and estimate the costs for OddEye monitoring</h1>
                <div class="clearfix"></div>
            </div>

            <div class="x_content ">
                <h2 class="col-xs-12 form-group top_search">
                    Select a service to include it in your estimate.
                </h2>
                <div class="col-xs-12 col-md-10 form-group top_search">
                    <div class="input-group">
                        <input class="form-control search-query" placeholder="Search check..." type="text">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="button">Go!</button>
                        </span>
                    </div>
                </div>
                <div class="col-xs-12 col-md-2  calc_buttondiv">
                    <button id="apply" class="calc_button ">Apply New</button>
                    <button id="reset" class="calc_button " >Reset</button>
                </div>

                <div class="clearfix"></div>
                <div class="row">
                    <div class="accordion" id="accordion" role="tablist" aria-multiselectable="true">
                        <div class="panel">
                            <a class="panel-heading collapsed" role="tab" id="headingSearch" data-toggle="collapse" data-parent="#accordion" href="#collapseSearch" aria-expanded="false" aria-controls="collapseTwo">
                                <h4 class="panel-title">serach content</h4>
                            </a>
                            <div id="collapseSearch" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo" aria-expanded="false" style="height: 0px;">
                                <div class="panel-body">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                </div>
                <!--<div class="clearfix"></div>-->

            </div>
        </div>
    </div>
    <div id="fullprice" class="col-lg-2 col-md-3 animated flipInY hidden-sm hidden-xs">
        <div class="x_panel calc">
            <div class="x_title">
                <h2>Price for month</h2>
                <div class="clearfix"></div>
            </div>

            <div class="x_content ">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Instance</th>
                            <th>Metrics</th>
                            <th>USD</th>
                        </tr>                                                
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr id="total">
                            <th>Total:</th>
                            <td class="unit"></td>
                            <td class="usd"></td>
                        </tr>                               
                    </tfoot>
                </table>                


            </div>        
        </div>
    </div>

    <div   class="col-lg-10 col-md-9 ">
        <div id="hostcheck"  >

        </div>
    </div>
</div>