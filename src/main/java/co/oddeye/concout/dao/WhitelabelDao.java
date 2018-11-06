/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.annotation.HbaseColumn;
import co.oddeye.concout.config.DatabaseConfig;
import co.oddeye.concout.model.WhitelabelModel;
import co.oddeye.core.globalFunctions;
import java.beans.PropertyDescriptor;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;
import java.util.UUID;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.hbase.async.Bytes;
import org.hbase.async.DeleteRequest;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.hbase.async.Scanner;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository("Whitelabeldao")
public class WhitelabelDao extends HbaseBaseDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(WhitelabelDao.class);

    @Autowired
    HbaseUserDao userDao;    
    
    public WhitelabelDao(DatabaseConfig p_config) {
        super(p_config.getWltable());
    }

    public List<WhitelabelModel> getAll() {
        List<WhitelabelModel> result = new ArrayList<>();
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            scanner.setQualifier("key");
            ArrayList<ArrayList<KeyValue>> rows;
            while ((rows = scanner.nextRows(10000).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                   for (KeyValue kv:row)  
                   {
                       if (Arrays.equals(kv.qualifier(), "key".getBytes()))
                       {
                           result.add(getByID(kv.value()));
                       }
                   }
                }
            }
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
            return null;
        }

        return result;
    }

    public WhitelabelModel getByID(byte[] id) {

        try {
            GetRequest get = new GetRequest(table, id);
            final ArrayList<KeyValue> kvs = BaseTsdb.getClient().get(get).join();
            WhitelabelModel whitelabel;
            whitelabel = new WhitelabelModel();
            if (kvs.isEmpty()) {
                return null;
            }
            for (Field field : whitelabel.getClass().getDeclaredFields()) {
                if (field.isAnnotationPresent(HbaseColumn.class)) {
                    PropertyDescriptor PDescriptor = new PropertyDescriptor(field.getName(), WhitelabelModel.class);
                    for (KeyValue kv : kvs) {
                        String q = new String(kv.qualifier());
                        for (Annotation an : field.getDeclaredAnnotations()) {
                            if (an.annotationType().equals(HbaseColumn.class)) {
                                HbaseColumn anotation = (HbaseColumn) an;
                                if ((Arrays.equals(kv.family(), anotation.family().getBytes()))) {
                                    if ((Arrays.equals(kv.qualifier(), anotation.qualifier().getBytes()))) {
                                        Method setter = PDescriptor.getWriteMethod();
                                        Object newvalue = null;
                                        //&& (field.getType().getCanonicalName().equals("java.util.Date"))
                                        if (anotation.type().equals("timestamp")) {
                                            newvalue = new Date(kv.timestamp());
                                            setter.invoke(whitelabel, new Object[]{newvalue});
                                        } else {
                                            switch (field.getType().getCanonicalName()) {
                                                case "co.oddeye.concout.model.OddeyeUserModel":
                                                    newvalue = userDao.getUserByUUID(new String(kv.value()));
                                                    setter.invoke(whitelabel, new Object[]{newvalue});
                                                    break;                                                
                                                case "java.util.UUID":
                                                    newvalue = UUID.fromString(new String(kv.value()));
                                                    setter.invoke(whitelabel, new Object[]{newvalue});
                                                    break;
                                                case "java.lang.String":
                                                    newvalue = new String(kv.value());
                                                    setter.invoke(whitelabel, new Object[]{newvalue});
                                                    break;
                                                case "java.util.Collection":
                                                    if (field.getName().equals("authorities")) {
                                                        String token;
                                                        StringTokenizer tokens = new StringTokenizer(new String(kv.value()).replaceAll("\\[|\\]", ""), ",");
                                                        newvalue = new ArrayList<>();
                                                        while (tokens.hasMoreTokens()) {
                                                            token = tokens.nextToken();
                                                            token = token.trim();
                                                            ((ArrayList<GrantedAuthority>) newvalue).add(new SimpleGrantedAuthority(token));
                                                        }
                                                        setter.invoke(whitelabel, new Object[]{newvalue});
                                                    }

                                                    break;
                                                case "java.lang.Double":
                                                    newvalue = ByteBuffer.wrap(kv.value()).getDouble();//Bytes.getLong(property.value());
                                                    setter.invoke(whitelabel, new Object[]{newvalue});
                                                    break;

                                                case "java.lang.Boolean":
                                                    if (kv.value().length == 1) {
                                                        newvalue = kv.value()[0] != (byte) 0;
                                                    }
                                                    if (kv.value().length == 4) {
                                                        newvalue = Bytes.getInt(kv.value()) != 0;
                                                    }
                                                    setter.invoke(whitelabel, new Object[]{newvalue});
                                                    break;
                                                case "byte[]":
                                                    newvalue = kv.value();
                                                    setter.invoke(whitelabel, new Object[]{newvalue});
                                                    break;
                                                default:
                                                    System.out.println(field.getType().getCanonicalName());
                                                    break;
                                            }
                                        }

                                    }

                                }

                            }
                        }
                    }
                }

            }
            return whitelabel;

        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;
    }

    @Override
    protected byte[] getKey(Object object) {
        return ((WhitelabelModel) object).getKey();
    }

    public WhitelabelModel getByID(String id) {
        try {
            return getByID(Hex.decodeHex(id.toCharArray()));
        } catch (DecoderException ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;
    }
}
