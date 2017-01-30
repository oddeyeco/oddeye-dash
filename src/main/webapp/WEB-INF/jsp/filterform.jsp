<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="form-group">
    <label class="col-md-12 col-sm-12 col-xs-12">By Tag</label>
    <c:forEach items="${curentuser.getMetricsMeta().getTagsList()}" var="tagitem">   
        <div class="form-group">
            <label class=" col-lg-12 col-sm-12 col-xs-12">
                ${fn:toUpperCase(fn:substring(tagitem.key, 0, 1))}${fn:toLowerCase(fn:substring(tagitem.key, 1,fn:length(tagitem.key)))}
                <input type="checkbox" class="js-switch-small filter-switch" id="check_${tagitem.key}" name="check_${tagitem.key}" value="${tagitem.key}"/> 
            </label>
            <div class="col-lg-12 col-sm-12 col-xs-12">
                <input class="form-control autocomplete-append filter-input" type="text" name="${tagitem.key}_input" id="${tagitem.key}_input" tagkey="${tagitem.key}" value="">
                <div class="autocomplete-container_${tagitem.key}" style="position: relative; float: left; width: 400px; margin: 0px;"></div>
            </div>
        </div>
    </c:forEach>
</div>
<div class="form-group">
    <label class="col-md-12 col-sm-12 col-xs-12">Level</label>
    <div class="col-md-12 col-sm-12 col-xs-12">
        <c:forEach items="${curentuser.getAlertLevels()}" var="level">   
            <div class="col-lg-6">
                <label>
                    <input type="checkbox" class="js-switch-small" id="check_level_${level.key}" name="check_level_${level.key}" /> ${curentuser.getAlertLevels().getName(level.key)}
                </label>
            </div>                                
        </c:forEach>
    </div>
</div>                                                                                       
