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
    private String logo;
    @HbaseColumn(qualifier = "introbkg", family = "info")
    private String introbkg;
    @HbaseColumn(qualifier = "css", family = "info")
    private String css;
    @HbaseColumn(qualifier = "userpayment", family = "info")
    private Boolean userpayment;
    @HbaseColumn(qualifier = "owner", family = "info", identfield="id")
    private OddeyeUserModel owner;
    private List<OddeyeUserModel> clients;

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
     * @return the logo
     */
    public String getLogo() {
        return logo;
    }

    /**
     * @param logo the logo to set
     */
    public void setLogo(String logo) {
        this.logo = logo;
    }

    /**
     * @return the introbkg
     */
    public String getIntrobkg() {
        return introbkg;
    }

    /**
     * @param introbkg the introbkg to set
     */
    public void setIntrobkg(String introbkg) {
        this.introbkg = introbkg;
    }

    /**
     * @return the css
     */
    public String getCss() {
        return css;
    }

    /**
     * @param css the css to set
     */
    public void setCss(String css) {
        this.css = css;
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
}
