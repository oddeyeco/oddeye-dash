/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.annotation.HbaseColumn;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import co.oddeye.concout.model.DashboardTemplate;
import co.oddeye.core.globalFunctions;
import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.hbase.async.Scanner;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbaseDushboardTemplateDAO extends HbaseBaseDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(HbaseDushboardTemplateDAO.class);

    public HbaseDushboardTemplateDAO() {
        super("oddeyeDushboardTemplates");
    }

    public void add(DashboardTemplate template) {
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
        put(changedata, template.getKey());
    }

    public ArrayList<DashboardTemplate> getAlltemplates(int limit) {
        ArrayList<DashboardTemplate> result = new ArrayList<>();
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            scanner.setMaxNumRows(limit);
            ArrayList<ArrayList<KeyValue>> rows;
            while ((rows = scanner.nextRows(limit).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                     result.add(new DashboardTemplate(row));
                }
            }

        } catch (Exception ex) {
            globalFunctions.stackTrace(ex);
        }
        return result;
    }
    public DashboardTemplate getbyKey (byte[] key)
    {
        try {
            GetRequest get = new GetRequest(table, key);
            final ArrayList<KeyValue> row = BaseTsdb.getClient().get(get).join();
            return  new DashboardTemplate(row);
        } catch (Exception ex) {
            
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return  null;
        
    }
}
