<%-- 
    Document   : homepage
    Created on : Jun 13, 2016, 4:39:17 PM
    Author     : vahan
--%>
<%@page import="java.util.Enumeration"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:url value="/login/" var="loginUrl" />
<c:url value="/signup/" var="sineupUrl"/>
<div id="home">
    <!-- Slider Starts -->
    <div id="myCarousel" class="carousel slide banner-slider animated flipInX" data-ride="carousel">     
        <div class="carousel-inner">
            <!-- Item 1 -->
            <div class="item active">
                <img src="${cp}/resources/images/back1.jpg" alt="banner">          
                <div class="carousel-caption">
                    <div class="caption-wrapper">
                        <div class="caption-info">
                            <img src="${cp}/resources/images/logobig.png" class="animated bounceInUp" alt="logo">
                            <h1 class="animated bounceInLeft">Unlimited Scalability Monitoring System</h1>
                            <p class="animated bounceInRight">Have effectively unlimited scalability (storage, access rate).</p>                            
                            <div class="animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>                            
                    </div>                            
                </div>
                <div class="carousel-caption carousel-caption-small">
                    <div class="caption-wrapper">
                        <div class="caption-info">                            
                            <h1 class="animated bounceInLeft">Unlimited Scalability Monitoring System</h1>                            
                            <div class="animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>                            
                    </div>                            
                </div>
            </div>
            <!-- #Item 1 -->

            <!-- Item 1 -->
            <div class="item">
                <img src="${cp}/resources/images/back2.jpg" alt="banner">          
                <div class="carousel-caption">
                    <div class="caption-wrapper">
                        <div class="caption-info">
                            <img src="${cp}/resources/images/logobig.png" class="animated bounceInUp" alt="logo">
                            <h1 class="animated bounceInLeft">Enormous injection of metrics per client</h1>
                            <p class="animated bounceInRight">Supports enormous per 2-10 second injection of metrics per client machine.</p>
                            <div class="scroll animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>  Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>
                    </div>
                </div>
                <div class="carousel-caption carousel-caption-small">
                    <div class="caption-wrapper">
                        <div class="caption-info">
                            <h1 class="animated bounceInLeft">Enormous injection of metrics per client</h1>
                            <div class="scroll animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>  Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>
                    </div>                            
                </div>        
            </div>
            <div class="item">
                <img src="${cp}/resources/images/back3.jpg" alt="banner">          
                <div class="carousel-caption">
                    <div class="caption-wrapper">
                        <div class="caption-info">
                            <img src="${cp}/resources/images/logobig.png" class="animated bounceInUp" alt="logo">
                            <h1 class="animated bounceInLeft">Open source python agent</h1>
                            <p class="animated bounceInRight">with absolute minimum configuration and dependencies.</p>
                            <div class="scroll animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>  Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>
                    </div>
                </div>
                <div class="carousel-caption carousel-caption-small">
                    <div class="caption-wrapper">
                        <div class="caption-info">
                            <h1 class="animated bounceInLeft">Open source python agent</h1>
                            <div class="scroll animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>  Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>
                    </div>                            
                </div>         
            </div>
            <div class="item">
                <img src="${cp}/resources/images/back4.jpg" alt="banner">          
                <div class="carousel-caption">
                    <div class="caption-wrapper">
                        <div class="caption-info">
                            <img src="${cp}/resources/images/logobig.png" class="animated bounceInUp" alt="logo">
                            <h1 class="animated bounceInLeft">Simple client API</h1>
                            <p class="animated bounceInRight">Simple client API to create own custom checks.</p>
                            <div class="scroll animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>  Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>
                    </div>
                </div>
                <div class="carousel-caption carousel-caption-small">
                    <div class="caption-wrapper">
                        <div class="caption-info">                           
                            <h1 class="animated bounceInLeft">Simple client API</h1>                            
                            <div class="scroll animated fadeInUp"><a href="${sineupUrl}" class="btn btn-default"><i class="fa fa-flask"></i>  Join</a> <a href="${loginUrl}" class="btn btn-default"><i class="fa fa-paper-plane-o"></i> Sign In</a></div>
                        </div>
                    </div>                            
                </div>        
            </div>
            <!-- #Item 1 -->
        </div>
        <a class="left carousel-control" href="#myCarousel" data-slide="prev"><span class="glyphicon-chevron-left"><i class="fa fa-angle-left"></i></span></a>
        <a class="right carousel-control" href="#myCarousel" data-slide="next"><span class="glyphicon-chevron-right"><i class="fa fa-angle-right"></i></span></a>
    </div>
    <!-- #Slider Ends -->
