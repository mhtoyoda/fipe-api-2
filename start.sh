#!/bin/bash

# Script para iniciar a api-2 com Docker

echo "🚀 Iniciando API-2..."

# Verificar se a rede existe
if ! docker network inspect fipe-network >/dev/null 2>&1; then
    echo "⚠️  Rede fipe-network não encontrada. Criando..."
    docker network create fipe-network
    echo "✅ Rede criada"
fi

# Build e start
echo "📦 Building e iniciando containers..."
docker-compose up -d --build

echo ""
echo "⏳ Aguardando serviços iniciarem..."
sleep 5

echo ""
echo "📊 Status dos containers:"
docker-compose ps

echo ""
echo "🔗 Endpoints disponíveis:"
echo "   - Aplicação: http://localhost:8086/api-2"
echo "   - Health: http://localhost:8086/api-2/actuator/health"
echo "   - Metrics: http://localhost:8086/api-2/actuator/metrics"
echo "   - PostgreSQL: localhost:5433"

echo ""
echo "📝 Para ver os logs:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 Para parar:"
echo "   docker-compose down"

