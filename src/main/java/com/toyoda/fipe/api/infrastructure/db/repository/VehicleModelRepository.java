package com.toyoda.fipe.api.infrastructure.db.repository;

import com.toyoda.fipe.api.infrastructure.db.entity.Brand;
import com.toyoda.fipe.api.infrastructure.db.entity.VehicleModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VehicleModelRepository extends JpaRepository<VehicleModel, Long> {

    List<VehicleModel> findByBrand(Brand brand);

    Optional<VehicleModel> findByBrandAndCode(Brand brand, String code);

    boolean existsByBrandAndCode(Brand brand, String code);

    long countByBrand(Brand brand);
}



