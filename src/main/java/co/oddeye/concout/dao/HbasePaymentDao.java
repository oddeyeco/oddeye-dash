/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.dao;

import co.oddeye.concout.config.DatabaseConfig;
import co.oddeye.concout.model.OddeyePayModel;
import co.oddeye.concout.model.OddeyeUserModel;
import co.oddeye.core.globalFunctions;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.ArrayUtils;
import org.hbase.async.GetRequest;
import org.hbase.async.KeyValue;
import org.hbase.async.PutRequest;
import org.hbase.async.Scanner;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

//import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author vahan
 */
@Repository
public class HbasePaymentDao extends HbaseBaseDao {

    @Autowired
    private HbaseUserDao Userdao;

    private static final Logger LOGGER = LoggerFactory.getLogger(HbasePaymentDao.class);

    public HbasePaymentDao(DatabaseConfig p_config) {
        super(p_config.getPaymentstable());
    }

    @Deprecated
    public void addPayment(OddeyeUserModel user, OddeyePayModel payment) throws Exception {
        byte[] family = "c".getBytes();
        byte[][] qualifiers = new byte[10][];
        byte[][] values = new byte[10][];
        byte[] end_key = ArrayUtils.addAll(user.getId().toString().getBytes(), payment.getIpn_track_id().getBytes());
        qualifiers[0] = "Ipn_track_id".getBytes();
        values[0] = payment.getIpn_track_id().getBytes();

        qualifiers[1] = "First_name".getBytes();
        values[1] = payment.getFirst_name().getBytes();
        qualifiers[2] = "Mc_currency".getBytes();
        values[2] = payment.getMc_currency().getBytes();

        qualifiers[3] = "Mc_gross".getBytes();
        byte[] bytes = new byte[8];
        ByteBuffer.wrap(bytes).putDouble((Double) payment.getMc_gross());
        values[3] = bytes;

        qualifiers[4] = "Mc_fee".getBytes();
        bytes = new byte[8];
        ByteBuffer.wrap(bytes).putDouble((Double) payment.getMc_fee());
        values[4] = bytes;

        qualifiers[5] = "Payment_gross".getBytes();
        bytes = new byte[8];
        ByteBuffer.wrap(bytes).putDouble((Double) payment.getPayment_gross());
        values[5] = bytes;

        qualifiers[6] = "Payment_fee".getBytes();
        bytes = new byte[8];
        ByteBuffer.wrap(bytes).putDouble((Double) payment.getPayment_fee());
        values[6] = bytes;

        qualifiers[7] = "Points".getBytes();
        bytes = new byte[8];
        ByteBuffer.wrap(bytes).putDouble((Double) payment.getPoints());
        values[7] = bytes;

        qualifiers[8] = "Payer_email".getBytes();
        values[8] = payment.getPayer_email().getBytes();

        qualifiers[9] = "fulljson".getBytes();
        values[9] = payment.getJson().toString().getBytes();

        final PutRequest request = new PutRequest(table, end_key, family, qualifiers, values);
        BaseTsdb.getClient().put(request).join();
    }

    public List<OddeyePayModel> getAllPay() {
        List<OddeyePayModel> result = new ArrayList<>();
        try {
            final Scanner scanner = BaseTsdb.getClient().newScanner(table);
            ArrayList<ArrayList<KeyValue>> rows;
            //TODO Do pagination
            while ((rows = scanner.nextRows(1000).joinUninterruptibly()) != null) {
                for (final ArrayList<KeyValue> row : rows) {
                    result.add(new OddeyePayModel(row, Userdao));
                }
            }
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
            return null;
        }

        return result;
    }

    public OddeyeUserModel getPaymentByid(byte[] key) {

        try {
            GetRequest get = new GetRequest(table, key);
            final ArrayList<KeyValue> userkvs = BaseTsdb.getClient().get(get).join();
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }
        return null;
    }

    protected byte[] getKey(Object object) {
      return ArrayUtils.addAll(((OddeyePayModel) object).getUser().getId().toString().getBytes(), ((OddeyePayModel) object).getIpn_track_id().getBytes());
    }

}
