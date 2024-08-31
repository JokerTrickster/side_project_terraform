provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "ecs" {
  source = "./modules/ecs"

  environment          = var.environment
  cluster              = var.cluster
  cloudwatch_prefix    = "${var.environment}"           #See ecs_instances module when to set this and when not!
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  key_name             = aws_key_pair.ecs.key_name
  instance_type        = var.instance_type
  ecs_aws_ami          = var.aws_ecs_ami
}

resource "aws_key_pair" "ecs" {
  key_name   = "ecs-key-${var.environment}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD6NDOEou6+NFfCVM7GP/TYxjzzngyc7aUCMdt+gnSSSvKM/IEU8pje9VVOcApeYM/uPSwN7Z71OyRLM2yvlW1oCYdnXHSe5lE49FdnHM/k+p/b+ysiKQzeGdCU6xrtpWBWwC4YC0Ap6BTse+VG+Hfoyy1tgHFsW+w94RW9qLD8rx0ot6zF9EqYQGlbch1FGEoouKOIzmbuRhXLRS2jUPvNUGuiLnyi1lsPLemlb1A+sUREOREX7ePB4pGg41ZNbiKWAI+9eGI+jkbG0qV9oMOlOLhBGFo/x4jb1wYLHMHl9+D3JdUV2QgZ6PYBRl64QsG2zbTbwfqW7ZXuTjzAcrwL mac@MACui-MacBookPro.local"
}

variable "environment" {
  description = "A name to describe the environment we're creating."
}
variable "cluster" {
  description = "The name of the ECS cluster."
}
variable "aws_profile" {
  description = "The AWS-CLI profile for the account to create resources in."
}
variable "aws_region" {
  description = "The AWS region to create resources in."
}
variable "aws_ecs_ami" {
  description = "The AMI to seed ECS instances with."
}
variable "vpc_cidr" {
  description = "The IP range to attribute to the virtual network."
}
variable "public_subnet_cidrs" {
  description = "The IP ranges to use for the public subnets in your VPC."
  type = list
}
variable "private_subnet_cidrs" {
  description = "The IP ranges to use for the private subnets in your VPC."
  type = list
}
variable "availability_zones" {
  description = "The AWS availability zones to create subnets in."
  type = list
}
variable "max_size" {
  description = "Maximum number of instances in the ECS cluster."
}
variable "min_size" {
  description = "Minimum number of instances in the ECS cluster."
}
variable "desired_capacity" {
  description = "Ideal number of instances in the ECS cluster."
}
variable "instance_type" {
  description = "Size of instances in the ECS cluster."
}

output "dev_common_target_group" {
  value = module.ecs.dev_common_target_group
}
