#!/bin/bash

echo "🚀 Iniciando API-2 em modo LOCAL (sem Kafka)"
echo "=============================================="
echo ""
echo "📋 Configurações:"
echo "   - Kafka: DESABILITADO"
echo "   - Redis: localhost:6379"
echo "   - PostgreSQL: localhost:5433"
echo "   - Porta: 8086"
echo ""

mvn spring-boot:run -Dspring-boot.run.profiles=local





