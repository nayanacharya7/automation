FROM openjdk:17-jdk-slim
EXPOSE 8080
ADD target/automation.jar automation.jar
ENTRYPOINT ["java", "-jar", "automation.jar"]