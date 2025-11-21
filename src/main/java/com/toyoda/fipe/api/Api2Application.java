package com.toyoda.fipe.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableFeignClients
@EnableJpaRepositories(basePackages = "com.toyoda.fipe.api.infrastructure.db.repository")
@EntityScan(basePackages = "com.toyoda.fipe.api.infrastructure.db.entity")
public class Api2Application {
	public static void main(String[] args) {
		SpringApplication.run(Api2Application.class, args);
	}
}