output "frog-elb" {
  value = aws_elb.frog-elb.dns_name
}
