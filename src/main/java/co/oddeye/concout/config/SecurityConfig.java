/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

/**
 *
 * @author vahan
 */
import co.oddeye.concout.providers.HbaseAuthenticationProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.*;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.*;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

//    @Autowired
//    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {        
//        auth
//                .inMemoryAuthentication()
//                .withUser("user").password("password").roles("USER");
//    }
    @Autowired
    private HbaseAuthenticationProvider authProvider;

    @Autowired
    protected void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(authProvider);
    }
//http://www.baeldung.com/spring-security-authentication-provider
    //.antMatchers("/hosts").hasAnyAuthority("ROLE_ADMIN")

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .logout().logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .logoutSuccessUrl("/login").deleteCookies("JSESSIONID")
                .invalidateHttpSession(true);
        http
                .authorizeRequests()
                .antMatchers("/resources/**", "/assets/**", "/signup/", "/", "/confirm/**").permitAll()
                .antMatchers("/getfiltredmetrics*").permitAll()
                .antMatchers("/getdata*").permitAll()
                .antMatchers("/gettagkey*").permitAll()
                .antMatchers("/gettagvalue*").permitAll()
                .antMatchers("/test").permitAll()
                .antMatchers("/subscribe/**").permitAll()
                .antMatchers("/userslist*").hasAnyAuthority("ROLE_USERMANAGER")
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginPage("/login")
                .permitAll();

    }
}
