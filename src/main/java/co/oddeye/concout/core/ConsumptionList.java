/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import java.util.Calendar;
import java.util.Collections;
import java.util.TreeMap;

/**
 *
 * @author vahan
 */
public class ConsumptionList extends TreeMap<Long, CoconutConsumption> {

    private final TreeMap<Long, CoconutConsumption> ConsumptionListHoure = new TreeMap<>(Collections.reverseOrder());
    private final TreeMap<Long, CoconutConsumption> ConsumptionListDaily = new TreeMap<>(Collections.reverseOrder());
    private final TreeMap<Long, CoconutConsumption> ConsumptionListMonth = new TreeMap<>(Collections.reverseOrder());

    public ConsumptionList()
    {
        super(Collections.reverseOrder());
    }
    
    @Override
    public CoconutConsumption put(Long key, CoconutConsumption value) {
        CoconutConsumption result = super.put(key, value);        
        Calendar cal = Calendar.getInstance(); // locale-specific
        cal.setTimeInMillis(value.getTimestamp());
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
        hvalue.addConsumption(value.getAmount(),value.getCount());
         
        cal.set(Calendar.HOUR_OF_DAY, 0);
        hkey = cal.getTimeInMillis();        
        if (!ConsumptionListDaily.containsKey(hkey)) {
            hvalue = new CoconutConsumption(hkey);
            getConsumptionListDaily().put(hkey, hvalue);
        } else {
            hvalue = getConsumptionListDaily().get(hkey);
        }        
        hvalue.addConsumption(value.getAmount(),value.getCount());
        
        cal.set(Calendar.DAY_OF_MONTH, 0);
        hkey = cal.getTimeInMillis();        
        if (!ConsumptionListMonth.containsKey(hkey)) {
            hvalue = new CoconutConsumption(hkey);
            getConsumptionListMonth().put(hkey, hvalue);
        } else {
            hvalue = getConsumptionListMonth().get(hkey);
        }        
        hvalue.addConsumption(value.getAmount(),value.getCount());
        
        
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

    /**
     * @return the ConsumptionListMonth
     */
    public TreeMap<Long, CoconutConsumption> getConsumptionListMonth() {
        return ConsumptionListMonth;
    }
}
