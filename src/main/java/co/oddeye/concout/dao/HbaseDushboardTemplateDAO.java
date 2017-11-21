/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.annotation.HbaseColumn;
import co.oddeye.concout.config.DatabaseConfig;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import co.oddeye.concout.model.DashboardTemplate;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.globalFunctions;
import com.stumbleupon.async.Deferred;
import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.BinaryPrefixComparator;
import org.hbase.async.Bytes;
import org.hbase.async.ColumnPrefixFilter;
import org.hbase.async.CompareFilter;
import org.hbase.async.DeleteRequest;
import org.hbase.async.FilterList;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.hbase.async.RowFilter;
import org.hbase.async.ScanFilter;
import org.hbase.async.Scanner;
import org.hbase.async.ValueFilter;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author vahan
 */
//@Repository
public class HbaseDushboardTemplateDAO extends HbaseBaseDao {

    @Autowired
    private HbaseUserDao Userdao;

    private static final Logger LOGGER = LoggerFactory.getLogger(HbaseDushboardTemplateDAO.class);

    public HbaseDushboardTemplateDAO(DatabaseConfig p_config) {
        super(p_config.getDushboardsTemplatesTable());                
    }   

    public Deferred<Object> add(DashboardTemplate template) {
        final Field[] fields = template.getClass().getDeclaredFields();
        Map<String, HashMap<String, Object>> changedata = new HashMap<>();
        for (Field field : fields) {
            Annotation[] Annotations = field.getDeclaredAnnotations();
            if (Annotations.length > 0) {
                for (Annotation annotation : Annotations) {
                    if (annotation.annotationType().equals(HbaseColumn.class)) {
                        try {
                            PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), template.getClass());
                            Method getter = PDescriptor.getReadMethod();
                            Object value = getter.invoke(template);
                            if (!((HbaseColumn) annotation).identfield().isEmpty()) {
                                PDescriptor = new PropertyDescriptor(((HbaseColumn) annotation).identfield(), value.getClass());
                                getter = PDescriptor.getReadMethod();
                                value = getter.invoke(value);
                            }
                            String family = ((HbaseColumn) annotation).family();
                            if ((!family.isEmpty() && (value != null))) {
                                if (!changedata.containsKey(family)) {
                                    changedata.put(family, new HashMap<>());
                                }
                                changedata.get(family).put(((HbaseColumn) annotation).qualifier(), value);
                            }

                        } catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException | IntrospectionException ex) {
                            LOGGER.error(globalFunctions.stackTrace(ex));
                        }
                    }
                }
            }
        }
        return put(changedata, template.getKey());
    }

    public ArrayList<DashboardTemplate> getRecomendTemplates(OddeyeUserModel user, int limit) {
        ArrayList<DashboardTemplate> result = new ArrayList<>();
         // TODO use Deferred
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            scanner.setMaxNumRows(limit);
            scanner.setReversed(true);
            final ArrayList<ScanFilter> filters = new ArrayList<>(2);
            filters.add(
                    new ValueFilter(org.hbase.async.CompareFilter.CompareOp.NOT_EQUAL,
                            new org.hbase.async.BinaryComparator(Bytes.fromInt(0))));
            filters.add(new ColumnPrefixFilter("Recomended"));
            
            filters.add(new RowFilter(CompareFilter.CompareOp.NOT_EQUAL, new BinaryPrefixComparator(user.getId().toString().getBytes())));

            scanner.setFilter(new FilterList(filters));
            ArrayList<ArrayList<KeyValue>> rows;
            rows = scanner.nextRows(limit).joinUninterruptibly();
            for (final ArrayList<KeyValue> row : rows) {
                GetRequest gettemplate = new GetRequest(table, row.get(0).key());
                ArrayList<KeyValue> s_row = BaseTsdb.getClient().get(gettemplate).join();                
                result.add(new DashboardTemplate(s_row, Userdao));
            }

        } catch (Exception ex) {
            globalFunctions.stackTrace(ex);
        }
        Collections.reverse(result);
        return result;
    }

    public ArrayList<DashboardTemplate> getLasttemplates(OddeyeUserModel user,int limit) {
        ArrayList<DashboardTemplate> result = new ArrayList<>();
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            scanner.setMaxNumRows(limit);            
            scanner.setReversed(true);
            final ArrayList<ScanFilter> filters = new ArrayList<>();            
            filters.add(new RowFilter(CompareFilter.CompareOp.NOT_EQUAL, new BinaryPrefixComparator(user.getId().toString().getBytes())));
            scanner.setFilter(new FilterList(filters));            
            
            ArrayList<ArrayList<KeyValue>> rows;
            rows = scanner.nextRows(limit).joinUninterruptibly();
            for (final ArrayList<KeyValue> row : rows) {
                result.add(new DashboardTemplate(row, Userdao));
            }

        } catch (Exception ex) {
            globalFunctions.stackTrace(ex);
        }
        Collections.reverse(result);
        return result;
    }

    public ArrayList<DashboardTemplate> getLastUsertemplates(OddeyeUserModel user,int limit) {
        ArrayList<DashboardTemplate> result = new ArrayList<>();
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            scanner.setMaxNumRows(limit);            
            scanner.setReversed(true);
            final ArrayList<ScanFilter> filters = new ArrayList<>();            
            filters.add(new RowFilter(CompareFilter.CompareOp.EQUAL, new BinaryPrefixComparator(user.getId().toString().getBytes())));
            scanner.setFilter(new FilterList(filters));            
            
            ArrayList<ArrayList<KeyValue>> rows;
            rows = scanner.nextRows(limit).joinUninterruptibly();
            for (final ArrayList<KeyValue> row : rows) {
                result.add(new DashboardTemplate(row, Userdao));
            }

        } catch (Exception ex) {
            globalFunctions.stackTrace(ex);
        }
        Collections.reverse(result);
        return result;
    }    
    
    public ArrayList<DashboardTemplate> getAll() {
        ArrayList<DashboardTemplate> result = new ArrayList<>();
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            scanner.setReversed(true);
            ArrayList<ArrayList<KeyValue>> rows;
            rows = scanner.nextRows(100).joinUninterruptibly();
            for (final ArrayList<KeyValue> row : rows) {
                result.add(new DashboardTemplate(row, Userdao));
            }

        } catch (Exception ex) {
            globalFunctions.stackTrace(ex);
        }
        return result;
    }

    public DashboardTemplate getbyKey(byte[] key) {
        try {
            GetRequest get = new GetRequest(table, key);
            final ArrayList<KeyValue> row = BaseTsdb.getClient().get(get).join();
            return new DashboardTemplate(row, Userdao);
        } catch (Exception ex) {

            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;

    }

    public void delete(DashboardTemplate template) {

        try {
            DeleteRequest del = new DeleteRequest(table, template.getKey());
            BaseTsdb.getClient().delete(del).join();
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }

    }

    public boolean checkByName(DashboardTemplate template) {
        DashboardTemplate oldTemplate = getbyKey(template.getKey());
        byte[] key = ArrayUtils.addAll(oldTemplate.getUser().getId().toString().getBytes(), template.getName().getBytes());
        if (template.getName().equals(oldTemplate.getName())) {
            return false;
        }
        return getbyKey(key) != null;
    }

    public boolean save(DashboardTemplate template, DashboardTemplate oldtemplate, Map<String, Object> editConfig) {
        template.FillCompare(oldtemplate);

        template.updateKey();
        Map<String, HashMap<String, Object>> changedata = new HashMap<>();
        if (Arrays.equals(template.getKey(), oldtemplate.getKey())) {
            for (Map.Entry<String, Object> configEntry : editConfig.entrySet()) {
                HashMap<?, ?> config = (HashMap<?, ?>) configEntry.getValue();
                String name = (String) config.get("path");
                try {
                    Field field = template.getClass().getDeclaredField(name);
                    Annotation[] Annotations = field.getDeclaredAnnotations();
                    if (Annotations.length > 0) {
                        for (Annotation annotation : Annotations) {
                            if (annotation.annotationType().equals(HbaseColumn.class)) {
                                try {
                                    PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), DashboardTemplate.class);
                                    Method getter = PDescriptor.getReadMethod();
                                    Object value = getter.invoke(oldtemplate);
                                    Object newvalue = getter.invoke(template);
                                    boolean ischange = false;
                                    switch (((HbaseColumn) annotation).type()) {
                                        default:
                                            if (!value.equals(newvalue)) {
                                                ischange = true;
                                            }
                                            break;
                                    }

                                    if (ischange) {

                                        Method setter = PDescriptor.getWriteMethod();
                                        String family = ((HbaseColumn) annotation).family();
                                        if (!changedata.containsKey(family)) {
                                            changedata.put(family, new HashMap<>());
                                        }
                                        setter.invoke(template, newvalue);
                                        changedata.get(family).put(((HbaseColumn) annotation).qualifier(), newvalue);

                                    }

                                } catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException | IntrospectionException e) {
                                    LOGGER.error(globalFunctions.stackTrace(e));
                                }
                            }

                        }
                    }
                } catch (NoSuchFieldException | SecurityException e) {
                    LOGGER.error(globalFunctions.stackTrace(e));
                }
            }
            put(changedata, template.getKey());
            return false;
        } else {
            try {
                delete(oldtemplate);
                add(template).joinUninterruptibly();
                return true;
            } catch (Exception ex) {
                LOGGER.error(globalFunctions.stackTrace(ex));
            }
            return false;
        }
    }
}
