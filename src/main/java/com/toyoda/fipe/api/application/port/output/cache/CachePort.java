package com.toyoda.fipe.api.application.port.output.cache;

import java.util.Optional;

public interface CachePort {
    void save(String key, Object value);
    Optional<Object> get(String key);
    void delete(String key);
}
