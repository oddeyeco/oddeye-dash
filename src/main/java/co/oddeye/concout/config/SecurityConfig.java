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
import co.oddeye.concout.providers.StickySesionCookieFilter;
import co.oddeye.concout.providers.UserDetailsServiceImpl;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.security.authentication.AuthenticationDetailsSource;
import org.springframework.security.config.annotation.authentication.builders.*;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.*;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@PropertySource("file:/opt/jetty/oddeye/dash.properties")
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Value("${sesion.cookie.name}")
    private String cookiename;
    @Value("${sesion.cookie.value}")
    private String cookievalue;
    
    
    @Autowired
    private HbaseAuthenticationProvider authProvider;
    @Autowired
    private UserDetailsServiceImpl userService;
    @Autowired
    protected void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(authProvider);        

    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
//        http.userDetailsService(userService);
        http
                .logout().logoutRequestMatcher(new AntPathRequestMatcher("/logout/"))
                .logoutSuccessUrl("/login/").deleteCookies("JSESSIONID")
                .invalidateHttpSession(true).and()
                .rememberMe().userDetailsService(userService).tokenValiditySeconds(1209600);
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
                .antMatchers("/user/switch/**").hasAnyAuthority("ROLE_CAN_SWICH")
                .antMatchers("/templatelist*").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/getmetastat/*").hasAnyAuthority("ROLE_USERMANAGER")
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .authenticationDetailsSource(authenticationDetailsSource())
                .loginPage("/login/")
                .permitAll()
                .and().addFilterBefore(new StickySesionCookieFilter(cookiename,cookievalue),UsernamePasswordAuthenticationFilter.class);

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
