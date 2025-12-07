#!/bin/bash
# user_data.sh - Script que se ejecuta al iniciar la instancia

echo "=== Iniciando configuración automática ==="

# Variables
DOCKER_IMAGE="erick1109/hello-world-app:v1"
APP_NAME="hello-world-app"
PORT=80

# Actualizar sistema
sudo yum update -y

# Instalar Docker
echo "Instalando Docker..."
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker

# Agregar usuario a grupo docker
sudo usermod -a -G docker ec2-user

# Descargar imagen de Docker Hub
echo "Descargando imagen: ${DOCKER_IMAGE}"
sudo docker pull ${DOCKER_IMAGE}

# Detener contenedores existentes (si los hay)
sudo docker stop ${APP_NAME} 2>/dev/null || true
sudo docker rm ${APP_NAME} 2>/dev/null || true

# Ejecutar nuevo contenedor
echo "Ejecutando contenedor..."
sudo docker run -d \
  --name ${APP_NAME} \
  --restart always \
  -p ${PORT}:80 \
  ${DOCKER_IMAGE}

# Verificar que está corriendo
sleep 10
echo "Verificando estado del contenedor..."
sudo docker ps | grep ${APP_NAME}

# Información de la instancia
echo ""
echo "=== Configuración completada ==="
echo "Instancia ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
echo "IP Pública: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "Región: $(curl -s http://169.254.169.254/latest/meta-data/placement/region)"
echo "La aplicación estará disponible en: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"