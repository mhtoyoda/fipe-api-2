#!/bin/bash

echo "📤 Enviar Mensagem de Teste - Kafka"
echo "===================================="
echo ""

# Configurações
TOPIC_NAME=${KAFKA_TOPIC_BRANDS:-fipe-brands-events}
KAFKA_CONTAINER=${KAFKA_CONTAINER:-kafka}

echo "📋 Configurações:"
echo "   Tópico: $TOPIC_NAME"
echo "   Container Kafka: $KAFKA_CONTAINER"
echo ""

# Verificar se Kafka está rodando
if ! docker ps --format '{{.Names}}' | grep -q "$KAFKA_CONTAINER"; then
    echo "❌ Kafka não está rodando"
    echo "   Execute: cd /caminho/para/api-1 && docker-compose up -d kafka"
    exit 1
fi

echo "✅ Kafka está rodando"
echo ""

# Menu de opções
echo "Escolha o tipo de mensagem para enviar:"
echo ""
echo "1) Mensagem JSON simples"
echo "2) Mensagem JSON com marca"
echo "3) Múltiplas mensagens (teste de carga)"
echo "4) Mensagem personalizada"
echo "5) Producer interativo"
echo ""
read -p "Opção (1-5): " option

case $option in
    1)
        echo ""
        echo "📤 Enviando mensagem JSON simples..."
        echo '{"type":"test","message":"Hello from api-2","timestamp":"'$(date -Iseconds)'"}' | \
        docker exec -i $KAFKA_CONTAINER kafka-console-producer \
            --bootstrap-server localhost:9092 \
            --topic "$TOPIC_NAME"
        echo "✅ Mensagem enviada!"
        ;;
    2)
        echo ""
        echo "📤 Enviando mensagem com marca..."
        echo '{"id":1,"name":"Fiat","code":"1","timestamp":"'$(date -Iseconds)'"}' | \
        docker exec -i $KAFKA_CONTAINER kafka-console-producer \
            --bootstrap-server localhost:9092 \
            --topic "$TOPIC_NAME"
        echo "✅ Mensagem enviada!"
        ;;
    3)
        echo ""
        read -p "Quantas mensagens deseja enviar? " count
        echo "📤 Enviando $count mensagens..."
        for i in $(seq 1 $count); do
            echo '{"id":'$i',"message":"Test message '$i'","timestamp":"'$(date -Iseconds)'"}' | \
            docker exec -i $KAFKA_CONTAINER kafka-console-producer \
                --bootstrap-server localhost:9092 \
                --topic "$TOPIC_NAME"
            echo "   [$i/$count] enviada"
        done
        echo "✅ $count mensagens enviadas!"
        ;;
    4)
        echo ""
        echo "Digite a mensagem JSON (ex: {\"test\":\"value\"}):"
        read -r message
        echo "$message" | \
        docker exec -i $KAFKA_CONTAINER kafka-console-producer \
            --bootstrap-server localhost:9092 \
            --topic "$TOPIC_NAME"
        echo "✅ Mensagem enviada!"
        ;;
    5)
        echo ""
        echo "🎤 Producer interativo iniciado"
        echo "   Digite suas mensagens (Ctrl+C para sair)"
        echo "   Cada linha será uma mensagem separada"
        echo ""
        docker exec -it $KAFKA_CONTAINER kafka-console-producer \
            --bootstrap-server localhost:9092 \
            --topic "$TOPIC_NAME"
        ;;
    *)
        echo "❌ Opção inválida"
        exit 1
        ;;
esac

echo ""
echo "================================"
echo "📊 Verificar se a mensagem foi consumida:"
echo ""
echo "# Ver logs da api-2"
echo "docker logs -f fipe-api-2 | grep -E 'MENSAGEM|📨'"
echo ""
echo "# Ou execute o debug:"
echo "./debug-kafka.sh"
echo ""



