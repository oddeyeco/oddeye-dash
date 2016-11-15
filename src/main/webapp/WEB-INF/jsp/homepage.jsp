<%-- 
    Document   : homepage
    Created on : Jun 13, 2016, 4:39:17 PM
    Author     : vahan
--%>
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
            </div>
            <!-- #Item 1 -->

            <!-- Item 1 -->
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
            </div>
            <!-- #Item 1 -->

            <!-- Item 1 -->
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
    <h2 class="text-center  wowload fadeInUp">Some of our happy clients</h2>
    <div class="clearfix">
        <div class="col-sm-6 partners  wowload fadeInLeft">
            <img src="${cp}/resources/images/partners/1.jpg"  alt="partners">
            <img src="${cp}/resources/images/partners/2.jpg"  alt="partners">
            <img src="${cp}/resources/images/partners/3.jpg" alt="partners">
            <img src="${cp}/resources/images/partners/4.jpg" alt="partners">
        </div>
        <div class="col-sm-6">


            <div id="carousel-testimonials" class="carousel slide testimonails  wowload fadeInRight" data-ride="carousel">
                <div class="carousel-inner">  
                    <div class="item active animated bounceInRight row">
                        <div class="animated slideInLeft col-xs-2"><img alt="portfolio" src="${cp}/resources/images/team/1.jpg" width="100" class="img-circle img-responsive"></div>
                        <div  class="col-xs-10">
                            <p> I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. </p>      
                            <span>Angel Smith - <b>eshop Canada</b></span>
                        </div>
                    </div>
                    <div class="item  animated bounceInRight row">
                        <div class="animated slideInLeft col-xs-2"><img alt="portfolio" src="${cp}/resources/images/team/2.jpg" width="100" class="img-circle img-responsive"></div>
                        <div  class="col-xs-10">
                            <p>No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful.</p>
                            <span>John Partic - <b>Crazy Pixel</b></span>
                        </div>
                    </div>
                    <div class="item  animated bounceInRight row">
                        <div class="animated slideInLeft  col-xs-2"><img alt="portfolio" src="${cp}/resources/images/team/3.jpg" width="100" class="img-circle img-responsive"></div>
                        <div  class="col-xs-10">
                            <p>On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue.</p>
                            <span>Harris David - <b>Jet London</b></span>
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
    <p class="text-center  wowload fadeInLeft">Our creative team that is making everything possible</p>
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
                    <p><b>Barbara Husto</b><br>Senior Designer<br><br><a href="#"><i class="fa fa-dribbble"></i></a> <a href="#"><i class="fa fa-facebook"></i></a> <a href="#"><i class="fa fa-twitter"></i></a></p>            
                </figcaption>
            </figure>
        </div>

        <div class=" col-sm-3 col-xs-6">
            <figure class="effect-chico">
                <img src="${cp}/resources/images/team/12.jpg" alt="img01"/>
                <figcaption>
                    <p><b>Barbara Husto</b><br>Senior Designer<br><br><a href="#"><i class="fa fa-dribbble"></i></a> <a href="#"><i class="fa fa-facebook"></i></a> <a href="#"><i class="fa fa-twitter"></i></a></p>          
                </figcaption>
            </figure>
        </div>

        <div class=" col-sm-3 col-xs-6">
            <figure class="effect-chico">
                <img src="${cp}/resources/images/team/17.jpg" alt="img01"/>
                <figcaption>
                    <p><b>Barbara Husto</b><br>Senior Designer<br><br><a href="#"><i class="fa fa-dribbble"></i></a> <a href="#"><i class="fa fa-facebook"></i></a> <a href="#"><i class="fa fa-twitter"></i></a></p>
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