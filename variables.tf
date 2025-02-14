variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "github_repo" {
  description = "GitHub Repository (e.g., owner/repo)"
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

variable "domain_name" {
  description = "Domain Name for the ALB"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the SSL Certificate in ACM"
  type        = string
}

variable "app_image_uri" {
  description = "Docker image URI for the application"
  type        = string
}

variable "nginx_image_uri" {
  description = "Docker image URI for Nginx"
  type        = string
}