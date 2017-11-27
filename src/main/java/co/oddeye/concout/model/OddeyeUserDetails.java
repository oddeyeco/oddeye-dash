/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.model;

import co.oddeye.concout.dao.HbaseUserDao;
import java.util.Collection;
import java.util.UUID;
import javax.persistence.Id;
import org.springframework.context.ApplicationContext;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import co.oddeye.concout.providers.AppContext;
import javax.persistence.Transient;

/**
 *
 * @author vahan
 */
public class OddeyeUserDetails implements UserDetails {

    private static final long serialVersionUID = 465895478L;
    @Id
    private final String id;
//    private final transient HbaseUserDao Userdao;

    public OddeyeUserDetails(UUID uid, HbaseUserDao aThis) {
        id = uid.toString();
//        Userdao = aThis;
    }
    
    @Transient
    public OddeyeUserModel getUserModel() {

        ApplicationContext ctx = AppContext.getApplicationContext();
        Object Userdao = ctx.getBean("Userdao");
        return ((HbaseUserDao) Userdao).getUserByUUID(getId());
    }

    // Override metods
    @Transient
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return getUserModel().getAuthorities();
    }

    /**
     * @param authorities the authorities to set
     */
    @Transient
    public void setAuthorities(Collection<GrantedAuthority> authorities) {
        getUserModel().setAuthorities(authorities);
    }

    @Transient
    @Override
    public String getPassword() {
//        String pass = "";
        return getUserModel().getPasswordst();
    }

    @Transient
    @Override
    public String getUsername() {
        return getUserModel().getEmail();
    }

    @Transient
    @Override
    public boolean isAccountNonExpired() {
        return getUserModel().getActive();
    }

    @Transient
    @Override
    public boolean isAccountNonLocked() {
        return getUserModel().getActive();
    }

    @Transient
    @Override
    public boolean isCredentialsNonExpired() {
        return getUserModel().getActive();
    }

    @Transient
    @Override
    public boolean isEnabled() {
        return getUserModel().getActive();
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

}
