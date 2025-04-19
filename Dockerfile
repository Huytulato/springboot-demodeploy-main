# Build stage: Maven with Java 17
FROM maven:3.9.4-eclipse-temurin-17 AS build

WORKDIR /opt/app
COPY ./ /opt/app
RUN mvn clean install -DskipTests

# Runtime stage: Java 17 JDK slim (or JRE if available)
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /opt/app
COPY --from=build /opt/app/target/*.jar app.jar

ENV PORT=8081
EXPOSE $PORT

ENTRYPOINT ["java", "-Xmx1024M", "-Dserver.port=${PORT}", "-jar", "app.jar"]
