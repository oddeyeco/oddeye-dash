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
import co.oddeye.concout.providers.RefererRedirectionAuthenticationSuccessHandler;
import co.oddeye.concout.providers.UserDetailsServiceImpl;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationDetailsSource;
import org.springframework.security.config.annotation.authentication.builders.*;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.*;
import org.springframework.security.web.access.intercept.FilterSecurityInterceptor;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.authentication.switchuser.SwitchUserFilter;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.filter.CharacterEncodingFilter;

@Configuration
@EnableWebSecurity
@PropertySource("file:/etc/oddeye/dash.properties")
public class SecurityConfig extends WebSecurityConfigurerAdapter {

//    @Value("${sesion.cookie.name}")
//    private String cookiename;
//    @Value("${sesion.cookie.value}")
//    private String cookievalue;
//    @Autowired
//    private HbaseAuthenticationProvider authProvider;
    @Autowired
    private UserDetailsServiceImpl userService;

    @Autowired
    protected void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userService);
        auth.authenticationProvider(authProvider());
    }
    
    @Bean
    public HbaseAuthenticationProvider authProvider() {
        HbaseAuthenticationProvider authenticationProvider = new HbaseAuthenticationProvider();
        authenticationProvider.setUserDetailsService(userService);
//        authenticationProvider.setPasswordEncoder(passwordEncoder());
        return authenticationProvider;
    }
    
    
    @Bean
    public SwitchUserFilter switchUserFilter() {

        SwitchUserFilter filter = new SwitchUserFilter();

        filter.setUserDetailsService(userService);

        filter.setSwitchUserUrl("/impersonate/login");
        
        filter.setExitUserUrl("/impersonate/logout");

        filter.setSwitchFailureUrl("/");

        filter.setTargetUrl("/dashboard/");

        return filter;
    }    
 
    // http://localhost:8080/OddeyeCoconut/impersonate/login?username=test%40mail.ru
    @Override
    protected void configure(HttpSecurity http) throws Exception {
//        http.userDetailsService(userService);
        http
                .logout().logoutRequestMatcher(new AntPathRequestMatcher("/logout/"))
                .logoutSuccessUrl("/login/").deleteCookies("JSESSIONID")
                .invalidateHttpSession(true);
        http
                .addFilterAfter(switchUserFilter(), FilterSecurityInterceptor.class)                
                .authorizeRequests()
                .antMatchers("/calculator/**", "/resources/**", "/assets/**", "/signup/", "/",
                        "/confirm/**", "/psreset/**", "/pschange/**", "/about/**", "/pricing/**", "/documentation/**",
                        "/faq/**", "/contact/**", "/login/**", "/psrecovery/"/*, "/gugush.txt"*/).permitAll()
                .antMatchers("/getstat*", "/getpayinfo*").permitAll()
                //                .antMatchers("/getdata*").permitAll()
                //                .antMatchers("/gettagkey*").permitAll()
                //                .antMatchers("/gettagvalue*").permitAll()
                .antMatchers("/test", "/demomb/").permitAll()
                
                
                .antMatchers(HttpMethod.POST, "/paypal/ipn/**").permitAll()
                .antMatchers("/subscribe/**").permitAll()
                .antMatchers("/userslist*", "/paymentslist/**").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/user/**").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/whitelable/**").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/user/switch/**").hasAnyAuthority("ROLE_CAN_SWICH")
                .antMatchers("/templatelist*").hasAnyAuthority("ROLE_USERMANAGER")
                .antMatchers("/getmetastat/*").hasAnyAuthority("ROLE_USERMANAGER")
                
                .antMatchers("/impersonate/login/**").hasAnyAuthority("ROLE_CAN_SWICH")
                .antMatchers("/impersonate/logout/**").hasAnyAuthority("ROLE_PREVIOUS_ADMINISTRATOR")                 
               
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .authenticationDetailsSource(authenticationDetailsSource())
                .successHandler(new RefererRedirectionAuthenticationSuccessHandler())
                .loginPage("/login/").permitAll()
                .and().rememberMe().userDetailsService(userService).tokenValiditySeconds(1209600)
                .and().csrf().ignoringAntMatchers("/paypal/ipn/**");
//                .and().addFilterBefore(new StickySesionCookieFilter(cookiename,cookievalue),UsernamePasswordAuthenticationFilter.class);

        CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
        encodingFilter.setEncoding("UTF-8");
        encodingFilter.setForceEncoding(true);

        http.addFilterBefore(encodingFilter, CsrfFilter.class);

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
