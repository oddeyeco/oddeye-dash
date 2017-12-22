<%-- 
    Document   : signup
    Created on : Jun 13, 2016, 4:58:05 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div  class="title_left"  >
    <h3>Price Calculator</h3>
</div>
<div class="container"  >

    <div class="x_panel x_content table-responsive">
        <table class="row calc table table-striped" >
            <thead col-lg-12 >
                <tr class="row " >

                    <th >Instances</th>
                    <th style="min-width: 100px" >Check Every(S)</th>
                    <th >Checks Enabled</th>
                    <th ></th>
                    <th >Price</th>
                </tr>
            </thead>
            <tbody col-lg-12>
            </tbody>
            <tfoot col-lg-12>
                <tr class="buttonTd row">
                    <td><button id="plus" class="reflock"> <i class="fa fa-plus" aria-hidden="true"></i></button></td>
                </tr>
            </tfoot>
        </table>

    </div>
</div>