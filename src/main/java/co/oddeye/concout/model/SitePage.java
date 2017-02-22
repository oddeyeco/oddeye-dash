/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import javax.persistence.Column;

/**
 *
 * @author vahan
 */
public class SitePage {
    private String title;
    private String fulltitle;
//    private boolean isTActive;   
    private String description;
    private String keywords;
    private String pagecaption;
    @Column(unique = true)
    private String sysname;
    private String controller;
    private String function;
    private String exiernalurl;
    @Column(unique = true)
    private String slug;
    private String h1image;
    private int sortorder;
    private boolean external;
    private boolean haspaging;
    private boolean isActive;
    private boolean isinMenu;
//    private $isEditable;
//    private $root;
//    private $lvl;
//    private $childrens;
    private SitePage parent;

    /**
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * @param title the title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * @return the fulltitle
     */
    public String getFulltitle() {
        return fulltitle;
    }

    /**
     * @param fulltitle the fulltitle to set
     */
    public void setFulltitle(String fulltitle) {
        this.fulltitle = fulltitle;
    }

    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return the keywords
     */
    public String getKeywords() {
        return keywords;
    }

    /**
     * @param keywords the keywords to set
     */
    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    /**
     * @return the pagecaption
     */
    public String getPagecaption() {
        return pagecaption;
    }

    /**
     * @param pagecaption the pagecaption to set
     */
    public void setPagecaption(String pagecaption) {
        this.pagecaption = pagecaption;
    }

    /**
     * @return the sysname
     */
    public String getSysname() {
        return sysname;
    }

    /**
     * @param sysname the sysname to set
     */
    public void setSysname(String sysname) {
        this.sysname = sysname;
    }

    /**
     * @return the controller
     */
    public String getController() {
        return controller;
    }

    /**
     * @param controller the controller to set
     */
    public void setController(String controller) {
        this.controller = controller;
    }

    /**
     * @return the function
     */
    public String getFunction() {
        return function;
    }

    /**
     * @param function the function to set
     */
    public void setFunction(String function) {
        this.function = function;
    }

    /**
     * @return the exiernalurl
     */
    public String getExiernalurl() {
        return exiernalurl;
    }

    /**
     * @param exiernalurl the exiernalurl to set
     */
    public void setExiernalurl(String exiernalurl) {
        this.exiernalurl = exiernalurl;
    }

    /**
     * @return the slug
     */
    public String getSlug() {
        return slug;
    }

    /**
     * @param slug the slug to set
     */
    public void setSlug(String slug) {
        this.slug = slug;
    }

    /**
     * @return the h1image
     */
    public String getH1image() {
        return h1image;
    }

    /**
     * @param h1image the h1image to set
     */
    public void setH1image(String h1image) {
        this.h1image = h1image;
    }

    /**
     * @return the sortorder
     */
    public int getSortorder() {
        return sortorder;
    }

    /**
     * @param sortorder the sortorder to set
     */
    public void setSortorder(int sortorder) {
        this.sortorder = sortorder;
    }

    /**
     * @return the external
     */
    public boolean isExternal() {
        return external;
    }

    /**
     * @param external the external to set
     */
    public void setExternal(boolean external) {
        this.external = external;
    }

    /**
     * @return the haspaging
     */
    public boolean isHaspaging() {
        return haspaging;
    }

    /**
     * @param haspaging the haspaging to set
     */
    public void setHaspaging(boolean haspaging) {
        this.haspaging = haspaging;
    }

    /**
     * @return the isActive
     */
    public boolean isIsActive() {
        return isActive;
    }

    /**
     * @param isActive the isActive to set
     */
    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    /**
     * @return the isinMenu
     */
    public boolean isIsinMenu() {
        return isinMenu;
    }

    /**
     * @param isinMenu the isinMenu to set
     */
    public void setIsinMenu(boolean isinMenu) {
        this.isinMenu = isinMenu;
    }

    /**
     * @return the parent
     */
    public SitePage getParent() {
        return parent;
    }

    /**
     * @param parent the parent to set
     */
    public void setParent(SitePage parent) {
        this.parent = parent;
    }
}
