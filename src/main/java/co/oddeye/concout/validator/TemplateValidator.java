/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.validator;

import co.oddeye.concout.dao.HbaseDushboardTemplateDAO;
import co.oddeye.concout.model.DashboardTemplate;
import co.oddeye.core.globalFunctions;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

/**
 *
 * @author vahan
 */
@Component
public class TemplateValidator implements Validator {
    @Autowired
    private HbaseDushboardTemplateDAO TemplateDAO;
    
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(TemplateValidator.class);
    @Override
    public boolean supports(Class<?> type) {
        return DashboardTemplate.class.isAssignableFrom(type);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DashboardTemplate template = (DashboardTemplate) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "dashboard.empty", "Dashboard must not be empty.");        
        byte[] key;
        try {
            if (TemplateDAO.checkByName(template))
            {
                errors.rejectValue("name", "name.exist", "Name for user is exist.");
            }
        } catch (Exception ex) {
            LOGGER.error(globalFunctions.stackTrace(ex));
        }        
    }

}
