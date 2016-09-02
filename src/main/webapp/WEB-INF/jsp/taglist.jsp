<%-- 
    Document   : taglist
    Created on : Jul 9, 2016, 3:20:58 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
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
                            <th>Name</th>
                            <th>***</th>
                        </tr>
                    </thead>


                    <tbody>
                        <c:forEach items="${curentuser.getMetrics()}" var="Datakey">
                            <tr>
                                <td> <a href="<c:url value="/chart"/>">  ${Datakey.key} </a></td>
                                <th>***</th>                                
                            </tr>
                        </c:forEach> 
                    </tbody>
                </table>


                <ul>                    
                    <%--<c:forEach items="${data}" var="Datapoint">
                        <ol>                                                   
                            <jsp:useBean id="dateValue" class="java.util.Date"/>
                            <jsp:setProperty name="dateValue" property="time" value="${Datapoint.timestamp()}"/>
                            <fmt:formatDate value="${dateValue}" pattern="MM/dd/yyyy HH:mm:ss"/>
                        </ol>
                    </c:forEach>--%>
                </ul>
            </div>
        </div>
    </div>
</div>
