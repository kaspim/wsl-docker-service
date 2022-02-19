FROM alpine:3.14

ARG DOCKER_SOCKET_DIR="/mnt/wsl/wsl-docker-socket"
ARG DOCKER_WSL_NAME="wsl-docker-service"
ARG DOCKER_DEFAULT_USER="docker-provider"
ARG DOCKER_DEFAULT_PASS="docker"

RUN apk update \
    && apk upgrade \
    && apk add sudo shadow bash docker docker-compose

RUN sed -i -e "s/^\(docker:x\):[^:]\+/\1:2509/" /etc/group \
    && groupmod -g 2509 docker \
    && echo -e "%wheel ALL=(ALL) ALL\n%docker ALL=(ALL) NOPASSWD: /usr/bin/dockerd\n%docker ALL=(ALL) NOPASSWD: /usr/bin/docker-initialize" >> /etc/sudoers

RUN adduser -s /bin/bash --gecos "" --disabled-password $DOCKER_DEFAULT_USER \
    && addgroup $DOCKER_DEFAULT_USER wheel \
    && addgroup $DOCKER_DEFAULT_USER docker \
    && echo "$DOCKER_DEFAULT_USER:$DOCKER_DEFAULT_PASS" | chpasswd \
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

RUN echo -e "[user]\ndefault=\"$DOCKER_DEFAULT_USER\"" > /etc/wsl.conf

RUN mkdir -pm u=rwx,go=rx /etc/docker/ \
    && mkdir -pm u=rwx,go=x /var/lib/docker \
    && echo -e "{\n  \"hosts\": [\"unix://$DOCKER_SOCKET_DIR/docker.sock\", \"tcp://0.0.0.0:2375\"],\n  \"features\": {\"buildkit\": true}\n}" > /etc/docker/daemon.json

RUN touch /usr/bin/docker-start \
    && chmod +x /usr/bin/docker-start \
    && echo "#!/bin/bash" > /usr/bin/docker-start \
    && echo -e "export DOCKER_HOST=\"unix://$DOCKER_SOCKET_DIR/docker.sock\"\n" >> /usr/bin/docker-start \
    && echo -e "sudo docker-initialize > /dev/null" >> /usr/bin/docker-start

RUN touch /usr/bin/docker-initialize \
    && chmod +x /usr/bin/docker-initialize \
    && echo "#!/bin/bash" > /usr/bin/docker-initialize \
    && echo "DATE=\"\$(date +%Y-%m-%d)\"" >> /usr/bin/docker-initialize \
    && echo "WIN_DOCKER_DATA=\"\$(cmd.exe /C \"cd /D %USERPROFILE% && bash.exe -c pwd\")/AppData/Local/Docker/$DOCKER_WSL_NAME\"" >> /usr/bin/docker-initialize \
    && echo -e "if [ ! -d \${WIN_DOCKER_DATA}/volumes ]; then\n  mkdir -p \${WIN_DOCKER_DATA}/volumes\nfi" >> /usr/bin/docker-initialize \
    && echo -e "if [ ! -L /var/lib/docker/volumes ]; then\n  rm -rf /var/lib/docker/volumes\n  ln -s \${WIN_DOCKER_DATA}/volumes /var/lib/docker/volumes\nfi" >> /usr/bin/docker-initialize \
    && echo "if [ ! -S \"$DOCKER_SOCKET_DIR/docker.sock\" ]; then" >> /usr/bin/docker-initialize \
    && echo "  mkdir -pm o=,ug=rwx $DOCKER_SOCKET_DIR" >> /usr/bin/docker-initialize \
    && echo "  chgrp docker $DOCKER_SOCKET_DIR" >> /usr/bin/docker-initialize \
    && echo "  /mnt/c/Windows/System32/wsl.exe -d $DOCKER_WSL_NAME sh -c \"nohup sudo -b dockerd < /dev/null > \${WIN_DOCKER_DATA}/docker-\${DATE}.log 2>&1\"" >> /usr/bin/docker-initialize \
    && echo "fi" >> /usr/bin/docker-initialize \
    && echo "if [ ! -L /var/run/docker.sock ]; then" >> /usr/bin/docker-initialize \
    && echo "  sudo rm -f /var/run/docker.sock" >> /usr/bin/docker-initialize \
    && echo "  sudo ln -s $DOCKER_SOCKET_DIR/docker.sock /var/run/docker.sock" >> /usr/bin/docker-initialize \
    && echo "fi" >> /usr/bin/docker-initialize

RUN touch /home/$DOCKER_DEFAULT_USER/.profile \
    && echo -e "if [ -d \"$HOME/bin\" ]; then\n  PATH=\"$HOME/bin:$PATH\"\nfi\n" >> /home/$DOCKER_DEFAULT_USER/.profile \
    && echo -e "if [ -d \"$HOME/.local/bin\" ]; then\n  PATH=\"$HOME/.local/bin:$PATH\"\nfi\n" >> /home/$DOCKER_DEFAULT_USER/.profile \
    && echo -e "docker-start > /dev/null" >> /home/$DOCKER_DEFAULT_USER/.profile \
    && chown $DOCKER_DEFAULT_USER:$DOCKER_DEFAULT_USER /home/$DOCKER_DEFAULT_USER/.profile
