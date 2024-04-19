variable "name" {
  description = "Name of the subnet, actual name will be, for example: name_ap-northeast-2a"
}

variable "environment" {
  description = "The name of the environment"
}

variable "cidrs" {
  type        = list
  description = "List of cidrs, for every availability zone you want you need one. Example: 10.12.101.0/24 and 10.12.106.0/24"
}

variable "availability_zones" {
  type        = list
  description = "List of availability zones you want. Example: ap-northeast-2a and ap-northeast-2b"
}

variable "vpc_id" {
  description = "VPC id to place subnet into"
}
