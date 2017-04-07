<div id="form_template" class="hidden">
    <form class="form-horizontal form-label-left edit-query" id="baze_query">
        <div class="form-group form-group-custom">
            <label class="control-label control-label-custom-legend" for="tags">Tags 
            </label>
            <div class="data-label tags" > </div>
            <label class="control-label query-label tags"><a><i class="fa fa-plus "></i></a></label>
            <!--<input id="baze_tags" name="tags" class="form-control query_input" type="text" value="host=cassa001*">-->        
        </div>
        <div class="form-group form-group-custom">
            <label class="control-label control-label-custom-legend" for="metrics">Metrics 
            </label>
            <div class="data-label metrics" > </div>
            <label class="control-label query-label metrics"><a><i class="fa fa-plus"></i></a></label>

            <!--<input id="baze_metrics" name="metrics" class="form-control query_input" type="text" value="cpu_user">-->
        </div>
        <div class="form-group form-group-custom">
            <label class="control-label control-label-custom-legend" for="metrics">Aggregator: 
            </label>        
            <select name="aggregator" class="form-control query_input aggregator">
                <option label="avg" value="avg">avg</option>
                <option label="count" value="count">count</option>
                <option label="dev" value="dev">dev</option>
                <option label="ep50r3" value="ep50r3">ep50r3</option>
                <option label="ep50r7" value="ep50r7">ep50r7</option>
                <option label="ep75r3" value="ep75r3">ep75r3</option>
                <option label="ep75r7" value="ep75r7">ep75r7</option>
                <option label="ep90r3" value="ep90r3">ep90r3</option>
                <option label="ep90r7" value="ep90r7">ep90r7</option>
                <option label="ep95r3" value="ep95r3">ep95r3</option>
                <option label="ep95r7" value="ep95r7">ep95r7</option>
                <option label="ep999r3" value="ep999r3">ep999r3</option>
                <option label="ep999r7" value="ep999r7">ep999r7</option>
                <option label="ep99r3" value="ep99r3">ep99r3</option>
                <option label="ep99r7" value="ep99r7">ep99r7</option>
                <option label="first" value="first">first</option>
                <option label="last" value="last">last</option>
                <option label="max" value="max">max</option>
                <option label="mimmax" value="mimmax">mimmax</option>
                <option label="mimmin" value="mimmin">mimmin</option>
                <option label="min" value="min">min</option>
                <option label="mult" value="mult">mult</option>
                <option label="none" value="none">none</option>
                <option label="p50" value="p50">p50</option>
                <option label="p75" value="p75">p75</option>
                <option label="p90" value="p90">p90</option>
                <option label="p95" value="p95">p95</option>
                <option label="p99" value="p99">p99</option>
                <option label="p999" value="p999">p999</option>
                <option label="sum" value="sum">sum</option>
                <option label="zimsum" value="zimsum">zimsum</option>
            </select>
            <label class="control-label control-label-custom-legend" for="alias">Alias: 
            </label>
            <input id="baze_alias" name="alias" class="form-control query_input alias" type="text" value="">       
            <label class="control-label" for="alias2">Alias secondary: 
            </label>
            <input id="baze_alias2" name="alias2" class="form-control query_input alias2" type="text" value="">       


        </div>                            
        <div class="form-group form-group-custom">
            <label class="control-label control-label-custom-legend" for="down-sample">Down sample 
            </label>
            <input id="baze_down-sample-time" name="down-sample-time" class="form-control query_input down-sample-time" type="text">

            <label class="control-label control-label-custom-legend" for="">Aggregator: 
            </label>
            <!--<input id="baze_down-sample-aggregator" name="down-sample-aggregator" class="form-control query_input" type="text" value="avg">-->        
            <select id="baze_down-sample-aggregator" name="down-sample-aggregator" class="form-control query_input down-sample-aggregator">
                <option label="avg" value="avg">avg</option>
                <option label="count" value="count">count</option>
                <option label="dev" value="dev">dev</option>
                <option label="ep50r3" value="ep50r3">ep50r3</option>
                <option label="ep50r7" value="ep50r7">ep50r7</option>
                <option label="ep75r3" value="ep75r3">ep75r3</option>
                <option label="ep75r7" value="ep75r7">ep75r7</option>
                <option label="ep90r3" value="ep90r3">ep90r3</option>
                <option label="ep90r7" value="ep90r7">ep90r7</option>
                <option label="ep95r3" value="ep95r3">ep95r3</option>
                <option label="ep95r7" value="ep95r7">ep95r7</option>
                <option label="ep999r3" value="ep999r3">ep999r3</option>
                <option label="ep999r7" value="ep999r7">ep999r7</option>
                <option label="ep99r3" value="ep99r3">ep99r3</option>
                <option label="ep99r7" value="ep99r7">ep99r7</option>
                <option label="first" value="first">first</option>
                <option label="last" value="last">last</option>
                <option label="max" value="max">max</option>
                <option label="mimmax" value="mimmax">mimmax</option>
                <option label="mimmin" value="mimmin">mimmin</option>
                <option label="min" value="min">min</option>
                <option label="mult" value="mult">mult</option>
                <option label="none" value="none">none</option>
                <option label="p50" value="p50">p50</option>
                <option label="p75" value="p75">p75</option>
                <option label="p90" value="p90">p90</option>
                <option label="p95" value="p95">p95</option>
                <option label="p99" value="p99">p99</option>
                <option label="p999" value="p999">p999</option>
                <option label="sum" value="sum">sum</option>
                <option label="zimsum" value="zimsum">zimsum</option>
            </select>        

            <label class="control-label" >
                Disable downsampling
            </label>
            <div class="checkbox" style="display: inline-block;">
                <input type="checkbox" class="js-switch-small" chart_prop_key="downsampling" id="baze_disable_downsampling" name="disable_downsampling" /> 
            </div>        
        </div>                        
        <div class="form-group form-group-custom">
            <label class="control-label control-label-custom-legend" >
                Rate
            </label>
            <div class="checkbox" style="display: inline-block;">
                <input type="checkbox" class="js-switch-small" chart_prop_key="rate" id="baze_enable_rate" name="enable_rate" /> 
            </div>
        </div>
        <div class="btn btn-success Duplicateq btn-xs" role="button">Duplicate</div>
        <div class="btn btn-danger Removeq btn-xs" role="button">Remove</div>
    </form>
</div>