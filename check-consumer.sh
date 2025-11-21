#!/bin/bash

echo "🔍 Verificação Completa do Consumer"
echo "===================================="
echo ""

# 1. Verificar se a aplicação está rodando
echo "1️⃣  Verificando se a aplicação está rodando..."
if docker ps | grep -q fipe-api-2; then
    echo "✅ Aplicação está rodando"
else
    echo "❌ Aplicação NÃO está rodando"
    exit 1
fi

echo ""

# 2. Verificar se o consumer foi iniciado
echo "2️⃣  Verificando se o BrandConsumerListener foi iniciado..."
if docker logs fipe-api-2 2>&1 | grep -q "BrandConsumerListener INICIADO"; then
    echo "✅ BrandConsumerListener foi iniciado"
    docker logs fipe-api-2 2>&1 | grep -A 5 "BrandConsumerListener INICIADO"
else
    echo "❌ BrandConsumerListener NÃO foi iniciado"
    echo ""
    echo "Verificando erros na inicialização:"
    docker logs fipe-api-2 2>&1 | grep -i "error\|exception" | tail -10
fi

echo ""

# 3. Verificar se há erros de Kafka
echo "3️⃣  Verificando erros de Kafka..."
KAFKA_ERRORS=$(docker logs fipe-api-2 2>&1 | grep -i "kafka" | grep -i "error\|exception" | tail -5)
if [ -z "$KAFKA_ERRORS" ]; then
    echo "✅ Sem erros de Kafka"
else
    echo "❌ Erros encontrados:"
    echo "$KAFKA_ERRORS"
fi

echo ""

# 4. Verificar última atividade do consumer
echo "4️⃣  Últimas 30 linhas dos logs:"
echo "----------------------------------------"
docker logs fipe-api-2 --tail 30

echo ""
echo "===================================="
echo "📋 DIAGNÓSTICO:"
echo ""

# Verificar se spring.kafka.enabled está true
echo "5️⃣  Verificando configuração do Kafka..."
if docker exec fipe-api-2 env 2>/dev/null | grep -q "SPRING_KAFKA_ENABLED=false"; then
    echo "❌ KAFKA ESTÁ DESABILITADO!"
    echo "   Solução: Remova a variável SPRING_KAFKA_ENABLED=false do docker-compose"
else
    echo "✅ Kafka está habilitado"
fi

echo ""
echo "🔧 Comandos para testar:"
echo ""
echo "# Ver todos os logs"
echo "docker logs fipe-api-2"
echo ""
echo "# Ver logs em tempo real"
echo "docker logs -f fipe-api-2"
echo ""
echo "# Ver apenas logs do consumer"
echo "docker logs fipe-api-2 | grep -E 'BrandConsumer|📨|🎧'"
echo ""



