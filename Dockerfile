FROM maven:3.6.1 AS builder

WORKDIR /app

COPY . .

# Build application -> create artifact /app/target/obo-stadium-0.0.1-SNAPSHOT.jar
RUN mvn -Dmaven.test.failure.ignore=true clean package

FROM openjdk:18-jdk-alpine

WORKDIR /project

COPY --from=builder /app/target/obo-stadium-0.0.1-SNAPSHOT.jar /project/app.jar
COPY --from=builder /app/src/main/resources/application-env.properties /project/application-env.properties
COPY --from=builder /app/src/main/resources/templates /project/templates

CMD ["java", "-Dspring.config.location=/project/application-env.properties", "-jar", "/project/app.jar"]