# ------------------------------------
# STAGE 1: Build the Executable JAR
# ------------------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS build
# Use 'maven:3.9.6-eclipse-temurin-21' for a comprehensive build environment

WORKDIR /app

# Copy the pom.xml first to download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline  

# Copy the rest of the source code
COPY src ./src

# Compile the application and create the final JAR (skipping tests for quick deployment)
RUN mvn clean package -DskipTests  


# ------------------------------------
# STAGE 2: Create Minimal Runtime Image
# ------------------------------------
FROM eclipse-temurin:21-jre-jammy  
# Use 'jre-jammy' for a lightweight Java Runtime Environment (smaller image!)

WORKDIR /app

# Copy the compiled JAR file from the 'build' stage
# The JAR is typically found in the 'target' directory
COPY --from=build /app/target/*.jar /app/app.jar 

# Expose the default Spring Boot port
EXPOSE 8080

# Define the command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "/app/app.jar"]