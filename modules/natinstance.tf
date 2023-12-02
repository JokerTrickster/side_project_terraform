resource "aws_network_interface" "frog_network_interface" {
  subnet_id   = aws_subnet.frog-public-1.id
  private_ips = ["10.15.21.220"]

  tags = {
    Name = "primary_network_interface"
  }
}

# NAT 인스턴스 생성
resource "aws_instance" "nat_instance" {
  ami           = var.AMIS[var.AWS_REGION]  # NAT 인스턴스 AMI ID를 설정합니다.
  instance_type = "t4g.micro"
  key_name      = aws_key_pair.mykeypair.key_name  # 키페어 이름을 설정합니다.

  # 여러 네트워크 인터페이스를 정의할 수 있습니다.
  network_interface {
    network_interface_id     = aws_network_interface.frog_network_interface.id
    device_index             = 0
  }

  tags = {
    Name = "frog-nat-instance"
  }
}

resource "aws_security_group" "nat_sg" {
  vpc_id      = aws_vpc.frog.id
  name        = "nat_security_group"
  description = "NAT instance security group"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "frog-nat-instance-sg"
  }
}
