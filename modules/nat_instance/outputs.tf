
output "nat_instnace_public_ip" {
  description = "The public IP of the NAT instance"
  value = aws_eip.nat_instance_eip.public_ip
}

output "nat_instance_id" {
  description = "The ID of the NAT instance"
  value = aws_instance.nat_instance.id
} 

output "nat_instance_network_interface_id" {
  description = "The ID of the NAT instance network interface"
  value = aws_instance.nat_instance.primary_network_interface_id
}