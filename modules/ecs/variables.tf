variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the Target Group for the ALB"
  type        = string
}

variable "app_image_uri" {
  description = "Docker image URI for the application"
  type        = string
  default     = "your-default-app-image-uri:latest" # Giá trị mặc định
}

variable "nginx_image_uri" {
  description = "Docker image URI for Nginx"
  type        = string
  default     = "nginx:latest" # Giá trị mặc định
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID of the ALB Security Group"
  type        = string
}