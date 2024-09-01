output "dev_common_alb_sg_id" {
  value = aws_security_group.dev_common_alb_sg.id
}

output "dev_frog_alb_target_group" {
  value = aws_alb_target_group.dev_frog_target_group.arn
}


output "dev_food_alb_target_group" {
  value = aws_alb_target_group.dev_food_target_group.arn
}