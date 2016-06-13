/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.controllers;


import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author vahan
 */
@Controller
public class DefaultController {
    
   @RequestMapping(value = "/", method = RequestMethod.GET)
   public String index(ModelMap map) {           
       map.put("body", "dashboard");
       return "index";
   }
    
   @RequestMapping(value = "/{templatename}", method = RequestMethod.GET)
   public String bytemplate(@PathVariable(value = "templatename") String templatename,ModelMap map) {       
       map.put("body", templatename);
       return "index";
   }   
}
