package com.toyoda.fipe.api.infrastructure.db.repository;

import com.toyoda.fipe.api.infrastructure.db.entity.Brand;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BrandRepository extends JpaRepository<Brand, Long> {

    Optional<Brand> findByCode(String code);

    boolean existsByCode(String code);

    @Query("SELECT b FROM Brand b LEFT JOIN FETCH b.models WHERE b.code = :code")
    Optional<Brand> findByCodeWithModels(String code);
}



