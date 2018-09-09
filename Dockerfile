FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get install -y docker
USER jenkins
# ADD --chown=jenkins jenkins_home /var/jenkins_home
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
