<%-- 
    Document   : balacepartOE
    Created on : Apr 17, 2019, 6:41:44 PM
    Author     : tigran
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="card shadow mb-4">
    <h4 class="card-header">
        <spring:message code="balance"/>
    </h4>
    <div class="card-body">                                
        <div class="row">
            <div class="col-xl-6 col-lg-12 col-md-6 col-sm-6 col-12">
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
                <c:if test="${Consumption!=null}">
                    <fmt:formatNumber type="number" pattern = "0.00" maxFractionDigits="2" value=" ${Consumption.getAmount()}" />                                
                </c:if>
                <c:if test="${Consumption==null}">
                    0                            
                </c:if>   
            </div>
            <div class="col-xl-6 col-lg-12 col-md-6 col-sm-6 col-12 tile_stats_count Consumptions">
                <h4 class="count_top"><spring:message code="dashboards.burnRate"/></h4>
                <div class="count_bottom clearfix">
                    <span class="float-left"><spring:message code="dashboards.burnRateToday"/></span>
                    <div class="green float-right">
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
                    <span class="float-left"><spring:message code="dashboards.burnRateYesterday"/></span>
                    <div class="green float-right">
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
                    <span class="float-left"><spring:message code="dashboards.burnRateThisMonth"/></span>
                    <div class="green float-right" id="thismonth">
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
                    <span class="float-left"><spring:message code="dashboards.burnRatePreviousMonth"/></span>
                    <div class="green float-right" id="prevmonth">
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
            <div class="col-12 moreunits">
                <h4><spring:message code="dashboards.getMore"/></h4>
                <div class="clearfix"></div>
                <div class="float-left col-xl-6 col-lg-12 col-sm-6 od">
                    <label for="amount"><spring:message code="dashboards.pay"/></label>
                    <input id="oddeyeAmmount" type="number" name="amount" value="1" step="1"><spring:message code="usd"/><br>
                </div>
                <div class="float-right col-xl-6 col-lg-12 col-sm-6 pp">
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
</div>                       
<div class="card shadow mb-4">
    <h4 class="card-header"><spring:message code="payments"/></h4>
    <div class="card-body"> 
        <ul class="row list-unstyled">
            <c:forEach items="${curentuser.getPayments()}" var="payment" varStatus="loop">                                
                <li class="col-12">
                    <span class="float-left">  
                        <fmt:formatDate value="${payment.getPayment_date()}" pattern="MM/dd/yyyy HH:mm:ss z" timeZone="${curentuser.getTimezone()}"/>
                    </span>
                    <span class="float-right"> ${payment.getPayment_gross()} $ </span>
                </li>                                
            </c:forEach>   
        </ul> 
    </div>                                
</div>