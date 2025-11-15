#!/bin/bash

# Script para parar a api-2

echo "🛑 Parando API-2..."

docker-compose down

echo "✅ API-2 parada"
echo ""
echo "💡 Para remover também os volumes (limpar dados):"
echo "   docker-compose down -v"

