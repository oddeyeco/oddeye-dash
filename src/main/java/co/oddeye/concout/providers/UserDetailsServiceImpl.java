/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;

import co.oddeye.concout.dao.HbaseUserDao;
import co.oddeye.concout.model.OddeyeUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 *
 * @author vahan
 */
@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    HbaseUserDao UserDao;

    public UserDetailsServiceImpl() {
        super();
    }    
    
    @Override
    public UserDetails loadUserByUsername(String string) throws UsernameNotFoundException {
        OddeyeUserDetails user = UserDao.getUserByEmail(string);
        return user;
    }



}