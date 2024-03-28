variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykeypair"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykeypair.pub"
}

variable "ECS_INSTANCE_TYPE" {
  default = "t4g.micro"
}

variable "ECS_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-04c97e62cb19d53f1"
  }
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-04c97e62cb19d53f1"
  }
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}

