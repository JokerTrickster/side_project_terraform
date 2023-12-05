# cluster
resource "aws_ecs_cluster" "frog-cluster" {
  name = "frog-cluster"
}
resource "aws_ecs_task_definition" "frog-task-definition" {
  family                   = "frog-container"
  requires_compatibilities = ["EC2"]
  cpu                      = "1024"
  memory                   = "856"
  execution_role_arn       = aws_iam_role.frog-task-execution-role.arn

  container_definitions = jsonencode([
    {
      "name"        = "frog-container",
      "image"       = aws_ecr_repository.frog.repository_url,
      "cpu"         = 1024,
      "memory"      = 856,
      "essential"   = true,
      "portMappings" = [
        {
          "containerPort" = 80,
          "hostPort"      = 80,
          "protocol"      = "tcp"
        }
      ],
      "environment" = [
        {
          "name"  = "PROJECT",
          "value" = "frog"
        },
        {
          "name"  = "PORT",
          "value" = "80"
        },
        {
          "name"  = "ENV",
          "value" = "dev"
        },
        {
          "name"  = "IS_LOCAL",
          "value" = "false"
        },
        {
          "name"  = "REGION",
          "value" = "us-east-1"
        }
      ],
      "mountPoints"      = [],
      "volumesFrom"      = [],
      "linuxParameters"  = {
        "maxSwap"    = 0,
        "swappiness" = 0
      },
      "disableNetworking" = false,
      "privileged"        = false,
      "ulimits"           = [
        {
          "name"      = "nofile",
          "softLimit" = 65535,
          "hardLimit" = 65535
        }
      ],
      "logConfiguration" = {
        "logDriver" = "awslogs",
        "options"   = {
          "awslogs-group"  = "ecs-dev-frog",
          "awslogs-region" = "us-east-1"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "frog-ecs-service" {
  name            = "frog-ecs-service"
  cluster         = aws_ecs_cluster.frog-cluster.id
  task_definition = aws_ecs_task_definition.frog-task-definition.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets = [aws_subnet.frog-public-1.id, aws_subnet.frog-public-2.id]
    security_groups = [aws_security_group.frog-ecs-securitygroup.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frog-target-group.arn
    container_name   = "frog-container"  
    container_port   = 80
  }
}


resource "aws_launch_configuration" "frog-ecs-launchconfig" {
  name_prefix          = "frog-ecs-launchconfig"
  image_id             = var.ECS_AMIS[var.AWS_REGION]
  instance_type        = var.ECS_INSTANCE_TYPE
  key_name             = aws_key_pair.mykeypair.key_name
  iam_instance_profile = aws_iam_instance_profile.frog-task-execution-role.id
  security_groups      = [aws_security_group.frog-ecs-securitygroup.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=frog-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "frog-ecs-autoscaling" {
  name                 = "frog-ecs-autoscaling"
  vpc_zone_identifier  = [aws_subnet.frog-public-1.id, aws_subnet.frog-public-2.id]
  launch_configuration = aws_launch_configuration.frog-ecs-launchconfig.name
  min_size             = 1
  max_size             = 1
  tag {
    key                 = "Name"
    value               = "frog-ecs-ec2-container"
    propagate_at_launch = true
  }
}

