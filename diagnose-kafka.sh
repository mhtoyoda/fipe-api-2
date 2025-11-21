#!/bin/bash

echo "🔍 Diagnóstico de Conectividade Kafka"
echo "====================================="
echo ""

# 1. Verificar se a rede existe
echo "1️⃣  Verificando rede fipe-network..."
if docker network inspect fipe-network >/dev/null 2>&1; then
    echo "✅ Rede fipe-network existe"
else
    echo "❌ Rede fipe-network NÃO existe"
    echo "   Execute: docker network create fipe-network"
    exit 1
fi

echo ""

# 2. Listar containers na rede
echo "2️⃣  Containers na rede fipe-network:"
CONTAINERS=$(docker network inspect fipe-network --format='{{range .Containers}}{{.Name}} {{end}}')
if [ -z "$CONTAINERS" ]; then
    echo "❌ Nenhum container na rede fipe-network"
else
    echo "$CONTAINERS"
fi

echo ""

# 3. Verificar se Kafka está rodando
echo "3️⃣  Verificando container Kafka..."
if docker ps --format '{{.Names}}' | grep -q kafka; then
    KAFKA_CONTAINER=$(docker ps --format '{{.Names}}' | grep kafka)
    echo "✅ Container Kafka encontrado: $KAFKA_CONTAINER"
    
    # Verificar se está na rede fipe-network
    if echo "$CONTAINERS" | grep -q kafka; then
        echo "✅ Kafka está na rede fipe-network"
    else
        echo "❌ Kafka NÃO está na rede fipe-network"
        echo "   Adicione o Kafka à rede fipe-network no docker-compose da api-1"
    fi
else
    echo "❌ Container Kafka não está rodando"
    echo "   Inicie o Kafka da api-1"
fi

echo ""

# 4. Verificar se Redis está rodando
echo "4️⃣  Verificando container Redis..."
if docker ps --format '{{.Names}}' | grep -q redis; then
    REDIS_CONTAINER=$(docker ps --format '{{.Names}}' | grep redis)
    echo "✅ Container Redis encontrado: $REDIS_CONTAINER"
    
    if echo "$CONTAINERS" | grep -q redis; then
        echo "✅ Redis está na rede fipe-network"
    else
        echo "❌ Redis NÃO está na rede fipe-network"
    fi
else
    echo "❌ Container Redis não está rodando"
fi

echo ""

# 5. Testar conectividade se api-2 estiver rodando
echo "5️⃣  Testando conectividade da api-2..."
if docker ps --format '{{.Names}}' | grep -q fipe-api-2; then
    echo "✅ Container api-2 está rodando"
    
    echo ""
    echo "   Testando conexão com Kafka..."
    if docker exec fipe-api-2 sh -c "nc -zv kafka 9092" 2>&1 | grep -q succeeded; then
        echo "   ✅ API-2 consegue conectar ao Kafka"
    else
        echo "   ❌ API-2 NÃO consegue conectar ao Kafka"
    fi
    
    echo ""
    echo "   Testando conexão com Redis..."
    if docker exec fipe-api-2 sh -c "nc -zv redis 6379" 2>&1 | grep -q succeeded; then
        echo "   ✅ API-2 consegue conectar ao Redis"
    else
        echo "   ❌ API-2 NÃO consegue conectar ao Redis"
    fi
else
    echo "⚠️  Container api-2 não está rodando"
    echo "   Execute: ./start.sh"
fi

echo ""
echo "====================================="
echo "📋 Resumo e Próximos Passos:"
echo ""

# Sugestões
if ! docker ps --format '{{.Names}}' | grep -q kafka; then
    echo "❗ Inicie o Kafka da api-1:"
    echo "   cd /caminho/para/api-1 && docker-compose up -d"
elif ! echo "$CONTAINERS" | grep -q kafka; then
    echo "❗ Adicione Kafka à rede fipe-network:"
    echo "   Edite docker-compose.yml da api-1:"
    echo "   services:"
    echo "     kafka:"
    echo "       networks:"
    echo "         - default"
    echo "         - fipe-network"
    echo ""
    echo "   networks:"
    echo "     fipe-network:"
    echo "       external: true"
    echo "       name: fipe-network"
    echo ""
    echo "   Depois: cd /caminho/para/api-1 && docker-compose down && docker-compose up -d"
fi

if ! docker ps --format '{{.Names}}' | grep -q fipe-api-2; then
    echo "❗ Inicie a api-2:"
    echo "   ./start.sh"
fi

echo ""




