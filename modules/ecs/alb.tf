module "alb" {
  source = "../alb"

  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  source_security_group_id = module.alb.dev_common_alb_sg_id
  security_group_id        = module.ecs_instances.dev_common_ecs_instance_sg_id
}
