/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.annotation.HbaseColumn;
import co.oddeye.concout.core.TemplateType;
import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.Bytes;
import org.hbase.async.KeyValue;
import org.slf4j.LoggerFactory;

/**
 *
 * @author vahan
 */
public class DashboardTemplate implements Comparable<DashboardTemplate> {

    @HbaseColumn(isKey = true)
    private byte[] key;
    @HbaseColumn(qualifier = "name", family = "d")
    private String name;
    @HbaseColumn(qualifier = "description", family = "d")
    private String description;
    @HbaseColumn(qualifier = "admindescription", family = "d")
    private String admindescription;
    @HbaseColumn(qualifier = "infojson", family = "d")
    private JsonObject infojson;
    @HbaseColumn(qualifier = "type", family = "d")
    private TemplateType type;
    @HbaseColumn(qualifier = "user", family = "d", identfield = "id")
    private OddeyeUserModel user;
    @HbaseColumn(qualifier = "Recomended", family = "d")
    private boolean Recomended;
    @HbaseColumn(qualifier = "version", family = "d")
    private String version;

    private long timestamp;

    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(DashboardTemplate.class);

    public DashboardTemplate() {

    }

    public DashboardTemplate(ArrayList<KeyValue> row, HbaseUserDao Userdao) {
        key = row.get(0).key();

        for (KeyValue property : row) {
            timestamp = property.timestamp();
            if (Arrays.equals(property.qualifier(), "name".getBytes())) {
                this.name = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "description".getBytes())) {
                this.description = new String(property.value());
            }
            if (Arrays.equals(property.qualifier(), "infojson".getBytes())) {
                this.infojson = (JsonObject) globalFunctions.getJsonParser().parse(new String(property.value()));
            }

            if (Arrays.equals(property.qualifier(), "Recomended".getBytes())) {
                if (property.value().length == 1) {
                    this.Recomended = property.value()[0] != (byte) 0;
                }
                if (property.value().length == 4) {
                    this.Recomended = Bytes.getInt(property.value()) != 0;
                }
            }

            if (Arrays.equals(property.qualifier(), "type".getBytes())) {
                this.type = TemplateType.valueOf(new String(property.value()));
            }

            if (Arrays.equals(property.qualifier(), "user".getBytes())) {
                this.user = Userdao.getUserByUUID(UUID.fromString(new String(property.value())));
            }
        }

    }

    private JsonObject clearjson(JsonObject json) {
        return clearjson(json, "");
    }

    private JsonObject clearjson(JsonObject json, String parentkey) {
        Iterator<Map.Entry<String, JsonElement>> elementIterator = json.entrySet().iterator();
        while (elementIterator.hasNext()) {

            Map.Entry<String, JsonElement> element = elementIterator.next();
            if (element.getValue().isJsonObject()) {
                clearjson(element.getValue().getAsJsonObject());
            }
            if (element.getValue().isJsonArray()) {
                for (JsonElement elem : element.getValue().getAsJsonArray()) {
                    if (elem.isJsonObject()) {
                        clearjson(elem.getAsJsonObject(), element.getKey());
                    }
                }
            }
            if (element.getKey().equals("data")) {
//                json.remove(element.getKey());
                elementIterator.remove();
            }
            if ((element.getKey().equals("name")) && (parentkey.equals("series"))) {
//                json.remove(element.getKey());
                elementIterator.remove();
            }
        }
        return json;
    }

    public DashboardTemplate(String _name, String json, OddeyeUserModel user, TemplateType _type) {
        this(_name, globalFunctions.getJsonParser().parse(json).getAsJsonObject(), user, _type);
    }

    public DashboardTemplate(String _name, JsonObject json, OddeyeUserModel _user, TemplateType _type) {
        infojson = clearjson(json);
        user = _user;
        name = _name;
        key = ArrayUtils.addAll(user.getId().toString().getBytes(), name.getBytes());
        type = _type;
        Recomended = false;
    }

    /**
     * @return the key
     */
    public byte[] getKey() {
        return key;
    }

    public String getStKey() {
        return Hex.encodeHexString(key);
    }

    public String getId() {
        return Hex.encodeHexString(key);
    }

    /**
     * @param key the key to set
     */
    public void setKey(byte[] key) {
        this.key = key;
    }

    public void setId(String id) {
        try {
            this.key = Hex.decodeHex(id.toCharArray());
        } catch (DecoderException ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
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
     * @return the admindescription
     */
    public String getAdmindescription() {
        return admindescription;
    }

    /**
     * @param admindescription the admindescription to set
     */
    public void setAdmindescription(String admindescription) {
        this.admindescription = admindescription;
    }

    /**
     * @return the infojson
     */
    public JsonObject getInfojson() {
        return infojson;
    }

    /**
     * @param infojson the infojson to set
     */
    public void setInfojson(JsonObject infojson) {
        this.infojson = infojson;
    }

    public void setInfojson(String sjson) {
        this.infojson = globalFunctions.getJsonParser().parse(sjson).getAsJsonObject();
    }

    /**
     * @return the type
     */
    public TemplateType getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(TemplateType type) {
        this.type = type;
    }

    /**
     * @return the user
     */
    public OddeyeUserModel getUser() {
        return user;
    }

    /**
     * @param user the user to set
     */
    public void setUser(OddeyeUserModel user) {
        this.user = user;
    }

    /**
     * @return the Recomended
     */
    public boolean isRecomended() {
        return Recomended;
    }

    /**
     * @param Recomended the Recomended to set
     */
    public void setRecomended(boolean Recomended) {
        this.Recomended = Recomended;
    }

    /**
     * @return the version
     */
    public String getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(String version) {
        this.version = version;
    }

    /**
     * @return the timestamp
     */
    public long getTimestamp() {
        return timestamp;
    }

    public Date getTime() {
        return new java.util.Date(timestamp);
    }

    public void updateKey() {
        key = ArrayUtils.addAll(user.getId().toString().getBytes(), name.getBytes());
    }

    public void FillCompare(DashboardTemplate o) {
        user = o.getUser();
        type = o.getType();
        timestamp = o.getTimestamp();
        infojson = o.getInfojson();
    }

    @Override
    public int compareTo(DashboardTemplate o) {
        int result = (timestamp < o.getTimestamp() ? -1 : (timestamp == o.getTimestamp() ? 0 : 1));
        if (result == 0)
        {
            result = getName().compareTo(o.getName());
        }
        return result;
    }

}
