FROM jenkins/jenkins:lts

# install docker
USER root
RUN apt-get update && \
    apt-get install -y apt-transport-https \
                    ca-certificates \
                    curl \
                    gnupg2 \
                    software-properties-common \
                    sudo
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
            $(lsb_release -cs) \
            edge"
RUN apt-get update && apt-get install -y docker-ce

# install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Enable passwordless sudo for users under the "sudo" group 
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

# allow use sudo
RUN sudo adduser jenkins sudo
USER jenkins

RUN mkdir -p /var/jenkins_home/workspace/build_idwell/web/test_results
