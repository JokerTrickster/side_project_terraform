# app

resource "aws_ecs_task_definition" "frog-task-definition" {
  family                = "frog"
  container_definitions = templatefile("templates/app.json.tpl", {
    REPOSITORY_URL = replace(aws_ecr_repository.frog.repository_url, "https://", "")
    APP_VERSION    = 0
  })
}

resource "aws_ecs_service" "frog-service" {
  count           = 0
  name            = "frog"
  cluster         = aws_ecs_cluster.frog-cluster.id
  task_definition = aws_ecs_task_definition.frog-task-definition.arn
  desired_count   = 1
  iam_role        = aws_iam_role.frog-ecs-service-role.arn
  depends_on      = [aws_iam_policy_attachment.frog-ecs-service-attach1]

  load_balancer {
    elb_name       = aws_elb.frog-elb.name
    container_name = "frog"
    container_port = 3000
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

# load balancer
resource "aws_elb" "frog-elb" {
  name = "frog-elb"

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:3000/"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = [aws_subnet.frog-public-1.id, aws_subnet.frog-public-2.id]
  security_groups = [aws_security_group.frog-elb-securitygroup.id]

  tags = {
    Name = "frog-elb"
  }
}

