/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.admincontrollers;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 * @author vahan
 */
abstract class GRUDControler {
    private final Map<String,Object> ViewConfig = new LinkedHashMap<>();
    private final Map<String,Object> EditConfig = new LinkedHashMap<>();
    
    /**
     * @return the ViewConfig
     */
    final protected Map<String,Object> getViewConfig() {
        return ViewConfig;
    }

    /**
     * @return the EditConfig
     */
    final protected Map<String,Object> getEditConfig() {
        return EditConfig;
    }
    
    final protected GRUDControler AddViewConfig (final String key,  final HashMap<String, Object> config)
    {
        ViewConfig.put(key, config);
        return this;
    }
    
    final protected GRUDControler AddEditConfig (final String key,  final HashMap<String, Object> config)
    {
        EditConfig.put(key, config);
        return this;
    }    
 
}
