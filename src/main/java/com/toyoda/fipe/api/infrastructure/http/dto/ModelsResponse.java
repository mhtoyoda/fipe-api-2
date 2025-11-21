package com.toyoda.fipe.api.infrastructure.http.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public record ModelsResponse(
        @JsonProperty("modelos")
        List<ModelResponse> modelos,

        @JsonProperty("anos")
        List<YearResponse> anos
) {}



