#!/bin/bash

# Script para configurar a rede compartilhada entre api-1 e api-2

echo "🔧 Configurando rede compartilhada fipe-network..."

# Criar a rede se não existir
if docker network inspect fipe-network >/dev/null 2>&1; then
    echo "✅ Rede fipe-network já existe"
else
    echo "📡 Criando rede fipe-network..."
    docker network create fipe-network
    echo "✅ Rede fipe-network criada com sucesso"
fi

echo ""
echo "📋 Informações da rede:"
docker network inspect fipe-network --format='{{json .}}' | jq -r '.Name, .Driver, .Scope'

echo ""
echo "🔍 Containers conectados à rede fipe-network:"
docker network inspect fipe-network --format='{{range .Containers}}{{.Name}} {{end}}'

echo ""
echo "⚠️  IMPORTANTE:"
echo "   1. Certifique-se de adicionar a rede fipe-network ao docker-compose da api-1"
echo "   2. Os serviços Redis e Kafka da api-1 devem estar na rede fipe-network"
echo "   3. Reinicie a api-1 após fazer as alterações"
echo ""
echo "Exemplo de configuração no docker-compose.yml da api-1:"
echo ""
cat << 'EOF'
services:
  redis:
    # ... configurações existentes ...
    networks:
      - default
      - fipe-network
  
  kafka:
    # ... configurações existentes ...
    networks:
      - default
      - fipe-network

networks:
  fipe-network:
    external: true
    name: fipe-network
EOF

