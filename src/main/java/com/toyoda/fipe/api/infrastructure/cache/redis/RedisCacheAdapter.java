package com.toyoda.fipe.api.infrastructure.cache.redis;

import com.toyoda.fipe.api.application.port.output.cache.CachePort;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class RedisCacheAdapter implements CachePort {

    private static final Logger log = LoggerFactory.getLogger(RedisCacheAdapter.class);

    private final RedisTemplate<String, Object> redisTemplate;

    public RedisCacheAdapter(
            RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    @Override
    public void save(String key, Object value) {
        log.info("Save in Cache key: {}, obj: {}", key, value);
        redisTemplate.opsForValue().set(key, value);
    }

    @Override
    public Optional<Object> get(String key) {
        log.info("Get in Cache key: {}", key);
        return Optional.ofNullable(redisTemplate.opsForValue().get(key));
    }

    @Override
    public void delete(String key) {
        log.info("Delete in Cache key: {}", key);
        redisTemplate.delete(key);
    }
}
