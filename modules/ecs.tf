# cluster
resource "aws_ecs_cluster" "frog-cluster" {
  name = "frog-cluster"
}

resource "aws_launch_configuration" "frog-ecs-launchconfig" {
  name_prefix          = "frog-ecs-launchconfig"
  image_id             = var.ECS_AMIS[var.AWS_REGION]
  instance_type        = var.ECS_INSTANCE_TYPE
  key_name             = aws_key_pair.mykeypair.key_name
  iam_instance_profile = aws_iam_instance_profile.frog-ecs-ec2-role.id
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

