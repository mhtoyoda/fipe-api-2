package com.toyoda.fipe.api.infrastructure.http.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ModelResponse(
        @JsonProperty("codigo")
        Integer codigo,

        @JsonProperty("nome")
        String nome
) {}



