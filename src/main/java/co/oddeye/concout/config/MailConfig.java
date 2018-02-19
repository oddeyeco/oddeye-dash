/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import co.oddeye.concout.helpers.OddeyeMailSender;
import java.util.Properties;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

/**
 *
 * @author vahan
 */
@Configuration
@PropertySource("file:/etc/oddeye/dash.properties")
public class MailConfig {

    @Value("${mail.user}")
    private String username;
    @Value("${mail.password}")
    private String password;

    @Value("${mail.from}")
    private String from;
    @Value("${mail.smtp.host}")
    private String host;
    @Value("${mail.smtp.auth}")
    private String auth;
    @Value("${mail.smtp.port}")
    private String port;
    @Value("${mail.smtp.starttls.enable}")
    private String starttlsenable;

    @Bean
    public OddeyeMailSender mailSender() {

        OddeyeMailSender Sender = new OddeyeMailSender(from);

        Sender.setHost(host);
        Sender.setPort(Integer.parseInt(port));
        Sender.setUsername(this.username);
        Sender.setPassword(this.password);
        Properties javaMailProperties = new Properties();
        javaMailProperties.put("mail.smtp.auth", auth);
//        javaMailProperties.put("mail.smtp.starttls.enable", starttlsenable);
        javaMailProperties.put("mail.smtp.socketFactory.port", port);
        javaMailProperties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        javaMailProperties.put("mail.smtp.host", host);
        javaMailProperties.put("mail.smtp.port", port);
        javaMailProperties.put("mail.user", this.username);
        Sender.setJavaMailProperties(javaMailProperties);
        return Sender;
    }
}
