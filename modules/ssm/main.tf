/*
    ssm 네이밍 규칙
  {환경}_{프로젝트명}_*
*/


// TODO 추후에 for문을 사용하여 프로젝트마다 생성해서 코드 간결화 필요


// common ssm

resource "aws_ssm_parameter" "dev_common_mysql_port" {
  name  = "dev_common_mysql_port"
  type  = "String"
  value = var.dev_common_mysql_port
}

resource "aws_ssm_parameter" "dev_common_mysql_host"{
  name = "dev_common_mysql_host"
  type = "String"
  value = var.dev_common_mysql_host
}


resource "aws_ssm_parameter" "dev_common_redis_port" {
  name  = "dev_common_redis_port"
  type  = "String"
  value = var.dev_common_redis_port
}

resource "aws_ssm_parameter" "dev_common_redis_host" {
  name  = "dev_common_redis_host"
  type  = "String"
  value = var.dev_common_redis_host
}


// frog 프로젝트 ssm 
resource "aws_ssm_parameter" "dev_frog_mysql_user" {
  name  = "dev_frog_mysql_user"
  type  = "String"
  value = var.dev_frog_mysql_user
}

resource "aws_ssm_parameter" "dev_frog_mysql_db" {
  name  = "dev_frog_mysql_db"
  type  = "String"
  value = var.dev_frog_mysql_db
}

resource "aws_ssm_parameter" "dev_frog_redis_user" {
  name  = "dev_frog_redis_user"
  type  = "String"
  value = var.dev_frog_redis_user
}

resource "aws_ssm_parameter" "dev_frog_redis_db" {
  name  = "dev_frog_redis_db"
  type  = "String"
  value = var.dev_frog_redis_db
}

// food 프로젝트 ssm
resource "aws_ssm_parameter" "dev_food_mysql_user" {
  name  = "dev_food_mysql_user"
  type  = "String"
  value = var.dev_food_mysql_user
}

resource "aws_ssm_parameter" "dev_food_mysql_db" {
  name  = "dev_food_mysql_db"
  type  = "String"
  value = var.dev_food_mysql_db
}

resource "aws_ssm_parameter" "dev_food_redis_user" {
  name  = "dev_food_redis_user"
  type  = "String"
  value = var.dev_food_redis_user
}

resource "aws_ssm_parameter" "dev_food_redis_db" {
  name  = "dev_food_redis_db"
  type  = "String"
  value = var.dev_food_redis_db
}
