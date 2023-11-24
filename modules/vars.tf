variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "ryankey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "ryankey.pub"
}

variable "ECS_INSTANCE_TYPE" {
  default = "t4g.micro"
}

variable "ECS_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-1924770e"
  }
}

# Full List: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0f5c19168a4bb46d3"
  }
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}
