package com.toyoda.fipe.api.infrastructure.db.repository;

import com.toyoda.fipe.api.application.port.output.db.BrandRepositoryPort;
import org.springframework.stereotype.Component;

@Component
public class BrandRepositoryAdapter implements BrandRepositoryPort {

    private final BrandRepository brandRepository;

    public BrandRepositoryAdapter(BrandRepository brandRepository) {
        this.brandRepository = brandRepository;
    }
}
