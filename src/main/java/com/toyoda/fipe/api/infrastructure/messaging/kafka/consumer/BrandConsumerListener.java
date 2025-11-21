package com.toyoda.fipe.api.infrastructure.messaging.kafka.consumer;

import com.toyoda.fipe.api.application.port.input.ImportCarUseCase;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "spring.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class BrandConsumerListener {

    private static final Logger log = LoggerFactory.getLogger(BrandConsumerListener.class);
    private final ImportCarUseCase importCarUseCase;

    @Value("${kafka.topics.brands}")
    private String topicName;

    @Value("${spring.kafka.consumer.group-id}")
    private String groupId;

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    public BrandConsumerListener(ImportCarUseCase importCarUseCase) {
        this.importCarUseCase = importCarUseCase;
    }

    @KafkaListener(
            topics = "${kafka.topics.brands}",
            groupId = "brand-group",
            containerFactory = "jsonKafkaListenerContainerFactory")
    public void consumer(
            Object message,
            @Header(KafkaHeaders.RECEIVED_TOPIC) String topic,
            @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
            @Header(KafkaHeaders.OFFSET) long offset,
            @Header(KafkaHeaders.RECEIVED_TIMESTAMP) long timestamp,
            Acknowledgment ack) {
        try {
            if (message instanceof org.apache.kafka.clients.consumer.ConsumerRecord) {
                org.apache.kafka.clients.consumer.ConsumerRecord<?, ?> record =
                    (org.apache.kafka.clients.consumer.ConsumerRecord<?, ?>) message;
                message = record.value();
            }
            processMessage(message);
            ack.acknowledge();

        } catch (Exception e) {
            log.error("❌ Error while processing message - Offset: {} - Erro: {}", offset, e.getMessage(), e);
            log.error("Stack trace:", e);
        }
    }

    private void processMessage(final Object message) {
        if (message instanceof java.util.List) {
            java.util.List<?> list = (java.util.List<?>) message;
            log.info("Processing list with {} brands", list.size());
            
            int success = 0;
            int failed = 0;
            
            for (int i = 0; i < list.size(); i++) {
                Object item = list.get(i);
                try {
                    processItem(item);
                    success++;
                } catch (Exception e) {
                    failed++;
                    log.error("Error while processing item {}: {}", i + 1, e.getMessage());
                }
            }
        } else {
            log.info("Processing just one brand");
            processItem(message);
        }
    }
    
    private void processItem(final Object item) {
        if (item instanceof java.util.Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> brandData = (Map<String, Object>) item;
            importCarUseCase.execute(brandData);
        }
    }
}
