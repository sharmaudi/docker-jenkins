FROM jenkins:latest
MAINTAINER Udit Sharma


ENV DEBIAN_FRONTEND=noninteractive

USER root

ARG DOCKER_GID=999

RUN groupadd -g ${DOCKER_GID:-999} docker

ARG DOCKER_ENGINE=1.13.0
ARG DOCKER_COMPOSE=1.11.0

RUN apt-get update -y && \
    apt-get install apt-transport-https ca-certificates software-properties-common curl python-dev python-setuptools gcc make libssl-dev lsb-release -y && \
    easy_install pip 

RUN curl -fsSL https://apt.dockerproject.org/gpg | apt-key add - && \
    apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D && \
    add-apt-repository "deb https://apt.dockerproject.org/repo/ debian-$(lsb_release -cs) main" && \
    apt-get update

RUN apt-cache policy docker-engine && \
    apt-get -y install docker-engine=${DOCKER_ENGINE:-1.13.0}-0~debian-$(lsb_release -cs) && \
    usermod -aG docker jenkins && \
    usermod -aG users jenkins

RUN pip install docker-compose==${DOCKER_COMPOSE:-1.11.0} && \
    pip install ansible boto boto3 fabric

USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
