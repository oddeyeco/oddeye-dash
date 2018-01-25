<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="row">
    <div class="col-xs-10 " id="maincontener">
        <div class="x_panel calc">
            <div class="x_title">
                <h2>Price Calculator</h2>
                <div class="clearfix"></div>
            </div>

            <div class="x_content ">
                <!--                    <div class="search">
                                        <div class="">
                                            <div class="">
                                                <h2>Stylish Search Box</h2>
                                                <div id="custom-search-input">
                                                    <div class="input-group col-md-12">
                                                        <input type="text" class="  search-query form-control" placeholder="Search" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>-->
                <div class="ccol-xs-12 form-group pull-right top_search">
                    <div class="input-group">
                        <input class="form-control search-query" placeholder="Search check..." type="text">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="button">Go!</button>
                        </span>
                    </div>
                </div>   
                <div class="row">
                    <div class="col-xs-3 col-lg-2">
                        <!-- required for floating -->
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs tabs-left">
                            <!--                            <li class="active"><a href="#system_check" data-toggle="tab">System Checks</a></li>
                                                        <li><a href="#webservers_check" data-toggle="tab">Web Servers</a></li>
                                                        <li><a href="#bigdata_check" data-toggle="tab">Big Data</a></li>
                                                        <li><a href="#java_check" data-toggle="tab">Java</a></li>
                                                        <li><a href="#messagequeue_check" data-toggle="tab">Message Queue</a></li>
                                                        <li><a href="#sqlcache_check" data-toggle="tab">SQL,Cache</a></li>
                                                        <li><a href="#hadoop_check" data-toggle="tab">Hadoop</a></li>
                                                        <li><a href="#docstorage_check" data-toggle="tab">Document Storage</a></li>
                                                        <li><a href="#other_check" data-toggle="tab">Other</a></li>-->
                        </ul>
                    </div>
                    <div class="col-xs-9 col-lg-10" id="tab-items">
                        <!-- Tab panes -->
                        <div class="tab-content">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="calc_buttondiv">
                        <button id="apply" class="calc_button ">Apply New</button>
                        <button id="reset" class="calc_button " >Reset</button>
                    </div>
                </div>
                <!--<div class="clearfix"></div>-->

            </div>
        </div>
    </div>
    <div id="fullprice" class="col-xs-2">
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
                            <th>UNITS</th>
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
                        <tr id="usdsave">
                            <th>Save:</th>
                            <td class="unit"></td>
                            <td class="usd"></td>
                        </tr>                             
                    </tfoot>
                </table>                

            </div>        
        </div>
    </div>
</div>
<div class="row">
    <div   class="col-lg-10 ">
        <div id="hostcheck"  >

        </div>
    </div>
</div>