/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.helpers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import co.oddeye.concout.model.OddeyeUserModel;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base32;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
        private byte[] digest;
        private boolean status;
        private String message;
        private OddeyeUserModel userModel;
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
        public void setDigest(byte[] digest){
            this.digest = digest;
        }
        public byte[] getDigest(){
            return digest;
        }
        public ResetInfo setStatus(boolean status) {
            this.status = status;
            return this;
        }
        public ResetInfo setStatus(boolean status, String message) {
            this.status = status;
            this.message = message;
            return this;
        }
        public boolean getStatus() {
            return status;
        }
        public String getMessage(){
            return message;
        }
        public void setUserModel(OddeyeUserModel userModel) {
            this.userModel = userModel;
        }
        public OddeyeUserModel getUserModel() {
            return userModel;
        }
    }

    @Value("${passwordRecovery.secret}")
    public String passwordRecoverySecret;
    
    @Value("${passwordRecovery.emailTimeToLive}")
    public int passwordRecoveryEmailTimeToLive;
    
    private final static int BYTES_IN_LONG = 8;
    private final static int BYTES_IN_DIGEST = 20;
    private final static String algorithm = "AES/ECB/PKCS5Padding";
    
    private Cipher cipher;
    private Key key;
    
    @Autowired
    private HbaseUserDao userDao;

    
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
    
    public ResetInfo decodeToken(String receivedToken)  throws Exception {
        byte[] tokenBytes = decrypt(receivedToken);
        ByteBuffer bb = ByteBuffer.wrap(tokenBytes);

        ResetInfo resetInfo = new ResetInfo();
 
        resetInfo.setTimestamp(bb.getLong());
        
        byte[] decodedDigestBytes = new byte[BYTES_IN_DIGEST];
        bb.get(decodedDigestBytes, 0, BYTES_IN_DIGEST);
        resetInfo.setDigest(decodedDigestBytes);
        
        byte[] decodedEmailBytes = new byte[bb.remaining()];
        bb.get(decodedEmailBytes, 0, bb.remaining());
        resetInfo.setEmail(new String(decodedEmailBytes, "UTF-8"));
        
        return resetInfo;
    }
    
    public ResetInfo validateToken(String receivedToken) throws Exception {
            ResetInfo ri = decodeToken(receivedToken);
            ri.setStatus(true);
            long now = System.currentTimeMillis();
            if((now - ri.getTimestamp()) > (1000 * 60 * passwordRecoveryEmailTimeToLive))
                return ri.setStatus(false, "Email validity link expired");
                
            OddeyeUserDetails userDetails = userDao.getUserByEmail(ri.getEmail());
            if(null == userDetails)
                return ri.setStatus(false, "User not found");   
                
            OddeyeUserModel userModel = userDao.getUserByUUID(userDetails.getId());
            ri.setUserModel(userModel);
            byte[] calculatedDigestBytes =
                        getAttributesDigest(ri.getTimestamp(),
                                            ri.getEmail(),
                                            userModel);
            if(!Arrays.equals(ri.getDigest(), calculatedDigestBytes))
                return ri.setStatus(false, "Invalid recovery link");
            return ri;
    }
    
    public String encrypt(byte[] bytesToEncrypt)
    {
        try
        {
            cipher.init(Cipher.ENCRYPT_MODE, key);
            Base32 base32 = new Base32();
            return base32.encodeToString(cipher.doFinal(bytesToEncrypt));
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
            Base32 base32 = new Base32();
            return cipher.doFinal(base32.decode(strToDecrypt));
        }
        catch (Exception e)
        {
            System.out.println("Error while decrypting: " + e.toString());
        }
        return null;
    }
}
/*
captcha.on = true
captcha.secret=6LfUVzcUAAAAAIMxs6jz0GhGxgTCUD360UhcSbYr
captcha.sitekey=6LfUVzcUAAAAAAixePsdRSiy2dSagG7jcXQFgCcY

dash.rootuser=andriasyan@gmail.com
#dash.rootuser=admin@oddeye.co

# Secret key used to encript decript email password recovery token
passwordRecovery.secret=123456

# Validity period of password recovery email in minutes
passwordRecovery.emailTimeToLive=120
*/
