/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Session;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;

/**
 *
 * @author vahan
 */

@Component
public class mailSender {
    private final String username;
    private final String password;
    private final Properties props;
 
    public mailSender() {
        this.username = "noreply@oddeye.co";
        this.password = "Rembo3Rembo4";
 
        props = new Properties();
        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "mail.netangels.net");
        props.put("mail.smtp.port", "25");
    }
 //oddeye.co@gmail.com
//    123asa!@#
    public void send(String subject, String text, String toEmail) throws UnsupportedEncodingException{
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
 
        try {
            Message message = new MimeMessage(session);
            //от кого
            message.setFrom(new InternetAddress(username,"OddEye"));
            //кому
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            //Заголовок письма
            message.setSubject(subject);
            //Содержимое
            message.setContent(text, "text/html");
 
            //Отправляем сообщение
            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }    

    public String getBaseurl(HttpServletRequest request) {
        return String.format("%s://%s"+request.getContextPath(),"https",  getServerName(request));
    }
    
    private String getServerName(HttpServletRequest request)
    {
        String Host = request.getHeader("X-OddEye-Host");
        if (Host != null)
        {
            return Host;             
        }
        
        return request.getServerName();
    }
}
