/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import co.oddeye.concout.dao.BaseTsdbConnect;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;

/**
 *
 * @author vahan
 */
@Configuration
@PropertySource("config.properties")
public class DatabaseConfig {

    @Value("${tsdb.quorum}")
    private String tsdbQuorum;

    @Bean
    public BaseTsdbConnect BaseTsdb()
    {
       Map<String, String> attr = new HashMap<>();
       attr.put("tsdb.quorum", tsdbQuorum);
       return new BaseTsdbConnect(attr);
    }
    
    @Bean
    public static PropertySourcesPlaceholderConfigurer
            propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

}
