/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.convertor;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

/**
 *
 * @author vahan
 */
@Component
public class StringToDoubleConvertor implements Converter<String, Double> {

    @Override
    public Double convert(String source) {
        if (source.isEmpty())
        {
            return null;
        }
        try {
        Double result = Double.parseDouble(source);
        return result;            
        } catch (Exception e) {
            
        }   
        return null;
    }
    
}
