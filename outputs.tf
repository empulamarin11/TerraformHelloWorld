output "load_balancer_dns" {
  value       = aws_lb.web_alb.dns_name
  description = "DNS del Application Load Balancer"
}

output "load_balancer_url" {
  value       = "http://${aws_lb.web_alb.dns_name}"
  description = "URL completa de la aplicación"
}

output "instance_count" {
  value       = aws_autoscaling_group.web_asg.desired_capacity
  description = "Número de instancias desplegadas"
}

output "auto_scaling_group_name" {
  value       = aws_autoscaling_group.web_asg.name
  description = "Nombre del Auto Scaling Group"
}

output "launch_template_id" {
  value       = aws_launch_template.web_lt.id
  description = "ID del Launch Template"
}

output "target_group_arn" {
  value       = aws_lb_target_group.web_tg.arn
  description = "ARN del Target Group"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID de la VPC"
}

output "security_group_ids" {
  value = {
    alb      = aws_security_group.alb_sg.id
    instance = aws_security_group.instance_sg.id
  }
  description = "IDs de los Security Groups"
}