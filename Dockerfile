FROM maven:3.8.3-openjdk-17 AS builder

LABEL maintainer="Sayali Kokane <sayalikokane55@gmail.com>"
LABEL app="chatapp"

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests=true

#--------------------------------------
# Stage 2
#--------------------------------------

FROM eclipse-temurin:17-jre-alpine AS deployer

WORKDIR /app
RUN apk add --no-cache curl
COPY --from=builder /app/target/*.jar chatapp.jar
EXPOSE 8080
CMD ["java", "-jar", "chatapp.jar"]

