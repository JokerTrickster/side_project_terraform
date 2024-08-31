variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_route_table_ids" {
  description = "List of private subnet route table IDs"
  type        = list(string)
}

variable "private_subnets_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

variable "dev_common_nat_instance_network_interface_id"   {
  description = "The ID of the NAT instance network interface"
  type        = string
  
}