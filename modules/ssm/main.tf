


resource "aws_ssm_parameter" "dev_mysql_user" {
  name  = "dev_mysql_user"
  type  = "String"
  value = var.mysql_user
}

resource "aws_ssm_parameter" "dev_mysql_db" {
  name  = "dev_mysql_db"
  type  = "String"
  value = var.mysql_db
}

resource "aws_ssm_parameter" "dev_mysql_port" {
  name  = "dev_mysql_port"
  type  = "String"
  value = var.mysql_port
}

resource "aws_ssm_parameter" "dev_mysql_host"{
  name = "dev_mysql_host"
  type = "String"
  value = var.mysql_host
}

