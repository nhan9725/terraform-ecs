output "ecs_cluster_name" {
  value = aws_ecs_cluster.dev_cluster.name
  description = "Name of the ECS Cluster"
}

output "ecs_service_name" {
  value = aws_ecs_service.dev_service.name
  description = "Name of the ECS Service"
}