/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

/**
 *
 * @author vahan
 */
public class WebInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{Config.class,SecurityConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return null;
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }

//    @Override
//    public void onStartup(ServletContext servletContext) throws ServletException {
//        AnnotationConfigWebApplicationContext ctx = new AnnotationConfigWebApplicationContext();
//        ctx.register(Config.class);
//        ctx.setServletContext(servletContext);
//        Dynamic servlet = servletContext.addServlet("dispatcher", new DispatcherServlet(ctx));
//        servlet.addMapping("/");
//        servlet.setLoadOnStartup(1);
//    }

}
