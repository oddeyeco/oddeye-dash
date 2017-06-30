/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import java.util.HashMap;
import java.util.Map;
import org.apache.kafka.clients.producer.ProducerConfig;
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
public class BaseConfiguration {
    
    @Value("${kafka.producer.bootstrap.servers}")
    private String producerServers;        

    @Value("${kafka.producer.key.serializer}")
    private String producerKeySerializer;        

    @Value("${kafka.producer.value.serializer}")
    private String producerValueSerializer;        

    
    @Bean (name = "ProducerConfigs")
    public Map<String, String> getProducerConfigs() {
        Map<String, String> props = new HashMap<>();                 
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, producerServers);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, producerKeySerializer);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, producerValueSerializer);
        return props;
    }

    @Bean
    public static PropertySourcesPlaceholderConfigurer placeHolderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
}
