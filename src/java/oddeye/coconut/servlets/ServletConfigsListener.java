/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package oddeye.coconut.servlets;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletContext;

import java.util.Properties;
import kafka.javaapi.producer.Producer;
//import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;
/**
 * Web application lifecycle listener.
 *
 * @author vahan
 */
public class ServletConfigsListener implements ServletContextListener {

    
    @Override
    public void contextInitialized(ServletContextEvent sce) {        
        //System.out.println("ServletContextListener started");
        ServletContext cntxt = sce.getServletContext();
        AppConfiguration.Initbyfile(cntxt);        
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
       AppConfiguration.Close();        
    }
}
