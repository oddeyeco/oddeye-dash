/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.model.OddeyeUserModel;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.Base64;
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
    public class ResetInfo {
        private long timestamp;
        private String email;
        private boolean ok;
        public void setTimestamp(long timestamp){
            this.timestamp = timestamp;
        }
        public long getTimestamp(){
            return timestamp;
        }
        public void setEmail(String email){
            this.email = email;
        }
        public String getEmail(){
            return email;
        }
        public void setOk(boolean ok){
            this.ok = ok;
        }
        public boolean isOk(){
            return ok;
        }
    }

    @Value("${passwordRecovery.secret}")
    public String passwordRecoverySecret;
    
    private final static int BYTES_IN_LONG = 8;
    private final static int BYTES_IN_DIGEST = 20;
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
    
    private byte[] getAttributesDigest(
            long timestamp,
            String email,
            OddeyeUserModel userModel) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        MessageDigest sha = MessageDigest.getInstance("SHA-1");
        StringBuilder sb = new StringBuilder();
                
        sb.append(timestamp);
        sb.append(email);
        sb.append(userModel.getCountry());
        sb.append(userModel.getRegion());
        sb.append(userModel.getCity());
        sb.append(userModel.getCompany());
        sb.append(userModel.getName());
        sb.append(userModel.getLastname());
        sb.append(userModel.getPassword());
        sb.append(userModel.getOldpassword());
        sb.append(passwordRecoverySecret);
        
        return sha.digest(sb.toString().getBytes("UTF-8"));
    }
    
    public String createRecoveryToken(OddeyeUserModel userModel) throws Exception {
        long timestamp = System.currentTimeMillis();
        byte[] digestBytes = getAttributesDigest(timestamp, userModel.getEmail(), userModel);
        byte[] emailBytes = userModel.getEmail().getBytes("UTF-8");
        ByteBuffer bb = ByteBuffer.allocate(BYTES_IN_LONG + BYTES_IN_DIGEST + emailBytes.length);
        
        bb.putLong(timestamp);
        bb.put(digestBytes);
        bb.put(emailBytes);
        
        return encrypt(bb.array());
    }
    
    public ResetInfo decodeToken(String receivedToken, OddeyeUserModel userModel)  throws Exception {
        byte[] tokenBytes = decrypt(receivedToken);
        ByteBuffer bb = ByteBuffer.wrap(tokenBytes);
        
        long decodedTimestamp = bb.getLong();
        byte[] decodedDigestBytes = new byte[BYTES_IN_DIGEST];
        bb.get(decodedDigestBytes, 0, BYTES_IN_DIGEST);
        
        byte[] decodedEmailBytes = new byte[bb.remaining()];
        bb.get(decodedEmailBytes, 0, bb.remaining());

        String email = new String(decodedEmailBytes, "UTF-8");
        byte[] calculatedDigestBytes = getAttributesDigest(decodedTimestamp, email, userModel);

        ResetInfo resetInfo = new ResetInfo();
        if(Arrays.equals(decodedDigestBytes, calculatedDigestBytes)) {
            resetInfo.setTimestamp(decodedTimestamp);
            resetInfo.setEmail(email);
            resetInfo.setOk(true);
        } else {
            resetInfo.setOk(false);            
        }
        
        return resetInfo;
    }
    
    public String encrypt(byte[] bytesToEncrypt)
    {
        try
        {
            cipher.init(Cipher.ENCRYPT_MODE, key);
            return Base64.getEncoder().encodeToString(cipher.doFinal(bytesToEncrypt));
        }
        catch (Exception e)
        {
            System.out.println("Error while encrypting: " + e.toString());
        }
        return null;
    }
 
    public byte[] decrypt(String strToDecrypt)
    {
        try
        {
            cipher.init(Cipher.DECRYPT_MODE, key);
            return cipher.doFinal(Base64.getDecoder().decode(strToDecrypt));
        }
        catch (Exception e)
        {
            System.out.println("Error while decrypting: " + e.toString());
        }
        return null;
    }
}
