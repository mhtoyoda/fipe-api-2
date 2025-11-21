package com.toyoda.fipe.api.application.usecase;

import com.toyoda.fipe.api.application.port.input.ImportCarUseCase;
import com.toyoda.fipe.api.application.port.output.db.BrandRepositoryPort;
import com.toyoda.fipe.api.application.port.output.db.VehicleModelRepositoryPort;
import com.toyoda.fipe.api.application.port.output.http.GetVehicicleModelClientPort;
import com.toyoda.fipe.api.domain.model.VehicicleModelInfo;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.springframework.stereotype.Component;

@Component
public class ImportCarUseCaseImpl implements ImportCarUseCase {

    private final static String CODE_FIELD = "codigo";
    private final static String BRAND_FIELD = "nome";
    private final BrandRepositoryPort brandRepositoryPort;
    private final VehicleModelRepositoryPort vehicleModelRepositoryPort;
    private final GetVehicicleModelClientPort getVehicicleModelClientPort;

    public ImportCarUseCaseImpl(BrandRepositoryPort brandRepositoryPort, VehicleModelRepositoryPort vehicleModelRepositoryPort, GetVehicicleModelClientPort getVehicicleModelClientPort) {
        this.brandRepositoryPort = brandRepositoryPort;
        this.vehicleModelRepositoryPort = vehicleModelRepositoryPort;
        this.getVehicicleModelClientPort = getVehicicleModelClientPort;
    }

    @Override
    public void execute(Map<String, Object> brandData) {
        String brandId = extractData(brandData, CODE_FIELD);
        String brand = extractData(brandData, BRAND_FIELD);

        List<VehicicleModelInfo> vehicicleModelByMarcaId = getVehicicleModelClientPort.getVehicicleModelByBrandId(brandId);
        System.out.println(vehicicleModelByMarcaId);
//        getVehicicleModelClientPort.getVehicicleModelByMarcaId()
    }

    private String extractData(Map<String, Object> data, String field) {
        Object value = data.get(field);
        return Objects.nonNull(value) ? String.valueOf(value) : null;
    }
}
