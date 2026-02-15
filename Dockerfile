# ==== Build stage ====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom and sources
COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src

# Build WAR file
RUN mvn -B clean package -DskipTests

# ==== Run stage ====
FROM tomcat:10.1-jdk17-temurin
# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR from build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
