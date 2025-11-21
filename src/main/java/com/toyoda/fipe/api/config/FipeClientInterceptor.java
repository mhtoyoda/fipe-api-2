package com.toyoda.fipe.api.config;

import feign.RequestInterceptor;
import feign.RequestTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class FipeClientInterceptor implements RequestInterceptor {

    @Value("${fipe.api.subscription-token:}")
    private String subscriptionToken;

    @Override
    public void apply(RequestTemplate template) {
        if (subscriptionToken != null && !subscriptionToken.isEmpty()) {
            template.header("X-Subscription-Token", subscriptionToken);
        }
    }
}

