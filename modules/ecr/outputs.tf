//frog 프로젝트
output "dev_frog_ecr_repository_url" {
    value = aws_ecr_repository.dev_frog_ecr_repository.repository_url
}

output "dev_frog_ecr_repository_name" {
    value = aws_ecr_repository.dev_frog_ecr_repository.name
}

// food 프로젝트
output "dev_food_ecr_repository_url" {
    value = aws_ecr_repository.dev_food_ecr_repository.repository_url
}

output "dev_food_ecr_repository_name" {
    value = aws_ecr_repository.dev_food_ecr_repository.name
}