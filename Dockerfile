########################
# madoos/jenkins-node 
#######################

FROM ubuntu:14.04

MAINTAINER Maurice Dominguez <maurice.ronet.dominguez@gmail.com>

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install the wrapper script from https://raw.githubusercontent.com/docker/docker/master/hack/dind.
ADD ./src/dind /usr/local/bin/dind
RUN chmod +x /usr/local/bin/dind
ADD ./src/wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION 1.8.1
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install Jenkins 
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update && apt-get install -y zip supervisor jenkins && rm -rf /var/lib/apt/lists/*
RUN usermod -a -G docker jenkins
ENV JENKINS_HOME /var/lib/jenkins
VOLUME /var/lib/jenkins

# Install Jenkins plugins for Node

ADD ./src/jenkins-scripts/install-plugins.sh /usr/local/bin/install-plugins.sh
ADD ./src/jenkins-scripts/jenkins-support /usr/local/bin/jenkins-support

RUN chmod +x /usr/local/bin/install-plugins.sh
RUN chmod +x /usr/local/bin/jenkins-support

COPY ./src/jenkins-scripts/plugins.txt /usr/share/jenkins/plugins.txt
#RUN /usr/local/bin/install-plugins.sh /usr/share/jenkins/plugins.txt

# Launch processes
ADD ./src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

EXPOSE 8080

CMD ["/usr/bin/supervisord"]