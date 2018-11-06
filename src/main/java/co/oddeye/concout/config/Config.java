/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.oddeye.concout.config;

import co.oddeye.concout.convertor.StringToDoubleConvertor;
import co.oddeye.concout.convertor.StringToOddeyeUserModelConverter;
import co.oddeye.concout.providers.ApplicationContextProvider;
import com.maxmind.geoip2.DatabaseReader;
import freemarker.template.TemplateException;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

/**
 *
 * @author vahan
 */
@Configuration
@ComponentScan("co.oddeye.concout")
@PropertySource("file:/etc/oddeye/dash.properties")
@EnableWebMvc
public class Config implements WebMvcConfigurer {

    @Value("${kafka.producer.bootstrap.servers}")
    private String producerServers;
    @Value("${kafka.producer.key.serializer}")
    private String producerKeySerializer;
    @Value("${kafka.producer.value.serializer}")
    private String producerValueSerializer;

    @Value("${geoipfile}")
    private String geoipfile;
    
    @Autowired
    StringToDoubleConvertor stringToDoubleConvertor;

    @Autowired
    StringToOddeyeUserModelConverter stringToOddeyeUserModelConverter;    
    
    protected static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(Config.class);

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addConverter(stringToDoubleConvertor);        
        registry.addConverter(stringToOddeyeUserModelConverter);        
    }    
    
    @Bean
    public UrlBasedViewResolver setupViewResolver() {
        UrlBasedViewResolver resolver = new UrlBasedViewResolver();
        resolver.setPrefix("/WEB-INF/jsp/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        return resolver;
    }

    @Bean
    public ProducerFactory<Integer, String> producerFactory() {
        return new DefaultKafkaProducerFactory<>(producerConfigs());
    }

    @Bean
    public Map<String, Object> producerConfigs() {
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, producerServers);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, producerKeySerializer);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, producerValueSerializer);
        return props;
    }

    @Bean
    public KafkaTemplate<Integer, String> kafkaTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**").addResourceLocations("/WEB-INF/resources/");
        registry.addResourceHandler("/assets/**").addResourceLocations("/WEB-INF/assets/");
    }

    @Bean(name = "freemarkerConfig")
    public FreeMarkerConfigurer getFreemarkerConfig() throws IOException, TemplateException {
        FreeMarkerConfigurer result = new FreeMarkerConfigurer();
        result.setTemplateLoaderPaths("/WEB-INF/ftl/"); // prevents FreeMarkerConfigurer from using its default path allowing setPrefix to work as expected
        return result;
    }

//    geoipfile
    @Bean(name = "geoip")
    public DatabaseReader getGeoip() throws IOException {
        File database = new File(geoipfile);
        DatabaseReader dbReader = new DatabaseReader.Builder(database).build();
        return dbReader;
    }

    @Bean(name = "messageSource")
    public MessageSource getMessageResource() {
        ReloadableResourceBundleMessageSource messageResource = new ReloadableResourceBundleMessageSource();
        // Read i18n/messages_xxx.properties file.
        // For example: i18n/messages_en.properties 
        messageResource.setBasename("classpath:i18n/messages");
        messageResource.setUseCodeAsDefaultMessage(true);
        messageResource.setDefaultEncoding("UTF-8");
        return messageResource;
    }

    @Bean(name = "localeResolver")
    public LocaleResolver getLocaleResolver() {
        SessionLocaleResolver slr = new SessionLocaleResolver();
        slr.setDefaultLocale(new Locale("en"));
        return slr;
    }

    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        LocaleChangeInterceptor lci = new LocaleChangeInterceptor();
        lci.setParamName("lang");
        return lci;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(localeChangeInterceptor());
    }

    @Bean
    public ApplicationContextProvider contextApplicationContextProvider() {
        return new ApplicationContextProvider();
    }
}