</div>
<!-- Cirlce Starts -->
<div id="about"  class="container spacer about">
    <h2 class="text-center wowload fadeInUp">Intuitive and powerful dashboard application for end users and DevOPS</h2>  
    <div class="row">
        <div class="col-sm-6 wowload fadeInLeft">
            <h4><i class="fa fa-paint-brush"></i> Intelligent alerts</h4>
            <p>Sends intelligent alerts only when system anomaly is detected and not by statically defined threshold.</p>


        </div>
        <div class="col-sm-6 wowload fadeInRight">
            <h4><i class="fa fa-code"></i> Machine Learning</h4>
            <p>Periodically learn statuses of client`s servers, create anomalies thresholds based on time.</p>    
        </div>
    </div>

    <div class="process">
        <h3 class="text-center wowload fadeInUp">Process</h3>
        <ul class="row text-center list-inline  wowload bounceInUp">
            <li>
                <span><i class="fa fa-history"></i><b>Collect</b></span>
            </li>
            <li>
                <span><i class="fa fa-puzzle-piece"></i><b>Learn</b></span>
            </li>
            <li>
                <span><i class="fa fa-database"></i><b>Analysis</b></span>
            </li>
            <li>
                <span><i class="fa fa-magic"></i><b>Showing</b></span>
            </li>        
            <li>
                <span><i class="fa fa-cloud-upload"></i><b>Notification</b></span>
            </li>
        </ul>
    </div>
</div>
<!-- #Cirlce Ends -->

<div id="partners" class="container spacer ">
    <h2 class="text-center  wowload fadeInUp">Used technologies</h2>
    <div class="clearfix">
        <div class="col-sm-6 partners  wowload fadeInLeft">
            <img src="${cp}/resources/images/technologies/asf_logo.png" alt="apache">        
            <img src="${cp}/resources/images/technologies/hadoop-logo.jpg"  alt="hadoop">            
            <img src="${cp}/resources/images/technologies/hbase.png" alt="hbase">
            <img src="${cp}/resources/images/technologies/kafka.png"  alt="kafka">
            <img src="${cp}/resources/images/technologies/storm.png" alt="storm">        

        </div>
        <div class="col-sm-6">


            <div id="carousel-testimonials" class="carousel slide testimonails  wowload fadeInRight" data-ride="carousel">
                <div class="carousel-inner">  
                    <div class="item active animated bounceInRight row">
                        <div class="animated slideInLeft col-xs-2"><img alt="portfolio" src="${cp}/resources/images/technologies/hadoop-logo.jpg" width="100" class="img-circle img-responsive"></div>
                        <div  class="col-xs-10">
                            <p> Hadoop makes it possible to run applications on systems with thousands of commodity hardware nodes, and to handle thousands of terabytes of data. Its distributed file system facilitates rapid data transfer rates among nodes and allows the system to continue operating in case of a node failure. This approach lowers the risk of catastrophic system failure and unexpected data loss, even if a significant number of nodes become inoperative. Consequently, Hadoop quickly emerged as a foundation for big data processing tasks, such as scientific analytics, business and sales planning, and processing enormous volumes of sensor data, including from internet of things sensors.
                            </p>                                  
                        </div>
                    </div>
                    <div class="item  animated bounceInRight row">
                        <div class="animated slideInLeft col-xs-2"><img alt="portfolio" src="${cp}/resources/images/technologies/kafka.png" width="100" class="img-circle img-responsive"></div>
                        <div  class="col-xs-10">
                            <p> Kafka is one of those systems that is very simple to describe at a high level, but has an incredible depth of technical detail when you dig deeper. The Kafka documentation does an excellent job of explaining the many design and implementation subtleties in the system, so we will not attempt to explain them all here. In summary, Kafka is a distributed publish-subscribe messaging system that is designed to be fast, scalable, and durable.
                                Like many publish-subscribe messaging systems, Kafka maintains feeds of messages in topics. Producers write data to topics and consumers read from topics. Since Kafka is a distributed system, topics are partitioned and replicated across multiple nodes.
                            </p>                                
                        </div>
                    </div>
                    <div class="item  animated bounceInRight row">
                        <div class="animated slideInLeft  col-xs-2"><img alt="portfolio" src="${cp}/resources/images/technologies/storm.png" width="100" class="img-circle img-responsive"></div>
                        <div  class="col-xs-10">
                            <p> Storm is a distributed real-time computation system for processing large volumes of high-velocity data. Storm is extremely fast, with the ability to process over a million records per second per node on a cluster of modest size. Enterprises harness this speed and combine it with other data access applications in Hadoop to prevent undesirable events or to optimize positive outcomes.
                                Some of specific new business opportunities include: real-time customer service management, data monetization, operational dashboards, or cyber security analytics and threat detection.
                            </p>                                
                        </div>
                    </div>
                </div>

                <!-- Indicators -->
                <ol class="carousel-indicators">
                    <li data-target="#carousel-testimonials" data-slide-to="0" class="active"></li>
                    <li data-target="#carousel-testimonials" data-slide-to="1"></li>
                    <li data-target="#carousel-testimonials" data-slide-to="2"></li>
                </ol>
                <!-- Indicators -->
            </div>



        </div>
    </div>


    <!-- team -->
    <h3 class="text-center  wowload fadeInUp">Our team</h3>
    <p class="text-center  wowload fadeInLeft">Our fantastic team that sees the future</p>
    <div class="row grid team  wowload fadeInUpBig">	
        <div class=" col-sm-3 col-xs-6">
            <figure class="effect-chico">
                <img src="${cp}/resources/images/team/sadoyan.jpg" alt="sadoyan" class="img-responsive" />
                <figcaption>
                    <p><b>Ara Sadoyan</b><br>Founder<br><br><a href="#"><i class="fa fa-dribbble"></i></a> <a href="#"><i class="fa fa-facebook"></i></a> <a href="#"><i class="fa fa-twitter"></i></a></p>            
                </figcaption>
            </figure>
        </div>

        <div class=" col-sm-3 col-xs-6">
            <figure class="effect-chico">
                <img src="${cp}/resources/images/team/10.jpg" alt="img01"/>
                <figcaption>            
                    <p><b>Vahan Avagyan</b><br>Senior Developer<br><br><a href="#"><i class="fa fa-dribbble"></i></a> <a href="#"><i class="fa fa-facebook"></i></a> <a href="#"><i class="fa fa-twitter"></i></a></p>            
                </figcaption>
            </figure>
        </div>

        <div class=" col-sm-3 col-xs-6">
            <figure class="effect-chico">
                <img src="${cp}/resources/images/team/12.jpg" alt="img01"/>
                <figcaption>
                    <p><b>Chewbacca</b><br>FrontEnd Developer<br><br><a href="#"><i class="fa fa-dribbble"></i></a> <a href="#"><i class="fa fa-facebook"></i></a> <a href="#"><i class="fa fa-twitter"></i></a></p>          
                </figcaption>
            </figure>
        </div>

        <div class=" col-sm-3 col-xs-6">
            <figure class="effect-chico">
                <img src="${cp}/resources/images/team/17.jpg" alt="img01"/>
                <figcaption>
                    <p><b>Artoo-Detoo</b><br>Network Engineer<br><br><a href="#"><i class="fa fa-dribbble"></i></a> <a href="#"><i class="fa fa-facebook"></i></a> <a href="#"><i class="fa fa-twitter"></i></a></p>
                </figcaption>
            </figure>
        </div>


    </div>
    <!-- team -->

</div>









<!-- About Starts -->
<div class="highlight-info">
    <div class="overlay spacer">
        <div class="container">
            <div class="row text-center  wowload fadeInDownBig">
                <div class="col-sm-3 col-xs-6">
                    <i class="fa fa-smile-o  fa-5x"></i><h4>200 Hosts</h4>
                </div>
                <div class="col-sm-3 col-xs-6">
                    <i class="fa fa-rocket  fa-5x"></i><h4>10K Alerts </h4>
                </div>
                <div class="col-sm-3 col-xs-6">
                    <i class="fa fa-cloud-download  fa-5x"></i><h4>5 Clusters</h4>
                </div>
                <div class="col-sm-3 col-xs-6">
                    <i class="fa fa-map-marker fa-5x"></i><h4>2Bil Metrics</h4>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- About Ends -->








<div id="contact" class="spacer">
    <!--Contact Starts-->
    <div class="container contactform center">
        <h2 class="text-center  wowload fadeInUp">Have questions? Ask them to us.</h2>
        <div class="row wowload fadeInLeftBig">      

            <div class="col-sm-6 col-sm-offset-3 col-xs-12">      
                <input type="text" placeholder="Name" class="form-control">
                <input type="text" placeholder="Company" class="form-control">
                <textarea rows="5" placeholder="Message" class="form-control"></textarea>
                <button class="btn btn-primary"><i class="fa fa-paper-plane"></i> Send</button>
            </div>
            <!--</form>-->
        </div>



    </div>
</div>
<!--Contact Ends-->