# ECS Cluster
resource "aws_ecs_cluster" "dev_cluster" {
  name = var.cluster_name
}

# ECS Task Definition
resource "aws_ecs_task_definition" "dev_task" {
  family                   = "dev-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = <<DEFINITION
[
  {
    "name": "dev-app",
    "image": "${var.app_image_uri}",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.dev_app_logs.name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
}

# ECS Service
resource "aws_ecs_service" "dev_service" {
  name            = "dev-service"
  cluster         = aws_ecs_cluster.dev_cluster.id
  task_definition = aws_ecs_task_definition.dev_task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "dev-app"
    container_port   = 3000
  }
}

# Security Group for ECS Task
resource "aws_security_group" "ecs_task_sg" {
  name        = "ecs-task-security-group"
  description = "Allow traffic from ALB to ECS Tasks"
  vpc_id      = var.vpc_id

  # Inbound Rules
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.alb_security_group_id]
  }

  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-task-security-group"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "dev_app_logs" {
  name              = "/ecs/dev-app"
  retention_in_days = 30 
}

# CloudWatch Log Group for Nginx
resource "aws_cloudwatch_log_group" "nginx_logs" {
  name              = "/ecs/nginx"
  retention_in_days = 30
}