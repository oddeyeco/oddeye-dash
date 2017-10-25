/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeeyMetricMetaList;
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

    private final Map<String, Map<String, Integer>> TagsList = new HashMap<>();
    static final Logger LOGGER = LoggerFactory.getLogger(ConcoutMetricMetaList.class);
    private final Set<Integer> Taghashlist = new HashSet<>();

    private final Map<String, Integer> RegularNameMap = new HashMap<>();
    private final Map<String, Integer> SpecialNameMap = new HashMap<>();
    private final Map<String, Integer> NameMap = new HashMap<>();

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
        Integer count = 1;
        if (!this.containsKey(e.hashCode())) {
            getTaghashlist().add(e.getTags().hashCode());
            for (Entry<String, OddeyeTag> tag : e.getTags().entrySet()) {
                if (!tag.getKey().equals("UUID")) {
                    if (TagsList.containsKey(tag.getKey())) {
                        count = 1;
                        if (TagsList.get(tag.getKey()).containsKey(tag.getValue().getValue())) {
                            count = TagsList.get(tag.getKey()).get(tag.getValue().getValue()) + 1;
                        }
                        TagsList.get(tag.getKey()).put(tag.getValue().getValue(), count);
                    } else {
                        Map<String, Integer> keyset = new TreeMap<>();
                        keyset.put(tag.getValue().getValue(), 1);
                        TagsList.put(tag.getKey(), keyset);
                    }
                }
            }
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
            if (this.containsKey(e.hashCode())) {
                ConcoutMetricMetaList.LOGGER.info("OddeeyMetricMeta vs hashcode " + e.hashCode() + " Is exist ");
            }
            return super.add(e);
//            e.getTags().keySet().stream().filter((tagkey) -> (!Tagkeys.contains(tagkey))).forEach(Tagkeys::add);
//
//            e.getTags().entrySet().stream().filter((tag) -> (!Tagkeyv.contains(tag.getValue().getValue()))).forEach((Map.Entry<String, OddeyeTag> tag) -> {
//                Tagkeyv.add(tag.getValue().getValue());
//            });
//
//            return this.put(e.hashCode(), e);
        } else {
            return this.replace(e.hashCode(), e);
        }
    }

    public OddeeyMetricMeta remove(Integer key) {
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

        for (Entry<String, OddeyeTag> tag : obg.getTags().entrySet()) {
            if (!tag.getKey().equals("UUID")) {
                if (TagsList.containsKey(tag.getKey())) {
                    if (TagsList.get(tag.getKey()).containsKey(tag.getValue().getValue())) {
                        count = 0;
                        if (TagsList.get(tag.getKey()).containsKey(tag.getValue().getValue())) {
                            count = TagsList.get(tag.getKey()).get(tag.getValue().getValue()) - 1;
                        }

                        if (count == 0) {
                            TagsList.get(tag.getKey()).remove(tag.getValue().getValue());
                        } else {
                            TagsList.get(tag.getKey()).put(tag.getValue().getValue(), count);
                        }
                    }

                    if (TagsList.get(tag.getKey()).size() == 0) {
                        TagsList.remove(tag.getKey());
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
        for (Map.Entry<Integer, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
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

    public ConcoutMetricMetaList getbyTags(Map<String, String> tagsMap, String filter) {
        ConcoutMetricMetaList SortbyName = new ConcoutMetricMetaList();
        Pattern rm = Pattern.compile(filter);
        for (Map.Entry<Integer, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
            try {
                boolean sucsses = true;
                for (Entry<String, String> tag : tagsMap.entrySet()) {
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

    public ConcoutMetricMetaList getbyName(String name) {
        ConcoutMetricMetaList SortbyName = new ConcoutMetricMetaList();
        for (Map.Entry<Integer, OddeeyMetricMeta> MetricMeta : this.entrySet()) {
            if (MetricMeta.getValue().getName().equals(name)) {
                SortbyName.add(MetricMeta.getValue());
            }

        }
//        SortbyName.sort(OddeeyMetricMeta::compareTo);
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
}
