variable "alb_name" {
  description = "Name of the ALB"
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

# variable "alb_security_group_id" {
#   description = "ID of the ALB Security Group"
#   type        = string
# }