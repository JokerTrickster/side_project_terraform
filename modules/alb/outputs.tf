output "dev_common_alb_sg_id" {
  value = aws_security_group.dev_common_alb_sg.id
}

output "dev_common_alb_target_group" {
  value = aws_alb_target_group.dev_common_target_group.arn
}
