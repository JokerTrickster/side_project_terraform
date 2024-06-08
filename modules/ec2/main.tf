module "ssm" {
  source      = "../ssm"
  mysql_host = aws_eip.utils_eip[0].public_ip
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh_security_group"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}

resource "aws_network_interface" "network_interface" {
  subnet_id   = var.subnet_ids[0]
  security_groups = [aws_security_group.ssh_sg.id]
  
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_eip" "utils_eip"{
  domain = "vpc"
  count = 1
  instance = aws_instance.utils_instance.id
    tags = {
        Name = "utils-eip"
    }
}
resource "aws_instance" "utils_instance" {
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
    Name = "utils-spot"
  }
}


