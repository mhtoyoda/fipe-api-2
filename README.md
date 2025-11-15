# Docker Setup - API-2

## Pré-requisitos

1. Docker e Docker Compose instalados
2. A api-1 deve estar rodando com sua rede Docker configurada

## Configuração da Rede Compartilhada

### Passo 1: Criar a rede compartilhada (executar uma vez)

```bash
docker network create fipe-network
```

### Passo 2: Atualizar o docker-compose da api-1

No arquivo `docker-compose.yml` da **api-1**, adicione a rede externa aos serviços Redis e Kafka:

```yaml
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
```

Depois, reinicie os serviços da api-1:

```bash
cd /caminho/para/api-1
docker-compose down
docker-compose up -d
```

## Executando a API-2

### Build e start dos containers

```bash
# No diretório da api-2
docker-compose up -d --build
```

### Verificar logs

```bash
# Logs de todos os serviços
docker-compose logs -f

# Logs apenas da aplicação
docker-compose logs -f api-2

# Logs apenas do Postgres
docker-compose logs -f postgres
```

### Verificar status

```bash
docker-compose ps
```

### Parar os containers

```bash
docker-compose down
```

### Parar e remover volumes (limpar dados)

```bash
docker-compose down -v
```

## Endpoints

- **Aplicação**: http://localhost:8086/api-2
- **Health Check**: http://localhost:8086/api-2/actuator/health
- **Metrics**: http://localhost:8086/api-2/actuator/metrics
- **PostgreSQL**: localhost:5433

## Credenciais

### PostgreSQL
- **Host**: localhost:5433 (externo) / postgres:5432 (interno)
- **Database**: fipe_api2
- **User**: fipe_user
- **Password**: fipe_password

### Redis (da api-1)
- **Host**: redis:6379 (dentro da rede Docker)

### Kafka (da api-1)
- **Bootstrap Servers**: kafka:9092 (dentro da rede Docker)

## Conexão com serviços da api-1

Os serviços Redis e Kafka são acessados através da rede `fipe-network` que é compartilhada entre api-1 e api-2.

### Verificar conectividade

```bash
# Acessar o container da api-2
docker exec -it fipe-api-2 sh

# Testar conexão com Redis
nc -zv redis 6379

# Testar conexão com Kafka
nc -zv kafka 9092
```

## Desenvolvimento Local

Para rodar localmente (fora do Docker) e conectar aos serviços Docker:

```bash
# Certifique-se que Redis e Kafka da api-1 estão expostos nas portas do host
# Exemplo: Redis em localhost:6379 e Kafka em localhost:9092

mvn spring-boot:run
```

## Troubleshooting

### Erro de rede "fipe-network not found"

```bash
docker network create fipe-network
```

### Containers não conseguem se conectar ao Redis/Kafka

1. Verifique se a rede foi adicionada ao docker-compose da api-1
2. Reinicie os containers da api-1
3. Verifique a rede:

```bash
docker network inspect fipe-network
```

### Rebuild completo

```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

## Estrutura de Redes

```
api-1:
  - default (rede interna da api-1)
  - fipe-network (rede compartilhada)
    - redis
    - kafka

api-2:
  - api-2-network (rede interna da api-2)
  - fipe-network (rede compartilhada)
    - api-2
    - postgres
```

