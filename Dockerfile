# Use an official Java 17 base image
FROM maven:3.8.3-openjdk-17 as builder 

# Add maintainer, so that new user will understand who had written this Dockerfile
MAINTAINER sayali Kokane<sayalikokane55@gmail.com>

# Add labels to the image to filter out if we have multiple application running
LABEL app=chatapp

# Set working directory in the container
WORKDIR /app

# Copy source code from local to container
COPY . /app

# Build application and skip test cases
RUN mvn clean install -DskipTests=true
#--------------------------------------
# Stage 2
#--------------------------------------
# Import small size java image
FROM openjdk:17-alpine as deployer

# Install curl
RUN apk add --no-cache curl

# Copy build from stage 1 (builder)
COPY --from=builder /app/target/*.jar /app/target/chatapp.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/target/chatapp.jar"]
