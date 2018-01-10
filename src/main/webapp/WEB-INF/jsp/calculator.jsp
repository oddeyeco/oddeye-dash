<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<main>
    <div  class="col-lg-12">
        <h3>Price Calculator</h3>
        <hr/>
        <div class="col-xs-3 col-md-2">
            <ul class="nav nav-tabs tabs-left">
                <li class="active"><a href="#sysChecks" data-toggle="tab">System Checks</a></li>
                <li><a href="#webServers" data-toggle="tab">Web Servers</a></li>
                <li><a href="#bigData" data-toggle="tab">Big Data</a></li>
                <li><a href="#java" data-toggle="tab">Java</a></li>
                <li><a href="#messageQueue" data-toggle="tab">Message Queue</a></li>
                <li><a href="#SQLCache" data-toggle="tab">SQL Cache</a></li>
                <li><a href="#hadoop" data-toggle="tab">Hadoop</a></li>
                <li><a href="#other" data-toggle="tab">Other</a></li>
            </ul>
        </div>
        <div class="col-xs-9">
            <!-- Tab panes -->
            <div class="tab-content">
                <div class="tab-pane active" id="sysChecks">
                    System Checks
                </div>
                <div class="tab-pane" id="webServers">
                    <div>
                        <a href=""><img alt="" src="https://www.oddeye.co/wp-content/uploads/2017/06/apache.png"></a>
                        <div class="for_hover">
                            <p>Abaut Apache Check</p>
                            <button>Learn More</button>
                        </div>
                    </div>
                    <a href=""><img alt="" src="https://www.oddeye.co/wp-content/uploads/2017/06/apache.png"></a>
                    <a href=""><img alt="" src="https://www.oddeye.co/wp-content/uploads/2017/06/apache.png"></a>
                    <a href=""><img alt="" src="https://www.oddeye.co/wp-content/uploads/2017/06/apache.png"></a>


                </div>
                <div class="tab-pane" id="bigData">
                    Big Data
                </div>
                <div class="tab-pane" id="java">
                    Java
                </div>
                <div class="tab-pane" id="messageQueue">
                    Message Queue
                </div>
                <div class="tab-pane" id="SQLCache">
                    SQL Cache
                </div>
                <div class="tab-pane" id="hadoop">
                    Hadoop
                </div>
                <div class="tab-pane" id="other">
                    Other
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
    </div>
</main>