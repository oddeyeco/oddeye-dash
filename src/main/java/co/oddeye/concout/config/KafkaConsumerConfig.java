/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.config.KafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.springframework.kafka.listener.ConcurrentMessageListenerContainer;

/**
 *
 * @author vahan
 */
@Configuration
@EnableKafka
public class KafkaConsumerConfig {

    @Bean
    KafkaListenerContainerFactory<ConcurrentMessageListenerContainer<Integer, String>> kafkaListenerContainerFactory() {
        
        ConcurrentKafkaListenerContainerFactory<Integer, String> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory());        
        factory.setConcurrency(3);
        factory.getContainerProperties().setPollTimeout(3000);        
        return factory;
    }

    @Bean
    public ConsumerFactory<Integer, String> consumerFactory() {
        
        return new DefaultKafkaConsumerFactory<>(consumerConfigs());
        
    }

    @Bean
    public Map<String, Object> consumerConfigs() {
        Map<String, Object> propsMap = new HashMap<>();
        propsMap.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "node0.netangels.net:9092,node1.netangels.net:9092,node2.netangels.net:9092"); //,node1.netangels.net:9092,node2.netangels.net:9092
        propsMap.put("zookeeper.connect", "nn1.netangels.net:2181,nn2.netangels.net:2181,rm1.netangels.net:2181");
        propsMap.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, true);
        propsMap.put(ConsumerConfig.AUTO_COMMIT_INTERVAL_MS_CONFIG, "1000");
        propsMap.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, "15000");
        propsMap.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, "50");
        propsMap.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, org.apache.kafka.common.serialization.StringDeserializer.class);
        propsMap.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, org.apache.kafka.common.serialization.StringDeserializer.class);        
        propsMap.put(ConsumerConfig.GROUP_ID_CONFIG, UUID.randomUUID().toString());
//        propsMap.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");//latest
        propsMap.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");//latest
        return propsMap;
    }

//    @Bean
//    public Listener listener() {
//        return new Listener();
//    }
}
