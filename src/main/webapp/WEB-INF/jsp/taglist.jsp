<%-- 
    Document   : taglist
    Created on : Jul 9, 2016, 3:20:58 PM
    Author     : vahan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
<h1>${tagkey} ${tagname} Metric list</h1>
<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <div class="x_title">
                <h2>List of <small>${tagname} Metric list</small></h2>
                <div class="clearfix"></div>
            </div>

            <div class="x_content">
                <table id="datatable" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Name</th>
                        </tr>
                    </thead>


                    <tbody>
                        <c:forEach items="${list.getDatakeys()}" var="Datakey">
                            <tr>
                                <td> <a href="<c:url value="/chart/${tagkey}/${tagname}/${Datakey}"/>">  ${Datakey} </a></td>
                                
                            </tr>
                        </c:forEach> 
                    </tbody>
                </table>

            </div>
        </div>
    </div>
</div>
