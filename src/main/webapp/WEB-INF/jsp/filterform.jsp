<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="form-group">    
    <label class="col-xs-12">
        Metric
        <input type="checkbox" class="js-switch-small filter-switch" name="check_metric" value="metric"/> 
    </label>    
    <div class="col-xs-12">
        <input class="form-control autocomplete-append-metric filter-input" type="text" name="metric_input"  tagkey="metric" value="">
        <div class="autocomplete-container-metric" style="position: relative; float: left; width: 400px; margin: 0px;"></div>
    </div>    
    <label class="col-xs-12 taglabel">By Tag <button class="btn btn-success addtagq btn-xs" type="button">Edit tag filer</button></label> 
    <c:forEach items="${activeuser.getMetricsMeta().getTagsKeysSort()}" var="tagitem">
        <div class="form-group tagfilter" id="div_${tagitem}" style="display: none" >
            <label class="col-xs-12">
                ${fn:toUpperCase(fn:substring(tagitem, 0, 1))}${fn:toLowerCase(fn:substring(tagitem, 1,fn:length(tagitem)))}
                <input type="checkbox" class="js-switch-small filter-switch" name="check_${tagitem}" value="${tagitem}"/> 
            </label>
            <div class="col-lg-12 col-sm-12 col-xs-12">
                <input class="form-control autocomplete-append filter-input" type="text" name="${tagitem}_input" tagkey="${tagitem}" value="">
                <div class="autocomplete-container_${tagitem}" style="position: relative; float: left; width: 400px; margin: 0px;"></div>
            </div>
        </div>
    </c:forEach>    
</div>
<div class="form-group">
    <label class="col-xs-12">Level</label>
    <div class="col-xs-12">
        <c:forEach items="${activeuser.getAlertLevels()}" var="level">   
            <div class="col-lg-6">
                <label>
                    <input type="checkbox" class="js-switch-small" name="check_level_${level.key}" /> ${activeuser.getAlertLevels().getName(level.key)}
                </label>
            </div>                                
        </c:forEach>
    </div>
</div>                                                                                       
