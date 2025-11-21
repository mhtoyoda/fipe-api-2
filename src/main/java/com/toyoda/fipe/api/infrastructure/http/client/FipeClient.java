package com.toyoda.fipe.api.infrastructure.http.client;

import com.toyoda.fipe.api.config.FeignConfig;
import com.toyoda.fipe.api.infrastructure.http.dto.ModelsResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(
        name = "fipe-client",
        url = "${service.api.url.fipe}",
        configuration = FeignConfig.class
)
public interface FipeClient {

    @GetMapping("/marcas/{brandId}/modelos")
    ModelsResponse getVehicicleModelByBrandId(@PathVariable("brandId") String brandId);
}

