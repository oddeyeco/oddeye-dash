/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeeyMetricMetaList;
import co.oddeye.core.OddeeyMetricTypesEnum;
import co.oddeye.core.OddeyeTag;
import co.oddeye.core.globalFunctions;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.opentsdb.core.TSDB;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author vahan
 */
public class ConcoutMetricMetaList extends OddeeyMetricMetaList {

    private static final long serialVersionUID = 465895478L;
    static final Logger LOGGER = LoggerFactory.getLogger(ConcoutMetricMetaList.class);

    private final Map<String, Map<String, Integer>> TagsList = new HashMap<>();
    private final Set<Integer> Taghashlist = new HashSet<>();
    private final Map<String, Integer> RegularNameMap = new HashMap<>();
    private final Map<String, Integer> SpecialNameMap = new HashMap<>();
    private final Map<String, Integer> NameMap = new HashMap<>();
    private final Map<OddeeyMetricTypesEnum, Integer> TypeMap = new HashMap<>();

    public ConcoutMetricMetaList() {
        super();
    }

    public ConcoutMetricMetaList(TSDB tsdb, byte[] bytes) {
        super(tsdb, bytes);
    }

    public void putAll(ConcoutMetricMetaList m) {
        m.entrySet().forEach((e) -> {
            add(e.getValue());
        });
    }

    @Override
    public OddeeyMetricMeta add(OddeeyMetricMeta e) {
        if (!this.containsKey(e.sha256Code())) {
            OddeeyMetricMeta result = super.add(e);
            updateIndex(e);
            return result;
        } else {
            return this.replace(e.sha256Code(), e);
        }
    }

    public OddeeyMetricMeta remove(String key) {
        if (!this.containsKey(key)) {
            return null;
        }
        final OddeeyMetricMeta obg = this.get(key);
        Integer count = 0;
        if (NameMap.containsKey(obg.getName())) {
            count = NameMap.get(obg.getName()) - 1;
        }
        if (count == 0) {
            NameMap.remove(obg.getName());
        } else {
            NameMap.put(obg.getName(), count);
        }

        count = 0;
        if (SpecialNameMap.containsKey(obg.getName())) {
            count = SpecialNameMap.get(obg.getName()) - 1;
        }
        if (count == 0) {
            SpecialNameMap.remove(obg.getName());
        } else {
            SpecialNameMap.put(obg.getName(), count);
        }

        count = 0;
        if (RegularNameMap.containsKey(obg.getName())) {
            count = RegularNameMap.get(obg.getName()) - 1;
        }
        if (count == 0) {
            RegularNameMap.remove(obg.getName());
        } else {
            RegularNameMap.put(obg.getName(), count);
        }

        for (Map.Entry<String, OddeyeTag> tag : obg.getTags().entrySet()) {
            if (!tag.getKey().equals("UUID")) {
                if (getTagsList().containsKey(tag.getKey())) {
                    if (getTagsList().get(tag.getKey()).containsKey(tag.getValue().getValue())) {
                        count = 0;
                        if (getTagsList().get(tag.getKey()).containsKey(tag.getValue().getValue())) {
                            count = getTagsList().get(tag.getKey()).get(tag.getValue().getValue()) - 1;
                        }

                        if (count == 0) {
                            getTagsList().get(tag.getKey()).remove(tag.getValue().getValue());
                        } else {
                            getTagsList().get(tag.getKey()).put(tag.getValue().getValue(), count);
                        }
                    }

                    if (getTagsList().get(tag.getKey()).isEmpty()) {
                        getTagsList().remove(tag.getKey());
                    }
                }
            }
        }

        return super.remove(key);
    }

    public List<String> GetSortedNames() {
        List<String> Name_list = new ArrayList<>(NameMap.keySet());
        Collections.sort(Name_list);
        return Name_list;
    }

    public Set<String> GetNames() {
        return NameMap.keySet();
    }

    public ConcoutMetricMetaList getbyTag(String tagK, String tagV) throws Exception {
        ConcoutMetricMetaList SortbyName = new ConcoutMetricMetaList();
        for (Map.Entry<String, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
            if (MetricMeta.getValue().getTags().containsKey(tagK)) {
                if (MetricMeta.getValue().getTags().get(tagK).getValue().equals(tagV)) {
                    SortbyName.add(MetricMeta.getValue());
                }
            }
        }
//        SortbyName.sort(OddeeyMetricMeta::compareTo);
        return SortbyName;
    }

    /**
     * @return the TagsList
     */
    public Map<String, Map<String, Integer>> getTagsList() {
        return TagsList;
    }

    public Map<String, Map<String, Integer>> getTagsListSorted() {
        return new TreeMap<String, Map<String, Integer>>(TagsList);
    }

    public List<String> getTagsKeysSort() {
        List<String> keys = new ArrayList<>(TagsList.keySet());
        Collections.sort(keys);
        return keys;
    }

