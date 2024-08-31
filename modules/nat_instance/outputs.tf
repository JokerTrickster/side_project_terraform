
output "dev_common_nat_instnace_public_ip" {
  description = "The public IP of the NAT instance"
  value = aws_eip.dev_common_nat_instance_eip.public_ip
}

output "dev_common_nat_instance_id" {
  description = "The ID of the NAT instance"
  value = aws_instance.dev_common_nat_instance.id
} 

output "dev_common_nat_instance_network_interface_id" {
  description = "The ID of the NAT instance network interface"
  value = aws_instance.dev_common_nat_instance.primary_network_interface_id
}