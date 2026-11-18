# ---------- Etapa 1: compila o projeto com Maven ----------
FROM maven:3.9-eclipse-temurin-11 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q package -DskipTests

# ---------- Etapa 2: imagem leve so com o Java ----------
FROM eclipse-temurin:11-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Ajustes de memoria para o plano gratuito do Render (512 MB)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=60 -XX:+UseSerialGC -XX:TieredStopAtLevel=1 -Xss512k"

EXPOSE 10000
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
