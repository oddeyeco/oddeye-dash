/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;
import org.springframework.security.web.context.*;
import org.springframework.web.context.support.GenericWebApplicationContext;
import org.springframework.web.multipart.support.MultipartFilter;
import org.springframework.web.servlet.DispatcherServlet;

/**
 *
 * @author vahan JETTY-i aranc sra chi asxatum
 */
public class SecurityWebApplicationInitializer extends AbstractSecurityWebApplicationInitializer {

    private String TMP_FOLDER = "/tmp";
    private int MAX_UPLOAD_SIZE = 5 * 1024 * 1024;

//    @Override
//    protected void beforeSpringSecurityFilterChain(ServletContext servletContext) {
//        ServletRegistration.Dynamic appServlet = servletContext.addServlet("mvc", new DispatcherServlet(
//                new GenericWebApplicationContext()));
//
//        appServlet.setLoadOnStartup(1);
//
//        MultipartConfigElement multipartConfigElement = new MultipartConfigElement(TMP_FOLDER,
//                MAX_UPLOAD_SIZE, MAX_UPLOAD_SIZE * 2, MAX_UPLOAD_SIZE / 2);
//
//        appServlet.setMultipartConfig(multipartConfigElement);
//        insertFilters(servletContext, new MultipartFilter());
//    }

}
