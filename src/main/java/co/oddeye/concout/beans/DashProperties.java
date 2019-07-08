/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.beans;

import java.io.Serializable;
import org.springframework.beans.factory.annotation.Value;

/**
 *
 * @author sasha
 */
public class DashProperties implements Serializable {
    @Value("${captcha.on}")
    public String captchaOn;    
    @Value("${captcha.secret}")
    public String captchaSecret;    
    @Value("${captcha.sitekey}")
    public String captchaSiteKey;
    
    public String getCaptchaOn() {
        return captchaOn;
    }

    public String getCaptchaSecret() {
        return captchaSecret;
    }

    public String getCaptchaSiteKey() {
        return captchaSiteKey;
    }

}
