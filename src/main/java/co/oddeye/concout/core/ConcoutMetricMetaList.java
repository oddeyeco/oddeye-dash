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
import java.util.TreeSet;
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

    private final Map<String, Set<String>> TagsList = new HashMap<>();
    static final Logger LOGGER = LoggerFactory.getLogger(ConcoutMetricMetaList.class);
    private final Set<String> Namelist = new HashSet<>();
    private final Set<String> RegularNamelist = new HashSet<>();
    private final Set<String> SpecialNamelist = new HashSet<>();
    private final Set<Integer> Taghashlist = new HashSet<>();

    public ConcoutMetricMetaList() {
        super();
    }

    public ConcoutMetricMetaList(TSDB tsdb, byte[] bytes) {
        super(tsdb, bytes);
    }

    public OddeeyMetricMeta add(OddeeyMetricMeta e) {
        getTaghashlist().add(e.getTags().hashCode());
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

        Namelist.add(e.getName());
        if (e.isSpecial()) {
            getSpecialNamelist().add(e.getName());
        } else {
            getRegularNamelist().add(e.getName());
        }
        if (this.containsKey(e.hashCode())) {
            ConcoutMetricMetaList.LOGGER.info("OddeeyMetricMeta vs hashcode " + e.hashCode() + " Is exist ");
        }

        e.getTags().keySet().stream().filter((tagkey) -> (!Tagkeys.contains(tagkey))).forEach(Tagkeys::add);

        e.getTags().entrySet().stream().filter((tag) -> (!Tagkeyv.contains(tag.getValue().getValue()))).forEach((Map.Entry<String, OddeyeTag> tag) -> {
            Tagkeyv.add(tag.getValue().getValue());
        });

        return this.put(e.hashCode(), e);
    }

    public List<String> GetSortedNames() {
        List<String> Name_list = new ArrayList<>(Namelist);
        Collections.sort(Name_list);
        return Name_list;
    }

    public Set<String> GetNames() {
        return Namelist;
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
    public Map<String, Set<String>> getTagsList() {
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
        return RegularNamelist;
    }

    public List<String> getRegularNamelistSorted() {
        List<String> list = new ArrayList<>(RegularNamelist);
        Collections.sort(list);
        return list;
    }

    /**
     * @return the SpecialNamelist
     */
    public Set<String> getSpecialNamelist() {
        return SpecialNamelist;
    }

    public List<String> getSpecialNameSorted() {
        List<String> list = new ArrayList<>(SpecialNamelist);
        Collections.sort(list);
        return list;
    }
}
