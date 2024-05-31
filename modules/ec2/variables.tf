variable "environment" {
  description = "The environment to deploy to"
}

variable "vpc_id" {
    description = "The VPC id"
}

variable "subnet_ids" {
    type        = list
    description = "The subnet ids"
  
}
variable "key_name" {
    description = "The key name"
}

