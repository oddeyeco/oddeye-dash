/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import java.util.ArrayList;

/**
 *
 * @author vahan
 */
public class MetaTags {
    private String name;
    private final ArrayList<String> datakeys;

    public MetaTags() {
        this.datakeys = new ArrayList();
    }    

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the datakeys
     */
    public ArrayList<String> getDatakeys() {
        return datakeys;
    }
 
    
    public void addDatakeys(String datakey) {
        this.datakeys.add(datakey);        
    }    
}
