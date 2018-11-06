/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.annotation.HbaseColumn;
import static co.oddeye.concout.model.DashboardTemplate.LOGGER;
import co.oddeye.core.globalFunctions;
import java.io.Serializable;
import java.util.List;
import java.util.UUID;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * @author vahan
 */
public class WhitelabelModel implements Serializable,IHbaseModel {

    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(WhitelabelModel.class);

    @HbaseColumn(qualifier = "key", family = "info")
    private byte[] key;
    @HbaseColumn(qualifier = "url", family = "info")
    private String url;
    @HbaseColumn(qualifier = "logo", family = "info")
    private String logofilename;
    private MultipartFile logo;
    @HbaseColumn(qualifier = "introbkg", family = "info")
    private String introbkgfilename;
    private MultipartFile introbkg;
    @HbaseColumn(qualifier = "css", family = "info")
    private String cssfilename;
    private MultipartFile css;
    @HbaseColumn(qualifier = "userpayment", family = "info")
    private Boolean userpayment;
    @HbaseColumn(qualifier = "owner", family = "info", identfield="id")
    private OddeyeUserModel owner;
    private List<OddeyeUserModel> clients;
    private String fullfileName;

    public WhitelabelModel() {
        key = UUID.randomUUID().toString().getBytes();
    }

    /**
     * @return the key
     */
    public byte[] getKey() {
        return key;
    }

    /**
     * @param key the key to set
     */
    public void setKey(byte key[]) {
        this.key = key;
    }

    public String getId() {
        return Hex.encodeHexString(key);
    }

    public void setId(String id) {
        try {
            this.key = Hex.decodeHex(id.toCharArray());
        } catch (DecoderException ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
    }

    /**
     * @return the url
     */
    public String getUrl() {
        return url;
    }

    /**
     * @param url the url to set
     */
    public void setUrl(String url) {
        this.url = url;
    }

    /**
     * @return the userpayment
     */
    public Boolean getUserpayment() {
        return userpayment;
    }

    /**
     * @param userpayment the userpayment to set
     */
    public void setUserpayment(Boolean userpayment) {
        this.userpayment = userpayment;
    }

    /**
     * @return the owner
     */
    public OddeyeUserModel getOwner() {
        return owner;
    }

    /**
     * @param owner the owner to set
     */
    public void setOwner(OddeyeUserModel owner) {
        this.owner = owner;
    }

    /**
     * @return the clients
     */
    public List<OddeyeUserModel> getClients() {
        return clients;
    }

    /**
     * @param clients the clients to set
     */
    public void setClients(List<OddeyeUserModel> clients) {
        this.clients = clients;
    }

    /**
     * @return the logofilename
     */
    public String getLogofilename() {
        return logofilename;
    }

    /**
     * @param logofilename the logofilename to set
     */
    public void setLogofilename(String logofilename) {
        this.logofilename = logofilename;
    }

    /**
     * @return the logo
     */
    public MultipartFile getLogo() {
        return logo;
    }

    /**
     * @param logo the logo to set
     */
    public void setLogo(MultipartFile logo) {
        this.logo = logo;
    }

    /**
     * @return the introbkgfilename
     */
    public String getIntrobkgfilename() {
        return introbkgfilename;
    }

    /**
     * @param introbkgfilename the introbkgfilename to set
     */
    public void setIntrobkgfilename(String introbkgfilename) {
        this.introbkgfilename = introbkgfilename;
    }

    /**
     * @return the introbkg
     */
    public MultipartFile getIntrobkg() {
        return introbkg;
    }

    /**
     * @param introbkg the introbkg to set
     */
    public void setIntrobkg(MultipartFile introbkg) {
        this.introbkg = introbkg;
    }

    /**
     * @return the cssfilename
     */
    public String getCssfilename() {
        return cssfilename;
    }

    /**
     * @param cssfilename the cssfilename to set
     */
    public void setCssfilename(String cssfilename) {
        this.cssfilename = cssfilename;
    }

    /**
     * @return the css
     */
    public MultipartFile getCss() {
        return css;
    }

    /**
     * @param css the css to set
     */
    public void setCss(MultipartFile css) {
        this.css = css;
    }
    
    public String getFullfileName(String name) {
        return "/WEB-INF/assets/uploads/"+this.getOwner().getId().toString()+"/"+this.getUrl()+"/"+name;
    }    

    /**
     * @return the fullfileName
     */
    public String getFullfileName() {
        return "/assets/uploads/"+this.getOwner().getId().toString()+"/"+this.getUrl()+"/";
    }

    /**
     * @param fullfileName the fullfileName to set
     */
    public void setFullfileName(String fullfileName) {
        this.fullfileName = fullfileName;
    }
}
