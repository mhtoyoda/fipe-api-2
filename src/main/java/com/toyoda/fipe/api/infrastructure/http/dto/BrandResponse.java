package com.toyoda.fipe.api.infrastructure.http.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record BrandResponse(
        @JsonProperty("codigo")
        String codigo,

        @JsonProperty("nome")
        String nome
) {}
