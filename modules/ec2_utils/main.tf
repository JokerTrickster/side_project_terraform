module "ssm" {
  source      = "../ssm"
  dev_common_mysql_host = aws_eip.dev_common_utils_eip[0].public_ip
  dev_common_redis_host = aws_eip.dev_common_utils_eip[0].public_ip
}

resource "aws_security_group" "dev_common_utils_sg" {
  name        = "dev_common_utils_security_group"
  description = "Allow SSH access from all IPs"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH access from all IPs
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all TCP traffic from all IPs
  }
  // mysql port
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  // redis port
   ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev utils server Security Group"
  }
}

resource "aws_network_interface" "network_interface" {
  subnet_id   = var.subnet_ids[1]
  security_groups = [aws_security_group.dev_common_utils_sg.id]
  
  tags = {
    Name = "dev primary_network_interface"
  }
}

resource "aws_eip" "dev_common_utils_eip"{
  domain = "vpc"
  count = 1
  instance = aws_instance.dev_common_utils_instance.id
    tags = {
        Name = "dev_common_utils_eip"
    }
}
resource "aws_instance" "dev_common_utils_instance" {
  ami = "ami-0e4b1df799f55b8bb" //arm64
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0092
    }
  }
  key_name = var.key_name
  network_interface {
    network_interface_id         = aws_network_interface.network_interface.id
    device_index                 = 0
  }
  instance_type = "t4g.small"

  // /templates/user_data.sh
  user_data = file("${path.module}/templates/user_data.sh")

  tags = {
    Name = "dev_common_utils_spot"
  }
}