    public ConcoutMetricMetaList getbyTags(Map<String, String> tagsMap, String filter) {
        ConcoutMetricMetaList SortbyName = new ConcoutMetricMetaList();
        Pattern rm = Pattern.compile(filter);
        for (Map.Entry<String, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
            try {
                boolean sucsses = true;
                for (Map.Entry<String, String> tag : tagsMap.entrySet()) {
                    if (!tag.getValue().equals("*")) {
                        Pattern r = Pattern.compile(tag.getValue());
                        Matcher m = r.matcher(MetricMeta.getValue().getTags().get(tag.getKey()).getValue());
                        if (!m.matches()) {
                            sucsses = false;
                        }
                    }
                }
                if (sucsses) {
                    Matcher m = rm.matcher(MetricMeta.getValue().getName());
                    if (m.matches()) {
                        SortbyName.add(MetricMeta.getValue());
                    }
                }
            } catch (Exception e) {
                LOGGER.warn(globalFunctions.stackTrace(e));
            }
        }
//        SortbyName.sort((OddeeyMetricMeta o1, OddeeyMetricMeta o2) -> o1.compareTo(o2));
        return SortbyName;
    }

    

    public ConcoutMetricMetaList getbyType(String type) {
        Integer tp = Integer.parseInt(type);
        ConcoutMetricMetaList SortbyName = new ConcoutMetricMetaList();
        for (Map.Entry<String, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
            if (OddeeyMetricTypesEnum.values()[tp].getShort() == MetricMeta.getValue().getType().getShort() ) {
                SortbyName.add(MetricMeta.getValue());
            }

        }
        return SortbyName;
    }            
            
    public ConcoutMetricMetaList getbyName(String name) {
        ConcoutMetricMetaList SortbyName = new ConcoutMetricMetaList();
        for (Map.Entry<String, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
            if (MetricMeta.getValue().getName().equals(name)) {
                SortbyName.add(MetricMeta.getValue());
            }

        }
        return SortbyName;
    }

    /**
     * @return the Taghashlist
     */
    public Set<Integer> getTaghashlist() {
        return Taghashlist;
    }

    /**
     * @return the RegularNamelist
     */
    public Set<String> getRegularNamelist() {
        return RegularNameMap.keySet();
    }

    public List<String> getRegularNamelistSorted() {
        List<String> list = new ArrayList<>(RegularNameMap.keySet());
        Collections.sort(list);
        return list;
    }

    /**
     * @return the SpecialNamelist
     */
    public Set<String> getSpecialNamelist() {
        return SpecialNameMap.keySet();
    }

    public List<String> getSpecialNameSorted() {
        List<String> list = new ArrayList<>(SpecialNameMap.keySet());
        Collections.sort(list);
        return list;
    }

    public Map<String, Integer> getSpecialNameMapSorted() {
//        List<String> list = new ArrayList<>(SpecialNameMap.keySet());
//        Collections.sort(list);
        return new TreeMap<>(SpecialNameMap);
    }

    public Map<String, Integer> getRegularNameMapSorted() {
//        List<String> list = new ArrayList<>(SpecialNameMap.keySet());
//        Collections.sort(list);
        return new TreeMap<>(RegularNameMap);
    }

    //Gidem lav chi
    public void updateIndexes() {
        getTagsList().clear();
        NameMap.clear();
        getTypeMap().clear();
        SpecialNameMap.clear();
        RegularNameMap.clear();
        this.entrySet().forEach((e) -> {
            updateIndex(e.getValue());
        });
    }

    public void updateIndex(OddeeyMetricMeta e) {
        Integer count;
        getTaghashlist().add(e.getTags().hashCode());
        for (Map.Entry<String, OddeyeTag> tag : e.getTags().entrySet()) {
            try {
                if (!tag.getKey().equals("UUID")) {
                    if (getTagsList().containsKey(tag.getKey())) {
                        count = 1;
                        if (getTagsList().get(tag.getKey()).containsKey(tag.getValue().getValue())) {
                            count = getTagsList().get(tag.getKey()).get(tag.getValue().getValue()) + 1;
                        }
                        getTagsList().get(tag.getKey()).put(tag.getValue().getValue(), count);
                    } else {
                        Map<String, Integer> keyset = new TreeMap<>(); //TreeMap<>();
                        keyset.put(tag.getValue().getValue(), 1);
                        getTagsList().put(tag.getKey(), keyset);
                    }
                }
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
                LOGGER.warn("Add metric " + e.sha256Code()+ " Error for tag \"" + tag.getKey() + "\" vs tags " + e.getTags());
            }

        }

        count = 1;
        if (getTypeMap().containsKey(e.getType())) {
            count = getTypeMap().get(e.getType()) + 1;
        }
        getTypeMap().put(e.getType(), count);

        count = 1;
        if (NameMap.containsKey(e.getName())) {
            count = NameMap.get(e.getName()) + 1;
        }
        NameMap.put(e.getName(), count);

        if (e.isSpecial()) {
            count = 1;
            if (SpecialNameMap.containsKey(e.getName())) {
                count = SpecialNameMap.get(e.getName()) + 1;
            }
            SpecialNameMap.put(e.getName(), count);
        } else {
            count = 1;
            if (RegularNameMap.containsKey(e.getName())) {
                count = RegularNameMap.get(e.getName()) + 1;
            }
            RegularNameMap.put(e.getName(), count);
        }
    }

    /**
     * @return the TypeMap
     */
    public Map<OddeeyMetricTypesEnum, Integer> getTypeMap() {
        return TypeMap;
    }
    
    public Map<OddeeyMetricTypesEnum, Integer> getTypeMapSorted() {
        return new TreeMap<>(TypeMap);
    }    
}
