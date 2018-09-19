<%-- 
    Document   : dashboards
    Created on : Apr 12, 2017, 12:14:22 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="row">
    <div class="col-md-8">
        <div class="x_panel">    
            <div class="x_title">
                <h2><spring:message code="dashboards.myDashboards"/> (${activeuser.getDushList().size()})</h2>
                <a class="btn btn-success btn-sm pull-right" href="<spring:url value="/dashboard/new"  htmlEscape="true"/>" ><spring:message code="dashboards.newDashboard"/> </a>
                <div class="clearfix"></div>
            </div>

            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${activeuser.getDushListasObject()}" var="Dush" varStatus="loop">                                
                            <li class="col-md-6">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" class="gotodash">
                                    <c:if test="${Dush.value.get(\"locked\")==true}">
                                        &nbsp; <i class="fa fas fa-lock"></i>
                                    </c:if>                                                               
                                    <c:if test="${Dush.value.get(\"locked\")!=true}">
                                        &nbsp; <i class="fa fas fa-lock-open"></i>
                                    </c:if>                                      
                                    ${Dush.getKey()}</a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                

        </div>    
        <div class="x_panel">    
            <div class="x_title">
                <div class="row">
                    <div class="col-md-6 col-xs-12 pull-left">
                     <h2><spring:message code="dashboards.statistic"/></h2>
                    </div>         
                    <div class="col-md-6 col-xs-12">
                    <a id="Get_Agent" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://github.com/oddeyeco/"  htmlEscape="true" />" target="_blank" ><spring:message code="dashboards.getAgent"/></a>
                    <a id="Agent_Guide" class="idcheck btn btn-success btn-sm pull-right" href="<spring:url value="https://www.oddeye.co/documentation/puypuy/puypuy/"  htmlEscape="true"/>" target="_blank"><spring:message code="dashboards.guideAgent"/></a>
                    </div>
                </div>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <c:import url="metricinfo.jsp" />
            </div>                
        </div>                 

    </div>    

    <div class="col-md-4">
        <div class="x_panel balace_part">          
            <div class="x_title">
                <h2><spring:message code="balance"/></h2>                               
                <div class="clearfix"></div>
            </div>
            <div class="row tile_count">
                <div class="col-sm-6 col-xs-12 tile_stats_count">
                    <h4 class="count_top"><spring:message code="dashboards.available"/></h4>
                    <div class="count">
                        <c:set var="balance" value="${curentuser.getBalance()}" />
                        <c:if test="${balance<Double.MAX_VALUE}">
                            <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${balance}" />
                        </c:if>                    
                        <c:if test="${balance==Double.MAX_VALUE}">
                            &infin; 
                        </c:if>                          
                        <c:if test="${balance==null}">
                            0
                        </c:if>                             
                    </div>
                    <c:set var="Consumption" value="${curentuser.getConsumptionList().getConsumptionListDay(0)}" />
                    <!--                    <span class="count_bottom">
                                            Consumed
                                            <i class="green">
                    <c:if test="${Consumption!=null}">
                        <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${Consumption.getAmount()}" />                                
                    </c:if>
                    <c:if test="${Consumption==null}">
                        0                            
                    </c:if>                            
                </i> Today                        
            </span>                          -->
                </div>
                <div class="col-sm-6 col-xs-12 tile_stats_count Consumptions">
                    <h4 class="count_top"><spring:message code="dashboards.burnRate"/></h4>
                    <c:set var="Consumption" value="${curentuser.getConsumptionList().getConsumptionListDay(0)}" />                    
                    <div class="count_bottom clearfix">                        
                        <span class="pull-left"><spring:message code="dashboards.burnRateToday"/> </span>
                        <div class="green">
                            <c:if test="${Consumption!=null}">
                                <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${Consumption.getAmount()}" />                                
                            </c:if>
                            <c:if test="${Consumption==null}">
                                0                            
                            </c:if> 
                        </div> 
                    </div>                                 
                    <c:set var="Consumption" value="${curentuser.getConsumptionList().getConsumptionListDay(1)}" />
                    <div class="count_bottom clearfix">                        
                        <span class="pull-left"><spring:message code="dashboards.burnRateYesterday"/> </span>
                        <div class="green">
                            <c:if test="${Consumption!=null}">
                                <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${Consumption.getAmount()}" />                                
                            </c:if>
                            <c:if test="${Consumption==null}">
                                0                            
                            </c:if> 
                        </div>
                    </div>                          
                    <c:set var="Consumption" value="${curentuser.getConsumptionList().getConsumptionListMonth(0)}" />
                    <div class="count_bottom clearfix">                        
                        <span class="pull-left"><spring:message code="dashboards.burnRateThisMonth"/></span>
                        <div class="green" id="thismonth">
                            <c:if test="${Consumption!=null}">
                                <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${Consumption.getAmount()}" />                                
                            </c:if>
                            <c:if test="${Consumption==null}">
                                0                            
                            </c:if> 
                        </div>
                    </div>
                    <c:set var="Consumption" value="${curentuser.getConsumptionList().getConsumptionListMonth(1)}" />
                    <div class="count_bottom clearfix">                        
                        <span class="pull-left"><spring:message code="dashboards.burnRatePreviousMonth"/></span>
                        <div class="green" id="prevmonth">
                            <c:if test="${Consumption!=null}">
                                <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${Consumption.getAmount()}" />                                
                            </c:if>
                            <c:if test="${Consumption==null}">
                                0                            
                            </c:if> 
                        </div>
                    </div>                     
                </div>  
                <div class="clearfix"></div>
                <!--<form action="https://www.sandbox.paypal.com/cgi-bin/webscr" method="post" target="_top">
                <input type="hidden" name="cmd" value="_s-xclick">
                <input type="hidden" name="hosted_button_id" value="F5L9FW2Q6K9ZW">
                <input type="image" src="https://www.sandbox.paypal.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
                <img alt="" border="0" src="https://www.sandbox.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
                </form>-->


                <div class="col-xs-12 moreunits">
                    <h4><spring:message code="dashboards.getMore"/></h4>
                    <div class="clearfix"></div>
                    <div class="pull-left col-sm-6 col-xs-12 od">                                                
                        <label for="amount"> <spring:message code="dashboards.pay"/> </label> <input id="oddeyeAmmount" type="number" name="amount" value="1" step="1"> <spring:message code="usd"/><br>
                        <!--<label for="quantity"> Get </label><input id="oddeyeQuantity" type="number" name="quantity" value="1" step="0.001"> Units-->
                    </div>
                    <div class="pull-right col-sm-6 col-xs-12 pp">
                        <form action="${paypal_url}" method="post" >
                            <input type="hidden" name="cmd" value="_xclick">
                            <input type="hidden" name="business" value="${paypal_email}">
                            <input id="paypalItemName" type="hidden" name="item_name" value="Oddeye Points ${curentuser.getEmail()}" text="OddEye units ${curentuser.getEmail()}">                            
                            <input id="paypalAmmount" type="hidden" name="amount" value="">                            
                            <input type="hidden" name="custom" value="${curentuser.getId()}">
                            <input type="hidden" name="no_shipping" value="1">
                            <input type="hidden" name="return" value="${paypal_returnurl}">
                            <input type="hidden" name="notify_url" value="${paypal_notifyurl}">
                            <input type="hidden" name="image_url" value="https://app.oddeye.co/OddeyeCoconut/assets/images/email/logo_100px.png">
                            <input type="hidden" name="currency_code" value="USD">                        
                            <input type="hidden" name="bn" value="PP-BuyNowBF">                            
                            <input type="image" src="https://www.paypal.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
                        </form>        
                    </div>
                </div>



            </div>                       
        </div>         
        <div class="x_panel">          
            <div class="x_title">
                <h2><spring:message code="dashboards.availableTemplates"/></h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${recomend}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash"> <span> 
                                        <i class="fa fas fa-info-circle" data-toggle="tooltip" data-html="true" data-placement="left" title="" data-delay='{"hide":"1000"}' data-original-title="${fn:escapeXml(Dush.getDescription())} <div> Metrics-${Dush.getUsednames().size()}<br>Tag Filters-${Dush.getUsedtags().size()}</div>"></i>

                                        ${Dush.getName()}</span>
                                    <span class="pull-right"><fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/></span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>             
            <div class="x_title">
                <h2><spring:message code="dashboards.myTemplates"/></h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash lastdash">
                        <c:forEach items="${mylasttemplates}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash">                                    
                                    <c:if test="${Dush.isRecomended()}">
                                        <i class="fa fa-check-circle green"></i>
                                    </c:if>                                      
                                    <c:if test="${!Dush.isRecomended()}">
                                        <i class="fa fa-dot-circle-o blue"></i>
                                    </c:if>                                         
                                    <span>${Dush.getName()}</span>
                                    <span class="pull-right"> <fmt:formatDate value="${Dush.getTime()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/></span>                                    
                                </a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                                     

        </div>         
    </div> 
</div>

