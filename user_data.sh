#!/bin/bash
# user_data.sh - Script que se ejecuta al iniciar la instancia

echo "=== Iniciando configuración ==="

# Actualizar sistema
sudo yum update -y

# Instalar Docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker

# Agregar usuario a grupo docker
sudo usermod -a -G docker ec2-user

# Descargar imagen de Docker Hub
echo "Descargando imagen: erick1109/hello-world-app:v1"
sudo docker pull erick1109/hello-world-app:v1

# Ejecutar contenedor
echo "Ejecutando contenedor..."
sudo docker run -d \
  --name hello-world-app \
  -p 80:80 \
  --restart always \
  erick1109/hello-world-app:v1

echo "=== Configuración completada ==="
echo "Aplicación disponible en el puerto 80"