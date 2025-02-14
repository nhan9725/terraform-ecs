# ALB
resource "aws_lb" "dev_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id] 
  subnets            = var.subnet_ids
}

# Target Group for app
resource "aws_lb_target_group" "dev_tg" {
  name     = "dev-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthcheck"               
    port                = "traffic-port"    
    protocol            = "HTTP"            
    healthy_threshold   = 2                 
    unhealthy_threshold = 2                 
    timeout             = 5                 
    interval            = 30                
    matcher             = "200"             
  }
  # lifecycle {
  #   prevent_destroy = true 
  # }
}

# Target Group for Nginx
resource "aws_lb_target_group" "nginx_tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.dev_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.dev_tg.arn
  }
  depends_on = [aws_lb_target_group.dev_tg]
}

# HTTP Listener (Redirect to HTTPS)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.dev_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [aws_lb_target_group.dev_tg]
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP and HTTPS traffic from the internet to the ALB"
  vpc_id      = var.vpc_id

  # Inbound Rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

# HTTPS Listener Rule for Domain
resource "aws_lb_listener_rule" "domain_rule" {
  listener_arn = aws_lb_listener.https_listener.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }

  condition {
    path_pattern {
      values = ["/*"] 
  }  
}
}