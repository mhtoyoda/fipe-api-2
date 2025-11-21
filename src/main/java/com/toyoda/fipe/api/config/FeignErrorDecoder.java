package com.toyoda.fipe.api.config;

import feign.Response;
import feign.codec.ErrorDecoder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

public class FeignErrorDecoder implements ErrorDecoder {

    private static final Logger log = LoggerFactory.getLogger(FeignErrorDecoder.class);
    private final ErrorDecoder defaultErrorDecoder = new Default();

    @Override
    public Exception decode(String methodKey, Response response) {
        HttpStatus status = HttpStatus.resolve(response.status());
        
        if (status == null) {
            return defaultErrorDecoder.decode(methodKey, response);
        }

        log.error("Erro na chamada Feign: {} - Status: {} - Reason: {}", 
                methodKey, response.status(), response.reason());

        return switch (status) {
            case NOT_FOUND -> new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "Recurso não encontrado na API FIPE"
            );
            case BAD_REQUEST -> new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Requisição inválida para a API FIPE"
            );
            case INTERNAL_SERVER_ERROR -> new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Erro interno na API FIPE"
            );
            case SERVICE_UNAVAILABLE -> new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "API FIPE temporariamente indisponível"
            );
            default -> defaultErrorDecoder.decode(methodKey, response);
        };
    }
}




