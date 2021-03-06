/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.validator;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserModel;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.springframework.validation.Validator;
import org.apache.commons.validator.routines.EmailValidator;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author vahan
 */
@Component
public class UserValidator implements Validator {
    @Autowired
    private HbaseUserDao Userdao;
    
    @Override
    public boolean supports(Class<?> clazz) {
        return OddeyeUserModel.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        OddeyeUserModel user = (OddeyeUserModel) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "name.empty", "Username must not be empty.");
        String username = user.getName();

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "passwordst", "password.empty", "Password must not be empty.");
        if (!(user.getPasswordst()).equals(user.getPasswordsecondst())) {
            errors.rejectValue("passwordsecond", "passwordsecond.passwordDontMatch", "Passwords don't match.");
        }

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "email.empty", "Email address must not be empty.");
        if (!EmailValidator.getInstance().isValid(user.getEmail())) {
            errors.rejectValue("email", "email.notValid", "Email address is not valid.");
        }
        try {
            if (Userdao.checkUserByEmail(user))
            {
                errors.rejectValue("email", "email.Exist", "Email address is exist.");
            }
        } catch (Exception ex) {
            Logger.getLogger(UserValidator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void adminCreateValidate(Object target, Errors errors) {
        OddeyeUserModel user = (OddeyeUserModel) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "name.empty", "Username must not be empty.");
        String username = user.getName();
        
        if (!(user.getPasswordst()).equals(user.getPasswordsecondst())) {
            errors.rejectValue("passwordsecond", "passwordsecond.passwordDontMatch", "Passwords don't match.");
        }

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "email.empty", "Email address must not be empty.");
        if (!EmailValidator.getInstance().isValid(user.getEmail())) {
            errors.rejectValue("email", "email.notValid", "Email address is not valid.");
        }
        try {
            if (Userdao.checkUserByEmail(user))
            {
                errors.rejectValue("email", "email.Exist", "Email address is exist.");
            }
        } catch (Exception ex) {
            Logger.getLogger(UserValidator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }    
    
    public void adminvalidate(Object target, Errors errors) {
        OddeyeUserModel user = (OddeyeUserModel) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "name.empty", "Username must not be empty.");
        String username = user.getName();
        
        if (!(user.getPasswordst()).equals(user.getPasswordsecondst())) {
            errors.rejectValue("passwordsecond", "passwordsecond.passwordDontMatch", "Passwords don't match.");
        }

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "email.empty", "Email address must not be empty.");
        if (!EmailValidator.getInstance().isValid(user.getEmail())) {
            errors.rejectValue("email", "email.notValid", "Email address is not valid.");
        }
        try {
            if (Userdao.checkUserByEmail(user))
            {
                errors.rejectValue("email", "email.Exist", "Email address is exist.");
            }
        } catch (Exception ex) {
            Logger.getLogger(UserValidator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }    
    
    public void updatevalidate(Object target, Errors errors,OddeyeUserModel userold) {
        OddeyeUserModel user = (OddeyeUserModel) target;
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "name.empty", "Username must not be empty.");   
        if (userold.getEmail().equals("demodemo@oddeye.co")) {
            errors.rejectValue("name", "demo.user", "Demo user must not be edited .");   
        }
    }    
    
    public void passwordvalidate(Object target,Object selftarget, Errors errors) {
        OddeyeUserModel user = (OddeyeUserModel) target;
        OddeyeUserModel selfuser = (OddeyeUserModel) selftarget;
        if (selfuser.getEmail().equals("demodemo@oddeye.co"))
        {
            errors.rejectValue("oldpassword", "oldpassword.isdemo", "password demodemo@oddeye.co is readonly.");
        }
        
        if (!(user.getOldpasswordst(selfuser)).equals(selfuser.getPasswordst())) {
            errors.rejectValue("oldpassword", "oldpassword.invalidPassword", "Invalid password.");
        }        
        
        if (!(user.getPasswordst()).equals(user.getPasswordsecondst())) {
            errors.rejectValue("passwordsecond", "passwordsecond.passwordMismatch", "Passwords mismatch.");
        }

    }
    public void passwordResetValidate(OddeyeUserModel user,OddeyeUserModel selfuser, Errors errors) {
        if (selfuser.getEmail().equals("demodemo@oddeye.co"))
        {
            errors.rejectValue("password", "oldpassword.isdemo", "password demodemo@oddeye.co is readonly.");
        }
        
        if (!(user.getPasswordst()).equals(user.getPasswordsecondst())) {
            errors.rejectValue("passwordRepeat", "passwordsecond.passwordMismatch", "Passwords mismatch.");
        }
    }    
}
