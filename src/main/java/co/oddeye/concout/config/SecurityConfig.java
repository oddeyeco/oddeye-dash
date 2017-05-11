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
import co.oddeye.concout.providers.OddeyeWebAuthenticationDetails;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationDetailsSource;
import org.springframework.security.config.annotation.authentication.builders.*;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.*;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
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

        //.userDetailsService(this)
    }
//http://www.baeldung.com/spring-security-authentication-provider
    //.antMatchers("/hosts").hasAnyAuthority("ROLE_ADMIN")

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .logout().logoutRequestMatcher(new AntPathRequestMatcher("/logout/"))
                .logoutSuccessUrl("/login/").deleteCookies("JSESSIONID")
                .invalidateHttpSession(true);
        http
                .authorizeRequests()
                .antMatchers("/resources/**", "/assets/**", "/signup/", "/", "/confirm/**", "/about/**", "/pricing/**", "/documentation/**", "/faq/**", "/contact/**", "/gugush.txt").permitAll()
                .antMatchers("/getfiltredmetrics*").permitAll()
                .antMatchers("/getdata*").permitAll()
                .antMatchers("/gettagkey*").permitAll()
                .antMatchers("/gettagvalue*").permitAll()
                .antMatchers("/test").permitAll()
                .antMatchers("/subscribe/**").permitAll()
                .antMatchers("/userslist*").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/user/**").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/templatelist*").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/getmetastat/*").hasAnyAuthority("ROLE_USERMANAGER")
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .authenticationDetailsSource(authenticationDetailsSource())
                .loginPage("/login/")
                .permitAll();

    }
    
    private AuthenticationDetailsSource<HttpServletRequest, WebAuthenticationDetails> authenticationDetailsSource() {

        return new AuthenticationDetailsSource<HttpServletRequest, WebAuthenticationDetails>() {
            @Override
            public OddeyeWebAuthenticationDetails buildDetails(
                    HttpServletRequest request) {
                return new OddeyeWebAuthenticationDetails(request);
            }

        };
    }    
}
