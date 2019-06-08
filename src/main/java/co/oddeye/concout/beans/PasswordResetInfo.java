/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.beans;

/**
 *
 * @author sasha
 */
public class PasswordResetInfo {
    private String userName;
    private String email;
    private String password;
    private String passwordRepeat;
    private String recaptcha;
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    public String getUserName() {
        return userName;
    }   
    public void setEmail(String email) {
        this.email = email;
    }
    public String getEmail() {
        return email;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getPassword() {
        return password;
    }    
    public void setPasswordRepeat(String passwordRepeat) {
        this.passwordRepeat = passwordRepeat;
    }
    public String getPasswordRepeat() {
        return passwordRepeat;
    }
    public void setRecaptcha(String recaptcha) {
        this.recaptcha = recaptcha;
    }
    public String getRecaptcha() {
        return recaptcha;
    }
}
