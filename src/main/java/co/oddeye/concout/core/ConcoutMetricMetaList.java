/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.core.OddeeyMetricMeta;
import co.oddeye.core.OddeeyMetricMetaList;
import co.oddeye.core.OddeyeTag;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.Consumer;

/**
 *
 * @author vahan
 */
public class ConcoutMetricMetaList extends OddeeyMetricMetaList {

    private final Map<String, Set<String>> TagsList = new HashMap<>();

    @Override
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

        return super.add(e);
    }

    /**
     * @return the TagsList
     */
    public Map<String, Set<String>> getTagsList() {
        return TagsList;
    }
}
