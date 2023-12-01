resource "aws_security_group" "frog-ecs-securitygroup" {
  vpc_id      = aws_vpc.frog.id
  name        = "ecs"
  description = "frog project security group for ecs"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frog-elb-securitygroup.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "frog-ecs"
  }
}

# elb security group
resource "aws_security_group" "frog-elb-securitygroup" {
  vpc_id      = aws_vpc.frog.id
  name        = "frog-elb"
  description = "frog security group for ecs"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "frog-elb"
  }
}
