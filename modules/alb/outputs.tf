output "alb_dns_name" {
  value = aws_lb.dev_alb.dns_name
  description = "DNS Name of the ALB"
}

output "target_group_arn" {
  value = aws_lb_target_group.dev_tg.arn
  description = "ARN of the Target Group"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID of the ALB Security Group"
}
