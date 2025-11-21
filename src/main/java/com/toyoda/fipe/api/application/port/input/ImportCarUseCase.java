package com.toyoda.fipe.api.application.port.input;

import java.util.Map;

public interface ImportCarUseCase {
    void execute(Map<String, Object> brandData);
}
