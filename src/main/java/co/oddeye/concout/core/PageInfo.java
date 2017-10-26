/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import java.io.Serializable;

/**
 *
 * @author vahan
 */
public class PageInfo implements Serializable{
    private static final long serialVersionUID = 465895478L;
    
    private final String page;
    private final String node;
    private final Long timestamp;

    public PageInfo(String _page, String _node, Long _timestamp) {
        page = _page;
        node = _node;
        timestamp = _timestamp;
    }

    @Override
    public String toString() {
        return node+":"+page+" "+( (System.currentTimeMillis()-timestamp)/1000)+"sec";
    }    
    
    /**
     * @return the page
     */
    public String getPage() {
        return page;
    }

    /**
     * @return the node
     */
    public String getNode() {
        return node;
    }

    /**
     * @return the timestamp
     */
    public Long getTimestamp() {
        return timestamp;
    }
}
