/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import com.stumbleupon.async.Deferred;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import net.opentsdb.core.DataPoint;
import net.opentsdb.core.DataPoints;
import net.opentsdb.core.SeekableView;
import net.opentsdb.meta.Annotation;
import org.hbase.async.Bytes;

/**
 *
 * @author andriasyan
 */
public class DataPointsImpl implements DataPoints {
    public DataPointsImpl(DataPoints source) {
        metricName = source.metricName();
        metricUID = source.metricUID().clone();
        if(null != source.getTags())
            tags = new HashMap<>(source.getTags());// Map
        
        tagUids = new Bytes.ByteMap<>();//Bytes.ByteMap<byte[]>
        if(null != source.getTagUids())
            tagUids.putAll(source.getTagUids());
        
        if(null != source.getAggregatedTags())
            aggregatedTags = new ArrayList(source.getAggregatedTags());//List
        
        if(null != source.getAggregatedTagUids())
            aggregatedTagUids = new ArrayList(source.getAggregatedTagUids());//List
        
        if(null != source.getTSUIDs())
            TSUIDs = new ArrayList(source.getTSUIDs());//List
        
        if(null != source.getAnnotations())
            annotations = new ArrayList(source.getAnnotations());//List
        size = source.size();
        aggregatedSize = source.aggregatedSize();
        
        dataPoints = new ArrayList<>(source.size());
        for(int i = 0;i < size;i++) {
            dataPoints.add(
                new DataPointImpl(
                    source.timestamp(i),
                    source.isInteger(i),
                    source.isInteger(i) ? source.longValue(i) : 0,
                    source.isInteger(i) ? 0f : source.doubleValue(i),
                    0
                )
            );
        }
        
    }
    
    String metricName;
    @Override
    public String metricName(){
        return metricName;
    }

    @Override
    public Deferred<String> metricNameAsync() {
        throw new UnsupportedOperationException("Operation not supported");
    }

    byte[] metricUID;
    @Override
    public byte[] metricUID() {
        return metricUID;
    }

    Map<String, String> tags;
    @Override
    public Map<String, String> getTags() {
        return tags;
    }

    @Override
    public Deferred<Map<String, String>> getTagsAsync() {
        throw new UnsupportedOperationException("Operation not supported");
    }

    Bytes.ByteMap<byte[]> tagUids;
    @Override
    public Bytes.ByteMap<byte[]> getTagUids() {
        return tagUids;
    }

    List<String> aggregatedTags;
    @Override
    public List<String> getAggregatedTags() {
        return aggregatedTags;
    }

    @Override
    public Deferred<List<String>> getAggregatedTagsAsync() {
        throw new UnsupportedOperationException("Operation not supported");
    }

    List<byte[]> aggregatedTagUids;
    @Override
    public List<byte[]> getAggregatedTagUids() {
        return aggregatedTagUids;
    }

    List<String> TSUIDs;
    @Override
    public List<String> getTSUIDs() {
        return TSUIDs;
    }

    List<Annotation> annotations;
    @Override
    public List<Annotation> getAnnotations() {
        return annotations;
    }

    int size;
    @Override
    public int size() {
        return size;
    }

    int aggregatedSize;
    @Override
    public int aggregatedSize() {
        return aggregatedSize;
    }

    List<DataPoint> dataPoints;
    @Override
    public SeekableView iterator() {
        return new SeekableView() {
            ListIterator<DataPoint> iterator = dataPoints.listIterator();
            @Override
            public boolean hasNext() {
               return iterator.hasNext();
            }

            @Override
            public DataPoint next() {
                return iterator.next();
            }

            @Override
            public void remove() {
                iterator.remove();
            }

            @Override
            public void seek(long l) {
                int currentIndex;
                if(iterator.hasPrevious())
                    currentIndex = iterator.previousIndex() + 1;
                else
                    currentIndex = 0;
                if(currentIndex < l) {
                    while(currentIndex < l) {
                        currentIndex++;
                        iterator.next();
                    }
                }
                else {
                    while(currentIndex > l) {
                        currentIndex--;
                        iterator.previous();
                    }    
                }
            }
        };
    }

    @Override
    public long timestamp(int i) {
        return dataPoints.get(i).timestamp();
    }

    @Override
    public boolean isInteger(int i) {
        return dataPoints.get(i).isInteger();
    }

    @Override
    public long longValue(int i) {
        return dataPoints.get(i).longValue();
    }

    @Override
    public double doubleValue(int i) {
        return dataPoints.get(i).doubleValue();
    }

    int queryIndex;
    @Override
    public int getQueryIndex() {
        return queryIndex;
    }

    boolean isPerclentile;
    @Override
    public boolean isPercentile() {
        return isPerclentile;
    }

    float percentilel;
    @Override
    public float getPercentile() {
        return percentilel;
    }   
}
