FROM ubuntu:18.04
# FROM openjdk:8
COPY ./run-spec-miners /usr/src/app/run-spec-miners
WORKDIR /usr/src/app/run-spec-miners/

RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
# Install Git
  apt-get install -y git
RUN \ 
  # Install python
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*
# Install misc
RUN \
  apt-get update && \
  apt-get install -y sudo && \
  apt-get install -y vim && \
  apt-get install -y emacs && \
  apt-get install -y wget && \
  apt-get install -y bc && \
  apt-get install -y zip unzip && \
# Install OpenJDK 8
  apt-get install -y openjdk-8-jdk && \
  mv /usr/lib/jvm/java-8-openjdk* /usr/lib/jvm/java-8-openjdk

# Use OpenJDK 8 when building the docker image
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk

RUN \
  wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz && \
  tar -xzvf apache-maven-3.9.1-bin.tar.gz && mv apache-maven-3.9.1/ apache-maven/ && \
  rm apache-maven-3.9.1-bin.tar.gz

RUN \
  # Set up the user's configurations
  tail -n +10 ~/.bashrc > ~/tmp-bashrc && \
  cp ~/tmp-bashrc ~/.bashrc && \
  echo 'JAVAHOME=/usr/lib/jvm/java-8-openjdk' >> ~/.bashrc && \
  echo 'export JAVA_HOME=${JAVAHOME}' >> ~/.bashrc && \
  echo 'export MAVEN_HOME=/usr/src/app/run-spec-miners/apache-maven' >> ~/.bashrc && \
  echo 'export PATH=${MAVEN_HOME}/bin:${JAVAHOME}/bin:${PATH}' >> ~/.bashrc
# RUN mvn clean install
# RUN ./bddminer.sh kamranzafar.jtar.txt
# WORKDIR /usr/src/app/run-spec-miners/
# RUN pwd
# RUN ./javert.sh kamranzafar.jtar.txt
# RUN ./setup-conda.sh
# RUN ./dsm-manual.sh kamranzafar.jtar.txt