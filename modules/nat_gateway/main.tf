# Using the AWS NAT Gateway service instead of a nat instance, it's more expensive but easier
# See comparison http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-comparison.html

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(var.subnet_ids, count.index)
  count         = var.subnet_count
}

resource "aws_eip" "nat" {
  domain = "vpc"
  count = var.subnet_count

  tags = {
    Name        = "nat_eip_${count.index}"
  }
}