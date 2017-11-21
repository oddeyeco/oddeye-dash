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
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

/**
 *
 * @author vahan
 */
public class OddeyeUserDetails implements UserDetails {
    private static final long serialVersionUID = 465895478L;
    @Id
    private UUID id;        
    private final transient HbaseUserDao Userdao;

    public OddeyeUserDetails(UUID uid, HbaseUserDao aThis) {
        id = uid;
        Userdao = aThis;
    }
    
    public OddeyeUserModel getUserModel()
    {
        return Userdao.getUserByUUID(getId());
    }
    // Override metods
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return getUserModel().getAuthorities();
    }

    /**
     * @param authorities the authorities to set
     */
    public void setAuthorities(Collection<GrantedAuthority> authorities) {
       getUserModel().setAuthorities(authorities);
    }

    @Override
    public String getPassword() {
//        String pass = "";
        return getUserModel().getPasswordst();
    }

    @Override
    public String getUsername() {
        return getUserModel().getEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return getUserModel().getActive();
    }

    @Override
    public boolean isAccountNonLocked() {
        return  getUserModel().getActive();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return  getUserModel().getActive();
    }

    @Override
    public boolean isEnabled() {
        return  getUserModel().getActive();
    }

    /**
     * @return the id
     */
    public UUID getId() {
        return id;
    }
    
}
