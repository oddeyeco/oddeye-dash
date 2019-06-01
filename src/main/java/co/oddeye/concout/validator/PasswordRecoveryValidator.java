/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.validator;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.validator.routines.EmailValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

/**
 *
 * @author sasha
 */
@Component
public class PasswordRecoveryValidator implements Validator {
    @Autowired
    private HbaseUserDao userDao;
    
    @Override
    public boolean supports(Class<?> clazz) {
        return OddeyeUserModel.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        String recoveryEmail = (String) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "email.empty", "Email address must not be empty.");
        if (!EmailValidator.getInstance().isValid(recoveryEmail)) {
            errors.rejectValue("email", "email.notValid", "Email address is not valid!");
        }
        try {
            OddeyeUserDetails userDetails = userDao.getUserByEmail(recoveryEmail);
            
            if (null == userDetails)
            {
                errors.rejectValue("email", "email.notExist", "Email address is not exist!");
            }
        } catch (Exception ex) {
            Logger.getLogger(UserValidator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
