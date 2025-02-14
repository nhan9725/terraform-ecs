output "github_actions_oidc_role_arn" {
  value = module.iam.github_actions_oidc_role_arn
  description = "ARN of the IAM Role for GitHub Actions with OIDC"
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
  description = "Name of the ECS Cluster"
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
  description = "Name of the ECS Service"
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
  description = "DNS Name of the ALB"
}
