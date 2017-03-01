/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.annotation.HbaseColumn;
import java.util.UUID;

/**
 *
 * @author vahan
 */
public class SitePage {
    @HbaseColumn(isKey = true)
    private UUID id;    
    @HbaseColumn(qualifier = "title", family = "d")
    private String title;
    @HbaseColumn(qualifier = "fulltitle", family = "d")
    private String fulltitle;
//    private boolean isTActive;   
    @HbaseColumn(qualifier = "description", family = "d")
    private String description;
    @HbaseColumn(qualifier = "keywords", family = "d")
    private String keywords;
    @HbaseColumn(qualifier = "pagecaption", family = "d")
    private String pagecaption;
    @HbaseColumn(qualifier = "sysname", family = "d")
    private String sysname;
    @HbaseColumn(qualifier = "controller", family = "d")
    private String controller;
    @HbaseColumn(qualifier = "function", family = "d")
    private String function;    
    @HbaseColumn(qualifier = "content", family = "d")
    private String content;    
    @HbaseColumn(qualifier = "exiernalurl", family = "d")
    private String exiernalurl;
    @HbaseColumn(qualifier = "slug", family = "d")
    private String slug;
    @HbaseColumn(qualifier = "h1image", family = "d")
    private String h1image;
    @HbaseColumn(qualifier = "sortorder", family = "d")
    private int sortorder;
    @HbaseColumn(qualifier = "external", family = "d")
    private boolean external;
    @HbaseColumn(qualifier = "haspaging", family = "d")
    private boolean haspaging;
    @HbaseColumn(qualifier = "isActive", family = "d")
    private boolean isActive;
    @HbaseColumn(qualifier = "isinMenu", family = "d")
    private boolean isinMenu;
//    private $isEditable;
//    private $root;
//    private $lvl;
//    private $childrens;
    @HbaseColumn(qualifier = "parent", family = "d")
    private SitePage parent;

     public SitePage()
     {
         id = UUID.randomUUID();
     }
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

    /**
     * @return the id
     */
    public UUID getId() {
        return id;
    }

    /**
     * @param id    
     */
    public void setId(UUID id) {
        this.id = id;
    }

    /**
     * @return the content
     */
    public String getContent() {
        return content;
    }

    /**
     * @param content the content to set
     */
    public void setContent(String content) {
        this.content = content;
    }
}
