module "network" {
  source               = "../network"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  depends_id           = ""
}
module "ecs_roles" {
  source      = "../ecs_roles"
  environment = var.environment
  cluster     = var.cluster
}

module "ecs_instances" {
  source = "../ecs_instances"

  environment             = var.environment
  cluster                 = var.cluster
  instance_group          = var.instance_group
  private_subnet_ids      = module.network.private_subnet_ids
  aws_ami                 = var.ecs_aws_ami
  instance_type           = var.instance_type
  max_size                = var.max_size
  min_size                = var.min_size
  desired_capacity        = var.desired_capacity
  vpc_id                  = module.network.vpc_id
  iam_instance_profile_id = aws_iam_instance_profile.ecs.id
  key_name                = var.key_name
  load_balancers          = var.load_balancers
  depends_id              = module.network.depends_id
  custom_userdata         = var.custom_userdata
  cloudwatch_prefix       = var.cloudwatch_prefix
}


resource "aws_ecs_cluster" "cluster" {
  name = var.cluster
}


resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.environment}_${var.cluster}" //dev_frog
  container_definitions = jsonencode([
    {
      name      = "${var.environment}_${var.cluster}"
      image     = "service-first"
      cpu       = 2048
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocal      = "tcp"
        }
      ]
      environment = [
                {
                    name: "PROJECT",
                    value: "frog"
                },
                {
                    name: "PORT",
                    value: "80"
                },
                {
                    name: "ENV",
                    value: "__ENV__"
                },
                {
                    name: "REGION",
                    value: "__REGION__"
                },
                {
                    name: "IS_LOCAL",
                    value: "false"
                },
                {
                    name: "MYSQL_USER",
                    value: "frog"
                },
                {
                    name: "MYSQL_PASSWORD",
                    value: "examplepassword"
                },
                {
                    name: "MYSQL_HOST",
                    value: "devstg_mongodb.internal_ap-northeast-2"
                },
                {
                    name: "MYSQL_PORT",
                    value: "3306"
                },
                {
                    name: "MYSQL_DATABASE",
                    value: "frog_dev"
                }
      ]

    }
  ])
  network_mode = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn = module.ecs_roles.ecs_default_task_execution_role_arn
  task_role_arn = module.ecs_roles.ecs_default_task_role_arn
  
}