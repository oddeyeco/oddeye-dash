/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.model.DashboardTemplate;
import co.oddeye.core.globalFunctions;
import freemarker.template.Configuration;
import freemarker.template.TemplateException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Session;
import javax.mail.Message;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessagePreparator;

import javax.mail.Transport;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.ui.freemarker.FreeMarkerConfigurationFactory;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

/**
 *
 * @author vahan
 */
@Component
public class mailSender extends JavaMailSenderImpl {
    
    @Autowired
    private FreeMarkerConfigurer freemarkerConfig;
    
    protected static final Logger LOGGER = LoggerFactory.getLogger(mailSender.class);
    private final String username;
    private final String password;
    private final Properties props;
    
    public mailSender() {
        this.username = "noreply@oddeye.co";
        this.password = "Rembo3Rembo4";
        this.setHost("mail.netangels.net");
        this.setPort(25);
        this.setUsername(this.username);
        this.setPassword(this.password);
        
        props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "false");
//        props.put("mail.smtp.host", "mail.netangels.net");
//        props.put("mail.smtp.port", "25");
        this.setJavaMailProperties(props);
    }
    //oddeye.co@gmail.com
//    123asa!@#

    public void send(String subject, String text, String toEmail) throws UnsupportedEncodingException {
        try {
            //        Session session = Session.getInstance(props, new Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(username, password);
//            }
//        });

//        MimeMessagePreparator preparator = new MimeMessagePreparator() {
//
//            public void prepare(MimeMessage mimeMessage) throws Exception {
//
//                mimeMessage.setRecipient(Message.RecipientType.TO,
//                        new InternetAddress(toEmail));
//                mimeMessage.setFrom(new InternetAddress(username, "OddEye"));
//                mimeMessage.setText(text);
//                mimeMessage.setSubject(subject);
//            }
//        };
            MimeMessage message = this.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(new InternetAddress(toEmail));
            helper.setFrom(new InternetAddress(username, "OddEye"));
            helper.setText(text, true);
            helper.setSubject(subject);
            this.send(message);

//        try {
//            Message message = new MimeMessage(session);
//            //от кого
//            message.setFrom(new InternetAddress(username,"OddEye"));
//            //кому
//            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
//            //Заголовок письма
//            message.setSubject(subject);
//            //Содержимое
//            message.setContent(text, "text/html");
// 
//            //Отправляем сообщение
//            Transport.send(message);
//        } catch (MessagingException e) {
//            throw new RuntimeException(e);
//        }
        } catch (MessagingException ex) {
            throw new RuntimeException(ex);
        }
    }
    
    public void send(String subject, String toEmail, String templatename, Object model) {
        
        try {
            String text = FreeMarkerTemplateUtils.processTemplateIntoString(freemarkerConfig.getConfiguration().getTemplate(templatename), model);            
            this.send(subject, text, toEmail);
        } catch (TemplateException | IOException e) {
            LOGGER.error(globalFunctions.stackTrace(e));
        }
        
    }
    
    public String getBaseurl(HttpServletRequest request) {
        return String.format("%s://%s" + request.getContextPath(), "https", getServerName(request));
    }
    
    private String getServerName(HttpServletRequest request) {
        String Host = request.getHeader("X-OddEye-Host");
        if (Host != null) {
            return Host;
        }
        
        return request.getServerName();
    }
}
