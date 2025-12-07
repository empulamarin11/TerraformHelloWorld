# variables.tf - Variables configurables

variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "docker_image" {
  description = "Imagen de Docker a usar"
  type        = string
  default     = "erick1109/hello-world-app:v1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "hello-world"
}