
# Internet VPC
resource "aws_vpc" "frog" {
  cidr_block           = "10.15.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "frog"
  }
}

# Subnets
resource "aws_subnet" "frog-public-1" {
  vpc_id                  = aws_vpc.frog.id
  cidr_block              = "10.15.0.0/19"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "frog-public-1"
  }
}

resource "aws_subnet" "frog-public-2" {
  vpc_id                  = aws_vpc.frog.id
  cidr_block              = "10.15.32.0/19"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "frog-public-2"
  }
}


resource "aws_subnet" "frog-private-1" {
  vpc_id                  = aws_vpc.frog.id
  cidr_block              = "10.15.64.0/18"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "frog-private-1"
  }
}

resource "aws_subnet" "frog-private-2" {
  vpc_id                  = aws_vpc.frog.id
  cidr_block              = "10.15.128.0/18"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "frog-private-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "frog-gw" {
  vpc_id = aws_vpc.frog.id

  tags = {
    Name = "frog"
  }
}

# route tables
resource "aws_route_table" "frog-public" {
  vpc_id = aws_vpc.frog.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.frog-gw.id
  }

  tags = {
    Name = "frog-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "frog-public-1-a" {
  subnet_id      = aws_subnet.frog-public-1.id
  route_table_id = aws_route_table.frog-public.id
}

resource "aws_route_table_association" "frog-public-2-a" {
  subnet_id      = aws_subnet.frog-public-2.id
  route_table_id = aws_route_table.frog-public.id
}

# route tables for private subnets
resource "aws_route_table" "frog-private" {
  vpc_id = aws_vpc.frog.id

  tags = {
    Name = "frog-private"
  }
}

# route associations private
resource "aws_route_table_association" "frog-private-1-a" {
  subnet_id      = aws_subnet.frog-private-1.id
  route_table_id = aws_route_table.frog-private.id
}

resource "aws_route_table_association" "frog-private-2-a" {
  subnet_id      = aws_subnet.frog-private-2.id
  route_table_id = aws_route_table.frog-private.id
}

# ecs cluster
resource "aws_ecs_cluster" "frog" {
  name = "frog"
}
