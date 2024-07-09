# You can have multiple ECS clusters in the same account with different resources.
# Therefore all resources created here have a name containing the name of the:
# environment, cluster name, and the instance_group name.
# That is also the reason why ecs_instances is a seperate module and not everything is created here.

# Get latest Linux 2 ECS-optimized AMI by Amazon
data "aws_ami" "latest_ecs_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "instance" {
  name        = "${var.environment}_${var.cluster}_${var.instance_group}"
  description = "Used in ${var.environment}"
  vpc_id      = var.vpc_id

  tags = {
    Environment   = var.environment
    Cluster       = var.cluster
    InstanceGroup = var.instance_group
  }
}

# We separate the rules from the aws_security_group because then we can manipulate the 
# aws_security_group outside of this module
resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "inbound_internet_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance.id
}

# Default disk size for Docker is 22 gig, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
resource "aws_launch_template" "launch_template" {
  name_prefix          = "${var.environment}_${var.cluster}_${var.instance_group}_"
  image_id             = var.aws_ami != "" ? var.aws_ami : data.aws_ami.latest_ecs_ami.image_id
  instance_type        = var.instance_type
  iam_instance_profile {
    name = var.iam_instance_profile_id
  }
  key_name             = var.key_name
  user_data            = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.cluster} >> /etc/ecs/ecs.config
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment   = var.environment
      Cluster       = var.cluster
      InstanceGroup = var.instance_group
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "${var.environment}_${var.cluster}_${var.instance_group}"
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.private_subnet_ids
  # launch_template {
  #   id      = aws_launch_template.launch_template.id
  #   version = "$Latest"
  # }

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.launch_template.id
        version            = "$Latest"
      }

      override {
        instance_type = var.instance_type
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}_ecs_${var.cluster}_${var.instance_group}_spot"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Cluster"
    value               = var.cluster
    propagate_at_launch = "true"
  }

  tag {
    key                 = "InstanceGroup"
    value               = var.instance_group
    propagate_at_launch = "true"
  }

  force_delete = true
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars = {
    ecs_config        = var.ecs_config
    ecs_logging       = var.ecs_logging
    cluster_name      = var.cluster
    env_name          = var.environment
    custom_userdata   = var.custom_userdata
    cloudwatch_prefix = var.cloudwatch_prefix
  }
}