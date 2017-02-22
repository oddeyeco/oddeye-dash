<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">

<div class="x_panel">
    <div class="x_title">
        <h2 class="col-md-3" >List of ${modelname}</h2>        
        <div class="clearfix"></div>
    </div>        
    <div class="x_content" id="dashcontent">     
        <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
            <thead>
                <tr>${modellist[0].toHtmlhead("th","</th><th>")}</tr>              
            </thead>
            <tbody>
                <c:forEach items="${modellist}" var="model">   
                <tr>${model.toHtml("td","</td><td>")}</tr>
                </c:forEach>                
            </tbody>

        </table>        
    </div>
</div>

