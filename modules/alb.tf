

# load balancer
resource "aws_lb" "frog-alb" {
  name                = "frog-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.frog-alb-securitygroup.id]
  subnets             = [aws_subnet.frog-public-1.id, aws_subnet.frog-public-2.id]

  enable_deletion_protection = false

  tags = {
    Name = "frog-alb"
  }
}

# ALB Target group
resource "aws_lb_target_group" "frog-target-group" {
  name        = "frog-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.frog.id

  health_check {
    path                = "/health"  # Replace with your health check path
    interval            = 60
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
}

# ALB Listener
resource "aws_lb_listener" "frog-listener" {
  load_balancer_arn = aws_lb.frog-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.frog-target-group.arn
    type             = "forward"
  }
}
