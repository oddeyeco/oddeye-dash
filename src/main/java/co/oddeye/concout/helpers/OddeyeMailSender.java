/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.core.OddeyeMessage;
import co.oddeye.core.globalFunctions;
import freemarker.template.TemplateException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

/**
 *
 * @author vahan
 */
public class OddeyeMailSender extends JavaMailSenderImpl {

    @Autowired
    private FreeMarkerConfigurer freemarkerConfig;

    protected static final Logger LOGGER = LoggerFactory.getLogger(OddeyeMailSender.class);    
    private final String username;    
//    private final String password;    
//    private String from;    
//    private String host;    
//    private String auth;    
//    private String port;    
//    private String starttlsenable;
    
//    private final Properties javaMailProperties = new Properties();

    public OddeyeMailSender(String u) {
        username = u;
    }
    //oddeye.co@gmail.com
//    123asa!@#

    public void send(String subject, String text,String html, String toEmail) throws UnsupportedEncodingException {
        try {
//            MimeMessage message = this.createMimeMessage();
//            MimeMessageHelper helper = new MimeMessageHelper(message, true);
//            helper.setTo(new InternetAddress(toEmail));
//            helper.setFrom(new InternetAddress(username, "OddEye"));
//            helper.setText(text, true);
//            helper.setSubject(subject);

                MimeMessage message = new OddeyeMessage(getSession());
                message.addHeader("Content-type", "text/HTML; charset=UTF-8");
                message.addHeader("format", "flowed");
                message.addHeader("Content-Transfer-Encoding", "8bit");

                String pattern = "EEE, dd MMM yyyy HH:mm:ss Z";
                SimpleDateFormat format = new SimpleDateFormat(pattern);
                message.addHeader("Date", format.format(Calendar.getInstance().getTime()));

                // Set From: header field of the header.
                message.setFrom(new InternetAddress(username, "OddEye Co"));
                message.setReplyTo(InternetAddress.parse(username, false));

                // Set To: header field of the header.
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
                
                message.setSubject(subject);

                final MimeBodyPart textPart = new MimeBodyPart();
                textPart.setContent(text, "text/plain");
                // HTML version
                final MimeBodyPart htmlPart = new MimeBodyPart();
                htmlPart.setContent(html, "text/html");

                final Multipart mp = new MimeMultipart("alternative");
                mp.addBodyPart(textPart);
                mp.addBodyPart(htmlPart);
                // Send the actual HTML message, as big as you like
                message.setContent(mp);                

            this.send(message);

        } catch (MessagingException ex) {
            throw new RuntimeException(ex);
        }
    }

    public void send(String subject, String toEmail, String htmltemplatename,String txttemplatename, Object model) {

        try {
            String html = FreeMarkerTemplateUtils.processTemplateIntoString(freemarkerConfig.getConfiguration().getTemplate(htmltemplatename), model);
            String text = FreeMarkerTemplateUtils.processTemplateIntoString(freemarkerConfig.getConfiguration().getTemplate(txttemplatename), model);
            this.send(subject, text,html, toEmail);
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
