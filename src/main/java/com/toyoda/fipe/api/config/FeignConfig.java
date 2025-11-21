package com.toyoda.fipe.api.config;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import feign.Logger;
import feign.Request;
import feign.RequestInterceptor;
import feign.Retryer;
import feign.codec.Decoder;
import feign.codec.ErrorDecoder;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.boot.autoconfigure.http.HttpMessageConverters;
import org.springframework.cloud.openfeign.support.SpringDecoder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

import java.util.concurrent.TimeUnit;

@Configuration
public class FeignConfig {

    private final FipeClientInterceptor fipeClientInterceptor;

    public FeignConfig(FipeClientInterceptor fipeClientInterceptor) {
        this.fipeClientInterceptor = fipeClientInterceptor;
    }

    @Bean
    public Decoder feignDecoder() {
        // Criar ObjectMapper específico para Feign sem default typing
        ObjectMapper feignMapper = new ObjectMapper();
        feignMapper.registerModule(new JavaTimeModule());
        feignMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        // NÃO ativar default typing para Feign!
        
        HttpMessageConverter<?> jacksonConverter = new MappingJackson2HttpMessageConverter(feignMapper);
        ObjectFactory<HttpMessageConverters> objectFactory = () -> new HttpMessageConverters(jacksonConverter);
        return new SpringDecoder(objectFactory);
    }

    @Bean
    public Logger.Level feignLoggerLevel() {
        return Logger.Level.FULL;
    }

    @Bean
    public Request.Options requestOptions() {
        return new Request.Options(
                10, TimeUnit.SECONDS,
                60, TimeUnit.SECONDS,
                true
        );
    }

    @Bean
    public Retryer retryer() {
        return new Retryer.Default(100, TimeUnit.SECONDS.toMillis(1), 3);
    }

    @Bean
    public ErrorDecoder errorDecoder() {
        return new FeignErrorDecoder();
    }

    @Bean
    public RequestInterceptor requestInterceptor() {
        return fipeClientInterceptor;
    }
}




