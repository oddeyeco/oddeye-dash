/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.TimeZone;
import java.util.TreeMap;

/**
 *
 * @author vahan
 */
public class ConsumptionList extends TreeMap<Long, CoconutConsumption> {

    private static final long serialVersionUID = 465895478L;

    private final TreeMap<Long, CoconutConsumption> ConsumptionListHoure = new TreeMap<>(Collections.reverseOrder());
    private final TreeMap<Long, CoconutConsumption> ConsumptionListDaily = new TreeMap<>(Collections.reverseOrder());
    private final TreeMap<Long, CoconutConsumption> ConsumptionListMonth = new TreeMap<>(Collections.reverseOrder());

    public ConsumptionList() {
        super(Collections.reverseOrder());
    }

    @Override
    public CoconutConsumption put(Long key, CoconutConsumption value) {
        CoconutConsumption result = super.put(key, value);
        TimeZone timeZone = TimeZone.getTimeZone("UTC");
        Calendar cal = Calendar.getInstance(timeZone);
        cal.setTimeInMillis(value.getTimestamp());
//        cal.add(Calendar.HOUR, 1);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        long hkey = cal.getTimeInMillis();
        CoconutConsumption hvalue;
        if (!ConsumptionListHoure.containsKey(hkey)) {
            hvalue = new CoconutConsumption(hkey);
            getConsumptionListHoure().put(hkey, hvalue);
        } else {
            hvalue = getConsumptionListHoure().get(hkey);
        }
        hvalue.addConsumption(value.getAmount(), value.getCount());

        cal.set(Calendar.HOUR_OF_DAY, 0);
//        cal.add(Calendar.DATE, 1);
        hkey = cal.getTimeInMillis();
        if (!ConsumptionListDaily.containsKey(hkey)) {
            hvalue = new CoconutConsumption(hkey);
            getConsumptionListDaily().put(hkey, hvalue);
        } else {
            hvalue = getConsumptionListDaily().get(hkey);
        }
        hvalue.addConsumption(value.getAmount(), value.getCount());

        cal.set(Calendar.DAY_OF_MONTH, 1);
//        cal.add(Calendar.MONTH, 1);
        hkey = cal.getTimeInMillis();
        if (!ConsumptionListMonth.containsKey(hkey)) {
            hvalue = new CoconutConsumption(hkey);
            getConsumptionListMonth().put(hkey, hvalue);
        } else {
            hvalue = getConsumptionListMonth().get(hkey);
        }
        hvalue.addConsumption(value.getAmount(), value.getCount());

        return result;
    }

    /**
     * @return the ConsumptionListHoure
     */
    public TreeMap<Long, CoconutConsumption> getConsumptionListHoure() {
        return ConsumptionListHoure;
    }

    /**
     * @return the ConsumptionListDaily
     */
    public TreeMap<Long, CoconutConsumption> getConsumptionListDaily() {
        return ConsumptionListDaily;
    }

    public CoconutConsumption getConsumptionListDay(int day) {
        if (!ConsumptionListDaily.entrySet().isEmpty()) {
            if (ConsumptionListDaily.size() > day) {
                CoconutConsumption cc = new ArrayList<>(ConsumptionListDaily.entrySet()).get(day).getValue();
                Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
//        cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                cal.set(Calendar.MILLISECOND, 0);
                cal.add(Calendar.DATE, -1 * day);
                if (cc.getTimestamp() == cal.getTimeInMillis()) {
                    return cc;
                }
            }
        }
        return null;

    }

    /**
     * @return the ConsumptionListMonth
     */
    public TreeMap<Long, CoconutConsumption> getConsumptionListMonth() {
        return ConsumptionListMonth;
    }

    public CoconutConsumption getConsumptionListMonth(int Month) {
        if (!ConsumptionListDaily.entrySet().isEmpty()) {
            CoconutConsumption cc = new ArrayList<>(ConsumptionListMonth.entrySet()).get(Month).getValue();
            Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
//        cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.DAY_OF_MONTH, 1);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            cal.add(Calendar.MONTH, -1 * Month);
            if (cc.getTimestamp() == cal.getTimeInMillis()) {
                return cc;
            }
        }
        return null;

    }
}
