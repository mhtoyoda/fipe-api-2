#!/bin/bash

echo "🔍 Debug Kafka Consumer - API-2"
echo "================================"
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configurações
TOPIC_NAME=${KAFKA_TOPIC_BRANDS:-fipe-brands-events}
GROUP_ID=${SPRING_KAFKA_CONSUMER_GROUP_ID:-api-2-consumer-group}
KAFKA_CONTAINER=${KAFKA_CONTAINER:-kafka}

echo "📋 Configurações:"
echo "   Tópico: $TOPIC_NAME"
echo "   Group ID: $GROUP_ID"
echo "   Container Kafka: $KAFKA_CONTAINER"
echo ""

# 1. Verificar se Kafka está rodando
echo "1️⃣  Verificando se Kafka está rodando..."
if docker ps --format '{{.Names}}' | grep -q "$KAFKA_CONTAINER"; then
    echo -e "${GREEN}✅ Kafka está rodando${NC}"
else
    echo -e "${RED}❌ Kafka NÃO está rodando${NC}"
    echo "   Execute: cd /caminho/para/api-1 && docker-compose up -d kafka"
    exit 1
fi

echo ""

# 2. Verificar se o tópico existe
echo "2️⃣  Verificando se o tópico '$TOPIC_NAME' existe..."
TOPIC_EXISTS=$(docker exec $KAFKA_CONTAINER kafka-topics --bootstrap-server localhost:9092 --list 2>/dev/null | grep -c "^${TOPIC_NAME}$")

if [ "$TOPIC_EXISTS" -gt 0 ]; then
    echo -e "${GREEN}✅ Tópico '$TOPIC_NAME' existe${NC}"
    
    # Mostrar detalhes do tópico
    echo ""
    echo "📊 Detalhes do tópico:"
    docker exec $KAFKA_CONTAINER kafka-topics --bootstrap-server localhost:9092 --describe --topic "$TOPIC_NAME" 2>/dev/null
else
    echo -e "${YELLOW}⚠️  Tópico '$TOPIC_NAME' NÃO existe${NC}"
    echo ""
    echo "   Deseja criar o tópico? (s/n)"
    read -r response
    if [[ "$response" =~ ^[Ss]$ ]]; then
        echo "   Criando tópico '$TOPIC_NAME'..."
        docker exec $KAFKA_CONTAINER kafka-topics --bootstrap-server localhost:9092 --create --topic "$TOPIC_NAME" --partitions 3 --replication-factor 1
        echo -e "${GREEN}✅ Tópico criado com sucesso${NC}"
    fi
fi

echo ""

# 3. Verificar mensagens no tópico
echo "3️⃣  Verificando mensagens no tópico..."
MESSAGE_COUNT=$(docker exec $KAFKA_CONTAINER kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic "$TOPIC_NAME" 2>/dev/null | awk -F: '{sum += $3} END {print sum}')

