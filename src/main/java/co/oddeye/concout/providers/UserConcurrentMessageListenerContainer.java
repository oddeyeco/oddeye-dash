/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.providers;


import java.io.Serializable;
import org.apache.kafka.common.TopicPartition;

import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.listener.ConcurrentMessageListenerContainer;
import org.springframework.kafka.listener.config.ContainerProperties;

/**
 * Creates 1 or more {@link KafkaMessageListenerContainer}s based on
 * {@link #setConcurrency(int) concurrency}. If the
 * {@link ContainerProperties} is configured with {@link TopicPartition}s,
 * the {@link TopicPartition}s are distributed evenly across the
 * instances.
 *
 * @param <K> the key type.
 * @param <V> the value type.
 */
public class UserConcurrentMessageListenerContainer<K, V> extends ConcurrentMessageListenerContainer<K, V> implements Serializable{
    
    public UserConcurrentMessageListenerContainer(ConsumerFactory<K, V> consumerFactory, ContainerProperties containerProperties) {
        super(consumerFactory, containerProperties);
    }
    
}
