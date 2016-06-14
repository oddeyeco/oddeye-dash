/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;

import co.oddeye.concout.model.User;
import org.springframework.validation.Validator;
import org.apache.commons.validator.routines.EmailValidator;

/**
 *
 * @author vahan
 */
@Component
public class UserValidator implements Validator {

    public boolean supports(Class<?> clazz) {
        return User.class.isAssignableFrom(clazz);
    }

    public void validate(Object target, Errors errors) {
        User user = (User) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "name.empty", "Username must not be empty.");
        String username = user.getName();
        if ((username.length()) > 16) {
            errors.rejectValue("username", "username.tooLong", "Username must not more than 16 characters.");
        }

//		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "password", "password.empty", "Password must not be empty.");
        if (!(user.getPassword()).equals(user.getPasswordsecond())) {
            errors.rejectValue("confirmPassword", "confirmPassword.passwordDontMatch", "Passwords don't match.");
        }

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "email.empty", "Email address must not be empty.");
        if (!EmailValidator.getInstance().isValid(user.getEmail())) {
            errors.rejectValue("email", "email.notValid", "Email address is not valid.");
        }
    }
}
