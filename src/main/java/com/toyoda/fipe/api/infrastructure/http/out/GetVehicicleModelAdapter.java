package com.toyoda.fipe.api.infrastructure.http.out;

import com.toyoda.fipe.api.application.port.output.http.GetVehicicleModelClientPort;
import com.toyoda.fipe.api.domain.model.VehicicleModelInfo;
import com.toyoda.fipe.api.infrastructure.http.client.FipeClient;
import com.toyoda.fipe.api.infrastructure.http.dto.ModelsResponse;
import java.util.List;
import org.springframework.stereotype.Component;

@Component
public class GetVehicicleModelAdapter implements GetVehicicleModelClientPort {

    private final FipeClient fipeClient;

    public GetVehicicleModelAdapter(FipeClient fipeClient) {
        this.fipeClient = fipeClient;
    }

    @Override
    public List<VehicicleModelInfo> getVehicicleModelByBrandId(String brandId) {
        ModelsResponse modelsResponse = fipeClient.getVehicicleModelByBrandId(brandId);
        return modelsResponse.modelos().stream()
                .map(modelResponse -> new VehicicleModelInfo(modelResponse.codigo(), modelResponse.nome()))
                .toList();
    }
}
