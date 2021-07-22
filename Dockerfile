# FROM java:8
# EXPOSE 8081
# ARG JAR_FILE=build/libs/*.jar
# COPY ${JAR_FILE} app.jar
# ENTRYPOINT ["java", "-jar", "/app.jar"]
FROM ubuntu:18.04 

# Default user 
ENV USER dalsoft 

# Packages install 
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y sudo vim net-tools ssh openssh-server openjdk-8-jdk-headless 

# Access Option 
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config 
RUN sed -i 's/UsePAM yes/#UserPAM yes/g' /etc/ssh/sshd_config 

# User add & set 
RUN groupadd -g 999 $USER 
RUN useradd -m -r -u 999 -g $USER $USER 

RUN sed -ri '20a'$USER' ALL=(ALL) NOPASSWD:ALL' /etc/sudoers 

# Set root & user passwd 
RUN echo 'root:root' | chpasswd RUN echo $USER':dalsoft' | chpasswd 

# Java 환경변수 
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 

ENTRYPOINT sudo service ssh restart && bash USER $USER