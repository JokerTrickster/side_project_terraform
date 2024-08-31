// common 변수
variable "dev_common_mysql_port" {
    description = "MySQL port"
    default = "3306"
}
variable "dev_common_mysql_host" { 
    description = "MySQL host"
    default = "localhost"
}

variable "dev_common_redis_port" {
    description = "Redis port"
    default = "6379"
}

variable "dev_common_redis_host" {
    description = "Redis host"
    default = "localhost"
}


//frog 프로젝트 변수
variable "dev_frog_mysql_user" {
    description = "MySQL user"
    default = "frog"
}

variable "dev_frog_mysql_db" {
    description = "MySQL database"
    default = "frog_dev"
}
variable "dev_frog_redis_user" {
    description = "Redis user"
    default = "frog"  
}

variable "dev_frog_redis_db" {
    description = "Redis database"
    default = "1"
}


//food 변수
variable "dev_food_mysql_user" {
    description = "MySQL user"
    default = "food"
}

variable "dev_food_mysql_db" {
    description = "MySQL database"
    default = "dev_food"
}

variable "dev_food_redis_user" {
    description = "Redis user"
    default = "food"  
}

variable "dev_food_redis_db" {
    description = "Redis database"
    default = "0"
}
