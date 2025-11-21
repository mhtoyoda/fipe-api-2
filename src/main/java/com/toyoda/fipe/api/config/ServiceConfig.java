package com.toyoda.fipe.api.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
@ComponentScan(basePackages = {
        "com.toyoda.fipe.api.adapter",
        "com.toyoda.fipe.api.application",
        "com.toyoda.fipe.api.domain",
        "com.toyoda.fipe.api.config"
})
@EnableJpaRepositories(basePackages = "com.toyoda.fipe.api.adapter.repository")
@EnableJpaAuditing
@EnableAsync
@EnableScheduling
public class ServiceConfig {
}