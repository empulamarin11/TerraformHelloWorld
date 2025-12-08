output "load_balancer_dns" {
  value       = aws_lb.web_alb.dns_name
  description = "Application Load Balancer DNS"
}

output "load_balancer_url" {
  value       = "http://${aws_lb.web_alb.dns_name}"
  description = "Full URL of the application"
}

output "instance_count" {
  value       = aws_autoscaling_group.web_asg.desired_capacity
  description = "Number of instances deployed"
}

output "auto_scaling_group_name" {
  value       = aws_autoscaling_group.web_asg.name
  description = "Name of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = aws_launch_template.web_lt.id
  description = "Launch Template ID"
}

output "target_group_arn" {
  value       = aws_lb_target_group.web_tg.arn
  description = "Target Group ARN"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "security_group_ids" {
  value = {
    alb      = aws_security_group.alb_sg.id
    instance = aws_security_group.instance_sg.id
  }
  description = "Security Group IDs"
}