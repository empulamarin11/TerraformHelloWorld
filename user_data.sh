#!/bin/bash
# user_data.sh - Improved version with more logs

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "==========================================="
echo "STARTING CONFIGURATION SCRIPT"
echo "Fecha: $(date)"
echo "==========================================="

# Configuration
DOCKER_IMAGE="erick1109/hello-world-app:v1"
APP_NAME="hello-world-app"
PORT=80

# 1. Update system
echo "[1/8] Updating system..."
sudo yum update -y

# 2. Install Docker
echo "[2/8] Installing Docker..."
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker

# 3. Add user to Docker group
sudo usermod -a -G docker ec2-user

# 4. Wait for Docker to be ready
echo "[3/8] Waiting for Docker to start..."
sleep 20

# 5. Verify that Docker is running
if sudo systemctl is-active --quiet docker; then
    echo "Docker is active"
else
    echo "Docker is not active, attempting to restart..."
    sudo service docker restart
    sleep 10
fi

# 6. Download Docker Hub image
echo "[4/8] Downloading image: ${DOCKER_IMAGE}..."
sudo docker pull ${DOCKER_IMAGE} || {
    echo "Error downloading image, please try again..."
    sleep 5
    sudo docker pull ${DOCKER_IMAGE}
}

# 7. Verify that the image was downloaded
if sudo docker images | grep -q "erick1109/hello-world-app"; then
    echo "Image downloaded successfully"
else
    echo "The image did NOT download"
    exit 1
fi

# 8. Stop containers prices
echo "[5/8] Cleaning previous containers..."
sudo docker stop ${APP_NAME} 2>/dev/null || true
sudo docker rm ${APP_NAME} 2>/dev/null || true

# 9. Run new container
echo "[6/8] Running container..."
sudo docker run -d \
  --name ${APP_NAME} \
  --restart always \
  -p ${PORT}:80 \
  ${DOCKER_IMAGE}

# 10. Wait for the container to start
echo "[7/8] Waiting for the container to start..."
sleep 30

# 11. Verify that it is running
echo "[8/8] Checking status..."
CONTAINER_STATUS=$(sudo docker inspect -f '{{.State.Status}}' ${APP_NAME} 2>/dev/null || echo "not_found")

if [ "$CONTAINER_STATUS" = "running" ]; then
    echo "==========================================="
    echo "CONTAINER RUNNING CORRECTLY"
    echo "==========================================="
    echo "📦 Image: ${DOCKER_IMAGE}"
    echo "🔗 Port: ${PORT}"
    echo "🆔 Container ID: $(sudo docker ps -q --filter name=${APP_NAME})"
    
    # Test that it responds
    echo "🏥 Testing app health..."
    if curl -f -s -o /dev/null -w "%{http_code}" http://localhost:${PORT} | grep -q "200"; then
        echo "Application responds HTTP 200"
    else
        echo "The application is not responding with 200"
        sudo docker logs ${APP_NAME} --tail 20
    fi
else
    echo "==========================================="
    echo "ERROR: CONTAINER IS NOT RUNNING"
    echo "==========================================="
    echo "Estatus: ${CONTAINER_STATUS}"
    echo "Container logs:"
    sudo docker logs ${APP_NAME} 2>/dev/null || echo "No logs available"
    exit 1
fi

# System information
echo ""
echo "SYSTEM INFORMATION:"
echo "Hostname: $(hostname)"
echo "IP Private: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo "IP Public: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "Region: $(curl -s http://169.254.169.254/latest/meta-data/placement/region)"
echo ""
echo "SETUP SUCCESSFULLY COMPLETED"
echo "==========================================="