#!/bin/bash
# user_data.sh - Versión mejorada con más logs

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "==========================================="
echo "INICIANDO SCRIPT DE CONFIGURACIÓN"
echo "Fecha: $(date)"
echo "==========================================="

# Configuración
DOCKER_IMAGE="erick1109/hello-world-app:v1"
APP_NAME="hello-world-app"
PORT=80

# 1. Actualizar sistema
echo "[1/8] Actualizando sistema..."
sudo yum update -y

# 2. Instalar Docker
echo "[2/8] Instalando Docker..."
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker

# 3. Agregar usuario a grupo docker
sudo usermod -a -G docker ec2-user

# 4. Esperar que Docker esté listo
echo "[3/8] Esperando que Docker inicie..."
sleep 20

# 5. Verificar que Docker está corriendo
if sudo systemctl is-active --quiet docker; then
    echo "✅ Docker está activo"
else
    echo "❌ Docker NO está activo, intentando reiniciar..."
    sudo service docker restart
    sleep 10
fi

# 6. Descargar imagen de Docker Hub
echo "[4/8] Descargando imagen: ${DOCKER_IMAGE}..."
sudo docker pull ${DOCKER_IMAGE} || {
    echo "❌ Error al descargar imagen, intentando nuevamente..."
    sleep 5
    sudo docker pull ${DOCKER_IMAGE}
}

# 7. Verificar que la imagen se descargó
if sudo docker images | grep -q "erick1109/hello-world-app"; then
    echo "✅ Imagen descargada correctamente"
else
    echo "❌ La imagen NO se descargó"
    exit 1
fi

# 8. Detener contenedores previos
echo "[5/8] Limpiando contenedores anteriores..."
sudo docker stop ${APP_NAME} 2>/dev/null || true
sudo docker rm ${APP_NAME} 2>/dev/null || true

# 9. Ejecutar nuevo contenedor
echo "[6/8] Ejecutando contenedor..."
sudo docker run -d \
  --name ${APP_NAME} \
  --restart always \
  -p ${PORT}:80 \
  ${DOCKER_IMAGE}

# 10. Esperar que el contenedor inicie
echo "[7/8] Esperando que el contenedor inicie..."
sleep 30

# 11. Verificar que está corriendo
echo "[8/8] Verificando estado..."
CONTAINER_STATUS=$(sudo docker inspect -f '{{.State.Status}}' ${APP_NAME} 2>/dev/null || echo "not_found")

if [ "$CONTAINER_STATUS" = "running" ]; then
    echo "==========================================="
    echo "✅ CONTENEDOR EJECUTÁNDOSE CORRECTAMENTE"
    echo "==========================================="
    echo "📦 Imagen: ${DOCKER_IMAGE}"
    echo "🔗 Puerto: ${PORT}"
    echo "🆔 Container ID: $(sudo docker ps -q --filter name=${APP_NAME})"
    
    # Probar que responde
    echo "🏥 Probando salud de la aplicación..."
    if curl -f -s -o /dev/null -w "%{http_code}" http://localhost:${PORT} | grep -q "200"; then
        echo "✅ Aplicación responde HTTP 200"
    else
        echo "⚠️ La aplicación no responde con 200"
        sudo docker logs ${APP_NAME} --tail 20
    fi
else
    echo "==========================================="
    echo "❌ ERROR: CONTENEDOR NO ESTÁ CORRIENDO"
    echo "==========================================="
    echo "Estado: ${CONTAINER_STATUS}"
    echo "Logs del contenedor:"
    sudo docker logs ${APP_NAME} 2>/dev/null || echo "No hay logs disponibles"
    exit 1
fi

# Información del sistema
echo ""
echo "📊 INFORMACIÓN DEL SISTEMA:"
echo "Hostname: $(hostname)"
echo "IP Privada: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo "IP Pública: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "Región: $(curl -s http://169.254.169.254/latest/meta-data/placement/region)"
echo ""
echo "🎉 CONFIGURACIÓN COMPLETADA EXITOSAMENTE"
echo "==========================================="