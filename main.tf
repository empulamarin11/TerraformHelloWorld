terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. VPC (Red Virtual Privada)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# 2. Subred Pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet"
    Environment = var.environment
    Type        = "Public"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# 4. Tabla de Rutas Pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# 5. Asociar Subred con Tabla de Rutas
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 6. Security Group (Firewall) - VERSIÓN SIMPLIFICADA PARA PRÁCTICA
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Permitir HTTP y SSH para práctica"
  vpc_id      = aws_vpc.main.id

  # HTTP desde cualquier lugar
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH desde cualquier lugar (PARA PRÁCTICA - cambiar en producción)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida a Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-web-sg"
    Environment = var.environment
  }
}

# 7. Instancia EC2 - VERSIÓN SIMPLIFICADA (sin ALB/ASG por ahora)
resource "aws_instance" "hello_world" {
  # ✅ AMI CORREGIDA - Amazon Linux 2 actualizada en us-east-1
  ami           = "ami-0c02fb55956c7d316"  # AMI actualizada y funcional
  
  instance_type = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  # Script que se ejecuta al iniciar (usa tu imagen Docker Hub)
  user_data = <<-EOF
              #!/bin/bash
              # Instalar Docker
              amazon-linux-extras install docker -y
              service docker start
              
              # Descargar TU imagen de Docker Hub
              docker pull ${var.docker_image}
              
              # Ejecutar contenedor
              docker run -d -p 80:80 ${var.docker_image}
              EOF
  
  tags = {
    Name        = var.project_name
    Environment = var.environment
    Project     = "TerraformHelloWorld"
    ManagedBy   = "Terraform"
  }
}

# 8. IP Pública Elástica
resource "aws_eip" "public_ip" {
  instance = aws_instance.hello_world.id
  vpc      = true
  
  tags = {
    Name        = "${var.project_name}-eip"
    Environment = var.environment
  }
}