<%-- 
    Document   : balacepart.jsp
    Created on : Dec 7, 2018, 2:51:49 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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