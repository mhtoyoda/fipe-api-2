# Etapa 1: Build da aplicação
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copia o pom.xml e baixa as dependências
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia o código fonte e faz o build
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Imagem final
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copia o JAR da etapa de build
COPY --from=build /app/target/*.jar app.jar

# Expõe a porta da aplicação
EXPOSE 8086

# Define variáveis de ambiente padrão
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Comando para executar a aplicação
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

