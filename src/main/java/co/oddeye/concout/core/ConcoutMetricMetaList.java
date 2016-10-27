/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeeyMetricMetaList;
import co.oddeye.core.OddeyeTag;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.Consumer;
import static javafx.scene.input.KeyCode.V;
import net.opentsdb.core.TSDB;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author vahan
 */
public class ConcoutMetricMetaList extends OddeeyMetricMetaList {
    
    private final Map<String, Set<String>> TagsList = new HashMap<>();   
    static final Logger LOGGER = LoggerFactory.getLogger(ConcoutMetricMetaList.class);

    public ConcoutMetricMetaList() {        
        super();
    }

    public ConcoutMetricMetaList(TSDB tsdb, byte[] bytes) {
        super(tsdb,bytes);
    }
        

    
    public OddeeyMetricMeta add(OddeeyMetricMeta e) {
        e.getTags().entrySet().stream().forEach((Entry<String, OddeyeTag> tag) -> {
            if (!tag.getKey().equals("UUID")) {
                if (getTagsList().containsKey(tag.getKey())) {
                    if (!TagsList.get(tag.getKey()).contains(tag.getValue().getValue())) {
                        getTagsList().get(tag.getKey()).add(tag.getValue().getValue());
                    }
                } else {
                    Set<String> keyset = new TreeSet<>();
                    keyset.add(tag.getValue().getValue());
                    getTagsList().put(tag.getKey(), keyset);
                }
            }
        });
        
        if (this.containsKey(e.hashCode())) {
            ConcoutMetricMetaList.LOGGER.warn("OddeeyMetricMeta vs hashcode " + e.hashCode() + " Is exist ");            
        }

        e.getTags().keySet().stream().filter((tagkey) -> (!Tagkeys.contains(tagkey))).forEach(Tagkeys::add);

        e.getTags().entrySet().stream().filter((tag) -> (!Tagkeyv.contains(tag.getValue().getValue()))).forEach((Map.Entry<String, OddeyeTag> tag) -> {
            Tagkeyv.add(tag.getValue().getValue());
        });

        return this.put(e.hashCode(), e);
    }
    
    public ArrayList<OddeeyMetricMeta> getbyTag(String tagK, String tagV) throws Exception {
        ArrayList<OddeeyMetricMeta> SortbyName = new ArrayList<>();                
        for (Map.Entry<Integer, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
            if (MetricMeta.getValue().getTags().containsKey(tagK)) {
                if (MetricMeta.getValue().getTags().get(tagK).getValue().equals(tagV)) {
                    SortbyName.add(MetricMeta.getValue());
                }
            }            
        }        
        SortbyName.sort((OddeeyMetricMeta o1, OddeeyMetricMeta o2) -> o1.compareTo(o2));        
        return SortbyName;
    }

    /**
     * @return the TagsList
     */
    public Map<String, Set<String>> getTagsList() {
        return TagsList;
    }
    
    
}
