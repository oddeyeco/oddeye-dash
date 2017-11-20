/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.core.OddeeyMetric;
import co.oddeye.core.globalFunctions;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 *
 * @author vahan
 */
@Component
public class CoconutParseMetric {

    private Date date;
    private final JsonParser parser;
    public static final Logger LOGGER = LoggerFactory.getLogger(CoconutParseMetric.class);

    public CoconutParseMetric() {
        parser = new JsonParser();
    }

    protected TreeMap<Integer, OddeeyMetric> prepareJsonObjectV2(JsonElement json, String msg) {
        JsonObject jsonResult = json.getAsJsonObject().get("data").getAsJsonObject();

        if (jsonResult.size() > 0) {
            LOGGER.debug("Ready count: " + jsonResult.size());
            final TreeMap<Integer, OddeeyMetric> MetricList = new TreeMap<>();

//            for (int i = 0; i < jsonResult.size(); i++) 
            for (Map.Entry<String, JsonElement> JsonEntry : jsonResult.entrySet()) {
                JsonElement tmpMetric = JsonEntry.getValue();
                JsonObject Metric = new JsonObject();

                Metric.add("tags", json.getAsJsonObject().get("tags"));
                Metric.add("timestamp", json.getAsJsonObject().get("timestamp"));
                Metric.addProperty("metric", JsonEntry.getKey());
                if (tmpMetric.isJsonPrimitive()) {
                    Metric.add("value", tmpMetric);
                    Metric.addProperty("type", "None");
                    Metric.addProperty("reaction", 0);
                }
                if (tmpMetric.isJsonObject()) {
                    if (tmpMetric.getAsJsonObject().get("value") == null) {
                        LOGGER.warn("mtrsc.getValue()==null " + Metric);
                        LOGGER.warn("mtrsc.getValue()==null " + msg);
                        continue;
                    } else {
                        Metric.add("value", tmpMetric.getAsJsonObject().get("value"));
                    }
                    if (tmpMetric.getAsJsonObject().get("type") == null) {
                        LOGGER.warn("mtrsc.type==null " + Metric);
                        LOGGER.warn("mtrsc.type==null " + msg);
                        Metric.addProperty("type", "None");
                    } else {
                        Metric.add("type", tmpMetric.getAsJsonObject().get("type"));
                    }

                    if (tmpMetric.getAsJsonObject().get("reaction") == null) {
                        LOGGER.warn("mtrsc.reaction==null " + Metric);
                        LOGGER.warn("mtrsc.reaction==null " + msg);
                        Metric.addProperty("reaction", 0);
                    } else {
                        Metric.add("reaction", tmpMetric.getAsJsonObject().get("reaction"));
                    }

                    if ((tmpMetric.getAsJsonObject().get("tags") != null) && (tmpMetric.getAsJsonObject().get("tags").isJsonObject())) {
                        for (Map.Entry<String, JsonElement> tagEntry : tmpMetric.getAsJsonObject().get("tags").getAsJsonObject().entrySet()) {
                            if (tagEntry.getValue().isJsonPrimitive()) {
                                Metric.get("tags").getAsJsonObject().add(tagEntry.getKey(), tagEntry.getValue());
                            }

                        }
                    }

                }

                try {
                    final OddeeyMetric mtrsc = new OddeeyMetric(Metric);

                    if (mtrsc.getName() == null) {
                        LOGGER.warn("mtrsc.getName()==null " + Metric);
                        LOGGER.warn("mtrsc.getName()==null " + msg);
                        continue;
                    }
                    if (mtrsc.getTimestamp() == null) {
                        LOGGER.warn("mtrsc.getTimestamp()==null " + Metric);
                        LOGGER.warn("mtrsc.getTimestamp()==null " + msg);
                        continue;
                    }
                    if (mtrsc.getValue() == null) {
                        LOGGER.warn("mtrsc.getValue()==null " + Metric);
                        LOGGER.warn("mtrsc.getValue()==null " + msg);
                        continue;
                    }
                    if (mtrsc.getTSDBTags() == null) {
                        LOGGER.warn("mtrsc.getTSDBTags()==null " + Metric);
                        LOGGER.warn("mtrsc.getTSDBTags()==null " + msg);
                        continue;
                    }
                    date = new Date(mtrsc.getTimestamp());
                    LOGGER.trace("Time " + date + " Metris: " + mtrsc.getName() + " Host: " + mtrsc.getTags().get("host"));
                    MetricList.put(mtrsc.hashCode(), mtrsc);

                } catch (Exception e) {
                    LOGGER.error("Exception: " + globalFunctions.stackTrace(e));
                    LOGGER.error("Exception Wits Metriq: " + Metric);
                    LOGGER.error("Exception Wits Input: " + msg);
                }

            }

            if (MetricList.size() > 0) {
                final OddeeyMetric firstmetric = MetricList.firstEntry().getValue();
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug(" first metric: Hash " + firstmetric.hashCode() + " list Size: " + MetricList.size() + " Tags hash " + firstmetric.getTags().hashCode() + " Name " + firstmetric.getName() + " Tags " + firstmetric.getTags() + " full json:" + msg);
                }

                return MetricList;
//                Compare.execute(MetricList);
//                        collector.emit(new Values(MetricList));
            }

        }
        return null;
    }

    protected OddeeyMetric prepareJsonObject(JsonElement Metric, String msg) {

        try {
            final OddeeyMetric mtrsc = new OddeeyMetric(Metric);
            if (mtrsc.getName() == null) {
                LOGGER.warn("mtrsc.getName()==null " + Metric);
                LOGGER.warn("mtrsc.getName()==null " + msg);
                return null;
            }
            if (mtrsc.getTimestamp() == null) {
                LOGGER.warn("mtrsc.getTimestamp()==null " + Metric);
                LOGGER.warn("mtrsc.getTimestamp()==null " + msg);
                return null;
            }
            if (mtrsc.getValue() == null) {
                LOGGER.warn("mtrsc.getValue()==null " + Metric);
                LOGGER.warn("mtrsc.getValue()==null " + msg);
                return null;
            }
            if (mtrsc.getTSDBTags() == null) {
                LOGGER.warn("mtrsc.getTSDBTags()==null " + Metric);
                LOGGER.warn("mtrsc.getTSDBTags()==null " + msg);
                return null;
            }
            date = new Date(mtrsc.getTimestamp());
            LOGGER.trace("Time " + date + " Metris: " + mtrsc.getName() + " Host: " + mtrsc.getTags().get("host"));
            return mtrsc;
//            Compare.execute(mtrsc);
//                    MetricList.put(mtrsc.getName(), mtrsc);
//                            collector.emit(new Values(mtrsc));

        } catch (Exception e) {
            LOGGER.error("Exception: " + globalFunctions.stackTrace(e));
            LOGGER.error("Exception Wits Metriq: " + Metric);
            LOGGER.error("Exception Wits Input: " + msg);
        }
        return null;
    }

    ;
    protected TreeMap<Integer, OddeeyMetric> parseforArray(JsonArray jsonResult, String msg) {
        JsonElement Metric;
        if (jsonResult.size() > 0) {
            LOGGER.debug("Ready count: " + jsonResult.size());
            final TreeMap<Integer, OddeeyMetric> MetricList = new TreeMap<>();
            for (int i = 0; i < jsonResult.size(); i++) {
                Metric = jsonResult.get(i);
                try {
                    try {
                        Metric.getAsJsonObject().get("value").getAsDouble();
                    } catch (Exception e) {
                        LOGGER.warn("VALOOD mtrsc.getValue()==null " + Metric);
                        continue;
                    }

                    final OddeeyMetric mtrsc = new OddeeyMetric(Metric);
                    if (mtrsc.getName() == null) {
                        LOGGER.warn("mtrsc.getName()==null " + Metric);
                        LOGGER.warn("mtrsc.getName()==null " + msg);
                        continue;
                    }
                    if (mtrsc.getTimestamp() == null) {
                        LOGGER.warn("mtrsc.getTimestamp()==null " + Metric);
                        LOGGER.warn("mtrsc.getTimestamp()==null " + msg);
                        continue;
                    }
                    if (mtrsc.getValue() == null) {
                        LOGGER.warn("mtrsc.getValue()==null " + Metric);
                        LOGGER.warn("mtrsc.getValue()==null " + msg);
                        continue;
                    }
                    if (mtrsc.getTSDBTags() == null) {
                        LOGGER.warn("mtrsc.getTSDBTags()==null " + Metric);
                        LOGGER.warn("mtrsc.getTSDBTags()==null " + msg);
                        continue;
                    }
                    date = new Date(mtrsc.getTimestamp());
                    LOGGER.trace("Time " + date + " Metris: " + mtrsc.getName() + " Host: " + mtrsc.getTags().get("host"));
                    MetricList.put(mtrsc.hashCode(), mtrsc);

                } catch (Exception e) {
                    LOGGER.error("Exception: " + globalFunctions.stackTrace(e));
                    LOGGER.error("Exception Wits Metriq: " + Metric);
                    LOGGER.error("Exception Wits Input: " + msg);
                }

            }

            if (MetricList.size() > 0) {
                final OddeeyMetric firstmetric = MetricList.firstEntry().getValue();
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug(" first metric: Hash " + firstmetric.hashCode() + " list Size: " + MetricList.size() + " Tags hash " + firstmetric.getTags().hashCode() + " Name " + firstmetric.getName() + " Tags " + firstmetric.getTags() + " full json:" + msg);
                }
//                Compare.execute(MetricList);
                return MetricList;
//                        collector.emit(new Values(MetricList));
            }

        }
        return null;
    }

    public Object execute(String msg) {
        LOGGER.debug("Start messge:" + msg);

        JsonElement jsonResult = null;
        try {
            jsonResult = this.parser.parse(msg);
        } catch (JsonSyntaxException ex) {
            LOGGER.info("msg parse Exception" + ex.toString());
        }
        Object input = null;
        if (jsonResult != null) {
            try {
                if (this.parser.parse(msg).isJsonArray()) {
                    input = this.parseforArray(jsonResult.getAsJsonArray(), msg);
                } else {
                    int version = 1;
                    if (jsonResult.getAsJsonObject().get("version") != null) {
                        version = jsonResult.getAsJsonObject().get("version").getAsInt();
                    }
                    if (version == 1) {
                        input = this.prepareJsonObject(jsonResult, msg);
                    }
                    if (version == 2) {
                        input = this.prepareJsonObjectV2(jsonResult, msg);
                    }
                }

            } catch (JsonSyntaxException ex) {
                LOGGER.error("JsonSyntaxException: " + globalFunctions.stackTrace(ex));
            } catch (NumberFormatException ex) {
                LOGGER.error("NumberFormatException: " + globalFunctions.stackTrace(ex));

            }
        }

        return input;

    }
}
