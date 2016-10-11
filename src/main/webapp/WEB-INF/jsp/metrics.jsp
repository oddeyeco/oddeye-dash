<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link href="${cp}/resources/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
<div class="page-title">
    <div class="title_left">
        <h3>Metrics</h3>
    </div>
</div>

<div class="clearfix"></div>

<div class="row">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <div class="x_content">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <div class="x_content">
                        <table id="datatable-fixed-header" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>
                                        Name
                                    </th>                                     
                                    <c:forEach items="${curentuser.getMetricsMeta().getTagK()}" var="tag">
                                        <c:if test="${tag != \"UUID\"}" >        
                                            <th>
                                                ${tag}
                                            </th> 
                                        </c:if>
                                    </c:forEach>       
                                    <th>
                                        lololo
                                    </th>        

                                </tr>    
                            </thead>
                            <tbody>                                
                                <c:forEach items="${curentuser.getMetricsMeta()}" var="tagitem">

                                    <tr>
                                        <td>
                                            ${tagitem.value.name} 
                                        </td>                                          
                                        <c:forEach items="${curentuser.getMetricsMeta().getTagK()}" var="tag">
                                            <c:if test="${tag != \"UUID\"}" >        
                                                <td>
                                                    ${tagitem.value.tags.get(tag).value}                                                                                                                                                
                                                </td>  
                                            </c:if>
                                        </c:forEach>                                            
                                         
                                        <td>
                                            lololol
                                        </td>                                                                                       
                                    </tr>                                

                                </c:forEach>                            

                            </tbody>       
                        </table>                                    
                    </div>                    
                </div>
            </div>
        </div>
    </div>
</div>

<!-- /page content -->
