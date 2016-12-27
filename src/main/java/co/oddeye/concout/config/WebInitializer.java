/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import java.io.File;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import org.apache.log4j.PropertyConfigurator;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

/**
 *
 * @author vahan
 */
public class WebInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{Config.class, SecurityConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return null;
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        String log4jConfigFile = servletContext.getInitParameter("log4jConfigLocation");
        String fullPath = servletContext.getRealPath("") + log4jConfigFile;
        final File f = new File(fullPath);
        if (f.exists()) {
            PropertyConfigurator.configure(fullPath);
            servletContext.addListener(org.springframework.web.util.Log4jConfigListener.class); 
        }
        super.onStartup(servletContext);
    }

}