if [ -z "$MESSAGE_COUNT" ] || [ "$MESSAGE_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Nenhuma mensagem no tópico${NC}"
    echo ""
    echo "   O tópico está vazio. Você precisa enviar mensagens para ele."
else
    echo -e "${GREEN}✅ Total de mensagens no tópico: $MESSAGE_COUNT${NC}"
fi

echo ""

# 4. Verificar consumer group
echo "4️⃣  Verificando consumer group '$GROUP_ID'..."
GROUP_EXISTS=$(docker exec $KAFKA_CONTAINER kafka-consumer-groups --bootstrap-server localhost:9092 --list 2>/dev/null | grep -c "^${GROUP_ID}$")

if [ "$GROUP_EXISTS" -gt 0 ]; then
    echo -e "${GREEN}✅ Consumer group '$GROUP_ID' existe${NC}"
    echo ""
    echo "📊 Status do consumer group:"
    docker exec $KAFKA_CONTAINER kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group "$GROUP_ID" 2>/dev/null
    echo ""
    
    # Verificar LAG
    LAG=$(docker exec $KAFKA_CONTAINER kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group "$GROUP_ID" 2>/dev/null | tail -n +3 | awk '{sum += $5} END {print sum}')
    if [ -z "$LAG" ] || [ "$LAG" -eq 0 ]; then
        echo -e "${GREEN}✅ Sem LAG - Todas as mensagens foram consumidas${NC}"
    else
        echo -e "${YELLOW}⚠️  LAG detectado: $LAG mensagens pendentes${NC}"
        echo "   O consumer está atrasado ou não está rodando"
    fi
else
    echo -e "${YELLOW}⚠️  Consumer group '$GROUP_ID' NÃO existe ainda${NC}"
    echo "   O grupo será criado quando o primeiro consumer se conectar"
fi

echo ""

# 5. Verificar se a api-2 está rodando
echo "5️⃣  Verificando se a api-2 está rodando..."
if docker ps --format '{{.Names}}' | grep -q "fipe-api-2"; then
    echo -e "${GREEN}✅ API-2 está rodando${NC}"
    
    echo ""
    echo "📝 Últimas 20 linhas dos logs da API-2:"
    echo "----------------------------------------"
    docker logs fipe-api-2 --tail 20 2>&1 | grep -E "Kafka|Consumer|BrandConsumer|MENSAGEM"
else
    echo -e "${YELLOW}⚠️  API-2 NÃO está rodando no Docker${NC}"
    echo "   Verifique se está rodando localmente"
fi

echo ""
echo "================================"
echo "📋 RESUMO E AÇÕES:"
echo ""

if [ "$TOPIC_EXISTS" -eq 0 ]; then
    echo -e "${RED}❗ PROBLEMA: Tópico não existe${NC}"
    echo "   Solução: Execute o script novamente e crie o tópico"
elif [ -z "$MESSAGE_COUNT" ] || [ "$MESSAGE_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}❗ PROBLEMA: Tópico vazio${NC}"
    echo "   Solução: Envie mensagens de teste para o tópico"
    echo ""
    echo "   Exemplo de envio de mensagem:"
    echo "   docker exec -it $KAFKA_CONTAINER kafka-console-producer \\"
    echo "       --bootstrap-server localhost:9092 \\"
    echo "       --topic $TOPIC_NAME"
    echo ""
    echo "   Digite a mensagem e pressione Enter"
elif [ "$GROUP_EXISTS" -eq 0 ]; then
    echo -e "${YELLOW}❗ PROBLEMA: Consumer não conectou ainda${NC}"
    echo "   Solução: Verifique os logs da api-2 e se o Kafka está acessível"
elif [ ! -z "$LAG" ] && [ "$LAG" -gt 0 ]; then
    echo -e "${YELLOW}❗ PROBLEMA: Consumer com LAG${NC}"
    echo "   Solução: Verifique os logs da api-2 para erros"
else
    echo -e "${GREEN}✅ TUDO OK: Consumer está funcionando corretamente${NC}"
fi

echo ""
echo "🔧 Comandos úteis:"
echo ""
echo "# Ver logs da api-2 em tempo real"
echo "docker logs -f fipe-api-2 | grep -E 'Kafka|Consumer|MENSAGEM'"
echo ""
echo "# Enviar mensagem de teste"
echo "docker exec -it $KAFKA_CONTAINER kafka-console-producer --bootstrap-server localhost:9092 --topic $TOPIC_NAME"
echo ""
echo "# Consumir mensagens manualmente"
echo "docker exec -it $KAFKA_CONTAINER kafka-console-consumer --bootstrap-server localhost:9092 --topic $TOPIC_NAME --from-beginning"
echo ""
echo "# Resetar offset do consumer group (CUIDADO!)"
echo "docker exec $KAFKA_CONTAINER kafka-consumer-groups --bootstrap-server localhost:9092 --group $GROUP_ID --reset-offsets --to-earliest --topic $TOPIC_NAME --execute"
echo ""



