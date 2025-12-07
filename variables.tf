variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "hello-world-app"
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block para la primera subred pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block para la segunda subred pública"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_1" {
  description = "Primera zona de disponibilidad"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Segunda zona de disponibilidad"
  type        = string
  default     = "us-east-1b"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "docker_image" {
  description = "Imagen de Docker Hub a desplegar"
  type        = string
  default     = "erick1109/hello-world-app:v1"
}

variable "min_instances" {
  description = "Número mínimo de instancias en Auto Scaling"
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "Número máximo de instancias en Auto Scaling"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Capacidad deseada en Auto Scaling"
  type        = number
  default     = 2
}