/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import com.google.common.collect.ImmutableMap;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author vahan
 */
public class AlertLevel extends HashMap<Integer,Map<Integer,Double>>{
    public final static Integer ALERT_LEVEL_ALL = 0;
    public final static Integer ALERT_LEVEL_LOW = 1;
    public final static Integer ALERT_LEVEL_GUARDED = 2;
    public final static Integer ALERT_LEVEL_ELEVATED = 3;
    public final static Integer ALERT_LEVEL_HIGH = 4;
    public final static Integer ALERT_LEVEL_SEVERE = 5;

    public final static String ST_ALERT_LEVEL_ALL = "All";
    public final static String ST_ALERT_LEVEL_LOW = "Low";
    public final static String ST_ALERT_LEVEL_GUARDED = "Guarded";
    public final static String ST_ALERT_LEVEL_ELEVATED = "Elevated";
    public final static String ST_ALERT_LEVEL_HIGH = "High";
    public final static String ST_ALERT_LEVEL_SEVERE = "Severe"; 
    
    public final static String[] ALERT_LEVELS = new String[]{ST_ALERT_LEVEL_ALL,ST_ALERT_LEVEL_LOW,ST_ALERT_LEVEL_GUARDED,ST_ALERT_LEVEL_ELEVATED,ST_ALERT_LEVEL_HIGH,ST_ALERT_LEVEL_SEVERE};    
    
    public final static String ST_ALERT_PARAM_VALUE_NAME = "Min Value";
    public final static String ST_ALERT_PARAM_PECENT_NAME = "Min Percent";
    public final static String ST_ALERT_PARAM_WEIGTH_NAME = "Min Weight";
    public final static String ST_ALERT_PARAM_RECCOUNT_NAME = "Min Recurrence Count";
    public final static String ST_ALERT_PARAM_PREDICTPERCENT_NAME = "Min Predict Percent";

    public final static Integer ALERT_PARAM_VALUE = 0;
    public final static Integer ALERT_PARAM_PECENT = 1;
    public final static Integer ALERT_PARAM_WEIGTH = 2;
    public final static Integer ALERT_PARAM_RECCOUNT = 3;
    public final static Integer ALERT_PARAM_PREDICTPERSENT = 4;

    public final static String[] ALERT_LEVEL_PARAM = new String[]{ST_ALERT_PARAM_VALUE_NAME,ST_ALERT_PARAM_PECENT_NAME,ST_ALERT_PARAM_WEIGTH_NAME,ST_ALERT_PARAM_RECCOUNT_NAME,ST_ALERT_PARAM_PREDICTPERCENT_NAME};

    
    public AlertLevel ()
    {
        this(true);
    }

    public AlertLevel(boolean usedefault) {
      if (usedefault)   
      {
          this.put(ALERT_LEVEL_ALL, ImmutableMap.<Integer, Double>builder()
                  .put(ALERT_PARAM_VALUE, 0.0)
                  .put(ALERT_PARAM_PECENT, 0.0)
                  .put(ALERT_PARAM_WEIGTH, 0.0)
                  .put(ALERT_PARAM_RECCOUNT, 0.0)
                  .put(ALERT_PARAM_PREDICTPERSENT, 0.0)
                  .build());
          this.put(ALERT_LEVEL_LOW, ImmutableMap.<Integer, Double>builder()
                  .put(ALERT_PARAM_VALUE, 1.0)
                  .put(ALERT_PARAM_PECENT, 20.0)
                  .put(ALERT_PARAM_WEIGTH, 8.0)
                  .put(ALERT_PARAM_RECCOUNT, 1.0)
                  .put(ALERT_PARAM_PREDICTPERSENT, 20.0)
                  .build());     
          
          this.put(ALERT_LEVEL_GUARDED, ImmutableMap.<Integer, Double>builder()
                  .put(ALERT_PARAM_VALUE, 1.0)
                  .put(ALERT_PARAM_PECENT, 30.0)
                  .put(ALERT_PARAM_WEIGTH, 10.0)
                  .put(ALERT_PARAM_RECCOUNT, 2.0)
                  .put(ALERT_PARAM_PREDICTPERSENT, 30.0)
                  .build());
          this.put(ALERT_LEVEL_ELEVATED, ImmutableMap.<Integer, Double>builder()
                  .put(ALERT_PARAM_VALUE, 1.0)
                  .put(ALERT_PARAM_PECENT, 50.0)
                  .put(ALERT_PARAM_WEIGTH, 14.0)
                  .put(ALERT_PARAM_RECCOUNT, 2.0)
                  .put(ALERT_PARAM_PREDICTPERSENT, 50.0)
                  .build());
          this.put(ALERT_LEVEL_HIGH, ImmutableMap.<Integer, Double>builder()
                  .put(ALERT_PARAM_VALUE, 1.0)
                  .put(ALERT_PARAM_PECENT, 70.0)
                  .put(ALERT_PARAM_WEIGTH, 15.0)
                  .put(ALERT_PARAM_RECCOUNT, 4.0)
                  .put(ALERT_PARAM_PREDICTPERSENT, 70.0)
                  .build());
          this.put(ALERT_LEVEL_SEVERE, ImmutableMap.<Integer, Double>builder()
                  .put(ALERT_PARAM_VALUE, 1.0)
                  .put(ALERT_PARAM_PECENT, 80.0)
                  .put(ALERT_PARAM_WEIGTH, 16.0)
                  .put(ALERT_PARAM_RECCOUNT, 4.0)
                  .put(ALERT_PARAM_PREDICTPERSENT, 80.0)
                  .build());          
          
//          this.get(this).get(this)
      }
    }
    
    public String getName(Integer idx)
    {
        return ALERT_LEVELS[idx];
    }

}
