
//sg_nat_instance
resource "aws_security_group" "sg_nat_instance" {
    vpc_id = var.vpc_id
    name = "sg_nat_instance"

    tags = {
        Name = "sg_nat_instance"
    }
}

resource "aws_instance" "nat_instance" {
    ami = "ami-01ad0c7a4930f0e43"
    instance_type = "t3.nano"
    instance_market_options {
      market_type = "spot"
      spot_options {
       max_price = 0.0092 
      }
      
    }
    vpc_security_group_ids = [aws_security_group.sg_nat_instance.id]
    subnet_id = var.public_subnets[0]
    associate_public_ip_address = true
    source_dest_check = false
    key_name = var.key_name

    root_block_device {
        volume_size = 8
        volume_type = "gp2"
        encrypted = true
    }
    tags = {
        Name = "nat_instance_spot"
    }
}

// attach eip to nat instance
resource "aws_eip" "nat_instance_eip" {
    instance = aws_instance.nat_instance.id

    tags = {
        Name = "nat_instance_eip"
    }
}

// sg_nat_instance rules inbound and outbound
resource "aws_security_group_rule" "sg_nat_instance_inbound" {
    security_group_id = aws_security_group.sg_nat_instance.id
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH inbound traffic"
}


resource "aws_security_group_rule" "private_subnet_inbound" {
    security_group_id = aws_security_group.sg_nat_instance.id
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow all inbound traffic from VPC"
}

resource "aws_security_group_rule" "sg_nat_instnace_inbound_http"{
    security_group_id = aws_security_group.sg_nat_instance.id
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description =  "Allow HTTP inbound traffic"
}

resource "aws_security_group_rule" "sg_nat_instance_inbound_https"{
    security_group_id = aws_security_group.sg_nat_instance.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow HTTPS inbound traffic"
}

//icmp
resource "aws_security_group_rule" "sg_nat_instance_inbound_icmp"{
    security_group_id = aws_security_group.sg_nat_instance.id
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow ICMP inbound traffic"
}

resource "aws_security_group_rule" "sg_nat_jnstance_outbound" {
    security_group_id = aws_security_group.sg_nat_instance.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
    }


resource "aws_network_interface" "primary_network_interface" {
    subnet_id = var.public_subnets[0]
    security_groups = [aws_security_group.sg_nat_instance.id]
    source_dest_check = false
    description = "Primary network interface for NAT instance"
    tags = {
        Name = "nat_instance"
    }
}