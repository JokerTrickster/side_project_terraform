/*
    네이밍 규칙
    {환경}_{프로젝트명}_*
*/

// frog 프로젝트 
resource "aws_ecr_repository" "dev_frog_ecr_repository" {
  name                 = "dev_frog_repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  } 
}

// food 프로젝트
resource "aws_ecr_repository" "dev_food_ecr_repository" {
  name                 = "dev_food_repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}