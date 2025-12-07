output "application_url" {
  value       = "http://${aws_eip.public_ip.public_ip}"
  description = "URL para acceder a tu aplicación Hola Mundo"
}

output "public_ip" {
  value       = aws_eip.public_ip.public_ip
  description = "IP pública del servidor"
}

output "instance_id" {
  value       = aws_instance.hello_world.id
  description = "ID de la instancia EC2"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID de la VPC"
}

output "security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "ID del Security Group"
}