# outputs.tf - Lo que Terraform nos mostrará

output "application_url" {
  value       = "http://${aws_eip.public_ip.public_ip}"
  description = "URL para acceder a tu aplicación"
}

output "instance_id" {
  value       = aws_instance.hello_world.id
  description = "ID de la instancia EC2"
}

output "public_ip" {
  value       = aws_eip.public_ip.public_ip
  description = "IP pública de la instancia"
}