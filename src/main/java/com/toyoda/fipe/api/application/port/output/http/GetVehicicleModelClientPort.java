package com.toyoda.fipe.api.application.port.output.http;

import com.toyoda.fipe.api.domain.model.VehicicleModelInfo;
import java.util.List;

public interface GetVehicicleModelClientPort {
    List<VehicicleModelInfo> getVehicicleModelByBrandId(String brandId);
}
