/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.core;

import co.oddeye.concout.model.OddeyeUserModel;

/**
 *
 * @author vahan
 */
public interface SendToKafka {   
   void run(OddeyeUserModel user,String action,Object hash);    
}
