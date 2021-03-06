<%-- 
    Document   : taglist
    Created on : Jul 9, 2016, 3:20:58 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css?v=${version}" rel="stylesheet">
<h1>Your Metric list</h1>
<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <div class="x_title">
                <h2>List of <small>Metric list</small></h2>
                <div class="clearfix"></div>
            </div>

            <div class="x_content">
                <table id="datatable" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>
                                Check
                            </th>                             
                            <th>Name</th>                            
                        </tr>
                    </thead>


                    <tbody>
                        <c:forEach items="${curentuser.getMetrics()}" var="Datakey">
                            <tr>
                                <td>
                                    <input type="checkbox" value = "*" type="${Datakey.key}">
                                </td>                                  
                                <td> <a href="<c:url value="/chart/?metrics=${Datakey.key}&tags=${tags}"/>">  ${Datakey.key} </a></td>                                                               
                            </tr>
                        </c:forEach> 
                    </tbody>
                </table>

                <%--${data}--%>
                <%--
                <ul>                    
                    <c:forEach items="${data}" var="Datapoints">
                        <ol>            
                            <ul>
                                <c:forEach items="${Datapoints}" var="Datalist">
                                    <li> ${Datalist.metricName()} ${Datalist.getTags()}   
                                        <ul>
                                            <c:forEach items="${Datalist.iterator()}" var="datapoint">
                                                <li>                                                    
                                                    <jsp:useBean id="dateValue" class="java.util.Date"/>
                                                    <jsp:setProperty name="dateValue" property="time" value="${datapoint.timestamp()}"/>
                                                    <fmt:formatDate value="${dateValue}" pattern="MM/dd/yyyy HH:mm:ss"/>                                                    
                                                    - ${datapoint.doubleValue()}
                                                </li>
                                            </c:forEach>    
                                        </ul>
                                    </li>
                                </c:forEach>
                            </ul>


                        </ol>
                    </c:forEach>                    
                </ul>
                            --%>
            </div>
        </div>
    </div>
</div>
