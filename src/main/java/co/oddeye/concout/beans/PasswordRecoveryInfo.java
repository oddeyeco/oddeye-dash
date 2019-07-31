/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.beans;

import java.io.Serializable;

/**
 *
 * @author sasha
 */
public class PasswordRecoveryInfo  implements Serializable {
    private String email;
    private String recaptcha;
    public void setEmail(String email) {
        this.email = email;
    }
    public String getEmail() {
        return email;
    }
    public void setRecaptcha(String recaptcha) {
        this.recaptcha = recaptcha;
    }
    public String getRecaptcha() {
        return recaptcha;
    }
}
