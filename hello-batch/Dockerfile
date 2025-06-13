# hello-batch/Dockerfile
FROM eclipse-temurin:17-jre
ARG JAR_FILE=target/hello-batch-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app.jar"]
