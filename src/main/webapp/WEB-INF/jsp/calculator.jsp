<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<main>
    <h3>Price Calculator</h3>
    <hr/>
    <div  class="col-lg-8">

        <div class="col-xs-3 ">
            <ul class="nav nav-tabs tabs-left">
                <li class="active"><a href="#system_check" data-toggle="tab">System Checks</a></li>
                <li><a href="#webservers_check" data-toggle="tab">Web Servers</a></li>
                <li><a href="#bigdata_check" data-toggle="tab">Big Data</a></li>
                <li><a href="#java_check" data-toggle="tab">Java</a></li>
                <li><a href="#messagequeue_check" data-toggle="tab">Message Queue</a></li>
                <li><a href="#sqlcache_check" data-toggle="tab">SQL Cache</a></li>
                <li><a href="#hadoop_check" data-toggle="tab">Hadoop</a></li>
                <li><a href="#docstorage_check" data-toggle="tab">Document Storage</a></li>
                <li><a href="#other_check" data-toggle="tab">Other</a></li>
            </ul>
        </div>


        <div class="col-xs-9 tab-content">

        </div>


        <div  >
            <button class="calc_button">Apply</button>
            <button class="calc_button">Change</button>
        </div>


    </div>
    <div class="col-lg-4">test</div>
    <div style="clear: both"></div>
    <div>Apply</div>

</main>