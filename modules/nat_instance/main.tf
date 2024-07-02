module "vpc"{
    source = "../vpc"

    cidr = var.vpc_cidr
    environment = var.environment
}


//sg_nat_instance
resource "aws_security_group" "sg_nat_instance" {
    vpc_id = var.vpc_id
    name = "sg_nat_instance"

    tags = {
        Name = "sg_nat_instance"
    }
}

resource "aws_instance" "nat_instance" {
    ami = "ami-08074b02473276b92"
    instance_type = "t2.micro"
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
        Name = "nat_instance"
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
    cidr_blocks = [var.vpc_cidr]
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
    cidr_blocks = ["0.0.0.0/0"]
    description =  "Allow HTTP inbound traffic"
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