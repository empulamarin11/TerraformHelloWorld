# main.tf - Versión SIMPLIFICADA para empezar

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Security Group (Firewall)
resource "aws_security_group" "web_sg" {
  name        = "hello-world-sg"
  description = "Permitir HTTP y SSH"

  # HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH solo desde tu IP (cambia esto después)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # CAMBIAR ESTO DESPUÉS
  }

  # Salida a internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hello-world-sg"
  }
}

# 2. Instancia EC2
resource "aws_instance" "hello_world" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
  instance_type = "t2.micro"
  
  # Usar el Security Group
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  # Script que se ejecuta al iniciar
  user_data = <<-EOF
              #!/bin/bash
              # Instalar Docker
              amazon-linux-extras install docker -y
              service docker start
              
              # Descargar TU imagen de Docker Hub
              docker pull erick1109/hello-world-app:v1
              
              # Ejecutar contenedor
              docker run -d -p 80:80 erick1109/hello-world-app:v1
              EOF

  tags = {
    Name = "Hello-World-App"
  }
}

# 3. IP Pública
resource "aws_eip" "public_ip" {
  instance = aws_instance.hello_world.id
  vpc      = true
}