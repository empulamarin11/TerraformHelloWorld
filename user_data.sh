#!/bin/bash
# Actualizar el sistema
yum update -y

# Instalar Docker
amazon-linux-extras install docker -y
service docker start
systemctl enable docker

# Instalar docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Descargar la imagen de Docker Hub
docker pull erick1109/hello-world-app:v1

# Ejecutar el contenedor
docker run -d -p 80:80 --name hello-world-app erick1109/hello-world-app:v1