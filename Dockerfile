# 1) Build stage — compile the app
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# copy your pom.xml
COPY pom.xml .

# pull dependencies
RUN mvn dependency:go-offline

# copy entire source code
COPY src ./src

# package the application (no tests for speed)
RUN mvn clean package -DskipTests

# 2) Run stage — run the compiled jar
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# copy the jar from build stage
COPY --from=build /app/target/*.jar app.jar

# expose default Java web port
EXPOSE 8080

# copy the war from build stage
COPY --from=build /app/target/*.war app.war

CMD ["java", "-jar", "app.war"]

