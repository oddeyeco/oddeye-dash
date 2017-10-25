/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 *
 * @author vahan
 */
@ResponseStatus(value=HttpStatus.NOT_FOUND,reason="dasdasdsa")
public class ResourceNotFoundException extends RuntimeException {  
    private static final long serialVersionUID = 465895478L;
    public ResourceNotFoundException(String message) {
        super(message);        
    }    
}
