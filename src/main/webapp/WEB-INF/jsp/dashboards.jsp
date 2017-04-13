<%-- 
    Document   : dashboards
    Created on : Apr 12, 2017, 12:14:22 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div class="row">
    <div class="page-title"><div class="title_left"><h1>Dashboards</h1></div></div>
</div>
<div class="row">
    <div class="col-md-8">
        <div class="x_panel">    
            <div class="x_title">
                <h2>My Dashboards (${curentuser.getDushList().size()})</h2>
                <a class="btn btn-success btn-sm pull-right" href="<spring:url value="/dashboard/new"  htmlEscape="true"/>" >New Dashboard </a>
                <div class="clearfix"></div>
            </div>
            
            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${curentuser.getDushList()}" var="Dush" varStatus="loop">                                
                            <li class="col-md-6">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/dashboard/${Dush.key}"  htmlEscape="true"/>" class="gotodash">${Dush.getKey()}</a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>                

        </div>    
    </div>    
    <div class="col-md-4">
        <div class="x_panel">          
            <div class="x_title">
                <h2>Using recommends</h2>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div>
                    <ul class="gotodash">
                        <c:forEach items="${templates}" var="Dush" varStatus="loop">                                
                            <li class="col-lg-12">
                                <!--<input type="checkbox" class="flat">-->
                                <a href="<spring:url value="/template/${Dush.getStKey()}"  htmlEscape="true"/>" class="gotodash">${Dush.getName()}</a> 
                            </li>                                
                        </c:forEach>
                    </ul>
                </div>
            </div>             
        </div>    
    </div> 
</div>

