# Default ALB implementation that can be used connect ECS instances to it

//frog 프로젝트 타겟그룹
resource "aws_alb_target_group" "dev_frog_target_group" {
  name                 = "dev-frog-target-group"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  target_type          = "ip"

  health_check {
    path     = var.health_check_path
    protocol = "HTTP"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_alb" "dev_common_alb" {
  name            = "dev-common-alb"
  subnets         = var.public_subnet_ids
  security_groups = ["${aws_security_group.dev_common_alb_sg.id}"]

  tags = {
    Environment = var.environment
  }
}

# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_alb.dev_common_alb.id
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.dev_frog_target_group.id
#     type             = "forward"
#   }
# }

# resource "aws_alb_listener" "https"{
#   load_balancer_arn = aws_alb.dev_common_alb.id
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     target_group_arn = aws_alb_target_group.dev_frog_target_group.id
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Fixed response content"
#       status_code  = "404"
#     }
#   }
# }
// food 타겟 그룹 
resource "aws_alb_target_group" "dev_food_target_group" {
  name                 = "dev-food-target-group"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  target_type          = "ip"

  health_check {
    path     = var.health_check_path
    protocol = "HTTP"
  }

  tags = {
    Environment = var.environment
  }
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.dev_common_alb.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
      type = "forward"
      forward {
        target_group {
          arn    = aws_alb_target_group.dev_food_target_group.id
          weight = 1
        }
        target_group {
          arn    = aws_alb_target_group.dev_frog_target_group.id
          weight = 2
        }
      }
    }
}

resource "aws_alb_listener" "https"{
  load_balancer_arn = aws_alb.dev_common_alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
      type = "forward"
      forward {
        target_group {
          arn    = aws_alb_target_group.dev_food_target_group.id
          weight = 1
        }
        target_group {
          arn    = aws_alb_target_group.dev_frog_target_group.id
          weight = 2
        }
      }
    }
}

// alb 보안그룹
resource "aws_security_group" "dev_common_alb_sg" {
  name   = "dev_common_alb_sg"
  vpc_id = var.vpc_id

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = var.allow_cidr_block
  security_group_id = aws_security_group.dev_common_alb_sg.id
}

resource "aws_security_group_rule" "https_from_anywhere"{
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = var.allow_cidr_block
  security_group_id = aws_security_group.dev_common_alb_sg.id
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dev_common_alb_sg.id
}


// route53 record for the ALB


data "aws_route53_zone" "dev_common_hosted_zone" {
  name = var.dev_common_hosted_zone
}


//frog 
resource "aws_route53_record" "dev_frog_api" {
  zone_id = data.aws_route53_zone.dev_common_hosted_zone.zone_id
  name    = "dev-frog-api"
  type    = "A"

  alias {
    name                   = aws_alb.dev_common_alb.dns_name
    zone_id                = aws_alb.dev_common_alb.zone_id
    evaluate_target_health = false
  }
}

//food
resource "aws_route53_record" "dev_food-recommendation_api" {
  zone_id = data.aws_route53_zone.dev_common_hosted_zone.zone_id
  name    = "dev-food-recommendation-api"
  type    = "A"

  alias {
    name                   = aws_alb.dev_common_alb.dns_name
    zone_id                = aws_alb.dev_common_alb.zone_id
    evaluate_target_health = false
  }
}