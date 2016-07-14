/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.model.User;
import java.util.ArrayList;
import java.util.List;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.filter.BinaryComparator;
import org.apache.hadoop.hbase.filter.CompareFilter;
import org.apache.hadoop.hbase.filter.Filter;
import org.apache.hadoop.hbase.filter.FilterList;
import org.apache.hadoop.hbase.filter.QualifierFilter;
import org.apache.hadoop.hbase.filter.SingleColumnValueFilter;
import org.springframework.stereotype.Repository;
import org.apache.hadoop.hbase.util.Bytes;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseDataDao extends HbaseBaseDao {

    private final static String tablename = "oddeyedata";

    public HbaseDataDao() {
        super(tablename);

    }

    public ResultScanner getSingleDataByTags(User user, String tagkey, String tagvalue, String datakey ) {
        java.util.Date date= new java.util.Date();
        
        long fromdate = date.getTime();
        int count = 1000; 
        return getSingleDataByTags(user, tagkey, tagvalue, datakey, fromdate, count ) ;
    }
    
    public ResultScanner getSingleDataByTags(User user, String tagkey, String tagvalue, String datakey,long fromdate,int count ) {

        Scan scan = new Scan();
        List<Filter> filters = new ArrayList();

        byte[] colfam = Bytes.toBytes("tags");
        byte[] Value = Bytes.toBytes(tagvalue);
        byte[] colA = Bytes.toBytes(tagkey);
        byte[] colB = Bytes.toBytes("UUID");
        byte[] fakeValue = Bytes.toBytes("DOESNOTEXIST");

//        Filter qualifierFilter = new QualifierFilter(CompareFilter.CompareOp.EQUAL, new BinaryComparator(Bytes.toBytes("data")));
//        filters.add(qualifierFilter);
//        Filter qualifierFilter2 = new QualifierFilter(CompareFilter.CompareOp.EQUAL, new BinaryComparator(colB));
//        filters.add(qualifierFilter2);
        SingleColumnValueFilter filter1
                = new SingleColumnValueFilter(Bytes.toBytes("data"), Bytes.toBytes(datakey), CompareFilter.CompareOp.NOT_EQUAL, fakeValue);
        filter1.setFilterIfMissing(true);
        filters.add(filter1);

        SingleColumnValueFilter dataFilter = new SingleColumnValueFilter(colfam, Bytes.toBytes(tagkey), CompareFilter.CompareOp.EQUAL, Value);
        dataFilter.setFilterIfMissing(true);
        filters.add(dataFilter);

        
        SingleColumnValueFilter dataFilterUpTime = new SingleColumnValueFilter(colfam, Bytes.toBytes("timestamp"), CompareFilter.CompareOp.LESS_OR_EQUAL, Bytes.toBytes(fromdate));
        dataFilter.setFilterIfMissing(true);
        filters.add(dataFilterUpTime);
        
        SingleColumnValueFilter dataFilterLowTime = new SingleColumnValueFilter(colfam, Bytes.toBytes("timestamp"), CompareFilter.CompareOp.GREATER_OR_EQUAL, Bytes.toBytes(fromdate-count));
        dataFilter.setFilterIfMissing(true);
        filters.add(dataFilterLowTime);

        
        
        SingleColumnValueFilter userFilter = new SingleColumnValueFilter(colfam, Bytes.toBytes("UUID"), CompareFilter.CompareOp.EQUAL, Bytes.toBytes(user.getId().toString()));
        userFilter.setFilterIfMissing(true);
        filters.add(userFilter);

        FilterList filterList = new FilterList(FilterList.Operator.MUST_PASS_ALL, filters);
//        Filter dataFilter = new SingleColumnValueFilter(Bytes.toBytes("tags"), Bytes.toBytes(tagkey), CompareFilter.CompareOp.EQUAL, Bytes.toBytes("ab"));        
        scan.setFilter(filterList);
        scan.addColumn(Bytes.toBytes("tags"), colA);
        scan.addColumn(Bytes.toBytes("tags"), colB);
        scan.addColumn(Bytes.toBytes("data"), Bytes.toBytes(datakey));
        scan.addColumn(Bytes.toBytes("tags"), Bytes.toBytes("timestamp"));
        try {
            ResultScanner resultScanner = this.htable.getScanner(scan);
            return resultScanner;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }
}
