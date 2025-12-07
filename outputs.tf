output "instance_public_ip" {
  value       = aws_eip.web_eip.public_ip
  description = "IP pública de la instancia"
}

output "application_url" {
  value       = "http://${aws_eip.web_eip.public_ip}"
  description = "URL de la aplicación"
}