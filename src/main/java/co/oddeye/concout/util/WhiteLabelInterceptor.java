/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.util;

import co.oddeye.concout.beans.WhiteLabelResolver;
import javafx.scene.chart.PieChart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/**
 *
 * @author vahan
 */
public class WhiteLabelInterceptor extends HandlerInterceptorAdapter {

    @Autowired
    private WhiteLabelResolver whiteLabelResolver;

    @Override
    public void postHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler,
            ModelAndView modelAndView) throws Exception {
        if (modelAndView != null) {
            modelAndView.addObject("whitelabel", whiteLabelResolver);
        }

    }
}
