/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.model.OddeyeUserModel;
import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import static java.util.Collections.list;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 *
 * @author sasha
 */
@Component
public class PasswordResetTokenEncoder {
    @Value("${passwordRecovery.secret}")
    public String passwordRecoverySecret;
    
    private String algorithm = "AES/ECB/PKCS5Padding";
    
    private Cipher cipher;
    private Key key;
    
    private static final Logger LOG = LoggerFactory.getLogger(PasswordResetTokenEncoder.class);
    
    @PostConstruct
    public void init() {
        try {
            cipher = Cipher.getInstance(algorithm);
            byte[] tempKey;
            MessageDigest sha = null;
            tempKey = passwordRecoverySecret.getBytes("UTF-8");
            sha = MessageDigest.getInstance("SHA-1");
            tempKey = sha.digest(tempKey);
            tempKey = Arrays.copyOf(tempKey, 16);
            key = new SecretKeySpec(tempKey, "AES");
        } catch(NoSuchAlgorithmException | NoSuchPaddingException | UnsupportedEncodingException e) {
            LOG.error("Failed to initialize java Cipher", e);
            throw new RuntimeException(e);
        }
    }
    
    private String getAttributesDigest(
            String timestamp,
            String email,
            OddeyeUserModel userModel) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        MessageDigest sha = MessageDigest.getInstance("SHA-1");
        StringBuilder sb = new StringBuilder();
                
        sb.append(timestamp);
        sb.append(email);
        sb.append(userModel.getCountry());
        sb.append(userModel.getCity());
        sb.append(userModel.getCompany());
        sb.append(userModel.getName());
        sb.append(userModel.getLastname());
        sb.append(userModel.getOldpassword());
        sb.append(passwordRecoverySecret);
        
        byte[] sbByteArray = sb.toString().getBytes("UTF-8");
        return Base64.getEncoder().encodeToString(sbByteArray);
    }
    
    public String createRecoveryToken(String timestamp, OddeyeUserModel userModel) throws Exception {
       return getAttributesDigest(timestamp, userModel.getEmail(), userModel);
    }
    
    public boolean isTokenValid(String timestamp, String email, String receivedToken, OddeyeUserModel userModel)  throws Exception {
        String calculatedToken = getAttributesDigest(timestamp, email, userModel);
        return calculatedToken != null && calculatedToken.equals(receivedToken);
    }
    
    public String encrypt(String strToEncrypt)
    {
        try
        {
            cipher.init(Cipher.ENCRYPT_MODE, key);
            return Base64.getEncoder().encodeToString(cipher.doFinal(strToEncrypt.getBytes("UTF-8")));
        }
        catch (Exception e)
        {
            System.out.println("Error while encrypting: " + e.toString());
        }
        return null;
    }
 
    public String decrypt(String strToDecrypt)
    {
        try
        {
            cipher.init(Cipher.DECRYPT_MODE, key);
            return new String(cipher.doFinal(Base64.getDecoder().decode(strToDecrypt)));
        }
        catch (Exception e)
        {
            System.out.println("Error while decrypting: " + e.toString());
        }
        return null;
    }
}
