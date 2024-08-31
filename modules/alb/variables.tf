
variable "environment" {
  description = "The name of the environment"
}

variable "public_subnet_ids" {
  type        = list
  description = "List of public subnet ids to place the loadbalancer in"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "health_check_path" {
  default     = "/health"
  description = "The default health check path"
}

variable "allow_cidr_block" {
  default     = ["0.0.0.0/0"]
  description = "Specify cidr block that is allowed to access the LoadBalancer"
}

variable "certificate_arn"{
  default     = "arn:aws:acm:ap-northeast-2:730335282594:certificate/272564fe-09a2-46a4-8f99-6869fa043ce1"
  description = "The ARN of the certificate to use for HTTPS"
}

variable "dev_common_hosted_zone"{
  default     = "jokertrickster.com"
  description = "The hosted zone to use for the DNS record"
}