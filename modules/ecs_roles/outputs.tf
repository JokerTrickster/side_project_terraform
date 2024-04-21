output "ecs_default_task_execution_role_arn" {
  value = aws_iam_role.ecs_default_task_execution_role.arn
}

output "ecs_default_task_role_arn" {
  value = aws_iam_role.ecs_default_task_role.arn
}