package com.toyoda.fipe.api.infrastructure.db.repository;

import com.toyoda.fipe.api.application.port.output.db.VehicleModelRepositoryPort;
import org.springframework.stereotype.Component;

@Component
public class VehicleModelRepositoryAdapter implements VehicleModelRepositoryPort {

    private final VehicleModelRepository vehicleModelRepository;

    public VehicleModelRepositoryAdapter(VehicleModelRepository vehicleModelRepository) {
        this.vehicleModelRepository = vehicleModelRepository;
    }
}
