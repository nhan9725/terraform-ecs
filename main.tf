# Provider Configuration
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "test-devops-terraform" 
    key            = "terraform.tfstate"       
    region         = "ap-southeast-1"               
    dynamodb_table = "terraform-state-lock"    
    encrypt        = true
  }
}

# Module for IAM Role
module "iam" {
  source = "./modules/iam"

  account_id   = var.account_id
  github_repo  = var.github_repo
}

# Module for ECR
# module "ecr" {
#   source = "./modules/ecr"

#   repository_name = "dev-app"
# }

# Module for ECS
module "ecs" {
  source = "./modules/ecs"
  region = var.region
  cluster_name       = "dev-cluster"
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  target_group_arn   = module.alb.target_group_arn
  app_image_uri      = var.app_image_uri 
  nginx_image_uri    = var.nginx_image_uri 
  execution_role_arn = module.iam.ecs_task_execution_role_arn 
  alb_security_group_id = module.alb.alb_security_group_id

  depends_on = [module.iam,module.alb]
}

# Module for ALB
module "alb" {
  source = "./modules/alb"

  alb_name           = "dev-alb"
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  domain_name        = var.domain_name
  acm_certificate_arn = var.acm_certificate_arn
}